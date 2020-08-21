Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3424CD78
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 07:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgHUF4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 01:56:54 -0400
Received: from foss.arm.com ([217.140.110.172]:54404 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgHUF4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 01:56:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B53D31B;
        Thu, 20 Aug 2020 22:56:52 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.210.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C76BF3F6CF;
        Thu, 20 Aug 2020 22:56:50 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, Jianlin.Lv@arm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: remove redundant variable in vxlan_xmit_one
Date:   Fri, 21 Aug 2020 13:56:36 +0800
Message-Id: <20200821055636.59937-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dst/src is used multiple times in vxlan_xmit_one function as the variable
name, although its scope is different, but it reduces the readability and
it is unnecessary to use intermediate variables here;
This patch reduces unnecessary assignments and removes redundant variables

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 drivers/net/vxlan.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index b9fefe27e3e8..679260e1d9f1 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2597,7 +2597,6 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	struct ip_tunnel_info *info;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	const struct iphdr *old_iph = ip_hdr(skb);
-	union vxlan_addr *dst;
 	union vxlan_addr remote_ip, local_ip;
 	struct vxlan_metadata _md;
 	struct vxlan_metadata *md = &_md;
@@ -2614,8 +2613,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	info = skb_tunnel_info(skb);
 
 	if (rdst) {
-		dst = &rdst->remote_ip;
-		if (vxlan_addr_any(dst)) {
+		remote_ip = rdst->remote_ip;
+		if (vxlan_addr_any(&remote_ip)) {
 			if (did_rsc) {
 				/* short-circuited back to local bridge */
 				vxlan_encap_bypass(skb, vxlan, vxlan,
@@ -2635,7 +2634,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			ttl = ip_tunnel_get_ttl(old_iph, skb);
 		} else {
 			ttl = vxlan->cfg.ttl;
-			if (!ttl && vxlan_addr_multicast(dst))
+			if (!ttl && vxlan_addr_multicast(&remote_ip))
 				ttl = 1;
 		}
 
@@ -2643,7 +2642,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		if (tos == 1)
 			tos = ip_tunnel_get_dsfield(old_iph, skb);
 
-		if (dst->sa.sa_family == AF_INET)
+		if (remote_ip.sa.sa_family == AF_INET)
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM_TX);
 		else
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
@@ -2662,7 +2661,6 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			remote_ip.sin6.sin6_addr = info->key.u.ipv6.dst;
 			local_ip.sin6.sin6_addr = info->key.u.ipv6.src;
 		}
-		dst = &remote_ip;
 		dst_port = info->key.tp_dst ? : vxlan->cfg.dst_port;
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
@@ -2681,7 +2679,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				     vxlan->cfg.port_max, true);
 
 	rcu_read_lock();
-	if (dst->sa.sa_family == AF_INET) {
+	if (remote_ip.sa.sa_family == AF_INET) {
 		struct vxlan_sock *sock4 = rcu_dereference(vxlan->vn4_sock);
 		struct rtable *rt;
 		__be16 df = 0;
@@ -2690,7 +2688,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			ifindex = sock4->sock->sk->sk_bound_dev_if;
 
 		rt = vxlan_get_route(vxlan, dev, sock4, skb, ifindex, tos,
-				     dst->sin.sin_addr.s_addr,
+				     remote_ip.sin.sin_addr.s_addr,
 				     &local_ip.sin.sin_addr.s_addr,
 				     dst_port, src_port,
 				     dst_cache, info);
@@ -2701,7 +2699,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		if (!info) {
 			/* Bypass encapsulation if the destination is local */
-			err = encap_bypass_if_local(skb, dev, vxlan, dst,
+			err = encap_bypass_if_local(skb, dev, vxlan, &remote_ip,
 						    dst_port, ifindex, vni,
 						    &rt->dst, rt->rt_flags);
 			if (err)
@@ -2728,12 +2726,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 		} else if (err) {
 			if (info) {
-				struct in_addr src, dst;
-
-				src = remote_ip.sin.sin_addr;
-				dst = local_ip.sin.sin_addr;
-				info->key.u.ipv4.src = src.s_addr;
-				info->key.u.ipv4.dst = dst.s_addr;
+				info->key.u.ipv4.src = remote_ip.sin.sin_addr.s_addr;
+				info->key.u.ipv4.dst = local_ip.sin.sin_addr.s_addr;
 			}
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
 			dst_release(ndst);
@@ -2748,7 +2742,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 
 		udp_tunnel_xmit_skb(rt, sock4->sock->sk, skb, local_ip.sin.sin_addr.s_addr,
-				    dst->sin.sin_addr.s_addr, tos, ttl, df,
+				    remote_ip.sin.sin_addr.s_addr, tos, ttl, df,
 				    src_port, dst_port, xnet, !udp_sum);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
@@ -2758,7 +2752,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			ifindex = sock6->sock->sk->sk_bound_dev_if;
 
 		ndst = vxlan6_get_route(vxlan, dev, sock6, skb, ifindex, tos,
-					label, &dst->sin6.sin6_addr,
+					label, &remote_ip.sin6.sin6_addr,
 					&local_ip.sin6.sin6_addr,
 					dst_port, src_port,
 					dst_cache, info);
@@ -2771,7 +2765,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		if (!info) {
 			u32 rt6i_flags = ((struct rt6_info *)ndst)->rt6i_flags;
 
-			err = encap_bypass_if_local(skb, dev, vxlan, dst,
+			err = encap_bypass_if_local(skb, dev, vxlan, &remote_ip,
 						    dst_port, ifindex, vni,
 						    ndst, rt6i_flags);
 			if (err)
@@ -2784,12 +2778,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 		} else if (err) {
 			if (info) {
-				struct in6_addr src, dst;
-
-				src = remote_ip.sin6.sin6_addr;
-				dst = local_ip.sin6.sin6_addr;
-				info->key.u.ipv6.src = src;
-				info->key.u.ipv6.dst = dst;
+				info->key.u.ipv6.src = remote_ip.sin6.sin6_addr;
+				info->key.u.ipv6.dst = local_ip.sin6.sin6_addr;
 			}
 
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
@@ -2807,7 +2797,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		udp_tunnel6_xmit_skb(ndst, sock6->sock->sk, skb, dev,
 				     &local_ip.sin6.sin6_addr,
-				     &dst->sin6.sin6_addr, tos, ttl,
+				     &remote_ip.sin6.sin6_addr, tos, ttl,
 				     label, src_port, dst_port, !udp_sum);
 #endif
 	}
-- 
2.17.1

