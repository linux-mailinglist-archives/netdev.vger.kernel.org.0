Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D0F57C6E1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbiGUIxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiGUIxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:53:09 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813E37FE4E;
        Thu, 21 Jul 2022 01:53:07 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 60E971008B38D;
        Thu, 21 Jul 2022 16:44:45 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 404A820089230;
        Thu, 21 Jul 2022 16:44:45 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ASNR1t25gaag; Thu, 21 Jul 2022 16:44:45 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 738F4200BFDA8;
        Thu, 21 Jul 2022 16:44:33 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC 4/5] virtio: get desc id in order
Date:   Thu, 21 Jul 2022 16:43:40 +0800
Message-Id: <20220721084341.24183-5-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If in order feature negotiated, we can skip the used ring to get
buffer's desc id sequentially.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/virtio/virtio_ring.c | 37 ++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index a5ec724c0..4d57a4edc 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -144,6 +144,9 @@ struct vring_virtqueue {
 			/* DMA address and size information */
 			dma_addr_t queue_dma_addr;
 			size_t queue_size_in_bytes;
+
+			/* In order feature batch begin here */
+			u16 next_batch_desc_begin;
 		} split;
 
 		/* Available for packed ring */
@@ -700,8 +703,10 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 	}
 
 	vring_unmap_one_split(vq, i);
-	vq->split.desc_extra[i].next = vq->free_head;
-	vq->free_head = head;
+	if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {
+		vq->split.desc_extra[i].next = vq->free_head;
+		vq->free_head = head;
+	}
 
 	/* Plus final descriptor */
 	vq->vq.num_free++;
@@ -743,7 +748,8 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	void *ret;
-	unsigned int i;
+	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
+	unsigned int i, j;
 	u16 last_used;
 
 	START_USE(vq);
@@ -762,11 +768,24 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
 	/* Only get used array entries after they have been exposed by host. */
 	virtio_rmb(vq->weak_barriers);
 
-	last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
-	i = virtio32_to_cpu(_vq->vdev,
-			vq->split.vring.used->ring[last_used].id);
-	*len = virtio32_to_cpu(_vq->vdev,
-			vq->split.vring.used->ring[last_used].len);
+	if (virtio_has_feature(_vq->vdev, VIRTIO_F_IN_ORDER)) {
+		/* Skip used ring and get used desc in order*/
+		i = vq->split.next_batch_desc_begin;
+		j = i;
+		while (vq->split.vring.desc[j].flags & nextflag)
+			j = (j + 1) % vq->split.vring.num;
+		/* move to next */
+		j = (j + 1) % vq->split.vring.num;
+		vq->split.next_batch_desc_begin = j;
+
+		/* TODO: len of buffer */
+	} else {
+		last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
+		i = virtio32_to_cpu(_vq->vdev,
+				    vq->split.vring.used->ring[last_used].id);
+		*len = virtio32_to_cpu(_vq->vdev,
+				       vq->split.vring.used->ring[last_used].len);
+	}
 
 	if (unlikely(i >= vq->split.vring.num)) {
 		BAD_RING(vq, "id %u out of range\n", i);
@@ -2234,6 +2253,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->split.avail_flags_shadow = 0;
 	vq->split.avail_idx_shadow = 0;
 
+	vq->split.next_batch_desc_begin = 0;
+
 	/* No callback?  Tell other side not to bother us. */
 	if (!callback) {
 		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
-- 
2.17.1

