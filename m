Return-Path: <netdev+bounces-799-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9241C6F9FA9
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D99C1C20945
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405BF171C7;
	Mon,  8 May 2023 06:14:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCD1171C5;
	Mon,  8 May 2023 06:14:36 +0000 (UTC)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA53F1634D;
	Sun,  7 May 2023 23:14:33 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vi.GnIp_1683526469;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vi.GnIp_1683526469)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 14:14:30 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: netdev@vger.kernel.org
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
	virtualization@lists.linux-foundation.org,
	bpf@vger.kernel.org
Subject: [PATCH net-next v5 10/15] virtio_net: introduce receive_small_xdp()
Date: Mon,  8 May 2023 14:14:12 +0800
Message-Id: <20230508061417.65297-11-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
References: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 847ebbc5df1e
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The purpose of this patch is to simplify the receive_small().
Separate all the logic of XDP of small into a function.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 165 ++++++++++++++++++++++++---------------
 1 file changed, 100 insertions(+), 65 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0baa6651dbb0..bc3bf190e614 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -931,6 +931,99 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	return NULL;
 }
 
+static struct sk_buff *receive_small_xdp(struct net_device *dev,
+					 struct virtnet_info *vi,
+					 struct receive_queue *rq,
+					 struct bpf_prog *xdp_prog,
+					 void *buf,
+					 unsigned int xdp_headroom,
+					 unsigned int len,
+					 unsigned int *xdp_xmit,
+					 struct virtnet_rq_stats *stats)
+{
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
+	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
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
+	case XDP_PASS:
+		/* Recalculate length in case bpf program changed it */
+		delta = orig_data - xdp.data;
+		len = xdp.data_end - xdp.data;
+		metasize = xdp.data - xdp.data_meta;
+		break;
+
+	case XDP_TX:
+	case XDP_REDIRECT:
+		goto xdp_xmit;
+
+	default:
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
@@ -947,9 +1040,6 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	unsigned int buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 			      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	struct page *page = virt_to_head_page(buf);
-	unsigned int delta = 0;
-	struct page *xdp_page;
-	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -969,56 +1059,10 @@ static struct sk_buff *receive_small(struct net_device *dev,
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
-		case XDP_PASS:
-			/* Recalculate length in case bpf program changed it */
-			delta = orig_data - xdp.data;
-			len = xdp.data_end - xdp.data;
-			metasize = xdp.data - xdp.data_meta;
-			break;
-		case XDP_TX:
-		case XDP_REDIRECT:
-			rcu_read_unlock();
-			goto xdp_xmit;
-		default:
-			goto err_xdp;
-		}
+		skb = receive_small_xdp(dev, vi, rq, xdp_prog, buf, xdp_headroom,
+					len, xdp_xmit, stats);
+		rcu_read_unlock();
+		return skb;
 	}
 	rcu_read_unlock();
 
@@ -1026,25 +1070,16 @@ static struct sk_buff *receive_small(struct net_device *dev,
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


