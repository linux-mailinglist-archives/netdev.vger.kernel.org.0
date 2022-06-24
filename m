Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24842558E72
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 04:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiFXC6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 22:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiFXC5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 22:57:36 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B304462BE7;
        Thu, 23 Jun 2022 19:57:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VHErswn_1656039447;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHErswn_1656039447)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 10:57:28 +0800
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
Subject: [PATCH v10 29/41] virtio_pci: introduce helper to get/set queue reset
Date:   Fri, 24 Jun 2022 10:56:09 +0800
Message-Id: <20220624025621.128843-30-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
References: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: fef800c86cd2
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new helpers to implement queue reset and get queue reset
status.

 https://github.com/oasis-tcs/virtio-spec/issues/124
 https://github.com/oasis-tcs/virtio-spec/issues/139

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_modern_dev.c | 39 ++++++++++++++++++++++++++
 include/linux/virtio_pci_modern.h      |  2 ++
 2 files changed, 41 insertions(+)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index b790f30b2b56..992bd62d67f5 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -3,6 +3,7 @@
 #include <linux/virtio_pci_modern.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 
 /*
  * vp_modern_map_capability - map a part of virtio pci capability
@@ -476,6 +477,44 @@ void vp_modern_set_status(struct virtio_pci_modern_device *mdev,
 }
 EXPORT_SYMBOL_GPL(vp_modern_set_status);
 
+/*
+ * vp_modern_get_queue_reset - get the queue reset status
+ * @mdev: the modern virtio-pci device
+ * @index: queue index
+ */
+int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
+{
+	struct virtio_pci_common_cfg_reset __iomem *cfg;
+
+	cfg = (struct virtio_pci_common_cfg_reset __iomem *)mdev->common;
+
+	vp_iowrite16(index, &cfg->cfg.queue_select);
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
+	struct virtio_pci_common_cfg_reset __iomem *cfg;
+
+	cfg = (struct virtio_pci_common_cfg_reset __iomem *)mdev->common;
+
+	vp_iowrite16(index, &cfg->cfg.queue_select);
+	vp_iowrite16(1, &cfg->queue_reset);
+
+	while (vp_ioread16(&cfg->queue_reset))
+		msleep(1);
+
+	while (vp_ioread16(&mdev->common->queue_enable))
+		msleep(1);
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
-- 
2.31.0

