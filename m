Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9736643F722
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 08:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhJ2Gar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 02:30:47 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:48455 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231982AbhJ2Gar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 02:30:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uu5jUTY_1635488894;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Uu5jUTY_1635488894)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 14:28:15 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 1/3] virtio: cache indirect desc for split
Date:   Fri, 29 Oct 2021 14:28:12 +0800
Message-Id: <20211029062814.76594-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211029062814.76594-1-xuanzhuo@linux.alibaba.com>
References: <20211029062814.76594-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of using indirect, indirect desc must be allocated and
released each time, which increases a lot of cpu overhead.

Here, a cache is added for indirect. If the number of indirect desc to be
applied for is less than desc_cache_thr, the desc array with
the size of desc_cache_thr is fixed and cached for reuse.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio.c      |   6 ++
 drivers/virtio/virtio_ring.c | 105 ++++++++++++++++++++++++++++++++---
 include/linux/virtio.h       |  14 +++++
 3 files changed, 117 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 0a5b54034d4b..1047149ac2a4 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -431,6 +431,12 @@ bool is_virtio_device(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(is_virtio_device);
 
+void virtio_set_desc_cache(struct virtio_device *dev, u32 thr)
+{
+	dev->desc_cache_thr = thr;
+}
+EXPORT_SYMBOL_GPL(virtio_set_desc_cache);
+
 void unregister_virtio_device(struct virtio_device *dev)
 {
 	int index = dev->index; /* save for after device release */
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index dd95dfd85e98..010c47baa37f 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -85,6 +85,19 @@ struct vring_desc_extra {
 	u16 next;			/* The next desc state in a list. */
 };
 
+struct vring_desc_cache {
+	/* desc cache chain */
+	struct list_head list;
+
+	void *array;
+
+	/* desc cache threshold
+	 *    0   - disable desc cache
+	 *    > 0 - enable desc cache. As the threshold of the desc cache.
+	 */
+	u32 thr;
+};
+
 struct vring_virtqueue {
 	struct virtqueue vq;
 
@@ -117,6 +130,8 @@ struct vring_virtqueue {
 	/* Hint for event idx: already triggered no need to disable. */
 	bool event_triggered;
 
+	struct vring_desc_cache desc_cache;
+
 	union {
 		/* Available for split ring */
 		struct {
@@ -423,7 +438,76 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 	return extra[i].next;
 }
 
-static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
+static void desc_cache_free(struct vring_virtqueue *vq)
+{
+	kfree(vq->desc_cache.array);
+}
+
+static void desc_cache_create(struct vring_virtqueue *vq,
+			      struct virtio_device *vdev, int size, int num)
+{
+	struct list_head *node;
+	int i;
+
+	BUILD_BUG_ON(sizeof(struct list_head) > sizeof(struct vring_desc));
+	BUILD_BUG_ON(sizeof(struct list_head) > sizeof(struct vring_packed_desc));
+
+	vq->desc_cache.array = NULL;
+	vq->desc_cache.thr = vdev->desc_cache_thr;
+
+	INIT_LIST_HEAD(&vq->desc_cache.list);
+
+	if (!vq->desc_cache.thr)
+		return;
+
+	size = size * vq->desc_cache.thr;
+
+	vq->desc_cache.array = kmalloc_array(num, size, GFP_KERNEL);
+	if (!vq->desc_cache.array) {
+		vq->desc_cache.thr = 0;
+		dev_warn(&vdev->dev, "queue[%d] alloc desc cache fail. turn off it.\n",
+			 vq->vq.index);
+		return;
+	}
+
+	for (i = 0; i < num; ++i) {
+		node = vq->desc_cache.array + (i * size);
+		list_add(node, &vq->desc_cache.list);
+	}
+}
+
+static void __desc_cache_put(struct vring_virtqueue *vq,
+			     struct list_head *node, int n)
+{
+	if (n <= vq->desc_cache.thr)
+		list_add(node, &vq->desc_cache.list);
+	else
+		kfree(node);
+}
+
+#define desc_cache_put(vq, desc, n) \
+	__desc_cache_put(vq, (struct list_head *)desc, n)
+
+static void *desc_cache_get(struct vring_virtqueue *vq,
+			    int size, int n, gfp_t gfp)
+{
+	struct list_head *node;
+
+	if (n > vq->desc_cache.thr)
+		return kmalloc_array(n, size, gfp);
+
+	node = vq->desc_cache.list.next;
+	list_del(node);
+	return node;
+}
+
+#define _desc_cache_get(vq, n, gfp, tp) \
+	((tp *)desc_cache_get(vq, (sizeof(tp)), n, gfp))
+
+#define desc_cache_get_split(vq, n, gfp) \
+	_desc_cache_get(vq, n, gfp, struct vring_desc)
+
+static struct vring_desc *alloc_indirect_split(struct vring_virtqueue *vq,
 					       unsigned int total_sg,
 					       gfp_t gfp)
 {
@@ -437,12 +521,12 @@ static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
 	 */
 	gfp &= ~__GFP_HIGHMEM;
 
-	desc = kmalloc_array(total_sg, sizeof(struct vring_desc), gfp);
+	desc = desc_cache_get_split(vq, total_sg, gfp);
 	if (!desc)
 		return NULL;
 
 	for (i = 0; i < total_sg; i++)
-		desc[i].next = cpu_to_virtio16(_vq->vdev, i + 1);
+		desc[i].next = cpu_to_virtio16(vq->vq.vdev, i + 1);
 	return desc;
 }
 
@@ -508,7 +592,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	head = vq->free_head;
 
 	if (virtqueue_use_indirect(_vq, total_sg))
-		desc = alloc_indirect_split(_vq, total_sg, gfp);
+		desc = alloc_indirect_split(vq, total_sg, gfp);
 	else {
 		desc = NULL;
 		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
@@ -652,7 +736,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	}
 
 	if (indirect)
-		kfree(desc);
+		desc_cache_put(vq, desc, total_sg);
 
 	END_USE(vq);
 	return -ENOMEM;
@@ -717,7 +801,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 	if (vq->indirect) {
 		struct vring_desc *indir_desc =
 				vq->split.desc_state[head].indir_desc;
-		u32 len;
+		u32 len, n;
 
 		/* Free the indirect table, if any, now that it's unmapped. */
 		if (!indir_desc)
@@ -729,10 +813,12 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 				VRING_DESC_F_INDIRECT));
 		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
 
-		for (j = 0; j < len / sizeof(struct vring_desc); j++)
+		n = len / sizeof(struct vring_desc);
+
+		for (j = 0; j < n; j++)
 			vring_unmap_one_split_indirect(vq, &indir_desc[j]);
 
-		kfree(indir_desc);
+		desc_cache_put(vq, indir_desc, n);
 		vq->split.desc_state[head].indir_desc = NULL;
 	} else if (ctx) {
 		*ctx = vq->split.desc_state[head].indir_desc;
@@ -2200,6 +2286,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 		!context;
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
+	desc_cache_create(vq, vdev, sizeof(struct vring_desc), vring.num);
+
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
@@ -2329,6 +2417,7 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 	if (!vq->packed_ring) {
 		kfree(vq->split.desc_state);
 		kfree(vq->split.desc_extra);
+		desc_cache_free(vq);
 	}
 	kfree(vq);
 }
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 41edbc01ffa4..bda6f9853e97 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -118,6 +118,7 @@ struct virtio_device {
 	struct list_head vqs;
 	u64 features;
 	void *priv;
+	u32 desc_cache_thr;
 };
 
 static inline struct virtio_device *dev_to_virtio(struct device *_dev)
@@ -130,6 +131,19 @@ int register_virtio_device(struct virtio_device *dev);
 void unregister_virtio_device(struct virtio_device *dev);
 bool is_virtio_device(struct device *dev);
 
+/**
+ * virtio_set_desc_cache - set virtio ring desc cache threshold
+ *
+ * virtio will cache the allocated indirect desc.
+ *
+ * This function must be called before find_vqs.
+ *
+ * @thr:
+ *    0   - disable desc cache
+ *    > 0 - enable desc cache. As the threshold of the desc cache.
+ */
+void virtio_set_desc_cache(struct virtio_device *dev, u32 thr);
+
 void virtio_break_device(struct virtio_device *dev);
 
 void virtio_config_changed(struct virtio_device *dev);
-- 
2.31.0

