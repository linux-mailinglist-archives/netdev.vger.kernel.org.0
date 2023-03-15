Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB026BA608
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCOELe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjCOELD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:11:03 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E1646095;
        Tue, 14 Mar 2023 21:10:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VducNby_1678853451;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VducNby_1678853451)
          by smtp.aliyun-inc.com;
          Wed, 15 Mar 2023 12:10:52 +0800
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
Subject: [RFC net-next 8/8] virtio_net: introduce receive_small_xdp()
Date:   Wed, 15 Mar 2023 12:10:42 +0800
Message-Id: <20230315041042.88138-9-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230315041042.88138-1-xuanzhuo@linux.alibaba.com>
References: <20230315041042.88138-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: a046238c058f
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to simplify the receive_small().
Separate all the logic of XDP of small into a function.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 165 +++++++++++++++++++++++----------------
 1 file changed, 97 insertions(+), 68 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b8c6638352f6..ed08b5b5f716 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -869,6 +869,96 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	return NULL;
 }
 
+static struct sk_buff *receive_small_xdp(struct net_device *dev,
+					 struct virtnet_info *vi,
+					 struct receive_queue *rq,
+					 struct bpf_prog *xdp_prog,
+					 void *buf,
+					 void *ctx,
+					 unsigned int len,
+					 unsigned int *xdp_xmit,
+					 struct virtnet_rq_stats *stats)
+{
+	unsigned int xdp_headroom = (unsigned long)ctx;
+	unsigned int header_offset = VIRTNET_RX_PAD + xdp_headroom;
+	unsigned int headroom = vi->hdr_len + header_offset;
+	struct virtio_net_hdr_mrg_rxbuf *hdr = buf + header_offset;
+	struct page *page = virt_to_head_page(buf);
+	struct page *xdp_page;
+	unsigned int buflen;
+	struct xdp_buff xdp;
+	struct sk_buff *skb;
+	unsigned int delta = 0;
+	unsigned int metasize = 0;
+	void *orig_data;
+	u32 act;
+
+	if (unlikely(hdr->hdr.gso_type))
+		goto err_xdp;
+
+	if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
+		int offset = buf - page_address(page) + header_offset;
+		unsigned int tlen = len + vi->hdr_len;
+		int num_buf = 1;
+
+		xdp_headroom = virtnet_get_headroom(vi);
+		header_offset = VIRTNET_RX_PAD + xdp_headroom;
+		headroom = vi->hdr_len + header_offset;
+		buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
+			SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		xdp_page = xdp_linearize_page(rq, &num_buf, page,
+					      offset, header_offset,
+					      &tlen);
+		if (!xdp_page)
+			goto err_xdp;
+
+		buf = page_address(xdp_page);
+		put_page(page);
+		page = xdp_page;
+	}
+
+	xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
+			 xdp_headroom, len, true);
+	orig_data = xdp.data;
+
+	act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
+
+	switch (act) {
+	case VIRTNET_XDP_RES_PASS:
+		/* Recalculate length in case bpf program changed it */
+		delta = orig_data - xdp.data;
+		len = xdp.data_end - xdp.data;
+		metasize = xdp.data - xdp.data_meta;
+		break;
+
+	case VIRTNET_XDP_RES_CONSUMED:
+		goto xdp_xmit;
+
+	case VIRTNET_XDP_RES_DROP:
+		goto err_xdp;
+	}
+
+	skb = build_skb(buf, buflen);
+	if (!skb)
+		goto err;
+
+	skb_reserve(skb, headroom - delta);
+	skb_put(skb, len);
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
+	return skb;
+
+err_xdp:
+	stats->xdp_drops++;
+err:
+	stats->drops++;
+	put_page(page);
+xdp_xmit:
+	return NULL;
+}
+
 static struct sk_buff *receive_small(struct net_device *dev,
 				     struct virtnet_info *vi,
 				     struct receive_queue *rq,
@@ -879,15 +969,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
 {
 	struct sk_buff *skb;
 	struct bpf_prog *xdp_prog;
-	unsigned int xdp_headroom = (unsigned long)ctx;
-	unsigned int header_offset = VIRTNET_RX_PAD + xdp_headroom;
+	unsigned int header_offset = VIRTNET_RX_PAD;
 	unsigned int headroom = vi->hdr_len + header_offset;
 	unsigned int buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 			      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	struct page *page = virt_to_head_page(buf);
-	unsigned int delta = 0;
-	struct page *xdp_page;
-	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -907,57 +993,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
-		struct virtio_net_hdr_mrg_rxbuf *hdr = buf + header_offset;
-		struct xdp_buff xdp;
-		void *orig_data;
-		u32 act;
-
-		if (unlikely(hdr->hdr.gso_type))
-			goto err_xdp;
-
-		if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
-			int offset = buf - page_address(page) + header_offset;
-			unsigned int tlen = len + vi->hdr_len;
-			int num_buf = 1;
-
-			xdp_headroom = virtnet_get_headroom(vi);
-			header_offset = VIRTNET_RX_PAD + xdp_headroom;
-			headroom = vi->hdr_len + header_offset;
-			buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
-				 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-			xdp_page = xdp_linearize_page(rq, &num_buf, page,
-						      offset, header_offset,
-						      &tlen);
-			if (!xdp_page)
-				goto err_xdp;
-
-			buf = page_address(xdp_page);
-			put_page(page);
-			page = xdp_page;
-		}
-
-		xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
-		xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
-				 xdp_headroom, len, true);
-		orig_data = xdp.data;
-
-		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
-
-		switch (act) {
-		case VIRTNET_XDP_RES_PASS:
-			/* Recalculate length in case bpf program changed it */
-			delta = orig_data - xdp.data;
-			len = xdp.data_end - xdp.data;
-			metasize = xdp.data - xdp.data_meta;
-			break;
-
-		case VIRTNET_XDP_RES_CONSUMED:
-			rcu_read_unlock();
-			goto xdp_xmit;
-
-		case VIRTNET_XDP_RES_DROP:
-			goto err_xdp;
-		}
+		skb = receive_small_xdp(dev, vi, rq, xdp_prog, buf, ctx, len, xdp_xmit, stats);
+		rcu_read_unlock();
+		return skb;
 	}
 	rcu_read_unlock();
 
@@ -965,25 +1003,16 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	skb = build_skb(buf, buflen);
 	if (!skb)
 		goto err;
-	skb_reserve(skb, headroom - delta);
+	skb_reserve(skb, headroom);
 	skb_put(skb, len);
-	if (!xdp_prog) {
-		buf += header_offset;
-		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
-	} /* keep zeroed vnet hdr since XDP is loaded */
-
-	if (metasize)
-		skb_metadata_set(skb, metasize);
 
+	buf += header_offset;
+	memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 	return skb;
 
-err_xdp:
-	rcu_read_unlock();
-	stats->xdp_drops++;
 err:
 	stats->drops++;
 	put_page(page);
-xdp_xmit:
 	return NULL;
 }
 
-- 
2.32.0.3.g01195cf9f

