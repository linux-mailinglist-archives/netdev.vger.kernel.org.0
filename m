Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E396E59DE
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjDRGyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjDRGxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:53:52 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB2C55BA;
        Mon, 17 Apr 2023 23:53:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgOKk2I_1681800820;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgOKk2I_1681800820)
          by smtp.aliyun-inc.com;
          Tue, 18 Apr 2023 14:53:40 +0800
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
Subject: [PATCH net-next v2 12/14] virtio_net: small: optimize code
Date:   Tue, 18 Apr 2023 14:53:25 +0800
Message-Id: <20230418065327.72281-13-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d931ac25730a
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        URIBL_BLOCKED,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of XDP-PASS, skb_reserve uses the delta to compatible
non-XDP, now remove this logic.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 34220f5f27d1..f6f5903face2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -959,9 +959,7 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
 	unsigned int buflen;
 	struct xdp_buff xdp;
 	struct sk_buff *skb;
-	unsigned int delta = 0;
 	unsigned int metasize = 0;
-	void *orig_data;
 	u32 act;
 
 	if (unlikely(hdr->hdr.gso_type))
@@ -994,14 +992,12 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
 	xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
 	xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
 			 xdp_headroom, len, true);
-	orig_data = xdp.data;
 
 	act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
 
 	switch (act) {
 	case VIRTNET_XDP_RES_PASS:
 		/* Recalculate length in case bpf program changed it */
-		delta = orig_data - xdp.data;
 		len = xdp.data_end - xdp.data;
 		metasize = xdp.data - xdp.data_meta;
 		break;
@@ -1017,7 +1013,7 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
 	if (!skb)
 		goto err;
 
-	skb_reserve(skb, headroom - delta);
+	skb_reserve(skb, xdp.data - buf);
 	skb_put(skb, len);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
-- 
2.32.0.3.g01195cf9f

