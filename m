Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A3F310521
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhBEGsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:48:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhBEGps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 226BF64FC8;
        Fri,  5 Feb 2021 06:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507457;
        bh=Ou05yqXghtb5vWAncKHkHYxOM6SVr3SKMKlsI1r1wfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLp+Wni0CRjSzQ8BR9YPLwLpXRDrKlskPmF3LvtbDkCxci1avRa+3NRfGSRClmT4c
         nzgFD++CRlFzxUB6CMrxnt/ciKoiiPUTcTMuyWS17k5OSt9kZMhbQCPAyqbTtz1QI8
         z5wgTqco1eM3t5PyN0/upJ2ah5btCc9iGUF62btrhVVecnYzJe5rgeayl83GfHzI2t
         zKVK+i8BC5mSwEv1gJZaj9/OmoXTN6fxD2EeNGsvWR923T9SBbEQYbotGaXV92xLO7
         EBkvgNPj8T9FoHXzEKb7GtymUpxBUAtOz5K31jSfSfiL70to6wU9EDNXsFVMugHNlW
         xo+VUwygj1izg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 17/17] net/mlx5e: Handle FIB events to update tunnel endpoint device
Date:   Thu,  4 Feb 2021 22:40:51 -0800
Message-Id: <20210205064051.89592-18-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205064051.89592-1-saeed@kernel.org>
References: <20210205064051.89592-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Process FIB route update events to dynamically update the stack device
rules when tunnel routing changes. Use rtnl lock to prevent FIB event
handler from running concurrently with neigh update and neigh stats
workqueue tasks. Use encap_tbl_lock mutex to synchronize with TC rule
update path that doesn't use rtnl lock.

FIB event workflow for encap flows:

- Unoffload all flows attached to route encaps from slow or fast path
depending on encap destination endpoint neigh state.

- Update encap IP header according to new route dev.

- Update flows mod_hdr action that is responsible for overwriting reg_c0
source port bits to source port of new underlying VF of new route dev. This
step requires changing flow create/delete code to save flow parse attribute
mod_hdr_acts structure for whole flow lifetime instead of deallocating it
after flow creation. Refactor mod_hdr code to allow saving id of individual
mod_hdr actions and updating them with dedicated helper.

- Offload all flows to either slow or fast path depending on encap
destination endpoint neigh state.

FIB event workflow for decap flows:

- Unoffload all route flows from hardware. When last route flow is deleted
all indirect table rules for the route dev will also be deleted.

- Update flow attr decap_vport and destination MAC according to underlying
VF of new rote dev.

- Offload all route flows back to hardware creating new indirect table
rules according to updated flow attribute data.

Extract some neigh update code to helper functions to be used by both neigh
update and route update infrastructure.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |   1 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 751 +++++++++++++++++-
 .../mellanox/mlx5/core/en/tc_tun_encap.h      |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  76 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   1 -
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +-
 7 files changed, 773 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 4f35b486fb44..c223591ffc22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -26,6 +26,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_CT                    = MLX5E_TC_FLOW_BASE + 7,
 	MLX5E_TC_FLOW_FLAG_L3_TO_L2_DECAP        = MLX5E_TC_FLOW_BASE + 8,
 	MLX5E_TC_FLOW_FLAG_TUN_RX                = MLX5E_TC_FLOW_BASE + 9,
+	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 10,
 };
 
 struct mlx5e_tc_flow_parse_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index bc0e26f3fd4c..6a116335bb21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1,12 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2021 Mellanox Technologies. */
 
+#include <net/fib_notifier.h>
 #include "tc_tun_encap.h"
 #include "en_tc.h"
 #include "tc_tun.h"
 #include "rep/tc.h"
 #include "diag/en_tc_tracepoint.h"
 
+enum {
+	MLX5E_ROUTE_ENTRY_VALID     = BIT(0),
+};
+
 struct mlx5e_route_key {
 	int ip_version;
 	union {
@@ -19,11 +24,26 @@ struct mlx5e_route_entry {
 	struct mlx5e_route_key key;
 	struct list_head encap_entries;
 	struct list_head decap_flows;
+	u32 flags;
 	struct hlist_node hlist;
 	refcount_t refcnt;
+	int tunnel_dev_index;
 	struct rcu_head rcu;
 };
 
+struct mlx5e_tc_tun_encap {
+	struct mlx5e_priv *priv;
+	struct notifier_block fib_nb;
+	spinlock_t route_lock; /* protects route_tbl */
+	unsigned long route_tbl_last_update;
+	DECLARE_HASHTABLE(route_tbl, 8);
+};
+
+static bool mlx5e_route_entry_valid(struct mlx5e_route_entry *r)
+{
+	return r->flags & MLX5E_ROUTE_ENTRY_VALID;
+}
+
 int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec)
 {
@@ -72,6 +92,27 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 	return 0;
 }
 
+static bool mlx5e_tc_flow_all_encaps_valid(struct mlx5_esw_flow_attr *esw_attr)
+{
+	bool all_flow_encaps_valid = true;
+	int i;
+
+	/* Flow can be associated with multiple encap entries.
+	 * Before offloading the flow verify that all of them have
+	 * a valid neighbour.
+	 */
+	for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
+		if (!(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP))
+			continue;
+		if (!(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP_VALID)) {
+			all_flow_encaps_valid = false;
+			break;
+		}
+	}
+
+	return all_flow_encaps_valid;
+}
+
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 			      struct mlx5e_encap_entry *e,
 			      struct list_head *flow_list)
@@ -84,6 +125,9 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow *flow;
 	int err;
 
+	if (e->flags & MLX5_ENCAP_ENTRY_NO_ROUTE)
+		return;
+
 	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
 						     e->reformat_type,
 						     e->encap_size, e->encap_header,
