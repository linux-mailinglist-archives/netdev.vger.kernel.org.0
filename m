Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F542D7591
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405928AbgLKM1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405451AbgLKM1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:38 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A109C0617A6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:21 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id a12so13065701lfl.6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J2qbl8+PQmeLyZfcgsn0UGIJs64aBXhfNs1G+gzOFeE=;
        b=GT30ZDQUXTm6AgOvtLafVa+12Pm0Mk5ihvh++zIqDa+1qort8nK8G0jJjda5uq2wq1
         j7NTSZQ+Echrv6LNGiB8GuX3zw9V+BLFH9UFNCxGxQPW3vV2srz8AS5M+88tInuAUEqy
         Bzv0GI2p57WDP52HQkQTkq+9wtJ87Dwc7Nz1J3TP8pK+qAUApJ6RiGIiD5ByLX0Anfrs
         h8jqhaTNwaTHLLasAMnIXAa0ozhMRDTq1hOwXBZW/P7OuzbxqGty7n5P67hXxbD7F6gt
         seiyniJd2RJ8OBmv9nep2kKIdFnw6+S5nu2d2OQnXAQ17r6gidMI5QLeHwcriWNvWBmJ
         4Gug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J2qbl8+PQmeLyZfcgsn0UGIJs64aBXhfNs1G+gzOFeE=;
        b=uWv8gtCcl433ZeqPm4XuxwZb02jdFgvZY/LNM6KfAQxENHNKc0o7rcwz+ESg1kWERV
         gz1Ln3iyCmTW5IxnHFFCEhYQw14I198ZpZOi6Y8r8dq7P9cPmndKF0WgQVXl5nJljstT
         LQkAFWSBAyoLYWzpdfYmTjwhyAv4LlOXYhddHy3V2PJl8LBj67VOcK6Rhv/CDqI7dvnM
         Pnfyzrw7vyIvtSt1R8KnhfpDyuGyFD2PjMAof/6KyAomHmT94qX8lsZ967gDcV8JrCuH
         YUOgRs2jHc7PszNO1ZInP0i46xo6e3BWqmT+sayl/vu2k4V4d1O/NFyAO45Sn4XO+LuJ
         ROsg==
X-Gm-Message-State: AOAM533SngTfVzD7xTgZLwL76F6uJ+cEcDuZKvPzLeyvGbN3EF5i1yrI
        KRvE2phXEoPN8jdnpzTKu+gCI+VPrHR5IA==
X-Google-Smtp-Source: ABdhPJztF0eHgvjzMT/9s3bmTnfbsUOQG9mTd32xeu2BL9RpQSiMqhX7Ds0wlkMh8tAoDPpP3gvvUA==
X-Received: by 2002:a19:418d:: with SMTP id o135mr4299776lfa.329.1607689579748;
        Fri, 11 Dec 2020 04:26:19 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:19 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 06/12] gtp: rework IPv4 functionality
Date:   Fri, 11 Dec 2020 13:26:06 +0100
Message-Id: <20201211122612.869225-7-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch does some cleanup work in the IPv4 functionality to lay the
groundwork for adding support for IPv6.  The form of these changes is
largely borrowed from the bareudp and geneve drivers, so there shouldn't
be anything here that looks unnecessarily unfamiliar.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 204 +++++++++++++++++++++-------------------------
 1 file changed, 92 insertions(+), 112 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index a1bb02818977..4a3a52970856 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -25,6 +25,7 @@
 #include <net/protocol.h>
 #include <net/ip.h>
 #include <net/udp.h>
+#include <net/ip_tunnels.h>
 #include <net/udp_tunnel.h>
 #include <net/icmp.h>
 #include <net/xfrm.h>
@@ -381,18 +382,36 @@ static void gtp_dev_uninit(struct net_device *dev)
 	free_percpu(dev->tstats);
 }
 
