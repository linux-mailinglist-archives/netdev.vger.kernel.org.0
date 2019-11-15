Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF99FE557
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKOTCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:02:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbfKOTCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 14:02:15 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B8420732;
        Fri, 15 Nov 2019 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573844534;
        bh=WoafOgeAmpH0dn+CxS5qXp5Mkh4L9Mqrz9zHwNzODPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2ggWPdrliLy/GUtGWLTT3AxQTWqzCkC4S5xCYAYFjYdKDg4cDN/pjA/aUUm76KEM
         OzeKQoovA3MDO49Kl7HElUtcvEa4+nOBk8laVRCZgXIP4/JL03OlVaKbgp2uYoPLjD
         IS+5bcree/RTwov9bJudqSbi00uYc9/ypjodiT2A=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com
Subject: [PATCH v3 net-next 2/3] net: page_pool: add the possibility to sync DMA memory for device
Date:   Fri, 15 Nov 2019 21:01:38 +0200
Message-Id: <1e177bb63c858acdf5aeac9198c2815448d37820.1573844190.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573844190.git.lorenzo@kernel.org>
References: <cover.1573844190.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the following parameters in order to add the possibility to sync
DMA memory for device before putting allocated pages in the page_pool
caches:
- PP_FLAG_DMA_SYNC_DEV: if set in page_pool_params flags, all pages that
  the driver gets from page_pool will be DMA-synced-for-device according
  to the length provided by the device driver. Please note DMA-sync-for-CPU
  is still device driver responsibility
- offset: DMA address offset where the DMA engine starts copying rx data
- max_len: maximum DMA memory size page_pool is allowed to flush. This
  is currently used in __page_pool_alloc_pages_slow routine when pages
  are allocated from page allocator
These parameters are supposed to be set by device drivers.

This optimization reduces the length of the DMA-sync-for-device.
The optimization is valid because pages are initially
DMA-synced-for-device as defined via max_len. At RX time, the driver
will perform a DMA-sync-for-CPU on the memory for the packet length.
What is important is the memory occupied by packet payload, because
this is the area CPU is allowed to read and modify. As we don't track
cache-lines written into by the CPU, simply use the packet payload length
as dma_sync_size at page_pool recycle time. This also take into account
any tail-extend.

Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/page_pool.h | 21 +++++++++++++++------
 net/core/page_pool.c    | 42 +++++++++++++++++++++++++++++++++++------
 2 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2cbcdbdec254..8856d2c815d0 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -34,8 +34,15 @@
 #include <linux/ptr_ring.h>
 #include <linux/dma-direction.h>
 
-#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unmap */
-#define PP_FLAG_ALL	PP_FLAG_DMA_MAP
+#define PP_FLAG_DMA_MAP		1 /* Should page_pool do the DMA map/unmap */
+#define PP_FLAG_DMA_SYNC_DEV	2 /* if set all pages that the driver gets
+				   * from page_pool will be
+				   * DMA-synced-for-device according to the
+				   * length provided by the device driver.
+				   * Please note DMA-sync-for-CPU is still
+				   * device driver responsibility
+				   */
+#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
 
 /*
  * Fast allocation side cache array/stack
@@ -65,6 +72,8 @@ struct page_pool_params {
 	int		nid;  /* Numa node id to allocate from pages from */
 	struct device	*dev; /* device, for DMA pre-mapping purposes */
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
+	unsigned int	max_len; /* max DMA sync memory size */
+	unsigned int	offset;  /* DMA addr offset */
 };
 
 struct page_pool {
@@ -150,8 +159,8 @@ static inline void page_pool_destroy(struct page_pool *pool)
 }
 
 /* Never call this directly, use helpers below */
-void __page_pool_put_page(struct page_pool *pool,
-			  struct page *page, bool allow_direct);
+void __page_pool_put_page(struct page_pool *pool, struct page *page,
+			  unsigned int dma_sync_size, bool allow_direct);
 
 static inline void page_pool_put_page(struct page_pool *pool,
 				      struct page *page, bool allow_direct)
@@ -160,14 +169,14 @@ static inline void page_pool_put_page(struct page_pool *pool,
 	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
 	 */
 #ifdef CONFIG_PAGE_POOL
-	__page_pool_put_page(pool, page, allow_direct);
+	__page_pool_put_page(pool, page, -1, allow_direct);
 #endif
 }
 /* Very limited use-cases allow recycle direct */
 static inline void page_pool_recycle_direct(struct page_pool *pool,
 					    struct page *page)
 {
-	__page_pool_put_page(pool, page, true);
+	__page_pool_put_page(pool, page, -1, true);
 }
 
 /* API user MUST have disconnected alloc-side (not allowed to call
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5bc65587f1c4..e4ea607f2098 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -44,6 +44,13 @@ static int page_pool_init(struct page_pool *pool,
 	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
 		return -EINVAL;
 
+	/* In order to request DMA-sync-for-device the page needs to
+	 * be mapped
+	 */
+	if ((pool->p.flags & PP_FLAG_DMA_SYNC_DEV) &&
+	    !(pool->p.flags & PP_FLAG_DMA_MAP))
+		return -EINVAL;
+
 	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
 		return -ENOMEM;
 
@@ -112,6 +119,16 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	return page;
 }
 
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
@@ -156,6 +173,9 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 	page->dma_addr = dma;
 
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
+
 skip_dma_map:
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
@@ -255,7 +275,8 @@ static void __page_pool_return_page(struct page_pool *pool, struct page *page)
 }
 
 static bool __page_pool_recycle_into_ring(struct page_pool *pool,
-				   struct page *page)
+					  struct page *page,
+					  unsigned int dma_sync_size)
 {
 	int ret;
 	/* BH protection not needed if current is serving softirq */
@@ -264,6 +285,9 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
 
+	if (ret == 0 && (pool->p.flags & PP_FLAG_DMA_SYNC_DEV))
+		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
+
 	return (ret == 0) ? true : false;
 }
 
@@ -273,18 +297,22 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
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
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
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
@@ -296,10 +324,12 @@ void __page_pool_put_page(struct page_pool *pool,
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

