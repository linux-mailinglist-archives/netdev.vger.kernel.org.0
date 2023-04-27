Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B736EFFA6
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243056AbjD0DGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242957AbjD0DG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:06:26 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C743A88;
        Wed, 26 Apr 2023 20:05:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vh5fo0-_1682564750;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vh5fo0-_1682564750)
          by smtp.aliyun-inc.com;
          Thu, 27 Apr 2023 11:05:51 +0800
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
Subject: [PATCH net-next v4 14/15] virtio_net: introduce receive_small_build_xdp
Date:   Thu, 27 Apr 2023 11:05:33 +0800
Message-Id: <20230427030534.115066-15-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
References: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 69b1082fef22
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

Simplifying receive_small() function. Bringing the logic relating to
build_skb together.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a76db3d19eb7..c526852a8547 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -927,6 +927,34 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
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
@@ -1026,9 +1054,6 @@ static struct sk_buff *receive_small(struct net_device *dev,
 {
 	unsigned int xdp_headroom = (unsigned long)ctx;
 	struct page *page = virt_to_head_page(buf);
-	unsigned int header_offset;
-	unsigned int headroom;
-	unsigned int buflen;
 	struct sk_buff *skb;
 
 	len -= vi->hdr_len;
@@ -1056,20 +1081,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
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

