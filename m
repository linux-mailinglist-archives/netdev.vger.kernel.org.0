Return-Path: <netdev+bounces-6998-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4018E7192E8
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 760CF2815D7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FD37483;
	Thu,  1 Jun 2023 06:01:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A2D79EB
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A285CC4339B;
	Thu,  1 Jun 2023 06:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599293;
	bh=zEADEZAL/dMsopinicMmlReSrtjuDbAWoKsStK6MS/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ube13wrRuCEzjsAWgqNlxLiahct1dKRUc74ig2Pw1pcR0M8iD40wwt477ddZn4iKE
	 YIlQx3vSCRCETE3jux7ZNkWCqXEH4oVa/bxMdZr8fhBTwyPofpeUIDncFbq0ocT2Q2
	 BXyhkrZ9xTdrMfnOI6iN0wOr4K7Tu4MI6jGjyhJeaeS9BmAG8qCbDtn3j6kl5Q3Xij
	 4s9q2Q1bGmF4E0Wtt8M5lzz23KlV3PZTn3oY/vdX/RMdzymetDRBrtYHMOlNUAcEX8
	 hTy7vgw/x6UlcgWPazKNpr/JbZF2Js/UxEr7A6hM3rJcXNCbirg9DceBTLnY4BxTdR
	 2lxTkUYzW6ZKg==
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
Subject: [net-next 02/14] net/mlx5e: tc, Refactor peer add/del flow
Date: Wed, 31 May 2023 23:01:06 -0700
Message-Id: <20230601060118.154015-3-saeed@kernel.org>
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

Move peer_eswitch outside mlx5e_tc_add_fdb_peer_flow() so downstream
patch can call mlx5e_tc_add_fdb_peer_flow() with multiple peers.
Move peer_eswitch in the remove flow as well in order to keep symmetry.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 65 ++++++++++---------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index de8b7a119a02..6bf0fd3038bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2071,7 +2071,7 @@ void mlx5e_put_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list)
 		mlx5e_flow_put(priv, flow);
 }
 
-static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
+static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow *peer_flow;
@@ -2096,25 +2096,20 @@ static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
 	}
 }
 
-static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
-{
-	struct mlx5_core_dev *dev = flow->priv->mdev;
-	struct mlx5_devcom *devcom = dev->priv.devcom;
-	struct mlx5_eswitch *peer_esw;
-
-	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-	if (!peer_esw)
-		return;
-
-	__mlx5e_tc_del_fdb_peer_flow(flow);
-	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-}
-
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow)
 {
 	if (mlx5e_is_eswitch_flow(flow)) {
+		struct mlx5_devcom *devcom = flow->priv->mdev->priv.devcom;
+		struct mlx5_eswitch *peer_esw;
+
+		peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+		if (!peer_esw) {
+			mlx5e_tc_del_fdb_flow(priv, flow);
+			return;
+		}
 		mlx5e_tc_del_fdb_peer_flow(flow);
+		mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 		mlx5e_tc_del_fdb_flow(priv, flow);
 	} else {
 		mlx5e_tc_del_nic_flow(priv, flow);
@@ -4490,22 +4485,18 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 
 static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 				      struct mlx5e_tc_flow *flow,
-				      unsigned long flow_flags)
+				      unsigned long flow_flags,
+				      struct mlx5_eswitch *peer_esw)
 {
 	struct mlx5e_priv *priv = flow->priv, *peer_priv;
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch, *peer_esw;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
-	struct mlx5_devcom *devcom = priv->mdev->priv.devcom;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_rep_priv *peer_urpriv;
 	struct mlx5e_tc_flow *peer_flow;
 	struct mlx5_core_dev *in_mdev;
 	int err = 0;
 
-	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-	if (!peer_esw)
-		return -ENODEV;
-
 	peer_urpriv = mlx5_eswitch_get_uplink_priv(peer_esw, REP_ETH);
 	peer_priv = netdev_priv(peer_urpriv->netdev);
 
@@ -4537,7 +4528,6 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	mutex_unlock(&esw->offloads.peer_mutex);
 
 out:
-	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 	return err;
 }
 
@@ -4548,9 +4538,11 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		   struct net_device *filter_dev,
 		   struct mlx5e_tc_flow **__flow)
 {
+	struct mlx5_devcom *devcom = priv->mdev->priv.devcom;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *in_rep = rpriv->rep;
 	struct mlx5_core_dev *in_mdev = priv->mdev;
+	struct mlx5_eswitch *peer_esw;
 	struct mlx5e_tc_flow *flow;
 	int err;
 
@@ -4559,19 +4551,30 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
 
-	if (is_peer_flow_needed(flow)) {
-		err = mlx5e_tc_add_fdb_peer_flow(f, flow, flow_flags);
-		if (err) {
-			mlx5e_tc_del_fdb_flow(priv, flow);
-			goto out;
-		}
+	if (!is_peer_flow_needed(flow)) {
+		*__flow = flow;
+		return 0;
 	}
 
+	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	if (!peer_esw) {
+		err = -ENODEV;
+		goto clean_flow;
+	}
+
+	err = mlx5e_tc_add_fdb_peer_flow(f, flow, flow_flags, peer_esw);
+	if (err)
+		goto peer_clean;
+	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+
 	*__flow = flow;
 
 	return 0;
 
-out:
+peer_clean:
+	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+clean_flow:
+	mlx5e_tc_del_fdb_flow(priv, flow);
 	return err;
 }
 
@@ -5376,7 +5379,7 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw)
 	struct mlx5e_tc_flow *flow, *tmp;
 
 	list_for_each_entry_safe(flow, tmp, &esw->offloads.peer_flows, peer)
-		__mlx5e_tc_del_fdb_peer_flow(flow);
+		mlx5e_tc_del_fdb_peer_flow(flow);
 }
 
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work)
-- 
2.40.1


