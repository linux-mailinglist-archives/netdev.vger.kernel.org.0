Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52836652CB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbjAKEYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbjAKEXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:23:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E347313DEF
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7UrvHMQwSHueXOfPW55RWxshiElvT2ojOuY7+1iudqA=; b=nDUgaLrkS3Lz2rgQePBM4xXWvc
        nySlwQKZm7EJ6PyUni6yPXKFnGKBO+q1NuWbYRPJUh5iSmhnlUgk/V4QEwTuuzZEYRoCrhgLn8cJ3
        yW4Wt0FDMS9punaTdLWDhAOUszE/n6VLDCmZJ5b+oFjdcLYIxT+7CA2pFBWlq5aPWS//eQ77Yh5WL
        oZqWVySW+7RVU1lsizLHoexJjI9pfm0ibommCDoA3niuWrltpt8HZrYfJGeydZhzXhmXyimeozRG6
        HHFJRIRGy/VkSoRWAjM0Q41XjZdJELigoiu4pnqgppv/OJcGWkGas4vrDy+gZixawISaM+TaAAtlu
        2vqyALVw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScy-003nxo-Gm; Wed, 11 Jan 2023 04:22:16 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 04/26] page_pool: Convert page_pool_release_page() to page_pool_release_netmem()
Date:   Wed, 11 Jan 2023 04:21:52 +0000
Message-Id: <20230111042214.907030-5-willy@infradead.org>
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

Also convert page_pool_clear_pp_info() and trace_page_pool_state_release()
to take a netmem.  Include a wrapper for page_pool_release_page() to
avoid converting all callers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/net/page_pool.h          | 15 +++++++++++----
 include/trace/events/page_pool.h | 14 +++++++-------
 net/core/page_pool.c             | 18 +++++++++---------
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ff4d11d43697..34d47c10550e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -18,7 +18,7 @@
  *
  * API keeps track of in-flight pages, in-order to let API user know
  * when it is safe to dealloactor page_pool object.  Thus, API users
- * must make sure to call page_pool_release_page() when a page is
+ * must make sure to call page_pool_release_netmem() when a page is
  * "leaving" the page_pool.  Or call page_pool_put_page() where
  * appropiate.  For maintaining correct accounting.
  *
@@ -354,7 +354,7 @@ struct xdp_mem_info;
 void page_pool_destroy(struct page_pool *pool);
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
 			   struct xdp_mem_info *mem);
-void page_pool_release_page(struct page_pool *pool, struct page *page);
+void page_pool_release_netmem(struct page_pool *pool, struct netmem *nmem);
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 			     int count);
 #else
@@ -367,8 +367,8 @@ static inline void page_pool_use_xdp_mem(struct page_pool *pool,
 					 struct xdp_mem_info *mem)
 {
 }
-static inline void page_pool_release_page(struct page_pool *pool,
-					  struct page *page)
+static inline void page_pool_release_netmem(struct page_pool *pool,
+					  struct netmem *nmem)
 {
 }
 
@@ -378,6 +378,13 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 }
 #endif
 
+/* Compat, remove when all users gone */
+static inline void page_pool_release_page(struct page_pool *pool,
+					struct page *page)
+{
+	page_pool_release_netmem(pool, page_netmem(page));
+}
+
 void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
 				  unsigned int dma_sync_size,
 				  bool allow_direct);
diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_pool.h
index ca534501158b..113aad0c9e5b 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -42,26 +42,26 @@ TRACE_EVENT(page_pool_release,
 TRACE_EVENT(page_pool_state_release,
 
 	TP_PROTO(const struct page_pool *pool,
-		 const struct page *page, u32 release),
+		 const struct netmem *nmem, u32 release),
 
-	TP_ARGS(pool, page, release),
+	TP_ARGS(pool, nmem, release),
 
 	TP_STRUCT__entry(
 		__field(const struct page_pool *,	pool)
-		__field(const struct page *,		page)
+		__field(const struct netmem *,		nmem)
 		__field(u32,				release)
 		__field(unsigned long,			pfn)
 	),
 
 	TP_fast_assign(
 		__entry->pool		= pool;
-		__entry->page		= page;
+		__entry->nmem		= nmem;
 		__entry->release	= release;
-		__entry->pfn		= page_to_pfn(page);
+		__entry->pfn		= netmem_pfn(nmem);
 	),
 
-	TP_printk("page_pool=%p page=%p pfn=0x%lx release=%u",
-		  __entry->pool, __entry->page, __entry->pfn, __entry->release)
+	TP_printk("page_pool=%p nmem=%p pfn=0x%lx release=%u",
+		  __entry->pool, __entry->nmem, __entry->pfn, __entry->release)
 );
 
 TRACE_EVENT(page_pool_state_hold,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b203d8660e4..437241aba5a7 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -336,10 +336,10 @@ static void page_pool_set_pp_info(struct page_pool *pool,
 		pool->p.init_callback(page, pool->p.init_arg);
 }
 
-static void page_pool_clear_pp_info(struct page *page)
+static void page_pool_clear_pp_info(struct netmem *nmem)
 {
-	page->pp_magic = 0;
-	page->pp = NULL;
+	nmem->pp_magic = 0;
+	nmem->pp = NULL;
 }
 
 static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
@@ -467,7 +467,7 @@ static s32 page_pool_inflight(struct page_pool *pool)
  * a regular page (that will eventually be returned to the normal
  * page-allocator via put_page).
  */
-void page_pool_release_page(struct page_pool *pool, struct page *page)
+void page_pool_release_netmem(struct page_pool *pool, struct netmem *nmem)
 {
 	dma_addr_t dma;
 	int count;
@@ -478,23 +478,23 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 		 */
 		goto skip_dma_unmap;
 
-	dma = page_pool_get_dma_addr(page);
+	dma = netmem_get_dma_addr(nmem);
 
 	/* When page is unmapped, it cannot be returned to our pool */
 	dma_unmap_page_attrs(pool->p.dev, dma,
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC);
-	page_pool_set_dma_addr(page, 0);
+	netmem_set_dma_addr(nmem, 0);
 skip_dma_unmap:
-	page_pool_clear_pp_info(page);
+	page_pool_clear_pp_info(nmem);
 
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
 	 */
 	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
-	trace_page_pool_state_release(pool, page, count);
+	trace_page_pool_state_release(pool, nmem, count);
 }
-EXPORT_SYMBOL(page_pool_release_page);
+EXPORT_SYMBOL(page_pool_release_netmem);
 
 /* Return a page to the page allocator, cleaning up our state */
 static void page_pool_return_page(struct page_pool *pool, struct page *page)
-- 
2.35.1

