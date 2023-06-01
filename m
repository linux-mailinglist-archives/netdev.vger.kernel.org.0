Return-Path: <netdev+bounces-6999-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D5B7192E9
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F28DC1C20FD8
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D1BBA45;
	Thu,  1 Jun 2023 06:01:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BFBA930
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0E3C4339C;
	Thu,  1 Jun 2023 06:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599294;
	bh=RELoGpaXKG4fal/vX/N/owc82xRdY5THHUZL04EUjso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLM0TNP2t1X0VForEIJlSFm0l1B5Ujfg+GVn5C1mSoC2k+2OOgAxBiSEoyAn33pdW
	 4Bp3lxBMZ88+jpnxrgWFhiy+gF13n82AD+3ijuiZVD39Ay4jNQx6droYTjkNuXVG7D
	 7Sz1cJcIrGaCWIbsiQXRhPMrIDE96rml0OzPDcQStB7rx0DLXXy6BtvQtcrLJvCE27
	 cN/KTWMkciLulRdEpfdmPSvwyBthllz1Ug81lWGLcku+i746JipiClXArOtQWiPOzM
	 WfbhCD0E3koyDP7kSd8XnuIlpBC2JqOsTbkGAetdXa9mTKnwKscIQAerwoImb2y5Iy
	 CgKnLAlp10kqQ==
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
	Roi Dayan <roid@nvidia.com>
Subject: [net-next 03/14] net/mlx5e: rep, store send to vport rules per peer
Date: Wed, 31 May 2023 23:01:07 -0700
Message-Id: <20230601060118.154015-4-saeed@kernel.org>
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

From: Mark Bloch <mbloch@nvidia.com>

Each representor, for each send queue, is holding a
send_to_vport rule for the peer eswitch.

In order to support more than one peer, and to map between the peer
rules and peer eswitches, refactor representor to hold both the peer
rules and pointer to the peer eswitches.
This enables mlx5 to store send_to_vport rules per peer, where each
peer have dedicate index via mlx5_get_dev_index().

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 97 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  7 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 18 ++--
 3 files changed, 96 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1fc386eccaf8..13d69c5634ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -373,7 +373,9 @@ static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 				 struct mlx5_eswitch_rep *rep)
 {
 	struct mlx5e_rep_sq *rep_sq, *tmp;
+	struct mlx5e_rep_sq_peer *sq_peer;
 	struct mlx5e_rep_priv *rpriv;
+	unsigned long i;
 
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
 		return;
@@ -381,8 +383,15 @@ static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 	rpriv = mlx5e_rep_to_rep_priv(rep);
 	list_for_each_entry_safe(rep_sq, tmp, &rpriv->vport_sqs_list, list) {
 		mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
-		if (rep_sq->send_to_vport_rule_peer)
-			mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule_peer);
+		xa_for_each(&rep_sq->sq_peer, i, sq_peer) {
+			if (sq_peer->rule)
+				mlx5_eswitch_del_send_to_vport_rule(sq_peer->rule);
+
+			xa_erase(&rep_sq->sq_peer, i);
+			kfree(sq_peer);
+		}
+
+		xa_destroy(&rep_sq->sq_peer);
 		list_del(&rep_sq->list);
 		kfree(rep_sq);
 	}
@@ -394,6 +403,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 {
 	struct mlx5_eswitch *peer_esw = NULL;
 	struct mlx5_flow_handle *flow_rule;
+	struct mlx5e_rep_sq_peer *sq_peer;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_rep_sq *rep_sq;
 	int err;
@@ -413,6 +423,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 			err = -ENOMEM;
 			goto out_err;
 		}
