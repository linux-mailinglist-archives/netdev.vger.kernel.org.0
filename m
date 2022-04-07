Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4C14F7A87
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiDGI40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243352AbiDGI4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:56:20 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CD4256677;
        Thu,  7 Apr 2022 01:54:15 -0700 (PDT)
X-UUID: 5f971f37c6b34234ac9c872879471170-20220407
X-UUID: 5f971f37c6b34234ac9c872879471170-20220407
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1309223339; Thu, 07 Apr 2022 16:54:11 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 7 Apr 2022 16:54:10 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Apr
 2022 16:54:04 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Apr 2022 16:54:03 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        <linux-kernel@vger.kernel.org>,
        Maciej enczykowski <maze@google.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        Lina Wang <lina.wang@mediatek.com>
Subject: [PATCH v5 3/3] net: fix wrong network header length
Date:   Thu, 7 Apr 2022 16:47:27 +0800
Message-ID: <20220407084727.10241-3-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220407084727.10241-1-lina.wang@mediatek.com>
References: <20220407084727.10241-1-lina.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is enable,
several skbs are gathered in skb_shinfo(skb)->frag_list. The first skb's
ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
network_header\transport_header\mac_header have been updated as ipv4 acts,
but other skbs in frag_list didnot update anything, just ipv6 packets.

udp_queue_rcv_skb will call skb_segment_list to traverse other skbs in
frag_list and make sure right udp payload is delivered to user space.
Unfortunately, other skbs in frag_list who are still ipv6 packets are
updated like the first skb and will have wrong transport header length.

e.g.before bpf_skb_proto_6_to_4,the first skb and other skbs in frag_list
has the same network_header(24)& transport_header(64), after
bpf_skb_proto_6_to_4, ipv6 protocol has been changed to ipv4, the first
skb's network_header is 44,transport_header is 64, other skbs in frag_list
didnot change.After skb_segment_list, the other skbs in frag_list has
different network_header(24) and transport_header(44), so there will be 20
bytes different from original,that is difference between ipv6 header and
ipv4 header. Just change transport_header to be the same with original.

Actually, there are two solutions to fix it, one is traversing all skbs
and changing every skb header in bpf_skb_proto_6_to_4, the other is
modifying frag_list skb's header in skb_segment_list. Considering
efficiency, adopt the second one--- when the first skb and other skbs in
frag_list has different network_header length, restore them to make sure
right udp payload is delivered to user space.

Signed-off-by: Lina Wang <lina.wang@mediatek.com>
---
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 10bde7c6db44..e8006e0a1b25 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3897,7 +3897,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb, *tmp;
-	int err;
+	int len_diff, err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
@@ -3937,9 +3937,11 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
 		skb_release_head_state(nskb);
+		len_diff = skb_network_header_len(nskb) - skb_network_header_len(skb);
 		__copy_skb_header(nskb, skb);
 
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
+		nskb->transport_header += len_diff;
 		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
 						 nskb->data - tnl_hlen,
 						 offset + tnl_hlen);
-- 
2.18.0

