Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FD019529C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC0IKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:10:18 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54998 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgC0IKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 04:10:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 44ABD20299;
        Fri, 27 Mar 2020 09:10:16 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0nlmoDGB-Ill; Fri, 27 Mar 2020 09:10:15 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D1F652054D;
        Fri, 27 Mar 2020 09:10:13 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 27 Mar 2020 09:10:13 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 27 Mar
 2020 09:10:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 185613180285;
 Fri, 27 Mar 2020 09:10:13 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/8] vti[6]: fix packet tx through bpf_redirect() in XinY cases
Date:   Fri, 27 Mar 2020 09:10:01 +0100
Message-ID: <20200327081007.1185-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327081007.1185-1-steffen.klassert@secunet.com>
References: <20200327081007.1185-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

I forgot the 4in6/6in4 cases in my previous patch. Let's fix them.

Fixes: 95224166a903 ("vti[6]: fix packet tx through bpf_redirect()")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
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
2.17.1

