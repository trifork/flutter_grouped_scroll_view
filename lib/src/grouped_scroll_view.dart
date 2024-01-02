import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'dart:math' as math;

import 'options/grouped_scroll_view_options.dart';

int kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

typedef HeaderBuilder = Widget Function(BuildContext context);
typedef FooterBuilder = Widget Function(BuildContext context);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef ItemAtIndex<T> = void Function(int index, int total, int groupedIndex);

@immutable
class GroupedScrollView<T, H> extends StatelessWidget {
  /// Data. Either a [List<T>] of items that will be grouped by
  /// [groupedOptions.itemGrouper] or a [Map<H,List<T>>] of pre-grouped
  /// items.
  final dynamic data;

  /// Header
  final HeaderBuilder? headerBuilder;

  /// Footer
  final FooterBuilder? footerBuilder;

  /// Optional [Function] that helps sort the groups by comparing the [T] items.
  final Comparator<T>? itemsSorter;

  /// itemBuilder
  final ItemBuilder<T> itemBuilder;

  /// ItemAtIndex
  final ItemAtIndex? itemAtIndex;

  /// The delegate that controls the size and position of the children.
  final SliverGridDelegate? gridDelegate;

  /// findChildIndexCallback for [SliverChildBuilderDelegate].
  final ChildIndexGetter? findChildIndexCallback;

  /// AutomaticKeepAlive for [SliverChildBuilderDelegate].
  final bool addAutomaticKeepAlives;

  /// addRepaintBoundaries for [SliverChildBuilderDelegate].
  final bool addRepaintBoundaries;

  /// addSemanticIndexes for [SliverChildBuilderDelegate].
  final bool addSemanticIndexes;

  /// semanticIndexOffset for [SliverChildBuilderDelegate].
  final int semanticIndexOffset;

  /// semanticIndexCallback for [SliverChildBuilderDelegate].
  final SemanticIndexCallback semanticIndexCallback;

  /// scrollDirection for [CustomScrollView]
  final Axis scrollDirection;

  /// reverse for [CustomScrollView]
  final bool reverse;

  /// controller for [CustomScrollView]
  final ScrollController? scrollController;

  /// primary for [CustomScrollView]
  final bool? primary;

  /// physics for [CustomScrollView]
  final ScrollPhysics? physics;

  /// scrollBehavior for [CustomScrollView]
  final ScrollBehavior? scrollBehavior;

  /// shrinkWrap for [CustomScrollView]
  final bool shrinkWrap;

  /// center for [CustomScrollView]
  final Key? center;

  /// anchor for [CustomScrollView]
  final double anchor;

  /// cacheExtent for [CustomScrollView]
  final double? cacheExtent;

  /// semanticChildCount for [CustomScrollView]
  final int? semanticChildCount;

  /// dragStartBehavior for [CustomScrollView]
  final DragStartBehavior dragStartBehavior;

  /// keyboardDismissBehavior for [CustomScrollView]
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// restorationId for [CustomScrollView]
  final String? restorationId;

  /// clipBehavior for [CustomScrollView]
  final Clip clipBehavior;

  /// separatorBuilder for [List]
  final IndexedWidgetBuilder? separatorBuilder;

  /// Grouped by groupedOptions.
  final GroupedScrollViewOptions<T, H>? groupedOptions;

  const GroupedScrollView({
    super.key,
    required this.data,
    this.headerBuilder,
    this.footerBuilder,
    required this.itemBuilder,
    this.itemAtIndex,
    this.itemsSorter,

    /// grid
    this.gridDelegate,

    /// list
    this.separatorBuilder,

    /// grouped
    this.groupedOptions,

    /// SliverChildBuilderDelegate
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,

    /// CustomScrollView
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });

