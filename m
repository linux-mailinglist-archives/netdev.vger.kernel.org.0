Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E137721CB43
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 22:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgGLUHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 16:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgGLUHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 16:07:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE10C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 13:07:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1juiG1-0002dR-K0; Sun, 12 Jul 2020 22:07:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     aconole@redhat.com, sbrivio@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/3] vxlan: allow to disable path mtu learning on encap socket
Date:   Sun, 12 Jul 2020 22:07:04 +0200
Message-Id: <20200712200705.9796-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200712200705.9796-1-fw@strlen.de>
References: <20200712200705.9796-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While its already possible to configure VXLAN to never set the DF bit
on packets that it sends, it was not yet possible to tell kernel to
not update the encapsulation sockets path MTU.

This can be used to tell ip stack to always use the interface MTU
when VXLAN wants to send a packet.

When packets are routed, VXLAN use skbs existing dst entries to
propagate the MTU update to the overlay, but on a bridge this doesn't
work (no routing, no dst entry, and no ip forwarding takes place, so
nothing emits icmp packet w. mtu update to sender).

This is only useful when VXLAN is used as a bridge port and the
network is known to accept packets up to the link MTU to avoid bogus
pmtu icmp packets from stopping tunneled traffic.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/vxlan.c          | 65 +++++++++++++++++++++++++++++++-----
 include/net/vxlan.h          |  2 ++
 include/uapi/linux/if_link.h |  1 +
 3 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a43c97b13924..ceb2940a2a62 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3316,6 +3316,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
 	[IFLA_VXLAN_REMCSUM_NOPARTIAL]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
+	[IFLA_VXLAN_PMTUDISC]	= { .type = NLA_U8 },
 };
 
 static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -3418,7 +3419,8 @@ static const struct ethtool_ops vxlan_ethtool_ops = {
 };
 
 static struct socket *vxlan_create_sock(struct net *net, bool ipv6,
-					__be16 port, u32 flags, int ifindex)
+					const struct vxlan_config *cfg,
+					int ifindex)
 {
 	struct socket *sock;
 	struct udp_port_cfg udp_conf;
@@ -3429,13 +3431,18 @@ static struct socket *vxlan_create_sock(struct net *net, bool ipv6,
 	if (ipv6) {
 		udp_conf.family = AF_INET6;
 		udp_conf.use_udp6_rx_checksums =
-		    !(flags & VXLAN_F_UDP_ZERO_CSUM6_RX);
+		    !(cfg->flags & VXLAN_F_UDP_ZERO_CSUM6_RX);
 		udp_conf.ipv6_v6only = 1;
 	} else {
 		udp_conf.family = AF_INET;
 	}
 
-	udp_conf.local_udp_port = port;
+	if (cfg->pmtudisc) {
+		udp_conf.ip_pmtudisc = 1;
+		udp_conf.ip_pmtudiscv = cfg->pmtudiscv;
+	}
+
+	udp_conf.local_udp_port = cfg->dst_port;
 	udp_conf.bind_ifindex = ifindex;
 
 	/* Open UDP socket */
@@ -3448,7 +3455,7 @@ static struct socket *vxlan_create_sock(struct net *net, bool ipv6,
 
 /* Create new listen socket if needed */
 static struct vxlan_sock *vxlan_socket_create(struct net *net, bool ipv6,
-					      __be16 port, u32 flags,
+					      const struct vxlan_config *cfg,
 					      int ifindex)
 {
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
@@ -3464,7 +3471,7 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, bool ipv6,
 	for (h = 0; h < VNI_HASH_SIZE; ++h)
 		INIT_HLIST_HEAD(&vs->vni_list[h]);
 
-	sock = vxlan_create_sock(net, ipv6, port, flags, ifindex);
+	sock = vxlan_create_sock(net, ipv6, cfg, ifindex);
 	if (IS_ERR(sock)) {
 		kfree(vs);
 		return ERR_CAST(sock);
@@ -3472,10 +3479,10 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, bool ipv6,
 
 	vs->sock = sock;
 	refcount_set(&vs->refcnt, 1);
-	vs->flags = (flags & VXLAN_F_RCV_FLAGS);
+	vs->flags = (cfg->flags & VXLAN_F_RCV_FLAGS);
 
 	spin_lock(&vn->sock_lock);
-	hlist_add_head_rcu(&vs->hlist, vs_head(net, port));
+	hlist_add_head_rcu(&vs->hlist, vs_head(net, cfg->dst_port));
 	udp_tunnel_notify_add_rx_port(sock,
 				      (vs->flags & VXLAN_F_GPE) ?
 				      UDP_TUNNEL_TYPE_VXLAN_GPE :
@@ -3521,8 +3528,7 @@ static int __vxlan_sock_add(struct vxlan_dev *vxlan, bool ipv6)
 	}
 	if (!vs)
 		vs = vxlan_socket_create(vxlan->net, ipv6,
-					 vxlan->cfg.dst_port, vxlan->cfg.flags,
-					 l3mdev_index);
+					 &vxlan->cfg, l3mdev_index);
 	if (IS_ERR(vs))
 		return PTR_ERR(vs);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -3984,6 +3990,21 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 
 	if (data[IFLA_VXLAN_LINK])
 		conf->remote_ifindex = nla_get_u32(data[IFLA_VXLAN_LINK]);
+	if (data[IFLA_VXLAN_PMTUDISC]) {
+		int pmtuv = nla_get_u8(data[IFLA_VXLAN_PMTUDISC]);
+
+		if (pmtuv < IP_PMTUDISC_DONT) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PMTUDISC], "PMTUDISC Value < 0");
+			return -EOPNOTSUPP;
+		}
+		if (pmtuv > IP_PMTUDISC_OMIT) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PMTUDISC], "PMTUDISC Value > IP_PMTUDISC_OMIT");
+			return -EOPNOTSUPP;
+		}
+
+		conf->pmtudisc = 1;
+		conf->pmtudiscv = pmtuv;
+	}
 
 	if (data[IFLA_VXLAN_TOS])
 		conf->tos  = nla_get_u8(data[IFLA_VXLAN_TOS]);
