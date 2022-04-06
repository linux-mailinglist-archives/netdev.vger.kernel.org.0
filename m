Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6B14F5D1F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiDFMSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiDFMRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:17:24 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EA426B58C;
        Tue,  5 Apr 2022 20:44:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V9Jmri3_1649216676;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9Jmri3_1649216676)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 06 Apr 2022 11:44:37 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v9 23/32] virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
Date:   Wed,  6 Apr 2022 11:43:37 +0800
Message-Id: <20220406034346.74409-24-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 881cb3483d12
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
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
 drivers/virtio/virtio_pci_common.c |  8 +--
 drivers/virtio/virtio_pci_modern.c | 84 ++++++++++++++++++++++++++++++
 drivers/virtio/virtio_ring.c       |  2 +
 include/linux/virtio.h             |  1 +
 4 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index fdbde1db5ec5..863d3a8a0956 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -248,9 +248,11 @@ static void vp_del_vq(struct virtqueue *vq)
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
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 49a4493732cf..cb5d38f1c9c8 100644
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
@@ -199,6 +202,83 @@ static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
 	return 0;
 }
 
+static int vp_modern_reset_vq(struct virtqueue *vq)
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
+	/* For the case where vq has an exclusive irq, to prevent the irq from
+	 * being received again and the pending irq, call disable_irq().
+	 *
+	 * In the scenario based on shared interrupts, vq will be searched from
+	 * the queue virtqueues. Since the previous list_del() has been deleted
+	 * from the queue, it is impossible for vq to be called in this case.
+	 * There is no need to close the corresponding interrupt.
+	 */
+	if (vp_dev->per_vq_vectors && info->msix_vector != VIRTIO_MSI_NO_VECTOR)
+		disable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
+
+	vq->reset = true;
+
+	return 0;
+}
+
+static int vp_modern_enable_reset_vq(struct virtqueue *vq)
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
+	/* check queue reset status */
+	if (vp_modern_get_queue_reset(mdev, index) != 1)
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
+	vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
+
+	if (vp_dev->per_vq_vectors && info->msix_vector != VIRTIO_MSI_NO_VECTOR)
+		enable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
+
+	vq->reset = false;
+
+	return 0;
+}
+
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
 {
 	return vp_modern_config_vector(&vp_dev->mdev, vector);
@@ -407,6 +487,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 	.get_vq_affinity = vp_get_vq_affinity,
 	.get_shm_region  = vp_get_shm_region,
+	.reset_vq	 = vp_modern_reset_vq,
+	.enable_reset_vq = vp_modern_enable_reset_vq,
 };
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
@@ -425,6 +507,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 	.get_vq_affinity = vp_get_vq_affinity,
 	.get_shm_region  = vp_get_shm_region,
+	.reset_vq	 = vp_modern_reset_vq,
+	.enable_reset_vq = vp_modern_enable_reset_vq,
 };
 
 /* the PCI probing function */
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 6250e19fc5bf..91937e21edca 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2028,6 +2028,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->vq.vdev = vdev;
 	vq->vq.name = name;
 	vq->vq.index = index;
+	vq->vq.reset = false;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
 
@@ -2508,6 +2509,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->vq.vdev = vdev;
 	vq->vq.name = name;
 	vq->vq.index = index;
+	vq->vq.reset = false;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index c86ff02e0ca0..33ab003c5100 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -33,6 +33,7 @@ struct virtqueue {
 	unsigned int num_free;
 	unsigned int num_max;
 	void *priv;
+	bool reset;
 };
 
 int virtqueue_add_outbuf(struct virtqueue *vq,
-- 
2.31.0

