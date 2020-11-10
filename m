Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEFA2ADA8E
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732447AbgKJPiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730511AbgKJPiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 10:38:23 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 092AF2068D;
        Tue, 10 Nov 2020 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605022702;
        bh=XlrTxDWxH5D4D6Z8zpKCWNopaKoNsWYTUyvITOZmi58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5Vx3AKKBVeLyNYU/Dv48kHxG9kX49HCs7bvAGCdHS8giL/VdSsCLOC/jBM1jZhqD
         4jMiciNdmS+fyvMH1nKNkwnrSTGZohI7ZL+4a6eEvrlbvyJY63ZzCovrbTN4KbbaCX
         MWm/4zvoh2jdZKE7tWoYfmrMZ3A7hBSGgudM0M5s=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v5 net-nex 2/5] net: page_pool: add bulk support for ptr_ring
Date:   Tue, 10 Nov 2020 16:37:57 +0100
Message-Id: <1229970bf6f36fd4689169a2e47fdcc664d28366.1605020963.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1605020963.git.lorenzo@kernel.org>
References: <cover.1605020963.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to batch page_pool ptr_ring refill since it is
usually run inside the driver NAPI tx completion loop.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/page_pool.h | 26 ++++++++++++++++
 net/core/page_pool.c    | 69 +++++++++++++++++++++++++++++++++++------
 net/core/xdp.c          |  9 ++----
 3 files changed, 87 insertions(+), 17 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 81d7773f96cd..b5b195305346 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -152,6 +152,8 @@ struct page_pool *page_pool_create(const struct page_pool_params *params);
 void page_pool_destroy(struct page_pool *pool);
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *));
 void page_pool_release_page(struct page_pool *pool, struct page *page);
+void page_pool_put_page_bulk(struct page_pool *pool, void **data,
+			     int count);
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -165,6 +167,11 @@ static inline void page_pool_release_page(struct page_pool *pool,
 					  struct page *page)
 {
 }
+
+static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
+					   int count)
+{
+}
 #endif
 
 void page_pool_put_page(struct page_pool *pool, struct page *page,
@@ -215,4 +222,23 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 	if (unlikely(pool->p.nid != new_nid))
 		page_pool_update_nid(pool, new_nid);
 }
+
+static inline void page_pool_ring_lock(struct page_pool *pool)
+	__acquires(&pool->ring.producer_lock)
+{
+	if (in_serving_softirq())
+		spin_lock(&pool->ring.producer_lock);
+	else
+		spin_lock_bh(&pool->ring.producer_lock);
+}
+
+static inline void page_pool_ring_unlock(struct page_pool *pool)
+	__releases(&pool->ring.producer_lock)
+{
+	if (in_serving_softirq())
+		spin_unlock(&pool->ring.producer_lock);
+	else
+		spin_unlock_bh(&pool->ring.producer_lock);
+}
+
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ef98372facf6..a3e6051ac978 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -11,6 +11,8 @@
 #include <linux/device.h>
 
 #include <net/page_pool.h>
+#include <net/xdp.h>
+
 #include <linux/dma-direction.h>
 #include <linux/dma-mapping.h>
 #include <linux/page-flags.h>
@@ -362,8 +364,9 @@ static bool pool_page_reusable(struct page_pool *pool, struct page *page)
  * If the page refcnt != 1, then the page will be returned to memory
  * subsystem.
  */
-void page_pool_put_page(struct page_pool *pool, struct page *page,
-			unsigned int dma_sync_size, bool allow_direct)
+static __always_inline struct page *
+__page_pool_put_page(struct page_pool *pool, struct page *page,
+		     unsigned int dma_sync_size, bool allow_direct)
 {
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
@@ -379,15 +382,12 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
 
-		if (allow_direct && in_serving_softirq())
-			if (page_pool_recycle_in_cache(page, pool))
-				return;
+		if (allow_direct && in_serving_softirq() &&
+		    page_pool_recycle_in_cache(page, pool))
+			return NULL;
 
-		if (!page_pool_recycle_in_ring(pool, page)) {
-			/* Cache full, fallback to free pages */
-			page_pool_return_page(pool, page);
-		}
-		return;
+		/* Page found as candidate for recycling */
+		return page;
 	}
 	/* Fallback/non-XDP mode: API user have elevated refcnt.
 	 *
@@ -405,9 +405,58 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
 	/* Do not replace this with page_pool_return_page() */
 	page_pool_release_page(pool, page);
 	put_page(page);
+
+	return NULL;
+}
+
+void page_pool_put_page(struct page_pool *pool, struct page *page,
+			unsigned int dma_sync_size, bool allow_direct)
+{
+	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
+	if (page && !page_pool_recycle_in_ring(pool, page)) {
+		/* Cache full, fallback to free pages */
+		page_pool_return_page(pool, page);
+	}
 }
 EXPORT_SYMBOL(page_pool_put_page);
 
+/* Caller must not use data area after call, as this function overwrites it */
+void page_pool_put_page_bulk(struct page_pool *pool, void **data,
+			     int count)
+{
+	int i, bulk_len = 0, pa_len = 0;
+
+	for (i = 0; i < count; i++) {
+		struct page *page = virt_to_head_page(data[i]);
+
+		page = __page_pool_put_page(pool, page, -1, false);
+		/* Approved for bulk recycling in ptr_ring cache */
+		if (page)
+			data[bulk_len++] = page;
+	}
+
+	if (unlikely(!bulk_len))
+		return;
+
+	/* Bulk producer into ptr_ring page_pool cache */
+	page_pool_ring_lock(pool);
+	for (i = 0; i < bulk_len; i++) {
+		if (__ptr_ring_produce(&pool->ring, data[i]))
+			data[pa_len++] = data[i];
+	}
+	page_pool_ring_unlock(pool);
+
+	if (likely(!pa_len))
+		return;
+
+	/* ptr_ring cache full, free pages outside producer lock since
+	 * put_page() with refcnt == 1 can be an expensive operation
+	 */
+	for (i = 0; i < pa_len; i++)
+		page_pool_return_page(pool, data[i]);
+}
+EXPORT_SYMBOL(page_pool_put_page_bulk);
+
 static void page_pool_empty_ring(struct page_pool *pool)
 {
 	struct page *page;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index bbaee7fdd44f..3d330ebda893 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -393,16 +393,11 @@ EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
 {
 	struct xdp_mem_allocator *xa = bq->xa;
-	int i;
 
-	if (unlikely(!xa))
+	if (unlikely(!xa || !bq->count))
 		return;
 
-	for (i = 0; i < bq->count; i++) {
-		struct page *page = virt_to_head_page(bq->q[i]);
-
-		page_pool_put_full_page(xa->page_pool, page, false);
-	}
+	page_pool_put_page_bulk(xa->page_pool, bq->q, bq->count);
 	/* bq->xa is not cleared to save lookup, if mem.id same in next bulk */
 	bq->count = 0;
 }
-- 
2.26.2

