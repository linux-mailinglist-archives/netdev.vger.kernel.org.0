Return-Path: <netdev+bounces-7358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB2F71FDCF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37900281791
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DBA19523;
	Fri,  2 Jun 2023 09:22:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA8619521;
	Fri,  2 Jun 2023 09:22:24 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E81E7E;
	Fri,  2 Jun 2023 02:22:21 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vk9Mo2n_1685697738;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vk9Mo2n_1685697738)
          by smtp.aliyun-inc.com;
          Fri, 02 Jun 2023 17:22:19 +0800
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
Subject: [PATCH vhost v10 10/10] virtio_net: support dma premapped
Date: Fri,  2 Jun 2023 17:22:06 +0800
Message-Id: <20230602092206.50108-11-xuanzhuo@linux.alibaba.com>
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

Introduce the module param "experiment_premapped" to enable the function
that the virtio-net do dma mapping.

If that is true, the vq of virtio-net is under the premapped mode.
It just handle the sg with dma_address. And the driver must get the dma
address of the buffer to unmap after get the buffer from virtio core.

That will be useful when AF_XDP is enable, AF_XDP tx and the kernel packet
xmit will share the tx queue, so the skb xmit must support the premapped
mode.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 163 +++++++++++++++++++++++++++++++++------
 1 file changed, 141 insertions(+), 22 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2396c28c0122..5898212fcb3c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -26,10 +26,11 @@
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
 
-static bool csum = true, gso = true, napi_tx = true;
+static bool csum = true, gso = true, napi_tx = true, experiment_premapped;
 module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
+module_param(experiment_premapped, bool, 0644);
 
 /* FIXME: MTU in config. */
 #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
@@ -142,6 +143,9 @@ struct send_queue {
 
 	/* Record whether sq is in reset state. */
 	bool reset;
+
+	/* The vq is premapped mode. */
+	bool premapped;
 };
 
 /* Internal representation of a receive virtqueue */
