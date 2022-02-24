Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE054C2A2A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiBXLEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiBXLEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:04:46 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0138928F97D;
        Thu, 24 Feb 2022 03:04:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5Nr1si_1645700652;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V5Nr1si_1645700652)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 19:04:13 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v2 9/9] virtio_net: xdp xmit use virtio dma api
Date:   Thu, 24 Feb 2022 19:04:02 +0800
Message-Id: <20220224110402.108161-10-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
References: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d02e086a8668
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP xmit uses virtio dma api for DMA operations. No longer let virtio
core manage DMA address.

To record the DMA address, allocate a space in the xdp_frame headroom to
store the DMA address.

Introduce virtnet_return_xdp_frame() to release the xdp frame and
complete the dma unmap operation.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 42 +++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a801ea40908f..0efbf7992a95 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -321,6 +321,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
 	return p;
 }
 
+static void virtnet_return_xdp_frame(struct send_queue *sq,
+				     struct xdp_frame *frame)
+{
+	struct virtnet_info *vi = sq->vq->vdev->priv;
+	dma_addr_t *p_addr, addr;
+
+	p_addr = frame->data - sizeof(*p_addr);
+	addr = *p_addr;
+
+	virtio_dma_unmap(&vi->vdev->dev, addr, frame->len, DMA_TO_DEVICE);
+
+	xdp_return_frame(frame);
+}
+
 static void virtqueue_napi_schedule(struct napi_struct *napi,
 				    struct virtqueue *vq)
 {
@@ -504,9 +518,11 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 				   struct xdp_frame *xdpf)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
+	struct device *dev = &vi->vdev->dev;
+	dma_addr_t addr, *p_addr;
 	int err;
 
-	if (unlikely(xdpf->headroom < vi->hdr_len))
+	if (unlikely(xdpf->headroom < vi->hdr_len + sizeof(addr)))
 		return -EOVERFLOW;
 
 	/* Make room for virtqueue hdr (also change xdpf->headroom?) */
@@ -516,10 +532,21 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 	memset(hdr, 0, vi->hdr_len);
 	xdpf->len   += vi->hdr_len;
 
-	sg_init_one(sq->sg, xdpf->data, xdpf->len);
+	p_addr = xdpf->data - sizeof(addr);
+
+	addr = virtio_dma_map(dev, xdpf->data, xdpf->len, DMA_TO_DEVICE);
+
+	if (virtio_dma_mapping_error(dev, addr))
+		return -ENOMEM;
+
+	*p_addr = addr;
+
+	sg_init_table(sq->sg, 1);
+	sq->sg->dma_address = addr;
+	sq->sg->length = xdpf->len;
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, 1, xdp_to_ptr(xdpf),
-				   GFP_ATOMIC);
+	err = virtqueue_add_outbuf_premapped(sq->vq, sq->sg, 1,
+					     xdp_to_ptr(xdpf), GFP_ATOMIC);
 	if (unlikely(err))
 		return -ENOSPC; /* Caller handle free/refcnt */
 
@@ -600,7 +627,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 			struct xdp_frame *frame = ptr_to_xdp(ptr);
 
 			bytes += frame->len;
-			xdp_return_frame(frame);
+			virtnet_return_xdp_frame(sq, frame);
 		} else {
 			struct sk_buff *skb = ptr;
 
@@ -1486,7 +1513,7 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 			struct xdp_frame *frame = ptr_to_xdp(ptr);
 
 			bytes += frame->len;
-			xdp_return_frame(frame);
+			virtnet_return_xdp_frame(sq, frame);
 		}
 		packets++;
 	}
@@ -2815,7 +2842,8 @@ static void free_unused_bufs(struct virtnet_info *vi)
 			if (!is_xdp_frame(buf))
 				dev_kfree_skb(buf);
 			else
-				xdp_return_frame(ptr_to_xdp(buf));
+				virtnet_return_xdp_frame(vi->sq + i,
+							 ptr_to_xdp(buf));
 		}
 	}
 
-- 
2.31.0

