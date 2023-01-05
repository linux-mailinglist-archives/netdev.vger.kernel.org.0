Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB7865F610
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbjAEVqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbjAEVq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DBD63F58
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=E09t+hkiAU+x+XiPYonyux6Fp0qlpaeqrtoR4FA5S+c=; b=rw7xh7p0TjYLAaPOaEupk3tOPt
        NDSRcqv5GjpfzNYdVhFTxq01vywHFyZYSzkoEF4YFw08ADYsHl8+fs9gQ/QJ/PYSr5HT9YosjQOMq
        Zuesj3Ju4EdAPiQfgvy7Hyj6QJZascVjhebd9Po7QRaZE0auC1255M/LE5cng9YKIATtrI2UsEBcx
        yLQjVzblxp7/5vli/L/bE8opuJR9N7W4LOddMgh1Y8pSeu4MxgUvagJ5npC0J+r7oVXdrKMPwwHRX
        Q+wpviR08yhoayANvaUgG1YTP8h9GI/gB/Kq6SzxX3PLbVU0s1pMe3qi++l4zV/ht5ga0PAsp9uJS
        QYO4GNkw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4I-00GWnV-A2; Thu, 05 Jan 2023 21:46:34 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 12/24] page_pool: Convert page_pool_alloc_pages() to page_pool_alloc_netmem()
Date:   Thu,  5 Jan 2023 21:46:19 +0000
Message-Id: <20230105214631.3939268-13-willy@infradead.org>
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

Add wrappers for page_pool_alloc_pages() and
page_pool_dev_alloc_netmem().  Also convert __page_pool_alloc_pages_slow()
to __page_pool_alloc_netmem_slow() and __page_pool_alloc_page_order()
to __page_pool_alloc_netmem().  __page_pool_get_cached() now returns
a netmem.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 13 ++++++++++++-
 net/core/page_pool.c    | 39 +++++++++++++++++++--------------------
 2 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 8b826da3b8b0..fbb653c9f1da 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -314,7 +314,18 @@ struct page_pool {
 	u64 destroy_cnt;
 };
 
-struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
+struct netmem *page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp);
+
+static inline struct netmem *page_pool_dev_alloc_netmem(struct page_pool *pool)
+{
+	return page_pool_alloc_netmem(pool, GFP_ATOMIC | __GFP_NOWARN);
+}
+
+static inline
+struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
+{
+	return netmem_page(page_pool_alloc_netmem(pool, gfp));
+}
 
 static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 0212244e07e7..c7ea487acbaa 100644
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

