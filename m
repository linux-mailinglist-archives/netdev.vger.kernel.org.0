Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7143B4F5B44
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 12:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351082AbiDFKT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376940AbiDFKSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:18:34 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A2A2662C5;
        Tue,  5 Apr 2022 20:44:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V9K8DYd_1649216652;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9K8DYd_1649216652)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 06 Apr 2022 11:44:14 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v9 12/32] virtio_ring: packed: extract the logic of alloc queue
Date:   Wed,  6 Apr 2022 11:43:26 +0800
Message-Id: <20220406034346.74409-13-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 881cb3483d12
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the logic of packed to create vring queue.

For the convenience of passing parameters, add a structure
vring_packed.

This feature is required for subsequent virtuqueue reset vring.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 70 ++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 33864134a744..ea451ae2aaef 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1817,19 +1817,17 @@ static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num)
 	return desc_extra;
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
+static int vring_alloc_queue_packed(struct virtio_device *vdev,
+				    u32 num,
+				    struct vring_packed_desc **_ring,
+				    struct vring_packed_desc_event **_driver,
+				    struct vring_packed_desc_event **_device,
+				    dma_addr_t *_ring_dma_addr,
+				    dma_addr_t *_driver_event_dma_addr,
+				    dma_addr_t *_device_event_dma_addr,
+				    size_t *_ring_size_in_bytes,
+				    size_t *_event_size_in_bytes)
 {
-	struct vring_virtqueue *vq;
 	struct vring_packed_desc *ring;
 	struct vring_packed_desc_event *driver, *device;
 	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
@@ -1857,6 +1855,52 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	if (!device)
 		goto err_device;
 
+	*_ring                   = ring;
+	*_driver                 = driver;
+	*_device                 = device;
+	*_ring_dma_addr          = ring_dma_addr;
+	*_driver_event_dma_addr  = driver_event_dma_addr;
+	*_device_event_dma_addr  = device_event_dma_addr;
+	*_ring_size_in_bytes     = ring_size_in_bytes;
+	*_event_size_in_bytes    = event_size_in_bytes;
+
+	return 0;
+
+err_device:
+	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
+
+err_driver:
+	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
+
+err_ring:
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
+	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
+	struct vring_packed_desc_event *driver, *device;
+	size_t ring_size_in_bytes, event_size_in_bytes;
+	struct vring_packed_desc *ring;
+	struct vring_virtqueue *vq;
+
+	if (vring_alloc_queue_packed(vdev, num, &ring, &driver, &device,
+				     &ring_dma_addr, &driver_event_dma_addr,
+				     &device_event_dma_addr,
+				     &ring_size_in_bytes,
+				     &event_size_in_bytes))
+		goto err_ring;
+
 	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
 	if (!vq)
 		goto err_vq;
@@ -1939,9 +1983,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	kfree(vq);
 err_vq:
 	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
-err_device:
 	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
-err_driver:
 	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
 err_ring:
 	return NULL;
-- 
2.31.0

