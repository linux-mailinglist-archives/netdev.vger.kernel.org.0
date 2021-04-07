Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24BC3562BA
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348557AbhDGEyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:54:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235945AbhDGEyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D62E613D2;
        Wed,  7 Apr 2021 04:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771276;
        bh=Wqh7Mf0ORFSrkKCXmeYgozXM+J6/CEqHhAFfZTYBG+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t24Oo3PT31F17tNZ/FK7uGllN7h9kcInyJZVLky/O9eXtAxZDSMnWD60z4NKEAZW9
         asJTP3jbfTep3ZXvy67XmKZuLA+eQOCqav1n9AejaUWX5l2VovTCJgL23UlIfllUg4
         yKJYq4qn+8nQqMS0kNOI09BM4yQhjvVU82TP5BkSd9HQHPvAuSOwH0eRvZ35Sb/wRr
         nPlLpM6zzvorBoAK00TbGmTDqNkJhY1W5h8y9QgoYj8ZcTHwPwVlJvPNj5my6i2GL5
         3a+x++YxbE5Q9ZFYDK9n3vfnwsAWKRhHms+IR2hrLuNBS1wRuk1NN+Zzd8hvV+Da9p
         v3YR9fBhg9l0Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/13] net/mlx5: E-switch, Generalize per vport table API
Date:   Tue,  6 Apr 2021 21:54:11 -0700
Message-Id: <20210407045421.148987-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently, per vport table was used only for port mirroring actions.
However, sample action will also require a per vport table instance.

Generalize the vport table API to work with multiple namespaces where
each namespace manages its own vport table instance.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/vporttbl.c    | 15 ++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h |  7 +++++++
 .../mellanox/mlx5/core/eswitch_offloads.c         | 14 ++++++++++++++
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
index 6c4246181615..abba1b801048 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
@@ -3,9 +3,6 @@
 
 #include "eswitch.h"
 
-#define MLX5_ESW_VPORT_TABLE_SIZE 128
-#define MLX5_ESW_VPORT_TBL_NUM_GROUPS  4
-
 /* This struct is used as a key to the hash table and we need it to be packed
  * so hash result is consistent
  */
@@ -14,6 +11,7 @@ struct mlx5_vport_key {
 	u16 prio;
 	u16 vport;
 	u16 vhca_id;
+	const struct esw_vport_tbl_namespace *vport_ns;
 } __packed;
 
 struct mlx5_vport_table {
@@ -24,14 +22,16 @@ struct mlx5_vport_table {
 };
 
 static struct mlx5_flow_table *
-esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns)
+esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns,
+		     const struct esw_vport_tbl_namespace *vport_ns)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *fdb;
 
-	ft_attr.autogroup.max_num_groups = MLX5_ESW_VPORT_TBL_NUM_GROUPS;
-	ft_attr.max_fte = MLX5_ESW_VPORT_TABLE_SIZE;
+	ft_attr.autogroup.max_num_groups = vport_ns->max_num_groups;
+	ft_attr.max_fte = vport_ns->max_fte;
 	ft_attr.prio = FDB_PER_VPORT;
+	ft_attr.flags = vport_ns->flags;
 	fdb = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(fdb)) {
 		esw_warn(esw->dev, "Failed to create per vport FDB Table err %ld\n",
@@ -49,6 +49,7 @@ static u32 flow_attr_to_vport_key(struct mlx5_eswitch *esw,
 	key->chain = attr->chain;
 	key->prio = attr->prio;
 	key->vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	key->vport_ns  = attr->vport_ns;
 	return jhash(key, sizeof(*key), 0);
 }
 
@@ -96,7 +97,7 @@ mlx5_esw_vporttbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr
 		goto err_ns;
 	}
 
-	fdb = esw_vport_tbl_create(esw, ns);
+	fdb = esw_vport_tbl_create(esw, ns, attr->vport_ns);
 	if (IS_ERR(fdb))
 		goto err_ns;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index b7d1f8854ef4..e0415676821a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -713,10 +713,17 @@ void
 esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 				      struct mlx5_vport *vport);
 
+struct esw_vport_tbl_namespace {
+	int max_fte;
+	int max_num_groups;
+	u32 flags;
+};
+
 struct mlx5_vport_tbl_attr {
 	u16 chain;
 	u16 prio;
 	u16 vport;
+	const struct esw_vport_tbl_namespace *vport_ns;
 };
 
 struct mlx5_flow_table *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 63e22e9e5ad1..8ac4b60ea225 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -54,6 +54,15 @@
 #define MLX5_ESW_MISS_FLOWS (2)
 #define UPLINK_REP_INDEX 0
 
+#define MLX5_ESW_VPORT_TBL_SIZE 128
+#define MLX5_ESW_VPORT_TBL_NUM_GROUPS  4
+
+static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_mirror_ns = {
+	.max_fte = MLX5_ESW_VPORT_TBL_SIZE,
+	.max_num_groups = MLX5_ESW_VPORT_TBL_NUM_GROUPS,
+	.flags = 0,
+};
+
 static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
 						     u16 vport_num)
 {
@@ -482,6 +491,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		fwd_attr.chain = attr->chain;
 		fwd_attr.prio = attr->prio;
 		fwd_attr.vport = esw_attr->in_rep->vport;
+		fwd_attr.vport_ns = &mlx5_esw_vport_tbl_mirror_ns;
 
 		fdb = mlx5_esw_vporttbl_get(esw, &fwd_attr);
 	} else {
@@ -548,6 +558,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	fwd_attr.chain = attr->chain;
 	fwd_attr.prio = attr->prio;
 	fwd_attr.vport = esw_attr->in_rep->vport;
+	fwd_attr.vport_ns = &mlx5_esw_vport_tbl_mirror_ns;
 	fwd_fdb = mlx5_esw_vporttbl_get(esw, &fwd_attr);
 	if (IS_ERR(fwd_fdb)) {
 		rule = ERR_CAST(fwd_fdb);
@@ -628,6 +639,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 		fwd_attr.chain = attr->chain;
 		fwd_attr.prio = attr->prio;
 		fwd_attr.vport = esw_attr->in_rep->vport;
+		fwd_attr.vport_ns = &mlx5_esw_vport_tbl_mirror_ns;
 	}
 
 	if (fwd_rule)  {
@@ -1345,6 +1357,7 @@ static void esw_vport_tbl_put(struct mlx5_eswitch *esw)
 	attr.prio = 1;
 	mlx5_esw_for_all_vports(esw, i, vport) {
 		attr.vport = vport->vport;
+		attr.vport_ns = &mlx5_esw_vport_tbl_mirror_ns;
 		mlx5_esw_vporttbl_put(esw, &attr);
 	}
 }
@@ -1360,6 +1373,7 @@ static int esw_vport_tbl_get(struct mlx5_eswitch *esw)
 	attr.prio = 1;
 	mlx5_esw_for_all_vports(esw, i, vport) {
 		attr.vport = vport->vport;
+		attr.vport_ns = &mlx5_esw_vport_tbl_mirror_ns;
 		fdb = mlx5_esw_vporttbl_get(esw, &attr);
 		if (IS_ERR(fdb))
 			goto out;
-- 
2.30.2

