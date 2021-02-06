Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC18311B62
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhBFFLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:11:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231334AbhBFFGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:06:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9977464FE1;
        Sat,  6 Feb 2021 05:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587767;
        bh=h4RSbkb2+t642X70nXzDWPuOv/NpvCvKZRDa9V/vIzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8GFOltxJFDUs5BPNgtd7gj2oeCIoxkgxcmwOKGiZQGw8ngvdu/46haY82s/6EiLD
         UZLy1CTuDTJRLS0swsgJV63mv/4XKxsR1jnxag4v04qYhzCso0kDkqlaAQlmsKdvAX
         F2ZfWDqkroX0c1QtnsG0MoON+4Wt9JPZgt6UzLZbEic7ibLGitAy65agNcESsjdiBx
         t24gJXeUugJUReJfbrSS68/+a7IR9H2tiLtmPhfV9BKaB8j2ZLcKZQakU+ArSBwKGq
         UNrGyZOnpDEJaF9Dck3I0uO+Qri7eg3NJIahLsIbXb5wtoJuXu4ScFREzSVRt7jiMF
         X7WxvQ6SNxkdw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 13/17] net/mlx5e: Create route entry infrastructure
Date:   Fri,  5 Feb 2021 21:02:36 -0800
Message-Id: <20210206050240.48410-14-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Implement dedicated route entry infrastructure to be used in following
patch by route update event. Both encap (indirectly through their
corresponding encap entries) and decap (directly) flows are attached to
routing entry. Since route update also requires updating encap (route
device MAC address is a source MAC address of tunnel encapsulation), same
encap_tbl_lock mutex is used for synchronization.

The new infrastructure looks similar to existing infrastructures for shared
encap, mod_hdr and hairpin entries:

- Per-eswitch hash table is used for quick entry lookup.

- Flows are attached to per-entry linked list and hold reference to entry
  during their lifetime.

- Atomic reference counting and rcu mechanisms are used as synchronization
  primitives for concurrent access.

The infrastructure also enables connection tracking on stacked devices
topology by attaching CT chain 0 flow on tunneling dev to decap route
entry.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  11 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 258 +++++++++++++++++-
 .../mellanox/mlx5/core/en/tc_tun_encap.h      |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  24 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   1 +
 7 files changed, 290 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index e0ae24d9a740..14db9b5accb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -25,6 +25,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_DELETED               = MLX5E_TC_FLOW_BASE + 6,
 	MLX5E_TC_FLOW_FLAG_CT                    = MLX5E_TC_FLOW_BASE + 7,
 	MLX5E_TC_FLOW_FLAG_L3_TO_L2_DECAP        = MLX5E_TC_FLOW_BASE + 8,