+		xa_init(&rep_sq->sq_peer);
 
 		/* Add re-inject rule to the PF/representor sqs */
 		flow_rule = mlx5_eswitch_add_send_to_vport_rule(esw, esw, rep,
@@ -426,15 +437,24 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 		rep_sq->sqn = sqns_array[i];
 
 		if (peer_esw) {
+			int peer_rule_idx = mlx5_get_dev_index(peer_esw->dev);
+
+			sq_peer = kzalloc(sizeof(*sq_peer), GFP_KERNEL);
+			if (!sq_peer)
+				goto out_sq_peer_err;
+
 			flow_rule = mlx5_eswitch_add_send_to_vport_rule(peer_esw, esw,
 									rep, sqns_array[i]);
 			if (IS_ERR(flow_rule)) {
 				err = PTR_ERR(flow_rule);
-				mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
-				kfree(rep_sq);
-				goto out_err;
+				goto out_flow_rule_err;
 			}
-			rep_sq->send_to_vport_rule_peer = flow_rule;
+
+			sq_peer->rule = flow_rule;
+			sq_peer->peer = peer_esw;
+			err = xa_insert(&rep_sq->sq_peer, peer_rule_idx, sq_peer, GFP_KERNEL);
+			if (err)
+				goto out_xa_err;
 		}
 
 		list_add(&rep_sq->list, &rpriv->vport_sqs_list);
@@ -445,6 +465,14 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 
 	return 0;
 
+out_xa_err:
+	mlx5_eswitch_del_send_to_vport_rule(flow_rule);
+out_flow_rule_err:
+	kfree(sq_peer);
+out_sq_peer_err:
+	mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
+	xa_destroy(&rep_sq->sq_peer);
+	kfree(rep_sq);
 out_err:
 	mlx5e_sqs2vport_stop(esw, rep);
 
@@ -1524,17 +1552,24 @@ static void *mlx5e_vport_rep_get_proto_dev(struct mlx5_eswitch_rep *rep)
 	return rpriv->netdev;
 }
 
-static void mlx5e_vport_rep_event_unpair(struct mlx5_eswitch_rep *rep)
+static void mlx5e_vport_rep_event_unpair(struct mlx5_eswitch_rep *rep,
+					 struct mlx5_eswitch *peer_esw)
 {
+	int i = mlx5_get_dev_index(peer_esw->dev);
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_rep_sq *rep_sq;
 
+	WARN_ON_ONCE(!peer_esw);
 	rpriv = mlx5e_rep_to_rep_priv(rep);
 	list_for_each_entry(rep_sq, &rpriv->vport_sqs_list, list) {
-		if (!rep_sq->send_to_vport_rule_peer)
+		struct mlx5e_rep_sq_peer *sq_peer = xa_load(&rep_sq->sq_peer, i);
+
+		if (!sq_peer || sq_peer->peer != peer_esw)
 			continue;
-		mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule_peer);
-		rep_sq->send_to_vport_rule_peer = NULL;
+
+		mlx5_eswitch_del_send_to_vport_rule(sq_peer->rule);
+		xa_erase(&rep_sq->sq_peer, i);
+		kfree(sq_peer);
 	}
 }
 
