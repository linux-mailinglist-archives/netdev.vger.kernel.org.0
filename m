Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790BB2B3159
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgKNXKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:10:46 -0500
Received: from smtp.netregistry.net ([202.124.241.204]:39116 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgKNXKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 18:10:45 -0500
Received: from 124-148-94-203.tpgi.com.au ([124.148.94.203]:41326 helo=192-168-1-16.tpgi.com.au)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1ke4go-0006YZ-8X; Sun, 15 Nov 2020 10:10:41 +1100
Date:   Sun, 15 Nov 2020 09:10:36 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Guillaume Nault <gnault@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing
Message-ID: <20201115091036.4970a107@192-168-1-16.tpgi.com.au>
In-Reply-To: <20201113090225.GA25425@linux.home>
References: <20201113120637.39c45f3f@192-168-1-16.tpgi.com.au>
        <20201112193656.73621cd5@hermes.local>
        <20201113090225.GA25425@linux.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[PATCH 2/2] DSCP in IPv4 routing

TOS handling in ipv4 routing does not use all the bits in a DSCP
value.  This change introduces a sysctl "route_tos_as_dscp" control
that, when enabled, widens masks to used the 6 DSCP bits in routing.

This commit converts macros
RT_TOS -> rt_tos
IPTOS_RT_MASK -> iptos_rt_mask

Signed-off-by: Russell Strong <russell@strong.id.au>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  3 +-
 drivers/net/geneve.c                          |  4 +--
 drivers/net/ipvlan/ipvlan_core.c              |  2 +-
 drivers/net/ppp/pptp.c                        |  2 +-
 drivers/net/vrf.c                             |  2 +-
 drivers/net/vxlan.c                           |  4 +--
 include/net/ip.h                              |  3 +-
 include/net/route.h                           |  6 ++--
 net/bridge/br_netfilter_hooks.c               |  2 +-
 net/core/filter.c                             |  4 +--
 net/core/lwt_bpf.c                            |  2 +-
 net/ipv4/fib_frontend.c                       |  2 +-
 net/ipv4/fib_rules.c                          |  2 +-
 net/ipv4/icmp.c                               |  8 ++---
 net/ipv4/ip_gre.c                             |  2 +-
 net/ipv4/ip_output.c                          |  2 +-
 net/ipv4/ip_tunnel.c                          |  6 ++--
 net/ipv4/ipmr.c                               |  6 ++--
 net/ipv4/netfilter.c                          |  2 +-
 net/ipv4/netfilter/ipt_rpfilter.c             |  2 +-
 net/ipv4/netfilter/nf_dup_ipv4.c              |  2 +-
 net/ipv4/route.c                              | 34 +++++++++++--------
 net/ipv6/ip6_output.c                         |  2 +-
 net/ipv6/ip6_tunnel.c                         | 10 +++---
 net/ipv6/sit.c                                |  4 +--
 net/xfrm/xfrm_policy.c                        | 13 ++-----
 26 files changed, 65 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 90930e54b6f2..ebc001e5b890 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -354,6 +354,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
 	struct net_device *out_dev, *route_dev;
+	struct net *net = dev_net(mirred_dev);
 	struct flowi6 fl6 = {};
 	struct ipv6hdr *ip6h;
 	struct neighbour *n = NULL;
@@ -364,7 +365,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 
 	ttl = tun_key->ttl;
 
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	fl6.flowlabel = ip6_make_flowinfo(rt_tos(net, tun_key->tos), tun_key->label);
 	fl6.daddr = tun_key->u.ipv6.dst;
 	fl6.saddr = tun_key->u.ipv6.src;
 
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index a3c8ce6deb93..544a42ba8506 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -797,7 +797,7 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 		tos = ip_tunnel_get_dsfield(ip_hdr(skb), skb);
 		use_cache = false;
 	}
-	fl4->flowi4_tos = RT_TOS(tos);
+	fl4->flowi4_tos = rt_tos(geneve->net, tos);
 
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
@@ -851,7 +851,7 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 		use_cache = false;
 	}
 