-static struct rtable *ip4_route_output_gtp(struct flowi4 *fl4,
-					   const struct sock *sk,
-					   __be32 daddr)
+static struct rtable *gtp_get_v4_rt(struct sk_buff *skb,
+				    struct net_device *dev,
+				    struct pdp_ctx *pctx,
+				    __be32 *saddr)
 {
-	memset(fl4, 0, sizeof(*fl4));
-	fl4->flowi4_oif		= sk->sk_bound_dev_if;
-	fl4->daddr		= daddr;
-	fl4->saddr		= inet_sk(sk)->inet_saddr;
-	fl4->flowi4_tos		= RT_CONN_FLAGS(sk);
-	fl4->flowi4_proto	= sk->sk_protocol;
-
-	return ip_route_output_key(sock_net(sk), fl4);
+	const struct sock *sk = pctx->sk;
+	struct rtable *rt = NULL;
+	struct flowi4 fl4;
+
+	memset(&fl4, 0, sizeof(fl4));
+	fl4.flowi4_oif		= sk->sk_bound_dev_if;
+	fl4.daddr		= pctx->peer_addr_ip4.s_addr;
+	fl4.saddr		= inet_sk(sk)->inet_saddr;
+	fl4.flowi4_tos		= RT_CONN_FLAGS(sk);
+	fl4.flowi4_proto	= sk->sk_protocol;
+
+	rt = ip_route_output_key(sock_net(sk), &fl4);
+	if (IS_ERR(rt)) {
+		netdev_dbg(pctx->dev, "no route to %pI4\n", &fl4.daddr);
+		return ERR_PTR(-ENETUNREACH);
+	}
+	if (rt->dst.dev == dev) {
+		netdev_dbg(pctx->dev, "circular route to %pI4\n", &fl4.daddr);
+		ip_rt_put(rt);
+		return ERR_PTR(-ELOOP);
+	}
+
+	*saddr = fl4.saddr;
+
+	return rt;
 }
 
 static inline void gtp0_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
@@ -435,54 +454,31 @@ static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 	 */
 }
 
-struct gtp_pktinfo {
-	struct sock		*sk;
-	struct iphdr		*iph;
-	struct flowi4		fl4;
-	struct rtable		*rt;
-	struct pdp_ctx		*pctx;
-	struct net_device	*dev;
-	__be16			gtph_port;
-};
-
-static void gtp_push_header(struct sk_buff *skb, struct gtp_pktinfo *pktinfo)
+static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
+						__be16 *port)
 {
-	switch (pktinfo->pctx->gtp_version) {
+	switch (pctx->gtp_version) {
 	case GTP_V0:
-		pktinfo->gtph_port = htons(GTP0_PORT);
-		gtp0_push_header(skb, pktinfo->pctx);
+		*port = htons(GTP0_PORT);
+		gtp0_push_header(skb, pctx);
 		break;
 	case GTP_V1:
-		pktinfo->gtph_port = htons(GTP1U_PORT);
-		gtp1_push_header(skb, pktinfo->pctx);
+		*port = htons(GTP1U_PORT);
+		gtp1_push_header(skb, pctx);
 		break;
 	}
 }
 
-static inline void gtp_set_pktinfo_ipv4(struct gtp_pktinfo *pktinfo,
-					struct sock *sk, struct iphdr *iph,
-					struct pdp_ctx *pctx, struct rtable *rt,
-					struct flowi4 *fl4,
-					struct net_device *dev)
-{
-	pktinfo->sk	= sk;
-	pktinfo->iph	= iph;
-	pktinfo->pctx	= pctx;
-	pktinfo->rt	= rt;
-	pktinfo->fl4	= *fl4;
-	pktinfo->dev	= dev;
-}
-
-static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
-			     struct gtp_pktinfo *pktinfo)
+static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
 	struct pdp_ctx *pctx;
 	struct rtable *rt;
-	struct flowi4 fl4;
+	__be32 saddr;
 	struct iphdr *iph;
