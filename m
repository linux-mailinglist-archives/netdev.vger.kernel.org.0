Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F6A57AED3
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 05:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbiGTDGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 23:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbiGTDFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 23:05:42 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894E0DC9;
        Tue, 19 Jul 2022 20:05:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VJux8zP_1658286298;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VJux8zP_1658286298)
          by smtp.aliyun-inc.com;
          Wed, 20 Jul 2022 11:04:59 +0800
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
Subject: [PATCH v12 09/40] virtio_ring: split: extract the logic of alloc state and extra
Date:   Wed, 20 Jul 2022 11:04:05 +0800
Message-Id: <20220720030436.79520-10-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 366032b2ffac
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

Separate the logic of creating desc_state, desc_extra, and subsequent
patches will call it independently.

Since only the structure vring is passed into __vring_new_virtqueue(),
when creating the function vring_alloc_state_extra_split(), we prefer to
use vring_virtqueue_split as a parameter, and it will be more convenient
to pass vring_virtqueue_split to some subsequent functions.

So a new vring_virtqueue_split variable is added in
__vring_new_virtqueue().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 54 +++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c7971438bb2c..ef2077e8b38d 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -204,6 +204,7 @@ struct vring_virtqueue {
 #endif
 };
 
+static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num);
 
 /*
  * Helpers.
@@ -939,6 +940,32 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
 	return NULL;
 }
 
+static int vring_alloc_state_extra_split(struct vring_virtqueue_split *vring_split)
+{
+	struct vring_desc_state_split *state;
+	struct vring_desc_extra *extra;
+	u32 num = vring_split->vring.num;
+
+	state = kmalloc_array(num, sizeof(struct vring_desc_state_split), GFP_KERNEL);
+	if (!state)
+		goto err_state;
+
+	extra = vring_alloc_desc_extra(num);
+	if (!extra)
+		goto err_extra;
+
+	memset(state, 0, num * sizeof(struct vring_desc_state_split));
+
+	vring_split->desc_state = state;
+	vring_split->desc_extra = extra;
+	return 0;
+
+err_extra:
+	kfree(state);
+err_state:
+	return -ENOMEM;
+}
+
 static void vring_free_split(struct vring_virtqueue_split *vring_split,
 			     struct virtio_device *vdev)
 {
@@ -2233,7 +2260,9 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 					void (*callback)(struct virtqueue *),
 					const char *name)
 {
+	struct vring_virtqueue_split vring_split = {};
 	struct vring_virtqueue *vq;
+	int err;
 
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return NULL;
@@ -2274,30 +2303,23 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 					vq->split.avail_flags_shadow);
 	}
 
-	vq->split.desc_state = kmalloc_array(vring.num,
-			sizeof(struct vring_desc_state_split), GFP_KERNEL);
-	if (!vq->split.desc_state)
-		goto err_state;
+	vring_split.vring = vring;
 
-	vq->split.desc_extra = vring_alloc_desc_extra(vring.num);
-	if (!vq->split.desc_extra)
-		goto err_extra;
+	err = vring_alloc_state_extra_split(&vring_split);
+	if (err) {
+		kfree(vq);
+		return NULL;
+	}
 
-	memset(vq->split.desc_state, 0, vring.num *
-			sizeof(struct vring_desc_state_split));
+	vq->split.desc_state = vring.desc_state;
+	vq->split.desc_extra = vring.desc_extra;
 
-	virtqueue_init(vq, vq->split.vring.num);
+	virtqueue_init(vq, vring_split.vring.num);
 
 	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 	spin_unlock(&vdev->vqs_list_lock);
 	return &vq->vq;
-
-err_extra:
-	kfree(vq->split.desc_state);
-err_state:
-	kfree(vq);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
 
-- 
2.31.0

