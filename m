Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEBA55F785
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiF2G7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiF2G6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:58:19 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6859326C2;
        Tue, 28 Jun 2022 23:57:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VHmY1MN_1656485861;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHmY1MN_1656485861)
          by smtp.aliyun-inc.com;
          Wed, 29 Jun 2022 14:57:42 +0800
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
Subject: [PATCH v11 21/40] virtio_ring: packed: introduce virtqueue_resize_packed()
Date:   Wed, 29 Jun 2022 14:56:37 +0800
Message-Id: <20220629065656.54420-22-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 3fdaf102dd89
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

virtio ring packed supports resize.

Only after the new vring is successfully allocated based on the new num,
we will release the old vring. In any case, an error is returned,
indicating that the vring still points to the old vring.

In the case of an error, re-initialize(by virtqueue_reinit_packed()) the
virtqueue to ensure that the vring can be used.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 650f701a5480..4860787286db 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2042,6 +2042,35 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	return NULL;
 }
 
+static int virtqueue_resize_packed(struct virtqueue *_vq, u32 num)
+{
+	struct vring_virtqueue_packed vring = {};
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct virtio_device *vdev = _vq->vdev;
+	int err;
+
+	if (vring_alloc_queue_packed(&vring, vdev, num))
+		goto err_ring;
+
+	err = vring_alloc_state_extra_packed(&vring);
+	if (err)
+		goto err_state_extra;
+
+	vring_free(&vq->vq);
+
+	virtqueue_init(vq, vring.vring.num);
+	virtqueue_vring_attach_packed(vq, &vring);
+	virtqueue_vring_init_packed(vq);
+
+	return 0;
+
+err_state_extra:
+	vring_free_packed(&vring, vdev);
+err_ring:
+	virtqueue_reinit_packed(vq);
+	return -ENOMEM;
+}
+
 
 /*
  * Generic functions and exported symbols.
-- 
2.31.0

