Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC008306BFB
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhA1EMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:12:08 -0500
Received: from novek.ru ([213.148.174.62]:46642 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231337AbhA1EMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 23:12:06 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C635E503330;
        Thu, 28 Jan 2021 06:50:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C635E503330
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611805821; bh=gpzk8KAGA14EFU9k0z0IDLjGlGuJM+jStR0X1rT7P1E=;
        h=From:To:Cc:Subject:Date:From;
        b=GAg7wYkr4UfPNgZH/8Zp3nrFEPmfEBssSxWon319gnXArvoWTcFD85LTrhy5UqG3o
         NPwf2WKhOCxKoVAXKnm0H06Fy0XR5kNMN3kOU4e/HmIgJPNKhj/1iVsAdlr9vjSvtZ
         t6MAZ0v1C9ItP36Bp7NTVTqY+9dLSw5dKgvwV3zY=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Slava Bacherikov <mail@slava.cc>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net] net: ip_tunnel: fix mtu calculation
Date:   Thu, 28 Jan 2021 06:48:53 +0300
Message-Id: <1611805733-25072-1-git-send-email-vfedorenko@novek.ru>
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
 net/ipv4/ip_tunnel.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 64594aa..ad78825 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -317,7 +317,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 	}
 
 	dev->needed_headroom = t_hlen + hlen;
-	mtu -= (dev->hard_header_len + t_hlen);
+	mtu -= dev->hard_header_len ? : t_hlen;
 
 	if (mtu < IPV4_MIN_MTU)
 		mtu = IPV4_MIN_MTU;
@@ -347,7 +347,7 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
 	nt = netdev_priv(dev);
 	t_hlen = nt->hlen + sizeof(struct iphdr);
 	dev->min_mtu = ETH_MIN_MTU;
-	dev->max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
+	dev->max_mtu = IP_MAX_MTU - dev->hard_header_len ? : t_hlen;
 	ip_tunnel_add(itn, nt);
 	return nt;
 
@@ -488,11 +488,11 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 	int mtu;
 
 	tunnel_hlen = md ? tunnel_hlen : tunnel->hlen;
-	pkt_size = skb->len - tunnel_hlen - dev->hard_header_len;
+	pkt_size = skb->len - dev->hard_header_len ? : tunnel_hlen;
 
 	if (df)
-		mtu = dst_mtu(&rt->dst) - dev->hard_header_len
-					- sizeof(struct iphdr) - tunnel_hlen;
+		mtu = dst_mtu(&rt->dst) - dev->hard_header_len ? :
+					 (sizeof(struct iphdr) + tunnel_hlen);
 	else
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
@@ -972,7 +972,7 @@ int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
-	int max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
+	int max_mtu = IP_MAX_MTU - dev->hard_header_len ? : t_hlen;
 
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
@@ -1149,10 +1149,10 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
 
 	mtu = ip_tunnel_bind_dev(dev);
 	if (tb[IFLA_MTU]) {
-		unsigned int max = IP_MAX_MTU - dev->hard_header_len - nt->hlen;
+		unsigned int max = IP_MAX_MTU - dev->hard_header_len ? :
+						 (nt->hlen + sizeof(struct iphdr));
 
-		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU,
-			    (unsigned int)(max - sizeof(struct iphdr)));
+		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU, max);
 	}
 
 	err = dev_set_mtu(dev, mtu);
-- 
1.8.3.1

