Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F53449C486
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbiAZHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:36:01 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:34955 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237920AbiAZHfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2uVHmm_1643182545;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2uVHmm_1643182545)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:46 +0800
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
Subject: [PATCH v3 11/17] virtio_pci: queue_reset: release vq by vp_dev->vqs
Date:   Wed, 26 Jan 2022 15:35:27 +0800
Message-Id: <20220126073533.44994-12-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the process of queue reset, vq leaves vdev->vqs, so the original
processing logic may miss some vq. So modify the processing method of
releasing vq. Release vq by listing vqs.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_common.c | 22 ++++++++++++++++++----
 drivers/virtio/virtio_pci_common.h |  2 ++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index fdbde1db5ec5..6b2573ec1ae8 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -260,12 +260,20 @@ static void vp_del_vq(struct virtqueue *vq)
 void vp_del_vqs(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	struct virtqueue *vq, *n;
-	int i;
+	struct virtio_pci_vq_info *info;
+	struct virtqueue *vq;
+	int i, v;
+
+	for (i = 0; i < vp_dev->nvqs; ++i) {
+
+		info = vp_dev->vqs[i];
+		if (!info)
+			continue;
+
+		vq = info->vq;
 
-	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
 		if (vp_dev->per_vq_vectors) {
-			int v = vp_dev->vqs[vq->index]->msix_vector;
+			v = info->msix_vector;
 
 			if (v != VIRTIO_MSI_NO_VECTOR) {
 				int irq = pci_irq_vector(vp_dev->pci_dev, v);
@@ -275,6 +283,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 			}
 		}
 		vp_del_vq(vq);
+		vp_dev->vqs[i] = NULL;
 	}
 	vp_dev->per_vq_vectors = false;
 
@@ -308,6 +317,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 	vp_dev->msix_affinity_masks = NULL;
 	kfree(vp_dev->vqs);
 	vp_dev->vqs = NULL;
+	vp_dev->nvqs = 0;
 }
 
 static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
@@ -324,6 +334,8 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 	if (!vp_dev->vqs)
 		return -ENOMEM;
 
+	vp_dev->nvqs = nvqs;
+
 	if (per_vq_vectors) {
 		/* Best option: one for change interrupt, one per vq. */
 		nvectors = 1;
@@ -395,6 +407,8 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned nvqs,
 	if (!vp_dev->vqs)
 		return -ENOMEM;
 
+	vp_dev->nvqs = nvqs;
+
 	err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
 			dev_name(&vdev->dev), vp_dev);
 	if (err)
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 23f6c5c678d5..392d990b7c73 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -60,6 +60,8 @@ struct virtio_pci_device {
 	/* array of all queues for house-keeping */
 	struct virtio_pci_vq_info **vqs;
 
+	u32 nvqs;
+
 	/* MSI-X support */
 	int msix_enabled;
 	int intx_enabled;
-- 
2.31.0

