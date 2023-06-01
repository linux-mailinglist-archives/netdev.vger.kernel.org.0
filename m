Return-Path: <netdev+bounces-7002-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 938D07192ED
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EE3D281643
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B04D30A;
	Thu,  1 Jun 2023 06:01:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE22A94A
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FFCC433B0;
	Thu,  1 Jun 2023 06:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599297;
	bh=H4Ua7hOd1ZoHKvUiqkHAHF86GnBBWyqu2iMHmMydmS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhuKSvrSkWr0rGc8GJ77hbcQ5Mq/lnJDDWpOafrSkX9ju+hIlGVkS32g1MwE1K0kj
	 qfyzvaMCdR7mjLGvfIiFtl/Jmc1X7riNit8sZiKbgSRiwSo0qYcexbSfjWYGRlz23k
	 MzbwoUxvL/B0MYzgAdVPnw9ZS7ca68cXTXbR6AFrV91qD7EVfyHUxgnsEZgomamgIf
	 JFm88NSxb3peuQE+1aemS+06moIzU5ko3EIcSYSw/DaE8y5HKfCwcuzuNCenyWAB2O
	 8mP7rbIcZ7vthA0rvSyGin/e/7001qGliH0vfV/mSQlHCn7ffshrBDV1Ul0girlxDp
	 fmkq80FXN2SGg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next 05/14] net/mlx5e: Handle offloads flows per peer
Date: Wed, 31 May 2023 23:01:09 -0700
Message-Id: <20230601060118.154015-6-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601060118.154015-1-saeed@kernel.org>
References: <20230601060118.154015-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Currently, E-switch offloads table have a list of all flows that
create a peer_flow over the peer eswitch.
In order to support more than one peer, extend E-switch offloads
table peer_flow to hold an array of lists, where each peer have
dedicate index via mlx5_get_dev_index(). Thereafter, extend original
flow to hold an array of peers as well.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 37 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  4 +-
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 8a500a966f06..6cc23af66b5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -96,7 +96,7 @@ struct mlx5e_tc_flow {
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head hairpin; /* flows sharing the same hairpin */
-	struct list_head peer;    /* flows with peer flow */
+	struct list_head peer[MLX5_MAX_PORTS];    /* flows with peer flow */
 	struct list_head unready; /* flows not ready to be offloaded (e.g
 				   * due to missing route)
 				   */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2135c0ef8560..13071d184d88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2065,7 +2065,8 @@ void mlx5e_put_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list)
 		mlx5e_flow_put(priv, flow);
 }
 
-static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
+static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow,
+				       int peer_index)
 {
 	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow *peer_flow;
@@ -2076,18 +2077,32 @@ static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
 		return;
 
 	mutex_lock(&esw->offloads.peer_mutex);
-	list_del(&flow->peer);
+	list_del(&flow->peer[peer_index]);
 	mutex_unlock(&esw->offloads.peer_mutex);
 
-	flow_flag_clear(flow, DUP);
-
 	list_for_each_entry_safe(peer_flow, tmp, &flow->peer_flows, peer_flows) {
+		if (peer_index != mlx5_get_dev_index(peer_flow->priv->mdev))
+			continue;
 		if (refcount_dec_and_test(&peer_flow->refcnt)) {
 			mlx5e_tc_del_fdb_flow(peer_flow->priv, peer_flow);
 			list_del(&peer_flow->peer_flows);
 			kfree(peer_flow);
 		}
 	}
+
+	if (list_empty(&flow->peer_flows))
+		flow_flag_clear(flow, DUP);
+}
+
+static void mlx5e_tc_del_fdb_peers_flow(struct mlx5e_tc_flow *flow)
+{
+	int i;
+
+	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		if (i == mlx5_get_dev_index(flow->priv->mdev))
+			continue;
+		mlx5e_tc_del_fdb_peer_flow(flow, i);
+	}
 }
 
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
@@ -2102,7 +2117,7 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			mlx5e_tc_del_fdb_flow(priv, flow);
 			return;
 		}
-		mlx5e_tc_del_fdb_peer_flow(flow);
+		mlx5e_tc_del_fdb_peers_flow(flow);
 		mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 		mlx5e_tc_del_fdb_flow(priv, flow);
 	} else {
@@ -4486,6 +4501,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	int i = mlx5_get_dev_index(peer_esw->dev);
 	struct mlx5e_rep_priv *peer_urpriv;
 	struct mlx5e_tc_flow *peer_flow;
 	struct mlx5_core_dev *in_mdev;
@@ -4518,7 +4534,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
 	flow_flag_set(flow, DUP);
 	mutex_lock(&esw->offloads.peer_mutex);
-	list_add_tail(&flow->peer, &esw->offloads.peer_flows);
+	list_add_tail(&flow->peer[i], &esw->offloads.peer_flows[i]);
 	mutex_unlock(&esw->offloads.peer_mutex);
 
 out:
@@ -5371,9 +5387,14 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
 void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw)
 {
 	struct mlx5e_tc_flow *flow, *tmp;
+	int i;
 
-	list_for_each_entry_safe(flow, tmp, &esw->offloads.peer_flows, peer)
-		mlx5e_tc_del_fdb_peer_flow(flow);
+	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		if (i == mlx5_get_dev_index(esw->dev))
+			continue;
+		list_for_each_entry_safe(flow, tmp, &esw->offloads.peer_flows[i], peer[i])
+			mlx5e_tc_del_fdb_peers_flow(flow);
+	}
 }
 
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index f70124ad71cf..eadc39542e5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -249,7 +249,7 @@ struct mlx5_esw_offload {
 	struct mlx5_flow_group *vport_rx_drop_group;
 	struct mlx5_flow_handle *vport_rx_drop_rule;
 	struct xarray vport_reps;
-	struct list_head peer_flows;
+	struct list_head peer_flows[MLX5_MAX_PORTS];
 	struct mutex peer_mutex;
 	struct mutex encap_tbl_lock; /* protects encap_tbl */
 	DECLARE_HASHTABLE(encap_tbl, 8);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9526382f1573..a767f3d52c76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2825,8 +2825,10 @@ static int mlx5_esw_offloads_devcom_event(int event,
 void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw)
 {
 	struct mlx5_devcom *devcom = esw->dev->priv.devcom;
+	int i;
 
-	INIT_LIST_HEAD(&esw->offloads.peer_flows);
+	for (i = 0; i < MLX5_MAX_PORTS; i++)
+		INIT_LIST_HEAD(&esw->offloads.peer_flows[i]);
 	mutex_init(&esw->offloads.peer_mutex);
 
 	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
-- 
2.40.1


