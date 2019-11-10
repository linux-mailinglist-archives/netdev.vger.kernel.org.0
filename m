Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC459F68D9
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 13:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfKJMJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 07:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfKJMJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 07:09:47 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9598220818;
        Sun, 10 Nov 2019 12:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573387786;
        bh=bxFH1n8N/vzX0+H3vCV1PB7HguGV+FN9plUSDMkMF2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmBDne0pYjZ5Pf2Bc73gaQmCYQBpX2BujLHfAZhqaDvTdOaOteR0ICIn82eYmPAtF
         2ELd1NRU/RYINKEeeCTViXKTn/W/GKYNEXfTCP1dEQt7ujME0BNhlNRCDEKmBQds1L
         JODMtzrKcznGPTH2aSHL9Jp5ngNZwvtFvIQ7BVD0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com
Subject: [PATCH net-next 2/3] net: page_pool: add the possibility to sync DMA memory for non-coherent devices
Date:   Sun, 10 Nov 2019 14:09:09 +0200
Message-Id: <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573383212.git.lorenzo@kernel.org>
References: <cover.1573383212.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the following parameters in order to add the possibility to sync
DMA memory area before putting allocated buffers in the page_pool caches:
- sync: set to 1 if device is non cache-coherent and needs to flush DMA
  area
- offset: DMA address offset where the DMA engine starts copying rx data
- max_len: maximum DMA memory size page_pool is allowed to flush. This
  is currently used in __page_pool_alloc_pages_slow routine when pages
  are allocated from page allocator
These parameters are supposed to be set by device drivers

Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/page_pool.h | 11 +++++++----
 net/core/page_pool.c    | 39 +++++++++++++++++++++++++++++++++------
 2 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2cbcdbdec254..defbfd90ab46 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -65,6 +65,9 @@ struct page_pool_params {
 	int		nid;  /* Numa node id to allocate from pages from */
 	struct device	*dev; /* device, for DMA pre-mapping purposes */
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
+	unsigned int	max_len; /* max DMA sync memory size */
+	unsigned int	offset;  /* DMA addr offset */
+	u8 sync;
 };
 
 struct page_pool {
@@ -150,8 +153,8 @@ static inline void page_pool_destroy(struct page_pool *pool)
 }
 
 /* Never call this directly, use helpers below */
-void __page_pool_put_page(struct page_pool *pool,
-			  struct page *page, bool allow_direct);
+void __page_pool_put_page(struct page_pool *pool, struct page *page,
+			  unsigned int dma_sync_size, bool allow_direct);
 
 static inline void page_pool_put_page(struct page_pool *pool,
 				      struct page *page, bool allow_direct)
@@ -160,14 +163,14 @@ static inline void page_pool_put_page(struct page_pool *pool,
 	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
 	 */
 #ifdef CONFIG_PAGE_POOL
-	__page_pool_put_page(pool, page, allow_direct);
+	__page_pool_put_page(pool, page, 0, allow_direct);
 #endif
 }
 /* Very limited use-cases allow recycle direct */
 static inline void page_pool_recycle_direct(struct page_pool *pool,
 					    struct page *page)
 {
-	__page_pool_put_page(pool, page, true);
+	__page_pool_put_page(pool, page, 0, true);
 }
 
 /* API user MUST have disconnected alloc-side (not allowed to call
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5bc65587f1c4..af9514c2d15b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -112,6 +112,17 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	return page;
 }
 
+/* Used for non-coherent devices */
+static void page_pool_dma_sync_for_device(struct page_pool *pool,
+					  struct page *page,
+					  unsigned int dma_sync_size)
+{
+	dma_sync_size = min(dma_sync_size, pool->p.max_len);
+	dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
+					 pool->p.offset, dma_sync_size,
+					 pool->p.dma_dir);
+}
+
 /* slow path */
 noinline
 static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
@@ -156,6 +167,10 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 	page->dma_addr = dma;
 
+	/* non-coherent devices - flush memory */
+	if (pool->p.sync)
+		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
+
 skip_dma_map:
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
@@ -255,7 +270,8 @@ static void __page_pool_return_page(struct page_pool *pool, struct page *page)
 }
 
 static bool __page_pool_recycle_into_ring(struct page_pool *pool,
-				   struct page *page)
+					  struct page *page,
+					  unsigned int dma_sync_size)
 {
 	int ret;
 	/* BH protection not needed if current is serving softirq */
@@ -264,6 +280,10 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
 
+	/* non-coherent devices - flush memory */
+	if (ret == 0 && pool->p.sync)
+		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
+
 	return (ret == 0) ? true : false;
 }
 
@@ -273,18 +293,23 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
  * Caller must provide appropriate safe context.
  */
 static bool __page_pool_recycle_direct(struct page *page,
-				       struct page_pool *pool)
+				       struct page_pool *pool,
+				       unsigned int dma_sync_size)
 {
 	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE))
 		return false;
 
 	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
 	pool->alloc.cache[pool->alloc.count++] = page;
+
+	/* non-coherent devices - flush memory */
+	if (pool->p.sync)
+		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
 	return true;
 }
 
-void __page_pool_put_page(struct page_pool *pool,
-			  struct page *page, bool allow_direct)
+void __page_pool_put_page(struct page_pool *pool, struct page *page,
+			  unsigned int dma_sync_size, bool allow_direct)
 {
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
@@ -296,10 +321,12 @@ void __page_pool_put_page(struct page_pool *pool,
 		/* Read barrier done in page_ref_count / READ_ONCE */
 
 		if (allow_direct && in_serving_softirq())
-			if (__page_pool_recycle_direct(page, pool))
+			if (__page_pool_recycle_direct(page, pool,
+						       dma_sync_size))
 				return;
 
-		if (!__page_pool_recycle_into_ring(pool, page)) {
+		if (!__page_pool_recycle_into_ring(pool, page,
+						   dma_sync_size)) {
 			/* Cache full, fallback to free pages */
 			__page_pool_return_page(pool, page);
 		}
-- 
2.21.0

