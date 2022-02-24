Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B96D4C2A40
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiBXLEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiBXLEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:04:43 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D534428F972;
        Thu, 24 Feb 2022 03:04:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5O.G4g_1645700650;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V5O.G4g_1645700650)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 19:04:11 +0800
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
Subject: [PATCH v2 7/9] virtio_ring: add api virtio_dma_map() for advance dma
Date:   Thu, 24 Feb 2022 19:04:00 +0800
Message-Id: <20220224110402.108161-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
References: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d02e086a8668
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

Added virtio_dma_map() to map DMA addresses for virtual memory in
advance. The purpose of adding this function is to check
vring_use_dma_api() for virtio dma operation and get vdev->dev.parent as
the parameter of dma_map_page().

Added virtio_dma_unmap() for unmap DMA address.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 63 ++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  7 ++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c8d63cae8b33..6a1e0ef5498a 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2508,4 +2508,67 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_vring);
 
+/**
+ * virtio_dma_map - get the DMA addr of the memory for virtio device
+ * @dev: virtio device
+ * @addr: the addr to DMA
+ * @length: memory length
+ * @dir: DMA direction
+ *
+ * Returns the DMA addr.
+ */
+dma_addr_t virtio_dma_map(struct device *dev, void *addr, unsigned int length,
+			  enum dma_data_direction dir)
+{
+	struct virtio_device *vdev = dev_to_virtio(dev);
+	struct page *page;
+	size_t offset;
+
+	page = virt_to_page(addr);
+	offset = offset_in_page(addr);
+
+	if (!vring_use_dma_api(vdev))
+		return page_to_phys(page) + offset;
+
+	return dma_map_page(vdev->dev.parent, page, offset, length, dir);
+}
+EXPORT_SYMBOL_GPL(virtio_dma_map);
+
+/**
+ * virtio_dma_mapping_error - check dma address
+ * @dev: virtio device
+ * @addr: DMA address
+ *
+ * Returns 0 means dma valid. Other means invalid dma address.
+ */
+int virtio_dma_mapping_error(struct device *dev, dma_addr_t addr)
+{
+	struct virtio_device *vdev = dev_to_virtio(dev);
+
+	if (!vring_use_dma_api(vdev))
+		return 0;
+
+	return dma_mapping_error(vdev->dev.parent, addr);
+}
+EXPORT_SYMBOL_GPL(virtio_dma_mapping_error);
+
+/**
+ * virtio_dma_unmap - unmap DMA addr
+ * @dev: virtio device
+ * @dma: DMA address
+ * @length: memory length
+ * @dir: DMA direction
+ */
+void virtio_dma_unmap(struct device *dev, dma_addr_t dma, unsigned int length,
+		      enum dma_data_direction dir)
+{
+	struct virtio_device *vdev = dev_to_virtio(dev);
+
+	if (!vring_use_dma_api(vdev))
+		return;
+
+	dma_unmap_page(vdev->dev.parent, dma, length, dir);
+}
+EXPORT_SYMBOL_GPL(virtio_dma_unmap);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 72292a62cd90..e86ea3b1a124 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/gfp.h>
+#include <linux/dma-mapping.h>
 
 /**
  * virtqueue - a queue to register buffers for sending or receiving.
@@ -196,4 +197,10 @@ void unregister_virtio_driver(struct virtio_driver *drv);
 #define module_virtio_driver(__virtio_driver) \
 	module_driver(__virtio_driver, register_virtio_driver, \
 			unregister_virtio_driver)
+
+dma_addr_t virtio_dma_map(struct device *dev, void *addr, unsigned int length,
+			  enum dma_data_direction dir);
+int virtio_dma_mapping_error(struct device *dev, dma_addr_t addr);
+void virtio_dma_unmap(struct device *dev, dma_addr_t dma, unsigned int length,
+		      enum dma_data_direction dir);
 #endif /* _LINUX_VIRTIO_H */
-- 
2.31.0

