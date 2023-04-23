Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DE46EBEF6
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 12:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjDWK6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 06:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjDWK6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 06:58:10 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBAD268C;
        Sun, 23 Apr 2023 03:57:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgjkwmZ_1682247473;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgjkwmZ_1682247473)
          by smtp.aliyun-inc.com;
          Sun, 23 Apr 2023 18:57:54 +0800
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
Subject: [PATCH net-next v3 14/15] virtio_net: introduce receive_small_build_xdp
Date:   Sun, 23 Apr 2023 18:57:35 +0800
Message-Id: <20230423105736.56918-15-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com>
References: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 3bb17d92efad
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplifying receive_small() function. Bringing the logic relating to
build_skb together.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d2973c8fa48c..811cf1046df2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -931,6 +931,34 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	return NULL;
 }
 
+static struct sk_buff *receive_small_build_skb(struct virtnet_info *vi,
+					       unsigned int xdp_headroom,
+					       void *buf,
+					       unsigned int len)
+{
+	unsigned int header_offset;
+	unsigned int headroom;
+	unsigned int buflen;
+	struct sk_buff *skb;
+
+	header_offset = VIRTNET_RX_PAD + xdp_headroom;
+	headroom = vi->hdr_len + header_offset;
+	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
+	skb = build_skb(buf, buflen);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, headroom);
+	skb_put(skb, len);
+
+	buf += header_offset;
+	memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
+
+	return skb;
+}
+
 static struct sk_buff *receive_small_xdp(struct net_device *dev,
 					 struct virtnet_info *vi,
 					 struct receive_queue *rq,
@@ -1030,9 +1058,6 @@ static struct sk_buff *receive_small(struct net_device *dev,
 {
 	unsigned int xdp_headroom = (unsigned long)ctx;
 	struct page *page = virt_to_head_page(buf);
-	unsigned int header_offset;
-	unsigned int headroom;
-	unsigned int buflen;
 	struct sk_buff *skb;
 
 	len -= vi->hdr_len;
@@ -1060,20 +1085,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		rcu_read_unlock();
 	}
 
-	header_offset = VIRTNET_RX_PAD + xdp_headroom;
-	headroom = vi->hdr_len + header_offset;
-	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
-		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-
-	skb = build_skb(buf, buflen);
-	if (!skb)
-		goto err;
-	skb_reserve(skb, headroom);
-	skb_put(skb, len);
-
-	buf += header_offset;
-	memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
-	return skb;
+	skb = receive_small_build_skb(vi, xdp_headroom, buf, len);
+	if (likely(skb))
+		return skb;
 
 err:
 	stats->drops++;
-- 
2.32.0.3.g01195cf9f