@@ -1542,24 +1577,52 @@ static int mlx5e_vport_rep_event_pair(struct mlx5_eswitch *esw,
 				      struct mlx5_eswitch_rep *rep,
 				      struct mlx5_eswitch *peer_esw)
 {
+	int i = mlx5_get_dev_index(peer_esw->dev);
 	struct mlx5_flow_handle *flow_rule;
+	struct mlx5e_rep_sq_peer *sq_peer;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_rep_sq *rep_sq;
+	int err;
 
 	rpriv = mlx5e_rep_to_rep_priv(rep);
 	list_for_each_entry(rep_sq, &rpriv->vport_sqs_list, list) {
-		if (rep_sq->send_to_vport_rule_peer)
+		sq_peer = xa_load(&rep_sq->sq_peer, i);
+
+		if (sq_peer && sq_peer->peer)
 			continue;
-		flow_rule = mlx5_eswitch_add_send_to_vport_rule(peer_esw, esw, rep, rep_sq->sqn);
-		if (IS_ERR(flow_rule))
+
+		flow_rule = mlx5_eswitch_add_send_to_vport_rule(peer_esw, esw, rep,
+								rep_sq->sqn);
+		if (IS_ERR(flow_rule)) {
+			err = PTR_ERR(flow_rule);
 			goto err_out;
-		rep_sq->send_to_vport_rule_peer = flow_rule;
+		}
+
+		if (sq_peer) {
+			sq_peer->rule = flow_rule;
+			sq_peer->peer = peer_esw;
+			continue;
+		}
+		sq_peer = kzalloc(sizeof(*sq_peer), GFP_KERNEL);
+		if (!sq_peer) {
+			err = -ENOMEM;
+			goto err_sq_alloc;
+		}
+		err = xa_insert(&rep_sq->sq_peer, i, sq_peer, GFP_KERNEL);
+		if (err)
+			goto err_xa;
+		sq_peer->rule = flow_rule;
+		sq_peer->peer = peer_esw;
 	}
 
 	return 0;
+err_xa:
+	kfree(sq_peer);
+err_sq_alloc:
+	mlx5_eswitch_del_send_to_vport_rule(flow_rule);
 err_out:
-	mlx5e_vport_rep_event_unpair(rep);
-	return PTR_ERR(flow_rule);
+	mlx5e_vport_rep_event_unpair(rep, peer_esw);
+	return err;
 }
 
 static int mlx5e_vport_rep_event(struct mlx5_eswitch *esw,
@@ -1572,7 +1635,7 @@ static int mlx5e_vport_rep_event(struct mlx5_eswitch *esw,
 	if (event == MLX5_SWITCHDEV_EVENT_PAIR)
 		err = mlx5e_vport_rep_event_pair(esw, rep, data);
 	else if (event == MLX5_SWITCHDEV_EVENT_UNPAIR)
-		mlx5e_vport_rep_event_unpair(rep);
+		mlx5e_vport_rep_event_unpair(rep, data);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 80b7f5079a5a..70640fa1ad7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -225,9 +225,14 @@ struct mlx5e_encap_entry {
 	struct rcu_head rcu;
 };
 
+struct mlx5e_rep_sq_peer {
+	struct mlx5_flow_handle *rule;
+	void *peer;
+};
+
 struct mlx5e_rep_sq {
 	struct mlx5_flow_handle	*send_to_vport_rule;
-	struct mlx5_flow_handle *send_to_vport_rule_peer;
+	struct xarray sq_peer;
 	u32 sqn;
 	struct list_head	 list;
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1b2f5e273525..9526382f1573 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2673,7 +2673,8 @@ void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
 #define ESW_OFFLOADS_DEVCOM_UNPAIR	(1)
 
-static void mlx5_esw_offloads_rep_event_unpair(struct mlx5_eswitch *esw)
+static void mlx5_esw_offloads_rep_event_unpair(struct mlx5_eswitch *esw,
+					       struct mlx5_eswitch *peer_esw)
 {
 	const struct mlx5_eswitch_rep_ops *ops;
 	struct mlx5_eswitch_rep *rep;
@@ -2686,17 +2687,18 @@ static void mlx5_esw_offloads_rep_event_unpair(struct mlx5_eswitch *esw)
 			ops = esw->offloads.rep_ops[rep_type];
 			if (atomic_read(&rep->rep_data[rep_type].state) == REP_LOADED &&
 			    ops->event)
-				ops->event(esw, rep, MLX5_SWITCHDEV_EVENT_UNPAIR, NULL);
+				ops->event(esw, rep, MLX5_SWITCHDEV_EVENT_UNPAIR, peer_esw);
 		}
 	}
 }
 
-static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw)
+static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw,
+				     struct mlx5_eswitch *peer_esw)
 {
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	mlx5e_tc_clean_fdb_peer_flows(esw);
 #endif
-	mlx5_esw_offloads_rep_event_unpair(esw);
+	mlx5_esw_offloads_rep_event_unpair(esw, peer_esw);
 	esw_del_fdb_peer_miss_rules(esw);
 }
 
@@ -2728,7 +2730,7 @@ static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
 	return 0;
 
 err_out:
-	mlx5_esw_offloads_unpair(esw);
+	mlx5_esw_offloads_unpair(esw, peer_esw);
 	return err;
 }
 
@@ -2802,8 +2804,8 @@ static int mlx5_esw_offloads_devcom_event(int event,
 		mlx5_devcom_set_paired(devcom, MLX5_DEVCOM_ESW_OFFLOADS, false);
 		esw->paired[mlx5_get_dev_index(peer_esw->dev)] = false;
 		peer_esw->paired[mlx5_get_dev_index(esw->dev)] = false;
-		mlx5_esw_offloads_unpair(peer_esw);
-		mlx5_esw_offloads_unpair(esw);
+		mlx5_esw_offloads_unpair(peer_esw, esw);
+		mlx5_esw_offloads_unpair(esw, peer_esw);
 		mlx5_esw_offloads_set_ns_peer(esw, peer_esw, false);
 		break;
 	}
@@ -2811,7 +2813,7 @@ static int mlx5_esw_offloads_devcom_event(int event,
 	return 0;
 
 err_pair:
-	mlx5_esw_offloads_unpair(esw);
+	mlx5_esw_offloads_unpair(esw, peer_esw);
 err_peer:
 	mlx5_esw_offloads_set_ns_peer(esw, peer_esw, false);
 err_out:
-- 
2.40.1


