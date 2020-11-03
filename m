Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AE12A4FE5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgKCTTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4543 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729520AbgKCTTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad280000>; Tue, 03 Nov 2020 11:19:04 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:19:00 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Vlad Buslov" <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/9] net/mlx5e: Protect encap route dev from concurrent release
Date:   Tue, 3 Nov 2020 11:18:23 -0800
Message-ID: <20201103191830.60151-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103191830.60151-1-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604431144; bh=6mOu6eo+I0YHui4C0Rq7XRcO61Y6ppeSKI1OWyTsAwg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=akZ54JJog3GC7d7sOJm4OAsKpOvGy9EgjVQHTVZHezAkYU8G2H5Uwg+Dr6brGVrfh
         3/eTBAcOVCch+JxOtOTwv3stLnJr0LQrsAa9BPxSoJ00nCbNjWGMYHVL4L/bTimL/S
         p96RNtk0rBGSHenCfnlbOJ3NB4s2lZWk9z/1gg/7M0hQbIHiuvBwaru5iFnzjI/s5H
         RF8+OlTBpFZHbhmHYqSZvfMcY2eMbjl/bUQ7QDJq6cAFC4pyww1eryCjqgBn/dM6FB
         wVvOOg2ooC+iBF0OeWCDC3W2fBvjMNsBvTgcFNAuyQQkDpH4q0PyenQpMf739UGOyY
         DUIZKT7oplD0g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

In functions mlx5e_route_lookup_ipv{4|6}() route_dev can be arbitrary net
device and not necessary mlx5 eswitch port representor. As such, in order
to ensure that route_dev is not destroyed concurrent the code needs either
explicitly take reference to the device before releasing reference to
rtable instance or ensure that caller holds rtnl lock. First approach is
chosen as a fix since rtnl lock dependency was intentionally removed from
mlx5 TC layer.

To prevent unprotected usage of route_dev in encap code take a reference to
the device before releasing rt. Don't save direct pointer to the device in
mlx5_encap_entry structure and use ifindex instead. Modify users of
route_dev pointer to properly obtain the net device instance from its
ifindex.

Fixes: 61086f391044 ("net/mlx5e: Protect encap hash table with mutex")
Fixes: 6707f74be862 ("net/mlx5e: Update hw flows when encap source mac chan=
ged")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  6 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 72 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  2 +-
 3 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index e36e505d38ad..d29af7b9c695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -107,12 +107,16 @@ void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
 		mlx5e_tc_encap_flows_del(priv, e, &flow_list);
=20
 	if (neigh_connected && !(e->flags & MLX5_ENCAP_ENTRY_VALID)) {
+		struct net_device *route_dev;
+
 		ether_addr_copy(e->h_dest, ha);
 		ether_addr_copy(eth->h_dest, ha);
 		/* Update the encap source mac, in case that we delete
 		 * the flows when encap source mac changed.
 		 */
-		ether_addr_copy(eth->h_source, e->route_dev->dev_addr);
+		route_dev =3D __dev_get_by_index(dev_net(priv->netdev), e->route_dev_ifi=
ndex);
+		if (route_dev)
+			ether_addr_copy(eth->h_source, route_dev->dev_addr);
=20
 		mlx5e_tc_encap_flows_add(priv, e, &flow_list);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 7cce85faa16f..90930e54b6f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -77,13 +77,13 @@ static int get_route_and_out_devs(struct mlx5e_priv *pr=
iv,
 	return 0;
 }
=20
-static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
-				   struct net_device *mirred_dev,
-				   struct net_device **out_dev,
-				   struct net_device **route_dev,
-				   struct flowi4 *fl4,
-				   struct neighbour **out_n,
-				   u8 *out_ttl)
+static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
+				       struct net_device *mirred_dev,
+				       struct net_device **out_dev,
+				       struct net_device **route_dev,
+				       struct flowi4 *fl4,
+				       struct neighbour **out_n,
+				       u8 *out_ttl)
 {
 	struct neighbour *n;
 	struct rtable *rt;
@@ -117,18 +117,28 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv =
*priv,
 		ip_rt_put(rt);
 		return ret;
 	}
+	dev_hold(*route_dev);
=20
 	if (!(*out_ttl))
 		*out_ttl =3D ip4_dst_hoplimit(&rt->dst);
 	n =3D dst_neigh_lookup(&rt->dst, &fl4->daddr);
 	ip_rt_put(rt);
-	if (!n)
+	if (!n) {
+		dev_put(*route_dev);
 		return -ENOMEM;
+	}
=20
 	*out_n =3D n;
 	return 0;
 }
