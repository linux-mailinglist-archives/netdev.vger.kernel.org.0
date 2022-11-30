Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C6763E329
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiK3WJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiK3WI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EF0950D9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wK0+Y2Z7+C+MyZoaRh/jfdsgnrkZnPCk0m09amqVjBk=; b=RyH59HF8KJ2mKzt4+uxCRZoILV
        e46NX6ADL2F4xfUMjmgbMmHwXDPFJ7KWaRZPSFkpY6E1Y70fG5mXd3PF47In/AulHQ5NOpICykOVo
        U1p9DVZ5soIRvpLnEPZ5nyLbmpCZMWoODCVZhfq7rtGc0NPN1J4FOB4eyIBT4gGOLxt+oo8hn8UG4
        0JTM1kAQklIyWKydW9VzrEUXXQqVxrdBQG6mqROET4oGrCPo7s1lWZ2w/dftIUTpcjmI8mwzCBIJP
        o1Wf9OLt9Qzq3sxoeARc2M2pYg/Gf8WSIRkWxYKvPqYBNa5aWZv6H7Wg539Zs3Z9hV+FZ1PdoOjgh
        G7HfRKkw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFM-00FLV5-TO; Wed, 30 Nov 2022 22:08:04 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 04/24] page_pool: Convert page_pool_release_page() to page_pool_release_netmem()
Date:   Wed, 30 Nov 2022 22:07:43 +0000
Message-Id: <20221130220803.3657490-5-willy@infradead.org>
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

Also convert page_pool_clear_pp_info() and trace_page_pool_state_release()
to take a netmem.  Include a wrapper for page_pool_release_page() to
avoid converting all callers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h          | 14 ++++++++++----
 include/trace/events/page_pool.h | 14 +++++++-------
 net/core/page_pool.c             | 18 +++++++++---------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a68746a5b99c..453797f9cb90 100644
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
@@ -332,7 +332,7 @@ struct xdp_mem_info;
 void page_pool_destroy(struct page_pool *pool);
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
 			   struct xdp_mem_info *mem);
-void page_pool_release_page(struct page_pool *pool, struct page *page);
+void page_pool_release_netmem(struct page_pool *pool, struct netmem *nmem);
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 			     int count);
 #else
@@ -345,8 +345,8 @@ static inline void page_pool_use_xdp_mem(struct page_pool *pool,
 					 struct xdp_mem_info *mem)
 {
 }
-static inline void page_pool_release_page(struct page_pool *pool,
-					  struct page *page)
+static inline void page_pool_release_netmem(struct page_pool *pool,
+					  struct netmem *nmem)
 {
 }
 
@@ -356,6 +356,12 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 }
 #endif
 
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

