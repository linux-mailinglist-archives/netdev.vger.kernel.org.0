Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989114C2A28
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiBXLEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbiBXLEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:04:37 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149EE28F969;
        Thu, 24 Feb 2022 03:04:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5Nr1qt_1645700643;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V5Nr1qt_1645700643)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 19:04:04 +0800
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
Subject: [PATCH v2 1/9] virtio_ring: rename vring_unmap_state_packed() to vring_unmap_extra_packed()
Date:   Thu, 24 Feb 2022 19:03:54 +0800
Message-Id: <20220224110402.108161-2-xuanzhuo@linux.alibaba.com>
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

The actual parameter handled by vring_unmap_state_packed() is that
vring_desc_extra, so this function should use "extra" instead of "state".

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 962f1477b1fa..7cf3ae057833 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -984,24 +984,24 @@ static struct virtqueue *vring_create_virtqueue_split(
  * Packed ring specific functions - *_packed().
  */
 
-static void vring_unmap_state_packed(const struct vring_virtqueue *vq,
-				     struct vring_desc_extra *state)
+static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
+				     struct vring_desc_extra *extra)
 {
 	u16 flags;
 
 	if (!vq->use_dma_api)
 		return;
 
-	flags = state->flags;
+	flags = extra->flags;
 
 	if (flags & VRING_DESC_F_INDIRECT) {
 		dma_unmap_single(vring_dma_dev(vq),
-				 state->addr, state->len,
+				 extra->addr, extra->len,
 				 (flags & VRING_DESC_F_WRITE) ?
 				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	} else {
 		dma_unmap_page(vring_dma_dev(vq),
-			       state->addr, state->len,
+			       extra->addr, extra->len,
 			       (flags & VRING_DESC_F_WRITE) ?
 			       DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	}
@@ -1303,8 +1303,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 	for (n = 0; n < total_sg; n++) {
 		if (i == err_idx)
 			break;
-		vring_unmap_state_packed(vq,
-					 &vq->packed.desc_extra[curr]);
+		vring_unmap_extra_packed(vq, &vq->packed.desc_extra[curr]);
 		curr = vq->packed.desc_extra[curr].next;
 		i++;
 		if (i >= vq->packed.vring.num)
@@ -1383,8 +1382,8 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
 	if (unlikely(vq->use_dma_api)) {
 		curr = id;
 		for (i = 0; i < state->num; i++) {
-			vring_unmap_state_packed(vq,
-				&vq->packed.desc_extra[curr]);
+			vring_unmap_extra_packed(vq,
+						 &vq->packed.desc_extra[curr]);
 			curr = vq->packed.desc_extra[curr].next;
 		}
 	}
-- 
2.31.0

