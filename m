Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EE96CBE75
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjC1MEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjC1ME3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:04:29 -0400
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B93983D5;
        Tue, 28 Mar 2023 05:04:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vet0640_1680005060;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vet0640_1680005060)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 20:04:20 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 7/8] virtio_net: introduce receive_mergeable_xdp()
Date:   Tue, 28 Mar 2023 20:04:11 +0800
Message-Id: <20230328120412.110114-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 822c071fd47f
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

The purpose of this patch is to simplify the receive_mergeable().
Separate all the logic of XDP into a function.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 128 +++++++++++++++++++++++----------------
 1 file changed, 76 insertions(+), 52 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 136131a7868a..c8978d8d8adb 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1316,6 +1316,63 @@ static void *mergeable_xdp_prepare(struct virtnet_info *vi,
 	return page_address(xdp_page) + VIRTIO_XDP_HEADROOM;
 }
 
+static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
+					     struct virtnet_info *vi,
+					     struct receive_queue *rq,
+					     struct bpf_prog *xdp_prog,
+					     void *buf,
+					     void *ctx,
+					     unsigned int len,
+					     unsigned int *xdp_xmit,
+					     struct virtnet_rq_stats *stats)
+{
+	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
+	int num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
+	struct page *page = virt_to_head_page(buf);
+	int offset = buf - page_address(page);
+	unsigned int xdp_frags_truesz = 0;
+	struct sk_buff *head_skb;
+	unsigned int frame_sz;
+	struct xdp_buff xdp;
+	void *data;
+	u32 act;
+	int err;
+
+	data = mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &frame_sz, &num_buf, &page,
+				     offset, &len, hdr);
+	if (!data)
+		goto err_xdp;
+
+	err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
+					 &num_buf, &xdp_frags_truesz, stats);
+	if (unlikely(err))
+		goto err_xdp;
+
+	act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
+
+	switch (act) {
+	case VIRTNET_XDP_RES_PASS:
+		head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
+		if (unlikely(!head_skb))
+			goto err_xdp;
+		return head_skb;
+
+	case VIRTNET_XDP_RES_CONSUMED:
+		return NULL;
+
+	case VIRTNET_XDP_RES_DROP:
+		break;
+	}
+
+err_xdp:
+	put_page(page);
+	mergeable_buf_free(rq, num_buf, dev, stats);
+
+	stats->xdp_drops++;
+	stats->drops++;
+	return NULL;
+}
+
 static struct sk_buff *receive_mergeable(struct net_device *dev,
 					 struct virtnet_info *vi,
 					 struct receive_queue *rq,
@@ -1325,21 +1382,22 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 					 unsigned int *xdp_xmit,
 					 struct virtnet_rq_stats *stats)
 {
-	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
-	int num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
-	struct page *page = virt_to_head_page(buf);
-	int offset = buf - page_address(page);
-	struct sk_buff *head_skb, *curr_skb;
-	struct bpf_prog *xdp_prog;
 	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	unsigned int tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
 	unsigned int room = SKB_DATA_ALIGN(headroom + tailroom);
-	unsigned int frame_sz;
-	int err;
+	struct virtio_net_hdr_mrg_rxbuf *hdr;
+	struct sk_buff *head_skb, *curr_skb;
+	struct bpf_prog *xdp_prog;
+	struct page *page;
+	int num_buf;
+	int offset;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
+	hdr = buf;
+	num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
+	page = virt_to_head_page(buf);
 
 	if (unlikely(len > truesize - room)) {
 		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
@@ -1348,51 +1406,21 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	if (likely(!vi->xdp_enabled)) {
-		xdp_prog = NULL;
-		goto skip_xdp;
-	}
-
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(rq->xdp_prog);
-	if (xdp_prog) {
-		unsigned int xdp_frags_truesz = 0;
-		struct xdp_buff xdp;
-		void *data;
-		u32 act;
-
-		data = mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &frame_sz, &num_buf, &page,
-					     offset, &len, hdr);
-		if (!data)
-			goto err_xdp;
-
-		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
-						 &num_buf, &xdp_frags_truesz, stats);
-		if (unlikely(err))
-			goto err_xdp;
-
-		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
-
-		switch (act) {
-		case VIRTNET_XDP_RES_PASS:
-			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
-			if (unlikely(!head_skb))
-				goto err_xdp;
-
+	if (likely(vi->xdp_enabled)) {
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(rq->xdp_prog);
+		if (xdp_prog) {
+			head_skb = receive_mergeable_xdp(dev, vi, rq, xdp_prog,
+							 buf, ctx, len, xdp_xmit,
+							 stats);
 			rcu_read_unlock();
 			return head_skb;
-
-		case VIRTNET_XDP_RES_CONSUMED:
-			rcu_read_unlock();
-			goto xdp_xmit;
-
-		case VIRTNET_XDP_RES_DROP:
-			goto err_xdp;
 		}
+		rcu_read_unlock();
 	}
-	rcu_read_unlock();
 
-skip_xdp:
+	offset = buf - page_address(page);
+
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, headroom);
 	curr_skb = head_skb;
 
@@ -1458,9 +1486,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	ewma_pkt_len_add(&rq->mrg_avg_pkt_len, head_skb->len);
 	return head_skb;
 
-err_xdp:
-	rcu_read_unlock();
-	stats->xdp_drops++;
 err_skb:
 	put_page(page);
 	mergeable_buf_free(rq, num_buf, dev, stats);
@@ -1468,7 +1493,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 err_buf:
 	stats->drops++;
 	dev_kfree_skb(head_skb);
-xdp_xmit:
 	return NULL;
 }
 
-- 
2.32.0.3.g01195cf9f

