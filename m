Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3990C151DC0
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 17:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgBDQAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 11:00:33 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:39154 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgBDQAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 11:00:33 -0500
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 71C8C37B8D3;
        Tue,  4 Feb 2020 17:00:31 +0100 (CET)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1iz0cp-0007eG-5x; Tue, 04 Feb 2020 17:00:31 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, sd@queasysnail.net,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec v3] vti[6]: fix packet tx through bpf_redirect() in XinY cases
Date:   Tue,  4 Feb 2020 17:00:27 +0100
Message-Id: <20200204160027.29309-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200204114604.GA59185@bistromath.localdomain>
References: <20200204114604.GA59185@bistromath.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I forgot the 4in6/6in4 cases in my previous patch. Let's fix them.

Fixes: 95224166a903 ("vti[6]: fix packet tx through bpf_redirect()")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

v2 -> v3:
 - fix compilation when IPv6 is compiled as a module

v1 -> v2:
 - fix compilation when IPv6 is disabled

 net/ipv4/Kconfig   |  1 +
 net/ipv4/ip_vti.c  | 38 ++++++++++++++++++++++++++++++--------
 net/ipv6/ip6_vti.c | 32 +++++++++++++++++++++++++-------
 3 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index f96bd489b362..6490b845e17b 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -303,6 +303,7 @@ config SYN_COOKIES
 
 config NET_IPVTI
 	tristate "Virtual (secure) IP: tunneling"
+	depends on IPV6 || IPV6=n
 	select INET_TUNNEL
 	select NET_IP_TUNNEL
 	select XFRM
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 37cddd18f282..1b4e6f298648 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -187,17 +187,39 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	int mtu;
 
 	if (!dst) {
-		struct rtable *rt;
-
-		fl->u.ip4.flowi4_oif = dev->ifindex;
-		fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
-		rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
-		if (IS_ERR(rt)) {
+		switch (skb->protocol) {
+		case htons(ETH_P_IP): {
+			struct rtable *rt;
+
+			fl->u.ip4.flowi4_oif = dev->ifindex;
+			fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
+			rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
+			if (IS_ERR(rt)) {
+				dev->stats.tx_carrier_errors++;
+				goto tx_error_icmp;
+			}
+			dst = &rt->dst;
+			skb_dst_set(skb, dst);
+			break;
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		case htons(ETH_P_IPV6):
+			fl->u.ip6.flowi6_oif = dev->ifindex;
+			fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+			dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
+			if (dst->error) {
+				dst_release(dst);
+				dst = NULL;
+				dev->stats.tx_carrier_errors++;
+				goto tx_error_icmp;
+			}
+			skb_dst_set(skb, dst);
+			break;
+#endif
+		default:
 			dev->stats.tx_carrier_errors++;
 			goto tx_error_icmp;
 		}
-		dst = &rt->dst;
-		skb_dst_set(skb, dst);
 	}
 
 	dst_hold(dst);
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 524006aa0d78..56e642efefff 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -450,15 +450,33 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	int mtu;
 
 	if (!dst) {
-		fl->u.ip6.flowi6_oif = dev->ifindex;
-		fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
-		dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
-		if (dst->error) {
-			dst_release(dst);
-			dst = NULL;
+		switch (skb->protocol) {
+		case htons(ETH_P_IP): {
+			struct rtable *rt;
+
+			fl->u.ip4.flowi4_oif = dev->ifindex;
+			fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
+			rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
+			if (IS_ERR(rt))
+				goto tx_err_link_failure;
+			dst = &rt->dst;
+			skb_dst_set(skb, dst);
+			break;
+		}
+		case htons(ETH_P_IPV6):
+			fl->u.ip6.flowi6_oif = dev->ifindex;
+			fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+			dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
+			if (dst->error) {
+				dst_release(dst);
+				dst = NULL;
+				goto tx_err_link_failure;
+			}
+			skb_dst_set(skb, dst);
+			break;
+		default:
 			goto tx_err_link_failure;
 		}
-		skb_dst_set(skb, dst);
 	}
 
 	dst_hold(dst);
-- 
2.24.0

