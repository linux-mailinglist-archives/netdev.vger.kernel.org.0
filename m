Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977413DF868
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhHCXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233570AbhHCXUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A61461040;
        Tue,  3 Aug 2021 23:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032822;
        bh=g1GRdjhhmYnq4odN6yrFsA6z4OJcL9sJuSOMn+enSIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcGfgtmdmwyGVqyUyWxGjIp4/Glg9XvPPHR8jN8kXdqskAACQqQB+fRYYqe9OSyN5
         AsRvkpRBmiY1DEyGInfZOjxBJUei3H9g5ukiyfXO8wKy4qtoYKdq71jn+KlQYPID7h
         gOJIXXAsBDos31Mx2/DUjdeziiLSUU5USmVkdGpKrPBWvDCfDnFrTdrvW1kE4SNwss
         vmd/gbFAtmrrUCCdBgXYXp92SPxkzuOJliAE7jOPUvNNqO2b8sjddYEKtmfaeL5ueF
         4Y86vzD0ajiwtpCNmAvmEgA+1rtNew4MgUe/asCsv5rtEKlhiNJI2ZtAsDFGr5Yd/v
         acCJPq88GPnbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 10/14] net/mlx5: Add send to vport rules on paired device
Date:   Tue,  3 Aug 2021 16:19:55 -0700
Message-Id: <20210803231959.26513-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

When two mlx5 devices are paired in switchdev mode, always offload the
send-to-vport rule to the peer E-Switch. This allows to abstract
the logic when this is really necessary (single FDB) and combine
the logic of both cases into one.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 86 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  2 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 16 +++-
 3 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1d016cc64015..cc34600b4dde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -49,6 +49,7 @@
 #include "en/devlink.h"
 #include "fs_core.h"
 #include "lib/mlx5.h"
+#include "lib/devcom.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
 #include "en_accel/ipsec.h"
@@ -310,6 +311,8 @@ static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 	rpriv = mlx5e_rep_to_rep_priv(rep);
 	list_for_each_entry_safe(rep_sq, tmp, &rpriv->vport_sqs_list, list) {
 		mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
+		if (rep_sq->send_to_vport_rule_peer)
+			mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule_peer);
 		list_del(&rep_sq->list);
 		kfree(rep_sq);
 	}