@@ -97,9 +141,6 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 	mlx5e_rep_queue_neigh_stats_work(priv);
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		bool all_flow_encaps_valid = true;
-		int i;
-
 		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
 		attr = flow->attr;
@@ -108,20 +149,9 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 
 		esw_attr->dests[flow->tmp_entry_index].pkt_reformat = e->pkt_reformat;
 		esw_attr->dests[flow->tmp_entry_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
-		/* Flow can be associated with multiple encap entries.
-		 * Before offloading the flow verify that all of them have
-		 * a valid neighbour.
-		 */
-		for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
-			if (!(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP))
-				continue;
-			if (!(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP_VALID)) {
-				all_flow_encaps_valid = false;
-				break;
-			}
-		}
+
 		/* Do not offload flows with unresolved neighbors */
-		if (!all_flow_encaps_valid)
+		if (!mlx5e_tc_flow_all_encaps_valid(esw_attr))
 			continue;
 		/* update from slow path rule to encap rule */
 		rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, attr);
@@ -181,6 +211,18 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
 }
 
+static void mlx5e_take_tmp_flow(struct mlx5e_tc_flow *flow,
+				struct list_head *flow_list,
+				int index)
+{
+	if (IS_ERR(mlx5e_flow_get(flow)))
+		return;
+	wait_for_completion(&flow->init_done);
+
+	flow->tmp_entry_index = index;
+	list_add(&flow->tmp_list, flow_list);
+}
+
 /* Takes reference to all flows attached to encap and adds the flows to
  * flow_list using 'tmp_list' list_head in mlx5e_tc_flow.
  */
@@ -191,15 +233,22 @@ void mlx5e_take_all_encap_flows(struct mlx5e_encap_entry *e, struct list_head *f
 
 	list_for_each_entry(efi, &e->flows, list) {
 		flow = container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
-		if (IS_ERR(mlx5e_flow_get(flow)))
-			continue;
-		wait_for_completion(&flow->init_done);
-
-		flow->tmp_entry_index = efi->index;
-		list_add(&flow->tmp_list, flow_list);
+		mlx5e_take_tmp_flow(flow, flow_list, efi->index);
 	}
 }
 
+/* Takes reference to all flows attached to route and adds the flows to
+ * flow_list using 'tmp_list' list_head in mlx5e_tc_flow.
+ */
+static void mlx5e_take_all_route_decap_flows(struct mlx5e_route_entry *r,
+					     struct list_head *flow_list)
+{
+	struct mlx5e_tc_flow *flow;
+
+	list_for_each_entry(flow, &r->decap_flows, decap_routes)
+		mlx5e_take_tmp_flow(flow, flow_list, 0);
+}
+
 static struct mlx5e_encap_entry *
 mlx5e_get_next_valid_encap(struct mlx5e_neigh_hash_entry *nhe,
 			   struct mlx5e_encap_entry *e)
@@ -557,21 +606,78 @@ static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
 	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
 	data = mlx5_eswitch_get_vport_metadata_for_set(esw_attr->in_mdev->priv.eswitch,
 						       vport_num);
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_hdr_acts,
-					MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG, data);
+	err = mlx5e_tc_match_to_reg_set_and_get_id(esw->dev, mod_hdr_acts,
+						   MLX5_FLOW_NAMESPACE_FDB,
+						   VPORT_TO_REG, data);
+	if (err >= 0) {
+		esw_attr->dests[out_index].src_port_rewrite_act_id = err;
+		err = 0;
+	}
+
+out:
+	if (route_dev)
+		dev_put(route_dev);
+	return err;
+}
+
+static int mlx5e_update_vf_tunnel(struct mlx5_eswitch *esw,
+				  struct mlx5_esw_flow_attr *attr,
+				  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+				  struct net_device *out_dev,
+				  int route_dev_ifindex,
+				  int out_index)
+{
+	int act_id = attr->dests[out_index].src_port_rewrite_act_id;
+	struct net_device *route_dev;
+	u16 vport_num;
+	int err = 0;
+	u32 data;
+
+	route_dev = dev_get_by_index(dev_net(out_dev), route_dev_ifindex);
+
+	if (!route_dev || route_dev->netdev_ops != &mlx5e_netdev_ops ||
+	    !mlx5e_tc_is_vf_tunnel(out_dev, route_dev)) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = mlx5e_tc_query_route_vport(out_dev, route_dev, &vport_num);
 	if (err)
 		goto out;
 
+	data = mlx5_eswitch_get_vport_metadata_for_set(attr->in_mdev->priv.eswitch,
+						       vport_num);
+	mlx5e_tc_match_to_reg_mod_hdr_change(esw->dev, mod_hdr_acts, VPORT_TO_REG, act_id, data);
+
 out:
 	if (route_dev)
 		dev_put(route_dev);
 	return err;
 }
 
+static unsigned int mlx5e_route_tbl_get_last_update(struct mlx5e_priv *priv)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct mlx5e_tc_tun_encap *encap;
+	unsigned int ret;
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+	encap = uplink_priv->encap;
+
+	spin_lock_bh(&encap->route_lock);
+	ret = encap->route_tbl_last_update;
+	spin_unlock_bh(&encap->route_lock);
+	return ret;
+}
+
 static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
 				    struct mlx5e_encap_entry *e,
 				    bool new_encap_entry,
