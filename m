Return-Path: <netdev+bounces-7561-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 131B07209A7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 865E31C21286
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68AB21F928;
	Fri,  2 Jun 2023 19:13:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32BE1F17D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C03AC43445;
	Fri,  2 Jun 2023 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685733194;
	bh=NQQohL6Fgi9c0mGA4KjcDIQnZf5fs9ESt3G7nswZ6rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWoRCEiQJ+KTzf1Q7xdZ6RuYquh7ajXiLUJPwHmcZh2D4O8pEkwP1QGo0Z286SyX9
	 FbnXN+arq0kRpSKGocvoitnuV7DQfLGsIGqS1FYG0kVtkud5coApro/YMv/GsBhJX1
	 r8CrvGT3HhHFYCU2d1UQWJsFHEZoiYmyu2FZvBQ1hAIErZDrwteBGbbciZQCvCZXUo
	 hPXMw+bP/Z9nQk1FLz1Hzqs/OiZ5gWjGeQoL/8pko1lBSi1mwT3Q94/w2wQAZh67BQ
	 CzErAudXh4H1cxO/T06cxj5ExGPrb2dAKhAeBqrmnsuzJlDfIei1GkTt/o6sWjTx4z
	 Talh8bV5XeGYg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next V2 13/14] net/mlx5: Devcom, introduce devcom_for_each_peer_entry
Date: Fri,  2 Jun 2023 12:13:00 -0700
Message-Id: <20230602191301.47004-14-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602191301.47004-1-saeed@kernel.org>
References: <20230602191301.47004-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

Introduce generic APIs which will retrieve all peers.
This API replace mlx5_devcom_get/release_peer_data which retrieve
only a single peer.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 94 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 44 +++++----
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 30 ++++--
 .../mellanox/mlx5/core/esw/bridge_mcast.c     | 21 ++++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  7 ++
 .../ethernet/mellanox/mlx5/core/lib/devcom.c  | 89 +++++++++++++-----
 .../ethernet/mellanox/mlx5/core/lib/devcom.h  | 23 ++++-
 7 files changed, 209 insertions(+), 99 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 51e147c0dd71..965a8261c99b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -398,25 +398,64 @@ static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 	}
 }
 
