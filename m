Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7391349476F
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358779AbiATGnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:43:11 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:49799 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358770AbiATGnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:43:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2KlUbq_1642660987;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2KlUbq_1642660987)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 14:43:07 +0800
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
Subject: [PATCH v2 03/12] virtio: queue_reset: struct virtio_config_ops add callbacks for queue_reset
Date:   Thu, 20 Jan 2022 14:42:54 +0800
Message-Id: <20220120064303.106639-4-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
References: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Performing reset on a queue is divided into two steps:

1. reset_vq: reset one vq
2. enable_reset_vq: re-enable the reset queue

In the first step, these tasks will be completed:
    1. notify the hardware queue to reset
    2. recycle the buffer from vq
    3. delete the vq

So add two callbacks reset_vq, enable_reset_vq to struct
virtio_config_ops. The parameters of enable_reset_vq are similar to
those of find_vqs.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/linux/virtio_config.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 4d107ad31149..e50a377c27a0 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -74,8 +74,22 @@ struct virtio_shm_region {
  * @set_vq_affinity: set the affinity for a virtqueue (optional).
  * @get_vq_affinity: get the affinity for a virtqueue (optional).
  * @get_shm_region: get a shared memory region based on the index.
+ * @reset_vq: reset a queue individually
+ *	vdev: the device
+ *	queue_index: the queue index
+ *	callback: callback to free unused bufs
+ *	data: pass to callback
+ *	returns 0 on success or error status
+ * @enable_reset_vq: enable a reset queue
+ *	vdev: the device
+ *	queue_index: the queue index
+ *	callback: callback for the virtqueue, NULL for vq that do not need a callback
+ *	name: virtqueue names (mainly for debugging), NULL for vq unused by driver
+ *	ctx: ctx
+ *	returns vq on success or error status
  */
 typedef void vq_callback_t(struct virtqueue *);
+typedef void vq_reset_callback_t(struct virtio_device *vdev, void *buf, void *data);
 struct virtio_config_ops {
 	void (*enable_cbs)(struct virtio_device *vdev);
 	void (*get)(struct virtio_device *vdev, unsigned offset,
@@ -100,6 +114,12 @@ struct virtio_config_ops {
 			int index);
 	bool (*get_shm_region)(struct virtio_device *vdev,
 			       struct virtio_shm_region *region, u8 id);
+	int (*reset_vq)(struct virtio_device *vdev, u16 queue_index,
+			vq_reset_callback_t *callback, void *data);
+	struct virtqueue *(*enable_reset_vq)(struct virtio_device *vdev,
+					     u16 queue_index,
+					     vq_callback_t *callback,
+					     const char *name, const bool *ctx);
 };
 
 /* If driver didn't advertise the feature, it will never appear. */
-- 
2.31.0

