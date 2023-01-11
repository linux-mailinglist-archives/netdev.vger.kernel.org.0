Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80596652BF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjAKEWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjAKEWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78181262F
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3ySWEkgCmf2GpW8kDKeRKe5QMZY/BleTQoqlmO/foAQ=; b=laM8j/vpMpDHefrvTjdg9eH3VN
        e4A5AWkeJ+cd7UEJQJ1F3ozE/V24RiXSO+3ZWBfq82cf2rHIF9fDVdX7l1A/msOZMPyrvybII2y3O
        b1yAs0HOAfk8xOc8DR6/rr3sY7xw7Mr9zwMsCkkuB4x4jwAp6SautLdWrVHFr5d7QWyov8ArlD499
        a3dpnZHmN5GSD6CGQ98xwcsZjucuFU0N3TLdM7FDXR7vePRMOvpubcJnB3ZGky61UbIZ87de7iZ8O
        oTfwBBUyEFj+HQSA2DAikgNl4sjDHW+/niupoVQHvDrKXOhVlayP6BmmUFiN2C3kjvkAvb6pbyBTO
        P0QU3yHg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScz-003nyi-Pn; Wed, 11 Jan 2023 04:22:17 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 19/26] page_pool: Convert frag_page to frag_nmem
Date:   Wed, 11 Jan 2023 04:22:07 +0000
Message-Id: <20230111042214.907030-20-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230111042214.907030-1-willy@infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
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
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/net/page_pool.h | 18 ++++++----------
 net/core/page_pool.c    | 47 ++++++++++++++++++-----------------------
 2 files changed, 26 insertions(+), 39 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 64ac397dcd9f..5e5030f5bbb4 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -262,7 +262,7 @@ struct page_pool {
 
 	u32 pages_state_hold_cnt;
 	unsigned int frag_offset;
-	struct page *frag_page;
+	struct netmem *frag_nmem;
 	long frag_users;
 
 #ifdef CONFIG_PAGE_POOL_STATS
@@ -335,8 +335,8 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 	return page_pool_alloc_pages(pool, gfp);
 }
 
-struct page *page_pool_alloc_frag(struct page_pool *pool, unsigned int *offset,
-				  unsigned int size, gfp_t gfp);
+struct netmem *page_pool_alloc_frag(struct page_pool *pool,
+		unsigned int *offset, unsigned int size, gfp_t gfp);
 
 static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
 						    unsigned int *offset,
@@ -344,7 +344,7 @@ static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
 {
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
-	return page_pool_alloc_frag(pool, offset, size, gfp);
+	return netmem_page(page_pool_alloc_frag(pool, offset, size, gfp));
 }
 
 /* get the stored dma direction. A driver might decide to treat this locally and
@@ -401,9 +401,9 @@ void page_pool_put_defragged_netmem(struct page_pool *pool, struct netmem *nmem,
 				  unsigned int dma_sync_size,
 				  bool allow_direct);
 
-static inline void page_pool_fragment_page(struct page *page, long nr)
+static inline void page_pool_fragment_netmem(struct netmem *nmem, long nr)
 {
-	atomic_long_set(&page->pp_frag_count, nr);
+	atomic_long_set(&nmem->pp_frag_count, nr);
 }
 
 static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
@@ -427,12 +427,6 @@ static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
 	return ret;
 }
 
-/* Compat, remove when all users gone */
-static inline long page_pool_defrag_page(struct page *page, long nr)
-{
-	return page_pool_defrag_netmem(page_netmem(page), nr);
-}
-
 static inline bool page_pool_is_last_frag(struct page_pool *pool,
 					  struct netmem *nmem)
 {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ddf9f2bb85f7..5624cdae1f4e 100644
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

