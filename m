Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346F82A6179
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgKDKYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729343AbgKDKXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 05:23:15 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B12B223AB;
        Wed,  4 Nov 2020 10:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604485393;
        bh=XIGNh9RCMZMoSFJCaUx1N0X6ggZzBFfOMi7+ATIW1OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17d+z3y9mC1OF21xuTsCFDJ2lMGKX5m+VrQz0fpcFebSpaxCDl1ok7JqJmjhWAgF1
         ljZe9a6t4qT6yBhFok2dt+sGnuoDDvwvwvxKbUdNMqmama+3eOBizEGtYnvHw/mKBV
         k+Xw90paCxpURsIUwPHy481CJPpoBzn3PEg5t3lw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v3 net-next 2/5] net: page_pool: add bulk support for ptr_ring
Date:   Wed,  4 Nov 2020 11:22:55 +0100
Message-Id: <b8638a44f1aee8feb3a1f6b949653e2125eb0867.1604484917.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1604484917.git.lorenzo@kernel.org>
References: <cover.1604484917.git.lorenzo@kernel.org>
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
 include/net/page_pool.h | 26 ++++++++++++++++++++++++++
 net/core/page_pool.c    | 35 +++++++++++++++++++++++++++++++++++
 net/core/xdp.c          |  9 ++-------
 3 files changed, 63 insertions(+), 7 deletions(-)

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
index ef98372facf6..236c5ed3aa66 100644
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
@@ -408,6 +410,39 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
 }
 EXPORT_SYMBOL(page_pool_put_page);
 
+void page_pool_put_page_bulk(struct page_pool *pool, void **data,
+			     int count)
+{
+	int i, len = 0;
+
+	for (i = 0; i < count; i++) {
+		struct page *page = virt_to_head_page(data[i]);
+
+		if (likely(page_ref_count(page) == 1 &&
+			   pool_page_reusable(pool, page))) {
+			if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+				page_pool_dma_sync_for_device(pool, page, -1);
+
+			/* bulk pages for ptr_ring cache */
+			data[len++] = page;
+		} else {
+			page_pool_release_page(pool, page);
+			put_page(page);
+		}
+	}
+
+	/* Grab the producer spinlock for concurrent access to
+	 * ptr_ring page_pool cache
+	 */
+	page_pool_ring_lock(pool);
+	for (i = 0; i < len; i++) {
+		if (__ptr_ring_produce(&pool->ring, data[i]))
+			page_pool_return_page(pool, data[i]);
+	}
+	page_pool_ring_unlock(pool);
+}
+EXPORT_SYMBOL(page_pool_put_page_bulk);
+
 static void page_pool_empty_ring(struct page_pool *pool)
 {
 	struct page *page;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 66ac275a0360..ff7c801bd40c 100644
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
 	bq->count = 0;
 }
 EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
-- 
2.26.2

