Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62F24DB24C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356335AbiCPOPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356196AbiCPOPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:15:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F851DA68;
        Wed, 16 Mar 2022 07:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 967CAB81B73;
        Wed, 16 Mar 2022 14:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26DAC340EC;
        Wed, 16 Mar 2022 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440062;
        bh=P35xTf4iwp/DUEsFUMcqfNfZ7QDo6NaErTy6nzlq8/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5l+ZlbSLSUx02v2BspO11mre3cmcbwRYHNts3vBRnLVZQbSF3gVfgSPvRQQXqTXA
         2OQxFsWhsi2WYJJki0MUgiMBbQDJm5XdE8/T+wNXZUsd6xQoq5efKaAB7VJQJCLv2d
         BDiNphQ3Y1nirexAIr5YqjKR8VkJSryMY/iSPixZ2IiMEgCpEFH5AXLQ91KDTdnVIj
         nR+yM0/9GZ3Hm3Ndn3G9oIPvsHCTJ+TjxVNterJwYg0XYR0S7ZrgBqiWBV4eGnxk2x
         LkBsCmLXeSi4UXR98ZteKUD0jlyaPT48raoryeugUjD+rNaSCEIrni07XKqHf53+4H
         VIfjhQ+szdo2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lina Wang <lina.wang@mediatek.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 04/13] xfrm: fix tunnel model fragmentation behavior
Date:   Wed, 16 Mar 2022 10:13:45 -0400
Message-Id: <20220316141354.247750-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141354.247750-1-sashal@kernel.org>
References: <20220316141354.247750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lina Wang <lina.wang@mediatek.com>

[ Upstream commit 4ff2980b6bd2aa6b4ded3ce3b7c0ccfab29980af ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.34.1

