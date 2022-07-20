Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5624C57AEEF
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 05:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241950AbiGTDHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 23:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbiGTDGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 23:06:49 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1450E709B6;
        Tue, 19 Jul 2022 20:05:35 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VJux97M_1658286326;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VJux97M_1658286326)
          by smtp.aliyun-inc.com;
          Wed, 20 Jul 2022 11:05:28 +0800
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
Subject: [PATCH v12 21/40] virtio_ring: packed: introduce virtqueue_resize_packed()
Date:   Wed, 20 Jul 2022 11:04:17 +0800
Message-Id: <20220720030436.79520-22-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 366032b2ffac
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

virtio ring packed supports resize.

Only after the new vring is successfully allocated based on the new num,
we will release the old vring. In any case, an error is returned,
indicating that the vring still points to the old vring.

In the case of an error, re-initialize(by virtqueue_reinit_packed()) the
virtqueue to ensure that the vring can be used.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5802cd373fd1..b092914e9dcd 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2045,6 +2045,35 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	return NULL;
 }
 
+static int virtqueue_resize_packed(struct virtqueue *_vq, u32 num)
+{
+	struct vring_virtqueue_packed vring_packed = {};
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct virtio_device *vdev = _vq->vdev;
+	int err;
+
+	if (vring_alloc_queue_packed(&vring_packed, vdev, num))
+		goto err_ring;
+
+	err = vring_alloc_state_extra_packed(&vring_packed);
+	if (err)
+		goto err_state_extra;
+
+	vring_free(&vq->vq);
+
+	virtqueue_init(vq, vring_packed.vring.num);
+	virtqueue_vring_attach_packed(vq, &vring_packed);
+	virtqueue_vring_init_packed(vq);
+
+	return 0;
+
+err_state_extra:
+	vring_free_packed(&vring_packed, vdev);
+err_ring:
+	virtqueue_reinit_packed(vq);
+	return -ENOMEM;
+}
+
 
 /*
  * Generic functions and exported symbols.
-- 
2.31.0

