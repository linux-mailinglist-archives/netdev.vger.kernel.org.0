Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551E24D17AE
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346945AbiCHMgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344801AbiCHMgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:36:46 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A8947074;
        Tue,  8 Mar 2022 04:35:44 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V6eTXaY_1646742937;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6eTXaY_1646742937)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 20:35:39 +0800
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
Subject: [PATCH v7 09/26] virtio_ring: split: implement virtqueue_reset_vring_split()
Date:   Tue,  8 Mar 2022 20:35:01 +0800
Message-Id: <20220308123518.33800-10-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: f06b131dbfed
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

virtio ring supports reset.

Queue reset is divided into several stages.

1. notify device queue reset
2. vring release
3. attach new vring
4. notify device queue re-enable

After the first step is completed, the vring reset operation can be
performed. If the newly set vring num does not change, then just reset
the vq related value.

Otherwise, the vring will be released and the vring will be reallocated.
And the vring will be attached to the vq. If this process fails, the
function will exit, and the state of the vq will be the vring release
state. You can call this function again to reallocate the vring.

In addition, vring_align, may_reduce_num are necessary for reallocating
vring, so they are retained when creating vq.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 69 ++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index e0422c04c903..148fb1fd3d5a 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -158,6 +158,12 @@ struct vring_virtqueue {
 			/* DMA address and size information */
 			dma_addr_t queue_dma_addr;
 			size_t queue_size_in_bytes;
+
+			/* The parameters for creating vrings are reserved for
+			 * creating new vrings when enabling reset queue.
+			 */
+			u32 vring_align;
+			bool may_reduce_num;
 		} split;
 
 		/* Available for packed ring */
@@ -217,6 +223,12 @@ struct vring_virtqueue {
 #endif
 };
 
+static void vring_free(struct virtqueue *vq);
+static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
+					 struct virtio_device *vdev);
+static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
+					  struct virtio_device *vdev,
+					  struct vring vring);
 
 /*
  * Helpers.
@@ -1012,6 +1024,8 @@ static struct virtqueue *vring_create_virtqueue_split(
 		return NULL;
 	}
 
+	to_vvq(vq)->split.vring_align = vring_align;
+	to_vvq(vq)->split.may_reduce_num = may_reduce_num;
 	to_vvq(vq)->split.queue_dma_addr = vring.dma_addr;
 	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
 	to_vvq(vq)->we_own_ring = true;
@@ -1019,6 +1033,59 @@ static struct virtqueue *vring_create_virtqueue_split(
 	return vq;
 }
 
+static int virtqueue_reset_vring_split(struct virtqueue *_vq, u32 num)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct virtio_device *vdev = _vq->vdev;
+	struct vring_split vring;
+	int err;
+
+	if (num > _vq->num_max)
+		return -E2BIG;
+
+	switch (vq->vq.reset) {
+	case VIRTIO_VQ_RESET_STEP_NONE:
+		return -ENOENT;
+
+	case VIRTIO_VQ_RESET_STEP_VRING_ATTACH:
+	case VIRTIO_VQ_RESET_STEP_DEVICE:
+		if (vq->split.vring.num == num || !num)
+			break;
+
+		vring_free(_vq);
+
+		fallthrough;
+
+	case VIRTIO_VQ_RESET_STEP_VRING_RELEASE:
+		if (!num)
+			num = vq->split.vring.num;
+
+		err = vring_create_vring_split(&vring, vdev,
+					       vq->split.vring_align,
+					       vq->weak_barriers,
+					       vq->split.may_reduce_num, num);
+		if (err)
+			return -ENOMEM;
+
+		err = __vring_virtqueue_attach_split(vq, vdev, vring.vring);
+		if (err) {
+			vring_free_queue(vdev, vring.queue_size_in_bytes,
+					 vring.queue,
+					 vring.dma_addr);
+			return -ENOMEM;
+		}
+
+		vq->split.queue_dma_addr = vring.dma_addr;
+		vq->split.queue_size_in_bytes = vring.queue_size_in_bytes;
+	}
+
+	__vring_virtqueue_init_split(vq, vdev);
+	vq->we_own_ring = true;
+	vq->vq.reset = VIRTIO_VQ_RESET_STEP_VRING_ATTACH;
+
+	return 0;
+}
+
 
 /*
  * Packed ring specific functions - *_packed().
@@ -2317,6 +2384,8 @@ static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
 static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
 					 struct virtio_device *vdev)
 {
+	vq->vq.reset = VIRTIO_VQ_RESET_STEP_NONE;
+
 	vq->packed_ring = false;
 	vq->we_own_ring = false;
 	vq->broken = false;
-- 
2.31.0

