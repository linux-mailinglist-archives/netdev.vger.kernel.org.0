Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87322EED16
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbhAHFcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbhAHFcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07490235FC;
        Fri,  8 Jan 2021 05:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083860;
        bh=jl1SFtCgX4vu4c2Smrtp/L37oy72Y1Dx5tuHWugVtKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwHkuhyraX/ZS8dxIjKsbrEpKAQ9DyifryfsafSDh1BtARE7IBdcYCWbyXTEdXVMa
         q5Fq/jqyQptlddwfUd0baAd+dD/h8uMB5/IV1CIyKHAez05+7kI3qTYQ9iJucQ+KaT
         xGNh3pJiFUaD/27Ow5SBfrMqzVj3vPnhzK1Vt++sgxEJneJ5TS2Ft5Fm7fcV5Gt1PY
         pQUV2Ztd73B096l7FaPxIZ3AijCMDpGarBPgusEOM/pz5rtQxQCPFX7CQVJS6AI5Cm
         i+70xQaMfpR9H6jgtxeBpr+otBz0gDhpaivGcN/83U0gxxfHox9jeTxTKU4JmL6k7a
         Ip+sO68fb9UVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: CT: Preparation for offloading +trk+new ct rules
Date:   Thu,  7 Jan 2021 21:30:47 -0800
Message-Id: <20210108053054.660499-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Connection tracking associates the connection state per packet. The
first packet of a connection is assigned with the +trk+new state. The
connection enters the established state once a packet is seen on the
other direction.

Currently we offload only the established flows. However, UDP traffic
using source port entropy (e.g. vxlan, RoCE) will never enter the
established state. Such protocols do not require stateful processing,
and therefore could be offloaded.

The change in the model is that a miss on the CT table will be forwarded
to a new +trk+new ct table and a miss there will be forwarded to the slow
path table.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 104 ++++++++++++++++--
 1 file changed, 96 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index d7ecd5e5f7c4..6dac2fabb7f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -21,6 +21,7 @@
 #include "en.h"
 #include "en_tc.h"
 #include "en_rep.h"
+#include "fs_core.h"
 
 #define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen * 8)
 #define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
@@ -50,6 +51,9 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_flow_table *ct;
 	struct mlx5_flow_table *ct_nat;
 	struct mlx5_flow_table *post_ct;
+	struct mlx5_flow_table *trk_new_ct;
+	struct mlx5_flow_group *miss_grp;
+	struct mlx5_flow_handle *miss_rule;
 	struct mutex control_lock; /* guards parallel adds/dels */
 	struct mutex shared_counter_lock;
 	struct mapping_ctx *zone_mapping;
@@ -1490,14 +1494,14 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  *      | set zone
  *      v
  * +--------------------+
- * + CT (nat or no nat) +
- * + tuple + zone match +
- * +--------------------+
- *      | set mark
- *      | set labels_id
- *      | set established
- *	| set zone_restore
- *      | do nat (if needed)
+ * + CT (nat or no nat) +    miss          +---------------------+  miss
+ * + tuple + zone match +----------------->+ trk_new_ct          +-------> SW
+ * +--------------------+                  + vxlan||roce match   +
+ *      | set mark                         +---------------------+
+ *      | set labels_id                             | set ct_state +trk+new
+ *      | set established                           | set zone_restore
+ *	| set zone_restore                          v
+ *      | do nat (if needed)                      post_ct
  *      v
  * +--------------+
  * + post_ct      + original filter actions
@@ -1893,6 +1897,72 @@ mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
 		return mlx5_tc_ct_init_check_nic_support(priv, err_msg);
 }
 
+static struct mlx5_flow_handle *
+tc_ct_add_miss_rule(struct mlx5_flow_table *ft,
+		    struct mlx5_flow_table *next_ft)
+{
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act act = {};
+
+	act.flags  = FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
+	act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dest.type  = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = next_ft;
+
+	return mlx5_add_flow_rules(ft, NULL, &act, &dest, 1);
+}
+
+static int
+tc_ct_add_ct_table_miss_rule(struct mlx5_tc_ct_priv *ct_priv)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_handle *miss_rule;
+	struct mlx5_flow_group *miss_group;
+	int max_fte = ct_priv->ct->max_fte;
+	u32 *flow_group_in;
+	int err = 0;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	/* create miss group */
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index,
+		 max_fte - 2);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+		 max_fte - 1);
+	miss_group = mlx5_create_flow_group(ct_priv->ct, flow_group_in);
+	if (IS_ERR(miss_group)) {
+		err = PTR_ERR(miss_group);
+		goto err_miss_grp;
+	}
+
+	/* add miss rule to next fdb */
+	miss_rule = tc_ct_add_miss_rule(ct_priv->ct, ct_priv->trk_new_ct);
+	if (IS_ERR(miss_rule)) {
+		err = PTR_ERR(miss_rule);
+		goto err_miss_rule;
+	}
+
+	ct_priv->miss_grp = miss_group;
+	ct_priv->miss_rule = miss_rule;
+	kvfree(flow_group_in);
+	return 0;
+
+err_miss_rule:
+	mlx5_destroy_flow_group(miss_group);
+err_miss_grp:
+	kvfree(flow_group_in);
+	return err;
+}
+
+static void
+tc_ct_del_ct_table_miss_rule(struct mlx5_tc_ct_priv *ct_priv)
+{
+	mlx5_del_flow_rules(ct_priv->miss_rule);
+	mlx5_destroy_flow_group(ct_priv->miss_grp);
+}
+
 #define INIT_ERR_PREFIX "tc ct offload init failed"
 
 struct mlx5_tc_ct_priv *
@@ -1962,6 +2032,18 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 		goto err_post_ct_tbl;
 	}
 
+	ct_priv->trk_new_ct = mlx5_chains_create_global_table(chains);
+	if (IS_ERR(ct_priv->trk_new_ct)) {
+		err = PTR_ERR(ct_priv->trk_new_ct);
+		mlx5_core_warn(dev, "%s, failed to create trk new ct table err: %d",
+			       INIT_ERR_PREFIX, err);
+		goto err_trk_new_ct_tbl;
+	}
+
+	err = tc_ct_add_ct_table_miss_rule(ct_priv);
+	if (err)
+		goto err_init_ct_tbl;
+
 	idr_init(&ct_priv->fte_ids);
 	mutex_init(&ct_priv->control_lock);
 	mutex_init(&ct_priv->shared_counter_lock);
@@ -1971,6 +2053,10 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 
 	return ct_priv;
 
+err_init_ct_tbl:
+	mlx5_chains_destroy_global_table(chains, ct_priv->trk_new_ct);
+err_trk_new_ct_tbl:
+	mlx5_chains_destroy_global_table(chains, ct_priv->post_ct);
 err_post_ct_tbl:
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct_nat);
 err_ct_nat_tbl:
@@ -1997,6 +2083,8 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 
 	chains = ct_priv->chains;
 
+	tc_ct_del_ct_table_miss_rule(ct_priv);
+	mlx5_chains_destroy_global_table(chains, ct_priv->trk_new_ct);
 	mlx5_chains_destroy_global_table(chains, ct_priv->post_ct);
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct_nat);
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
-- 
2.26.2

