Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C39B4B81CA
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiBPHh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:37:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiBPHh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:37:57 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DD91986F6;
        Tue, 15 Feb 2022 23:37:17 -0800 (PST)
X-UUID: 9157c8615f1146ca9f59d6e2acc8c07d-20220216
X-UUID: 9157c8615f1146ca9f59d6e2acc8c07d-20220216
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 956864657; Wed, 16 Feb 2022 15:36:52 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 16 Feb 2022 15:36:51 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Feb 2022 15:36:50 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <maze@google.com>, Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lina Wang <lina.wang@mediatek.com>
Subject: [PATCH v3] net: fix wrong network header length
Date:   Wed, 16 Feb 2022 15:30:55 +0800
Message-ID: <20220216073055.22642-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
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
index 0118f0afaa4f..f5ea977d8f24 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3865,7 +3865,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb, *tmp;
-	int err;
+	int len_diff, err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
@@ -3905,9 +3905,11 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
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

