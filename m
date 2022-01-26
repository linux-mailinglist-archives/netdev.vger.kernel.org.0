Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A38D49C498
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbiAZHgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:36:15 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:33398 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237917AbiAZHfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:47 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2ubkkx_1643182543;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2ubkkx_1643182543)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:43 +0800
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
Subject: [PATCH v3 09/17] virtio_ring: queue_reset: add vring_reset_virtqueue()
Date:   Wed, 26 Jan 2022 15:35:25 +0800
Message-Id: <20220126073533.44994-10-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added vring_reset_virtqueue() for reset vring_virtqueue.

In this process, vq is removed from the vdev->vqs queue. And the memory
of the ring is released

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 12 +++++++++++-
 include/linux/virtio_ring.h  |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4beb7c7127c1..bba9f3c67b33 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2391,11 +2391,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	__vring_del_virtqueue(vq);
+	if (!_vq->reset)
+		__vring_del_virtqueue(vq);
 	kfree(vq);
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
 
+void vring_reset_virtqueue(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	__vring_del_virtqueue(vq);
+	_vq->reset = true;
+}
+EXPORT_SYMBOL_GPL(vring_reset_virtqueue);
+
 /* Manipulates transport-specific feature bits. */
 void vring_transport_features(struct virtio_device *vdev)
 {
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index e90323fce4bf..84b55fb8686d 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -124,6 +124,11 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
  */
 void vring_del_virtqueue(struct virtqueue *vq);
 
+/*
+ * Resets a virtqueue. Just frees the ring, not free vq.
+ */
+void vring_reset_virtqueue(struct virtqueue *vq);
+
 /* Filter out transport-specific feature bits. */
 void vring_transport_features(struct virtio_device *vdev);
 
-- 
2.31.0

