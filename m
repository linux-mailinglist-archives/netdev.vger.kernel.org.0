Return-Path: <netdev+bounces-804-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D62276F9FBF
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91B86280C50
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FCE9182A3;
	Mon,  8 May 2023 06:14:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088D182A2;
	Mon,  8 May 2023 06:14:42 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC1E11542;
	Sun,  7 May 2023 23:14:40 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vi.E8Al_1683526475;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vi.E8Al_1683526475)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 14:14:35 +0800
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
Subject: [PATCH net-next v5 15/15] virtio_net: introduce virtnet_build_skb()
Date: Mon,  8 May 2023 14:14:17 +0800
Message-Id: <20230508061417.65297-16-xuanzhuo@linux.alibaba.com>
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
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This logic is used in multiple places, now we separate it into
a helper.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 37287ede1959..97241006d64a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -443,6 +443,22 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
 	return (unsigned long)mrg_ctx & ((1 << MRG_CTX_HEADER_SHIFT) - 1);
 }
 
+static struct sk_buff *virtnet_build_skb(void *buf, unsigned int buflen,
+					 unsigned int headroom,
+					 unsigned int len)
+{
+	struct sk_buff *skb;
+
+	skb = build_skb(buf, buflen);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_reserve(skb, headroom);
+	skb_put(skb, len);
+
+	return skb;
+}
+
 /* Called from bottom half context */
 static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
@@ -476,13 +492,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
 	/* copy small packet so we can reuse these pages */
 	if (!NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
-		skb = build_skb(buf, truesize);
+		skb = virtnet_build_skb(buf, truesize, p - buf, len);
 		if (unlikely(!skb))
 			return NULL;
 
-		skb_reserve(skb, p - buf);
-		skb_put(skb, len);
-
 		page = (struct page *)page->private;
 		if (page)
 			give_pages(rq, page);
@@ -946,13 +959,10 @@ static struct sk_buff *receive_small_build_skb(struct virtnet_info *vi,
 	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
-	skb = build_skb(buf, buflen);
-	if (!skb)
+	skb = virtnet_build_skb(buf, buflen, headroom, len);
+	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, headroom);
-	skb_put(skb, len);
-
 	buf += header_offset;
 	memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 
@@ -1028,12 +1038,10 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
 		goto err_xdp;
 	}
 
-	skb = build_skb(buf, buflen);
-	if (!skb)
+	skb = virtnet_build_skb(buf, buflen, xdp.data - buf, len);
+	if (unlikely(!skb))
 		goto err;
 
-	skb_reserve(skb, xdp.data - buf);
-	skb_put(skb, len);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-- 
2.32.0.3.g01195cf9f