@@ -4249,6 +4270,27 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	netdev_adjacent_change_commit(dst->remote_dev, lowerdev, dev);
 	if (lowerdev && lowerdev != dst->remote_dev)
 		dst->remote_dev = lowerdev;
+
+	if (conf.pmtudisc && conf.pmtudiscv != vxlan->cfg.pmtudiscv) {
+		struct vxlan_sock *sock4 = rtnl_dereference(vxlan->vn4_sock);
+#if IS_ENABLED(CONFIG_IPV6)
+		struct vxlan_sock *sock6 = rtnl_dereference(vxlan->vn6_sock);
+#endif
+		struct socket *sock;
+
+		if (sock4) {
+			sock = sock4->sock;
+			ip_sock_set_mtu_discover(sock->sk, conf.pmtudiscv);
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		if (sock6) {
+			sock = sock6->sock;
+			ip6_sock_set_mtu_discover(sock->sk, conf.pmtudiscv);
+			ip_sock_set_mtu_discover(sock->sk, conf.pmtudiscv);
+		}
+#endif
+	}
+
 	vxlan_config_apply(dev, &conf, lowerdev, vxlan->net, true);
 	return 0;
 }
@@ -4276,6 +4318,7 @@ static size_t vxlan_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) +	/* IFLA_VXLAN_TTL_INHERIT */
 		nla_total_size(sizeof(__u8)) +	/* IFLA_VXLAN_TOS */
 		nla_total_size(sizeof(__u8)) +	/* IFLA_VXLAN_DF */
+		nla_total_size(sizeof(__u8)) +	/* IFLA_VXLAN_PMTUDISC */
 		nla_total_size(sizeof(__be32)) + /* IFLA_VXLAN_LABEL */
 		nla_total_size(sizeof(__u8)) +	/* IFLA_VXLAN_LEARNING */
 		nla_total_size(sizeof(__u8)) +	/* IFLA_VXLAN_PROXY */
@@ -4374,6 +4417,10 @@ static int vxlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put(skb, IFLA_VXLAN_PORT_RANGE, sizeof(ports), &ports))
 		goto nla_put_failure;
 
+	if (vxlan->cfg.pmtudisc &&
+	    nla_put_u8(skb, IFLA_VXLAN_PMTUDISC, vxlan->cfg.pmtudiscv))
+		goto nla_put_failure;
+
 	if (vxlan->cfg.flags & VXLAN_F_GBP &&
 	    nla_put_flag(skb, IFLA_VXLAN_GBP))
 		goto nla_put_failure;
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 3a41627cbdfe..1414cfa2005f 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -220,6 +220,8 @@ struct vxlan_config {
 	unsigned long		age_interval;
 	unsigned int		addrmax;
 	bool			no_share;
+	u8			pmtudisc:1;
+	u8			pmtudiscv:3;
 	enum ifla_vxlan_df	df;
 };
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index cc185a007ade..f22cf508871c 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -548,6 +548,7 @@ enum {
 	IFLA_VXLAN_GPE,
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
+	IFLA_VXLAN_PMTUDISC,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
-- 
2.26.2