@@ -174,6 +178,9 @@ struct receive_queue {
 	char name[16];
 
 	struct xdp_rxq_info xdp_rxq;
+
+	/* The vq is premapped mode. */
+	bool premapped;
 };
 
 /* This structure can contain rss message with maximum settings for indirection table and keysize
@@ -546,6 +553,105 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	return skb;
 }
 
+static int virtnet_generic_unmap(struct virtqueue *vq, struct virtqueue_detach_cursor *cursor)
+{
+	enum dma_data_direction dir;
+	dma_addr_t addr;
+	u32 len;
+	int err;
+
+	do {
+		err = virtqueue_detach(vq, cursor, &addr, &len, &dir);
+		if (!err || err == -EAGAIN)
+			dma_unmap_page_attrs(virtqueue_dma_dev(vq), addr, len, dir, 0);
+
+	} while (err == -EAGAIN);
+
+	return err;
+}
+
+static void *virtnet_detach_unused_buf(struct virtqueue *vq, bool premapped)
+{
+	struct virtqueue_detach_cursor cursor;
+	void *buf;
+
+	if (!premapped)
+		return virtqueue_detach_unused_buf(vq);
+
+	buf = virtqueue_detach_unused_buf_premapped(vq, &cursor);
+	if (buf)
+		virtnet_generic_unmap(vq, &cursor);
+
+	return buf;
+}
+
+static void *virtnet_get_buf_ctx(struct virtqueue *vq, bool premapped, u32 *len, void **ctx)
+{
+	struct virtqueue_detach_cursor cursor;
+	void *buf;
+
+	if (!premapped)
+		return virtqueue_get_buf_ctx(vq, len, ctx);
+
+	buf = virtqueue_get_buf_premapped(vq, len, ctx, &cursor);
+	if (buf)
+		virtnet_generic_unmap(vq, &cursor);
+
+	return buf;
+}
+
+#define virtnet_rq_get_buf(rq, plen, pctx) \
+({ \
+	typeof(rq) _rq = (rq); \
+	virtnet_get_buf_ctx(_rq->vq, _rq->premapped, plen, pctx); \
+})
+
+#define virtnet_sq_get_buf(sq, plen, pctx) \
+({ \
+	typeof(sq) _sq = (sq); \
+	virtnet_get_buf_ctx(_sq->vq, _sq->premapped, plen, pctx); \
+})
+
+static int virtnet_add_sg(struct virtqueue *vq, bool premapped,
+			  struct scatterlist *sg, unsigned int num, bool out,
+			  void *data, void *ctx, gfp_t gfp)
+{
+	enum dma_data_direction dir;
+	struct device *dev;
+	int err, ret;
+
+	if (!premapped)
+		return virtqueue_add_sg(vq, sg, num, out, data, ctx, gfp);
+
+	dir = out ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	dev = virtqueue_dma_dev(vq);
+
+	ret = dma_map_sg_attrs(dev, sg, num, dir, 0);
+	if (ret != num)
+		goto err;
+
+	err = virtqueue_add_sg(vq, sg, num, out, data, ctx, gfp);
+	if (err < 0)
+		goto err;
+
+	return 0;
+
+err:
+	dma_unmap_sg_attrs(dev, sg, num, dir, 0);
+	return -ENOMEM;
+}
+
+static int virtnet_add_outbuf(struct send_queue *sq, unsigned int num, void *data)
+{
+	return virtnet_add_sg(sq->vq, sq->premapped, sq->sg, num, true, data, NULL, GFP_ATOMIC);
+}
+
+static int virtnet_add_inbuf(struct receive_queue *rq, unsigned int num, void *data,
+			     void *ctx, gfp_t gfp)
+{
+	return virtnet_add_sg(rq->vq, rq->premapped, rq->sg, num, false, data, ctx, gfp);
+}
+
 static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 {
 	unsigned int len;
@@ -553,7 +659,7 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 	unsigned int bytes = 0;
 	void *ptr;
 
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
+	while ((ptr = virtnet_sq_get_buf(sq, &len, NULL)) != NULL) {
 		if (likely(!is_xdp_frame(ptr))) {
 			struct sk_buff *skb = ptr;
 
@@ -667,8 +773,7 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 			    skb_frag_size(frag), skb_frag_off(frag));
 	}
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
-				   xdp_to_ptr(xdpf), GFP_ATOMIC);
+	err = virtnet_add_outbuf(sq, nr_frags + 1, xdp_to_ptr(xdpf));
 	if (unlikely(err))
 		return -ENOSPC; /* Caller handle free/refcnt */
 
