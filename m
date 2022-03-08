Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440494D1771
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346868AbiCHMgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346855AbiCHMge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:36:34 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D534D4348C;
        Tue,  8 Mar 2022 04:35:33 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V6eQtXl_1646742927;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6eQtXl_1646742927)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 20:35:28 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
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
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v7 04/26] virtio_ring: split: extract the logic of creating vring
Date:   Tue,  8 Mar 2022 20:34:56 +0800
Message-Id: <20220308123518.33800-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: f06b131dbfed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the logic of split to create vring queue.

For the convenience of passing parameters, add a structure
vring_split.

This feature is required for subsequent virtuqueue reset vring.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 74 +++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 23 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index b87130c8f312..d32793615451 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -85,6 +85,13 @@ struct vring_desc_extra {
 	u16 next;			/* The next desc state in a list. */
 };
 
+struct vring_split {
+	void *queue;
+	dma_addr_t dma_addr;
+	size_t queue_size_in_bytes;
+	struct vring vring;
+};
+
 struct vring_virtqueue {
 	struct virtqueue vq;
 
@@ -915,28 +922,21 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
 	return NULL;
 }
 
-static struct virtqueue *vring_create_virtqueue_split(
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
+static int vring_create_vring_split(struct vring_split *vring,
+				    struct virtio_device *vdev,
+				    unsigned int vring_align,
+				    bool weak_barriers,
+				    bool may_reduce_num,
+				    u32 num)
 {
-	struct virtqueue *vq;
 	void *queue = NULL;
 	dma_addr_t dma_addr;
 	size_t queue_size_in_bytes;
-	struct vring vring;
 
 	/* We assume num is a power of 2. */
 	if (num & (num - 1)) {
 		dev_warn(&vdev->dev, "Bad virtqueue length %u\n", num);
-		return NULL;
+		return -EINVAL;
 	}
 
 	/* TODO: allocate each queue chunk individually */
@@ -947,11 +947,11 @@ static struct virtqueue *vring_create_virtqueue_split(
 		if (queue)
 			break;
 		if (!may_reduce_num)
-			return NULL;
+			return -ENOMEM;
 	}
 
 	if (!num)
-		return NULL;
+		return -ENOMEM;
 
 	if (!queue) {
 		/* Try to get a single page. You are my only hope! */
@@ -959,21 +959,49 @@ static struct virtqueue *vring_create_virtqueue_split(
 					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
 	}
 	if (!queue)
-		return NULL;
+		return -ENOMEM;
 
 	queue_size_in_bytes = vring_size(num, vring_align);
-	vring_init(&vring, num, queue, vring_align);
+	vring_init(&vring->vring, num, queue, vring_align);
+
+	vring->dma_addr = dma_addr;
+	vring->queue = queue;
+	vring->queue_size_in_bytes = queue_size_in_bytes;
+
+	return 0;
+}
+
+static struct virtqueue *vring_create_virtqueue_split(
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
+	struct vring_split vring;
+	struct virtqueue *vq;
+	int err;
+
+	err = vring_create_vring_split(&vring, vdev, vring_align, weak_barriers,
+				       may_reduce_num, num);
+	if (err)
+		return NULL;
 
-	vq = __vring_new_virtqueue(index, vring, vdev, weak_barriers, context,
+	vq = __vring_new_virtqueue(index, vring.vring, vdev, weak_barriers, context,
 				   notify, callback, name);
 	if (!vq) {
-		vring_free_queue(vdev, queue_size_in_bytes, queue,
-				 dma_addr);
+		vring_free_queue(vdev, vring.queue_size_in_bytes, vring.queue,
+				 vring.dma_addr);
 		return NULL;
 	}
 
-	to_vvq(vq)->split.queue_dma_addr = dma_addr;
-	to_vvq(vq)->split.queue_size_in_bytes = queue_size_in_bytes;
+	to_vvq(vq)->split.queue_dma_addr = vring.dma_addr;
+	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
 	to_vvq(vq)->we_own_ring = true;
 
 	return vq;
-- 
2.31.0

