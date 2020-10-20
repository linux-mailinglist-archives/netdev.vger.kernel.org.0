Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3D2293813
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392887AbgJTJeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392766AbgJTJeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 05:34:00 -0400
Received: from lore-desk.redhat.com (unknown [151.66.125.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B44223C6;
        Tue, 20 Oct 2020 09:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603186439;
        bh=M5WlBZtyTGQG1tc8djGKTOxquF2qQdaDPsN9eWxctO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDps+fJCjLNACla8cYhgBtnnNhjY+NCq5yLo+yh8+2AIgtgVc68GUQxMuzi9co2h5
         ngquHz3DJsl7WVIPXIAcLwU+ncxjbnngjmhXw+gqzC0T0J6EQ7vDiZLQ9VUHlAO1i2
         05PquipGaaL2BuhophGsmvDZGrzwopNhnAj/dvqc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [RFC 2/2] net: page_pool: add bulk support for ptr_ring
Date:   Tue, 20 Oct 2020 11:33:38 +0200
Message-Id: <5017913dc83b31ef389c804f0c560e25746b3506.1603185591.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603185591.git.lorenzo@kernel.org>
References: <cover.1603185591.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to batch page_pool ptr_ring refill since it is
usually run inside the driver NAPI tx completion loop.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/page_pool.h | 21 +++++++++++++++++++++
 net/core/page_pool.c    | 37 +++++++++++++++++++++++++++++++++++++
 net/core/xdp.c          | 13 ++++++-------
 3 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 81d7773f96cd..1330419efec7 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -169,6 +169,8 @@ static inline void page_pool_release_page(struct page_pool *pool,
 
 void page_pool_put_page(struct page_pool *pool, struct page *page,
 			unsigned int dma_sync_size, bool allow_direct);
+void page_pool_put_page_bulk(struct page_pool *pool, void **data, int count,
+			     bool allow_direct);
 
 /* Same as above but will try to sync the entire area pool->max_len */
 static inline void page_pool_put_full_page(struct page_pool *pool,
@@ -215,4 +217,23 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
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
index ef98372facf6..03c3a92c9179 100644
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
@@ -408,6 +410,41 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
 }
 EXPORT_SYMBOL(page_pool_put_page);
 
+void page_pool_put_page_bulk(struct page_pool *pool, void **data, int count,
+			     bool allow_direct)
+{
+	struct page *page_ring[XDP_BULK_QUEUE_SIZE];
+	int i, len = 0;
+
+	for (i = 0; i < count; i++) {
+		struct page *page = virt_to_head_page(data[i]);
+
+		if (unlikely(page_ref_count(page) != 1 ||
+			     !pool_page_reusable(pool, page))) {
+			page_pool_release_page(pool, page);
+			put_page(page);
+			continue;
+		}
+
+		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+			page_pool_dma_sync_for_device(pool, page, -1);
+
+		if (allow_direct && in_serving_softirq() &&
+		    page_pool_recycle_in_cache(page, pool))
+			continue;
+
+		page_ring[len++] = page;
+	}
+
+	page_pool_ring_lock(pool);
+	for (i = 0; i < len; i++) {
+		if (__ptr_ring_produce(&pool->ring, page_ring[i]))
+			page_pool_return_page(pool, page_ring[i]);
+	}
+	page_pool_ring_unlock(pool);
+}
+EXPORT_SYMBOL(page_pool_put_page_bulk);
+
 static void page_pool_empty_ring(struct page_pool *pool)
 {
 	struct page *page;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index b05467a916b4..7ebe159e3835 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -384,14 +384,13 @@ void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq,
 			  bool napi_direct)
 {
 	struct xdp_mem_allocator *xa = bq->xa;
-	int i;
 
-	for (i = 0; i < bq->count; i++) {
-		napi_direct &= !xdp_return_frame_no_direct();
-		page_pool_put_full_page(xa->page_pool,
-					virt_to_head_page(bq->q[i]),
-					napi_direct);
-	}
+	if (unlikely(!bq->count))
+		return;
+
+	napi_direct &= !xdp_return_frame_no_direct();
+	page_pool_put_page_bulk(xa->page_pool, bq->q, bq->count,
+				napi_direct);
 	bq->count = 0;
 }
 EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
-- 
2.26.2

