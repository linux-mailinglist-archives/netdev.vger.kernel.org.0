Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56C36CBAEF
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbjC1J3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjC1J3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:29:16 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935936A62;
        Tue, 28 Mar 2023 02:28:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VesYnTJ_1679995731;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VesYnTJ_1679995731)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:28:52 +0800
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
Subject: [PATCH 03/16] virtio_net: add prefix to the struct inside header file
Date:   Tue, 28 Mar 2023 17:28:34 +0800
Message-Id: <20230328092847.91643-4-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: e880b402863c
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We moved some structures to the header file, but these structures do not
prefixed with virtnet. This patch adds virtnet for these.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 78 ++++++++++++++++++------------------
 drivers/net/virtio/virtnet.h | 12 +++---
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 5ca354e29483..92ef95c163b6 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -174,7 +174,7 @@ static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
  * private is used to chain pages for big packets, put the whole
  * most recent used list in the beginning for reuse
  */
-static void give_pages(struct receive_queue *rq, struct page *page)
+static void give_pages(struct virtnet_rq *rq, struct page *page)
 {
 	struct page *end;
 
@@ -184,7 +184,7 @@ static void give_pages(struct receive_queue *rq, struct page *page)
 	rq->pages = page;
 }
 
-static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
+static struct page *get_a_page(struct virtnet_rq *rq, gfp_t gfp_mask)
 {
 	struct page *p = rq->pages;
 
@@ -268,7 +268,7 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
 
 /* Called from bottom half context */
 static struct sk_buff *page_to_skb(struct virtnet_info *vi,
-				   struct receive_queue *rq,
+				   struct virtnet_rq *rq,
 				   struct page *page, unsigned int offset,
 				   unsigned int len, unsigned int truesize,
 				   unsigned int headroom)
@@ -370,7 +370,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	return skb;
 }
 
-static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
+static void free_old_xmit_skbs(struct virtnet_sq *sq, bool in_napi)
 {
 	unsigned int len;
 	unsigned int packets = 0;
@@ -418,7 +418,7 @@ static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
 
 static void check_sq_full_and_disable(struct virtnet_info *vi,
 				      struct net_device *dev,
-				      struct send_queue *sq)
+				      struct virtnet_sq *sq)
 {
 	bool use_napi = sq->napi.weight;
 	int qnum;
@@ -452,7 +452,7 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
 }
 
 static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
-				   struct send_queue *sq,
+				   struct virtnet_sq *sq,
 				   struct xdp_frame *xdpf)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -541,9 +541,9 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 			    int n, struct xdp_frame **frames, u32 flags)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	struct receive_queue *rq = vi->rq;
+	struct virtnet_rq *rq = vi->rq;
 	struct bpf_prog *xdp_prog;
-	struct send_queue *sq;
+	struct virtnet_sq *sq;
 	unsigned int len;
 	int packets = 0;
 	int bytes = 0;
@@ -631,7 +631,7 @@ static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
  * across multiple buffers (num_buf > 1), and we make sure buffers
  * have enough headroom.
  */
