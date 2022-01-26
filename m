Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64C49C480
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbiAZHf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:35:59 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:40438 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237900AbiAZHfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2ubkkL_1643182540;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2ubkkL_1643182540)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:41 +0800
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
Subject: [PATCH v3 07/17] virtio_ring: queue_reset: split: support enable reset queue
Date:   Wed, 26 Jan 2022 15:35:23 +0800
Message-Id: <20220126073533.44994-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to make vring split support re-enable reset
vq.

The core idea is that when calling vring_create_virtqueue_split, use the
existing vq instead of re-allocating vq. vq is passed in through
function parameters.

Modify vring_create_virtqueue() to vring_setup_virtqueue(), and add a
new parameter vq. At the same time, add a new inline function, the
definition of the function is exactly the same as the original
vring_create_virtqueue().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 41 ++++++++++++++++++++++++++----------
 include/linux/virtio.h       |  1 +
 include/linux/virtio_ring.h  | 37 +++++++++++++++++++++++---------
 3 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4e1d345b0557..a93a677008ba 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -198,6 +198,15 @@ struct vring_virtqueue {
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
+				  const char *name);
 
 /*
  * Helpers.
@@ -925,9 +934,9 @@ static struct virtqueue *vring_create_virtqueue_split(
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
@@ -964,12 +973,17 @@ static struct virtqueue *vring_create_virtqueue_split(
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
+					   callback, name))
+			goto err;
 	}
 
 	to_vvq(vq)->split.queue_dma_addr = dma_addr;
@@ -977,6 +991,9 @@ static struct virtqueue *vring_create_virtqueue_split(
 	to_vvq(vq)->we_own_ring = true;
 
 	return vq;
+err:
+	vring_free_queue(vdev, queue_size_in_bytes, queue, dma_addr);
+	return NULL;
 }
 
 
@@ -2185,6 +2202,7 @@ static int __vring_init_virtqueue(struct virtqueue *_vq,
 	vq->vq.name = name;
 	vq->vq.num_free = vring.num;
 	vq->vq.index = index;
+	vq->vq.reset = false;
 	vq->we_own_ring = false;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
@@ -2276,7 +2294,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 }
 EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
 
-struct virtqueue *vring_create_virtqueue(
+struct virtqueue *vring_setup_virtqueue(
 	unsigned int index,
 	unsigned int num,
 	unsigned int vring_align,
@@ -2286,7 +2304,8 @@ struct virtqueue *vring_create_virtqueue(
 	bool context,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
-	const char *name)
+	const char *name,
+	struct virtqueue *vq)
 {
 
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
@@ -2296,9 +2315,9 @@ struct virtqueue *vring_create_virtqueue(
 
 	return vring_create_virtqueue_split(index, num, vring_align,
 			vdev, weak_barriers, may_reduce_num,
-			context, notify, callback, name);
+			context, notify, callback, name, vq);
 }
-EXPORT_SYMBOL_GPL(vring_create_virtqueue);
+EXPORT_SYMBOL_GPL(vring_setup_virtqueue);
 
 /* Only available for split ring */
 struct virtqueue *vring_new_virtqueue(unsigned int index,
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 41edbc01ffa4..98c89cbeafa1 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -32,6 +32,7 @@ struct virtqueue {
 	unsigned int index;
 	unsigned int num_free;
 	void *priv;
+	bool reset;
 };
 
 int virtqueue_add_outbuf(struct virtqueue *vq,
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index b485b13fa50b..e90323fce4bf 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -65,16 +65,33 @@ struct virtqueue;
  * expected.  The caller should query virtqueue_get_vring_size to learn
  * the actual size of the ring.
  */
-struct virtqueue *vring_create_virtqueue(unsigned int index,
-					 unsigned int num,
-					 unsigned int vring_align,
-					 struct virtio_device *vdev,
-					 bool weak_barriers,
-					 bool may_reduce_num,
-					 bool ctx,
-					 bool (*notify)(struct virtqueue *vq),
-					 void (*callback)(struct virtqueue *vq),
-					 const char *name);
+struct virtqueue *vring_setup_virtqueue(unsigned int index,
+					unsigned int num,
+					unsigned int vring_align,
+					struct virtio_device *vdev,
+					bool weak_barriers,
+					bool may_reduce_num,
+					bool ctx,
+					bool (*notify)(struct virtqueue *vq),
+					void (*callback)(struct virtqueue *vq),
+					const char *name,
+					struct virtqueue *vq);
+
+static inline struct virtqueue *vring_create_virtqueue(unsigned int index,
+						       unsigned int num,
+						       unsigned int vring_align,
+						       struct virtio_device *vdev,
+						       bool weak_barriers,
+						       bool may_reduce_num,
+						       bool ctx,
+						       bool (*notify)(struct virtqueue *vq),
+						       void (*callback)(struct virtqueue *vq),
+						       const char *name)
+{
+	return vring_setup_virtqueue(index, num, vring_align, vdev,
+				     weak_barriers, may_reduce_num, ctx,
+				     notify, callback, name, NULL);
+}
 
 /* Creates a virtqueue with a custom layout. */
 struct virtqueue *__vring_new_virtqueue(unsigned int index,
-- 
2.31.0

