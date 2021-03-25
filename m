Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C33D349106
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhCYLnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:43:51 -0400
Received: from outbound-smtp54.blacknight.com ([46.22.136.238]:60445 "EHLO
        outbound-smtp54.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230481AbhCYLnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:43:12 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp54.blacknight.com (Postfix) with ESMTPS id 599F4FA822
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:43:10 +0000 (GMT)
Received: (qmail 16560 invoked from network); 25 Mar 2021 11:43:10 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 25 Mar 2021 11:43:10 -0000
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
Subject: [PATCH 3/9] mm/page_alloc: Add an array-based interface to the bulk page allocator
Date:   Thu, 25 Mar 2021 11:42:22 +0000
Message-Id: <20210325114228.27719-4-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325114228.27719-1-mgorman@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The proposed callers for the bulk allocator store pages from the bulk
allocator in an array. This patch adds an array-based interface to the API
to avoid multiple list iterations. The page list interface is preserved
to avoid requiring all users of the bulk API to allocate and manage enough
storage to store the pages.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 include/linux/gfp.h | 13 +++++++---
 mm/page_alloc.c     | 60 +++++++++++++++++++++++++++++++++------------
 2 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 4a304fd39916..fb6234e1fe59 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -520,13 +520,20 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 
 int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
-				struct list_head *list);
+				struct list_head *page_list,
+				struct page **page_array);
 
 /* Bulk allocate order-0 pages */
 static inline unsigned long
-alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
+alloc_pages_bulk_list(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
 {
-	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list, NULL);
+}
+
+static inline unsigned long
+alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
+{
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eb547470a7e4..be1e33a4df39 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4966,21 +4966,29 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 }
 
 /*
- * __alloc_pages_bulk - Allocate a number of order-0 pages to a list
+ * __alloc_pages_bulk - Allocate a number of order-0 pages to a list or array
  * @gfp: GFP flags for the allocation
  * @preferred_nid: The preferred NUMA node ID to allocate from
  * @nodemask: Set of nodes to allocate from, may be NULL
- * @nr_pages: The number of pages desired on the list
- * @page_list: List to store the allocated pages
+ * @nr_pages: The number of pages desired on the list or array
+ * @page_list: Optional list to store the allocated pages
+ * @page_array: Optional array to store the pages
  *
  * This is a batched version of the page allocator that attempts to
- * allocate nr_pages quickly and add them to a list.
+ * allocate nr_pages quickly. Pages are added to page_list if page_list
+ * is not NULL, otherwise it is assumed that the page_array is valid.
  *
- * Returns the number of pages on the list.
+ * For lists, nr_pages is the number of pages that should be allocated.
+ *
+ * For arrays, only NULL elements are populated with pages and nr_pages
+ * is the maximum number of pages that will be stored in the array.
+ *
+ * Returns the number of pages on the list or array.
  */
 int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			nodemask_t *nodemask, int nr_pages,
-			struct list_head *page_list)
+			struct list_head *page_list,
+			struct page **page_array)
 {
 	struct page *page;
 	unsigned long flags;
@@ -4991,13 +4999,20 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags;
-	int allocated = 0;
+	int nr_populated = 0;
 
 	if (WARN_ON_ONCE(nr_pages <= 0))
 		return 0;
 
+	/*
+	 * Skip populated array elements to determine if any pages need
+	 * to be allocated before disabling IRQs.
+	 */
+	while (page_array && page_array[nr_populated] && nr_populated < nr_pages)
+		nr_populated++;
+
 	/* Use the single page allocator for one page. */
-	if (nr_pages == 1)
+	if (nr_pages - nr_populated == 1)
 		goto failed;
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
@@ -5041,12 +5056,19 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	pcp_list = &pcp->lists[ac.migratetype];
 
-	while (allocated < nr_pages) {
+	while (nr_populated < nr_pages) {
+
+		/* Skip existing pages */
+		if (page_array && page_array[nr_populated]) {
+			nr_populated++;
+			continue;
+		}
+
 		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
 		if (!page) {
 			/* Try and get at least one page */
-			if (!allocated)
+			if (!nr_populated)
 				goto failed_irq;
 			break;
 		}
@@ -5061,13 +5083,16 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 		zone_statistics(ac.preferred_zoneref->zone, zone);
 
 		prep_new_page(page, 0, gfp, 0);
-		list_add(&page->lru, page_list);
-		allocated++;
+		if (page_list)
+			list_add(&page->lru, page_list);
+		else
+			page_array[nr_populated] = page;
+		nr_populated++;
 	}
 
 	local_irq_restore(flags);
 
-	return allocated;
+	return nr_populated;
 
 failed_irq:
 	local_irq_restore(flags);
@@ -5075,11 +5100,14 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 failed:
 	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
 	if (page) {
-		list_add(&page->lru, page_list);
-		allocated = 1;
+		if (page_list)
+			list_add(&page->lru, page_list);
+		else
+			page_array[nr_populated] = page;
+		nr_populated++;
 	}
 
-	return allocated;
+	return nr_populated;
 }
 EXPORT_SYMBOL_GPL(__alloc_pages_bulk);
 
-- 
2.26.2

