Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BF24F6512
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbiDFQNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237707AbiDFQMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:12:37 -0400
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B92F264830;
        Tue,  5 Apr 2022 20:44:18 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V9Jziol_1649216650;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9Jziol_1649216650)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 06 Apr 2022 11:44:11 +0800
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
Subject: [PATCH v9 11/32] virtio_ring: split: introduce virtqueue_resize_split()
Date:   Wed,  6 Apr 2022 11:43:25 +0800
Message-Id: <20220406034346.74409-12-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 881cb3483d12
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio ring split supports resize.

Only after the new vring is successfully allocated based on the new num,
we will release the old vring. In any case, an error is returned,
indicating that the vring still points to the old vring.

In the case of an error, the caller must
re-initialize(virtqueue_reinit_split()) the virtqueue to ensure that the
vring can be used.

In addition, vring_align, may_reduce_num are necessary for reallocating
vring, so they are retained for creating vq.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 47 ++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 3dc6ace2ba7a..33864134a744 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -139,6 +139,12 @@ struct vring_virtqueue {
 			/* DMA address and size information */
 			dma_addr_t queue_dma_addr;
 			size_t queue_size_in_bytes;
+
+			/* The parameters for creating vrings are reserved for
+			 * creating new vring.
+			 */
+			u32 vring_align;
+			bool may_reduce_num;
 		} split;
 
 		/* Available for packed ring */
@@ -199,6 +205,7 @@ struct vring_virtqueue {
 };
 
 static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num);
+static void vring_free(struct virtqueue *_vq);
 
 /*
  * Helpers.
@@ -1088,6 +1095,8 @@ static struct virtqueue *vring_create_virtqueue_split(
 		return NULL;
 	}
 
+	to_vvq(vq)->split.vring_align = vring_align;
+	to_vvq(vq)->split.may_reduce_num = may_reduce_num;
 	to_vvq(vq)->split.queue_dma_addr = dma_addr;
 	to_vvq(vq)->split.queue_size_in_bytes = queue_size_in_bytes;
 	to_vvq(vq)->we_own_ring = true;
@@ -1095,6 +1104,44 @@ static struct virtqueue *vring_create_virtqueue_split(
 	return vq;
 }
 
+static int virtqueue_resize_split(struct virtqueue *_vq, u32 num)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct virtio_device *vdev = _vq->vdev;
+	struct vring_desc_state_split *state;
+	struct vring_desc_extra *extra;
+	size_t queue_size_in_bytes;
+	dma_addr_t dma_addr;
+	struct vring vring;
+	int err = -ENOMEM;
+	void *queue;
+
+	queue = vring_alloc_queue_split(vdev, &dma_addr, &num,
+					vq->split.vring_align,
+					vq->weak_barriers,
+					vq->split.may_reduce_num);
+	if (!queue)
+		return -ENOMEM;
+
+	queue_size_in_bytes = vring_size(num, vq->split.vring_align);
+
+	err = vring_alloc_state_extra_split(num, &state, &extra);
+	if (err) {
+		vring_free_queue(vdev, queue_size_in_bytes, queue, dma_addr);
+		return -ENOMEM;
+	}
+
+	vring_free(&vq->vq);
+
+	vring_init(&vring, num, queue, vq->split.vring_align);
+	vring_virtqueue_attach_split(vq, vring, state, extra);
+	vq->split.queue_dma_addr = dma_addr;
+	vq->split.queue_size_in_bytes = queue_size_in_bytes;
+
+	vring_virtqueue_init_split(vq, vdev, true);
+	return 0;
+}
+
 
 /*
  * Packed ring specific functions - *_packed().
-- 
2.31.0