+				    unsigned long tbl_time_before,
 				    int out_index);
 
 int mlx5e_attach_encap(struct mlx5e_priv *priv,
@@ -586,6 +692,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	const struct ip_tunnel_info *tun_info;
+	unsigned long tbl_time_before = 0;
 	struct encap_key key;
 	struct mlx5e_encap_entry *e;
 	bool entry_created = false;
@@ -651,6 +758,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 
 	INIT_LIST_HEAD(&e->flows);
 	hash_add_rcu(esw->offloads.encap_tbl, &e->encap_hlist, hash_key);
+	tbl_time_before = mlx5e_route_tbl_get_last_update(priv);
 	mutex_unlock(&esw->offloads.encap_tbl_lock);
 
 	if (family == AF_INET)
@@ -668,7 +776,8 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	e->compl_result = 1;
 
 attach_flow:
-	err = mlx5e_attach_encap_route(priv, flow, e, entry_created, out_index);
+	err = mlx5e_attach_encap_route(priv, flow, e, entry_created, tbl_time_before,
+				       out_index);
 	if (err)
 		goto out_err;
 
@@ -797,15 +906,48 @@ static u32 hash_route_info(struct mlx5e_route_key *key)
 	return jhash(&key->endpoint_ip.v6, sizeof(key->endpoint_ip.v6), 0);
 }
 
+static void mlx5e_route_dealloc(struct mlx5e_priv *priv,
+				struct mlx5e_route_entry *r)
+{
+	WARN_ON(!list_empty(&r->decap_flows));
+	WARN_ON(!list_empty(&r->encap_entries));
+
+	kfree_rcu(r, rcu);
+}
+
+static void mlx5e_route_put(struct mlx5e_priv *priv, struct mlx5e_route_entry *r)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	if (!refcount_dec_and_mutex_lock(&r->refcnt, &esw->offloads.encap_tbl_lock))
+		return;
+
+	hash_del_rcu(&r->hlist);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	mlx5e_route_dealloc(priv, r);
+}
+
+static void mlx5e_route_put_locked(struct mlx5e_priv *priv, struct mlx5e_route_entry *r)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	lockdep_assert_held(&esw->offloads.encap_tbl_lock);
+
+	if (!refcount_dec_and_test(&r->refcnt))
+		return;
+	hash_del_rcu(&r->hlist);
+	mlx5e_route_dealloc(priv, r);
+}
+
 static struct mlx5e_route_entry *
-mlx5e_route_get(struct mlx5e_priv *priv, struct mlx5e_route_key *key,
+mlx5e_route_get(struct mlx5e_tc_tun_encap *encap, struct mlx5e_route_key *key,
 		u32 hash_key)
 {
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_route_key r_key;
 	struct mlx5e_route_entry *r;
 
-	hash_for_each_possible(esw->offloads.route_tbl, r, hlist, hash_key) {
+	hash_for_each_possible(encap->route_tbl, r, hlist, hash_key) {
 		r_key = r->key;
 		if (!cmp_route_info(&r_key, key) &&
 		    refcount_inc_not_zero(&r->refcnt))
@@ -816,33 +958,120 @@ mlx5e_route_get(struct mlx5e_priv *priv, struct mlx5e_route_key *key,
 
 static struct mlx5e_route_entry *
 mlx5e_route_get_create(struct mlx5e_priv *priv,
-		       struct mlx5e_route_key *key)
+		       struct mlx5e_route_key *key,
+		       int tunnel_dev_index,
+		       unsigned long *route_tbl_change_time)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct mlx5e_tc_tun_encap *encap;
 	struct mlx5e_route_entry *r;
 	u32 hash_key;
 
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+	encap = uplink_priv->encap;
+
 	hash_key = hash_route_info(key);
-	r = mlx5e_route_get(priv, key, hash_key);
-	if (r)
+	spin_lock_bh(&encap->route_lock);
+	r = mlx5e_route_get(encap, key, hash_key);
+	spin_unlock_bh(&encap->route_lock);
+	if (r) {
+		if (!mlx5e_route_entry_valid(r)) {
+			mlx5e_route_put_locked(priv, r);
+			return ERR_PTR(-EINVAL);
+		}
 		return r;
+	}
 
 	r = kzalloc(sizeof(*r), GFP_KERNEL);
 	if (!r)
 		return ERR_PTR(-ENOMEM);
 
 	r->key = *key;
+	r->flags |= MLX5E_ROUTE_ENTRY_VALID;
+	r->tunnel_dev_index = tunnel_dev_index;
 	refcount_set(&r->refcnt, 1);
 	INIT_LIST_HEAD(&r->decap_flows);
 	INIT_LIST_HEAD(&r->encap_entries);
-	hash_add(esw->offloads.route_tbl, &r->hlist, hash_key);
+
+	spin_lock_bh(&encap->route_lock);
+	*route_tbl_change_time = encap->route_tbl_last_update;
+	hash_add(encap->route_tbl, &r->hlist, hash_key);
+	spin_unlock_bh(&encap->route_lock);
+
 	return r;
 }
 
+static struct mlx5e_route_entry *
+mlx5e_route_lookup_for_update(struct mlx5e_tc_tun_encap *encap, struct mlx5e_route_key *key)
+{
+	u32 hash_key = hash_route_info(key);
+	struct mlx5e_route_entry *r;
+
+	spin_lock_bh(&encap->route_lock);
+	encap->route_tbl_last_update = jiffies;
+	r = mlx5e_route_get(encap, key, hash_key);
+	spin_unlock_bh(&encap->route_lock);
+
+	return r;
+}
+
+struct mlx5e_tc_fib_event_data {
+	struct work_struct work;
+	unsigned long event;
+	struct mlx5e_route_entry *r;
+	struct net_device *ul_dev;
+};
+
+static void mlx5e_tc_fib_event_work(struct work_struct *work);
+static struct mlx5e_tc_fib_event_data *
+mlx5e_tc_init_fib_work(unsigned long event, struct net_device *ul_dev, gfp_t flags)
+{
+	struct mlx5e_tc_fib_event_data *fib_work;
+
+	fib_work = kzalloc(sizeof(*fib_work), flags);
+	if (WARN_ON(!fib_work))
+		return NULL;
+
+	INIT_WORK(&fib_work->work, mlx5e_tc_fib_event_work);
+	fib_work->event = event;
+	fib_work->ul_dev = ul_dev;
+
+	return fib_work;
+}
+
+static int
+mlx5e_route_enqueue_update(struct mlx5e_priv *priv,
+			   struct mlx5e_route_entry *r,
+			   unsigned long event)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_fib_event_data *fib_work;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct net_device *ul_dev;
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	ul_dev = uplink_rpriv->netdev;
+
+	fib_work = mlx5e_tc_init_fib_work(event, ul_dev, GFP_KERNEL);
+	if (!fib_work)
+		return -ENOMEM;
+
+	dev_hold(ul_dev);
+	refcount_inc(&r->refcnt);
+	fib_work->r = r;
+	queue_work(priv->wq, &fib_work->work);
+
+	return 0;
+}
+
 int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
 			     struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	unsigned long tbl_time_before, tbl_time_after;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
@@ -856,6 +1085,8 @@ int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
 	if (!esw_attr->rx_tun_attr)
 		goto out;
 
+	tbl_time_before = mlx5e_route_tbl_get_last_update(priv);
+	tbl_time_after = tbl_time_before;
 	err = mlx5e_tc_tun_route_lookup(priv, &parse_attr->spec, attr);
 	if (err || !esw_attr->rx_tun_attr->decap_vport)
 		goto out;
@@ -866,11 +1097,22 @@ int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
 	else
 		key.endpoint_ip.v6 = esw_attr->rx_tun_attr->dst_ip.v6;
 
-	r = mlx5e_route_get_create(priv, &key);
+	r = mlx5e_route_get_create(priv, &key, parse_attr->filter_dev->ifindex,
+				   &tbl_time_after);
 	if (IS_ERR(r)) {
 		err = PTR_ERR(r);
 		goto out;
 	}
+	/* Routing changed concurrently. FIB event handler might have missed new
+	 * entry, schedule update.
+	 */
+	if (tbl_time_before != tbl_time_after) {
+		err = mlx5e_route_enqueue_update(priv, r, FIB_EVENT_ENTRY_REPLACE);
+		if (err) {
+			mlx5e_route_put_locked(priv, r);
+			goto out;
+		}
+	}
 
 	flow->decap_route = r;
 	list_add(&flow->decap_routes, &r->decap_flows);
@@ -886,9 +1128,11 @@ static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
 				    struct mlx5e_encap_entry *e,
 				    bool new_encap_entry,
+				    unsigned long tbl_time_before,
 				    int out_index)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	unsigned long tbl_time_after = tbl_time_before;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	const struct ip_tunnel_info *tun_info;
@@ -917,9 +1161,20 @@ static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
 		     MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE))
 		return err;
 
