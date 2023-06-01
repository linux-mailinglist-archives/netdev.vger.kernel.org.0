Return-Path: <netdev+bounces-7006-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D4EF7192F2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24A5C1C20F34
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6E3D306;
	Thu,  1 Jun 2023 06:01:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C186D13AED
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F00C433A0;
	Thu,  1 Jun 2023 06:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599302;
	bh=QM6v+O8m2DH22MCL9bC7O1LsNSlJ5ctmacqk73Z66Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la40hLhIH2ccUkZbMxb/XKZIaX8pXH32TqdA500QWNHXnqC8oVoV1PLytQa09rLJa
	 KZ42ds72b/Bm7+vyC5P0N5B2RryzVJZG6NfkMwBIDO11vJ3p6ncC/+yeAYOGLyHCsg
	 j/L+Izjpoahfi4QRoZ74L6anJkEkJHBH+/CE1S+ZqjxhlTkRq2OY2gDYhA8dZPlf0x
	 Ymd2v+GgfLle1BZ+WT4EN8yzdGYgeMbohmcgYBM8W39bbYdD5G9LbIxhqqCZGOlX4+
	 6l+h2sXVV1CbFr2JC8UUd+646bsCCl8Je4tvbBW0vjDmrs/0t8EFcTivGTXkLXPaHw
	 bdGgby1vqNGjw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [net-next 10/14] net/mlx5: DR, handle more than one peer domain
Date: Wed, 31 May 2023 23:01:14 -0700
Message-Id: <20230601060118.154015-11-saeed@kernel.org>
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