-	fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
+	fl6->flowlabel = ip6_make_flowinfo(rt_tos(geneve->net, prio),
 					   info->key.label);
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 8801d093135c..a2cee2633fc1 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -421,7 +421,7 @@ static int ipvlan_process_v4_outbound(struct sk_buff *skb)
 	int err, ret = NET_XMIT_DROP;
 	struct flowi4 fl4 = {
 		.flowi4_oif = dev->ifindex,
-		.flowi4_tos = RT_TOS(ip4h->tos),
+		.flowi4_tos = rt_tos(net, ip4h->tos),
 		.flowi4_flags = FLOWI_FLAG_ANYSRC,
 		.flowi4_mark = skb->mark,
 		.daddr = ip4h->daddr,
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index ee5058445d06..c2c4a242e163 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -155,7 +155,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0, IPPROTO_GRE,
-				   RT_TOS(0), sk->sk_bound_dev_if);
+				   rt_tos(net, 0), sk->sk_bound_dev_if);
 	if (IS_ERR(rt))
 		goto tx_error;
 
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index f2793ffde191..c477c3e165a1 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -534,7 +534,7 @@ static netdev_tx_t vrf_process_v4_outbound(struct sk_buff *skb,
 	/* needed to match OIF rule */
 	fl4.flowi4_oif = vrf_dev->ifindex;
 	fl4.flowi4_iif = LOOPBACK_IFINDEX;
-	fl4.flowi4_tos = RT_TOS(ip4h->tos);
+	fl4.flowi4_tos = rt_tos(net, ip4h->tos);
 	fl4.flowi4_flags = FLOWI_FLAG_ANYSRC | FLOWI_FLAG_SKIP_NH_OIF;
 	fl4.flowi4_proto = ip4h->protocol;
 	fl4.daddr = ip4h->daddr;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 236fcc55a5fd..533e7ef087a6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2412,7 +2412,7 @@ static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device
 
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.flowi4_oif = oif;
-	fl4.flowi4_tos = RT_TOS(tos);
+	fl4.flowi4_tos = rt_tos(vxlan->net, tos);
 	fl4.flowi4_mark = skb->mark;
 	fl4.flowi4_proto = IPPROTO_UDP;
 	fl4.daddr = daddr;
@@ -2469,7 +2469,7 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 	fl6.flowi6_oif = oif;
 	fl6.daddr = *daddr;
 	fl6.saddr = *saddr;
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tos), label);
+	fl6.flowlabel = ip6_make_flowinfo(rt_tos(vxlan->net, tos), label);
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = IPPROTO_UDP;
 	fl6.fl6_dport = dport;
diff --git a/include/net/ip.h b/include/net/ip.h
index e20874059f82..11482f265b31 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -241,7 +241,8 @@ static inline struct sk_buff *ip_finish_skb(struct sock *sk, struct flowi4 *fl4)
 
 static inline __u8 get_rttos(struct ipcm_cookie* ipc, struct inet_sock *inet)
 {
-	return (ipc->tos != -1) ? RT_TOS(ipc->tos) : RT_TOS(inet->tos);
+	struct net *net = sock_net(&inet->sk);
+	return (ipc->tos != -1) ? rt_tos(net, ipc->tos) : rt_tos(net, inet->tos);
 }
 
 static inline __u8 get_rtconn_flags(struct ipcm_cookie* ipc, struct sock* sk)
diff --git a/include/net/route.h b/include/net/route.h
index 0cc8ce316940..705137be768b 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -56,8 +56,8 @@ static inline u8 rt_tos(const struct net *net, u8 tos)
 
 #define RTO_ONLINK	0x01
 
-#define RT_CONN_FLAGS(sk)   (RT_TOS(inet_sk(sk)->tos) | sock_flag(sk, SOCK_LOCALROUTE))
-#define RT_CONN_FLAGS_TOS(sk,tos)   (RT_TOS(tos) | sock_flag(sk, SOCK_LOCALROUTE))
+#define RT_CONN_FLAGS(sk)   (rt_tos(sock_net(sk), inet_sk(sk)->tos) | sock_flag(sk, SOCK_LOCALROUTE))
+#define RT_CONN_FLAGS_TOS(sk,tos)   (rt_tos(sock_net(sk), tos) | sock_flag(sk, SOCK_LOCALROUTE))
 
 struct fib_nh;
 struct fib_info;
