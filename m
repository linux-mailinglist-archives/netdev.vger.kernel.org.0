Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89986494781
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358798AbiATGnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:43:19 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:56338 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358781AbiATGnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:43:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2L1lSE_1642660988;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2L1lSE_1642660988)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 14:43:08 +0800
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
Subject: [PATCH v2 04/12] virtio: queue_reset: pci: update struct virtio_pci_common_cfg and option functions
Date:   Thu, 20 Jan 2022 14:42:55 +0800
Message-Id: <20220120064303.106639-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
References: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add queue_reset in virtio_pci_common_cfg, and add related operation
functions.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_modern_dev.c | 28 ++++++++++++++++++++++++++
 include/linux/virtio_pci_modern.h      |  2 ++
 include/uapi/linux/virtio_pci.h        |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index e11ed748e661..be02f812a2f6 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -463,6 +463,34 @@ void vp_modern_set_status(struct virtio_pci_modern_device *mdev,
 }
 EXPORT_SYMBOL_GPL(vp_modern_set_status);
 
+/*
+ * vp_modern_get_queue_reset - get the queue reset status
+ * @mdev: the modern virtio-pci device
+ * @index: queue index
+ */
+int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
+
+	vp_iowrite16(index, &cfg->queue_select);
+	return vp_ioread16(&cfg->queue_reset);
+}
+EXPORT_SYMBOL_GPL(vp_modern_get_queue_reset);
+
+/*
+ * vp_modern_set_queue_reset - reset the queue
+ * @mdev: the modern virtio-pci device
+ * @index: queue index
+ */
+void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
+
+	vp_iowrite16(index, &cfg->queue_select);
+	vp_iowrite16(1, &cfg->queue_reset);
+}
+EXPORT_SYMBOL_GPL(vp_modern_set_queue_reset);
+
 /*
  * vp_modern_queue_vector - set the MSIX vector for a specific virtqueue
  * @mdev: the modern virtio-pci device
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index eb2bd9b4077d..cc4154dd7b28 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -106,4 +106,6 @@ void __iomem * vp_modern_map_vq_notify(struct virtio_pci_modern_device *mdev,
 				       u16 index, resource_size_t *pa);
 int vp_modern_probe(struct virtio_pci_modern_device *mdev);
 void vp_modern_remove(struct virtio_pci_modern_device *mdev);
+int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
+void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
 #endif
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 492c89f56c6a..bf10f349087f 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -165,6 +165,7 @@ struct virtio_pci_common_cfg {
 	__le32 queue_used_lo;		/* read-write */
 	__le32 queue_used_hi;		/* read-write */
 	__le16 queue_notify_data;	/* read-write */
+	__le16 queue_reset;		/* read-write */
 };
 
 /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
-- 
2.31.0

