Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFF9580D2F
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbiGZHZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238172AbiGZHYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:24:02 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD30B13F3C;
        Tue, 26 Jul 2022 00:23:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VKUJOXR_1658820206;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VKUJOXR_1658820206)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 15:23:28 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: [PATCH v13 32/42] virtio_pci: support VIRTIO_F_RING_RESET
Date:   Tue, 26 Jul 2022 15:22:15 +0800
Message-Id: <20220726072225.19884-33-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 19d2a6aae0b1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements virtio pci support for QUEUE RESET.

Performing reset on a queue is divided into these steps:

 1. notify the device to reset the queue
 2. recycle the buffer submitted
 3. reset the vring (may re-alloc)
 4. mmap vring to device, and enable the queue

This patch implements virtio_reset_vq(), virtio_enable_resetq() in the
pci scenario.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_common.c | 12 +++-
 drivers/virtio/virtio_pci_modern.c | 88 ++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index ca51fcc9daab..ad258a9d3b9f 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -214,9 +214,15 @@ static void vp_del_vq(struct virtqueue *vq)
 	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
 	unsigned long flags;
 
-	spin_lock_irqsave(&vp_dev->lock, flags);
-	list_del(&info->node);
-	spin_unlock_irqrestore(&vp_dev->lock, flags);
+	/*
+	 * If it fails during re-enable reset vq. This way we won't rejoin
+	 * info->node to the queue. Prevent unexpected irqs.
+	 */
+	if (!vq->reset) {
+		spin_lock_irqsave(&vp_dev->lock, flags);
+		list_del(&info->node);
+		spin_unlock_irqrestore(&vp_dev->lock, flags);
+	}
 
 	vp_dev->del_vq(info);
 	kfree(info);
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9041d9a41b7d..c3b9f2761849 100644
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
@@ -199,6 +202,87 @@ static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
 	return 0;
 }
 
+static int vp_modern_disable_vq_and_reset(struct virtqueue *vq)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
+	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	struct virtio_pci_vq_info *info;
+	unsigned long flags;
+
+	if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
+		return -ENOENT;
+
+	vp_modern_set_queue_reset(mdev, vq->index);
+
+	info = vp_dev->vqs[vq->index];
+
+	/* delete vq from irq handler */
+	spin_lock_irqsave(&vp_dev->lock, flags);
+	list_del(&info->node);
+	spin_unlock_irqrestore(&vp_dev->lock, flags);
+
+	INIT_LIST_HEAD(&info->node);
+
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
+	__virtqueue_break(vq);
+#endif
+
+	/* For the case where vq has an exclusive irq, call synchronize_irq() to
+	 * wait for completion.
+	 *
+	 * note: We can't use disable_irq() since it conflicts with the affinity
+	 * managed IRQ that is used by some drivers.
+	 */
+	if (vp_dev->per_vq_vectors && info->msix_vector != VIRTIO_MSI_NO_VECTOR)
+		synchronize_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
+
+	vq->reset = true;
+
+	return 0;
+}
+
+static int vp_modern_enable_vq_after_reset(struct virtqueue *vq)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
+	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	struct virtio_pci_vq_info *info;
+	unsigned long flags, index;
+	int err;
+
+	if (!vq->reset)
+		return -EBUSY;
+
+	index = vq->index;
+	info = vp_dev->vqs[index];
+
+	if (vp_modern_get_queue_reset(mdev, index))
+		return -EBUSY;
+
+	if (vp_modern_get_queue_enable(mdev, index))
+		return -EBUSY;
+
+	err = vp_active_vq(vq, info->msix_vector);
+	if (err)
+		return err;
+
+	if (vq->callback) {
+		spin_lock_irqsave(&vp_dev->lock, flags);
+		list_add(&info->node, &vp_dev->virtqueues);
+		spin_unlock_irqrestore(&vp_dev->lock, flags);
+	} else {
+		INIT_LIST_HEAD(&info->node);
+	}
+
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
+	__virtqueue_unbreak(vq);
+#endif
+
+	vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
+	vq->reset = false;
+
+	return 0;
+}
+
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
 {
 	return vp_modern_config_vector(&vp_dev->mdev, vector);
@@ -413,6 +497,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 	.get_vq_affinity = vp_get_vq_affinity,
 	.get_shm_region  = vp_get_shm_region,
+	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
+	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
 };
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
@@ -431,6 +517,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 	.get_vq_affinity = vp_get_vq_affinity,
 	.get_shm_region  = vp_get_shm_region,
+	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
+	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
 };
 
 /* the PCI probing function */
-- 
2.31.0