=20
+static void mlx5e_route_lookup_ipv4_put(struct net_device *route_dev,
+					struct neighbour *n)
+{
+	neigh_release(n);
+	dev_put(route_dev);
+}
+
 static const char *mlx5e_netdev_kind(struct net_device *dev)
 {
 	if (dev->rtnl_link_ops)
@@ -193,8 +203,8 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *=
priv,
 	fl4.saddr =3D tun_key->u.ipv4.src;
 	ttl =3D tun_key->ttl;
=20
-	err =3D mlx5e_route_lookup_ipv4(priv, mirred_dev, &out_dev, &route_dev,
-				      &fl4, &n, &ttl);
+	err =3D mlx5e_route_lookup_ipv4_get(priv, mirred_dev, &out_dev, &route_de=
v,
+					  &fl4, &n, &ttl);
 	if (err)
 		return err;
=20
@@ -223,7 +233,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *=
priv,
 	e->m_neigh.family =3D n->ops->family;
 	memcpy(&e->m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
 	e->out_dev =3D out_dev;
-	e->route_dev =3D route_dev;
+	e->route_dev_ifindex =3D route_dev->ifindex;
=20
 	/* It's important to add the neigh to the hash table before checking
 	 * the neigh validity state. So if we'll get a notification, in case the
@@ -278,7 +288,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *=
priv,
=20
 	e->flags |=3D MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(out_dev));
-	neigh_release(n);
+	mlx5e_route_lookup_ipv4_put(route_dev, n);
 	return err;
=20
 destroy_neigh_entry:
@@ -286,18 +296,18 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv=
 *priv,
 free_encap:
 	kfree(encap_header);
 release_neigh:
-	neigh_release(n);
+	mlx5e_route_lookup_ipv4_put(route_dev, n);
 	return err;
 }
=20
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
-static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
-				   struct net_device *mirred_dev,
-				   struct net_device **out_dev,
-				   struct net_device **route_dev,
-				   struct flowi6 *fl6,
-				   struct neighbour **out_n,
-				   u8 *out_ttl)
+static int mlx5e_route_lookup_ipv6_get(struct mlx5e_priv *priv,
+				       struct net_device *mirred_dev,
+				       struct net_device **out_dev,
+				       struct net_device **route_dev,
+				       struct flowi6 *fl6,
+				       struct neighbour **out_n,
+				       u8 *out_ttl)
 {
 	struct dst_entry *dst;
 	struct neighbour *n;
@@ -318,15 +328,25 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv =
*priv,
 		return ret;
 	}
=20
+	dev_hold(*route_dev);
 	n =3D dst_neigh_lookup(dst, &fl6->daddr);
 	dst_release(dst);
-	if (!n)
+	if (!n) {
+		dev_put(*route_dev);
 		return -ENOMEM;
+	}
=20
 	*out_n =3D n;
 	return 0;
 }
=20
+static void mlx5e_route_lookup_ipv6_put(struct net_device *route_dev,
+					struct neighbour *n)
+{
+	neigh_release(n);
+	dev_put(route_dev);
+}
+
 int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 				    struct net_device *mirred_dev,
 				    struct mlx5e_encap_entry *e)
@@ -348,8 +368,8 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *=
priv,
 	fl6.daddr =3D tun_key->u.ipv6.dst;
 	fl6.saddr =3D tun_key->u.ipv6.src;
=20
-	err =3D mlx5e_route_lookup_ipv6(priv, mirred_dev, &out_dev, &route_dev,
-				      &fl6, &n, &ttl);
+	err =3D mlx5e_route_lookup_ipv6_get(priv, mirred_dev, &out_dev, &route_de=
v,
+					  &fl6, &n, &ttl);
 	if (err)
 		return err;
=20
@@ -378,7 +398,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *=
priv,
 	e->m_neigh.family =3D n->ops->family;
 	memcpy(&e->m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
 	e->out_dev =3D out_dev;
-	e->route_dev =3D route_dev;
+	e->route_dev_ifindex =3D route_dev->ifindex;
=20
 	/* It's importent to add the neigh to the hash table before checking
 	 * the neigh validity state. So if we'll get a notification, in case the
@@ -433,7 +453,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *=
priv,
=20
 	e->flags |=3D MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(out_dev));
-	neigh_release(n);
+	mlx5e_route_lookup_ipv6_put(route_dev, n);
 	return err;
=20
 destroy_neigh_entry:
@@ -441,7 +461,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *=
priv,
 free_encap:
 	kfree(encap_header);
 release_neigh:
-	neigh_release(n);
+	mlx5e_route_lookup_ipv6_put(route_dev, n);
 	return err;
 }
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index 9020d1419bcf..8932c387d46a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -186,7 +186,7 @@ struct mlx5e_encap_entry {
 	unsigned char h_dest[ETH_ALEN];	/* destination eth addr	*/
=20
 	struct net_device *out_dev;
-	struct net_device *route_dev;
+	int route_dev_ifindex;
 	struct mlx5e_tc_tunnel *tunnel;
 	int reformat_type;
 	u8 flags;
--=20
2.26.2