-	r = mlx5e_route_get_create(priv, &key);
+	r = mlx5e_route_get_create(priv, &key, parse_attr->mirred_ifindex[out_index],
+				   &tbl_time_after);
 	if (IS_ERR(r))
 		return PTR_ERR(r);
+	/* Routing changed concurrently. FIB event handler might have missed new
+	 * entry, schedule update.
+	 */
+	if (tbl_time_before != tbl_time_after) {
+		err = mlx5e_route_enqueue_update(priv, r, FIB_EVENT_ENTRY_REPLACE);
+		if (err) {
+			mlx5e_route_put_locked(priv, r);
+			return err;
+		}
+	}
 
 	flow->encap_routes[out_index].r = r;
 	if (new_encap_entry)
@@ -928,15 +1183,6 @@ static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static void mlx5e_route_dealloc(struct mlx5e_priv *priv,
-				struct mlx5e_route_entry *r)
-{
-	WARN_ON(!list_empty(&r->decap_flows));
-	WARN_ON(!list_empty(&r->encap_entries));
-
-	kfree_rcu(r, rcu);
-}
-
 void mlx5e_detach_decap_route(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow)
 {
@@ -986,3 +1232,422 @@ static void mlx5e_detach_encap_route(struct mlx5e_priv *priv,
 	mlx5e_route_dealloc(priv, r);
 }
 
+static void mlx5e_invalidate_encap(struct mlx5e_priv *priv,
+				   struct mlx5e_encap_entry *e,
+				   struct list_head *encap_flows)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow *flow;
+
+	list_for_each_entry(flow, encap_flows, tmp_list) {
+		struct mlx5_flow_attr *attr = flow->attr;
+		struct mlx5_esw_flow_attr *esw_attr;
+
+		if (!mlx5e_is_offloaded_flow(flow))
+			continue;
+		esw_attr = attr->esw_attr;
+
+		if (flow_flag_test(flow, SLOW))
+			mlx5e_tc_unoffload_from_slow_path(esw, flow);
+		else
+			mlx5e_tc_unoffload_fdb_rules(esw, flow, flow->attr);
+		mlx5_modify_header_dealloc(priv->mdev, attr->modify_hdr);
+		attr->modify_hdr = NULL;
+
+		esw_attr->dests[flow->tmp_entry_index].flags &=
+			~MLX5_ESW_DEST_ENCAP_VALID;
+		esw_attr->dests[flow->tmp_entry_index].pkt_reformat = NULL;
+	}
+
+	e->flags |= MLX5_ENCAP_ENTRY_NO_ROUTE;
+	if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
+		e->flags &= ~MLX5_ENCAP_ENTRY_VALID;
+		mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
+		e->pkt_reformat = NULL;
+	}
+}
+
+static void mlx5e_reoffload_encap(struct mlx5e_priv *priv,
+				  struct net_device *tunnel_dev,
+				  struct mlx5e_encap_entry *e,
+				  struct list_head *encap_flows)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow *flow;
+	int err;
+
+	err = ip_tunnel_info_af(e->tun_info) == AF_INET ?
+		mlx5e_tc_tun_update_header_ipv4(priv, tunnel_dev, e) :
+		mlx5e_tc_tun_update_header_ipv6(priv, tunnel_dev, e);
+	if (err)
+		mlx5_core_warn(priv->mdev, "Failed to update encap header, %d", err);
+	e->flags &= ~MLX5_ENCAP_ENTRY_NO_ROUTE;
+
+	list_for_each_entry(flow, encap_flows, tmp_list) {
+		struct mlx5e_tc_flow_parse_attr *parse_attr;
+		struct mlx5_flow_attr *attr = flow->attr;
+		struct mlx5_esw_flow_attr *esw_attr;
+		struct mlx5_flow_handle *rule;
+		struct mlx5_flow_spec *spec;
+
+		if (flow_flag_test(flow, FAILED))
+			continue;
+
+		esw_attr = attr->esw_attr;
+		parse_attr = attr->parse_attr;
+		spec = &parse_attr->spec;
+
+		err = mlx5e_update_vf_tunnel(esw, esw_attr, &parse_attr->mod_hdr_acts,
+					     e->out_dev, e->route_dev_ifindex,
+					     flow->tmp_entry_index);
+		if (err) {
+			mlx5_core_warn(priv->mdev, "Failed to update VF tunnel err=%d", err);
+			continue;
+		}
+
+		err = mlx5e_tc_add_flow_mod_hdr(priv, parse_attr, flow);
+		if (err) {
+			mlx5_core_warn(priv->mdev, "Failed to update flow mod_hdr err=%d",
+				       err);
+			continue;
+		}
+
+		if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
+			esw_attr->dests[flow->tmp_entry_index].pkt_reformat = e->pkt_reformat;
+			esw_attr->dests[flow->tmp_entry_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
+			if (!mlx5e_tc_flow_all_encaps_valid(esw_attr))
+				goto offload_to_slow_path;
+			/* update from slow path rule to encap rule */
+			rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, attr);
+			if (IS_ERR(rule)) {
+				err = PTR_ERR(rule);
+				mlx5_core_warn(priv->mdev, "Failed to update cached encapsulation flow, %d\n",
+					       err);
+			} else {
+				flow->rule[0] = rule;
+			}
+		} else {
+offload_to_slow_path:
+			rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
+			/* mark the flow's encap dest as non-valid */
+			esw_attr->dests[flow->tmp_entry_index].flags &=
+				~MLX5_ESW_DEST_ENCAP_VALID;
+
+			if (IS_ERR(rule)) {
+				err = PTR_ERR(rule);
+				mlx5_core_warn(priv->mdev, "Failed to update slow path (encap) flow, %d\n",
+					       err);
+			} else {
+				flow->rule[0] = rule;
+			}
+		}
+		flow_flag_set(flow, OFFLOADED);
+	}
+}
+
+static int mlx5e_update_route_encaps(struct mlx5e_priv *priv,
+				     struct mlx5e_route_entry *r,
+				     struct list_head *flow_list,
+				     bool replace)
+{
+	struct net_device *tunnel_dev;
+	struct mlx5e_encap_entry *e;
+
+	tunnel_dev = __dev_get_by_index(dev_net(priv->netdev), r->tunnel_dev_index);
+	if (!tunnel_dev)
+		return -ENODEV;
+
+	list_for_each_entry(e, &r->encap_entries, route_list) {
+		LIST_HEAD(encap_flows);
+
+		mlx5e_take_all_encap_flows(e, &encap_flows);
+		if (list_empty(&encap_flows))
+			continue;
+
+		if (mlx5e_route_entry_valid(r))
+			mlx5e_invalidate_encap(priv, e, &encap_flows);
+
+		if (!replace) {
+			list_splice(&encap_flows, flow_list);
+			continue;
+		}
+
+		mlx5e_reoffload_encap(priv, tunnel_dev, e, &encap_flows);
+		list_splice(&encap_flows, flow_list);
+	}
+
+	return 0;
+}
+
+static void mlx5e_unoffload_flow_list(struct mlx5e_priv *priv,
+				      struct list_head *flow_list)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow *flow;
+
+	list_for_each_entry(flow, flow_list, tmp_list)
+		if (mlx5e_is_offloaded_flow(flow))
+			mlx5e_tc_unoffload_fdb_rules(esw, flow, flow->attr);
+}
+
+static void mlx5e_reoffload_decap(struct mlx5e_priv *priv,
+				  struct list_head *decap_flows)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow *flow;
+
+	list_for_each_entry(flow, decap_flows, tmp_list) {
+		struct mlx5e_tc_flow_parse_attr *parse_attr;
+		struct mlx5_flow_attr *attr = flow->attr;
+		struct mlx5_flow_handle *rule;
+		struct mlx5_flow_spec *spec;
+		int err;
+
+		if (flow_flag_test(flow, FAILED))
+			continue;
+
+		parse_attr = attr->parse_attr;
+		spec = &parse_attr->spec;
+		err = mlx5e_tc_tun_route_lookup(priv, spec, attr);
+		if (err) {
+			mlx5_core_warn(priv->mdev, "Failed to lookup route for flow, %d\n",
+				       err);
+			continue;
+		}
+
+		rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, attr);
+		if (IS_ERR(rule)) {
+			err = PTR_ERR(rule);
+			mlx5_core_warn(priv->mdev, "Failed to update cached decap flow, %d\n",
+				       err);
+		} else {
+			flow->rule[0] = rule;
+			flow_flag_set(flow, OFFLOADED);
+		}
+	}
+}
+
+static int mlx5e_update_route_decap_flows(struct mlx5e_priv *priv,
+					  struct mlx5e_route_entry *r,
+					  struct list_head *flow_list,
+					  bool replace)
+{
+	struct net_device *tunnel_dev;
+	LIST_HEAD(decap_flows);
+
+	tunnel_dev = __dev_get_by_index(dev_net(priv->netdev), r->tunnel_dev_index);
+	if (!tunnel_dev)
+		return -ENODEV;
+
+	mlx5e_take_all_route_decap_flows(r, &decap_flows);
+	if (mlx5e_route_entry_valid(r))
+		mlx5e_unoffload_flow_list(priv, &decap_flows);
+	if (replace)
+		mlx5e_reoffload_decap(priv, &decap_flows);
+
+	list_splice(&decap_flows, flow_list);
+
+	return 0;
+}
+
+static void mlx5e_tc_fib_event_work(struct work_struct *work)
+{
+	struct mlx5e_tc_fib_event_data *event_data =
+		container_of(work, struct mlx5e_tc_fib_event_data, work);
+	struct net_device *ul_dev = event_data->ul_dev;
+	struct mlx5e_priv *priv = netdev_priv(ul_dev);
+	struct mlx5e_route_entry *r = event_data->r;
+	struct mlx5_eswitch *esw;
+	LIST_HEAD(flow_list);
+	bool replace;
+	int err;
+
+	/* sync with concurrent neigh updates */
+	rtnl_lock();
+	esw = priv->mdev->priv.eswitch;
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	replace = event_data->event == FIB_EVENT_ENTRY_REPLACE;
+
+	if (!mlx5e_route_entry_valid(r) && !replace)
+		goto out;
+
+	err = mlx5e_update_route_encaps(priv, r, &flow_list, replace);
+	if (err)
+		mlx5_core_warn(priv->mdev, "Failed to update route encaps, %d\n",
+			       err);
+
+	err = mlx5e_update_route_decap_flows(priv, r, &flow_list, replace);
+	if (err)
+		mlx5_core_warn(priv->mdev, "Failed to update route decap flows, %d\n",
+			       err);
+
+	if (replace)
+		r->flags |= MLX5E_ROUTE_ENTRY_VALID;
+out:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	rtnl_unlock();
+
+	mlx5e_put_flow_list(priv, &flow_list);
+	mlx5e_route_put(priv, event_data->r);
+	dev_put(event_data->ul_dev);
+	kfree(event_data);
+}
+
+static struct mlx5e_tc_fib_event_data *
+mlx5e_init_fib_work_ipv4(struct mlx5e_priv *priv,
+			 struct net_device *ul_dev,
+			 struct mlx5e_tc_tun_encap *encap,
+			 unsigned long event,
+			 struct fib_notifier_info *info)
+{
+	struct fib_entry_notifier_info *fen_info;
+	struct mlx5e_tc_fib_event_data *fib_work;
+	struct mlx5e_route_entry *r;
+	struct mlx5e_route_key key;
+	struct net_device *fib_dev;
+
+	fen_info = container_of(info, struct fib_entry_notifier_info, info);
+	fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
+	if (fib_dev->netdev_ops != &mlx5e_netdev_ops ||
+	    fen_info->dst_len != 32)
+		return NULL;
+
+	fib_work = mlx5e_tc_init_fib_work(event, ul_dev, GFP_ATOMIC);
+	if (!fib_work)
+		return ERR_PTR(-ENOMEM);
+
+	key.endpoint_ip.v4 = htonl(fen_info->dst);
+	key.ip_version = 4;
+
+	/* Can't fail after this point because releasing reference to r
+	 * requires obtaining sleeping mutex which we can't do in atomic
+	 * context.
+	 */
+	r = mlx5e_route_lookup_for_update(encap, &key);
+	if (!r)
+		goto out;
+	fib_work->r = r;
+	dev_hold(ul_dev);
+
+	return fib_work;
+
+out:
+	kfree(fib_work);
+	return NULL;
+}
+
+static struct mlx5e_tc_fib_event_data *
+mlx5e_init_fib_work_ipv6(struct mlx5e_priv *priv,
+			 struct net_device *ul_dev,
+			 struct mlx5e_tc_tun_encap *encap,
+			 unsigned long event,
+			 struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen_info;
+	struct mlx5e_tc_fib_event_data *fib_work;
+	struct mlx5e_route_entry *r;
+	struct mlx5e_route_key key;
+	struct net_device *fib_dev;
+
+	fen_info = container_of(info, struct fib6_entry_notifier_info, info);
+	fib_dev = fib6_info_nh_dev(fen_info->rt);
+	if (fib_dev->netdev_ops != &mlx5e_netdev_ops ||
+	    fen_info->rt->fib6_dst.plen != 128)
+		return NULL;
+
+	fib_work = mlx5e_tc_init_fib_work(event, ul_dev, GFP_ATOMIC);
+	if (!fib_work)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(&key.endpoint_ip.v6, &fen_info->rt->fib6_dst.addr,
+	       sizeof(fen_info->rt->fib6_dst.addr));
+	key.ip_version = 6;
+
+	/* Can't fail after this point because releasing reference to r
+	 * requires obtaining sleeping mutex which we can't do in atomic
+	 * context.
+	 */
+	r = mlx5e_route_lookup_for_update(encap, &key);
+	if (!r)
+		goto out;
+	fib_work->r = r;
+	dev_hold(ul_dev);
+
+	return fib_work;
+
+out:
+	kfree(fib_work);
+	return NULL;
+}
+
+static int mlx5e_tc_tun_fib_event(struct notifier_block *nb, unsigned long event, void *ptr)
+{
+	struct mlx5e_tc_fib_event_data *fib_work;
+	struct fib_notifier_info *info = ptr;
+	struct mlx5e_tc_tun_encap *encap;
+	struct net_device *ul_dev;
+	struct mlx5e_priv *priv;
+
+	encap = container_of(nb, struct mlx5e_tc_tun_encap, fib_nb);
+	priv = encap->priv;
+	ul_dev = priv->netdev;
+	priv = netdev_priv(ul_dev);
+
+	switch (event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+	case FIB_EVENT_ENTRY_DEL:
+		if (info->family == AF_INET)
+			fib_work = mlx5e_init_fib_work_ipv4(priv, ul_dev, encap, event, info);
+		else if (info->family == AF_INET6)
+			fib_work = mlx5e_init_fib_work_ipv6(priv, ul_dev, encap, event, info);
+		else
+			return NOTIFY_DONE;
+
+		if (!IS_ERR_OR_NULL(fib_work)) {
+			queue_work(priv->wq, &fib_work->work);
+		} else if (IS_ERR(fib_work)) {
+			NL_SET_ERR_MSG_MOD(info->extack, "Failed to init fib work");
+			mlx5_core_warn(priv->mdev, "Failed to init fib work, %ld\n",
+				       PTR_ERR(fib_work));
+		}
+
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_DONE;
+}
+
+struct mlx5e_tc_tun_encap *mlx5e_tc_tun_init(struct mlx5e_priv *priv)
+{
+	struct mlx5e_tc_tun_encap *encap;
+	int err;
+
+	encap = kvzalloc(sizeof(*encap), GFP_KERNEL);
+	if (!encap)
+		return ERR_PTR(-ENOMEM);
+
+	encap->priv = priv;
+	encap->fib_nb.notifier_call = mlx5e_tc_tun_fib_event;
+	spin_lock_init(&encap->route_lock);
+	hash_init(encap->route_tbl);
+	err = register_fib_notifier(dev_net(priv->netdev), &encap->fib_nb,
+				    NULL, NULL);
+	if (err) {
+		kvfree(encap);
+		return ERR_PTR(err);
+	}
+
+	return encap;
+}
+
+void mlx5e_tc_tun_cleanup(struct mlx5e_tc_tun_encap *encap)
+{
+	if (!encap)
+		return;
+
+	unregister_fib_notifier(dev_net(encap->priv->netdev), &encap->fib_nb);
+	flush_workqueue(encap->priv->wq); /* flush fib event works */
+	kvfree(encap);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
index 9939cff6e6c5..3391504d9a08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
@@ -32,4 +32,7 @@ struct ip_tunnel_info *mlx5e_dup_tun_info(const struct ip_tunnel_info *tun_info)
 int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec);
 
+struct mlx5e_tc_tun_encap *mlx5e_tc_tun_init(struct mlx5e_priv *priv);
+void mlx5e_tc_tun_cleanup(struct mlx5e_tc_tun_encap *encap);
+
 #endif /* __MLX5_EN_TC_TUN_ENCAP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index e947921a2d5a..d1696404cca9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -59,6 +59,8 @@ struct mlx5e_neigh_update_table {
 
 struct mlx5_tc_ct_priv;
 struct mlx5e_rep_bond;
+struct mlx5e_tc_tun_encap;
+
 struct mlx5_rep_uplink_priv {
 	/* Filters DB - instantiated by the uplink representor and shared by
 	 * the uplink's VFs
@@ -90,6 +92,9 @@ struct mlx5_rep_uplink_priv {
 
 	/* support eswitch vports bonding */
 	struct mlx5e_rep_bond *bond;
+
+	/* tc tunneling encapsulation private data */
+	struct mlx5e_tc_tun_encap *encap;
 };
 
 struct mlx5e_rep_priv {
@@ -153,6 +158,7 @@ enum {
 	/* set when the encap entry is successfully offloaded into HW */
 	MLX5_ENCAP_ENTRY_VALID     = BIT(0),
 	MLX5_REFORMAT_DECAP        = BIT(1),
+	MLX5_ENCAP_ENTRY_NO_ROUTE  = BIT(2),
 };
 
 struct mlx5e_decap_key {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c5ecb9e4e767..db142ee96510 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1279,11 +1279,11 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	struct net_device *out_dev, *encap_dev = NULL;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
+	bool vf_tun = false, encap_valid = true;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_fc *counter = NULL;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_priv *out_priv;
-	bool encap_valid = true;
 	u32 max_prio, max_chain;
 	int err = 0;
 	int out_index;
@@ -1297,26 +1297,28 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	if (!mlx5e_is_ft_flow(flow) && attr->chain > max_chain) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Requested chain is out of supported range");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto err_out;
 	}
 
 	max_prio = mlx5_chains_get_prio_range(esw_chains(esw));
 	if (attr->prio > max_prio) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Requested priority is out of supported range");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto err_out;
 	}
 
 	if (flow_flag_test(flow, TUN_RX)) {
 		err = mlx5e_attach_decap_route(priv, flow);
 		if (err)
-			return err;
+			goto err_out;
 	}
 
 	if (flow_flag_test(flow, L3_TO_L2_DECAP)) {
 		err = mlx5e_attach_decap(priv, flow, extack);
 		if (err)
-			return err;
+			goto err_out;
 	}
 
 	parse_attr = attr->parse_attr;
@@ -1334,8 +1336,11 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
 					 extack, &encap_dev, &encap_valid);
 		if (err)
