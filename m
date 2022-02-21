Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEC74BD550
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 06:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344474AbiBUFXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:23:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344467AbiBUFXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:23:42 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D187B1106;
        Sun, 20 Feb 2022 21:23:15 -0800 (PST)
X-UUID: e1ce2c3cfc84441da9ec6c38340dcaa2-20220221
X-UUID: e1ce2c3cfc84441da9ec6c38340dcaa2-20220221
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 731770152; Mon, 21 Feb 2022 13:23:13 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 21 Feb 2022 13:23:12 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Feb
 2022 13:23:08 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 21 Feb 2022 13:23:05 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Lina Wang <lina.wang@mediatek.com>
Subject: [PATCH] xfrm: fix tunnel model fragmentation behavior
Date:   Mon, 21 Feb 2022 13:16:48 +0800
Message-ID: <20220221051648.22660-1-lina.wang@mediatek.com>
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

in tunnel mode, if outer interface(ipv4) is less, it is easily to let 
inner IPV6 mtu be less than 1280. If so, a Packet Too Big ICMPV6 message 
is received. When send again, packets are fragmentized with 1280, they
are still rejected with ICMPV6(Packet Too Big) by xfrmi_xmit2().

According to RFC4213 Section3.2.2:
         if (IPv4 path MTU - 20) is less than 1280
                 if packet is larger than 1280 bytes
                         Send ICMPv6 "packet too big" with MTU = 1280.
                         Drop packet.
                 else
                         Encapsulate but do not set the Don't Fragment
                         flag in the IPv4 header.  The resulting IPv4
                         packet might be fragmented by the IPv4 layer
                         on the encapsulator or by some router along
                         the IPv4 path.
                 endif
         else
                 if packet is larger than (IPv4 path MTU - 20)
                         Send ICMPv6 "packet too big" with
                         MTU = (IPv4 path MTU - 20).
                         Drop packet.
                 else
                         Encapsulate and set the Don't Fragment flag
                         in the IPv4 header.
                 endif
         endif
Packets should be fragmentized with ipv4 outer interface, so change it.

After it is fragemtized with ipv4, there will be double fragmenation.
No.48 & No.51 are ipv6 fragment packets, No.48 is double fragmentized, 
then tunneled with IPv4(No.49& No.50), which obey spec. And received peer
cannot decrypt it rightly.

48              2002::10	2002::11 1296(length) IPv6 fragment (off=0 more=y ident=0xa20da5bc nxt=50) 
49   0x0000 (0) 2002::10	2002::11 1304	      IPv6 fragment (off=0 more=y ident=0x7448042c nxt=44)
50   0x0000 (0)	2002::10	2002::11 200	      ESP (SPI=0x00035000) 
51		2002::10	2002::11 180	      Echo (ping) request 
52   0x56dc     2002::10	2002::11 248	      IPv6 fragment (off=1232 more=n ident=0xa20da5bc nxt=50)

esp_noneed_fragment has fixed above issues. Finally, it acted like below:
1   0x6206 192.168.1.138   192.168.1.1 1316 Fragmented IP protocol (proto=Encap Security Payload 50, off=0, ID=6206) [Reassembled in #2]
2   0x6206 2002::10	   2002::11    88   IPv6 fragment (off=0 more=y ident=0x1f440778 nxt=50)
3   0x0000 2002::10	   2002::11    248  ICMPv6    Echo (ping) request 

Signed-off-by: Lina Wang <lina.wang@mediatek.com>
---
 net/ipv6/xfrm6_output.c   | 16 ++++++++++++++++
 net/xfrm/xfrm_interface.c |  5 ++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index d0d280077721..ab4384e22b4f 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -45,6 +45,19 @@ static int __xfrm6_output_finish(struct net *net, struct sock *sk, struct sk_buf
 	return xfrm_output(sk, skb);
 }
 
+static int esp_noneed_fragment(struct sk_buff *skb)
+{
+	struct frag_hdr *fh;
+	u8 prevhdr = ipv6_hdr(skb)->nexthdr;
+
+	if (prevhdr != NEXTHDR_FRAGMENT)
+		return 0;
+	fh = (struct frag_hdr *)(skb->data + sizeof(struct ipv6hdr));
+	if (fh->nexthdr == NEXTHDR_ESP)
+		return 1;
+	return 0;
+}
+
 static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -73,6 +86,9 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		xfrm6_local_rxpmtu(skb, mtu);
 		kfree_skb(skb);
 		return -EMSGSIZE;
+	} else if (toobig && esp_noneed_fragment(skb)) {
+		skb->ignore_df = 1;
+		goto skip_frag;
 	} else if (!skb->ignore_df && toobig && skb->sk) {
 		xfrm_local_error(skb, mtu);
 		kfree_skb(skb);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 57448fc519fc..242351fffdeb 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -304,7 +304,10 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 			if (mtu < IPV6_MIN_MTU)
 				mtu = IPV6_MIN_MTU;
 
-			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			if (skb->len > 1280)
+				icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			else
+				goto xmit;
 		} else {
 			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
 				goto xmit;
-- 
2.18.0

