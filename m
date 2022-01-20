Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4249494782
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358807AbiATGnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:43:22 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:46550 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358782AbiATGnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:43:13 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2KWFJl_1642660990;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2KWFJl_1642660990)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 14:43:11 +0800
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
Subject: [PATCH v2 06/12] virtio: queue_reset: pci: add independent function to enable msix vq
Date:   Thu, 20 Jan 2022 14:42:57 +0800
Message-Id: <20220120064303.106639-7-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
References: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract the vp_enable_vq_msix() function from vp_find_vqs_msix() . Used
to enable a msix vq individually.

In the subsequent patches that supports queue reset, I have the
need to enable a vq separately.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_common.c | 61 ++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index cb1eec0a6bf3..5afe207ce28a 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -311,6 +311,40 @@ void vp_del_vqs(struct virtio_device *vdev)
 	vp_dev->vqs = NULL;
 }
 
+static struct virtqueue *vp_enable_vq_msix(struct virtio_device *vdev,
+					   int queue_index,
+					   vq_callback_t *callback,
+					   const char * const name,
+					   bool ctx,
+					   u16 msix_vec)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtqueue *vq;
+	int err;
+
+	vq = vp_setup_vq(vdev, queue_index, callback, name, ctx, msix_vec);
+	if (IS_ERR(vq))
+		return vq;
+
+	if (!vp_dev->per_vq_vectors || msix_vec == VIRTIO_MSI_NO_VECTOR)
+		return vq;
+
+	/* allocate per-vq irq if available and necessary */
+	snprintf(vp_dev->msix_names[msix_vec],
+		 sizeof *vp_dev->msix_names,
+		 "%s-%s", dev_name(&vp_dev->vdev.dev), name);
+
+	err = request_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec),
+			  vring_interrupt, IRQF_NO_AUTOEN,
+			  vp_dev->msix_names[msix_vec], vq);
+	if (err) {
+		vp_del_vq(vq);
+		return ERR_PTR(err);
+	}
+
+	return vq;
+}
+
 static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
 		const char * const names[], bool per_vq_vectors,
@@ -320,6 +354,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	u16 msix_vec;
 	int i, err, nvectors, allocated_vectors, queue_idx = 0;
+	struct virtqueue *vq;
 
 	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
 	if (!vp_dev->vqs)
@@ -355,28 +390,14 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 			msix_vec = allocated_vectors++;
 		else
 			msix_vec = VP_MSIX_VQ_VECTOR;
-		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     ctx ? ctx[i] : false,
-				     msix_vec);
-		if (IS_ERR(vqs[i])) {
-			err = PTR_ERR(vqs[i]);
-			goto error_find;
-		}
-
-		if (!vp_dev->per_vq_vectors || msix_vec == VIRTIO_MSI_NO_VECTOR)
-			continue;
 
-		/* allocate per-vq irq if available and necessary */
-		snprintf(vp_dev->msix_names[msix_vec],
-			 sizeof *vp_dev->msix_names,
-			 "%s-%s",
-			 dev_name(&vp_dev->vdev.dev), names[i]);
-		err = request_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec),
-				  vring_interrupt, IRQF_NO_AUTOEN,
-				  vp_dev->msix_names[msix_vec],
-				  vqs[i]);
-		if (err)
+		vq = vp_enable_vq_msix(vdev, queue_idx++, callbacks[i],
+				       names[i], ctx ? ctx[i] : false, msix_vec);
+		if (IS_ERR(vq)) {
+			err = PTR_ERR(vq);
 			goto error_find;
+		}
+		vqs[i] = vq;
 	}
 	return 0;
 
-- 
2.31.0

