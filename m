Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516E26CBB05
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjC1Ja7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbjC1JaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:30:19 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9417681;
        Tue, 28 Mar 2023 02:29:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VesZtZh_1679995742;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VesZtZh_1679995742)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:29:02 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 13/16] virtio_net: prepare for virtio
Date:   Tue, 28 Mar 2023 17:28:44 +0800
Message-Id: <20230328092847.91643-14-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: e880b402863c
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put some functions or macro into the header file.

This is prepare for separating the virtio-related funcs.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 43 +++++++++++++++++++-----------------
 drivers/net/virtio/virtnet.h |  7 ++++++
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 5f508d9500f3..8f281a7f9d7a 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -33,8 +33,6 @@ module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
 
-/* FIXME: MTU in config. */
-#define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
 #define GOOD_COPY_LEN	128
 
 static const unsigned long guest_offloads[] = {
@@ -175,7 +173,7 @@ static void virtqueue_napi_complete(struct napi_struct *napi,
 	}
 }
 
-static void skb_xmit_done(struct virtqueue *vq)
+void virtnet_skb_xmit_done(struct virtqueue *vq)
 {
 	struct virtnet_info *vi = vq->vdev->priv;
 	struct napi_struct *napi = &vi->sq[vq2txq(vq)].napi;
@@ -635,7 +633,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	unsigned int xdp_headroom = (unsigned long)ctx;
 	unsigned int header_offset = VIRTNET_RX_PAD + xdp_headroom;
 	unsigned int headroom = vi->hdr_len + header_offset;
-	unsigned int buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
+	unsigned int buflen = SKB_DATA_ALIGN(VIRTNET_GOOD_PACKET_LEN + headroom) +
 			      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	struct page *page = virt_to_head_page(buf);
 	unsigned int delta = 0;
@@ -646,9 +644,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	len -= vi->hdr_len;
 	stats->bytes += len;
 
-	if (unlikely(len > GOOD_PACKET_LEN)) {
+	if (unlikely(len > VIRTNET_GOOD_PACKET_LEN)) {
 		pr_debug("%s: rx error: len %u exceeds max size %d\n",
-			 dev->name, len, GOOD_PACKET_LEN);
+			 dev->name, len, VIRTNET_GOOD_PACKET_LEN);
 		dev->stats.rx_length_errors++;
 		goto err;
 	}
@@ -678,7 +676,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			xdp_headroom = virtnet_get_headroom(vi);
 			header_offset = VIRTNET_RX_PAD + xdp_headroom;
 			headroom = vi->hdr_len + header_offset;
-			buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
+			buflen = SKB_DATA_ALIGN(VIRTNET_GOOD_PACKET_LEN + headroom) +
 				 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 			xdp_page = xdp_linearize_page(rq, &num_buf, page,
 						      offset, header_offset,
@@ -1286,7 +1284,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct virtnet_rq *rq,
 	char *buf;
 	unsigned int xdp_headroom = virtnet_get_headroom(vi);
 	void *ctx = (void *)(unsigned long)xdp_headroom;
-	int len = vi->hdr_len + VIRTNET_RX_PAD + GOOD_PACKET_LEN + xdp_headroom;
+	int len = vi->hdr_len + VIRTNET_RX_PAD + VIRTNET_GOOD_PACKET_LEN + xdp_headroom;
 	int err;
 
 	len = SKB_DATA_ALIGN(len) +
@@ -1298,7 +1296,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct virtnet_rq *rq,
 	get_page(alloc_frag->page);
 	alloc_frag->offset += len;
 	sg_init_one(rq->sg, buf + VIRTNET_RX_PAD + xdp_headroom,
-		    vi->hdr_len + GOOD_PACKET_LEN);
+		    vi->hdr_len + VIRTNET_GOOD_PACKET_LEN);
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0)
 		put_page(virt_to_head_page(buf));
@@ -1421,7 +1419,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
  * Returns false if we couldn't fill entirely (OOM).
  *
  * Normally run in the receive path, but can also be run from ndo_open