+static int mlx5e_sqs2vport_add_peers_rules(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep,
+					   struct mlx5_devcom *devcom,
+					   struct mlx5e_rep_sq *rep_sq, int i)
+{
+	struct mlx5_eswitch *peer_esw = NULL;
+	struct mlx5_flow_handle *flow_rule;
+	int tmp;
+
+	mlx5_devcom_for_each_peer_entry(devcom, MLX5_DEVCOM_ESW_OFFLOADS,
+					peer_esw, tmp) {
+		int peer_rule_idx = mlx5_get_dev_index(peer_esw->dev);
+		struct mlx5e_rep_sq_peer *sq_peer;
+		int err;
+
+		sq_peer = kzalloc(sizeof(*sq_peer), GFP_KERNEL);
+		if (!sq_peer)
+			return -ENOMEM;
+
+		flow_rule = mlx5_eswitch_add_send_to_vport_rule(peer_esw, esw,
+								rep, rep_sq->sqn);
+		if (IS_ERR(flow_rule)) {
+			kfree(sq_peer);
+			return PTR_ERR(flow_rule);
+		}
+
+		sq_peer->rule = flow_rule;
+		sq_peer->peer = peer_esw;
+		err = xa_insert(&rep_sq->sq_peer, peer_rule_idx, sq_peer, GFP_KERNEL);
+		if (err) {
+			kfree(sq_peer);
+			mlx5_eswitch_del_send_to_vport_rule(flow_rule);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 				 struct mlx5_eswitch_rep *rep,
 				 u32 *sqns_array, int sqns_num)
 {
-	struct mlx5_eswitch *peer_esw = NULL;
 	struct mlx5_flow_handle *flow_rule;
-	struct mlx5e_rep_sq_peer *sq_peer;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_rep_sq *rep_sq;
+	struct mlx5_devcom *devcom;
+	bool devcom_locked = false;
 	int err;
 	int i;
 
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
 		return 0;
 
+	devcom = esw->dev->priv.devcom;
 	rpriv = mlx5e_rep_to_rep_priv(rep);
-	if (mlx5_devcom_comp_is_ready(esw->dev->priv.devcom, MLX5_DEVCOM_ESW_OFFLOADS))
-		peer_esw = mlx5_devcom_get_peer_data(esw->dev->priv.devcom,
-						     MLX5_DEVCOM_ESW_OFFLOADS);
+	if (mlx5_devcom_comp_is_ready(devcom, MLX5_DEVCOM_ESW_OFFLOADS) &&
+	    mlx5_devcom_for_each_peer_begin(devcom, MLX5_DEVCOM_ESW_OFFLOADS))
+		devcom_locked = true;
 
 	for (i = 0; i < sqns_num; i++) {
 		rep_sq = kzalloc(sizeof(*rep_sq), GFP_KERNEL);
@@ -424,7 +463,6 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 			err = -ENOMEM;
 			goto out_err;
 		}
-		xa_init(&rep_sq->sq_peer);
 
 		/* Add re-inject rule to the PF/representor sqs */
 		flow_rule = mlx5_eswitch_add_send_to_vport_rule(esw, esw, rep,
@@ -437,50 +475,30 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 		rep_sq->send_to_vport_rule = flow_rule;
 		rep_sq->sqn = sqns_array[i];
 
-		if (peer_esw) {
-			int peer_rule_idx = mlx5_get_dev_index(peer_esw->dev);
-
-			sq_peer = kzalloc(sizeof(*sq_peer), GFP_KERNEL);
-			if (!sq_peer) {
-				err = -ENOMEM;
-				goto out_sq_peer_err;
-			}
-
-			flow_rule = mlx5_eswitch_add_send_to_vport_rule(peer_esw, esw,
-									rep, sqns_array[i]);
-			if (IS_ERR(flow_rule)) {
-				err = PTR_ERR(flow_rule);
-				goto out_flow_rule_err;
+		xa_init(&rep_sq->sq_peer);
+		if (devcom_locked) {
+			err = mlx5e_sqs2vport_add_peers_rules(esw, rep, devcom, rep_sq, i);
+			if (err) {
+				mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
+				xa_destroy(&rep_sq->sq_peer);
+				kfree(rep_sq);
+				goto out_err;
 			}
-
-			sq_peer->rule = flow_rule;
-			sq_peer->peer = peer_esw;
-			err = xa_insert(&rep_sq->sq_peer, peer_rule_idx, sq_peer, GFP_KERNEL);
-			if (err)
-				goto out_xa_err;
 		}
 
 		list_add(&rep_sq->list, &rpriv->vport_sqs_list);
 	}
 
-	if (peer_esw)
-		mlx5_devcom_release_peer_data(esw->dev->priv.devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	if (devcom_locked)
+		mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 
 	return 0;
 
-out_xa_err:
-	mlx5_eswitch_del_send_to_vport_rule(flow_rule);
-out_flow_rule_err:
-	kfree(sq_peer);
-out_sq_peer_err:
-	mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
-	xa_destroy(&rep_sq->sq_peer);
-	kfree(rep_sq);
 out_err:
 	mlx5e_sqs2vport_stop(esw, rep);
 
-	if (peer_esw)
-		mlx5_devcom_release_peer_data(esw->dev->priv.devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	if (devcom_locked)
+		mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9739a61026d8..88631fb9f966 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1670,6 +1670,7 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	struct mlx5_eswitch *esw;
 	u16 vhca_id;
 	int err;
+	int i;
 
 	out_priv = netdev_priv(out_dev);
 	esw = out_priv->mdev->priv.eswitch;
@@ -1686,8 +1687,13 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 
 	rcu_read_lock();
 	devcom = out_priv->mdev->priv.devcom;
-	esw = mlx5_devcom_get_peer_data_rcu(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-	err = esw ? mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport) : -ENODEV;
+	err = -ENODEV;
+	mlx5_devcom_for_each_peer_entry_rcu(devcom, MLX5_DEVCOM_ESW_OFFLOADS,
+					    esw, i) {
+		err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+		if (!err)
+			break;
+	}
 	rcu_read_unlock();
 
 	return err;
@@ -2025,15 +2031,14 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 {
 	if (mlx5e_is_eswitch_flow(flow)) {
 		struct mlx5_devcom *devcom = flow->priv->mdev->priv.devcom;
-		struct mlx5_eswitch *peer_esw;
 
-		peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-		if (!peer_esw) {
+		if (!mlx5_devcom_for_each_peer_begin(devcom, MLX5_DEVCOM_ESW_OFFLOADS)) {
 			mlx5e_tc_del_fdb_flow(priv, flow);
 			return;
 		}
+
 		mlx5e_tc_del_fdb_peers_flow(flow);
-		mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+		mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 		mlx5e_tc_del_fdb_flow(priv, flow);
 	} else {
 		mlx5e_tc_del_nic_flow(priv, flow);
@@ -4472,6 +4477,7 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *peer_esw;
 	struct mlx5e_tc_flow *flow;
 	int err;
+	int i;
 
 	flow = __mlx5e_add_fdb_flow(priv, f, flow_flags, filter_dev, in_rep,
 				    in_mdev);
@@ -4483,23 +4489,27 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		return 0;
 	}
 
-	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-	if (!peer_esw) {
+	if (!mlx5_devcom_for_each_peer_begin(devcom, MLX5_DEVCOM_ESW_OFFLOADS)) {
 		err = -ENODEV;
 		goto clean_flow;
 	}
 
-	err = mlx5e_tc_add_fdb_peer_flow(f, flow, flow_flags, peer_esw);
-	if (err)
-		goto peer_clean;
-	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	mlx5_devcom_for_each_peer_entry(devcom,
+					MLX5_DEVCOM_ESW_OFFLOADS,
+					peer_esw, i) {
+		err = mlx5e_tc_add_fdb_peer_flow(f, flow, flow_flags, peer_esw);
+		if (err)
+			goto peer_clean;
+	}
 
-	*__flow = flow;
+	mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 
+	*__flow = flow;
 	return 0;
 
 peer_clean:
-	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	mlx5e_tc_del_fdb_peers_flow(flow);
+	mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 clean_flow:
 	mlx5e_tc_del_fdb_flow(priv, flow);
 	return err;
@@ -4719,7 +4729,6 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 {
 	struct mlx5_devcom *devcom = priv->mdev->priv.devcom;
 	struct rhashtable *tc_ht = get_tc_ht(priv, flags);
-	struct mlx5_eswitch *peer_esw;
 	struct mlx5e_tc_flow *flow;
 	struct mlx5_fc *counter;
 	u64 lastuse = 0;
@@ -4754,8 +4763,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	/* Under multipath it's possible for one rule to be currently
 	 * un-offloaded while the other rule is offloaded.
 	 */
-	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-	if (!peer_esw)
+	if (!mlx5_devcom_for_each_peer_begin(devcom, MLX5_DEVCOM_ESW_OFFLOADS))
 		goto out;
 
 	if (flow_flag_test(flow, DUP)) {
@@ -4786,7 +4794,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	}
 
 no_peer_counter:
-	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 out:
 	flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
 			  FLOW_ACTION_HW_STATS_DELAYED);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 1ba03e219111..bea7cc645461 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -647,22 +647,35 @@ mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr,
 }
 
 static struct mlx5_flow_handle *
-mlx5_esw_bridge_ingress_flow_peer_create(u16 vport_num, const unsigned char *addr,
+mlx5_esw_bridge_ingress_flow_peer_create(u16 vport_num, u16 esw_owner_vhca_id,
+					 const unsigned char *addr,
 					 struct mlx5_esw_bridge_vlan *vlan, u32 counter_id,
 					 struct mlx5_esw_bridge *bridge)
 {
 	struct mlx5_devcom *devcom = bridge->br_offloads->esw->dev->priv.devcom;
+	struct mlx5_eswitch *tmp, *peer_esw = NULL;
 	static struct mlx5_flow_handle *handle;
-	struct mlx5_eswitch *peer_esw;
+	int i;
 
-	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-	if (!peer_esw)
+	if (!mlx5_devcom_for_each_peer_begin(devcom, MLX5_DEVCOM_ESW_OFFLOADS))
 		return ERR_PTR(-ENODEV);
 
+	mlx5_devcom_for_each_peer_entry(devcom,
+					MLX5_DEVCOM_ESW_OFFLOADS,
+					tmp, i) {
+		if (mlx5_esw_is_owner(tmp, vport_num, esw_owner_vhca_id)) {
+			peer_esw = tmp;
+			break;
+		}
+	}
+	if (!peer_esw) {
+		mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+		return ERR_PTR(-ENODEV);
+	}
+
 	handle = mlx5_esw_bridge_ingress_flow_with_esw_create(vport_num, addr, vlan, counter_id,
 							      bridge, peer_esw);
-
-	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 	return handle;
 }
 
@@ -1369,8 +1382,9 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, u16 esw_ow
 	entry->ingress_counter = counter;
 
 	handle = peer ?
-		mlx5_esw_bridge_ingress_flow_peer_create(vport_num, addr, vlan,
-							 mlx5_fc_id(counter), bridge) :
+		mlx5_esw_bridge_ingress_flow_peer_create(vport_num, esw_owner_vhca_id,
+							 addr, vlan, mlx5_fc_id(counter),
+							 bridge) :
 		mlx5_esw_bridge_ingress_flow_create(vport_num, addr, vlan,
 						    mlx5_fc_id(counter), bridge);
 	if (IS_ERR(handle)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
index 2eae594a5e80..2455f8b93c1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
@@ -540,16 +540,29 @@ static struct mlx5_flow_handle *
 mlx5_esw_bridge_mcast_filter_flow_peer_create(struct mlx5_esw_bridge_port *port)
 {
 	struct mlx5_devcom *devcom = port->bridge->br_offloads->esw->dev->priv.devcom;
+	struct mlx5_eswitch *tmp, *peer_esw = NULL;
 	static struct mlx5_flow_handle *handle;
-	struct mlx5_eswitch *peer_esw;
+	int i;
 
-	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-	if (!peer_esw)
+	if (!mlx5_devcom_for_each_peer_begin(devcom, MLX5_DEVCOM_ESW_OFFLOADS))
 		return ERR_PTR(-ENODEV);
 
+	mlx5_devcom_for_each_peer_entry(devcom,
+					MLX5_DEVCOM_ESW_OFFLOADS,
+					tmp, i) {
+		if (mlx5_esw_is_owner(tmp, port->vport_num, port->esw_owner_vhca_id)) {
+			peer_esw = tmp;
+			break;
+		}
+	}
+	if (!peer_esw) {
+		mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+		return ERR_PTR(-ENODEV);
+	}
+
 	handle = mlx5_esw_bridge_mcast_flow_with_esw_create(port, peer_esw);
 
-	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 	return handle;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index d6e4ca436f39..c42c16d9ccbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -585,6 +585,13 @@ mlx5_esw_is_manager_vport(const struct mlx5_eswitch *esw, u16 vport_num)
 	return esw->manager_vport == vport_num;
 }
 
+static inline bool mlx5_esw_is_owner(struct mlx5_eswitch *esw, u16 vport_num,
+				     u16 esw_owner_vhca_id)
+{
+	return esw_owner_vhca_id == MLX5_CAP_GEN(esw->dev, vhca_id) ||
+		(vport_num == MLX5_VPORT_UPLINK && mlx5_lag_is_master(esw->dev));
+}
+
 static inline u16 mlx5_eswitch_first_host_vport_num(struct mlx5_core_dev *dev)
 {
 	return mlx5_core_is_ecpf_esw_manager(dev) ?
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 7446900a589e..96a3b7b9a5cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -239,55 +239,92 @@ bool mlx5_devcom_comp_is_ready(struct mlx5_devcom *devcom,
 	return READ_ONCE(devcom->priv->components[id].ready);
 }
 
-void *mlx5_devcom_get_peer_data(struct mlx5_devcom *devcom,
-				enum mlx5_devcom_components id)
+bool mlx5_devcom_for_each_peer_begin(struct mlx5_devcom *devcom,
+				     enum mlx5_devcom_components id)
 {
 	struct mlx5_devcom_component *comp;
-	int i;
 
 	if (IS_ERR_OR_NULL(devcom))
-		return NULL;
+		return false;
 
 	comp = &devcom->priv->components[id];
 	down_read(&comp->sem);
 	if (!READ_ONCE(comp->ready)) {
 		up_read(&comp->sem);
-		return NULL;
+		return false;
 	}
 
-	for (i = 0; i < MLX5_DEVCOM_PORTS_SUPPORTED; i++)
-		if (i != devcom->idx)
-			break;
+	return true;
+}
+
+void mlx5_devcom_for_each_peer_end(struct mlx5_devcom *devcom,
+				   enum mlx5_devcom_components id)
+{
+	struct mlx5_devcom_component *comp = &devcom->priv->components[id];
 
-	return rcu_dereference_protected(comp->device[i].data, lockdep_is_held(&comp->sem));
+	up_read(&comp->sem);
 }
 
-void *mlx5_devcom_get_peer_data_rcu(struct mlx5_devcom *devcom, enum mlx5_devcom_components id)
+void *mlx5_devcom_get_next_peer_data(struct mlx5_devcom *devcom,
+				     enum mlx5_devcom_components id,
+				     int *i)
 {
 	struct mlx5_devcom_component *comp;
-	int i;
+	void *ret;
+	int idx;
 
-	if (IS_ERR_OR_NULL(devcom))
-		return NULL;
+	comp = &devcom->priv->components[id];
 
-	for (i = 0; i < MLX5_DEVCOM_PORTS_SUPPORTED; i++)
-		if (i != devcom->idx)
-			break;
+	if (*i == MLX5_DEVCOM_PORTS_SUPPORTED)
+		return NULL;
+	for (idx = *i; idx < MLX5_DEVCOM_PORTS_SUPPORTED; idx++) {
+		if (idx != devcom->idx) {
+			ret = rcu_dereference_protected(comp->device[idx].data,
+							lockdep_is_held(&comp->sem));
+			if (ret)
+				break;
+		}
+	}
 
-	comp = &devcom->priv->components[id];
-	/* This can change concurrently, however 'data' pointer will remain
-	 * valid for the duration of RCU read section.
-	 */
-	if (!READ_ONCE(comp->ready))
+	if (idx == MLX5_DEVCOM_PORTS_SUPPORTED) {
+		*i = idx;
 		return NULL;
+	}
+	*i = idx + 1;
 
-	return rcu_dereference(comp->device[i].data);
+	return ret;
 }
 
-void mlx5_devcom_release_peer_data(struct mlx5_devcom *devcom,
-				   enum mlx5_devcom_components id)
+void *mlx5_devcom_get_next_peer_data_rcu(struct mlx5_devcom *devcom,
+					 enum mlx5_devcom_components id,
+					 int *i)
 {
-	struct mlx5_devcom_component *comp = &devcom->priv->components[id];
+	struct mlx5_devcom_component *comp;
+	void *ret;
+	int idx;
 
-	up_read(&comp->sem);
+	comp = &devcom->priv->components[id];
+
+	if (*i == MLX5_DEVCOM_PORTS_SUPPORTED)
+		return NULL;
+	for (idx = *i; idx < MLX5_DEVCOM_PORTS_SUPPORTED; idx++) {
+		if (idx != devcom->idx) {
+			/* This can change concurrently, however 'data' pointer will remain
+			 * valid for the duration of RCU read section.
+			 */
+			if (!READ_ONCE(comp->ready))
+				return NULL;
+			ret = rcu_dereference(comp->device[idx].data);
+			if (ret)
+				break;
+		}
+	}
+
+	if (idx == MLX5_DEVCOM_PORTS_SUPPORTED) {
+		*i = idx;
+		return NULL;
+	}
+	*i = idx + 1;
+
+	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
index d465de8459b4..b7f72f1a5367 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
@@ -39,11 +39,24 @@ void mlx5_devcom_comp_set_ready(struct mlx5_devcom *devcom,
 bool mlx5_devcom_comp_is_ready(struct mlx5_devcom *devcom,
 			       enum mlx5_devcom_components id);
 
-void *mlx5_devcom_get_peer_data(struct mlx5_devcom *devcom,
-				enum mlx5_devcom_components id);
-void *mlx5_devcom_get_peer_data_rcu(struct mlx5_devcom *devcom, enum mlx5_devcom_components id);
-void mlx5_devcom_release_peer_data(struct mlx5_devcom *devcom,
+bool mlx5_devcom_for_each_peer_begin(struct mlx5_devcom *devcom,
+				     enum mlx5_devcom_components id);
+void mlx5_devcom_for_each_peer_end(struct mlx5_devcom *devcom,
 				   enum mlx5_devcom_components id);
+void *mlx5_devcom_get_next_peer_data(struct mlx5_devcom *devcom,
+				     enum mlx5_devcom_components id, int *i);
 
-#endif
+#define mlx5_devcom_for_each_peer_entry(devcom, id, data, i)			\
+	for (i = 0, data = mlx5_devcom_get_next_peer_data(devcom, id, &i);	\
+	     data;								\
+	     data = mlx5_devcom_get_next_peer_data(devcom, id, &i))
+
+void *mlx5_devcom_get_next_peer_data_rcu(struct mlx5_devcom *devcom,
+					 enum mlx5_devcom_components id, int *i);
 
+#define mlx5_devcom_for_each_peer_entry_rcu(devcom, id, data, i)		\
+	for (i = 0, data = mlx5_devcom_get_next_peer_data_rcu(devcom, id, &i);	\
+	     data;								\
+	     data = mlx5_devcom_get_next_peer_data_rcu(devcom, id, &i))
+
+#endif
-- 
2.40.1


