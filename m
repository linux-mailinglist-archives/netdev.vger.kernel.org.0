Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497E563E30F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiK3WID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiK3WIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A65E52163
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WPw43D2FWQN3SSgISxsX8XwX/rXccr8Gt85IFRnjKRs=; b=PJ6YQTlsLPGTHZ66bVvy2i2V6s
        mXq9ZVtLGmN4XqbaXiYbhdcAoIIbHth8W8eaGScdYkIuotJgZnqMKZzf0u3A3kViUxtEkOTZylGYn
        oV9v9DH0aoVvOTmuNDZrYWPQyCM3l97C5BkFJctrwoNnoEAaaforfKu3shdkNOnN3aZXYUGipC2Fu
        X/IFiXc3BntzVRSkW1UFK0C/wL0vdhhHVMINMErtvs7ZZ8GMpGqdzDAE9aiFjoHJM3myhmh3fxNYF
        Ie55w7znDVfhYJDHc6mslqjVv0nll9C6cuceJbvZJMlPVUBn311TRFXDIEJ56j2x5GKcxnn1nizd5
        xAUSkbJQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFO-00FLVt-3Z; Wed, 30 Nov 2022 22:08:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 18/24] page_pool: Convert frag_page to frag_nmem
Date:   Wed, 30 Nov 2022 22:07:57 +0000
Message-Id: <20221130220803.3657490-19-willy@infradead.org>
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

Remove page_pool_defrag_page() and page_pool_return_page() as they have
no more callers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 17 ++++++---------
 net/core/page_pool.c    | 47 ++++++++++++++++++-----------------------
 2 files changed, 26 insertions(+), 38 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 701f94947e8a..ce1049a03f2d 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -240,7 +240,7 @@ struct page_pool {
 
 	u32 pages_state_hold_cnt;
 	unsigned int frag_offset;
-	struct page *frag_page;
+	struct netmem *frag_nmem;
 	long frag_users;
 
 #ifdef CONFIG_PAGE_POOL_STATS
@@ -307,8 +307,8 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 	return page_pool_alloc_pages(pool, gfp);
 }
 
-struct page *page_pool_alloc_frag(struct page_pool *pool, unsigned int *offset,
-				  unsigned int size, gfp_t gfp);
+struct netmem *page_pool_alloc_frag(struct page_pool *pool,
+		unsigned int *offset, unsigned int size, gfp_t gfp);
 
 static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
 						    unsigned int *offset,
@@ -316,7 +316,7 @@ static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
 {
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
-	return page_pool_alloc_frag(pool, offset, size, gfp);
+	return netmem_page(page_pool_alloc_frag(pool, offset, size, gfp));
 }
 
 /* get the stored dma direction. A driver might decide to treat this locally and
@@ -372,9 +372,9 @@ void page_pool_put_defragged_netmem(struct page_pool *pool, struct netmem *nmem,
 				  unsigned int dma_sync_size,
 				  bool allow_direct);
 
-static inline void page_pool_fragment_page(struct page *page, long nr)
+static inline void page_pool_fragment_netmem(struct netmem *nmem, long nr)
 {
-	atomic_long_set(&page->pp_frag_count, nr);
+	atomic_long_set(&nmem->pp_frag_count, nr);
 }
 
 static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
@@ -398,11 +398,6 @@ static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
 	return ret;
 }
 
-static inline long page_pool_defrag_page(struct page *page, long nr)
-{
-	return page_pool_defrag_netmem(page_netmem(page), nr);
-}
-
 static inline bool page_pool_is_last_frag(struct page_pool *pool,
 					  struct netmem *nmem)
 {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b4540d242081..5be78ec93af8 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -222,12 +222,6 @@ EXPORT_SYMBOL(page_pool_create);
 
 static void page_pool_return_netmem(struct page_pool *pool, struct netmem *nm);
 
-static inline
-void page_pool_return_page(struct page_pool *pool, struct page *page)
-{
-	page_pool_return_netmem(pool, page_netmem(page));
-}
-
 noinline
 static struct netmem *page_pool_refill_alloc_cache(struct page_pool *pool)
 {
@@ -665,10 +659,9 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 }
 EXPORT_SYMBOL(page_pool_put_page_bulk);
 
-static struct page *page_pool_drain_frag(struct page_pool *pool,
-					 struct page *page)
+static struct netmem *page_pool_drain_frag(struct page_pool *pool,
+					 struct netmem *nmem)
 {
-	struct netmem *nmem = page_netmem(page);
 	long drain_count = BIAS_MAX - pool->frag_users;
 
 	/* Some user is still using the page frag */
@@ -679,7 +672,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
 		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
 			page_pool_dma_sync_for_device(pool, nmem, -1);
 
-		return page;
+		return nmem;
 	}
 
 	page_pool_return_netmem(pool, nmem);
@@ -689,22 +682,22 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
 static void page_pool_free_frag(struct page_pool *pool)
 {
 	long drain_count = BIAS_MAX - pool->frag_users;
-	struct page *page = pool->frag_page;
+	struct netmem *nmem = pool->frag_nmem;
 
-	pool->frag_page = NULL;
+	pool->frag_nmem = NULL;
 
-	if (!page || page_pool_defrag_page(page, drain_count))
+	if (!nmem || page_pool_defrag_netmem(nmem, drain_count))
 		return;
 
-	page_pool_return_page(pool, page);
+	page_pool_return_netmem(pool, nmem);
 }
 
-struct page *page_pool_alloc_frag(struct page_pool *pool,
+struct netmem *page_pool_alloc_frag(struct page_pool *pool,
 				  unsigned int *offset,
 				  unsigned int size, gfp_t gfp)
 {
 	unsigned int max_size = PAGE_SIZE << pool->p.order;
-	struct page *page = pool->frag_page;
+	struct netmem *nmem = pool->frag_nmem;
 
 	if (WARN_ON(!(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
 		    size > max_size))
@@ -713,35 +706,35 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
 	size = ALIGN(size, dma_get_cache_alignment());
 	*offset = pool->frag_offset;
 
-	if (page && *offset + size > max_size) {
-		page = page_pool_drain_frag(pool, page);
-		if (page) {
+	if (nmem && *offset + size > max_size) {
+		nmem = page_pool_drain_frag(pool, nmem);
+		if (nmem) {
 			alloc_stat_inc(pool, fast);
 			goto frag_reset;
 		}
 	}
 
-	if (!page) {
-		page = page_pool_alloc_pages(pool, gfp);
-		if (unlikely(!page)) {
-			pool->frag_page = NULL;
+	if (!nmem) {
+		nmem = page_pool_alloc_netmem(pool, gfp);
+		if (unlikely(!nmem)) {
+			pool->frag_nmem = NULL;
 			return NULL;
 		}
 
-		pool->frag_page = page;
+		pool->frag_nmem = nmem;
 
 frag_reset:
 		pool->frag_users = 1;
 		*offset = 0;
 		pool->frag_offset = size;
-		page_pool_fragment_page(page, BIAS_MAX);
-		return page;
+		page_pool_fragment_netmem(nmem, BIAS_MAX);
+		return nmem;
 	}
 
 	pool->frag_users++;
 	pool->frag_offset = *offset + size;
 	alloc_stat_inc(pool, fast);
-	return page;
+	return nmem;
 }
 EXPORT_SYMBOL(page_pool_alloc_frag);
 
-- 
2.35.1

