Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796AC4C2540
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiBXIMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiBXIMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:12:12 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F7B24CCF3;
        Thu, 24 Feb 2022 00:11:34 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V5NDoAn_1645690285;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V5NDoAn_1645690285)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 16:11:26 +0800
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
Subject: [PATCH v6 11/26] virtio_ring: introduce virtqueue_reset_vring()
Date:   Thu, 24 Feb 2022 16:10:47 +0800
Message-Id: <20220224081102.80224-12-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220224081102.80224-1-xuanzhuo@linux.alibaba.com>
References: <20220224081102.80224-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: bd1c915e263f
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

Introduce virtqueue_reset_vring() to implement the reset of vring during
the reset process.

If num is equal to 0 or equal to the original ring num, the original vring
will be used directly. The vring will not be reallocated. Otherwise, the
original vring will be released, and the vring will be re-allocated
based on num.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 30 ++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 3ee2d0e17515..ab03aa732f75 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2534,6 +2534,36 @@ struct virtqueue *vring_create_virtqueue(
 }
 EXPORT_SYMBOL_GPL(vring_create_virtqueue);
 
+/**
+ * virtqueue_reset_vring - reset the vring of vq
+ * @vq: the struct virtqueue we're talking about.
+ * @num: new ring num
+ *
+ * If num is equal to 0 or equal to the original ring num, the original vring
+ * will be used directly. The vring will not be reallocated. Otherwise, the
+ * original vring will be released, and the vring will be re-allocated based on
+ * num.
+ *
+ * This function must be called after virtio_reset_vq(). For more information on
+ * vq reset see the description of virtio_reset_vq().
+ *
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ *
+ * Returns zero or a negative error.
+ */
+int virtqueue_reset_vring(struct virtqueue *vq, u32 num)
+{
+	struct virtio_device *vdev = vq->vdev;
+
+	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
+		return virtqueue_reset_vring_packed(vq, num);
+
+	return virtqueue_reset_vring_split(vq, num);
+}
+EXPORT_SYMBOL_GPL(virtqueue_reset_vring);
+
 /* Only available for split ring */
 struct virtqueue *vring_new_virtqueue(unsigned int index,
 				      unsigned int num,
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index e3714e6db330..7bf29f9e7491 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -99,6 +99,8 @@ dma_addr_t virtqueue_get_desc_addr(struct virtqueue *vq);
 dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);
 dma_addr_t virtqueue_get_used_addr(struct virtqueue *vq);
 
+int virtqueue_reset_vring(struct virtqueue *vq, u32 num);
+
 /**
  * virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
-- 
2.31.0

