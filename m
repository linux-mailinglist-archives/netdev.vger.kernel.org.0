Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7706D32834D
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbhCAQPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:15:13 -0500
Received: from outbound-smtp61.blacknight.com ([46.22.136.249]:52741 "EHLO
        outbound-smtp61.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237668AbhCAQNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 11:13:12 -0500
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp61.blacknight.com (Postfix) with ESMTPS id B3025FA92E
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 16:12:01 +0000 (GMT)
Received: (qmail 30477 invoked from network); 1 Mar 2021 16:12:01 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 1 Mar 2021 16:12:01 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Date:   Mon,  1 Mar 2021 16:11:57 +0000
Message-Id: <20210301161200.18852-3-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301161200.18852-1-mgorman@techsingularity.net>
References: <20210301161200.18852-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new page allocator interface via alloc_pages_bulk,
and __alloc_pages_bulk_nodemask. A caller requests a number of pages
to be allocated and added to a list. They can be freed in bulk using
free_pages_bulk().

The API is not guaranteed to return the requested number of pages and
may fail if the preferred allocation zone has limited free memory, the
cpuset changes during the allocation or page debugging decides to fail
an allocation. It's up to the caller to request more pages in batch
if necessary.

Note that this implementation is not very efficient and could be improved
but it would require refactoring. The intent is to make it available early
to determine what semantics are required by different callers. Once the
full semantics are nailed down, it can be refactored.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 include/linux/gfp.h |  13 +++++
 mm/page_alloc.c     | 113 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 124 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 8572a1474e16..4903d1cc48dc 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -515,6 +515,10 @@ static inline int arch_make_page_accessible(struct page *page)
 }
 #endif
 
+int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
+				nodemask_t *nodemask, int nr_pages,
+				struct list_head *list);
+
 struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
 							nodemask_t *nodemask);
@@ -525,6 +529,14 @@ __alloc_pages(gfp_t gfp_mask, unsigned int order, int preferred_nid)
 	return __alloc_pages_nodemask(gfp_mask, order, preferred_nid, NULL);
 }
 
+/* Bulk allocate order-0 pages */
+static inline unsigned long
+alloc_pages_bulk(gfp_t gfp_mask, unsigned long nr_pages, struct list_head *list)
+{
+	return __alloc_pages_bulk_nodemask(gfp_mask, numa_mem_id(), NULL,
+							nr_pages, list);
+}
+
 /*
  * Allocate pages, preferring the node given as nid. The node must be valid and
  * online. For more general interface, see alloc_pages_node().
@@ -594,6 +606,7 @@ void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+extern void free_pages_bulk(struct list_head *list);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3e4b29ee2b1e..ff1e55793786 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4436,6 +4436,21 @@ static void wake_all_kswapds(unsigned int order, gfp_t gfp_mask,
 	}
 }
 
+/* Drop reference counts and free order-0 pages from a list. */
+void free_pages_bulk(struct list_head *list)
+{
+	struct page *page, *next;
+
+	list_for_each_entry_safe(page, next, list, lru) {
+		trace_mm_page_free_batched(page);
+		if (put_page_testzero(page)) {
+			list_del(&page->lru);
+			__free_pages_ok(page, 0, FPI_NONE);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(free_pages_bulk);
+
 static inline unsigned int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
@@ -4919,6 +4934,9 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		struct alloc_context *ac, gfp_t *alloc_mask,
 		unsigned int *alloc_flags)
 {
+	gfp_mask &= gfp_allowed_mask;
+	*alloc_mask = gfp_mask;
+
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
 	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
 	ac->nodemask = nodemask;
@@ -4960,6 +4978,99 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	return true;
 }
 
+/*
+ * This is a batched version of the page allocator that attempts to
+ * allocate nr_pages quickly from the preferred zone and add them to list.
+ */
+int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
+			nodemask_t *nodemask, int nr_pages,
+			struct list_head *alloc_list)
+{
+	struct page *page;
+	unsigned long flags;
+	struct zone *zone;
+	struct zoneref *z;
+	struct per_cpu_pages *pcp;
+	struct list_head *pcp_list;
+	struct alloc_context ac;
+	gfp_t alloc_mask;
+	unsigned int alloc_flags;
+	int alloced = 0;
+
+	if (nr_pages == 1)
+		goto failed;
+
+	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
+	if (!prepare_alloc_pages(gfp_mask, 0, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
+		return 0;
+	gfp_mask = alloc_mask;
+
+	/* Find an allowed local zone that meets the high watermark. */
+	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
+		unsigned long mark;
+
+		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp_mask)) {
+			continue;
+		}
+
+		if (nr_online_nodes > 1 && zone != ac.preferred_zoneref->zone &&
+		    zone_to_nid(zone) != zone_to_nid(ac.preferred_zoneref->zone)) {
+			goto failed;
+		}
+
+		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
+		if (zone_watermark_fast(zone, 0,  mark,
+				zonelist_zone_idx(ac.preferred_zoneref),
+				alloc_flags, gfp_mask)) {
+			break;
+		}
+	}
+	if (!zone)
+		return 0;
+
+	/* Attempt the batch allocation */
+	local_irq_save(flags);
+	pcp = &this_cpu_ptr(zone->pageset)->pcp;
+	pcp_list = &pcp->lists[ac.migratetype];
+
+	while (alloced < nr_pages) {
+		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
+								pcp, pcp_list);
+		if (!page)
+			break;
+
+		prep_new_page(page, 0, gfp_mask, 0);
+		list_add(&page->lru, alloc_list);
+		alloced++;
+	}
+
+	if (!alloced)
+		goto failed_irq;
+
+	if (alloced) {
+		__count_zid_vm_events(PGALLOC, zone_idx(zone), alloced);
+		zone_statistics(zone, zone);
+	}
+
+	local_irq_restore(flags);
+
+	return alloced;
+
+failed_irq:
+	local_irq_restore(flags);
+
+failed:
+	page = __alloc_pages_nodemask(gfp_mask, 0, preferred_nid, nodemask);
+	if (page) {
+		alloced++;
+		list_add(&page->lru, alloc_list);
+	}
+
+	return alloced;
+}
+EXPORT_SYMBOL_GPL(__alloc_pages_bulk_nodemask);
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
@@ -4981,8 +5092,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
 		return NULL;
 	}
 
-	gfp_mask &= gfp_allowed_mask;
-	alloc_mask = gfp_mask;
 	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
 		return NULL;
 
-- 
2.26.2

