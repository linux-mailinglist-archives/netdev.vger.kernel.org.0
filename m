Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE33B6E3DF9
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 05:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjDQD17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 23:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDQD16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 23:27:58 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D3F2716;
        Sun, 16 Apr 2023 20:27:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0VgBt9Ys_1681702070;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgBt9Ys_1681702070)
          by smtp.aliyun-inc.com;
          Mon, 17 Apr 2023 11:27:51 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Mon, 17 Apr 2023 11:27:50 +0800
Message-Id: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
MIME-Version: 1.0
X-Git-Hash: 60759681f964
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to allow driver pass the own dma_ops to
xsk.

This is to cope with the scene of virtio-net. If virtio does not have
VIRTIO_F_ACCESS_PLATFORM, then virtio cannot use DMA API. In this case,
XSK cannot use DMA API directly to achieve DMA address. Based on this
scene, we must let XSK support driver to use the driver's dma_ops.

On the other hand, the implementation of XSK as a highlevel code
should put the underlying operation of DMA to the driver layer.
The driver layer determines the implementation of the final DMA. XSK
should not make such assumptions. Everything will be simplified if DMA
is done at the driver level.

More is here:
    https://lore.kernel.org/virtualization/1681265026.6082013-1-xuanzhuo@linux.alibaba.com/

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/net/xdp_sock_drv.h  | 20 +++++++++++++++-
 include/net/xsk_buff_pool.h | 19 +++++++++++++++
 net/xdp/xsk_buff_pool.c     | 47 +++++++++++++++++++++++--------------
 3 files changed, 68 insertions(+), 18 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 9c0d860609ba..181583ff6a26 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -67,7 +67,17 @@ static inline int xsk_pool_dma_map(struct xsk_buff_pool *pool,
 {
 	struct xdp_umem *umem = pool->umem;
 
-	return xp_dma_map(pool, dev, attrs, umem->pgs, umem->npgs);
+	return xp_dma_map(pool, dev, NULL, attrs, umem->pgs, umem->npgs);
+}
+
+static inline int xsk_pool_dma_map_with_ops(struct xsk_buff_pool *pool,
+					    struct device *dev,
+					    struct xsk_dma_ops *dma_ops,
+					    unsigned long attrs)
+{
+	struct xdp_umem *umem = pool->umem;
+
+	return xp_dma_map(pool, dev, dma_ops, attrs, umem->pgs, umem->npgs);
 }
 
 static inline dma_addr_t xsk_buff_xdp_get_dma(struct xdp_buff *xdp)
@@ -226,6 +236,14 @@ static inline int xsk_pool_dma_map(struct xsk_buff_pool *pool,
 	return 0;
 }
 
+static inline int xsk_pool_dma_map_with_ops(struct xsk_buff_pool *pool,
+					    struct device *dev,
+					    struct xsk_dma_ops *dma_ops,
+					    unsigned long attrs)
+{
+	return 0;
+}
+
 static inline dma_addr_t xsk_buff_xdp_get_dma(struct xdp_buff *xdp)
 {
 	return 0;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 3e952e569418..1299b9d12484 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -43,6 +43,23 @@ struct xsk_dma_map {
 	bool dma_need_sync;
 };
 
+struct xsk_dma_ops {
+	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction dir, unsigned long attrs);
+	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
+			   size_t size, enum dma_data_direction dir,
+			   unsigned long attrs);
+	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
+	bool (*need_sync)(struct device *dev, dma_addr_t dma);
+	void (*sync_single_range_for_cpu)(struct device *dev, dma_addr_t addr,
+					  unsigned long offset, size_t size,
+					  enum dma_data_direction dir);
+	void (*sync_single_range_for_device)(struct device *dev, dma_addr_t addr,
+					     unsigned long offset, size_t size,
+					     enum dma_data_direction dir);
+};
+
 struct xsk_buff_pool {
 	/* Members only used in the control path first. */
 	struct device *dev;
@@ -85,6 +102,7 @@ struct xsk_buff_pool {
 	 * sockets share a single cq when the same netdev and queue id is shared.
 	 */
 	spinlock_t cq_lock;
+	struct xsk_dma_ops dma_ops;
 	struct xdp_buff_xsk *free_heads[];
 };
 
@@ -131,6 +149,7 @@ static inline void xp_init_xskb_dma(struct xdp_buff_xsk *xskb, struct xsk_buff_p
 /* AF_XDP ZC drivers, via xdp_sock_buff.h */
 void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq);
 int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
+	       struct xsk_dma_ops *dma_ops,
 	       unsigned long attrs, struct page **pages, u32 nr_pages);
 void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs);
 struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index b2df1e0f8153..646090cae8ec 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -328,7 +328,8 @@ static void xp_destroy_dma_map(struct xsk_dma_map *dma_map)
 	kfree(dma_map);
 }
 