+	MLX5E_TC_FLOW_FLAG_TUN_RX                = MLX5E_TC_FLOW_BASE + 9,
 };
 
 struct mlx5e_tc_flow_parse_attr {
@@ -59,6 +60,11 @@ struct encap_flow_item {
 	int index;
 };
 
+struct encap_route_flow_item {
+	struct mlx5e_route_entry *r; /* attached route instance */
+	int index;
+};
+
 struct mlx5e_tc_flow {
 	struct rhash_head node;
 	struct mlx5e_priv *priv;
@@ -70,6 +76,11 @@ struct mlx5e_tc_flow {
 	struct list_head l3_to_l2_reformat;
 	struct mlx5e_decap_entry *decap_reformat;
 
+	/* flows sharing same route entry */
+	struct list_head decap_routes;
+	struct mlx5e_route_entry *decap_route;
+	struct encap_route_flow_item encap_routes[MLX5_MAX_FLOW_FWD_VPORTS];
+
 	/* Flow can be associated with multiple encap IDs.
 	 * The number of encaps is bounded by the number of supported
 	 * destinations.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 63652911d56e..75fcffecfe3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -7,6 +7,23 @@
 #include "rep/tc.h"
 #include "diag/en_tc_tracepoint.h"
 
+struct mlx5e_route_key {
+	int ip_version;
+	union {
+		__be32 v4;
+		struct in6_addr v6;
+	} endpoint_ip;
+};
+
+struct mlx5e_route_entry {
+	struct mlx5e_route_key key;
+	struct list_head encap_entries;
+	struct list_head decap_flows;
+	struct hlist_node hlist;
+	refcount_t refcnt;
+	struct rcu_head rcu;
+};
+
 int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec)
 {
@@ -29,10 +46,13 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 				     outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
 		tun_attr->dst_ip.v4 = *(__be32 *)daddr;
 		tun_attr->src_ip.v4 = *(__be32 *)saddr;
+		if (!tun_attr->dst_ip.v4 || !tun_attr->src_ip.v4)
+			return 0;
 	}
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 	else if (ip_version == 6) {
 		int ipv6_size = MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6);
+		struct in6_addr zerov6 = {};
 
 		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				     outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6);
@@ -40,8 +60,15 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 				     outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6);
 		memcpy(&tun_attr->dst_ip.v6, daddr, ipv6_size);
 		memcpy(&tun_attr->src_ip.v6, saddr, ipv6_size);
+		if (!memcmp(&tun_attr->dst_ip.v6, &zerov6, sizeof(zerov6)) ||
+		    !memcmp(&tun_attr->src_ip.v6, &zerov6, sizeof(zerov6)))
+			return 0;
 	}
 #endif
+	/* Only set the flag if both src and dst ip addresses exist. They are
+	 * required to establish routing.
+	 */
+	flow_flag_set(flow, TUN_RX);
 	return 0;
 }
 
@@ -325,6 +352,7 @@ void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
 
 	if (!refcount_dec_and_mutex_lock(&e->refcnt, &esw->offloads.encap_tbl_lock))
 		return;
+	list_del(&e->route_list);
 	hash_del_rcu(&e->encap_hlist);
 	mutex_unlock(&esw->offloads.encap_tbl_lock);
 
@@ -343,12 +371,20 @@ static void mlx5e_decap_put(struct mlx5e_priv *priv, struct mlx5e_decap_entry *d
 	mlx5e_decap_dealloc(priv, d);
 }
 
+static void mlx5e_detach_encap_route(struct mlx5e_priv *priv,
+				     struct mlx5e_tc_flow *flow,
+				     int out_index);
+
 void mlx5e_detach_encap(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow, int out_index)
 {
 	struct mlx5e_encap_entry *e = flow->encaps[out_index].e;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
+	if (flow->attr->esw_attr->dests[out_index].flags &
+	    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+		mlx5e_detach_encap_route(priv, flow, out_index);
+
 	/* flow wasn't fully initialized */
 	if (!e)
 		return;
@@ -360,6 +396,7 @@ void mlx5e_detach_encap(struct mlx5e_priv *priv,
 		mutex_unlock(&esw->offloads.encap_tbl_lock);
 		return;
 	}
+	list_del(&e->route_list);
 	hash_del_rcu(&e->encap_hlist);
 	mutex_unlock(&esw->offloads.encap_tbl_lock);
 
@@ -531,6 +568,12 @@ static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
 	return err;
 }
 
+static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
+				    struct mlx5e_tc_flow *flow,
+				    struct mlx5e_encap_entry *e,
+				    bool new_encap_entry,
+				    int out_index);
+
 int mlx5e_attach_encap(struct mlx5e_priv *priv,
 		       struct mlx5e_tc_flow *flow,
 		       struct net_device *mirred_dev,
@@ -545,6 +588,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	const struct ip_tunnel_info *tun_info;
 	struct encap_key key;
 	struct mlx5e_encap_entry *e;
+	bool entry_created = false;
 	unsigned short family;
 	uintptr_t hash_key;
 	int err = 0;
@@ -592,6 +636,8 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 
 	refcount_set(&e->refcnt, 1);
 	init_completion(&e->res_ready);
+	entry_created = true;
+	INIT_LIST_HEAD(&e->route_list);
 
 	tun_info = mlx5e_dup_tun_info(tun_info);
 	if (!tun_info) {
@@ -622,8 +668,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	e->compl_result = 1;
 
 attach_flow:
-	err = mlx5e_set_vf_tunnel(esw, attr, &parse_attr->mod_hdr_acts, e->out_dev,
-				  e->route_dev_ifindex, out_index);
+	err = mlx5e_attach_encap_route(priv, flow, e, entry_created, out_index);
 	if (err)
 		goto out_err;
 
@@ -732,3 +777,212 @@ int mlx5e_attach_decap(struct mlx5e_priv *priv,
 	mutex_unlock(&esw->offloads.decap_tbl_lock);
 	return err;
 }
+
+static int cmp_route_info(struct mlx5e_route_key *a,
+			  struct mlx5e_route_key *b)
+{
+	if (a->ip_version == 4 && b->ip_version == 4)
+		return memcmp(&a->endpoint_ip.v4, &b->endpoint_ip.v4,
+			      sizeof(a->endpoint_ip.v4));
+	else if (a->ip_version == 6 && b->ip_version == 6)
+		return memcmp(&a->endpoint_ip.v6, &b->endpoint_ip.v6,
+			      sizeof(a->endpoint_ip.v6));
+	return 1;
+}
+
+static u32 hash_route_info(struct mlx5e_route_key *key)
+{
+	if (key->ip_version == 4)
+		return jhash(&key->endpoint_ip.v4, sizeof(key->endpoint_ip.v4), 0);
+	return jhash(&key->endpoint_ip.v6, sizeof(key->endpoint_ip.v6), 0);
+}
+
+static struct mlx5e_route_entry *
+mlx5e_route_get(struct mlx5e_priv *priv, struct mlx5e_route_key *key,
+		u32 hash_key)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_route_key r_key;
+	struct mlx5e_route_entry *r;
+
+	hash_for_each_possible(esw->offloads.route_tbl, r, hlist, hash_key) {
+		r_key = r->key;
+		if (!cmp_route_info(&r_key, key) &&
+		    refcount_inc_not_zero(&r->refcnt))
+			return r;
+	}
+	return NULL;
+}
+
+static struct mlx5e_route_entry *
+mlx5e_route_get_create(struct mlx5e_priv *priv,
+		       struct mlx5e_route_key *key)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_route_entry *r;
+	u32 hash_key;
+
+	hash_key = hash_route_info(key);
+	r = mlx5e_route_get(priv, key, hash_key);
+	if (r)
+		return r;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+
+	r->key = *key;
+	refcount_set(&r->refcnt, 1);
+	INIT_LIST_HEAD(&r->decap_flows);
+	INIT_LIST_HEAD(&r->encap_entries);
+	hash_add(esw->offloads.route_tbl, &r->hlist, hash_key);
+	return r;
+}
+
+int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
+			     struct mlx5e_tc_flow *flow)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
+	struct mlx5_esw_flow_attr *esw_attr;
+	struct mlx5e_route_entry *r;
+	struct mlx5e_route_key key;
+	int err = 0;
+
+	esw_attr = attr->esw_attr;
+	parse_attr = attr->parse_attr;
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	if (!esw_attr->rx_tun_attr)
+		goto out;
+
+	err = mlx5e_tc_tun_route_lookup(priv, &parse_attr->spec, attr);
+	if (err || !esw_attr->rx_tun_attr->decap_vport)
+		goto out;
+
+	key.ip_version = attr->ip_version;
+	if (key.ip_version == 4)
+		key.endpoint_ip.v4 = esw_attr->rx_tun_attr->dst_ip.v4;
+	else
+		key.endpoint_ip.v6 = esw_attr->rx_tun_attr->dst_ip.v6;
+
+	r = mlx5e_route_get_create(priv, &key);
+	if (IS_ERR(r)) {
+		err = PTR_ERR(r);
+		goto out;
+	}
+
+	flow->decap_route = r;
+	list_add(&flow->decap_routes, &r->decap_flows);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	return 0;
+
+out:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	return err;
+}
+
+static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
+				    struct mlx5e_tc_flow *flow,
+				    struct mlx5e_encap_entry *e,
+				    bool new_encap_entry,
+				    int out_index)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
+	const struct ip_tunnel_info *tun_info;
+	struct mlx5_esw_flow_attr *esw_attr;
+	struct mlx5e_route_entry *r;
+	struct mlx5e_route_key key;
+	unsigned short family;
+	int err = 0;
+
+	esw_attr = attr->esw_attr;
+	parse_attr = attr->parse_attr;
+	tun_info = parse_attr->tun_info[out_index];
+	family = ip_tunnel_info_af(tun_info);
+
+	if (family == AF_INET) {
+		key.endpoint_ip.v4 = tun_info->key.u.ipv4.src;
+		key.ip_version = 4;
+	} else if (family == AF_INET6) {
+		key.endpoint_ip.v6 = tun_info->key.u.ipv6.src;
+		key.ip_version = 6;
+	}
+
+	err = mlx5e_set_vf_tunnel(esw, attr, &parse_attr->mod_hdr_acts, e->out_dev,
+				  e->route_dev_ifindex, out_index);
+	if (err || !(esw_attr->dests[out_index].flags &
+		     MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE))
+		return err;
+
+	r = mlx5e_route_get_create(priv, &key);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	flow->encap_routes[out_index].r = r;
+	if (new_encap_entry)
+		list_add(&e->route_list, &r->encap_entries);
+	flow->encap_routes[out_index].index = out_index;
+	return 0;
+}
+
+static void mlx5e_route_dealloc(struct mlx5e_priv *priv,
+				struct mlx5e_route_entry *r)
+{
+	WARN_ON(!list_empty(&r->decap_flows));
+	WARN_ON(!list_empty(&r->encap_entries));
+
+	kfree_rcu(r, rcu);
+}
+
+void mlx5e_detach_decap_route(struct mlx5e_priv *priv,
+			      struct mlx5e_tc_flow *flow)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_route_entry *r = flow->decap_route;
+
+	if (!r)
+		return;
+
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	list_del(&flow->decap_routes);
+	flow->decap_route = NULL;
+
+	if (!refcount_dec_and_test(&r->refcnt)) {
+		mutex_unlock(&esw->offloads.encap_tbl_lock);
+		return;
+	}
+	hash_del_rcu(&r->hlist);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	mlx5e_route_dealloc(priv, r);
+}
+
+static void mlx5e_detach_encap_route(struct mlx5e_priv *priv,
+				     struct mlx5e_tc_flow *flow,
+				     int out_index)
+{
+	struct mlx5e_route_entry *r = flow->encap_routes[out_index].r;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_encap_entry *e, *tmp;
+
+	if (!r)
+		return;
+
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	flow->encap_routes[out_index].r = NULL;
+
+	if (!refcount_dec_and_test(&r->refcnt)) {
+		mutex_unlock(&esw->offloads.encap_tbl_lock);
+		return;
+	}
+	list_for_each_entry_safe(e, tmp, &r->encap_entries, route_list)
+		list_del_init(&e->route_list);
+	hash_del_rcu(&r->hlist);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	mlx5e_route_dealloc(priv, r);
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
index 81b9fef1cf2a..9939cff6e6c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
@@ -22,6 +22,11 @@ int mlx5e_attach_decap(struct mlx5e_priv *priv,
 void mlx5e_detach_decap(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow);
 
+int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
+			     struct mlx5e_tc_flow *flow);
+void mlx5e_detach_decap_route(struct mlx5e_priv *priv,
+			      struct mlx5e_tc_flow *flow);
+
 struct ip_tunnel_info *mlx5e_dup_tun_info(const struct ip_tunnel_info *tun_info);
 
 int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 988195ab1c54..8e04126f088a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -181,6 +181,7 @@ struct mlx5e_encap_entry {
 	 */
 	struct hlist_node encap_hlist;
 	struct list_head flows;
+	struct list_head route_list;
 	struct mlx5_pkt_reformat *pkt_reformat;
 	const struct ip_tunnel_info *tun_info;
 	unsigned char h_dest[ETH_ALEN];	/* destination eth addr	*/
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cfe340e23dfc..2cc31f99db9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1251,6 +1251,12 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	if (flow_flag_test(flow, TUN_RX)) {
+		err = mlx5e_attach_decap_route(priv, flow);
+		if (err)
+			return err;
+	}
+
 	if (flow_flag_test(flow, L3_TO_L2_DECAP)) {
 		err = mlx5e_attach_decap(priv, flow, extack);
 		if (err)
@@ -1335,8 +1341,10 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_flow_attr *attr = flow->attr;
+	struct mlx5_esw_flow_attr *esw_attr;
 	int out_index;
 
+	esw_attr = attr->esw_attr;
 	mlx5e_put_flow_tunnel_id(flow);
 
 	if (flow_flag_test(flow, NOT_READY))
@@ -1354,11 +1362,15 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 
 	mlx5_eswitch_del_vlan_action(esw, attr);
 
-	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
-		if (attr->esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP) {
+	if (flow->decap_route)
+		mlx5e_detach_decap_route(priv, flow);
+
+	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
+		if (esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP) {
 			mlx5e_detach_encap(priv, flow, out_index);
 			kfree(attr->parse_attr->tun_info[out_index]);
 		}
+	}
 	kvfree(attr->parse_attr);
 	kvfree(attr->esw_attr->rx_tun_attr);
 
@@ -1368,7 +1380,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		mlx5e_detach_mod_hdr(priv, flow);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
-		mlx5_fc_destroy(attr->esw_attr->counter_dev, attr->counter);
+		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
 
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
@@ -3692,12 +3704,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		}
 	}
 
-	if (decap && esw_attr->rx_tun_attr) {
-		err = mlx5e_tc_tun_route_lookup(priv, &parse_attr->spec, attr);
-		if (err)
-			return err;
-	}
-
 	/* always set IP version for indirect table handling */
 	attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index aba17835465b..310c405e81d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1830,6 +1830,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	mutex_init(&esw->offloads.decap_tbl_lock);
 	hash_init(esw->offloads.decap_tbl);
 	mlx5e_mod_hdr_tbl_init(&esw->offloads.mod_hdr);
+	hash_init(esw->offloads.route_tbl);
 	atomic64_set(&esw->offloads.num_flows, 0);
 	ida_init(&esw->offloads.vport_metadata_ida);
 	xa_init_flags(&esw->offloads.vhca_map, XA_FLAGS_ALLOC);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 34a21ff95472..b90724e27960 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -214,6 +214,7 @@ struct mlx5_esw_offload {
 	struct mutex peer_mutex;
 	struct mutex encap_tbl_lock; /* protects encap_tbl */
 	DECLARE_HASHTABLE(encap_tbl, 8);
+	DECLARE_HASHTABLE(route_tbl, 8);
 	struct mutex decap_tbl_lock; /* protects decap_tbl */
 	DECLARE_HASHTABLE(decap_tbl, 8);
 	struct mod_hdr_tbl mod_hdr;
-- 
2.29.2

