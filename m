Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B49F6E59E1
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjDRGyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjDRGyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:54:05 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EFC65B0;
        Mon, 17 Apr 2023 23:53:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgOLnp3_1681800822;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgOLnp3_1681800822)
          by smtp.aliyun-inc.com;
          Tue, 18 Apr 2023 14:53:43 +0800
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
Subject: [PATCH net-next v2 14/14] virtio_net: small: remove skip_xdp
Date:   Tue, 18 Apr 2023 14:53:27 +0800
Message-Id: <20230418065327.72281-15-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d931ac25730a
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

now, the process of xdp is simple, we can remove the skip_xdp.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5a5636178bd3..19f7a8367c17 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1037,13 +1037,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
 				     unsigned int *xdp_xmit,
 				     struct virtnet_rq_stats *stats)
 {
-	struct sk_buff *skb;
-	struct bpf_prog *xdp_prog;
 	unsigned int xdp_headroom = (unsigned long)ctx;
 	struct page *page = virt_to_head_page(buf);
 	unsigned int header_offset;
 	unsigned int headroom;
 	unsigned int buflen;
+	struct sk_buff *skb;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -1055,22 +1054,21 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		goto err;
 	}
 
-	if (likely(!vi->xdp_enabled)) {
-		xdp_prog = NULL;
-		goto skip_xdp;
-	}
+	if (unlikely(vi->xdp_enabled)) {
+		struct bpf_prog *xdp_prog;
 
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(rq->xdp_prog);
-	if (xdp_prog) {
-		skb = receive_small_xdp(dev, vi, rq, xdp_prog, buf, xdp_headroom,
-					len, xdp_xmit, stats);
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(rq->xdp_prog);
+		if (xdp_prog) {
+			skb = receive_small_xdp(dev, vi, rq, xdp_prog, buf,
+						xdp_headroom, len, xdp_xmit,
+						stats);
+			rcu_read_unlock();
+			return skb;
+		}
 		rcu_read_unlock();
-		return skb;
 	}
-	rcu_read_unlock();
 
-skip_xdp:
 	header_offset = VIRTNET_RX_PAD + xdp_headroom;
 	headroom = vi->hdr_len + header_offset;
 	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
-- 
2.32.0.3.g01195cf9f

