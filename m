Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EE6310515
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhBEGpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:45:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231200AbhBEGp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:45:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E98FF64FC1;
        Fri,  5 Feb 2021 06:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507449;
        bh=AMzy+eX/J260Hh/2GMkoYTBomukZe+QX5VCT9F+zTH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxSi/xv+RJHVc9bw/i6uI5/jMn4y2l+5ONmvbtPkDfZimMtOy15DKfFYQoCCWktlG
         5xB3J10HAK3Sy2eXh/Wo8SuXxwUMyWADbHxPyXf1cufQI2EbSbpRB3lNMPnhHqF0lL
         QVEYHXgJA9cnqIf//l9YuKznEyl46vP2fSbhXFW/4rKCJtnFAAPr8x/vQswxDR0+j9
         2ESzEv+0gwjTo88Wu40E727Lq45Xk0v0d8qxZhj7beiDbTloL/ZeCLYVtQNQMQj+FP
         pyDccUypXUBmQmQIGrFHFmkfF8Z4Qv0N7U6PHpeoH2sFHBQXkH52fm9cfT4B4/rOtI
         FdnXXWetFWTCQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/17] net/mlx5e: Refactor tun routing helpers
Date:   Thu,  4 Feb 2021 22:40:40 -0800
Message-Id: <20210205064051.89592-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205064051.89592-1-saeed@kernel.org>
References: <20210205064051.89592-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Refactor tun routing helpers to use dedicated struct
mlx5e_tc_tun_route_attr instead of multiple output arguments. This
simplifies the callers (no need to keep track of bunch of output param
pointers) and allows to unify struct release code in new
mlx5e_tc_tun_route_attr_cleanup() helper instead of requiring callers to
manually release some of the output parameters that require it.

Simplify code by unifying error handling at the end of the function and
rearranging code. Remove redundant empty line.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 235 ++++++++++--------
 1 file changed, 126 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 90930e54b6f2..3e18ca200c86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -10,6 +10,27 @@
 #include "rep/tc.h"
 #include "rep/neigh.h"
 
+struct mlx5e_tc_tun_route_attr {
+	struct net_device *out_dev;
+	struct net_device *route_dev;
+	union {
+		struct flowi4 fl4;
+		struct flowi6 fl6;
+	} fl;
+	struct neighbour *n;
+	u8 ttl;
+};
+
+#define TC_TUN_ROUTE_ATTR_INIT(name) struct mlx5e_tc_tun_route_attr name = {}
+
+static void mlx5e_tc_tun_route_attr_cleanup(struct mlx5e_tc_tun_route_attr *attr)
+{
+	if (attr->n)
+		neigh_release(attr->n);
+	if (attr->route_dev)
+		dev_put(attr->route_dev);
+}
+
 struct mlx5e_tc_tunnel *mlx5e_get_tc_tun(struct net_device *tunnel_dev)
 {
 	if (netif_is_vxlan(tunnel_dev))
@@ -79,12 +100,10 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 
 static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
 				       struct net_device *mirred_dev,
-				       struct net_device **out_dev,
-				       struct net_device **route_dev,
-				       struct flowi4 *fl4,
-				       struct neighbour **out_n,
-				       u8 *out_ttl)
+				       struct mlx5e_tc_tun_route_attr *attr)
 {
+	struct net_device *route_dev;
+	struct net_device *out_dev;
 	struct neighbour *n;
 	struct rtable *rt;
 
@@ -97,46 +116,50 @@ static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
 		struct mlx5_eswitch *esw = mdev->priv.eswitch;
 
 		uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
-		fl4->flowi4_oif = uplink_dev->ifindex;
+		attr->fl.fl4.flowi4_oif = uplink_dev->ifindex;
 	}
 
-	rt = ip_route_output_key(dev_net(mirred_dev), fl4);
+	rt = ip_route_output_key(dev_net(mirred_dev), &attr->fl.fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
 	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family != AF_INET) {
-		ip_rt_put(rt);
-		return -ENETUNREACH;
+		ret = -ENETUNREACH;
+		goto err_rt_release;
 	}
 #else
 	return -EOPNOTSUPP;
 #endif
 
-	ret = get_route_and_out_devs(priv, rt->dst.dev, route_dev, out_dev);
-	if (ret < 0) {
-		ip_rt_put(rt);
-		return ret;
-	}
-	dev_hold(*route_dev);
+	ret = get_route_and_out_devs(priv, rt->dst.dev, &route_dev, &out_dev);
+	if (ret < 0)
+		goto err_rt_release;
+	dev_hold(route_dev);
 
