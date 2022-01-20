Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C220A494784
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358823AbiATGnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:43:25 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:54188 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358790AbiATGnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:43:17 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2LASB-_1642660992;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2LASB-_1642660992)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 14:43:13 +0800
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
Subject: [PATCH v2 08/12] virtio: queue_reset: add helper
Date:   Thu, 20 Jan 2022 14:42:59 +0800
Message-Id: <20220120064303.106639-9-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
References: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper for virtio queue reset.

* virtio_reset_vq: reset a queue individually
* virtio_enable_resetq: enable a reset queue

In the virtio_reset_vq(), these tasks will be completed:
   1. notify the hardware queue to reset
   2. recycle the buffer from vq
   3. delete the vq

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/linux/virtio_config.h | 43 +++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index e50a377c27a0..f84347f4e4ee 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -239,6 +239,49 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
 				      desc);
 }
 
+/**
+ * virtio_reset_vq - reset a queue individually
+ * @vdev: the device
+ * @queue_index: the queue index
+ * @callback: callback to free unused bufs
+ * @data: pass to callback
+ *
+ * returns 0 on success or error status
+ *
+ */
+static inline
+int virtio_reset_vq(struct virtio_device *vdev, u16 queue_index,
+		    vq_reset_callback_t *callback, void *data)
+{
+	if (!vdev->config->reset_vq)
+		return -ENOENT;
+
+	return vdev->config->reset_vq(vdev, queue_index, callback, data);
+}
+
+/**
+ * virtio_enable_resetq - enable a reset queue
+ * @vdev: the device
+ * @queue_index: the queue index
+ * @callback: callback for the virtqueue, NULL for vq that do not need a callback
+ * @name: virtqueue names (mainly for debugging), NULL for vq unused by driver
+ * @ctx: ctx
+ *
+ * returns vq on success or error status
+ *
+ */
+static inline
+struct virtqueue *virtio_enable_resetq(struct virtio_device *vdev,
+				       u16 queue_index, vq_callback_t *callback,
+				       const char *name, const bool *ctx)
+{
+	if (!vdev->config->enable_reset_vq)
+		return ERR_PTR(-ENOENT);
+
+	return vdev->config->enable_reset_vq(vdev, queue_index, callback,
+					     name, ctx);
+}
+
 /**
  * virtio_device_ready - enable vq use in probe function
  * @vdev: the device
-- 
2.31.0

