Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614D4336CF0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhCKHKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232030AbhCKHJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1592865034;
        Thu, 11 Mar 2021 07:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446583;
        bh=CaiJYHFQ0lB6BQTHasLJH2iX94RUjo7l/z2wKWU4w9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGs/vlwlOdgEdwsSvivgowY/V2aRyFrA2SuNk4MgQzMzf9L24x9GIbxuj7SWhlyDL
         MoZENrxIHsBzycG1dv0B8tWAV5NEHTQewrdCm8QGfHvRXdikuaarUw7mVXoaN6U1na
         zBD4+eaoQTL7FZeOTPjBDl6ZvqPgX0KGhW2fMlJVWFHqPH0WcctKAZqbxFzV1un0TL
         d01mNJ38+ZRXT8BhC6zI1ZhQ1NrbT0N9ozMIqGZUJ/lF96+6bHZeqopD+mtDnQrwlv
         3OG3IT1+CcOsqOkpP1ElHIi7S8zTH/zX23tO09HQRDRbDtPZlusFy9UKvb0Sg+A7yk
         VW0l1Q68b/4Fg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 7/9] net/mlx5: E-Switch, Refactor send to vport to be more generic
Date:   Wed, 10 Mar 2021 23:09:13 -0800
Message-Id: <20210311070915.321814-8-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Now that each representor stores a pointer to the managing E-Switch
use that information when creating the send-to-vport rules.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           |  3 +--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 +--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 20 +++++++++++--------
 include/linux/mlx5/eswitch.h                  |  4 ++--
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 4eae7131b0ce..db5de720bb12 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -123,8 +123,7 @@ struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 
 	rep = dev->port[port - 1].rep;
 
-	return mlx5_eswitch_add_send_to_vport_rule(esw, rep->vport,
-						   sq->base.mqp.qpn);
+	return mlx5_eswitch_add_send_to_vport_rule(esw, rep, sq->base.mqp.qpn);
 }
 
 static int mlx5r_rep_probe(struct auxiliary_device *adev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a132fff7a980..3d6c2bce67d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -411,8 +411,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 		}
 
 		/* Add re-inject rule to the PF/representor sqs */
-		flow_rule = mlx5_eswitch_add_send_to_vport_rule(esw,
-								rep->vport,
+		flow_rule = mlx5_eswitch_add_send_to_vport_rule(esw, rep,
 								sqns_array[i]);
 		if (IS_ERR(flow_rule)) {
 			err = PTR_ERR(flow_rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f6c0e7e05ad5..6090b2609089 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1036,7 +1036,8 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 }
 
 struct mlx5_flow_handle *
-mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, u16 vport,
+mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
+				    struct mlx5_eswitch_rep *rep,
 				    u32 sqn)
 {
 	struct mlx5_flow_act flow_act = {0};
@@ -1054,27 +1055,30 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, u16 vport,
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
 	MLX5_SET(fte_match_set_misc, misc, source_sqn, sqn);
 	/* source vport is the esw manager */
-	MLX5_SET(fte_match_set_misc, misc, source_port, esw->manager_vport);
-	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+	MLX5_SET(fte_match_set_misc, misc, source_port, rep->esw->manager_vport);
+	if (MLX5_CAP_ESW(on_esw->dev, merged_eswitch))
 		MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id,
-			 MLX5_CAP_GEN(esw->dev, vhca_id));
+			 MLX5_CAP_GEN(rep->esw->dev, vhca_id));
 
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_sqn);
 	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
-	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+	if (MLX5_CAP_ESW(on_esw->dev, merged_eswitch))
 		MLX5_SET_TO_ONES(fte_match_set_misc, misc,
 				 source_eswitch_owner_vhca_id);
 
 	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-	dest.vport.num = vport;
+	dest.vport.num = rep->vport;
+	dest.vport.vhca_id = MLX5_CAP_GEN(rep->esw->dev, vhca_id);
+	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+	flow_rule = mlx5_add_flow_rules(on_esw->fdb_table.offloads.slow_fdb,
 					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule))
-		esw_warn(esw->dev, "FDB: Failed to add send to vport rule err %ld\n", PTR_ERR(flow_rule));
+		esw_warn(on_esw->dev, "FDB: Failed to add send to vport rule err %ld\n",
+			 PTR_ERR(flow_rule));
 out:
 	kvfree(spec);
 	return flow_rule;
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 72d480df2a03..2ec0527991c8 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -62,8 +62,8 @@ struct mlx5_eswitch_rep *mlx5_eswitch_vport_rep(struct mlx5_eswitch *esw,
 						u16 vport_num);
 void *mlx5_eswitch_uplink_get_proto_dev(struct mlx5_eswitch *esw, u8 rep_type);
 struct mlx5_flow_handle *
-mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw,
-				    u16 vport_num, u32 sqn);
+mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
+				    struct mlx5_eswitch_rep *rep, u32 sqn);
 
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev);
 
-- 
2.29.2

