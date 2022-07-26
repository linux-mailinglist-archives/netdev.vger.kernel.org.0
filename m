Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE90580CFD
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbiGZHX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238070AbiGZHXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:23:16 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519512B609;
        Tue, 26 Jul 2022 00:23:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VKUNV98_1658820180;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VKUNV98_1658820180)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 15:23:01 +0800
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
Subject: [PATCH v13 18/42] virtio_ring: packed: extract the logic of alloc queue
Date:   Tue, 26 Jul 2022 15:22:01 +0800
Message-Id: <20220726072225.19884-19-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 19d2a6aae0b1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the logic of packed to create vring queue.

This feature is required for subsequent virtuqueue reset vring.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 80 +++++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 29 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 891900b31c3d..10cc2b7e3588 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1857,19 +1857,10 @@ static void vring_free_packed(struct vring_virtqueue_packed *vring_packed,
 	kfree(vring_packed->desc_extra);
 }
 
-static struct virtqueue *vring_create_virtqueue_packed(
-	unsigned int index,
-	unsigned int num,
-	unsigned int vring_align,
-	struct virtio_device *vdev,
-	bool weak_barriers,
-	bool may_reduce_num,
-	bool context,
-	bool (*notify)(struct virtqueue *),
-	void (*callback)(struct virtqueue *),
-	const char *name)
+static int vring_alloc_queue_packed(struct vring_virtqueue_packed *vring_packed,
+				    struct virtio_device *vdev,
+				    u32 num)
 {
-	struct vring_virtqueue *vq;
 	struct vring_packed_desc *ring;
 	struct vring_packed_desc_event *driver, *device;
 	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
@@ -1881,7 +1872,11 @@ static struct virtqueue *vring_create_virtqueue_packed(
 				 &ring_dma_addr,
 				 GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
 	if (!ring)
-		goto err_ring;
+		goto err;
+
+	vring_packed->vring.desc         = ring;
+	vring_packed->ring_dma_addr      = ring_dma_addr;
+	vring_packed->ring_size_in_bytes = ring_size_in_bytes;
 
 	event_size_in_bytes = sizeof(struct vring_packed_desc_event);
 
@@ -1889,13 +1884,47 @@ static struct virtqueue *vring_create_virtqueue_packed(
 				   &driver_event_dma_addr,
 				   GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
 	if (!driver)
-		goto err_driver;
+		goto err;
+
+	vring_packed->vring.driver          = driver;
+	vring_packed->event_size_in_bytes   = event_size_in_bytes;
+	vring_packed->driver_event_dma_addr = driver_event_dma_addr;
 
 	device = vring_alloc_queue(vdev, event_size_in_bytes,
 				   &device_event_dma_addr,
 				   GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
 	if (!device)
-		goto err_device;
+		goto err;
+
+	vring_packed->vring.device          = device;
+	vring_packed->device_event_dma_addr = device_event_dma_addr;
+
+	vring_packed->vring.num = num;
+
+	return 0;
+
+err:
+	vring_free_packed(vring_packed, vdev);
+	return -ENOMEM;
+}
+
+static struct virtqueue *vring_create_virtqueue_packed(
+	unsigned int index,
+	unsigned int num,
+	unsigned int vring_align,
+	struct virtio_device *vdev,
+	bool weak_barriers,
+	bool may_reduce_num,
+	bool context,
+	bool (*notify)(struct virtqueue *),
+	void (*callback)(struct virtqueue *),
+	const char *name)
+{
+	struct vring_virtqueue_packed vring_packed = {};
+	struct vring_virtqueue *vq;
+
+	if (vring_alloc_queue_packed(&vring_packed, vdev, num))
+		goto err_ring;
 
 	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
 	if (!vq)
@@ -1918,17 +1947,14 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
 
-	vq->packed.ring_dma_addr = ring_dma_addr;
-	vq->packed.driver_event_dma_addr = driver_event_dma_addr;
-	vq->packed.device_event_dma_addr = device_event_dma_addr;
+	vq->packed.ring_dma_addr = vring_packed.ring_dma_addr;
+	vq->packed.driver_event_dma_addr = vring_packed.driver_event_dma_addr;
+	vq->packed.device_event_dma_addr = vring_packed.device_event_dma_addr;
 
-	vq->packed.ring_size_in_bytes = ring_size_in_bytes;
-	vq->packed.event_size_in_bytes = event_size_in_bytes;
+	vq->packed.ring_size_in_bytes = vring_packed.ring_size_in_bytes;
+	vq->packed.event_size_in_bytes = vring_packed.event_size_in_bytes;
 
-	vq->packed.vring.num = num;
-	vq->packed.vring.desc = ring;
-	vq->packed.vring.driver = driver;
-	vq->packed.vring.device = device;
+	vq->packed.vring = vring_packed.vring;
 
 	vq->packed.next_avail_idx = 0;
 	vq->packed.avail_wrap_counter = 1;
@@ -1967,11 +1993,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 err_desc_state:
 	kfree(vq);
 err_vq:
-	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
-err_device:
-	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
-err_driver:
-	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
+	vring_free_packed(&vring_packed, vdev);
 err_ring:
 	return NULL;
 }
-- 
2.31.0

