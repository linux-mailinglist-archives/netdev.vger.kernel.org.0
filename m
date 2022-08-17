Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD20597097
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbiHQN7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239884AbiHQN7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:59:21 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6527589917;
        Wed, 17 Aug 2022 06:59:11 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 9A62A1008B38F;
        Wed, 17 Aug 2022 21:58:48 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 052AA2009BEAD;
        Wed, 17 Aug 2022 21:58:48 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9ZmfqEkD5H1c; Wed, 17 Aug 2022 21:58:47 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id EB8352009BEA0;
        Wed, 17 Aug 2022 21:58:35 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v2 6/7] virtio: in order support for virtio_ring
Date:   Wed, 17 Aug 2022 21:57:17 +0800
Message-Id: <20220817135718.2553-7-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If in order feature negotiated, we can skip the used ring to get
buffer's desc id sequentially.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1c1b3fa376a2..143184ebb5a1 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -144,6 +144,9 @@ struct vring_virtqueue {
 			/* DMA address and size information */
 			dma_addr_t queue_dma_addr;
 			size_t queue_size_in_bytes;
+
+			/* In order feature batch begin here */
+			u16 next_desc_begin;
 		} split;
 
 		/* Available for packed ring */
@@ -702,8 +705,13 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 	}
 
 	vring_unmap_one_split(vq, i);
-	vq->split.desc_extra[i].next = vq->free_head;
-	vq->free_head = head;
+	/* In order feature use desc in order,
+	 * that means, the next desc will always be free
+	 */
+	if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {
+		vq->split.desc_extra[i].next = vq->free_head;
+		vq->free_head = head;
+	}
 
 	/* Plus final descriptor */
 	vq->vq.num_free++;
@@ -745,7 +753,7 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	void *ret;
-	unsigned int i;
+	unsigned int i, j;
 	u16 last_used;
 
 	START_USE(vq);
@@ -764,11 +772,38 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
 	/* Only get used array entries after they have been exposed by host. */
 	virtio_rmb(vq->weak_barriers);
 
-	last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
-	i = virtio32_to_cpu(_vq->vdev,
-			vq->split.vring.used->ring[last_used].id);
-	*len = virtio32_to_cpu(_vq->vdev,
-			vq->split.vring.used->ring[last_used].len);
+	if (virtio_has_feature(_vq->vdev, VIRTIO_F_IN_ORDER)) {
+		/* Skip used ring and get used desc in order*/
+		i = vq->split.next_desc_begin;
+		j = i;
+		/* Indirect only takes one descriptor in descriptor table */
+		while (!vq->indirect && (vq->split.desc_extra[j].flags & VRING_DESC_F_NEXT))
+			j = (j + 1) % vq->split.vring.num;
+		/* move to next */
+		j = (j + 1) % vq->split.vring.num;
+		/* Next buffer will use this descriptor in order */
+		vq->split.next_desc_begin = j;
+		if (!vq->indirect) {
+			*len = vq->split.desc_extra[i].len;
+		} else {
+			struct vring_desc *indir_desc =
+				vq->split.desc_state[i].indir_desc;
+			u32 indir_num = vq->split.desc_extra[i].len, buffer_len = 0;
+
+			if (indir_desc) {
+				for (j = 0; j < indir_num / sizeof(struct vring_desc); j++)
+					buffer_len += indir_desc[j].len;
+			}
+
+			*len = buffer_len;
+		}
+	} else {
+		last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
+		i = virtio32_to_cpu(_vq->vdev,
+				    vq->split.vring.used->ring[last_used].id);
+		*len = virtio32_to_cpu(_vq->vdev,
+				       vq->split.vring.used->ring[last_used].len);
+	}
 
 	if (unlikely(i >= vq->split.vring.num)) {
 		BAD_RING(vq, "id %u out of range\n", i);
@@ -2236,6 +2271,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->split.avail_flags_shadow = 0;
 	vq->split.avail_idx_shadow = 0;
 
+	vq->split.next_desc_begin = 0;
+
 	/* No callback?  Tell other side not to bother us. */
 	if (!callback) {
 		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
-- 
2.17.1