- * before we're receiving packets, or from refill_work which is
+ * before we're receiving packets, or from virtnet_refill_work which is
  * careful to disable receiving (using napi_disable).
  */
 static bool try_fill_recv(struct virtnet_info *vi, struct virtnet_rq *rq,
@@ -1453,7 +1451,7 @@ static bool try_fill_recv(struct virtnet_info *vi, struct virtnet_rq *rq,
 	return !oom;
 }
 
-static void skb_recv_done(struct virtqueue *rvq)
+void virtnet_skb_recv_done(struct virtqueue *rvq)
 {
 	struct virtnet_info *vi = rvq->vdev->priv;
 	struct virtnet_rq *rq = &vi->rq[vq2rxq(rvq)];
@@ -1498,7 +1496,7 @@ static void virtnet_napi_tx_disable(struct napi_struct *napi)
 		napi_disable(napi);
 }
 
-static void refill_work(struct work_struct *work)
+void virtnet_refill_work(struct work_struct *work)
 {
 	struct virtnet_info *vi =
 		container_of(work, struct virtnet_info, refill.work);
@@ -1982,7 +1980,7 @@ static int virtnet_close(struct net_device *dev)
 
 	/* Make sure NAPI doesn't schedule refill work */
 	disable_delayed_refill(vi);
-	/* Make sure refill_work doesn't re-enable napi! */
+	/* Make sure virtnet_refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -2480,7 +2478,7 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
 	unsigned int min_buf_len = DIV_ROUND_UP(buf_len, rq_size);
 
 	return max(max(min_buf_len, hdr_len) - hdr_len,
-		   (unsigned int)GOOD_PACKET_LEN);
+		   (unsigned int)VIRTNET_GOOD_PACKET_LEN);
 }
 
 static int virtnet_find_vqs(struct virtnet_info *vi)
@@ -2525,8 +2523,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 
 	/* Allocate/initialize parameters for send/receive virtqueues */
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		callbacks[rxq2vq(i)] = skb_recv_done;
-		callbacks[txq2vq(i)] = skb_xmit_done;
+		callbacks[rxq2vq(i)] = virtnet_skb_recv_done;
+		callbacks[txq2vq(i)] = virtnet_skb_xmit_done;
 		sprintf(vi->rq[i].name, "input.%d", i);
 		sprintf(vi->sq[i].name, "output.%d", i);
 		names[rxq2vq(i)] = vi->rq[i].name;
@@ -2585,7 +2583,7 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 	if (!vi->rq)
 		goto err_rq;
 
-	INIT_DELAYED_WORK(&vi->refill, refill_work);
+	INIT_DELAYED_WORK(&vi->refill, virtnet_refill_work);
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		vi->rq[i].pages = NULL;
 		netif_napi_add_weight(vi->dev, &vi->rq[i].napi, virtnet_poll,
@@ -3045,14 +3043,19 @@ static int virtnet_probe(struct virtio_device *vdev)
 	return err;
 }
 
-static void remove_vq_common(struct virtnet_info *vi)
+void virtnet_free_bufs(struct virtnet_info *vi)
 {
-	virtio_reset_device(vi->vdev);
-
 	/* Free unused buffers in both send and recv, if any. */
 	free_unused_bufs(vi);
 
 	free_receive_bufs(vi);
+}
+
+static void remove_vq_common(struct virtnet_info *vi)
+{
+	virtio_reset_device(vi->vdev);
+
+	virtnet_free_bufs(vi);
 
 	free_receive_page_frags(vi);
 
diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
index 269ddc386418..1315dcf52f1b 100644
--- a/drivers/net/virtio/virtnet.h
+++ b/drivers/net/virtio/virtnet.h
@@ -26,6 +26,9 @@ DECLARE_EWMA(pkt_len, 0, 64)
 
 #define VIRTNET_DRIVER_VERSION "1.0.0"
 
+/* FIXME: MTU in config. */
+#define VIRTNET_GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
+
 struct virtnet_sq_stats {
 	struct u64_stats_sync syncp;
 	u64 packets;
@@ -186,4 +189,8 @@ int virtnet_tx_resize(struct virtnet_info *vi, struct virtnet_sq *sq, u32 ring_n
 int _virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs);
 void virtnet_dev_rx_queue_group(struct virtnet_info *vi, struct net_device *dev);
 const struct net_device_ops *virtnet_get_netdev(void);
+void virtnet_skb_xmit_done(struct virtqueue *vq);
+void virtnet_skb_recv_done(struct virtqueue *rvq);
+void virtnet_refill_work(struct work_struct *work);
+void virtnet_free_bufs(struct virtnet_info *vi);
 #endif
-- 
2.32.0.3.g01195cf9f