Currently, DR domain is using the assumption that each domain can only
have a single peer.
In order to support VF LAG of more then two ports, expand peer domain
to use an array of peers, and align the code accordingly.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c  | 12 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c    |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h    |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c   |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h   |  3 ++-
 .../mellanox/mlx5/core/steering/dr_action.c         |  5 +++--
 .../mellanox/mlx5/core/steering/dr_domain.c         | 13 +++++++------
 .../mellanox/mlx5/core/steering/dr_ste_v0.c         |  9 +++++----
 .../mellanox/mlx5/core/steering/dr_ste_v1.c         |  9 +++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_types.h |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c    |  5 +++--
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h   |  3 ++-
 12 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 98d75a33a624..761278e1af5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2778,7 +2778,9 @@ static int mlx5_esw_offloads_set_ns_peer(struct mlx5_eswitch *esw,
 					 struct mlx5_eswitch *peer_esw,
 					 bool pair)
 {
+	u8 peer_idx = mlx5_get_dev_index(peer_esw->dev);
 	struct mlx5_flow_root_namespace *peer_ns;
+	u8 idx = mlx5_get_dev_index(esw->dev);
 	struct mlx5_flow_root_namespace *ns;
 	int err;
 
@@ -2786,18 +2788,18 @@ static int mlx5_esw_offloads_set_ns_peer(struct mlx5_eswitch *esw,
 	ns = esw->dev->priv.steering->fdb_root_ns;
 
 	if (pair) {
-		err = mlx5_flow_namespace_set_peer(ns, peer_ns);
+		err = mlx5_flow_namespace_set_peer(ns, peer_ns, peer_idx);
 		if (err)
 			return err;
 
-		err = mlx5_flow_namespace_set_peer(peer_ns, ns);
+		err = mlx5_flow_namespace_set_peer(peer_ns, ns, idx);
 		if (err) {
-			mlx5_flow_namespace_set_peer(ns, NULL);
+			mlx5_flow_namespace_set_peer(ns, NULL, peer_idx);
 			return err;
 		}
 	} else {
-		mlx5_flow_namespace_set_peer(ns, NULL);
-		mlx5_flow_namespace_set_peer(peer_ns, NULL);
+		mlx5_flow_namespace_set_peer(ns, NULL, peer_idx);
+		mlx5_flow_namespace_set_peer(peer_ns, NULL, idx);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 144e59480686..11374c3744c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -139,7 +139,8 @@ static void mlx5_cmd_stub_modify_header_dealloc(struct mlx5_flow_root_namespace
 }
 
 static int mlx5_cmd_stub_set_peer(struct mlx5_flow_root_namespace *ns,
-				  struct mlx5_flow_root_namespace *peer_ns)
+				  struct mlx5_flow_root_namespace *peer_ns,
+				  u8 peer_idx)
 {
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
index 8ef4254b9ea1..b6b9a5a20591 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -93,7 +93,8 @@ struct mlx5_flow_cmds {
 				      struct mlx5_modify_hdr *modify_hdr);
 
 	int (*set_peer)(struct mlx5_flow_root_namespace *ns,
-			struct mlx5_flow_root_namespace *peer_ns);
+			struct mlx5_flow_root_namespace *peer_ns,
+			u8 peer_idx);
 
 	int (*create_ns)(struct mlx5_flow_root_namespace *ns);
 	int (*destroy_ns)(struct mlx5_flow_root_namespace *ns);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 19da02c41616..4ef04aa28771 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -3620,7 +3620,8 @@ void mlx5_destroy_match_definer(struct mlx5_core_dev *dev,
 }
 
 int mlx5_flow_namespace_set_peer(struct mlx5_flow_root_namespace *ns,
-				 struct mlx5_flow_root_namespace *peer_ns)
+				 struct mlx5_flow_root_namespace *peer_ns,
+				 u8 peer_idx)
 {
 	if (peer_ns && ns->mode != peer_ns->mode) {
 		mlx5_core_err(ns->dev,
@@ -3628,7 +3629,7 @@ int mlx5_flow_namespace_set_peer(struct mlx5_flow_root_namespace *ns,
 		return -EINVAL;
 	}
 
-	return ns->cmds->set_peer(ns, peer_ns);
+	return ns->cmds->set_peer(ns, peer_ns, peer_idx);
 }
 
 /* This function should be called only at init stage of the namespace.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index f137a0611b77..200ec946409c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -295,7 +295,8 @@ void mlx5_fc_update_sampling_interval(struct mlx5_core_dev *dev,
 const struct mlx5_flow_cmds *mlx5_fs_cmd_get_fw_cmds(void);
 
 int mlx5_flow_namespace_set_peer(struct mlx5_flow_root_namespace *ns,
-				 struct mlx5_flow_root_namespace *peer_ns);
+				 struct mlx5_flow_root_namespace *peer_ns,
+				 u8 peer_idx);
 
 int mlx5_flow_namespace_set_mode(struct mlx5_flow_namespace *ns,
 				 enum mlx5_flow_steering_mode mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 0eb9a8d7f282..4e9bc1897a88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -2071,8 +2071,9 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *dmn,
 	struct mlx5dr_action *action;
 	u8 peer_vport;
 
-	peer_vport = vhca_id_valid && (vhca_id != dmn->info.caps.gvmi);
-	vport_dmn = peer_vport ? dmn->peer_dmn : dmn;
+	peer_vport = vhca_id_valid && mlx5_core_is_pf(dmn->mdev) &&
+		(vhca_id != dmn->info.caps.gvmi);
+	vport_dmn = peer_vport ? dmn->peer_dmn[vhca_id] : dmn;
 	if (!vport_dmn) {
 		mlx5dr_dbg(dmn, "No peer vport domain for given vhca_id\n");
 		return NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 9a2dfe6ebe31..75dc85dc24ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -555,17 +555,18 @@ int mlx5dr_domain_destroy(struct mlx5dr_domain *dmn)
 }
 
 void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
-			    struct mlx5dr_domain *peer_dmn)
+			    struct mlx5dr_domain *peer_dmn,
+			    u8 peer_idx)
 {
 	mlx5dr_domain_lock(dmn);
 
-	if (dmn->peer_dmn)
-		refcount_dec(&dmn->peer_dmn->refcount);
+	if (dmn->peer_dmn[peer_idx])
+		refcount_dec(&dmn->peer_dmn[peer_idx]->refcount);
 
-	dmn->peer_dmn = peer_dmn;
+	dmn->peer_dmn[peer_idx] = peer_dmn;
 
-	if (dmn->peer_dmn)
-		refcount_inc(&dmn->peer_dmn->refcount);
+	if (dmn->peer_dmn[peer_idx])
+		refcount_inc(&dmn->peer_dmn[peer_idx]->refcount);
 
 	mlx5dr_domain_unlock(dmn);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 2010d4ac6519..69d7a8f3c402 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1647,6 +1647,7 @@ dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 				 u8 *tag)
 {
 	struct mlx5dr_match_misc *misc = &value->misc;
+	int id = misc->source_eswitch_owner_vhca_id;
 	struct mlx5dr_cmd_vport_cap *vport_cap;
 	struct mlx5dr_domain *dmn = sb->dmn;
 	struct mlx5dr_domain *vport_dmn;
@@ -1657,11 +1658,11 @@ dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 
 	if (sb->vhca_id_valid) {
 		/* Find port GVMI based on the eswitch_owner_vhca_id */
-		if (misc->source_eswitch_owner_vhca_id == dmn->info.caps.gvmi)
+		if (id == dmn->info.caps.gvmi)
 			vport_dmn = dmn;
-		else if (dmn->peer_dmn && (misc->source_eswitch_owner_vhca_id ==
-					   dmn->peer_dmn->info.caps.gvmi))
-			vport_dmn = dmn->peer_dmn;
+		else if (id < MLX5_MAX_PORTS && dmn->peer_dmn[id] &&
+			 (id == dmn->peer_dmn[id]->info.caps.gvmi))
+			vport_dmn = dmn->peer_dmn[id];
 		else
 			return -EINVAL;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 4c0704ad166b..f4ef0b22b991 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1979,6 +1979,7 @@ static int dr_ste_v1_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 					    u8 *tag)
 {
 	struct mlx5dr_match_misc *misc = &value->misc;
+	int id = misc->source_eswitch_owner_vhca_id;
 	struct mlx5dr_cmd_vport_cap *vport_cap;
 	struct mlx5dr_domain *dmn = sb->dmn;
 	struct mlx5dr_domain *vport_dmn;
@@ -1988,11 +1989,11 @@ static int dr_ste_v1_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 
 	if (sb->vhca_id_valid) {
 		/* Find port GVMI based on the eswitch_owner_vhca_id */
-		if (misc->source_eswitch_owner_vhca_id == dmn->info.caps.gvmi)
+		if (id == dmn->info.caps.gvmi)
 			vport_dmn = dmn;
-		else if (dmn->peer_dmn && (misc->source_eswitch_owner_vhca_id ==
-					   dmn->peer_dmn->info.caps.gvmi))
-			vport_dmn = dmn->peer_dmn;
+		else if (id < MLX5_MAX_PORTS && dmn->peer_dmn[id] &&
+			 (id == dmn->peer_dmn[id]->info.caps.gvmi))
+			vport_dmn = dmn->peer_dmn[id];
 		else
 			return -EINVAL;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 678a993ab053..1622dbbe6b97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -935,7 +935,7 @@ struct mlx5dr_domain_info {
 };
 
 struct mlx5dr_domain {
-	struct mlx5dr_domain *peer_dmn;
+	struct mlx5dr_domain *peer_dmn[MLX5_MAX_PORTS];
 	struct mlx5_core_dev *mdev;
 	u32 pdn;
 	struct mlx5_uars_page *uar;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 984653756779..c6fda1cbfcff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -770,14 +770,15 @@ static int mlx5_cmd_dr_update_fte(struct mlx5_flow_root_namespace *ns,
 }
 
 static int mlx5_cmd_dr_set_peer(struct mlx5_flow_root_namespace *ns,
-				struct mlx5_flow_root_namespace *peer_ns)
+				struct mlx5_flow_root_namespace *peer_ns,
+				u8 peer_idx)
 {
 	struct mlx5dr_domain *peer_domain = NULL;
 
 	if (peer_ns)
 		peer_domain = peer_ns->fs_dr_domain.dr_domain;
 	mlx5dr_domain_set_peer(ns->fs_dr_domain.dr_domain,
-			       peer_domain);
+			       peer_domain, peer_idx);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 9afd268a2573..5ba88f2ecb3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -48,7 +48,8 @@ int mlx5dr_domain_destroy(struct mlx5dr_domain *domain);
 int mlx5dr_domain_sync(struct mlx5dr_domain *domain, u32 flags);
 
 void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
-			    struct mlx5dr_domain *peer_dmn);
+			    struct mlx5dr_domain *peer_dmn,
+			    u8 peer_idx);
 
 struct mlx5dr_table *
 mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level, u32 flags,
-- 
2.40.1


