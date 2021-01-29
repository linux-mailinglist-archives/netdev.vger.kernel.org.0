Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251EE309012
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 23:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhA2W2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 17:28:38 -0500
Received: from novek.ru ([213.148.174.62]:52278 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233401AbhA2W2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 17:28:36 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 0D7BA50336D;
        Sat, 30 Jan 2021 01:29:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 0D7BA50336D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611959354; bh=gv0a+B+AMgdeZCH+s0c02sBnSxhy59mJ7SAXEOOWdJU=;
        h=From:To:Cc:Subject:Date:From;
        b=Y+JSvXlkqJyey5H1j8wPozZMz/T0bJvzHgPKwcKvy03duR5zQODg9Gcthopo4/tHj
         hF/Mm1rXfM2UildysTLtF6WYLXcJPdh4N+4k2BT2ylp4SEQAB3qKHN9u6mAid+/Mxo
         3a29WcL5vEluS23Ljnyi9QRchDkeryBK6YweHMIE=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Slava Bacherikov <mail@slava.cc>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [RESEND net v3] net: ip_tunnel: fix mtu calculation
Date:   Sat, 30 Jan 2021 01:27:47 +0300
Message-Id: <1611959267-20536-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev->hard_header_len for tunnel interface is set only when header_ops
are set too and already contains full overhead of any tunnel encapsulation.
That's why there is not need to use this overhead twice in mtu calc.

Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
Reported-by: Slava Bacherikov <mail@slava.cc>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv4/ip_tunnel.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 64594aa..76a420c 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -317,7 +317,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 	}
 
 	dev->needed_headroom = t_hlen + hlen;
-	mtu -= (dev->hard_header_len + t_hlen);
+	mtu -= t_hlen;
 
 	if (mtu < IPV4_MIN_MTU)
 		mtu = IPV4_MIN_MTU;
@@ -347,7 +347,7 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
 	nt = netdev_priv(dev);
 	t_hlen = nt->hlen + sizeof(struct iphdr);
 	dev->min_mtu = ETH_MIN_MTU;
-	dev->max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
+	dev->max_mtu = IP_MAX_MTU - t_hlen;
 	ip_tunnel_add(itn, nt);
 	return nt;
 
@@ -488,11 +488,10 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 	int mtu;
 
 	tunnel_hlen = md ? tunnel_hlen : tunnel->hlen;
-	pkt_size = skb->len - tunnel_hlen - dev->hard_header_len;
+	pkt_size = skb->len - tunnel_hlen;
 
 	if (df)
-		mtu = dst_mtu(&rt->dst) - dev->hard_header_len
-					- sizeof(struct iphdr) - tunnel_hlen;
+		mtu = dst_mtu(&rt->dst) - (sizeof(struct iphdr) + tunnel_hlen);
 	else
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
@@ -972,7 +971,7 @@ int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
-	int max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
+	int max_mtu = IP_MAX_MTU - t_hlen;
 
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
@@ -1149,10 +1148,9 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
 
 	mtu = ip_tunnel_bind_dev(dev);
 	if (tb[IFLA_MTU]) {
-		unsigned int max = IP_MAX_MTU - dev->hard_header_len - nt->hlen;
+		unsigned int max = IP_MAX_MTU - (nt->hlen + sizeof(struct iphdr));
 
-		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU,
-			    (unsigned int)(max - sizeof(struct iphdr)));
+		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU, max);
 	}
 
 	err = dev_set_mtu(dev, mtu);
-- 
1.8.3.1