@@ -744,7 +849,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	}
 
 	/* Free up any pending old buffers before queueing new ones. */
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
+	while ((ptr = virtnet_sq_get_buf(sq, &len, NULL)) != NULL) {
 		if (likely(is_xdp_frame(ptr))) {
 			struct xdp_frame *frame = ptr_to_xdp(ptr);
 
@@ -828,7 +933,7 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 		void *buf;
 		int off;
 
-		buf = virtqueue_get_buf(rq->vq, &buflen);
+		buf = virtnet_rq_get_buf(rq, &buflen, NULL);
 		if (unlikely(!buf))
 			goto err_buf;
 
@@ -1119,7 +1224,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 		return -EINVAL;
 
 	while (--*num_buf > 0) {
-		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
+		buf = virtnet_rq_get_buf(rq, &len, &ctx);
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers out of %d missing\n",
 				 dev->name, *num_buf,
@@ -1344,7 +1449,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	while (--num_buf) {
 		int num_skb_frags;
 
-		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
+		buf = virtnet_rq_get_buf(rq, &len, &ctx);
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers out of %d missing\n",
 				 dev->name, num_buf,
@@ -1407,7 +1512,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 err_skb:
 	put_page(page);
 	while (num_buf-- > 1) {
-		buf = virtqueue_get_buf(rq->vq, &len);
+		buf = virtnet_rq_get_buf(rq, &len, NULL);
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers missing\n",
 				 dev->name, num_buf);
@@ -1534,7 +1639,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
 	alloc_frag->offset += len;
 	sg_init_one(rq->sg, buf + VIRTNET_RX_PAD + xdp_headroom,
 		    vi->hdr_len + GOOD_PACKET_LEN);
-	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
+	err = virtnet_add_inbuf(rq, 1, buf, ctx, gfp);
 	if (err < 0)
 		put_page(virt_to_head_page(buf));
 	return err;
@@ -1581,8 +1686,8 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
 
 	/* chain first in list head */
 	first->private = (unsigned long)list;
-	err = virtqueue_add_inbuf(rq->vq, rq->sg, vi->big_packets_num_skbfrags + 2,
-				  first, gfp);
+	err = virtnet_add_inbuf(rq, vi->big_packets_num_skbfrags + 2,
+				first, NULL, gfp);
 	if (err < 0)
 		give_pages(rq, first);
 
@@ -1645,7 +1750,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 
 	sg_init_one(rq->sg, buf, len);
 	ctx = mergeable_len_to_ctx(len + room, headroom);
-	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
+	err = virtnet_add_inbuf(rq, 1, buf, ctx, gfp);
 	if (err < 0)
 		put_page(virt_to_head_page(buf));
 
@@ -1768,13 +1873,13 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 		void *ctx;
 
 		while (stats.packets < budget &&
-		       (buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx))) {
+		       (buf = virtnet_rq_get_buf(rq, &len, &ctx))) {
 			receive_buf(vi, rq, buf, len, ctx, xdp_xmit, &stats);
 			stats.packets++;
 		}
 	} else {
 		while (stats.packets < budget &&
-		       (buf = virtqueue_get_buf(rq->vq, &len)) != NULL) {
+		       (buf = virtnet_rq_get_buf(rq, &len, NULL)) != NULL) {
 			receive_buf(vi, rq, buf, len, NULL, xdp_xmit, &stats);
 			stats.packets++;
 		}
@@ -1984,7 +2089,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 			return num_sg;
 		num_sg++;
 	}
-	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
+	return virtnet_add_outbuf(sq, num_sg, skb);
 }
 
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -3552,15 +3657,17 @@ static void free_unused_bufs(struct virtnet_info *vi)
 	int i;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct virtqueue *vq = vi->sq[i].vq;
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
-			virtnet_sq_free_unused_buf(vq, buf);
+		struct send_queue *sq = &vi->sq[i];
+
+		while ((buf = virtnet_detach_unused_buf(sq->vq, sq->premapped)) != NULL)
+			virtnet_sq_free_unused_buf(sq->vq, buf);
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct virtqueue *vq = vi->rq[i].vq;
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
-			virtnet_rq_free_unused_buf(vq, buf);
+		struct receive_queue *rq = &vi->rq[i];
+
+		while ((buf = virtnet_detach_unused_buf(rq->vq, rq->premapped)) != NULL)
+			virtnet_rq_free_unused_buf(rq->vq, buf);
 	}
 }
 
@@ -3658,6 +3765,18 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		vi->rq[i].vq = vqs[rxq2vq(i)];
 		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
 		vi->sq[i].vq = vqs[txq2vq(i)];
+
+		if (experiment_premapped) {
+			if (!virtqueue_set_premapped(vi->rq[i].vq))
+				vi->rq[i].premapped = true;
+			else
+				netdev_warn(vi->dev, "RXQ (%d) enable premapped failure.\n", i);
+
+			if (!virtqueue_set_premapped(vi->sq[i].vq))
+				vi->sq[i].premapped = true;
+			else
+				netdev_warn(vi->dev, "TXQ (%d) enable premapped failure.\n", i);
+		}
 	}
 
 	/* run here: ret == 0. */
-- 
2.32.0.3.g01195cf9f


