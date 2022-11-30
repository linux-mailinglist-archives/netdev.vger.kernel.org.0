Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6824D63E323
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiK3WJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiK3WIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1448094929
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9GpVtqE16bx92cBcnBntQf4rdh1V8b/Phx6mQORBxs8=; b=Gb7Esyx/pDfAzo29TzNM267+5c
        HpieHZcjXSzCovEuqjAMyWzXowmUCRtyNWKMUDRuSXUdmxtcjYPBDvrt3czDcoKGkQ256MIoGXSPT
        WMOh/Dv+8HvHqjjRvqSG0oKKvM1osGquId378ZgQfYmC4Q8JF/R5Y5gOdkEq5CG0104NCmjj8JL/Z
        n3vPCb5EzBN3E6sL/bsawoB+Yu2y/jxaE9wYj8qOAmDMYCgkoeQk+iM3vg6Obblo5+pMtgIUtz+Zs
        F5nLAquBOu92cm0Vc/5yJm2mHrFbLaUBsnAkcr5lXbyYokbPQZ+fLAhnf9/CXzRL0PXopBlyWBokm
        2ZqRcX/A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFN-00FLV9-09; Wed, 30 Nov 2022 22:08:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 05/24] page_pool: Start using netmem in allocation path.
Date:   Wed, 30 Nov 2022 22:07:44 +0000
Message-Id: <20221130220803.3657490-6-willy@infradead.org>
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

Convert __page_pool_alloc_page_order() and __page_pool_alloc_pages_slow()
to use netmem internally.  This removes a couple of calls
to compound_head() that are hidden inside put_page().
Convert trace_page_pool_state_hold(), page_pool_dma_map() and
page_pool_set_pp_info() to take a netmem argument.

Saves 83 bytes of text in __page_pool_alloc_page_order() and 98 in
__page_pool_alloc_pages_slow() for a total of 181 bytes.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/trace/events/page_pool.h | 14 +++++------
 net/core/page_pool.c             | 42 +++++++++++++++++---------------
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_pool.h
index 113aad0c9e5b..d1237a7ce481 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -67,26 +67,26 @@ TRACE_EVENT(page_pool_state_release,
 TRACE_EVENT(page_pool_state_hold,
 
 	TP_PROTO(const struct page_pool *pool,
-		 const struct page *page, u32 hold),
+		 const struct netmem *nmem, u32 hold),
 
-	TP_ARGS(pool, page, hold),
+	TP_ARGS(pool, nmem, hold),
 
 	TP_STRUCT__entry(
 		__field(const struct page_pool *,	pool)
-		__field(const struct page *,		page)
+		__field(const struct netmem *,		nmem)
 		__field(u32,				hold)
 		__field(unsigned long,			pfn)
 	),
 
 	TP_fast_assign(
 		__entry->pool	= pool;
-		__entry->page	= page;
+		__entry->nmem	= nmem;
 		__entry->hold	= hold;
-		__entry->pfn	= page_to_pfn(page);
+		__entry->pfn	= netmem_pfn(nmem);
 	),
 
-	TP_printk("page_pool=%p page=%p pfn=0x%lx hold=%u",
-		  __entry->pool, __entry->page, __entry->pfn, __entry->hold)
+	TP_printk("page_pool=%p netmem=%p pfn=0x%lx hold=%u",
+		  __entry->pool, __entry->nmem, __entry->pfn, __entry->hold)
 );
 
 TRACE_EVENT(page_pool_update_nid,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 437241aba5a7..4e985502c569 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -304,8 +304,9 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
 					 pool->p.dma_dir);
 }
 
-static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
+static bool page_pool_dma_map(struct page_pool *pool, struct netmem *nmem)
 {
+	struct page *page = netmem_page(nmem);
 	dma_addr_t dma;
 
 	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
@@ -328,12 +329,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 }
 
 static void page_pool_set_pp_info(struct page_pool *pool,
-				  struct page *page)
+				  struct netmem *nmem)
 {
-	page->pp = pool;
-	page->pp_magic |= PP_SIGNATURE;
+	nmem->pp = pool;
+	nmem->pp_magic |= PP_SIGNATURE;
 	if (pool->p.init_callback)
-		pool->p.init_callback(page, pool->p.init_arg);
+		pool->p.init_callback(netmem_page(nmem), pool->p.init_arg);
 }
 
 static void page_pool_clear_pp_info(struct netmem *nmem)
@@ -345,26 +346,26 @@ static void page_pool_clear_pp_info(struct netmem *nmem)
 static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 						 gfp_t gfp)
 {
-	struct page *page;
+	struct netmem *nmem;
 
 	gfp |= __GFP_COMP;
-	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
-	if (unlikely(!page))
+	nmem = page_netmem(alloc_pages_node(pool->p.nid, gfp, pool->p.order));
+	if (unlikely(!nmem))
 		return NULL;
 
 	if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
-	    unlikely(!page_pool_dma_map(pool, page))) {
-		put_page(page);
+	    unlikely(!page_pool_dma_map(pool, nmem))) {
+		netmem_put(nmem);
 		return NULL;
 	}
 
 	alloc_stat_inc(pool, slow_high_order);
-	page_pool_set_pp_info(pool, page);
+	page_pool_set_pp_info(pool, nmem);
 
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
-	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
-	return page;
+	trace_page_pool_state_hold(pool, nmem, pool->pages_state_hold_cnt);
+	return netmem_page(nmem);
 }
 
 /* slow path */
@@ -398,18 +399,18 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	 * page element have not been (possibly) DMA mapped.
 	 */
 	for (i = 0; i < nr_pages; i++) {
-		page = pool->alloc.cache[i];
+		struct netmem *nmem = page_netmem(pool->alloc.cache[i]);
 		if ((pp_flags & PP_FLAG_DMA_MAP) &&
-		    unlikely(!page_pool_dma_map(pool, page))) {
-			put_page(page);
+		    unlikely(!page_pool_dma_map(pool, nmem))) {
+			netmem_put(nmem);
 			continue;
 		}
 
-		page_pool_set_pp_info(pool, page);
-		pool->alloc.cache[pool->alloc.count++] = page;
+		page_pool_set_pp_info(pool, nmem);
+		pool->alloc.cache[pool->alloc.count++] = netmem_page(nmem);
 		/* Track how many pages are held 'in-flight' */
 		pool->pages_state_hold_cnt++;
-		trace_page_pool_state_hold(pool, page,
+		trace_page_pool_state_hold(pool, nmem,
 					   pool->pages_state_hold_cnt);
 	}
 
@@ -421,7 +422,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		page = NULL;
 	}
 
-	/* When page just alloc'ed is should/must have refcnt 1. */
+	/* When page just allocated it should have refcnt 1 (but may have
+	 * speculative references) */
 	return page;
 }
 
-- 
2.35.1