-	if (!(*out_ttl))
-		*out_ttl = ip4_dst_hoplimit(&rt->dst);
-	n = dst_neigh_lookup(&rt->dst, &fl4->daddr);
-	ip_rt_put(rt);
+	if (!attr->ttl)
+		attr->ttl = ip4_dst_hoplimit(&rt->dst);
+	n = dst_neigh_lookup(&rt->dst, &attr->fl.fl4.daddr);
 	if (!n) {
-		dev_put(*route_dev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_dev_release;
 	}
 
-	*out_n = n;
+	ip_rt_put(rt);
+	attr->route_dev = route_dev;
+	attr->out_dev = out_dev;
+	attr->n = n;
 	return 0;
+
+err_dev_release:
+	dev_put(route_dev);
+err_rt_release:
+	ip_rt_put(rt);
+	return ret;
 }
 
-static void mlx5e_route_lookup_ipv4_put(struct net_device *route_dev,
-					struct neighbour *n)
+static void mlx5e_route_lookup_ipv4_put(struct mlx5e_tc_tun_route_attr *attr)
 {
-	neigh_release(n);
-	dev_put(route_dev);
+	mlx5e_tc_tun_route_attr_cleanup(attr);
 }
 
 static const char *mlx5e_netdev_kind(struct net_device *dev)
