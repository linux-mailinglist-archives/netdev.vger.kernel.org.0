Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A09100687
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 14:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKRNeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 08:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfKRNeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 08:34:07 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 480B720748;
        Mon, 18 Nov 2019 13:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574084046;
        bh=9dEiXhhWnwrNC2N24xwfH2ZySDxmBMkQ3LMijcbL2hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f08/5pmXGSAw4hNBC4K4SM5BkoNc07uHm2h8VfYSTh6InKD/WObjf7x9d1Sq7gYQa
         +64bBAwVHXtsxvxhlOmA2wzaQULF5mXa3NscX5NOkJo7lYvHsjAVSfhRvR0t1g9f+c
         Zk9Gj+RbxiyGIfUZTZnmNQysAgtVTc//aoik9l3Q=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com,
        jonathan.lemon@gmail.com
Subject: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to sync DMA memory for device
Date:   Mon, 18 Nov 2019 15:33:45 +0200
Message-Id: <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1574083275.git.lorenzo@kernel.org>
References: <cover.1574083275.git.lorenzo@kernel.org>
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
 net/core/page_pool.c    | 28 ++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 1121faa99c12..6f684c3a3434 100644
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
@@ -149,8 +158,8 @@ static inline void page_pool_use_xdp_mem(struct page_pool *pool,
 #endif
 
 /* Never call this directly, use helpers below */
-void __page_pool_put_page(struct page_pool *pool,
-			  struct page *page, bool allow_direct);
+void __page_pool_put_page(struct page_pool *pool, struct page *page,
+			  unsigned int dma_sync_size, bool allow_direct);
 
 static inline void page_pool_put_page(struct page_pool *pool,
 				      struct page *page, bool allow_direct)
@@ -159,14 +168,14 @@ static inline void page_pool_put_page(struct page_pool *pool,
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
 
 /* Disconnects a page (from a page_pool).  API users can have a need
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index dfc2501c35d9..4f9aed7bce5a 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -47,6 +47,13 @@ static int page_pool_init(struct page_pool *pool,
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
 
@@ -115,6 +122,16 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
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
@@ -159,6 +176,9 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 	page->dma_addr = dma;
 
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
+
 skip_dma_map:
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
@@ -281,8 +301,8 @@ static bool __page_pool_recycle_direct(struct page *page,
 	return true;
 }
 
-void __page_pool_put_page(struct page_pool *pool,
-			  struct page *page, bool allow_direct)
+void __page_pool_put_page(struct page_pool *pool, struct page *page,
+			  unsigned int dma_sync_size, bool allow_direct)
 {
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
@@ -293,6 +313,10 @@ void __page_pool_put_page(struct page_pool *pool,
 	if (likely(page_ref_count(page) == 1)) {
 		/* Read barrier done in page_ref_count / READ_ONCE */
 
+		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+			page_pool_dma_sync_for_device(pool, page,
+						      dma_sync_size);
+
 		if (allow_direct && in_serving_softirq())
 			if (__page_pool_recycle_direct(page, pool))
 				return;
-- 
2.21.0

