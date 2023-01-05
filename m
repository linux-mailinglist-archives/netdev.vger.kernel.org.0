Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B48865F60F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbjAEVqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbjAEVq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DFB671B1
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=w47n6MmGiQALv1tQiyKVrkQG4HjPnS/MkMXrWJAcNmM=; b=DSlYKKAKDmrsrfzfoGNdgfJJwk
        oqHPnyWdTlLYbuCqzlxSE7XFl150cU0bRikDE8+65rxX254tq4RHLKNQ/EzcVyjAa96FGqHUXTVWm
        sYD3vELTBXNQtKBMPh67irhZhe4ri77E/KVRJD7QTD0BpQ4wh9vo55wfOoI+UacOT4AVUiun4AVgk
        U9DykfxmvUmear3AHzxtLhOF18tL6R5sSpaNkP0bhu8eq/IVxqVtjvOZpU/EAt1cnHlbxIY4jHnww
        GgcRPMv6Ndyx1K7AZVreBU0bpHgAZ/f+JhjxuXouyp3H7JJZXgJ3PmpqJrkfXJx78X3rWcBXveSKt
        X9P1dH0w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4H-00GWn9-T3; Thu, 05 Jan 2023 21:46:33 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 08/24] page_pool: Convert pp_alloc_cache to contain netmem
Date:   Thu,  5 Jan 2023 21:46:15 +0000
Message-Id: <20230105214631.3939268-9-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230105214631.3939268-1-willy@infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the type here from page to netmem.  It works out well to
convert page_pool_refill_alloc_cache() to return a netmem instead
of a page as part of this commit.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h |  2 +-
 net/core/page_pool.c    | 52 ++++++++++++++++++++---------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 480baa22bc50..63aa530922de 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -173,7 +173,7 @@ static inline bool netmem_is_pfmemalloc(const struct netmem *nmem)
 #define PP_ALLOC_CACHE_REFILL	64
 struct pp_alloc_cache {
 	u32 count;
-	struct page *cache[PP_ALLOC_CACHE_SIZE];
+	struct netmem *cache[PP_ALLOC_CACHE_SIZE];
 };
 
 struct page_pool_params {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 8f3f7cc5a2d5..c54217ce6b77 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -229,10 +229,10 @@ void page_pool_return_page(struct page_pool *pool, struct page *page)
 }
 
 noinline
