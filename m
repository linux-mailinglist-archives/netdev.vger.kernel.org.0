Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1956363E31D
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiK3WIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiK3WII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9CB54341
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=PxWNL/tjWIqDR8XmqIe4fjWtjHmT3qk449W8d0uRXDw=; b=Jf9EssJPH91dkhQGtAiuZByQyl
        SiSWxm9XmF+KaYMP8Mk7os4pEdQHevU6YojFN+904UE4mworMT7euqzCDFQ7ehLmT48wGku0DLUok
        7Xybz1XXi3nozgkCSLRc6+EaW1hD6vNMHE+JoZ0bJC5tBvpTizBjBmdCZh4SQJge9yNUYVu6XZWR2
        O4+mUGzNRXVYBFIddb5EiPVzbX8DhL5U/s029f3eA+u3t8edltYVZkV6BsklTCM+5zeyey2B3qYRO
        uj1o9aSAU+MtV/pWVl1fS0BGg9hUJRT9s76MuKhaxokuqDX7uXvdOgPSw/BLx5iECga3/Hc/Y+E+U
        OuADfrsg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFN-00FLVY-Ju; Wed, 30 Nov 2022 22:08:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 12/24] page_pool: Convert page_pool_alloc_pages() to page_pool_alloc_netmem()
Date:   Wed, 30 Nov 2022 22:07:51 +0000
Message-Id: <20221130220803.3657490-13-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
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

Add a page_pool_alloc_pages() compatibility wrapper.  Also convert
__page_pool_alloc_pages_slow() to __page_pool_alloc_netmem_slow()
and __page_pool_alloc_page_order() to __page_pool_alloc_netmem().
__page_pool_get_cached() is converted to return a netmem.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h |  8 +++++++-
 net/core/page_pool.c    | 39 +++++++++++++++++++--------------------
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index db617073025e..4c730591de46 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -292,7 +292,13 @@ struct page_pool {
 	u64 destroy_cnt;
 };
 
-struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
+struct netmem *page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp);
+
+static inline
+struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
+{
+	return netmem_page(page_pool_alloc_netmem(pool, gfp));
+}
 
 static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 7a77e3220205..efe9f1471caa 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -282,7 +282,7 @@ static struct netmem *page_pool_refill_alloc_cache(struct page_pool *pool)
 }
 
 /* fast path */
-static struct page *__page_pool_get_cached(struct page_pool *pool)
+static struct netmem *__page_pool_get_cached(struct page_pool *pool)
 {
 	struct netmem *nmem;
 
@@ -295,7 +295,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 		nmem = page_pool_refill_alloc_cache(pool);
 	}
 
-	return netmem_page(nmem);
+	return nmem;
 }
 
 static void page_pool_dma_sync_for_device(struct page_pool *pool,
@@ -349,8 +349,8 @@ static void page_pool_clear_pp_info(struct netmem *nmem)
 	nmem->pp = NULL;
 }
 
-static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
-						 gfp_t gfp)
+static
+struct netmem *__page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp)
 {
 	struct netmem *nmem;
 
@@ -371,27 +371,27 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 	trace_page_pool_state_hold(pool, nmem, pool->pages_state_hold_cnt);
-	return netmem_page(nmem);
+	return nmem;
 }
 
 /* slow path */
 noinline
-static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
+static struct netmem *__page_pool_alloc_netmem_slow(struct page_pool *pool,
 						 gfp_t gfp)
 {
 	const int bulk = PP_ALLOC_CACHE_REFILL;
 	unsigned int pp_flags = pool->p.flags;
 	unsigned int pp_order = pool->p.order;
-	struct page *page;
+	struct netmem *nmem;
 	int i, nr_pages;
 
 	/* Don't support bulk alloc for high-order pages */
 	if (unlikely(pp_order))
-		return __page_pool_alloc_page_order(pool, gfp);
+		return __page_pool_alloc_netmem(pool, gfp);
 
 	/* Unnecessary as alloc cache is empty, but guarantees zero count */
 	if (unlikely(pool->alloc.count > 0))
-		return netmem_page(pool->alloc.cache[--pool->alloc.count]);
+		return pool->alloc.cache[--pool->alloc.count];
 
 	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
 	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
@@ -422,34 +422,33 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 
 	/* Return last page */
 	if (likely(pool->alloc.count > 0)) {
-		page = netmem_page(pool->alloc.cache[--pool->alloc.count]);
+		nmem = pool->alloc.cache[--pool->alloc.count];
 		alloc_stat_inc(pool, slow);
 	} else {
-		page = NULL;
+		nmem = NULL;
 	}
 
 	/* When page just allocated it should have refcnt 1 (but may have
 	 * speculative references) */
-	return page;
+	return nmem;
 }
 
 /* For using page_pool replace: alloc_pages() API calls, but provide
  * synchronization guarantee for allocation side.
  */
-struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
+struct netmem *page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp)
 {
-	struct page *page;
+	struct netmem *nmem;
 
 	/* Fast-path: Get a page from cache */
-	page = __page_pool_get_cached(pool);
-	if (page)
-		return page;
+	nmem = __page_pool_get_cached(pool);
+	if (nmem)
+		return nmem;
 
 	/* Slow-path: cache empty, do real allocation */
-	page = __page_pool_alloc_pages_slow(pool, gfp);
-	return page;
+	return __page_pool_alloc_netmem_slow(pool, gfp);
 }
-EXPORT_SYMBOL(page_pool_alloc_pages);
+EXPORT_SYMBOL(page_pool_alloc_netmem);
 
 /* Calculate distance between two u32 values, valid if distance is below 2^(31)
  *  https://en.wikipedia.org/wiki/Serial_number_arithmetic#General_Solution
-- 
2.35.1

