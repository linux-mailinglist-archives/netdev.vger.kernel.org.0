Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADDD63E31C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiK3WIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiK3WII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BE754372
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ytDwzaaiBIaOl0NGC8+JijprqvlmynIdZB7ZXnih+Nw=; b=P8rICWLHbEY1OGbm+L5MV9t+64
        ZeXvZXd0Ny8CovsmEJAC3zBU3Nytd9NLzR5yFRWXVAbum5tqbesvKlIgopNK8mmIBsZtHEeW4c0cH
        dI0n8CGq1NyH1OyX1aAEG4HvQ+gX3bDYtf91/4ngQmkpWnWJJl/tI8X1PWi+P8TURZxXQP9SLxuak
        8uoqaaUva97FP3meHxIc51dg4f8g44eA0QH//q5Sj364rDRhd6YTGJgUCQ34M2FkZwRVHGBqbn6pX
        G2rJQbOYN8l0WZrKpaooQA6K0LSOTw5YyEIA9Dp1V/cVvnPldZndudaJgsze+sjzLWypvIgmwXIOu
        kBTb/mJg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFN-00FLVc-Mc; Wed, 30 Nov 2022 22:08:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 13/24] page_pool: Convert page_pool_dma_sync_for_device() to take a netmem
Date:   Wed, 30 Nov 2022 22:07:52 +0000
Message-Id: <20221130220803.3657490-14-willy@infradead.org>
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

Change all callers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/core/page_pool.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index efe9f1471caa..9ef65b383b40 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -299,10 +299,10 @@ static struct netmem *__page_pool_get_cached(struct page_pool *pool)
 }
 
 static void page_pool_dma_sync_for_device(struct page_pool *pool,
-					  struct page *page,
+					  struct netmem *nmem,
 					  unsigned int dma_sync_size)
 {
-	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
+	dma_addr_t dma_addr = netmem_get_dma_addr(nmem);
 
 	dma_sync_size = min(dma_sync_size, pool->p.max_len);
 	dma_sync_single_range_for_device(pool->p.dev, dma_addr,
@@ -329,7 +329,7 @@ static bool page_pool_dma_map(struct page_pool *pool, struct netmem *nmem)
 	page_pool_set_dma_addr(page, dma);
 
 	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
+		page_pool_dma_sync_for_device(pool, nmem, pool->p.max_len);
 
 	return true;
 }
@@ -576,7 +576,7 @@ __page_pool_put_netmem(struct page_pool *pool, struct netmem *nmem,
 		/* Read barrier done in netmem_ref_count / READ_ONCE */
 
 		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-			page_pool_dma_sync_for_device(pool, netmem_page(nmem),
+			page_pool_dma_sync_for_device(pool, nmem,
 						      dma_sync_size);
 
 		if (allow_direct && in_serving_softirq() &&
@@ -676,6 +676,7 @@ EXPORT_SYMBOL(page_pool_put_page_bulk);
 static struct page *page_pool_drain_frag(struct page_pool *pool,
 					 struct page *page)
 {
+	struct netmem *nmem = page_netmem(page);
 	long drain_count = BIAS_MAX - pool->frag_users;
 
 	/* Some user is still using the page frag */
@@ -684,7 +685,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
 
 	if (page_ref_count(page) == 1 && !page_is_pfmemalloc(page)) {
 		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-			page_pool_dma_sync_for_device(pool, page, -1);
+			page_pool_dma_sync_for_device(pool, nmem, -1);
 
 		return page;
 	}
-- 
2.35.1