@@ -271,8 +271,6 @@ static inline void ip_rt_put(struct rtable *rt)
 	dst_release(&rt->dst);
 }
 
-#define IPTOS_RT_MASK	(IPTOS_TOS_MASK & ~3)
-
 extern const __u8 ip_tos2prio[16];
 
 static inline char rt_tos2priority(u8 tos)
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 04c3f9a82650..2e7de791936c 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -379,7 +379,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				goto free_skb;
 
 			rt = ip_route_output(net, iph->daddr, 0,
-					     RT_TOS(iph->tos), 0);
+					     rt_tos(net, iph->tos), 0);
 			if (!IS_ERR(rt)) {
 				/* - Bridged-and-DNAT'ed traffic doesn't
 				 *   require ip_forwarding. */
diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..94cb0a4ee9b3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2345,7 +2345,7 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 		struct flowi4 fl4 = {
 			.flowi4_flags = FLOWI_FLAG_ANYSRC,
 			.flowi4_mark  = skb->mark,
-			.flowi4_tos   = RT_TOS(ip4h->tos),
+			.flowi4_tos   = rt_tos(net, ip4h->tos),
 			.flowi4_oif   = dev->ifindex,
 			.flowi4_proto = ip4h->protocol,
 			.daddr	      = ip4h->daddr,
@@ -5309,7 +5309,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		fl4.flowi4_iif = params->ifindex;
 		fl4.flowi4_oif = 0;
 	}
-	fl4.flowi4_tos = params->tos & IPTOS_RT_MASK;
+	fl4.flowi4_tos = params->tos & iptos_rt_mask(net);
 	fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
 	fl4.flowi4_flags = 0;
 
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 7d3438215f32..81f673111423 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -206,7 +206,7 @@ static int bpf_lwt_xmit_reroute(struct sk_buff *skb)
 		fl4.flowi4_oif = oif;
 		fl4.flowi4_mark = skb->mark;
 		fl4.flowi4_uid = sock_net_uid(net, sk);
-		fl4.flowi4_tos = RT_TOS(iph->tos);
+		fl4.flowi4_tos = rt_tos(net, iph->tos);
 		fl4.flowi4_flags = FLOWI_FLAG_ANYSRC;
 		fl4.flowi4_proto = iph->protocol;
 		fl4.daddr = iph->daddr;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 86a23e4a6a50..6a3b6036d8e6 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -292,7 +292,7 @@ __be32 fib_compute_spec_dst(struct sk_buff *skb)
 			.flowi4_iif = LOOPBACK_IFINDEX,
 			.flowi4_oif = l3mdev_master_ifindex_rcu(dev),
 			.daddr = ip_hdr(skb)->saddr,
-			.flowi4_tos = RT_TOS(ip_hdr(skb)->tos),
+			.flowi4_tos = rt_tos(net, ip_hdr(skb)->tos),
 			.flowi4_scope = scope,
 			.flowi4_mark = vmark ? skb->mark : 0,
 		};
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index ce54a30c2ef1..6f82604d3715 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -229,7 +229,7 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	int err = -EINVAL;
 	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
 
