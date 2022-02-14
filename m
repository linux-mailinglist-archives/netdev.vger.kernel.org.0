Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72364B4381
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241692AbiBNIPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:15:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241710AbiBNIPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:15:04 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581F15FF16;
        Mon, 14 Feb 2022 00:14:56 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4O5x9Z_1644826469;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4O5x9Z_1644826469)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:30 +0800
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
Subject: [PATCH v5 12/22] virtio_pci: queue_reset: setup_vq() support vring_setup_virtqueue()
Date:   Mon, 14 Feb 2022 16:14:06 +0800
Message-Id: <20220214081416.117695-13-xuanzhuo@linux.alibaba.com>
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

modern setup_vq() replaces vring_create_virtqueue() with
vring_setup_virtqueue()

vp_setup_vq() can pass the original vq(from info->vq) to re-enable vq.

Allow direct calls to vp_setup_vq() in virtio_pci_modern.c

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_common.c | 31 ++++++++++++++++++------------
 drivers/virtio/virtio_pci_common.h |  8 +++++++-
 drivers/virtio/virtio_pci_legacy.c |  4 ++--
 drivers/virtio/virtio_pci_modern.c | 12 ++++++------
 4 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 6b2573ec1ae8..5a4f750a0b97 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -205,28 +205,33 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 	return err;
 }
 
-static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
-				     void (*callback)(struct virtqueue *vq),
-				     const char *name,
-				     bool ctx,
-				     u16 msix_vec)
+struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int index,
+			      void (*callback)(struct virtqueue *vq),
+			      const char *name,
+			      bool ctx,
+			      u16 msix_vec)
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
+		info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+		/* fill out our structure that represents an active queue */
+		if (!info)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
-			      msix_vec);
+			      msix_vec, info->vq);
 	if (IS_ERR(vq))
 		goto out_info;
 
 	info->vq = vq;
-	if (callback) {
+	if (vq->callback) {
 		spin_lock_irqsave(&vp_dev->lock, flags);
 		list_add(&info->node, &vp_dev->virtqueues);
 		spin_unlock_irqrestore(&vp_dev->lock, flags);
@@ -238,7 +243,9 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
 	return vq;
 
 out_info:
-	kfree(info);
+	if (!info->vq)
+		kfree(info);
+
 	return vq;
 }
 
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 392d990b7c73..696e3f6a493b 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -84,7 +84,8 @@ struct virtio_pci_device {
 				      void (*callback)(struct virtqueue *vq),
 				      const char *name,
 				      bool ctx,
-				      u16 msix_vec);
+				      u16 msix_vec,
+				      struct virtqueue *vq);
 	void (*del_vq)(struct virtio_pci_vq_info *info);
 
 	u16 (*config_vector)(struct virtio_pci_device *vp_dev, u16 vector);
@@ -117,6 +118,11 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
 		const char * const names[], const bool *ctx,
 		struct irq_affinity *desc);
+struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int index,
+			      void (*callback)(struct virtqueue *vq),
+			      const char *name,
+			      bool ctx,
+			      u16 msix_vec);
 const char *vp_bus_name(struct virtio_device *vdev);
 
 /* Setup the affinity for a virtqueue:
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 34141b9abe27..96ec2b04e97d 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -113,9 +113,9 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  void (*callback)(struct virtqueue *vq),
 				  const char *name,
 				  bool ctx,
-				  u16 msix_vec)
+				  u16 msix_vec,
+				  struct virtqueue *vq)
 {
-	struct virtqueue *vq;
 	u16 num;
 	int err;
 	u64 q_pfn;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 5455bc041fb6..5af82948f0ae 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -187,11 +187,11 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  void (*callback)(struct virtqueue *vq),
 				  const char *name,
 				  bool ctx,
-				  u16 msix_vec)
+				  u16 msix_vec,
+				  struct virtqueue *vq)
 {
 
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
-	struct virtqueue *vq;
 	u16 num;
 	int err;
 
@@ -211,10 +211,10 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	info->msix_vector = msix_vec;
 
 	/* create the vring */
-	vq = vring_create_virtqueue(index, num,
-				    SMP_CACHE_BYTES, &vp_dev->vdev,
-				    true, true, ctx,
-				    vp_notify, callback, name);
+	vq = vring_setup_virtqueue(index, num,
+				   SMP_CACHE_BYTES, &vp_dev->vdev,
+				   true, true, ctx,
+				   vp_notify, callback, name, vq);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.31.0

