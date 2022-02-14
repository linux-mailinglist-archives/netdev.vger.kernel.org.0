Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329A34B438C
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241643AbiBNIO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:14:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241640AbiBNIOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:14:50 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47E75FF0E;
        Mon, 14 Feb 2022 00:14:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4O5x8V_1644826461;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4O5x8V_1644826461)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:22 +0800
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
Subject: [PATCH v5 05/22] virtio_ring: queue_reset: split: support enable reset queue
Date:   Mon, 14 Feb 2022 16:13:59 +0800
Message-Id: <20220214081416.117695-6-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 24fd8391539b
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

The purpose of this patch is to make vring split support re-enable reset
vq.

Based on whether the incoming vq passed by vring_setup_virtqueue() is
NULL or not, distinguish whether it is a normal create virtqueue or
re-enable a reset queue.

When re-enable a reset queue, reuse the original callback, name,
indirect.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 52 +++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 9cfbe45ab286..4639e1643c78 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -198,6 +198,16 @@ struct vring_virtqueue {
 #endif
 };
 
+static int __vring_init_virtqueue(struct virtqueue *_vq,
+				  unsigned int index,
+				  struct vring vring,
+				  struct virtio_device *vdev,
+				  bool weak_barriers,
+				  bool context,
+				  bool (*notify)(struct virtqueue *),
+				  void (*callback)(struct virtqueue *),
+				  const char *name,
+				  bool reset);
 
 /*
  * Helpers.
@@ -925,9 +935,9 @@ static struct virtqueue *vring_create_virtqueue_split(
 	bool context,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
-	const char *name)
+	const char *name,
+	struct virtqueue *vq)
 {
-	struct virtqueue *vq;
 	void *queue = NULL;
 	dma_addr_t dma_addr;
 	size_t queue_size_in_bytes;
@@ -964,12 +974,17 @@ static struct virtqueue *vring_create_virtqueue_split(
 	queue_size_in_bytes = vring_size(num, vring_align);
 	vring_init(&vring, num, queue, vring_align);
 
-	vq = __vring_new_virtqueue(index, vring, vdev, weak_barriers, context,
-				   notify, callback, name);
 	if (!vq) {
-		vring_free_queue(vdev, queue_size_in_bytes, queue,
-				 dma_addr);
-		return NULL;
+		vq = __vring_new_virtqueue(index, vring, vdev, weak_barriers,
+					   context, notify, callback, name);
+		if (!vq)
+			goto err;
+
+	} else {
+		if (__vring_init_virtqueue(vq, index, vring, vdev,
+					   weak_barriers, context, notify,
+					   callback, name, true))
+			goto err;
 	}
 
 	to_vvq(vq)->split.queue_dma_addr = dma_addr;
@@ -977,6 +992,9 @@ static struct virtqueue *vring_create_virtqueue_split(
 	to_vvq(vq)->we_own_ring = true;
 
 	return vq;
+err:
+	vring_free_queue(vdev, queue_size_in_bytes, queue, dma_addr);
+	return NULL;
 }
 
 
@@ -2177,14 +2195,20 @@ static int __vring_init_virtqueue(struct virtqueue *_vq,
 				  bool context,
 				  bool (*notify)(struct virtqueue *),
 				  void (*callback)(struct virtqueue *),
-				  const char *name)
+				  const char *name,
+				  bool reset)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	if (!reset) {
+		vq->vq.callback = callback;
+		vq->vq.name = name;
+		vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
+			!context;
+	}
+
 	vq->packed_ring = false;
-	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
-	vq->vq.name = name;
 	vq->vq.num_free = vring.num;
 	vq->vq.index = index;
 	vq->we_own_ring = false;
@@ -2200,8 +2224,6 @@ static int __vring_init_virtqueue(struct virtqueue *_vq,
 	vq->last_add_time_valid = false;
 #endif
 
-	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
-		!context;
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
@@ -2215,7 +2237,7 @@ static int __vring_init_virtqueue(struct virtqueue *_vq,
 	vq->split.avail_idx_shadow = 0;
 
 	/* No callback?  Tell other side not to bother us. */
-	if (!callback) {
+	if (!vq->vq.callback) {
 		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
 		if (!vq->event)
 			vq->split.vring.avail->flags = cpu_to_virtio16(vdev,
@@ -2267,7 +2289,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 		return NULL;
 
 	err = __vring_init_virtqueue(&vq->vq, index, vring, vdev, weak_barriers,
-				     context, notify, callback, name);
+				     context, notify, callback, name, false);
 
 	if (err) {
 		kfree(vq);
@@ -2299,7 +2321,7 @@ struct virtqueue *vring_setup_virtqueue(
 
 	return vring_create_virtqueue_split(index, num, vring_align,
 			vdev, weak_barriers, may_reduce_num,
-			context, notify, callback, name);
+			context, notify, callback, name, vq);
 }
 EXPORT_SYMBOL_GPL(vring_setup_virtqueue);
 
-- 
2.31.0

