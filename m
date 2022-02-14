Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E0D4B4399
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbiBNIOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:14:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241631AbiBNIOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:14:37 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A6A5F8F9;
        Mon, 14 Feb 2022 00:14:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4NbDOX_1644826465;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4NbDOX_1644826465)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:25 +0800
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
Subject: [PATCH v5 08/22] virtio_ring: queue_reset: add vring_release_virtqueue()
Date:   Mon, 14 Feb 2022 16:14:02 +0800
Message-Id: <20220214081416.117695-9-xuanzhuo@linux.alibaba.com>
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

Added vring_release_virtqueue() to release the ring of the vq.

In this process, vq is removed from the vdev->vqs queue. And the memory
of the ring is released

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 18 +++++++++++++++++-
 include/linux/virtio.h       | 12 ++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c5dd17c7dd4a..b37753bdbbc4 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1730,6 +1730,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->vq.vdev = vdev;
 	vq->vq.num_free = num;
 	vq->vq.index = index;
+	vq->vq.reset = VIRTQUEUE_RESET_STAGE_NONE;
 	vq->we_own_ring = true;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
@@ -2218,6 +2219,7 @@ static int __vring_init_virtqueue(struct virtqueue *_vq,
 	vq->vq.vdev = vdev;
 	vq->vq.num_free = vring.num;
 	vq->vq.index = index;
+	vq->vq.reset = VIRTQUEUE_RESET_STAGE_NONE;
 	vq->we_own_ring = false;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
@@ -2397,11 +2399,25 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	__vring_del_virtqueue(vq);
+	if (_vq->reset != VIRTQUEUE_RESET_STAGE_RELEASE)
+		__vring_del_virtqueue(vq);
 	kfree(vq);
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
 
+void vring_release_virtqueue(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (_vq->reset != VIRTQUEUE_RESET_STAGE_DEVICE)
+		return;
+
+	__vring_del_virtqueue(vq);
+
+	_vq->reset = VIRTQUEUE_RESET_STAGE_RELEASE;
+}
+EXPORT_SYMBOL_GPL(vring_release_virtqueue);
+
 /* Manipulates transport-specific feature bits. */
 void vring_transport_features(struct virtio_device *vdev)
 {
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 72292a62cd90..cdb2a551257c 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -10,6 +10,12 @@
 #include <linux/mod_devicetable.h>
 #include <linux/gfp.h>
 
+enum virtqueue_reset_stage {
+	VIRTQUEUE_RESET_STAGE_NONE,
+	VIRTQUEUE_RESET_STAGE_DEVICE,
+	VIRTQUEUE_RESET_STAGE_RELEASE,
+};
+
 /**
  * virtqueue - a queue to register buffers for sending or receiving.
  * @list: the chain of virtqueues for this device
@@ -32,6 +38,7 @@ struct virtqueue {
 	unsigned int index;
 	unsigned int num_free;
 	void *priv;
+	enum virtqueue_reset_stage reset;
 };
 
 int virtqueue_add_outbuf(struct virtqueue *vq,
@@ -196,4 +203,9 @@ void unregister_virtio_driver(struct virtio_driver *drv);
 #define module_virtio_driver(__virtio_driver) \
 	module_driver(__virtio_driver, register_virtio_driver, \
 			unregister_virtio_driver)
+/*
+ * Resets a virtqueue. Just frees the ring, not free vq.
+ * This function must be called after reset_vq().
+ */
+void vring_release_virtqueue(struct virtqueue *vq);
 #endif /* _LINUX_VIRTIO_H */
-- 
2.31.0

