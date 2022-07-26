Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59E3580CAE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbiGZHXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238066AbiGZHW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:22:58 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EED02B18C;
        Tue, 26 Jul 2022 00:22:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VKUOEZz_1658820161;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VKUOEZz_1658820161)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 15:22:42 +0800
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
Subject: [PATCH v13 08/42] virtio_ring: split: __vring_new_virtqueue() accept struct vring_virtqueue_split
Date:   Tue, 26 Jul 2022 15:21:51 +0800
Message-Id: <20220726072225.19884-9-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 19d2a6aae0b1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__vring_new_virtqueue() instead accepts struct vring_virtqueue_split.

The purpose of this is to pass more information into
__vring_new_virtqueue() to make the code simpler and the structure
cleaner.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4e54ed7ee7fb..4d65c437d968 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -205,7 +205,7 @@ struct vring_virtqueue {
 };
 
 static struct virtqueue *__vring_new_virtqueue(unsigned int index,
-					       struct vring vring,
+					       struct vring_virtqueue_split *vring_split,
 					       struct virtio_device *vdev,
 					       bool weak_barriers,
 					       bool context,
@@ -959,6 +959,7 @@ static struct virtqueue *vring_create_virtqueue_split(
 	void (*callback)(struct virtqueue *),
 	const char *name)
 {
+	struct vring_virtqueue_split vring_split = {};
 	struct virtqueue *vq;
 	void *queue = NULL;
 	dma_addr_t dma_addr;
@@ -994,10 +995,10 @@ static struct virtqueue *vring_create_virtqueue_split(
 		return NULL;
 
 	queue_size_in_bytes = vring_size(num, vring_align);
-	vring_init(&vring, num, queue, vring_align);
+	vring_init(&vring_split.vring, num, queue, vring_align);
 
-	vq = __vring_new_virtqueue(index, vring, vdev, weak_barriers, context,
-				   notify, callback, name);
+	vq = __vring_new_virtqueue(index, &vring_split, vdev, weak_barriers,
+				   context, notify, callback, name);
 	if (!vq) {
 		vring_free_queue(vdev, queue_size_in_bytes, queue,
 				 dma_addr);
@@ -2206,7 +2207,7 @@ EXPORT_SYMBOL_GPL(vring_interrupt);
 
 /* Only available for split ring */
 static struct virtqueue *__vring_new_virtqueue(unsigned int index,
-					       struct vring vring,
+					       struct vring_virtqueue_split *vring_split,
 					       struct virtio_device *vdev,
 					       bool weak_barriers,
 					       bool context,
@@ -2243,7 +2244,7 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->split.queue_dma_addr = 0;
 	vq->split.queue_size_in_bytes = 0;
 
-	vq->split.vring = vring;
+	vq->split.vring = vring_split->vring;
 	vq->split.avail_flags_shadow = 0;
 	vq->split.avail_idx_shadow = 0;
 
@@ -2255,19 +2256,19 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 					vq->split.avail_flags_shadow);
 	}
 
-	vq->split.desc_state = kmalloc_array(vring.num,
+	vq->split.desc_state = kmalloc_array(vring_split->vring.num,
 			sizeof(struct vring_desc_state_split), GFP_KERNEL);
 	if (!vq->split.desc_state)
 		goto err_state;
 
-	vq->split.desc_extra = vring_alloc_desc_extra(vring.num);
+	vq->split.desc_extra = vring_alloc_desc_extra(vring_split->vring.num);
 	if (!vq->split.desc_extra)
 		goto err_extra;
 
-	memset(vq->split.desc_state, 0, vring.num *
+	memset(vq->split.desc_state, 0, vring_split->vring.num *
 			sizeof(struct vring_desc_state_split));
 
-	virtqueue_init(vq, vq->split.vring.num);
+	virtqueue_init(vq, vring_split->vring.num);
 
 	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
@@ -2317,14 +2318,14 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
 				      void (*callback)(struct virtqueue *vq),
 				      const char *name)
 {
-	struct vring vring;
+	struct vring_virtqueue_split vring_split = {};
 
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return NULL;
 
-	vring_init(&vring, num, pages, vring_align);
-	return __vring_new_virtqueue(index, vring, vdev, weak_barriers, context,
-				     notify, callback, name);
+	vring_init(&vring_split.vring, num, pages, vring_align);
+	return __vring_new_virtqueue(index, &vring_split, vdev, weak_barriers,
+				     context, notify, callback, name);
 }
 EXPORT_SYMBOL_GPL(vring_new_virtqueue);
 
-- 
2.31.0