  const GroupedScrollView.grid({
    super.key,
    required this.data,
    required this.itemBuilder,
    required this.gridDelegate,
    this.headerBuilder,
    this.footerBuilder,
    this.itemsSorter,
    this.itemAtIndex,

    /// grouped
    this.groupedOptions,

    /// SliverChildBuilderDelegate
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,

    /// CustomScrollView
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : separatorBuilder = null;

  const GroupedScrollView.list({
    super.key,
    required this.data,
    required this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.itemsSorter,
    this.itemAtIndex,
    this.separatorBuilder,

    /// grouped
    this.groupedOptions,

    /// SliverChildBuilderDelegate
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,

    /// CustomScrollView
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : gridDelegate = null;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: scrollController,
      primary: primary,
      physics: physics,
      scrollBehavior: scrollBehavior,
      shrinkWrap: shrinkWrap,
      center: center,
      anchor: anchor,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      slivers: null != groupedOptions
          ? _buildGroupMode(context)
          : _buildNormalMode(context),
    );
  }

  List<Widget> _buildNormalMode(BuildContext context) {
    if (itemsSorter != null) {
      data.sort(itemsSorter);
    }
    List<Widget> section = [];
    if (null != headerBuilder) {
      section.add(SliverToBoxAdapter(child: headerBuilder!(context)));
    }
    section.add(null != gridDelegate
        ? SliverGrid(
            delegate: _buildSliverChildDelegate(data, 0),
            gridDelegate: gridDelegate!)
        : SliverList(delegate: _buildSliverChildDelegate(data, 0)));
    if (null != footerBuilder) {
      section.add(SliverToBoxAdapter(
        child: footerBuilder!(context),
      ));
    }
    return section;
  }

  List<Widget> _buildGroupMode(BuildContext context) {
    final options = groupedOptions!;
    List<Widget> slivers = [];
    Map<H, List<T>> groupItems;
    if (data is List<T>) {
      if (options.itemGrouper != null) {
        groupItems = groupBy(data, options.itemGrouper!);
      } else {
        throw Exception(
            'You must provide an itemGrouper function to group the items.');
      }
    } else {
      groupItems = data;
    }
    List<H> keys = groupItems.keys.toList();
    if (options.stickyHeaderSorter != null) {
      keys.sort(options.stickyHeaderSorter);
    }
    final groups = keys.length;
    for (var i = 0; i < groups; i++) {
      H header = keys[i];
      List<T> items = groupItems[header]!;
      if (itemsSorter != null) {
        items.sort(itemsSorter);
      }
      List<Widget> section = [];
      if (0 == i && null != headerBuilder) section.add(headerBuilder!(context));
      section.add(SliverPinnedHeader(
        child: options.stickyHeaderBuilder(context, header, i),
      ));
      section.add(null != gridDelegate
          ? SliverGrid(
              delegate: _buildSliverChildDelegate(items, i),
              gridDelegate: gridDelegate!)
          : SliverList(delegate: _buildSliverChildDelegate(items, i)));
      if (options.sectionFooterBuilder != null) {
        section.add(options.sectionFooterBuilder!(context, header, i));
      }
      if (groups - 1 == i && null != footerBuilder) {
        section.add(footerBuilder!(context));
      }
      slivers.add(
          MultiSliver(key: key, pushPinnedChildren: true, children: section));
    }
    return slivers;
  }

  SliverChildBuilderDelegate _buildSliverChildDelegate(
      List<T> items, int groupedIndex) {
    return SliverChildBuilderDelegate(
        (context, idx) =>
            _sliverChildBuilder(context, idx, items, groupedIndex),
        addRepaintBoundaries: addRepaintBoundaries,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addSemanticIndexes: addSemanticIndexes,
        findChildIndexCallback: findChildIndexCallback,
        semanticIndexOffset: semanticIndexOffset,
        semanticIndexCallback: semanticIndexCallback,
        childCount: _isHasListSeparatorBuilder()
            ? _computeActualChildCount(items.length)
            : items.length);
  }

  // Helper method to compute the actual child count for the separated constructor.
  static int _computeActualChildCount(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }

  bool _isHasListSeparatorBuilder() {
    return null == gridDelegate && null != separatorBuilder;
  }

  Widget _sliverChildBuilder(
      BuildContext context, int index, List<T> items, int groupedIndex) {
    if (_isHasListSeparatorBuilder()) {
      final int itemIndex = index ~/ 2;
      if (index.isEven) {
        if (null != itemAtIndex) {
          itemAtIndex!(itemIndex, items.length, groupedIndex);
        }
        return itemBuilder(context, items[itemIndex]);
      }
      return separatorBuilder!(context, itemIndex);
    }
    if (null != itemAtIndex) itemAtIndex!(index, items.length, groupedIndex);
    return itemBuilder(context, items[index]);
  }
}
