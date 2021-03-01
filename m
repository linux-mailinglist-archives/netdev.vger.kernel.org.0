Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A59C328399
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbhCAQWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:22:06 -0500
Received: from outbound-smtp15.blacknight.com ([46.22.139.232]:51211 "EHLO
        outbound-smtp15.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237752AbhCAQUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 11:20:25 -0500
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp15.blacknight.com (Postfix) with ESMTPS id 4FFA01C3CF2
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 16:12:02 +0000 (GMT)
Received: (qmail 30566 invoked from network); 1 Mar 2021 16:12:01 -0000
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
Subject: [PATCH 5/5] net: page_pool: use alloc_pages_bulk in refill code path
Date:   Mon,  1 Mar 2021 16:12:00 +0000
Message-Id: <20210301161200.18852-6-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301161200.18852-1-mgorman@techsingularity.net>
References: <20210301161200.18852-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

There are cases where the page_pool need to refill with pages from the
page allocator. Some workloads cause the page_pool to release pages
instead of recycling these pages.

For these workload it can improve performance to bulk alloc pages from
the page-allocator to refill the alloc cache.

For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
redirecting xdp_frame packets into a veth, that does XDP_PASS to create
an SKB from the xdp_frame, which then cannot return the page to the
page_pool. In this case, we saw[1] an improvement of 18.8% from using
the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 net/core/page_pool.c | 63 ++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a26f2ceb6a87..567680bd91c4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -208,44 +208,61 @@ noinline
 static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 						 gfp_t _gfp)
 {
+	const int bulk = PP_ALLOC_CACHE_REFILL;
+	struct page *page, *next, *first_page;
 	unsigned int pp_flags = pool->p.flags;
-	struct page *page;
+	unsigned int pp_order = pool->p.order;
+	int pp_nid = pool->p.nid;
+	LIST_HEAD(page_list);
 	gfp_t gfp = _gfp;
 
-	/* We could always set __GFP_COMP, and avoid this branch, as
-	 * prep_new_page() can handle order-0 with __GFP_COMP.
-	 */
-	if (pool->p.order)
+	/* Don't support bulk alloc for high-order pages */
+	if (unlikely(pp_order)) {
 		gfp |= __GFP_COMP;
+		first_page = alloc_pages_node(pp_nid, gfp, pp_order);
+		if (unlikely(!first_page))
+			return NULL;
+		goto out;
+	}
 
-	/* FUTURE development:
-	 *
-	 * Current slow-path essentially falls back to single page
-	 * allocations, which doesn't improve performance.  This code
-	 * need bulk allocation support from the page allocator code.
-	 */
-
-	/* Cache was empty, do real allocation */
-#ifdef CONFIG_NUMA
-	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
-#else
-	page = alloc_pages(gfp, pool->p.order);
-#endif
-	if (!page)
+	if (unlikely(!__alloc_pages_bulk_nodemask(gfp, pp_nid, NULL,
+						  bulk, &page_list)))
 		return NULL;
 
+	/* First page is extracted and returned to caller */
+	first_page = list_first_entry(&page_list, struct page, lru);
+	list_del(&first_page->lru);
+
+	/* Remaining pages store in alloc.cache */
+	list_for_each_entry_safe(page, next, &page_list, lru) {
+		list_del(&page->lru);
+		if (pp_flags & PP_FLAG_DMA_MAP &&
+		    unlikely(!page_pool_dma_map(pool, page))) {
+			put_page(page);
+			continue;
+		}
+		if (likely(pool->alloc.count < PP_ALLOC_CACHE_SIZE)) {
+			pool->alloc.cache[pool->alloc.count++] = page;
+			pool->pages_state_hold_cnt++;
+			trace_page_pool_state_hold(pool, page,
+						   pool->pages_state_hold_cnt);
+		} else {
+			put_page(page);
+		}
+	}
+out:
 	if (pp_flags & PP_FLAG_DMA_MAP &&
-	    unlikely(!page_pool_dma_map(pool, page))) {
-		put_page(page);
+	    unlikely(!page_pool_dma_map(pool, first_page))) {
+		put_page(first_page);
 		return NULL;
 	}
 
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
-	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
+	trace_page_pool_state_hold(pool, first_page, pool->pages_state_hold_cnt);
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
-	return page;
+	return first_page;
 }
 
 /* For using page_pool replace: alloc_pages() API calls, but provide
-- 
2.26.2