-	__be16 df;
-	int mtu;
+	int headroom;
+	__be16 port;
+	int r;
 
 	/* Read the IP destination address and resolve the PDP context.
 	 * Prepend PDP header with TEI/TID from PDP ctx.
@@ -500,102 +496,86 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 	}
 	netdev_dbg(dev, "found PDP context %p\n", pctx);
 
-	rt = ip4_route_output_gtp(&fl4, pctx->sk, pctx->peer_addr_ip4.s_addr);
+	rt = gtp_get_v4_rt(skb, dev, pctx, &saddr);
 	if (IS_ERR(rt)) {
-		netdev_dbg(dev, "no route to SSGN %pI4\n",
-			   &pctx->peer_addr_ip4.s_addr);
-		dev->stats.tx_carrier_errors++;
-		goto err;
+		if (PTR_ERR(rt) == -ENETUNREACH)
+			dev->stats.tx_carrier_errors++;
+		else if (PTR_ERR(rt) == -ELOOP)
+			dev->stats.collisions++;
+		return PTR_ERR(rt);
 	}
 
-	if (rt->dst.dev == dev) {
-		netdev_dbg(dev, "circular route to SSGN %pI4\n",
-			   &pctx->peer_addr_ip4.s_addr);
-		dev->stats.collisions++;
-		goto err_rt;
-	}
+	headroom = sizeof(struct iphdr) + sizeof(struct udphdr);
 
-	/* This is similar to tnl_update_pmtu(). */
-	df = iph->frag_off;
-	if (df) {
-		mtu = dst_mtu(&rt->dst) - dev->hard_header_len -
-			sizeof(struct iphdr) - sizeof(struct udphdr);
-		switch (pctx->gtp_version) {
-		case GTP_V0:
-			mtu -= sizeof(struct gtp0_header);
-			break;
-		case GTP_V1:
-			mtu -= sizeof(struct gtp1_header);
-			break;
-		}
-	} else {
-		mtu = dst_mtu(&rt->dst);
+	switch (pctx->gtp_version) {
+	case GTP_V0:
+		headroom += sizeof(struct gtp0_header);
+		break;
+	case GTP_V1:
+		headroom += sizeof(struct gtp1_header);
+		break;
 	}
 
-	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, false);
+	r = skb_tunnel_check_pmtu(skb, &rt->dst, headroom,
+					netif_is_any_bridge_port(dev));
+	if (r < 0) {
+		ip_rt_put(rt);
+		return r;
+	} else if (r) {
+		netif_rx(skb);
+		ip_rt_put(rt);
+		return -EMSGSIZE;
+	}
 
-	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
-	    mtu < ntohs(iph->tot_len)) {
-		netdev_dbg(dev, "packet too big, fragmentation needed\n");
-		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
-		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-			      htonl(mtu));
+	/* Ensure there is sufficient headroom. */
+	r = skb_cow_head(skb, headroom);
+	if (unlikely(r))
 		goto err_rt;
-	}
 
-	gtp_set_pktinfo_ipv4(pktinfo, pctx->sk, iph, pctx, rt, &fl4, dev);
-	gtp_push_header(skb, pktinfo);
+	skb_reset_inner_headers(skb);
+
+	gtp_push_header(skb, pctx, &port);
+
+	iph = ip_hdr(skb);
+	netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
+		   &iph->saddr, &iph->daddr);
+
+	udp_tunnel_xmit_skb(rt, pctx->sk, skb,
+			    saddr, pctx->peer_addr_ip4.s_addr,
+			    iph->tos,
+			    ip4_dst_hoplimit(&rt->dst),
+			    0,
+			    port, port,
+			    !net_eq(sock_net(pctx->sk),
+				    dev_net(pctx->dev)),
+			    false);
 
 	return 0;
 err_rt:
 	ip_rt_put(rt);
-err:
 	return -EBADMSG;
 }
 
 static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	unsigned int proto = ntohs(skb->protocol);
-	struct gtp_pktinfo pktinfo;
 	int err;
 
-	/* Ensure there is sufficient headroom. */
-	if (skb_cow_head(skb, dev->needed_headroom))
+	if (proto != ETH_P_IP && proto != ETH_P_IPV6) {
+		err = -ENOTSUPP;
 		goto tx_err;
-
-	skb_reset_inner_headers(skb);
+	}
 
 	/* PDP context lookups in gtp_build_skb_*() need rcu read-side lock. */
 	rcu_read_lock();
-	switch (proto) {
-	case ETH_P_IP:
-		err = gtp_build_skb_ip4(skb, dev, &pktinfo);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
+
+	err = gtp_xmit_ip4(skb, dev);
+
 	rcu_read_unlock();
 
 	if (err < 0)
 		goto tx_err;
 
-	switch (proto) {
-	case ETH_P_IP:
-		netdev_dbg(pktinfo.dev, "gtp -> IP src: %pI4 dst: %pI4\n",
-			   &pktinfo.iph->saddr, &pktinfo.iph->daddr);
-		udp_tunnel_xmit_skb(pktinfo.rt, pktinfo.sk, skb,
-				    pktinfo.fl4.saddr, pktinfo.fl4.daddr,
-				    pktinfo.iph->tos,
-				    ip4_dst_hoplimit(&pktinfo.rt->dst),
-				    0,
-				    pktinfo.gtph_port, pktinfo.gtph_port,
-				    !net_eq(sock_net(pktinfo.pctx->sk),
-					    dev_net(dev)),
-				    false);
-		break;
-	}
-
 	return NETDEV_TX_OK;
 tx_err:
 	dev->stats.tx_errors++;
-- 
2.27.0

