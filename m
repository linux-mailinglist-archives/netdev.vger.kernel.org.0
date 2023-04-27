Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F316EFFAF
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbjD0DHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243024AbjD0DGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:06:31 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AE746BA;
        Wed, 26 Apr 2023 20:05:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vh5Z4Xz_1682564751;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vh5Z4Xz_1682564751)
          by smtp.aliyun-inc.com;
          Thu, 27 Apr 2023 11:05:52 +0800
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
Subject: [PATCH net-next v4 15/15] virtio_net: introduce virtnet_build_skb()
Date:   Thu, 27 Apr 2023 11:05:34 +0800
Message-Id: <20230427030534.115066-16-xuanzhuo@linux.alibaba.com>
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

This logic is used in multiple places, now we separate it into
a helper.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c526852a8547..256bcd0890a2 100644
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
@@ -942,13 +955,10 @@ static struct sk_buff *receive_small_build_skb(struct virtnet_info *vi,
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
 
@@ -1024,12 +1034,10 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
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