-			return err;
+			goto err_out;
 
+		if (esw_attr->dests[out_index].flags &
+		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+			vf_tun = true;
 		out_priv = netdev_priv(encap_dev);
 		rpriv = out_priv->ppriv;
 		esw_attr->dests[out_index].rep = rpriv->rep;
@@ -1344,19 +1349,27 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 
 	err = mlx5_eswitch_add_vlan_action(esw, attr);
 	if (err)
-		return err;
+		goto err_out;
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !(attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR)) {
-		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
-		if (err)
-			return err;
+		if (vf_tun) {
+			err = mlx5e_tc_add_flow_mod_hdr(priv, parse_attr, flow);
+			if (err)
+				goto err_out;
+		} else {
+			err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
+			if (err)
+				goto err_out;
+		}
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
 		counter = mlx5_fc_create(esw_attr->counter_dev, true);
-		if (IS_ERR(counter))
-			return PTR_ERR(counter);
+		if (IS_ERR(counter)) {
+			err = PTR_ERR(counter);
+			goto err_out;
+		}
 
 		attr->counter = counter;
 	}
@@ -1370,12 +1383,17 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	else
 		flow->rule[0] = mlx5e_tc_offload_fdb_rules(esw, flow, &parse_attr->spec, attr);
 
-	if (IS_ERR(flow->rule[0]))
-		return PTR_ERR(flow->rule[0]);
-	else
-		flow_flag_set(flow, OFFLOADED);
+	if (IS_ERR(flow->rule[0])) {
+		err = PTR_ERR(flow->rule[0]);
+		goto err_out;
+	}
+	flow_flag_set(flow, OFFLOADED);
 
 	return 0;
