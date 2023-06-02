Return-Path: <netdev+bounces-7350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C683971FDAC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46E5F1C20CA7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DAB517AD3;
	Fri,  2 Jun 2023 09:22:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E88D17AD2;
	Fri,  2 Jun 2023 09:22:17 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA56E6D;
	Fri,  2 Jun 2023 02:22:13 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vk9OIfj_1685697728;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vk9OIfj_1685697728)
          by smtp.aliyun-inc.com;
          Fri, 02 Jun 2023 17:22:09 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux-foundation.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH vhost v10 02/10] virtio_ring: introduce virtqueue_set_premapped()
Date: Fri,  2 Jun 2023 17:21:58 +0800
Message-Id: <20230602092206.50108-3-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 3bf1b1dbeb8a
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This helper allows the driver change the dma mode to premapped mode.
Under the premapped mode, the virtio core do not do dma mapping
internally.

This just work when the use_dma_api is true. If the use_dma_api is false,
the dma options is not through the DMA APIs, that is not the standard
way of the linux kernel.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 40 ++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  2 ++
 2 files changed, 42 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 72ed07a604d4..2afdfb9e3e30 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -172,6 +172,9 @@ struct vring_virtqueue {
 	/* Host publishes avail event idx */
 	bool event;
 
+	/* Do DMA mapping by driver */
+	bool premapped;
+
 	/* Head of free buffer list. */
 	unsigned int free_head;
 	/* Number we've added since last sync. */
@@ -2059,6 +2062,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->packed_ring = true;
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
+	vq->premapped = false;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2548,6 +2552,7 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 #endif
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
+	vq->premapped = false;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2691,6 +2696,41 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 }
 EXPORT_SYMBOL_GPL(virtqueue_resize);
 
+/**
+ * virtqueue_set_premapped - set the vring premapped mode
+ * @_vq: the struct virtqueue we're talking about.
+ *
+ * Enable the premapped mode of the vq.
+ *
+ * The vring in premapped mode does not do dma internally, so the driver must
+ * do dma mapping in advance. The driver must pass the dma_address through
+ * dma_address of scatterlist. When the driver got a used buffer from
+ * the vring, it has to unmap the dma address. So the driver must call
+ * virtqueue_get_buf_premapped()/virtqueue_detach_unused_buf_premapped().
+ *
+ * This must be called before adding any buf to vring.
+ * So this should be called immediately after init vq or vq reset.
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ *
+ * Returns zero or a negative error.
+ * 0: success.
+ * -EINVAL: vring does not use the dma api, so we can not enable premapped mode.
+ */
+int virtqueue_set_premapped(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->use_dma_api)
+		return -EINVAL;
+
+	vq->premapped = true;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtqueue_set_premapped);
+
 /* Only available for split ring */
 struct virtqueue *vring_new_virtqueue(unsigned int index,
 				      unsigned int num,
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b93238db94e3..1fc0e1023bd4 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -78,6 +78,8 @@ bool virtqueue_enable_cb(struct virtqueue *vq);
 
 unsigned virtqueue_enable_cb_prepare(struct virtqueue *vq);
 
+int virtqueue_set_premapped(struct virtqueue *_vq);
+
 bool virtqueue_poll(struct virtqueue *vq, unsigned);
 
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
-- 
2.32.0.3.g01195cf9f