-static struct page *xdp_linearize_page(struct receive_queue *rq,
+static struct page *xdp_linearize_page(struct virtnet_rq *rq,
 				       int *num_buf,
 				       struct page *p,
 				       int offset,
@@ -683,7 +683,7 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 
 static struct sk_buff *receive_small(struct net_device *dev,
 				     struct virtnet_info *vi,
-				     struct receive_queue *rq,
+				     struct virtnet_rq *rq,
 				     void *buf, void *ctx,
 				     unsigned int len,
 				     unsigned int *xdp_xmit,
@@ -827,7 +827,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_info *vi,
-				   struct receive_queue *rq,
+				   struct virtnet_rq *rq,
 				   void *buf,
 				   unsigned int len,
 				   struct virtnet_rq_stats *stats)
@@ -900,7 +900,7 @@ static struct sk_buff *build_skb_from_xdp_buff(struct net_device *dev,
 /* TODO: build xdp in big mode */
 static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 				      struct virtnet_info *vi,
-				      struct receive_queue *rq,
+				      struct virtnet_rq *rq,
 				      struct xdp_buff *xdp,
 				      void *buf,
 				      unsigned int len,
@@ -987,7 +987,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 
 static struct sk_buff *receive_mergeable(struct net_device *dev,
 					 struct virtnet_info *vi,
-					 struct receive_queue *rq,
+					 struct virtnet_rq *rq,
 					 void *buf,
 					 void *ctx,
 					 unsigned int len,
@@ -1278,7 +1278,7 @@ static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
 	skb_set_hash(skb, __le32_to_cpu(hdr_hash->hash_value), rss_hash_type);
 }
 
-static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
+static void receive_buf(struct virtnet_info *vi, struct virtnet_rq *rq,
 			void *buf, unsigned int len, void **ctx,
 			unsigned int *xdp_xmit,
 			struct virtnet_rq_stats *stats)
@@ -1338,7 +1338,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
  * not need to use  mergeable_len_to_ctx here - it is enough
  * to store the headroom as the context ignoring the truesize.
  */
-static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
+static int add_recvbuf_small(struct virtnet_info *vi, struct virtnet_rq *rq,
 			     gfp_t gfp)
 {
 	struct page_frag *alloc_frag = &rq->alloc_frag;
@@ -1364,7 +1364,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
 	return err;
 }
 
-static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
+static int add_recvbuf_big(struct virtnet_info *vi, struct virtnet_rq *rq,
 			   gfp_t gfp)
 {
 	struct page *first, *list = NULL;
@@ -1413,7 +1413,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
 	return err;
 }
 
-static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
+static unsigned int get_mergeable_buf_len(struct virtnet_rq *rq,
 					  struct ewma_pkt_len *avg_pkt_len,
 					  unsigned int room)
 {
@@ -1431,7 +1431,7 @@ static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
 }
 
 static int add_recvbuf_mergeable(struct virtnet_info *vi,
-				 struct receive_queue *rq, gfp_t gfp)
+				 struct virtnet_rq *rq, gfp_t gfp)
 {
 	struct page_frag *alloc_frag = &rq->alloc_frag;
 	unsigned int headroom = virtnet_get_headroom(vi);
@@ -1483,7 +1483,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
  * before we're receiving packets, or from refill_work which is
  * careful to disable receiving (using napi_disable).
  */
-static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
+static bool try_fill_recv(struct virtnet_info *vi, struct virtnet_rq *rq,
 			  gfp_t gfp)
 {
 	int err;
@@ -1515,7 +1515,7 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
 static void skb_recv_done(struct virtqueue *rvq)
 {
 	struct virtnet_info *vi = rvq->vdev->priv;
-	struct receive_queue *rq = &vi->rq[vq2rxq(rvq)];
+	struct virtnet_rq *rq = &vi->rq[vq2rxq(rvq)];
 
 	virtqueue_napi_schedule(&rq->napi, rvq);
 }
@@ -1565,7 +1565,7 @@ static void refill_work(struct work_struct *work)
 	int i;
 
 	for (i = 0; i < vi->curr_queue_pairs; i++) {
-		struct receive_queue *rq = &vi->rq[i];
+		struct virtnet_rq *rq = &vi->rq[i];
 
 		napi_disable(&rq->napi);
 		still_empty = !try_fill_recv(vi, rq, GFP_KERNEL);
@@ -1579,7 +1579,7 @@ static void refill_work(struct work_struct *work)
 	}
 }
 
-static int virtnet_receive(struct receive_queue *rq, int budget,
+static int virtnet_receive(struct virtnet_rq *rq, int budget,
 			   unsigned int *xdp_xmit)
 {
 	struct virtnet_info *vi = rq->vq->vdev->priv;
@@ -1626,11 +1626,11 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	return stats.packets;
 }
 
-static void virtnet_poll_cleantx(struct receive_queue *rq)
+static void virtnet_poll_cleantx(struct virtnet_rq *rq)
 {
 	struct virtnet_info *vi = rq->vq->vdev->priv;
 	unsigned int index = vq2rxq(rq->vq);
-	struct send_queue *sq = &vi->sq[index];
+	struct virtnet_sq *sq = &vi->sq[index];
 	struct netdev_queue *txq = netdev_get_tx_queue(vi->dev, index);
 
 	if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
@@ -1656,10 +1656,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 
 static int virtnet_poll(struct napi_struct *napi, int budget)
 {
-	struct receive_queue *rq =
-		container_of(napi, struct receive_queue, napi);
+	struct virtnet_rq *rq =
+		container_of(napi, struct virtnet_rq, napi);
 	struct virtnet_info *vi = rq->vq->vdev->priv;
-	struct send_queue *sq;
+	struct virtnet_sq *sq;
 	unsigned int received;
 	unsigned int xdp_xmit = 0;
 
@@ -1720,7 +1720,7 @@ static int virtnet_open(struct net_device *dev)
 
 static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 {
-	struct send_queue *sq = container_of(napi, struct send_queue, napi);
+	struct virtnet_sq *sq = container_of(napi, struct virtnet_sq, napi);
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	unsigned int index = vq2txq(sq->vq);
 	struct netdev_queue *txq;
@@ -1764,7 +1764,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	return 0;
 }
 
-static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
+static int xmit_skb(struct virtnet_sq *sq, struct sk_buff *skb)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
@@ -1815,7 +1815,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	int qnum = skb_get_queue_mapping(skb);
-	struct send_queue *sq = &vi->sq[qnum];
+	struct virtnet_sq *sq = &vi->sq[qnum];
 	int err;
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
 	bool kick = !netdev_xmit_more();
@@ -1869,7 +1869,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 }
 
 static int virtnet_rx_resize(struct virtnet_info *vi,
-			     struct receive_queue *rq, u32 ring_num)
+			     struct virtnet_rq *rq, u32 ring_num)
 {
 	bool running = netif_running(vi->dev);
 	int err, qindex;
@@ -1892,7 +1892,7 @@ static int virtnet_rx_resize(struct virtnet_info *vi,
 }
 
 static int virtnet_tx_resize(struct virtnet_info *vi,
-			     struct send_queue *sq, u32 ring_num)
+			     struct virtnet_sq *sq, u32 ring_num)
 {
 	bool running = netif_running(vi->dev);
 	struct netdev_queue *txq;
@@ -2038,8 +2038,8 @@ static void virtnet_stats(struct net_device *dev,
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		u64 tpackets, tbytes, terrors, rpackets, rbytes, rdrops;
-		struct receive_queue *rq = &vi->rq[i];
-		struct send_queue *sq = &vi->sq[i];
+		struct virtnet_rq *rq = &vi->rq[i];
+		struct virtnet_sq *sq = &vi->sq[i];
 
 		do {
 			start = u64_stats_fetch_begin(&sq->stats.syncp);
@@ -2355,8 +2355,8 @@ static int virtnet_set_ringparam(struct net_device *dev,
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	u32 rx_pending, tx_pending;
-	struct receive_queue *rq;
-	struct send_queue *sq;
+	struct virtnet_rq *rq;
+	struct virtnet_sq *sq;
 	int i, err;
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
@@ -2660,7 +2660,7 @@ static void virtnet_get_ethtool_stats(struct net_device *dev,
 	size_t offset;
 
 	for (i = 0; i < vi->curr_queue_pairs; i++) {
-		struct receive_queue *rq = &vi->rq[i];
+		struct virtnet_rq *rq = &vi->rq[i];
 
 		stats_base = (u8 *)&rq->stats;
 		do {
@@ -2674,7 +2674,7 @@ static void virtnet_get_ethtool_stats(struct net_device *dev,
 	}
 
 	for (i = 0; i < vi->curr_queue_pairs; i++) {
-		struct send_queue *sq = &vi->sq[i];
+		struct virtnet_sq *sq = &vi->sq[i];
 
 		stats_base = (u8 *)&sq->stats;
 		do {
@@ -3229,7 +3229,7 @@ static int virtnet_set_features(struct net_device *dev,
 static void virtnet_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct virtnet_info *priv = netdev_priv(dev);
-	struct send_queue *sq = &priv->sq[txqueue];
+	struct virtnet_sq *sq = &priv->sq[txqueue];
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, txqueue);
 
 	u64_stats_update_begin(&sq->stats.syncp);
diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
index 778a0e6af869..669e0499f340 100644
--- a/drivers/net/virtio/virtnet.h
+++ b/drivers/net/virtio/virtnet.h
@@ -48,8 +48,8 @@ struct virtnet_rq_stats {
 	u64 kicks;
 };
 
-struct send_queue {
-	/* Virtqueue associated with this send _queue */
+struct virtnet_sq {
+	/* Virtqueue associated with this virtnet_sq */
 	struct virtqueue *vq;
 
 	/* TX: fragments + linear part + virtio header */
@@ -66,8 +66,8 @@ struct send_queue {
 	bool reset;
 };
 
-struct receive_queue {
-	/* Virtqueue associated with this receive_queue */
+struct virtnet_rq {
+	/* Virtqueue associated with this virtnet_rq */
 	struct virtqueue *vq;
 
 	struct napi_struct napi;
@@ -101,8 +101,8 @@ struct virtnet_info {
 	struct virtio_device *vdev;
 	struct virtqueue *cvq;
 	struct net_device *dev;
-	struct send_queue *sq;
-	struct receive_queue *rq;
+	struct virtnet_sq *sq;
+	struct virtnet_rq *rq;
 	unsigned int status;
 
 	/* Max # of queue pairs supported by the device */
-- 
2.32.0.3.g01195cf9f