+
+err_out:
+	flow_flag_set(flow, FAILED);
+	return err;
 }
 
 static bool mlx5_flow_has_geneve_opt(struct mlx5e_tc_flow *flow)
@@ -1397,6 +1415,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
+	bool vf_tun = false;
 	int out_index;
 
 	esw_attr = attr->esw_attr;
@@ -1421,20 +1440,26 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		mlx5e_detach_decap_route(priv, flow);
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
+		if (esw_attr->dests[out_index].flags &
+		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+			vf_tun = true;
 		if (esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP) {
 			mlx5e_detach_encap(priv, flow, out_index);
 			kfree(attr->parse_attr->tun_info[out_index]);
 		}
 	}
-	kvfree(attr->parse_attr);
-	kvfree(attr->esw_attr->rx_tun_attr);
 
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		dealloc_mod_hdr_actions(&attr->parse_attr->mod_hdr_acts);
-		mlx5e_detach_mod_hdr(priv, flow);
+		if (vf_tun && attr->modify_hdr)
+			mlx5_modify_header_dealloc(priv->mdev, attr->modify_hdr);
+		else
+			mlx5e_detach_mod_hdr(priv, flow);
 	}
+	kvfree(attr->parse_attr);
+	kvfree(attr->esw_attr->rx_tun_attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
@@ -4044,7 +4069,6 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	return flow;
 
 err_free:
-	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 	mlx5e_flow_put(priv, flow);
 out:
 	return ERR_PTR(err);
@@ -4189,6 +4213,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	return 0;
 
 err_free:
+	flow_flag_set(flow, FAILED);
 	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 	mlx5e_flow_put(priv, flow);
 out:
@@ -4724,8 +4749,14 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 
 	lockdep_set_class(&tc_ht->mutex, &tc_ht_lock_key);
 
+	uplink_priv->encap = mlx5e_tc_tun_init(priv);
+	if (IS_ERR(uplink_priv->encap))
+		goto err_register_fib_notifier;
+
 	return err;
 
+err_register_fib_notifier:
+	rhashtable_destroy(tc_ht);
 err_ht_init:
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 err_enc_opts_mapping:
@@ -4742,10 +4773,11 @@ void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
 
-	rhashtable_free_and_destroy(tc_ht, _mlx5e_tc_del_flow, NULL);
-
 	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
 
+	rhashtable_free_and_destroy(tc_ht, _mlx5e_tc_del_flow, NULL);
+	mlx5e_tc_tun_cleanup(uplink_priv->encap);
+
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 	mapping_destroy(uplink_priv->tunnel_mapping);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 310c405e81d7..aba17835465b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1830,7 +1830,6 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	mutex_init(&esw->offloads.decap_tbl_lock);
 	hash_init(esw->offloads.decap_tbl);
 	mlx5e_mod_hdr_tbl_init(&esw->offloads.mod_hdr);
-	hash_init(esw->offloads.route_tbl);
 	atomic64_set(&esw->offloads.num_flows, 0);
 	ida_init(&esw->offloads.vport_metadata_ida);
 	xa_init_flags(&esw->offloads.vhca_map, XA_FLAGS_ALLOC);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index b90724e27960..fdf5c8c05c1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -214,7 +214,6 @@ struct mlx5_esw_offload {
 	struct mutex peer_mutex;
 	struct mutex encap_tbl_lock; /* protects encap_tbl */
 	DECLARE_HASHTABLE(encap_tbl, 8);
-	DECLARE_HASHTABLE(route_tbl, 8);
 	struct mutex decap_tbl_lock; /* protects decap_tbl */
 	DECLARE_HASHTABLE(decap_tbl, 8);
 	struct mod_hdr_tbl mod_hdr;
@@ -424,6 +423,7 @@ struct mlx5_esw_flow_attr {
 		struct mlx5_pkt_reformat *pkt_reformat;
 		struct mlx5_core_dev *mdev;
 		struct mlx5_termtbl_handle *termtbl;
+		int src_port_rewrite_act_id;
 	} dests[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5_rx_tun_attr *rx_tun_attr;
 	struct mlx5_pkt_reformat *decap_pkt_reformat;
-- 
2.29.2