@@ -319,6 +322,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 				 struct mlx5_eswitch_rep *rep,
 				 u32 *sqns_array, int sqns_num)
 {
+	struct mlx5_eswitch *peer_esw = NULL;
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_rep_sq *rep_sq;
@@ -329,6 +333,10 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 		return 0;
 
 	rpriv = mlx5e_rep_to_rep_priv(rep);
+	if (mlx5_devcom_is_paired(esw->dev->priv.devcom, MLX5_DEVCOM_ESW_OFFLOADS))
+		peer_esw = mlx5_devcom_get_peer_data(esw->dev->priv.devcom,
+						     MLX5_DEVCOM_ESW_OFFLOADS);
+
 	for (i = 0; i < sqns_num; i++) {
 		rep_sq = kzalloc(sizeof(*rep_sq), GFP_KERNEL);
 		if (!rep_sq) {
@@ -345,12 +353,34 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 			goto out_err;
 		}
 		rep_sq->send_to_vport_rule = flow_rule;
+		rep_sq->sqn = sqns_array[i];
+
+		if (peer_esw) {
+			flow_rule = mlx5_eswitch_add_send_to_vport_rule(peer_esw, esw,
+									rep, sqns_array[i]);
+			if (IS_ERR(flow_rule)) {
+				err = PTR_ERR(flow_rule);
+				mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
+				kfree(rep_sq);
+				goto out_err;
+			}
+			rep_sq->send_to_vport_rule_peer = flow_rule;
+		}
+
 		list_add(&rep_sq->list, &rpriv->vport_sqs_list);
 	}
+
+	if (peer_esw)
+		mlx5_devcom_release_peer_data(esw->dev->priv.devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+
 	return 0;
 
 out_err:
 	mlx5e_sqs2vport_stop(esw, rep);
+
+	if (peer_esw)
+		mlx5_devcom_release_peer_data(esw->dev->priv.devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+
 	return err;
 }
 
@@ -1264,10 +1294,64 @@ static void *mlx5e_vport_rep_get_proto_dev(struct mlx5_eswitch_rep *rep)
 	return rpriv->netdev;
 }
 
+static void mlx5e_vport_rep_event_unpair(struct mlx5_eswitch_rep *rep)
+{
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_rep_sq *rep_sq;
+
+	rpriv = mlx5e_rep_to_rep_priv(rep);
+	list_for_each_entry(rep_sq, &rpriv->vport_sqs_list, list) {
+		if (!rep_sq->send_to_vport_rule_peer)
+			continue;
+		mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule_peer);
+		rep_sq->send_to_vport_rule_peer = NULL;
+	}
+}
+
+static int mlx5e_vport_rep_event_pair(struct mlx5_eswitch *esw,
+				      struct mlx5_eswitch_rep *rep,
+				      struct mlx5_eswitch *peer_esw)
+{
+	struct mlx5_flow_handle *flow_rule;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_rep_sq *rep_sq;
+
+	rpriv = mlx5e_rep_to_rep_priv(rep);
+	list_for_each_entry(rep_sq, &rpriv->vport_sqs_list, list) {
+		if (rep_sq->send_to_vport_rule_peer)
+			continue;
+		flow_rule = mlx5_eswitch_add_send_to_vport_rule(peer_esw, esw, rep, rep_sq->sqn);
+		if (IS_ERR(flow_rule))
+			goto err_out;
+		rep_sq->send_to_vport_rule_peer = flow_rule;
+	}
+
+	return 0;
+err_out:
+	mlx5e_vport_rep_event_unpair(rep);
+	return PTR_ERR(flow_rule);
+}
+
+static int mlx5e_vport_rep_event(struct mlx5_eswitch *esw,
+				 struct mlx5_eswitch_rep *rep,
+				 enum mlx5_switchdev_event event,
+				 void *data)
+{
+	int err = 0;
+
+	if (event == MLX5_SWITCHDEV_EVENT_PAIR)
+		err = mlx5e_vport_rep_event_pair(esw, rep, data);
+	else if (event == MLX5_SWITCHDEV_EVENT_UNPAIR)
+		mlx5e_vport_rep_event_unpair(rep);
+
+	return err;
+}
+
 static const struct mlx5_eswitch_rep_ops rep_ops = {
 	.load = mlx5e_vport_rep_load,
 	.unload = mlx5e_vport_rep_unload,
-	.get_proto_dev = mlx5e_vport_rep_get_proto_dev
+	.get_proto_dev = mlx5e_vport_rep_get_proto_dev,
+	.event = mlx5e_vport_rep_event,
 };
 
 static int mlx5e_rep_probe(struct auxiliary_device *adev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 47a2dfb7792a..8f0c82448eec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -207,6 +207,8 @@ struct mlx5e_encap_entry {
 
 struct mlx5e_rep_sq {
 	struct mlx5_flow_handle	*send_to_vport_rule;
+	struct mlx5_flow_handle *send_to_vport_rule_peer;
+	u32 sqn;
 	struct list_head	 list;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b57a5c188832..e02a8bd2bd96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1616,7 +1616,18 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 		goto ns_err;
 	}
 
-	table_size = esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ +
+	/* To be strictly correct:
+	 *	MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ)
+	 * should be:
+	 *	esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ +
+	 *	peer_esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ
+	 * but as the peer device might not be in switchdev mode it's not
+	 * possible. We use the fact that by default FW sets max vfs and max sfs
+	 * to the same value on both devices. If it needs to be changed in the future note
+	 * the peer miss group should also be created based on the number of
+	 * total vports of the peer (currently is also uses esw->total_vports).
+	 */
+	table_size = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ) +
 		MLX5_ESW_MISS_FLOWS + esw->total_vports + esw->esw_funcs.num_vfs;
 
 	/* create the slow path fdb with encap set, so further table instances
@@ -1673,7 +1684,8 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 			 source_eswitch_owner_vhca_id_valid, 1);
 	}
 
-	ix = esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ;
+	/* See comment above table_size calculation */
+	ix = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ix - 1);
 
-- 
2.31.1

