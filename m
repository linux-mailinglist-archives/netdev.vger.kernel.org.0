Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ACC43DF34
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 12:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhJ1Kvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 06:51:50 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:42025 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230126AbhJ1Kvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 06:51:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uu.SeFY_1635418160;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Uu.SeFY_1635418160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 18:49:20 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 2/3] virtio: cache indirect desc for packed
Date:   Thu, 28 Oct 2021 18:49:18 +0800
Message-Id: <20211028104919.3393-3-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211028104919.3393-1-xuanzhuo@linux.alibaba.com>
References: <20211028104919.3393-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of using indirect, indirect desc must be allocated and
released each time, which increases a lot of cpu overhead.

Here, a cache is added for indirect. If the number of indirect desc to be
applied for is less than VIRT_QUEUE_CACHE_DESC_NUM, the desc array with
the size of VIRT_QUEUE_CACHE_DESC_NUM is fixed and cached for reuse.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 0ebcd4f12d3b..e6d1985a87a8 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1089,7 +1089,11 @@ static void vring_unmap_desc_packed(const struct vring_virtqueue *vq,
 	}
 }
 
-static struct vring_packed_desc *alloc_indirect_packed(unsigned int total_sg,
+#define desc_cache_get_packed(vq, n, gfp) \
+	_desc_cache_get(vq, n, gfp, struct vring_packed_desc)
+
+static struct vring_packed_desc *alloc_indirect_packed(struct vring_virtqueue *vq,
+						       unsigned int total_sg,
 						       gfp_t gfp)
 {
 	struct vring_packed_desc *desc;
@@ -1101,7 +1105,7 @@ static struct vring_packed_desc *alloc_indirect_packed(unsigned int total_sg,
 	 */
 	gfp &= ~__GFP_HIGHMEM;
 
-	desc = kmalloc_array(total_sg, sizeof(struct vring_packed_desc), gfp);
+	desc = desc_cache_get_packed(vq, total_sg, gfp);
 
 	return desc;
 }
@@ -1121,7 +1125,7 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	dma_addr_t addr;
 
 	head = vq->packed.next_avail_idx;
-	desc = alloc_indirect_packed(total_sg, gfp);
+	desc = alloc_indirect_packed(vq, total_sg, gfp);
 
 	if (unlikely(vq->vq.num_free < 1)) {
 		pr_debug("Can't add buf len 1 - avail = 0\n");
@@ -1212,7 +1216,7 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	for (i = 0; i < err_idx; i++)
 		vring_unmap_desc_packed(vq, &desc[i]);
 
-	kfree(desc);
+	desc_cache_put(vq, desc, total_sg);
 
 	END_USE(vq);
 	return -ENOMEM;
@@ -1437,20 +1441,22 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
 	}
 
 	if (vq->indirect) {
-		u32 len;
+		u32 len, n;
 
 		/* Free the indirect table, if any, now that it's unmapped. */
 		desc = state->indir_desc;
 		if (!desc)
 			return;
 
+		len = vq->packed.desc_extra[id].len;
+		n = len / sizeof(struct vring_packed_desc);
+
 		if (vq->use_dma_api) {
-			len = vq->packed.desc_extra[id].len;
-			for (i = 0; i < len / sizeof(struct vring_packed_desc);
-					i++)
+			for (i = 0; i < n; i++)
 				vring_unmap_desc_packed(vq, &desc[i]);
 		}
-		kfree(desc);
+
+		desc_cache_put(vq, desc, n);
 		state->indir_desc = NULL;
 	} else if (ctx) {
 		*ctx = state->indir_desc;
@@ -1768,6 +1774,9 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
+	vq->desc_cache_thr = vdev->desc_cache_thr;
+
+	INIT_LIST_HEAD(&vq->desc_cache);
 
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
@@ -2389,8 +2398,8 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 	if (!vq->packed_ring) {
 		kfree(vq->split.desc_state);
 		kfree(vq->split.desc_extra);
-		desc_cache_free(&vq->desc_cache);
 	}
+	desc_cache_free(&vq->desc_cache);
 	kfree(vq);
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
-- 
2.31.0