-	if (frh->tos & ~IPTOS_TOS_MASK) {
+	if (frh->tos & ~iptos_rt_mask(net)) {
 		NL_SET_ERR_MSG(extack, "Invalid tos");
 		goto errout;
 	}
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 005faea415a4..5433455596d2 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -444,7 +444,7 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 	fl4.saddr = saddr;
 	fl4.flowi4_mark = mark;
 	fl4.flowi4_uid = sock_net_uid(net, NULL);
-	fl4.flowi4_tos = RT_TOS(ip_hdr(skb)->tos);
+	fl4.flowi4_tos = rt_tos(net, ip_hdr(skb)->tos);
 	fl4.flowi4_proto = IPPROTO_ICMP;
 	fl4.flowi4_oif = l3mdev_master_ifindex(skb->dev);
 	security_skb_classify_flow(skb, flowi4_to_flowi(&fl4));
@@ -496,7 +496,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	fl4->saddr = saddr;
 	fl4->flowi4_mark = mark;
 	fl4->flowi4_uid = sock_net_uid(net, NULL);
-	fl4->flowi4_tos = RT_TOS(tos);
+	fl4->flowi4_tos = rt_tos(net, tos);
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
@@ -544,7 +544,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 		orefdst = skb_in->_skb_refdst; /* save old refdst */
 		skb_dst_set(skb_in, NULL);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
-				     RT_TOS(tos), rt2->dst.dev);
+				     rt_tos(net, tos), rt2->dst.dev);
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
@@ -712,7 +712,7 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		rcu_read_unlock();
 	}
 
-	tos = icmp_pointers[type].error ? (RT_TOS(iph->tos) |
+	tos = icmp_pointers[type].error ? (rt_tos(net, iph->tos) |
 					   IPTOS_PREC_INTERNETCONTROL) :
 					   iph->tos;
 	mark = IP4_REPLY_MARK(net, skb_in->mark);
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index a68bf4c6fe9b..17042cf9750d 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -882,7 +882,7 @@ static int ipgre_open(struct net_device *dev)
 					 t->parms.iph.daddr,
 					 t->parms.iph.saddr,
 					 t->parms.o_key,
-					 RT_TOS(t->parms.iph.tos),
+					 rt_tos(t->net, t->parms.iph.tos),
 					 t->parms.link);
 		if (IS_ERR(rt))
 			return -EADDRNOTAVAIL;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 879b76ae4435..b564bf9a908b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1694,7 +1694,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 
 	flowi4_init_output(&fl4, oif,
 			   IP4_REPLY_MARK(net, skb->mark) ?: sk->sk_mark,
-			   RT_TOS(arg->tos),
+			   rt_tos(net, arg->tos),
 			   RT_SCOPE_UNIVERSE, ip_hdr(skb)->protocol,
 			   ip_reply_arg_flowi_flags(arg),
 			   daddr, saddr,
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index ee65c9225178..b2c01ba8476a 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -294,7 +294,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 
 		ip_tunnel_init_flow(&fl4, iph->protocol, iph->daddr,
 				    iph->saddr, tunnel->parms.o_key,
-				    RT_TOS(iph->tos), tunnel->parms.link,
+				    rt_tos(tunnel->net, iph->tos), tunnel->parms.link,
 				    tunnel->fwmark, 0);
 		rt = ip_route_output_key(tunnel->net, &fl4);
 
@@ -565,7 +565,7 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			tos = ipv6_get_dsfield((const struct ipv6hdr *)inner_iph);
 	}
 	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src,
-			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
+			    tunnel_id_to_key32(key->tun_id), rt_tos(tunnel->net, tos),
 			    0, skb->mark, skb_get_hash(skb));
 	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
 		goto tx_error;
@@ -722,7 +722,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	ip_tunnel_init_flow(&fl4, protocol, dst, tnl_params->saddr,
-			    tunnel->parms.o_key, RT_TOS(tos), tunnel->parms.link,
+			    tunnel->parms.o_key, rt_tos(tunnel->net, tos), tunnel->parms.link,
 			    tunnel->fwmark, skb_get_hash(skb));
 
 	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0)
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 939792a38814..142124fb85c5 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1840,7 +1840,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 					   vif->remote, vif->local,
 					   0, 0,
 					   IPPROTO_IPIP,
-					   RT_TOS(iph->tos), vif->link);
+					   rt_tos(net, iph->tos), vif->link);
 		if (IS_ERR(rt))
 			goto out_free;
 		encap = sizeof(struct iphdr);
