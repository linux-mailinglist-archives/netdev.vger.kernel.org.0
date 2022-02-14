Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7AB4B439D
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241683AbiBNIPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:15:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241686AbiBNIPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:15:04 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722E95FF13;
        Mon, 14 Feb 2022 00:14:54 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4OWZIc_1644826477;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4OWZIc_1644826477)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:38 +0800
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
Subject: [PATCH v5 19/22] virtio: add helper virtio_set_max_ring_num()
Date:   Mon, 14 Feb 2022 16:14:13 +0800
Message-Id: <20220214081416.117695-20-xuanzhuo@linux.alibaba.com>
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

Added helper virtio_set_max_ring_num() to set the upper limit of ring
num when creating a virtqueue.

Can be used to limit ring num before find_vqs() call. Or change ring num
when re-enable reset queue.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c  |  6 ++++++
 include/linux/virtio.h        |  1 +
 include/linux/virtio_config.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1a123b5e5371..a77a82883e44 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -943,6 +943,9 @@ static struct virtqueue *vring_create_virtqueue_split(
 	size_t queue_size_in_bytes;
 	struct vring vring;
 
+	if (vdev->max_ring_num && num > vdev->max_ring_num)
+		num = vdev->max_ring_num;
+
 	/* We assume num is a power of 2. */
 	if (num & (num - 1)) {
 		dev_warn(&vdev->dev, "Bad virtqueue length %u\n", num);
@@ -1692,6 +1695,9 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
 	size_t ring_size_in_bytes, event_size_in_bytes;
 
+	if (vdev->max_ring_num && num > vdev->max_ring_num)
+		num = vdev->max_ring_num;
+
 	ring_size_in_bytes = num * sizeof(struct vring_packed_desc);
 
 	ring = vring_alloc_queue(vdev, ring_size_in_bytes,
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 1153b093c53d..45525beb2ec4 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -127,6 +127,7 @@ struct virtio_device {
 	struct list_head vqs;
 	u64 features;
 	void *priv;
+	u16 max_ring_num;
 };
 
 static inline struct virtio_device *dev_to_virtio(struct device *_dev)
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index cd7f7f44ce38..d7cb2d0341ee 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -200,6 +200,36 @@ static inline bool virtio_has_dma_quirk(const struct virtio_device *vdev)
 	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
 }
 
+/**
+ * virtio_set_max_ring_num - set max ring num
+ * @vdev: the device
+ * @num: max ring num. Zero clear the limit.
+ *
+ * When creating a virtqueue, use this value as the upper limit of ring num.
+ *
+ * Returns 0 on success or error status
+ */
+static inline
+int virtio_set_max_ring_num(struct virtio_device *vdev, u16 num)
+{
+	if (!num) {
+		vdev->max_ring_num = num;
+		return 0;
+	}
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
+		if (!is_power_of_2(num)) {
+			num = __rounddown_pow_of_two(num);
+
+			if (!num)
+				return -EINVAL;
+		}
+	}
+
+	vdev->max_ring_num = num;
+	return 0;
+}
+
 static inline
 struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
 					vq_callback_t *c, const char *n)
-- 
2.31.0

