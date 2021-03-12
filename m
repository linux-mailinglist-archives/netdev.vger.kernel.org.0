Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38F23391A7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhCLPoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:44:06 -0500
Received: from outbound-smtp56.blacknight.com ([46.22.136.240]:56443 "EHLO
        outbound-smtp56.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231889AbhCLPnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:43:35 -0500
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp56.blacknight.com (Postfix) with ESMTPS id 574DBFB0B7
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 15:43:32 +0000 (GMT)
Received: (qmail 19821 invoked from network); 12 Mar 2021 15:43:32 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 12 Mar 2021 15:43:32 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 3/7] mm/page_alloc: Add a bulk page allocator
Date:   Fri, 12 Mar 2021 15:43:27 +0000
Message-Id: <20210312154331.32229-4-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312154331.32229-1-mgorman@techsingularity.net>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
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
 include/linux/gfp.h |  12 +++++
 mm/page_alloc.c     | 116 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0a88f84b08f4..e2cd98dba72e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -518,6 +518,17 @@ static inline int arch_make_page_accessible(struct page *page)
 struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 
+int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
+				nodemask_t *nodemask, int nr_pages,
+				struct list_head *list);
+
+/* Bulk allocate order-0 pages */
+static inline unsigned long
+alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
+{
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
+}
+
 /*
  * Allocate pages, preferring the node given as nid. The node must be valid and
  * online. For more general interface, see alloc_pages_node().
@@ -581,6 +592,7 @@ void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+extern void free_pages_bulk(struct list_head *list);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 880b1d6368bd..f48f94375b66 100644
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
@@ -4963,6 +4978,107 @@ static inline bool prepare_alloc_pages(gfp_t gfp, unsigned int order,
 	return true;
 }
 
+/*
+ * This is a batched version of the page allocator that attempts to
+ * allocate nr_pages quickly from the preferred zone and add them to list.
+ *
+ * Returns the number of pages allocated.
+ */
+int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
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
+	gfp_t alloc_gfp;
+	unsigned int alloc_flags;
+	int allocated = 0;
+
+	if (WARN_ON_ONCE(nr_pages <= 0))
+		return 0;
+
+	if (nr_pages == 1)
+		goto failed;
+
+	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac,
+	&alloc_gfp, &alloc_flags))
+		return 0;
+	gfp = alloc_gfp;
+
+	/* Find an allowed local zone that meets the high watermark. */
+	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
+		unsigned long mark;
+
+		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp)) {
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
+				alloc_flags, gfp)) {
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
+	while (allocated < nr_pages) {
+		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
+								pcp, pcp_list);
+		if (!page) {
+			/* Try and get at least one page */
+			if (!allocated)
+				goto failed_irq;
+			break;
+		}
+
+		list_add(&page->lru, alloc_list);
+		allocated++;
+	}
+
+	__count_zid_vm_events(PGALLOC, zone_idx(zone), allocated);
+	zone_statistics(zone, zone);
+
+	local_irq_restore(flags);
+
+	/* Prep page with IRQs enabled to reduce disabled times */
+	list_for_each_entry(page, alloc_list, lru)
+		prep_new_page(page, 0, gfp, 0);
+
+	return allocated;
+
+failed_irq:
+	local_irq_restore(flags);
+
+failed:
+	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
+	if (page) {
+		list_add(&page->lru, alloc_list);
+		allocated = 1;
+	}
+
+	return allocated;
+}
+EXPORT_SYMBOL_GPL(__alloc_pages_bulk);
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-- 
2.26.2