-static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
+static struct netmem *page_pool_refill_alloc_cache(struct page_pool *pool)
 {
 	struct ptr_ring *r = &pool->ring;
-	struct page *page;
+	struct netmem *nmem;
 	int pref_nid; /* preferred NUMA node */
 
 	/* Quicker fallback, avoid locks when ring is empty */
@@ -253,49 +253,49 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 
 	/* Refill alloc array, but only if NUMA match */
 	do {
-		page = __ptr_ring_consume(r);
-		if (unlikely(!page))
+		nmem = __ptr_ring_consume(r);
+		if (unlikely(!nmem))
 			break;
 
-		if (likely(page_to_nid(page) == pref_nid)) {
-			pool->alloc.cache[pool->alloc.count++] = page;
+		if (likely(netmem_nid(nmem) == pref_nid)) {
+			pool->alloc.cache[pool->alloc.count++] = nmem;
 		} else {
 			/* NUMA mismatch;
 			 * (1) release 1 page to page-allocator and
 			 * (2) break out to fallthrough to alloc_pages_node.
 			 * This limit stress on page buddy alloactor.
 			 */
-			page_pool_return_page(pool, page);
+			page_pool_return_netmem(pool, nmem);
 			alloc_stat_inc(pool, waive);
-			page = NULL;
+			nmem = NULL;
 			break;
 		}
 	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
 
 	/* Return last page */
 	if (likely(pool->alloc.count > 0)) {
-		page = pool->alloc.cache[--pool->alloc.count];
+		nmem = pool->alloc.cache[--pool->alloc.count];
 		alloc_stat_inc(pool, refill);
 	}
 
-	return page;
+	return nmem;
 }
 
 /* fast path */
 static struct page *__page_pool_get_cached(struct page_pool *pool)
 {
-	struct page *page;
+	struct netmem *nmem;
 
 	/* Caller MUST guarantee safe non-concurrent access, e.g. softirq */
 	if (likely(pool->alloc.count)) {
 		/* Fast-path */
-		page = pool->alloc.cache[--pool->alloc.count];
+		nmem = pool->alloc.cache[--pool->alloc.count];
 		alloc_stat_inc(pool, fast);
 	} else {
-		page = page_pool_refill_alloc_cache(pool);
+		nmem = page_pool_refill_alloc_cache(pool);
 	}
 
-	return page;
+	return netmem_page(nmem);
 }
 
 static void page_pool_dma_sync_for_device(struct page_pool *pool,
@@ -391,13 +391,13 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 
 	/* Unnecessary as alloc cache is empty, but guarantees zero count */
 	if (unlikely(pool->alloc.count > 0))
-		return pool->alloc.cache[--pool->alloc.count];
+		return netmem_page(pool->alloc.cache[--pool->alloc.count]);
 
 	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
 	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
 
 	nr_pages = alloc_pages_bulk_array_node(gfp, pool->p.nid, bulk,
-					       pool->alloc.cache);
+					(struct page **)pool->alloc.cache);
 	if (unlikely(!nr_pages))
 		return NULL;
 
@@ -405,7 +405,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	 * page element have not been (possibly) DMA mapped.
 	 */
 	for (i = 0; i < nr_pages; i++) {
-		struct netmem *nmem = page_netmem(pool->alloc.cache[i]);
+		struct netmem *nmem = pool->alloc.cache[i];
 		if ((pp_flags & PP_FLAG_DMA_MAP) &&
 		    unlikely(!page_pool_dma_map(pool, nmem))) {
 			netmem_put(nmem);
@@ -413,7 +413,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		}
 
 		page_pool_set_pp_info(pool, nmem);
-		pool->alloc.cache[pool->alloc.count++] = netmem_page(nmem);
+		pool->alloc.cache[pool->alloc.count++] = nmem;
 		/* Track how many pages are held 'in-flight' */
 		pool->pages_state_hold_cnt++;
 		trace_page_pool_state_hold(pool, nmem,
@@ -422,7 +422,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 
 	/* Return last page */
 	if (likely(pool->alloc.count > 0)) {
-		page = pool->alloc.cache[--pool->alloc.count];
+		page = netmem_page(pool->alloc.cache[--pool->alloc.count]);
 		alloc_stat_inc(pool, slow);
 	} else {
 		page = NULL;
@@ -547,7 +547,7 @@ static bool page_pool_recycle_in_cache(struct page *page,
 	}
 
 	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
-	pool->alloc.cache[pool->alloc.count++] = page;
+	pool->alloc.cache[pool->alloc.count++] = page_netmem(page);
 	recycle_stat_inc(pool, cached);
 	return true;
 }
@@ -785,7 +785,7 @@ static void page_pool_free(struct page_pool *pool)
 
 static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 {
-	struct page *page;
+	struct netmem *nmem;
 
 	if (pool->destroy_cnt)
 		return;
@@ -795,8 +795,8 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 	 * call concurrently.
 	 */
 	while (pool->alloc.count) {
-		page = pool->alloc.cache[--pool->alloc.count];
-		page_pool_return_page(pool, page);
+		nmem = pool->alloc.cache[--pool->alloc.count];
+		page_pool_return_netmem(pool, nmem);
 	}
 }
 
@@ -878,15 +878,15 @@ EXPORT_SYMBOL(page_pool_destroy);
 /* Caller must provide appropriate safe context, e.g. NAPI. */
 void page_pool_update_nid(struct page_pool *pool, int new_nid)
 {
-	struct page *page;
+	struct netmem *nmem;
 
 	trace_page_pool_update_nid(pool, new_nid);
 	pool->p.nid = new_nid;
 
 	/* Flush pool alloc cache, as refill will check NUMA node */
 	while (pool->alloc.count) {
-		page = pool->alloc.cache[--pool->alloc.count];
-		page_pool_return_page(pool, page);
+		nmem = pool->alloc.cache[--pool->alloc.count];
+		page_pool_return_netmem(pool, nmem);
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
-- 
2.35.1

