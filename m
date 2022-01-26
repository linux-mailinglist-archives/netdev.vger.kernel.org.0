Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208DA49C497
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbiAZHgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:36:12 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:39588 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237925AbiAZHfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2uPGP7_1643182547;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2uPGP7_1643182547)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:48 +0800
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
Subject: [PATCH v3 13/17] virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
Date:   Wed, 26 Jan 2022 15:35:29 +0800
Message-Id: <20220126073533.44994-14-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements virtio pci support for QUEUE RESET.

Performing reset on a queue is divided into two steps:

1. reset_vq: reset one vq
2. enable_reset_vq: re-enable the reset queue

In the first step, these tasks will be completed:
   1. notify the hardware queue to reset
   2. recycle the buffer from vq
   3. release the ring of the vq

The process of enable reset vq:
    vp_modern_enable_reset_vq()
    vp_enable_reset_vq()
    __vp_setup_vq()
    setup_vq()
    vring_setup_virtqueue()

In this process, we added two parameters, vq and num, and finally passed
them to vring_setup_virtqueue().  And reuse the original info and vq.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_common.c |  36 +++++++----
 drivers/virtio/virtio_pci_common.h |   5 ++
 drivers/virtio/virtio_pci_modern.c | 100 +++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+), 13 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index c02936d29a31..ad21638fbf66 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -205,23 +205,28 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 	return err;
 }
 
-static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
-				     void (*callback)(struct virtqueue *vq),
-				     const char *name,
-				     bool ctx,
-				     u16 msix_vec, u16 num)
+struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
+			      void (*callback)(struct virtqueue *vq),
+			      const char *name,
+			      bool ctx,
+			      u16 msix_vec, u16 num)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	struct virtio_pci_vq_info *info = kmalloc(sizeof *info, GFP_KERNEL);
+	struct virtio_pci_vq_info *info;
 	struct virtqueue *vq;
 	unsigned long flags;
 
-	/* fill out our structure that represents an active queue */
-	if (!info)
-		return ERR_PTR(-ENOMEM);
+	info = vp_dev->vqs[index];
+	if (!info) {
+		info = kzalloc(sizeof *info, GFP_KERNEL);
+
+		/* fill out our structure that represents an active queue */
+		if (!info)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
-			      msix_vec, NULL, num);
+			      msix_vec, info->vq, num);
 	if (IS_ERR(vq))
 		goto out_info;
 
@@ -238,6 +243,9 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
 	return vq;
 
 out_info:
+	if (info->vq && info->vq->reset)
+		return vq;
+
 	kfree(info);
 	return vq;
 }
@@ -248,9 +256,11 @@ static void vp_del_vq(struct virtqueue *vq)
 	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
 	unsigned long flags;
 
-	spin_lock_irqsave(&vp_dev->lock, flags);
-	list_del(&info->node);
-	spin_unlock_irqrestore(&vp_dev->lock, flags);
+	if (!vq->reset) {
+		spin_lock_irqsave(&vp_dev->lock, flags);
+		list_del(&info->node);
+		spin_unlock_irqrestore(&vp_dev->lock, flags);
+	}
 
 	vp_dev->del_vq(info);
 	kfree(info);
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 65db92245e41..c1d15f7c0be4 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -119,6 +119,11 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
 		const char * const names[], const bool *ctx,
 		struct irq_affinity *desc);
+struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
+			      void (*callback)(struct virtqueue *vq),
+			      const char *name,
+			      bool ctx,
+			      u16 msix_vec, u16 num);
 const char *vp_bus_name(struct virtio_device *vdev);
 
 /* Setup the affinity for a virtqueue:
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 2ce58de549de..6789411169e4 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
 	if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
 			pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
 		__virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
+
+	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
+		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
 }
 
 /* virtio config->finalize_features() implementation */
@@ -176,6 +179,94 @@ static void vp_reset(struct virtio_device *vdev)
 	vp_disable_cbs(vdev);
 }
 