-static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
+static void __xp_dma_unmap(struct xsk_dma_map *dma_map,
+			   struct xsk_dma_ops *dma_ops, unsigned long attrs)
 {
 	dma_addr_t *dma;
 	u32 i;
@@ -337,8 +338,8 @@ static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
 		dma = &dma_map->dma_pages[i];
 		if (*dma) {
 			*dma &= ~XSK_NEXT_PG_CONTIG_MASK;
-			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
-					     DMA_BIDIRECTIONAL, attrs);
+			dma_ops->unmap_page(dma_map->dev, *dma, PAGE_SIZE,
+					    DMA_BIDIRECTIONAL, attrs);
 			*dma = 0;
 		}
 	}
@@ -362,7 +363,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 	if (!refcount_dec_and_test(&dma_map->users))
 		return;
 
-	__xp_dma_unmap(dma_map, attrs);
+	__xp_dma_unmap(dma_map, &pool->dma_ops, attrs);
 	kvfree(pool->dma_pages);
 	pool->dma_pages_cnt = 0;
 	pool->dev = NULL;
@@ -407,6 +408,7 @@ static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_
 }
 
 int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
+	       struct xsk_dma_ops *dma_ops,
 	       unsigned long attrs, struct page **pages, u32 nr_pages)
 {
 	struct xsk_dma_map *dma_map;
@@ -424,18 +426,29 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 		return 0;
 	}
 
+	if (!dma_ops) {
+		pool->dma_ops.map_page = dma_map_page_attrs;
+		pool->dma_ops.mapping_error = dma_mapping_error;
+		pool->dma_ops.need_sync = dma_need_sync;
+		pool->dma_ops.sync_single_range_for_device = dma_sync_single_range_for_device;
+		pool->dma_ops.sync_single_range_for_cpu = dma_sync_single_range_for_cpu;
+		dma_ops = &pool->dma_ops;
+	} else {
+		pool->dma_ops = *dma_ops;
+	}
+
 	dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
 	if (!dma_map)
 		return -ENOMEM;
 
 	for (i = 0; i < dma_map->dma_pages_cnt; i++) {
-		dma = dma_map_page_attrs(dev, pages[i], 0, PAGE_SIZE,
-					 DMA_BIDIRECTIONAL, attrs);
-		if (dma_mapping_error(dev, dma)) {
-			__xp_dma_unmap(dma_map, attrs);
+		dma = dma_ops->map_page(dev, pages[i], 0, PAGE_SIZE,
+					DMA_BIDIRECTIONAL, attrs);
+		if (dma_ops->mapping_error(dev, dma)) {
+			__xp_dma_unmap(dma_map, dma_ops, attrs);
 			return -ENOMEM;
 		}
-		if (dma_need_sync(dev, dma))
+		if (dma_ops->need_sync(dev, dma))
 			dma_map->dma_need_sync = true;
 		dma_map->dma_pages[i] = dma;
 	}
@@ -445,7 +458,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 
 	err = xp_init_dma_info(pool, dma_map);
 	if (err) {
-		__xp_dma_unmap(dma_map, attrs);
+		__xp_dma_unmap(dma_map, dma_ops, attrs);
 		return err;
 	}
 
@@ -532,9 +545,9 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
 	xskb->xdp.data_meta = xskb->xdp.data;
 
 	if (pool->dma_need_sync) {
-		dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
-						 pool->frame_len,
-						 DMA_BIDIRECTIONAL);
+		pool->dma_ops.sync_single_range_for_device(pool->dev, xskb->dma, 0,
+							   pool->frame_len,
+							   DMA_BIDIRECTIONAL);
 	}
 	return &xskb->xdp;
 }
@@ -670,15 +683,15 @@ EXPORT_SYMBOL(xp_raw_get_dma);
 
 void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb)
 {
-	dma_sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
-				      xskb->pool->frame_len, DMA_BIDIRECTIONAL);
+	xskb->pool->dma_ops.sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
+						      xskb->pool->frame_len, DMA_BIDIRECTIONAL);
 }
 EXPORT_SYMBOL(xp_dma_sync_for_cpu_slow);
 
 void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
 				 size_t size)
 {
-	dma_sync_single_range_for_device(pool->dev, dma, 0,
-					 size, DMA_BIDIRECTIONAL);
+	pool->dma_ops.sync_single_range_for_device(pool->dev, dma, 0,
+						   size, DMA_BIDIRECTIONAL);
 }
 EXPORT_SYMBOL(xp_dma_sync_for_device_slow);
-- 
2.32.0.3.g01195cf9f

