Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98494D2FB2
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbiCINJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiCINJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:09:49 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4793CC8FA0
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 05:08:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F384C2019D;
        Wed,  9 Mar 2022 14:08:48 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DRINu8tKeVQc; Wed,  9 Mar 2022 14:08:42 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 965332009B;
        Wed,  9 Mar 2022 14:08:42 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 8F0E480004A;
        Wed,  9 Mar 2022 14:08:42 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Wed, 9 Mar 2022 14:08:42 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 9 Mar
 2022 14:08:41 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9DADA3180625; Wed,  9 Mar 2022 14:08:41 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/5] xfrm: fix tunnel model fragmentation behavior
Date:   Wed, 9 Mar 2022 14:08:35 +0100
Message-ID: <20220309130839.3263912-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309130839.3263912-1-steffen.klassert@secunet.com>
References: <20220309130839.3263912-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lina Wang <lina.wang@mediatek.com>

in tunnel mode, if outer interface(ipv4) is less, it is easily to let
inner IPV6 mtu be less than 1280. If so, a Packet Too Big ICMPV6 message
is received. When send again, packets are fragmentized with 1280, they
are still rejected with ICMPV6(Packet Too Big) by xfrmi_xmit2().

According to RFC4213 Section3.2.2:
if (IPv4 path MTU - 20) is less than 1280
	if packet is larger than 1280 bytes
		Send ICMPv6 "packet too big" with MTU=1280
                Drop packet
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

48              2002::10        2002::11 1296(length) IPv6 fragment (off=0 more=y ident=0xa20da5bc nxt=50)
49   0x0000 (0) 2002::10        2002::11 1304         IPv6 fragment (off=0 more=y ident=0x7448042c nxt=44)
50   0x0000 (0) 2002::10        2002::11 200          ESP (SPI=0x00035000)
51              2002::10        2002::11 180          Echo (ping) request
52   0x56dc     2002::10        2002::11 248          IPv6 fragment (off=1232 more=n ident=0xa20da5bc nxt=50)

xfrm6_noneed_fragment has fixed above issues. Finally, it acted like below:
1   0x6206 192.168.1.138   192.168.1.1 1316 Fragmented IP protocol (proto=Encap Security Payload 50, off=0, ID=6206) [Reassembled in #2]
2   0x6206 2002::10        2002::11    88   IPv6 fragment (off=0 more=y ident=0x1f440778 nxt=50)
3   0x0000 2002::10        2002::11    248  ICMPv6    Echo (ping) request

Signed-off-by: Lina Wang <lina.wang@mediatek.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/xfrm6_output.c   | 16 ++++++++++++++++
 net/xfrm/xfrm_interface.c |  5 ++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index d0d280077721..ad07904642ca 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -45,6 +45,19 @@ static int __xfrm6_output_finish(struct net *net, struct sock *sk, struct sk_buf
 	return xfrm_output(sk, skb);
 }
 
+static int xfrm6_noneed_fragment(struct sk_buff *skb)
+{
+	struct frag_hdr *fh;
+	u8 prevhdr = ipv6_hdr(skb)->nexthdr;
+
+	if (prevhdr != NEXTHDR_FRAGMENT)
+		return 0;
+	fh = (struct frag_hdr *)(skb->data + sizeof(struct ipv6hdr));
+	if (fh->nexthdr == NEXTHDR_ESP || fh->nexthdr == NEXTHDR_AUTH)
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
+	} else if (toobig && xfrm6_noneed_fragment(skb)) {
+		skb->ignore_df = 1;
+		goto skip_frag;
 	} else if (!skb->ignore_df && toobig && skb->sk) {
 		xfrm_local_error(skb, mtu);
 		kfree_skb(skb);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 4e3c62d1ad9e..1e8b26eecb3f 100644
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
2.25.1

