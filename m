Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3CBFC876
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKNOLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfKNOLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 09:11:07 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CE420715;
        Thu, 14 Nov 2019 14:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573740666;
        bh=gA5h+sKLnE3gXeA6CqyE6CL+ZVip20K0vy+I1X6GvDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHoQFl327CSgYbEuI2gEPLrfcSYpIzX1cr7YnlUckgYaTVsrp/Mik4RBrimggMJOw
         TOHC8q5979MXoy5iUIWHqP9C0nRu/j1GKBtMUz4wfi5/TMntlTfJjGVuYWxcuiTK61
         aVRXAnbojJsbJomqcU68uw8F5Bg+zmEkvaVfvGrI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com
Subject: [PATCH v2 net-next 2/3] net: page_pool: add the possibility to sync DMA memory for device
Date:   Thu, 14 Nov 2019 16:10:36 +0200
Message-Id: <6dc38847dd56fbef8e43cc4c554d95e7efb92568.1573740067.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573740067.git.lorenzo@kernel.org>
References: <cover.1573740067.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the following parameters in order to add the possibility to sync
DMA memory area for device before putting allocated buffers in the
page_pool caches:
- dma_sync: if set all pages that the driver gets from page_pool will be
  DMA-synced-for-device according to the length provided by the device
  driver. Please note DMA-sync-for-CPU is still device drivers
  responsibility
- offset: DMA address offset where the DMA engine starts copying rx data
- max_len: maximum DMA memory size page_pool is allowed to flush. This
  is currently used in __page_pool_alloc_pages_slow routine when pages
  are allocated from page allocator
These parameters are supposed to be set by device drivers.

This optimization reduces the length of the DMA-sync-for-device.
The optimization is valid because pages are initially
DMA-synced-for-device, as defined via max_len. At RX time, the driver
will perform a DMA-sync-for-CPU on the memory for the packet length.
What is important is the memory occupied by packet payload, because
this is the area CPU is allowed to read and modify. As we don't track
cache-lines written into by the CPU, simply use the packet payload length
as dma_sync_size at page_pool recycle time. This also take into account
any tail-extend.

Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/page_pool.h | 16 ++++++++++++----
 net/core/page_pool.c    | 35 +++++++++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2cbcdbdec254..0b41050fddf4 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -65,6 +65,14 @@ struct page_pool_params {
 	int		nid;  /* Numa node id to allocate from pages from */
 	struct device	*dev; /* device, for DMA pre-mapping purposes */
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
+	unsigned int	max_len; /* max DMA sync memory size */
+	unsigned int	offset;  /* DMA addr offset */
+	u8 dma_sync; /* if set all pages that the driver gets from page_pool
+		      * will be DMA-synced-for-device according
+		      * to the length provided by the device driver.
+		      * Please note DMA-sync-for-CPU is still device drivers
+		      * responsibility
+		      */
 };
 
 struct page_pool {
@@ -150,8 +158,8 @@ static inline void page_pool_destroy(struct page_pool *pool)
 }
 
 /* Never call this directly, use helpers below */
-void __page_pool_put_page(struct page_pool *pool,
-			  struct page *page, bool allow_direct);
+void __page_pool_put_page(struct page_pool *pool, struct page *page,
+			  unsigned int dma_sync_size, bool allow_direct);
 
 static inline void page_pool_put_page(struct page_pool *pool,
 				      struct page *page, bool allow_direct)
@@ -160,14 +168,14 @@ static inline void page_pool_put_page(struct page_pool *pool,
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
index 5bc65587f1c4..3f61934ab3d1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -112,6 +112,16 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
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
@@ -156,6 +166,9 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 	page->dma_addr = dma;
 
+	if (pool->p.dma_sync)
+		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
+
 skip_dma_map:
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
@@ -255,7 +268,8 @@ static void __page_pool_return_page(struct page_pool *pool, struct page *page)
 }
 
 static bool __page_pool_recycle_into_ring(struct page_pool *pool,
-				   struct page *page)
+					  struct page *page,
+					  unsigned int dma_sync_size)
 {
 	int ret;
 	/* BH protection not needed if current is serving softirq */
@@ -264,6 +278,9 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
 
+	if (ret == 0 && pool->p.dma_sync)
+		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
+
 	return (ret == 0) ? true : false;
 }
 
@@ -273,18 +290,22 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
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
+	if (pool->p.dma_sync)
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
@@ -296,10 +317,12 @@ void __page_pool_put_page(struct page_pool *pool,
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

