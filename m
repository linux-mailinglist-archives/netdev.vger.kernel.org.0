Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4545C687B42
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbjBBLBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBBLBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:22 -0500
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051E0885D1;
        Thu,  2 Feb 2023 03:01:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VakkM26_1675335667;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VakkM26_1675335667)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:01:08 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 07/33] virtio_ring: add api virtio_dma_map() for advance dma
Date:   Thu,  2 Feb 2023 19:00:32 +0800
Message-Id: <20230202110058.130695-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d7589ab6ea10
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/virtio/virtio_ring.c | 80 ++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  9 ++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 7dfce7001f9f..67eda7bc23ea 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -3022,4 +3022,84 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_vring);
 
+/**
+ * virtio_dma_map_page - get the DMA addr of the memory for virtio device
+ * @dev: virtio device
+ * @page: the page of the memory to DMA
+ * @offset: the offset of the memory inside page
+ * @length: memory length
+ * @dir: DMA direction
+ *
+ * Returns the DMA addr. DMA_MAPPING_ERROR means error.
+ */
+dma_addr_t virtio_dma_map_page(struct device *dev, struct page *page, size_t offset,
+			       unsigned int length, enum dma_data_direction dir)
+{
+	struct virtio_device *vdev = dev_to_virtio(dev);
+
+	if (!vring_use_dma_api(vdev))
+		return page_to_phys(page) + offset;
+
+	return dma_map_page(vdev->dev.parent, page, offset, length, dir);
+}
+
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
+	struct page *page;
+	size_t offset;
+
+	page = virt_to_page(addr);
+	offset = offset_in_page(addr);
+
+	return virtio_dma_map_page(dev, page, offset, length, dir);
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
index 3ca2edb1aef3..ce89126becc5 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/gfp.h>
+#include <linux/dma-mapping.h>
 
 /**
  * struct virtqueue - a queue to register buffers for sending or receiving.
@@ -218,4 +219,12 @@ void unregister_virtio_driver(struct virtio_driver *drv);
 #define module_virtio_driver(__virtio_driver) \
 	module_driver(__virtio_driver, register_virtio_driver, \
 			unregister_virtio_driver)
+
+dma_addr_t virtio_dma_map_page(struct device *dev, struct page *page, size_t offset,
+			       unsigned int length, enum dma_data_direction dir);
+dma_addr_t virtio_dma_map(struct device *dev, void *addr, unsigned int length,
+			  enum dma_data_direction dir);
+int virtio_dma_mapping_error(struct device *dev, dma_addr_t addr);
+void virtio_dma_unmap(struct device *dev, dma_addr_t dma, unsigned int length,
+		      enum dma_data_direction dir);
 #endif /* _LINUX_VIRTIO_H */
-- 
2.32.0.3.g01195cf9f

