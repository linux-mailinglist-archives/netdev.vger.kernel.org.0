Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC5434911D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhCYLos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:44:48 -0400
Received: from outbound-smtp14.blacknight.com ([46.22.139.231]:38253 "EHLO
        outbound-smtp14.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231395AbhCYLoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:44:16 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp14.blacknight.com (Postfix) with ESMTPS id CC63A1C314E
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:44:11 +0000 (GMT)
Received: (qmail 20297 invoked from network); 25 Mar 2021 11:44:11 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 25 Mar 2021 11:44:11 -0000
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
Subject: [PATCH 9/9] net: page_pool: use alloc_pages_bulk in refill code path
Date:   Thu, 25 Mar 2021 11:42:28 +0000
Message-Id: <20210325114228.27719-10-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325114228.27719-1-mgorman@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
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
page_pool.

Performance results under GitHub xdp-project[1]:
 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org

Mel: The patch "net: page_pool: convert to use alloc_pages_bulk_array
variant" was squashed with this patch. From the test page, the array
variant was superior with one of the test results as follows.

	Kernel		XDP stats       CPU     pps           Delta
	Baseline	XDP-RX CPU      total   3,771,046       n/a
	List		XDP-RX CPU      total   3,940,242    +4.49%
	Array		XDP-RX CPU      total   4,249,224   +12.68%

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 include/net/page_pool.h |  2 +-
 net/core/page_pool.c    | 82 ++++++++++++++++++++++++++++-------------
 2 files changed, 57 insertions(+), 27 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b5b195305346..6d517a37c18b 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -65,7 +65,7 @@
 #define PP_ALLOC_CACHE_REFILL	64
 struct pp_alloc_cache {
 	u32 count;
-	void *cache[PP_ALLOC_CACHE_SIZE];
+	struct page *cache[PP_ALLOC_CACHE_SIZE];
 };
 
 struct page_pool_params {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 40e1b2beaa6c..9ec1aa9640ad 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -203,38 +203,17 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	return true;
 }
 
-/* slow path */
-noinline
-static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
-						 gfp_t _gfp)
+static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
+						 gfp_t gfp)
 {
-	unsigned int pp_flags = pool->p.flags;
 	struct page *page;
-	gfp_t gfp = _gfp;
-
-	/* We could always set __GFP_COMP, and avoid this branch, as
-	 * prep_new_page() can handle order-0 with __GFP_COMP.
-	 */
-	if (pool->p.order)
-		gfp |= __GFP_COMP;
-
-	/* FUTURE development:
-	 *
-	 * Current slow-path essentially falls back to single page
-	 * allocations, which doesn't improve performance.  This code
-	 * need bulk allocation support from the page allocator code.
-	 */
 
-	/* Cache was empty, do real allocation */
-#ifdef CONFIG_NUMA
+	gfp |= __GFP_COMP;
 	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
-#else
-	page = alloc_pages(gfp, pool->p.order);
-#endif
-	if (!page)
+	if (unlikely(!page))
 		return NULL;
 
-	if ((pp_flags & PP_FLAG_DMA_MAP) &&
+	if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
 	    unlikely(!page_pool_dma_map(pool, page))) {
 		put_page(page);
 		return NULL;
@@ -243,6 +222,57 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
+	return page;
+}
+
+/* slow path */
+noinline
+static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
+						 gfp_t gfp)
+{
+	const int bulk = PP_ALLOC_CACHE_REFILL;
+	unsigned int pp_flags = pool->p.flags;
+	unsigned int pp_order = pool->p.order;
+	struct page *page;
+	int i, nr_pages;
+
+	/* Don't support bulk alloc for high-order pages */
+	if (unlikely(pp_order))
+		return __page_pool_alloc_page_order(pool, gfp);
+
+	/* Unnecessary as alloc cache is empty, but guarantees zero count */
+	if (unlikely(pool->alloc.count > 0))
+		return pool->alloc.cache[--pool->alloc.count];
+
+	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
+	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
+
+	nr_pages = alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
+	if (unlikely(!nr_pages))
+		return NULL;
+
+	/* Pages have been filled into alloc.cache array, but count is zero and
+	 * page element have not been (possibly) DMA mapped.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		page = pool->alloc.cache[i];
+		if ((pp_flags & PP_FLAG_DMA_MAP) &&
+		    unlikely(!page_pool_dma_map(pool, page))) {
+			put_page(page);
+			continue;
+		}
+		pool->alloc.cache[pool->alloc.count++] = page;
+		/* Track how many pages are held 'in-flight' */
+		pool->pages_state_hold_cnt++;
+		trace_page_pool_state_hold(pool, page,
+					   pool->pages_state_hold_cnt);
+	}
+
+	/* Return last page */
+	if (likely(pool->alloc.count > 0))
+		page = pool->alloc.cache[--pool->alloc.count];
+	else
+		page = NULL;
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
-- 
2.26.2

