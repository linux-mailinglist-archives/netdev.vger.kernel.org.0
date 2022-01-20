Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C675C49477F
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358791AbiATGnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:43:16 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:56311 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358770AbiATGnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:43:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2L1lSQ_1642660989;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2L1lSQ_1642660989)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 14:43:09 +0800
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
Subject: [PATCH v2 05/12] virito: queue_reset: pci: move the per queue irq logic from vp_del_vqs to vp_del_vq
Date:   Thu, 20 Jan 2022 14:42:56 +0800
Message-Id: <20220120064303.106639-6-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
References: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move irq's processing logic into vp_del_vq(), so that this function can
handle a vq's del operation independently.

In the subsequent patches that supports queue reset, I have the
need to delete a vq separately.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_common.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index fdbde1db5ec5..cb1eec0a6bf3 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -248,6 +248,17 @@ static void vp_del_vq(struct virtqueue *vq)
 	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
 	unsigned long flags;
 
+	if (vp_dev->per_vq_vectors) {
+		int v = vp_dev->vqs[vq->index]->msix_vector;
+
+		if (v != VIRTIO_MSI_NO_VECTOR) {
+			int irq = pci_irq_vector(vp_dev->pci_dev, v);
+
+			irq_set_affinity_hint(irq, NULL);
+			free_irq(irq, vq);
+		}
+	}
+
 	spin_lock_irqsave(&vp_dev->lock, flags);
 	list_del(&info->node);
 	spin_unlock_irqrestore(&vp_dev->lock, flags);
@@ -263,19 +274,9 @@ void vp_del_vqs(struct virtio_device *vdev)
 	struct virtqueue *vq, *n;
 	int i;
 
-	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
-		if (vp_dev->per_vq_vectors) {
-			int v = vp_dev->vqs[vq->index]->msix_vector;
-
-			if (v != VIRTIO_MSI_NO_VECTOR) {
-				int irq = pci_irq_vector(vp_dev->pci_dev, v);
-
-				irq_set_affinity_hint(irq, NULL);
-				free_irq(irq, vq);
-			}
-		}
+	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
 		vp_del_vq(vq);
-	}
+
 	vp_dev->per_vq_vectors = false;
 
 	if (vp_dev->intx_enabled) {
-- 
2.31.0