+static int vp_modern_reset_vq(struct virtio_reset_vq *param)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(param->vdev);
+	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	struct virtio_pci_vq_info *info;
+	u16 msix_vec, queue_index;
+	unsigned long flags;
+	void *buf;
+
+	if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
+		return -ENOENT;
+
+	queue_index = param->queue_index;
+
+	vp_modern_set_queue_reset(mdev, queue_index);
+
+	/* After write 1 to queue reset, the driver MUST wait for a read of
+	 * queue reset to return 1.
+	 */
+	while (vp_modern_get_queue_reset(mdev, queue_index) != 1)
+		msleep(1);
+
+	info = vp_dev->vqs[queue_index];
+	msix_vec = info->msix_vector;
+
+	/* Disable VQ callback. */
+	if (vp_dev->per_vq_vectors && msix_vec != VIRTIO_MSI_NO_VECTOR)
+		disable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec));
+
+	while ((buf = virtqueue_detach_unused_buf(info->vq)) != NULL)
+		param->free_unused_cb(param, buf);
+
+	/* delete vq */
+	spin_lock_irqsave(&vp_dev->lock, flags);
+	list_del(&info->node);
+	spin_unlock_irqrestore(&vp_dev->lock, flags);
+
+	INIT_LIST_HEAD(&info->node);
+
+	if (vp_dev->msix_enabled)
+		vp_modern_queue_vector(mdev, info->vq->index,
+				       VIRTIO_MSI_NO_VECTOR);
+
+	if (!mdev->notify_base)
+		pci_iounmap(mdev->pci_dev,
+			    (void __force __iomem *)info->vq->priv);
+
+	vring_reset_virtqueue(info->vq);
+
+	return 0;
+}
+
+static struct virtqueue *vp_modern_enable_reset_vq(struct virtio_reset_vq *param)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(param->vdev);
+	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	struct virtio_pci_vq_info *info;
+	u16 msix_vec, queue_index;
+	struct virtqueue *vq;
+
+	if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
+		return ERR_PTR(-ENOENT);
+
+	queue_index = param->queue_index;
+
+	info = vp_dev->vqs[queue_index];
+
+	if (!info->vq->reset)
+		return ERR_PTR(-EPERM);
+
+	/* check queue reset status */
+	if (vp_modern_get_queue_reset(mdev, queue_index) != 1)
+		return ERR_PTR(-EBUSY);
+
+	vq = vp_setup_vq(param->vdev, queue_index, param->callback, param->name,
+			 param->ctx, info->msix_vector, param->ring_num);
+	if (IS_ERR(vq))
+		return vq;
+
+	vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
+
+	msix_vec = vp_dev->vqs[queue_index]->msix_vector;
+	if (vp_dev->per_vq_vectors && msix_vec != VIRTIO_MSI_NO_VECTOR)
+		enable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec));
+
+	return vq;
+}
+
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
 {
 	return vp_modern_config_vector(&vp_dev->mdev, vector);
@@ -284,6 +375,11 @@ static void del_vq(struct virtio_pci_vq_info *info)
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
 
+	if (vq->reset) {
+		vring_del_virtqueue(vq);
+		return;
+	}
+
 	if (vp_dev->msix_enabled)
 		vp_modern_queue_vector(mdev, vq->index,
 				       VIRTIO_MSI_NO_VECTOR);
@@ -403,6 +499,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 	.get_vq_affinity = vp_get_vq_affinity,
 	.get_shm_region  = vp_get_shm_region,
+	.reset_vq	 = vp_modern_reset_vq,
+	.enable_reset_vq = vp_modern_enable_reset_vq,
 };
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
@@ -421,6 +519,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 	.get_vq_affinity = vp_get_vq_affinity,
 	.get_shm_region  = vp_get_shm_region,
+	.reset_vq	 = vp_modern_reset_vq,
+	.enable_reset_vq = vp_modern_enable_reset_vq,
 };
 
 /* the PCI probing function */
-- 
2.31.0

