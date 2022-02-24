Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9B54C2A2C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiBXLEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiBXLEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:04:41 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D45328F970;
        Thu, 24 Feb 2022 03:04:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5Nr1rv_1645700648;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V5Nr1rv_1645700648)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 19:04:08 +0800
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
Subject: [PATCH v2 5/9] virtio_ring: split: virtqueue_add_split() support premapped
Date:   Thu, 24 Feb 2022 19:03:58 +0800
Message-Id: <20220224110402.108161-6-xuanzhuo@linux.alibaba.com>
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

virtqueue_add_split() only supports virtual addresses, dma is completed
in virtqueue_add_split().

In some scenarios (such as the AF_XDP scenario), the memory is allocated
and DMA is completed in advance, so it is necessary for us to support
passing the DMA address to virtqueue_add_split().

And record this premapped information in desc_extra[head]->premapped,
which can be skipped when executing dma unmap.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 58 +++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 2f9572c3628c..35cb804dcf2d 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -83,6 +83,7 @@ struct vring_desc_extra {
 	u32 len;			/* Descriptor length. */
 	u16 flags;			/* Descriptor flags. */
 	u16 next;			/* The next desc state in a list. */
+	bool premapped;
 };
 
 struct vring_virtqueue {
@@ -387,7 +388,7 @@ static void vring_unmap_one_split_indirect(const struct vring_virtqueue *vq,
 }
 
 static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
-					  unsigned int i)
+					  unsigned int i, bool premapped)
 {
 	struct vring_desc_extra *extra = vq->split.desc_extra;
 	u16 flags;
@@ -404,6 +405,9 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 				 (flags & VRING_DESC_F_WRITE) ?
 				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	} else {
+		if (premapped)
+			goto out;
+
 		dma_unmap_page(vring_dma_dev(vq),
 			       extra[i].addr,
 			       extra[i].len,
@@ -474,7 +478,8 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 				      unsigned int in_sgs,
 				      void *data,
 				      void *ctx,
-				      gfp_t gfp)
+				      gfp_t gfp,
+				      bool premapped)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	struct scatterlist *sg;
@@ -535,9 +540,16 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 
 	for (n = 0; n < out_sgs; n++) {
 		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
-			dma_addr_t addr = vring_map_one_sg(vq, sg, DMA_TO_DEVICE);
-			if (vring_mapping_error(vq, addr))
-				goto unmap_release;
+			dma_addr_t addr;
+
+			if (premapped) {
+				addr = sg_dma_address(sg);
+
+			} else {
+				addr = vring_map_one_sg(vq, sg, DMA_TO_DEVICE);
+				if (vring_mapping_error(vq, addr))
+					goto unmap_release;
+			}
 
 			prev = i;
 			/* Note that we trust indirect descriptor
@@ -550,9 +562,16 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	}
 	for (; n < (out_sgs + in_sgs); n++) {
 		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
-			dma_addr_t addr = vring_map_one_sg(vq, sg, DMA_FROM_DEVICE);
-			if (vring_mapping_error(vq, addr))
-				goto unmap_release;
+			dma_addr_t addr;
+
+			if (premapped) {
+				addr = sg_dma_address(sg);
+
+			} else {
+				addr = vring_map_one_sg(vq, sg, DMA_FROM_DEVICE);
+				if (vring_mapping_error(vq, addr))
+					goto unmap_release;
+			}
 
 			prev = i;
 			/* Note that we trust indirect descriptor
@@ -602,6 +621,8 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	else
 		vq->split.desc_state[head].indir_desc = ctx;
 
+	vq->split.desc_extra[head].premapped = premapped;
+
 	/* Put entry in available array (but don't update avail->idx until they
 	 * do sync). */
 	avail = vq->split.avail_idx_shadow & (vq->split.vring.num - 1);
@@ -626,6 +647,9 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	return 0;
 
 unmap_release:
+	if (premapped)
+		goto unmap_free;
+
 	err_idx = i;
 
 	if (indirect)
@@ -640,9 +664,10 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 			vring_unmap_one_split_indirect(vq, &desc[i]);
 			i = virtio16_to_cpu(_vq->vdev, desc[i].next);
 		} else
-			i = vring_unmap_one_split(vq, i);
+			i = vring_unmap_one_split(vq, i, false);
 	}
 
+unmap_free:
 	if (indirect)
 		kfree(desc);
 
@@ -686,20 +711,23 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 {
 	unsigned int i, j;
 	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
+	bool premapped;
 
 	/* Clear data ptr. */
 	vq->split.desc_state[head].data = NULL;
 
+	premapped = vq->split.desc_extra[head].premapped;
+
 	/* Put back on free list: unmap first-level descriptors and find end */
 	i = head;
 
 	while (vq->split.vring.desc[i].flags & nextflag) {
-		vring_unmap_one_split(vq, i);
+		vring_unmap_one_split(vq, i, premapped);
 		i = vq->split.desc_extra[i].next;
 		vq->vq.num_free++;
 	}
 
-	vring_unmap_one_split(vq, i);
+	vring_unmap_one_split(vq, i, premapped);
 	vq->split.desc_extra[i].next = vq->free_head;
 	vq->free_head = head;
 
@@ -721,8 +749,10 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 				VRING_DESC_F_INDIRECT));
 		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
 
-		for (j = 0; j < len / sizeof(struct vring_desc); j++)
-			vring_unmap_one_split_indirect(vq, &indir_desc[j]);
+		if (!premapped) {
+			for (j = 0; j < len / sizeof(struct vring_desc); j++)
+				vring_unmap_one_split_indirect(vq, &indir_desc[j]);
+		}
 
 		kfree(indir_desc);
 		vq->split.desc_state[head].indir_desc = NULL;
@@ -1788,7 +1818,7 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 	return vq->packed_ring ? virtqueue_add_packed(_vq, sgs, total_sg,
 					out_sgs, in_sgs, data, ctx, gfp) :
 				 virtqueue_add_split(_vq, sgs, total_sg,
-					out_sgs, in_sgs, data, ctx, gfp);
+					out_sgs, in_sgs, data, ctx, gfp, premapped);
 }
 
 /**
-- 
2.31.0

