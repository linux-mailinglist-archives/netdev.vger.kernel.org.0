Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9517E349105
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhCYLns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:43:48 -0400
Received: from outbound-smtp21.blacknight.com ([81.17.249.41]:59292 "EHLO
        outbound-smtp21.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230260AbhCYLnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:43:01 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp21.blacknight.com (Postfix) with ESMTPS id 115C7CCA7D
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:43:00 +0000 (GMT)
Received: (qmail 15945 invoked from network); 25 Mar 2021 11:42:59 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 25 Mar 2021 11:42:59 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 2/9] mm/page_alloc: Add a bulk page allocator
Date:   Thu, 25 Mar 2021 11:42:21 +0000
Message-Id: <20210325114228.27719-3-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325114228.27719-1-mgorman@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new page allocator interface via alloc_pages_bulk,
and __alloc_pages_bulk_nodemask. A caller requests a number of pages
to be allocated and added to a list.

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/gfp.h |  11 +++++
 mm/page_alloc.c     | 118 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0a88f84b08f4..4a304fd39916 100644
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8a3e13277e22..eb547470a7e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4965,6 +4965,124 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	return true;
 }
 
+/*
+ * __alloc_pages_bulk - Allocate a number of order-0 pages to a list
+ * @gfp: GFP flags for the allocation
+ * @preferred_nid: The preferred NUMA node ID to allocate from
+ * @nodemask: Set of nodes to allocate from, may be NULL
+ * @nr_pages: The number of pages desired on the list
+ * @page_list: List to store the allocated pages
+ *
+ * This is a batched version of the page allocator that attempts to
+ * allocate nr_pages quickly and add them to a list.
+ *
+ * Returns the number of pages on the list.
+ */
+int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
+			nodemask_t *nodemask, int nr_pages,
+			struct list_head *page_list)
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
+	/* Use the single page allocator for one page. */
+	if (nr_pages == 1)
+		goto failed;
+
+	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
+	gfp &= gfp_allowed_mask;
+	alloc_gfp = gfp;
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
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
+
+	/*
+	 * If there are no allowed local zones that meets the watermarks then
+	 * try to allocate a single page and reclaim if necessary.
+	 */
+	if (!zone)
+		goto failed;
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
+		/*
+		 * Ideally this would be batched but the best way to do
+		 * that cheaply is to first convert zone_statistics to
+		 * be inaccurate per-cpu counter like vm_events to avoid
+		 * a RMW cycle then do the accounting with IRQs enabled.
+		 */
+		__count_zid_vm_events(PGALLOC, zone_idx(zone), 1);
+		zone_statistics(ac.preferred_zoneref->zone, zone);
+
+		prep_new_page(page, 0, gfp, 0);
+		list_add(&page->lru, page_list);
+		allocated++;
+	}
+
+	local_irq_restore(flags);
+
+	return allocated;
+
+failed_irq:
+	local_irq_restore(flags);
+
+failed:
+	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
+	if (page) {
+		list_add(&page->lru, page_list);
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

