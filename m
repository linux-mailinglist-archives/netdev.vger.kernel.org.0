Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612FF4B4383
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbiBNIOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:14:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241636AbiBNIOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:14:41 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0D05F8F3;
        Mon, 14 Feb 2022 00:14:33 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4O5x7x_1644826459;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4O5x7x_1644826459)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:20 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v5 03/22] virtio_ring: queue_reset: add function vring_setup_virtqueue()
Date:   Mon, 14 Feb 2022 16:13:57 +0800
Message-Id: <20220214081416.117695-4-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 24fd8391539b
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

Added function vring_setup_virtqueue() to allow passing existing vq
without reallocating vq.

The purpose of adding this function is to not break the form of
vring_create_virtqueue().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c |  7 ++++---
 include/linux/virtio_ring.h  | 37 ++++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 962f1477b1fa..4f95d650b066 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2255,7 +2255,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 }
 EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
 
-struct virtqueue *vring_create_virtqueue(
+struct virtqueue *vring_setup_virtqueue(
 	unsigned int index,
 	unsigned int num,
 	unsigned int vring_align,
@@ -2265,7 +2265,8 @@ struct virtqueue *vring_create_virtqueue(
 	bool context,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
-	const char *name)
+	const char *name,
+	struct virtqueue *vq)
 {
 
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
@@ -2277,7 +2278,7 @@ struct virtqueue *vring_create_virtqueue(
 			vdev, weak_barriers, may_reduce_num,
 			context, notify, callback, name);
 }
-EXPORT_SYMBOL_GPL(vring_create_virtqueue);
+EXPORT_SYMBOL_GPL(vring_setup_virtqueue);
 
 /* Only available for split ring */
 struct virtqueue *vring_new_virtqueue(unsigned int index,
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index b485b13fa50b..e90323fce4bf 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -65,16 +65,33 @@ struct virtqueue;
  * expected.  The caller should query virtqueue_get_vring_size to learn
  * the actual size of the ring.
  */
-struct virtqueue *vring_create_virtqueue(unsigned int index,
-					 unsigned int num,
-					 unsigned int vring_align,
-					 struct virtio_device *vdev,
-					 bool weak_barriers,
-					 bool may_reduce_num,
-					 bool ctx,
-					 bool (*notify)(struct virtqueue *vq),
-					 void (*callback)(struct virtqueue *vq),
-					 const char *name);
+struct virtqueue *vring_setup_virtqueue(unsigned int index,
+					unsigned int num,
+					unsigned int vring_align,
+					struct virtio_device *vdev,
+					bool weak_barriers,
+					bool may_reduce_num,
+					bool ctx,
+					bool (*notify)(struct virtqueue *vq),
+					void (*callback)(struct virtqueue *vq),
+					const char *name,
+					struct virtqueue *vq);
+
+static inline struct virtqueue *vring_create_virtqueue(unsigned int index,
+						       unsigned int num,
+						       unsigned int vring_align,
+						       struct virtio_device *vdev,
+						       bool weak_barriers,
+						       bool may_reduce_num,
+						       bool ctx,
+						       bool (*notify)(struct virtqueue *vq),
+						       void (*callback)(struct virtqueue *vq),
+						       const char *name)
+{
+	return vring_setup_virtqueue(index, num, vring_align, vdev,
+				     weak_barriers, may_reduce_num, ctx,
+				     notify, callback, name, NULL);
+}
 
 /* Creates a virtqueue with a custom layout. */
 struct virtqueue *__vring_new_virtqueue(unsigned int index,
-- 
2.31.0