@@ -1848,7 +1848,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 		rt = ip_route_output_ports(net, &fl4, NULL, iph->daddr, 0,
 					   0, 0,
 					   IPPROTO_IPIP,
-					   RT_TOS(iph->tos), vif->link);
+					   rt_tos(net, iph->tos), vif->link);
 		if (IS_ERR(rt))
 			goto out_free;
 	}
@@ -2048,7 +2048,7 @@ static struct mr_table *ipmr_rt_fib_lookup(struct net *net, struct sk_buff *skb)
 	struct flowi4 fl4 = {
 		.daddr = iph->daddr,
 		.saddr = iph->saddr,
-		.flowi4_tos = RT_TOS(iph->tos),
+		.flowi4_tos = rt_tos(net, iph->tos),
 		.flowi4_oif = (rt_is_output_route(rt) ?
 			       skb->dev->ifindex : 0),
 		.flowi4_iif = (rt_is_output_route(rt) ?
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 7c841037c533..acb8fc28f27a 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -42,7 +42,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	 */
 	fl4.daddr = iph->daddr;
 	fl4.saddr = saddr;
-	fl4.flowi4_tos = RT_TOS(iph->tos);
+	fl4.flowi4_tos = rt_tos(net, iph->tos);
 	fl4.flowi4_oif = sk ? sk->sk_bound_dev_if : 0;
 	if (!fl4.flowi4_oif)
 		fl4.flowi4_oif = l3mdev_master_ifindex(dev);
diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index cc23f1ce239c..e7b793919c63 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -76,7 +76,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.daddr = iph->saddr;
 	flow.saddr = rpfilter_get_saddr(iph->daddr);
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
-	flow.flowi4_tos = RT_TOS(iph->tos);
+	flow.flowi4_tos = rt_tos(xt_net(par), iph->tos);
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
 	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
 
diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index 6cc5743c553a..8b8c685f6436 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -32,7 +32,7 @@ static bool nf_dup_ipv4_route(struct net *net, struct sk_buff *skb,
 		fl4.flowi4_oif = oif;
 
 	fl4.daddr = gw->s_addr;
-	fl4.flowi4_tos = RT_TOS(iph->tos);
+	fl4.flowi4_tos = rt_tos(net, iph->tos);
 	fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
 	fl4.flowi4_flags = FLOWI_FLAG_KNOWN_NH;
 	rt = ip_route_output_key(net, &fl4);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a3b60c41cbad..b27a7abda30a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -112,9 +112,6 @@
 
 #include "fib_lookup.h"
 
-#define RT_FL_TOS(oldflp4) \
-	((oldflp4)->flowi4_tos & (IPTOS_RT_MASK | RTO_ONLINK))
-
 #define RT_GC_TIMEOUT (300*HZ)
 
 static int ip_rt_max_size;
@@ -549,7 +546,7 @@ static void build_skb_flow_key(struct flowi4 *fl4, const struct sk_buff *skb,
 	const struct net *net = dev_net(skb->dev);
 	const struct iphdr *iph = ip_hdr(skb);
 	int oif = skb->dev->ifindex;
-	u8 tos = RT_TOS(iph->tos);
+	u8 tos = rt_tos(net, iph->tos);
 	u8 prot = iph->protocol;
 	u32 mark = skb->mark;
 
@@ -825,7 +822,7 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 	const struct iphdr *iph = (const struct iphdr *) skb->data;
 	struct net *net = dev_net(skb->dev);
 	int oif = skb->dev->ifindex;
-	u8 tos = RT_TOS(iph->tos);
+	u8 tos = rt_tos(net, iph->tos);
 	u8 prot = iph->protocol;
 	u32 mark = skb->mark;
 
@@ -1073,7 +1070,7 @@ void ipv4_update_pmtu(struct sk_buff *skb, struct net *net, u32 mtu,
 	u32 mark = IP4_REPLY_MARK(net, skb->mark);
 
 	__build_flow_key(net, &fl4, NULL, iph, oif,
-			 RT_TOS(iph->tos), protocol, mark, 0);
+			 rt_tos(net, iph->tos), protocol, mark, 0);
 	rt = __ip_route_output_key(net, &fl4);
 	if (!IS_ERR(rt)) {
 		__ip_rt_update_pmtu(rt, &fl4, mtu);
@@ -1162,7 +1159,7 @@ void ipv4_redirect(struct sk_buff *skb, struct net *net,
 	struct rtable *rt;
 
 	__build_flow_key(net, &fl4, NULL, iph, oif,
-			 RT_TOS(iph->tos), protocol, 0, 0);
+			 rt_tos(net, iph->tos), protocol, 0, 0);
 	rt = __ip_route_output_key(net, &fl4);
 	if (!IS_ERR(rt)) {
 		__ip_do_redirect(rt, skb, &fl4, false);
@@ -1271,18 +1268,23 @@ void ip_rt_get_source(u8 *addr, struct sk_buff *skb, struct rtable *rt)
 	else {
 		struct fib_result res;
 		struct iphdr *iph = ip_hdr(skb);
+		struct net *net;
+
 		struct flowi4 fl4 = {
 			.daddr = iph->daddr,
 			.saddr = iph->saddr,
-			.flowi4_tos = RT_TOS(iph->tos),
 			.flowi4_oif = rt->dst.dev->ifindex,
 			.flowi4_iif = skb->dev->ifindex,
 			.flowi4_mark = skb->mark,
 		};
 
 		rcu_read_lock();
-		if (fib_lookup(dev_net(rt->dst.dev), &fl4, &res, 0) == 0)
-			src = fib_result_prefsrc(dev_net(rt->dst.dev), &res);
+
+		net = dev_net(rt->dst.dev);
+		fl4.flowi4_tos = rt_tos(net, iph->tos);
+
+		if (fib_lookup(net, &fl4, &res, 0) == 0)
+			src = fib_result_prefsrc(net, &res);
 		else
 			src = inet_select_addr(rt->dst.dev,
 					       rt_nexthop(rt, iph->daddr),
@@ -2055,7 +2057,7 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (rt->rt_type != RTN_LOCAL)
 		goto skip_validate_source;
 
-	tos &= IPTOS_RT_MASK;
+	tos &= iptos_rt_mask(net);
 	err = fib_validate_source(skb, saddr, daddr, tos, 0, dev, in_dev, &tag);
 	if (err < 0)
 		goto martian_source;
@@ -2297,8 +2299,9 @@ int ip_route_input_noref(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 {
 	struct fib_result res;
 	int err;
+	struct net *net = dev_net(dev);
 
-	tos &= IPTOS_RT_MASK;
+	tos &= iptos_rt_mask(net);
 	rcu_read_lock();
 	err = ip_route_input_rcu(skb, daddr, saddr, tos, dev, &res);
 	rcu_read_unlock();
@@ -2489,7 +2492,8 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
 					const struct sk_buff *skb)
 {
-	__u8 tos = RT_FL_TOS(fl4);
+	__u8 tos = fl4->flowi4_tos & (iptos_rt_mask(net) | RTO_ONLINK);
+
 	struct fib_result res = {
 		.type		= RTN_UNSPEC,
 		.fi		= NULL,
@@ -2499,7 +2503,7 @@ struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
 	struct rtable *rth;
 
 	fl4->flowi4_iif = LOOPBACK_IFINDEX;
-	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
+	fl4->flowi4_tos = tos & iptos_rt_mask(net);
 	fl4->flowi4_scope = ((tos & RTO_ONLINK) ?
 			 RT_SCOPE_LINK : RT_SCOPE_UNIVERSE);
 
@@ -2808,7 +2812,7 @@ struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
 	fl4.daddr = info->key.u.ipv4.dst;
 	fl4.saddr = info->key.u.ipv4.src;
 	tos = info->key.tos;
-	fl4.flowi4_tos = RT_TOS(tos);
+	fl4.flowi4_tos = rt_tos(net, tos);
 
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt)) {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 749ad72386b2..6880b7ef2730 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1243,7 +1243,7 @@ struct dst_entry *ip6_dst_lookup_tunnel(struct sk_buff *skb,
 	fl6.daddr = info->key.u.ipv6.dst;
 	fl6.saddr = info->key.u.ipv6.src;
 	prio = info->key.tos;
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(prio),
+	fl6.flowlabel = ip6_make_flowinfo(rt_tos(net, prio),
 					  info->key.label);
 
 	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sock->sk, &fl6,
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a7950baa05e5..65d51b3be259 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -571,6 +571,7 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	u8 rel_code = code;
 	struct rtable *rt;
 	struct flowi4 fl4;
+	struct net *net;
 
 	err = ip6_tnl_err(skb, IPPROTO_IPIP, opt, &rel_type, &rel_code,
 			  &rel_msg, &rel_info, offset);
@@ -611,8 +612,9 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	eiph = ip_hdr(skb2);
 
 	/* Try to guess incoming interface */
-	rt = ip_route_output_ports(dev_net(skb->dev), &fl4, NULL, eiph->saddr,
-				   0, 0, 0, IPPROTO_IPIP, RT_TOS(eiph->tos), 0);
+	net = dev_net(skb->dev);
+	rt = ip_route_output_ports(net, &fl4, NULL, eiph->saddr,
+				   0, 0, 0, IPPROTO_IPIP, rt_tos(net, eiph->tos), 0);
 	if (IS_ERR(rt))
 		goto out;
 
@@ -621,9 +623,9 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	/* route "incoming" packet */
 	if (rt->rt_flags & RTCF_LOCAL) {
-		rt = ip_route_output_ports(dev_net(skb->dev), &fl4, NULL,
+		rt = ip_route_output_ports(net, &fl4, NULL,
 					   eiph->daddr, eiph->saddr, 0, 0,
-					   IPPROTO_IPIP, RT_TOS(eiph->tos), 0);
+					   IPPROTO_IPIP, rt_tos(net, eiph->tos), 0);
 		if (IS_ERR(rt) || rt->dst.dev->type != ARPHRD_TUNNEL6) {
 			if (!IS_ERR(rt))
 				ip_rt_put(rt);
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 2da0ee703779..a4158c92e68a 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -937,7 +937,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	flowi4_init_output(&fl4, tunnel->parms.link, tunnel->fwmark,
-			   RT_TOS(tos), RT_SCOPE_UNIVERSE, IPPROTO_IPV6,
+			   rt_tos(tunnel->net, tos), RT_SCOPE_UNIVERSE, IPPROTO_IPV6,
 			   0, dst, tiph->saddr, 0, 0,
 			   sock_net_uid(tunnel->net, NULL));
 
@@ -1112,7 +1112,7 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 							  iph->daddr, iph->saddr,
 							  0, 0,
 							  IPPROTO_IPV6,
-							  RT_TOS(iph->tos),
+							  rt_tos(tunnel->net, iph->tos),
 							  tunnel->parms.link);
 
 		if (!IS_ERR(rt)) {
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d622c2548d22..1a7a77be3cf0 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2447,14 +2447,6 @@ xfrm_tmpl_resolve(struct xfrm_policy **pols, int npols, const struct flowi *fl,
 
 }
 
-static int xfrm_get_tos(const struct flowi *fl, int family)
-{
-	if (family == AF_INET)
-		return IPTOS_RT_MASK & fl->u.ip4.flowi4_tos;
-
-	return 0;
-}
-
 static inline struct xfrm_dst *xfrm_alloc_dst(struct net *net, int family)
 {
 	const struct xfrm_policy_afinfo *afinfo = xfrm_policy_get_afinfo(family);
@@ -2541,13 +2533,14 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 	int header_len = 0;
 	int nfheader_len = 0;
 	int trailer_len = 0;
-	int tos;
+	int tos = 0;
 	int family = policy->selector.family;
 	xfrm_address_t saddr, daddr;
 
 	xfrm_flowi_addr_get(fl, &saddr, &daddr, family);
 
-	tos = xfrm_get_tos(fl, family);
+	if (family == AF_INET)
+		tos = iptos_rt_mask(net) & fl->u.ip4.flowi4_tos;
 
 	dst_hold(dst);
 
-- 
2.26.2