@@ -188,28 +211,25 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 {
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
-	struct net_device *out_dev, *route_dev;
-	struct flowi4 fl4 = {};
-	struct neighbour *n;
+	TC_TUN_ROUTE_ATTR_INIT(attr);
 	int ipv4_encap_size;
 	char *encap_header;
-	u8 nud_state, ttl;
 	struct iphdr *ip;
+	u8 nud_state;
 	int err;
 
 	/* add the IP fields */
-	fl4.flowi4_tos = tun_key->tos;
-	fl4.daddr = tun_key->u.ipv4.dst;
-	fl4.saddr = tun_key->u.ipv4.src;
-	ttl = tun_key->ttl;
+	attr.fl.fl4.flowi4_tos = tun_key->tos;
+	attr.fl.fl4.daddr = tun_key->u.ipv4.dst;
+	attr.fl.fl4.saddr = tun_key->u.ipv4.src;
+	attr.ttl = tun_key->ttl;
 
-	err = mlx5e_route_lookup_ipv4_get(priv, mirred_dev, &out_dev, &route_dev,
-					  &fl4, &n, &ttl);
+	err = mlx5e_route_lookup_ipv4_get(priv, mirred_dev, &attr);
 	if (err)
 		return err;
 
 	ipv4_encap_size =
-		(is_vlan_dev(route_dev) ? VLAN_ETH_HLEN : ETH_HLEN) +
+		(is_vlan_dev(attr.route_dev) ? VLAN_ETH_HLEN : ETH_HLEN) +
 		sizeof(struct iphdr) +
 		e->tunnel->calc_hlen(e);
 
@@ -229,37 +249,37 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	/* used by mlx5e_detach_encap to lookup a neigh hash table
 	 * entry in the neigh hash table when a user deletes a rule
 	 */
-	e->m_neigh.dev = n->dev;
-	e->m_neigh.family = n->ops->family;
-	memcpy(&e->m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
-	e->out_dev = out_dev;
-	e->route_dev_ifindex = route_dev->ifindex;
+	e->m_neigh.dev = attr.n->dev;
+	e->m_neigh.family = attr.n->ops->family;
+	memcpy(&e->m_neigh.dst_ip, attr.n->primary_key, attr.n->tbl->key_len);
+	e->out_dev = attr.out_dev;
+	e->route_dev_ifindex = attr.route_dev->ifindex;
 
 	/* It's important to add the neigh to the hash table before checking
 	 * the neigh validity state. So if we'll get a notification, in case the
 	 * neigh changes it's validity state, we would find the relevant neigh
 	 * in the hash.
 	 */
-	err = mlx5e_rep_encap_entry_attach(netdev_priv(out_dev), e);
+	err = mlx5e_rep_encap_entry_attach(netdev_priv(attr.out_dev), e);
 	if (err)
 		goto free_encap;
 
-	read_lock_bh(&n->lock);
-	nud_state = n->nud_state;
-	ether_addr_copy(e->h_dest, n->ha);
-	read_unlock_bh(&n->lock);
+	read_lock_bh(&attr.n->lock);
+	nud_state = attr.n->nud_state;
+	ether_addr_copy(e->h_dest, attr.n->ha);
+	read_unlock_bh(&attr.n->lock);
 
 	/* add ethernet header */
-	ip = (struct iphdr *)gen_eth_tnl_hdr(encap_header, route_dev, e,
+	ip = (struct iphdr *)gen_eth_tnl_hdr(encap_header, attr.route_dev, e,
 					     ETH_P_IP);
 
 	/* add ip header */
 	ip->tos = tun_key->tos;
 	ip->version = 0x4;
 	ip->ihl = 0x5;
-	ip->ttl = ttl;
-	ip->daddr = fl4.daddr;
-	ip->saddr = fl4.saddr;
+	ip->ttl = attr.ttl;
+	ip->daddr = attr.fl.fl4.daddr;
+	ip->saddr = attr.fl.fl4.saddr;
 
 	/* add tunneling protocol header */
 	err = mlx5e_gen_ip_tunnel_header((char *)ip + sizeof(struct iphdr),
@@ -271,7 +291,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	e->encap_header = encap_header;
 
 	if (!(nud_state & NUD_VALID)) {
-		neigh_event_send(n, NULL);
+		neigh_event_send(attr.n, NULL);
 		/* the encap entry will be made valid on neigh update event
 		 * and not used before that.
 		 */
@@ -287,8 +307,8 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	}
 
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
-	mlx5e_rep_queue_neigh_stats_work(netdev_priv(out_dev));
-	mlx5e_route_lookup_ipv4_put(route_dev, n);
+	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
+	mlx5e_route_lookup_ipv4_put(&attr);
 	return err;
 
 destroy_neigh_entry:
@@ -296,55 +316,56 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 free_encap:
 	kfree(encap_header);
 release_neigh:
-	mlx5e_route_lookup_ipv4_put(route_dev, n);
+	mlx5e_route_lookup_ipv4_put(&attr);
 	return err;
 }
 
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 static int mlx5e_route_lookup_ipv6_get(struct mlx5e_priv *priv,
 				       struct net_device *mirred_dev,
-				       struct net_device **out_dev,
-				       struct net_device **route_dev,
-				       struct flowi6 *fl6,
-				       struct neighbour **out_n,
-				       u8 *out_ttl)
+				       struct mlx5e_tc_tun_route_attr *attr)
 {
+	struct net_device *route_dev;
+	struct net_device *out_dev;
 	struct dst_entry *dst;
 	struct neighbour *n;
-
 	int ret;
 
-	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(mirred_dev), NULL, fl6,
+	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(mirred_dev), NULL, &attr->fl.fl6,
 					      NULL);
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
-	if (!(*out_ttl))
-		*out_ttl = ip6_dst_hoplimit(dst);
+	if (!attr->ttl)
+		attr->ttl = ip6_dst_hoplimit(dst);
 
-	ret = get_route_and_out_devs(priv, dst->dev, route_dev, out_dev);
-	if (ret < 0) {
-		dst_release(dst);
-		return ret;
-	}
+	ret = get_route_and_out_devs(priv, dst->dev, &route_dev, &out_dev);
+	if (ret < 0)
+		goto err_dst_release;
 
-	dev_hold(*route_dev);
-	n = dst_neigh_lookup(dst, &fl6->daddr);
-	dst_release(dst);
+	dev_hold(route_dev);
+	n = dst_neigh_lookup(dst, &attr->fl.fl6.daddr);
 	if (!n) {
-		dev_put(*route_dev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_dev_release;
 	}
 
-	*out_n = n;
+	dst_release(dst);
+	attr->out_dev = out_dev;
+	attr->route_dev = route_dev;
+	attr->n = n;
 	return 0;
+
+err_dev_release:
+	dev_put(route_dev);
+err_dst_release:
+	dst_release(dst);
+	return ret;
 }
 
-static void mlx5e_route_lookup_ipv6_put(struct net_device *route_dev,
-					struct neighbour *n)
+static void mlx5e_route_lookup_ipv6_put(struct mlx5e_tc_tun_route_attr *attr)
 {
-	neigh_release(n);
-	dev_put(route_dev);
+	mlx5e_tc_tun_route_attr_cleanup(attr);
 }
 
 int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
@@ -353,28 +374,24 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 {
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
-	struct net_device *out_dev, *route_dev;
-	struct flowi6 fl6 = {};
+	TC_TUN_ROUTE_ATTR_INIT(attr);
 	struct ipv6hdr *ip6h;
-	struct neighbour *n = NULL;
 	int ipv6_encap_size;
 	char *encap_header;
-	u8 nud_state, ttl;
+	u8 nud_state;
 	int err;
 
-	ttl = tun_key->ttl;
-
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
-	fl6.daddr = tun_key->u.ipv6.dst;
-	fl6.saddr = tun_key->u.ipv6.src;
+	attr.ttl = tun_key->ttl;
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
+	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 
-	err = mlx5e_route_lookup_ipv6_get(priv, mirred_dev, &out_dev, &route_dev,
-					  &fl6, &n, &ttl);
+	err = mlx5e_route_lookup_ipv6_get(priv, mirred_dev, &attr);
 	if (err)
 		return err;
 
 	ipv6_encap_size =
-		(is_vlan_dev(route_dev) ? VLAN_ETH_HLEN : ETH_HLEN) +
+		(is_vlan_dev(attr.route_dev) ? VLAN_ETH_HLEN : ETH_HLEN) +
 		sizeof(struct ipv6hdr) +
 		e->tunnel->calc_hlen(e);
 
@@ -394,36 +411,36 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	/* used by mlx5e_detach_encap to lookup a neigh hash table
 	 * entry in the neigh hash table when a user deletes a rule
 	 */
-	e->m_neigh.dev = n->dev;
-	e->m_neigh.family = n->ops->family;
-	memcpy(&e->m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
-	e->out_dev = out_dev;
-	e->route_dev_ifindex = route_dev->ifindex;
+	e->m_neigh.dev = attr.n->dev;
+	e->m_neigh.family = attr.n->ops->family;
+	memcpy(&e->m_neigh.dst_ip, attr.n->primary_key, attr.n->tbl->key_len);
+	e->out_dev = attr.out_dev;
+	e->route_dev_ifindex = attr.route_dev->ifindex;
 
 	/* It's importent to add the neigh to the hash table before checking
 	 * the neigh validity state. So if we'll get a notification, in case the
 	 * neigh changes it's validity state, we would find the relevant neigh
 	 * in the hash.
 	 */
-	err = mlx5e_rep_encap_entry_attach(netdev_priv(out_dev), e);
+	err = mlx5e_rep_encap_entry_attach(netdev_priv(attr.out_dev), e);
 	if (err)
 		goto free_encap;
 
-	read_lock_bh(&n->lock);
-	nud_state = n->nud_state;
-	ether_addr_copy(e->h_dest, n->ha);
-	read_unlock_bh(&n->lock);
+	read_lock_bh(&attr.n->lock);
+	nud_state = attr.n->nud_state;
+	ether_addr_copy(e->h_dest, attr.n->ha);
+	read_unlock_bh(&attr.n->lock);
 
 	/* add ethernet header */
-	ip6h = (struct ipv6hdr *)gen_eth_tnl_hdr(encap_header, route_dev, e,
+	ip6h = (struct ipv6hdr *)gen_eth_tnl_hdr(encap_header, attr.route_dev, e,
 						 ETH_P_IPV6);
 
 	/* add ip header */
 	ip6_flow_hdr(ip6h, tun_key->tos, 0);
 	/* the HW fills up ipv6 payload len */
-	ip6h->hop_limit   = ttl;
-	ip6h->daddr	  = fl6.daddr;
-	ip6h->saddr	  = fl6.saddr;
+	ip6h->hop_limit   = attr.ttl;
+	ip6h->daddr	  = attr.fl.fl6.daddr;
+	ip6h->saddr	  = attr.fl.fl6.saddr;
 
 	/* add tunneling protocol header */
 	err = mlx5e_gen_ip_tunnel_header((char *)ip6h + sizeof(struct ipv6hdr),
@@ -435,7 +452,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	e->encap_header = encap_header;
 
 	if (!(nud_state & NUD_VALID)) {
-		neigh_event_send(n, NULL);
+		neigh_event_send(attr.n, NULL);
 		/* the encap entry will be made valid on neigh update event
 		 * and not used before that.
 		 */
@@ -452,8 +469,8 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	}
 
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
-	mlx5e_rep_queue_neigh_stats_work(netdev_priv(out_dev));
-	mlx5e_route_lookup_ipv6_put(route_dev, n);
+	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
+	mlx5e_route_lookup_ipv6_put(&attr);
 	return err;
 
 destroy_neigh_entry:
@@ -461,7 +478,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 free_encap:
 	kfree(encap_header);
 release_neigh:
-	mlx5e_route_lookup_ipv6_put(route_dev, n);
+	mlx5e_route_lookup_ipv6_put(&attr);
 	return err;
 }
 #endif
-- 
2.29.2

