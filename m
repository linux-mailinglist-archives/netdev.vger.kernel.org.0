Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0674F687B3F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbjBBLBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjBBLBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:23 -0500
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC02B8717A;
        Thu,  2 Feb 2023 03:01:16 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VakkM2s_1675335670;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VakkM2s_1675335670)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:01:11 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 10/33] xsk: support virtio DMA map
Date:   Thu,  2 Feb 2023 19:00:35 +0800
Message-Id: <20230202110058.130695-11-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d7589ab6ea10
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When device is a virtio device, use virtio's DMA interface.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 net/xdp/xsk_buff_pool.c | 59 +++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 14 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 78e325e195fa..e2785aca8396 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -3,6 +3,7 @@
 #include <net/xsk_buff_pool.h>
 #include <net/xdp_sock.h>
 #include <net/xdp_sock_drv.h>
+#include <linux/virtio.h>
 
 #include "xsk_queue.h"
 #include "xdp_umem.h"
@@ -334,8 +335,12 @@ static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
 		dma = &dma_map->dma_pages[i];
 		if (*dma) {
 			*dma &= ~XSK_NEXT_PG_CONTIG_MASK;
-			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
-					     DMA_BIDIRECTIONAL, attrs);
+			if (is_virtio_device(dma_map->dev))
+				virtio_dma_unmap(dma_map->dev, *dma, PAGE_SIZE,
+						 DMA_BIDIRECTIONAL);
+			else
+				dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
+						     DMA_BIDIRECTIONAL, attrs);
 			*dma = 0;
 		}
 	}
@@ -435,22 +440,40 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 		return 0;
 	}
 
-	pool->dma_sync_for_cpu = dma_sync_for_cpu;
-	pool->dma_sync_for_device = dma_sync_for_device;
+	if (is_virtio_device(dev)) {
+		pool->dma_sync_for_cpu = virtio_dma_sync_signle_range_for_cpu;
+		pool->dma_sync_for_device = virtio_dma_sync_signle_range_for_device;
+
+	} else {
+		pool->dma_sync_for_cpu = dma_sync_for_cpu;
+		pool->dma_sync_for_device = dma_sync_for_device;
+	}
 
 	dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
 	if (!dma_map)
 		return -ENOMEM;
 
 	for (i = 0; i < dma_map->dma_pages_cnt; i++) {
-		dma = dma_map_page_attrs(dev, pages[i], 0, PAGE_SIZE,
-					 DMA_BIDIRECTIONAL, attrs);
-		if (dma_mapping_error(dev, dma)) {
-			__xp_dma_unmap(dma_map, attrs);
-			return -ENOMEM;
+		if (is_virtio_device(dev)) {
+			dma = virtio_dma_map_page(dev, pages[i], 0, PAGE_SIZE,
+						  DMA_BIDIRECTIONAL);
+
+			if (virtio_dma_mapping_error(dev, dma))
+				goto err;
+
+			if (virtio_dma_need_sync(dev, dma))
+				dma_map->dma_need_sync = true;
+
+		} else {
+			dma = dma_map_page_attrs(dev, pages[i], 0, PAGE_SIZE,
+						 DMA_BIDIRECTIONAL, attrs);
+
+			if (dma_mapping_error(dev, dma))
+				goto err;
+
+			if (dma_need_sync(dev, dma))
+				dma_map->dma_need_sync = true;
 		}
-		if (dma_need_sync(dev, dma))
-			dma_map->dma_need_sync = true;
 		dma_map->dma_pages[i] = dma;
 	}
 
@@ -464,6 +487,9 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	}
 
 	return 0;
+err:
+	__xp_dma_unmap(dma_map, attrs);
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(xp_dma_map);
 
@@ -546,9 +572,14 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
 	xskb->xdp.data_meta = xskb->xdp.data;
 
 	if (pool->dma_need_sync) {
-		dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
-						 pool->frame_len,
-						 DMA_BIDIRECTIONAL);
+		if (is_virtio_device(pool->dev))
+			virtio_dma_sync_signle_range_for_device(pool->dev, xskb->dma, 0,
+								pool->frame_len,
+								DMA_BIDIRECTIONAL);
+		else
+			dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
+							 pool->frame_len,
+							 DMA_BIDIRECTIONAL);
 	}
 	return &xskb->xdp;
 }
-- 
2.32.0.3.g01195cf9f

