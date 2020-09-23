Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B669F276422
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgIWWsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgIWWsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:48:38 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C092235FC;
        Wed, 23 Sep 2020 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600901318;
        bh=w5AhULHWLCvSVqt25LwQUz6mSHBhxXEmQ9PP0itqRtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5PZeWbhEYA7yp41kaOFvx54U0p0haPJYK31wx2TCHBVDzFhN4hPcKlfHAuFT+n/i
         miBDtcOm/+U+LbXKbpPfCDXcSZ4pmgInGaTcMdeJv+z10NZa6/iwwMdN0MdudXamAI
         8B53HjOmrLRSsczd5fLZ9kHqyeFQAkz6M0xTffQM=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 03/15] net/mlx5e: Tc nic flows to use mlx5_chains flow tables
Date:   Wed, 23 Sep 2020 15:48:12 -0700
Message-Id: <20200923224824.67340-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923224824.67340-1-saeed@kernel.org>
References: <20200923224824.67340-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Change nic tc flows offload path to use the chains and prios
infrastructure for the flow table creation as a preparation to
support tc multi chains and priorities for nic flows.

Adding an instance of the table chaining database to the nic tc struct
and perform the root table creation and desctuction via the chains api
while keeping the limit of a single chain (0) in nic tc mode.
This will be extendable to supporting multiple chains in the following
patches.

The flow table sizes and default miss table parameters that are provided
to the chains creation api are kept the same.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 86 ++++++++++++-------
 2 files changed, 60 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 6fdcd5e69476..ef3c9a165b1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -12,9 +12,12 @@ enum {
 };
 
 struct mlx5e_tc_table {
-	/* protects flow table */
+	/* Protects the dynamic assignment of the t parameter
+	 * which is the nic tc root table.
+	 */
 	struct mutex			t_lock;
 	struct mlx5_flow_table		*t;
+	struct mlx5_fs_chains           *chains;
 
 	struct rhashtable               ht;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 557769c16393..0cc81f8d2f5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -68,6 +68,7 @@
 #include "lib/fs_chains.h"
 #include "diag/en_tc_tracepoint.h"
 
+#define nic_chains(priv) ((priv)->fs.tc.chains)
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
 
 struct mlx5_nic_flow_attr {
@@ -170,7 +171,7 @@ struct mlx5e_tc_flow_parse_attr {
 };
 
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
-#define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(16)
+#define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(18)
 
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[CHAIN_TO_REG] = {
@@ -898,6 +899,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 {
 	struct mlx5_flow_context *flow_context = &parse_attr->spec.flow_context;
 	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
+	struct mlx5e_tc_table *tc = &priv->fs.tc;
 	struct mlx5_core_dev *dev = priv->mdev;
 	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_flow_act flow_act = {
@@ -948,35 +950,19 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	mutex_lock(&priv->fs.tc.t_lock);
-	if (IS_ERR_OR_NULL(priv->fs.tc.t)) {
-		struct mlx5_flow_table_attr ft_attr = {};
-		int tc_grp_size, tc_tbl_size, tc_num_grps;
-		u32 max_flow_counter;
-
-		max_flow_counter = (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
-				    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
-
-		tc_grp_size = min_t(int, max_flow_counter, MLX5E_TC_TABLE_MAX_GROUP_SIZE);
-
-		tc_tbl_size = min_t(int, tc_grp_size * MLX5E_TC_TABLE_NUM_GROUPS,
-				    BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev, log_max_ft_size)));
-		tc_num_grps = MLX5E_TC_TABLE_NUM_GROUPS;
-
-		ft_attr.prio = MLX5E_TC_PRIO;
-		ft_attr.max_fte = tc_tbl_size;
-		ft_attr.level = MLX5E_TC_FT_LEVEL;
-		ft_attr.autogroup.max_num_groups = tc_num_grps;
-		priv->fs.tc.t =
-			mlx5_create_auto_grouped_flow_table(priv->fs.ns,
-							    &ft_attr);
-		if (IS_ERR(priv->fs.tc.t)) {
-			mutex_unlock(&priv->fs.tc.t_lock);
+	mutex_lock(&tc->t_lock);
+	if (IS_ERR_OR_NULL(tc->t)) {
+		/* Create the root table here if doesn't exist yet */
+		tc->t =
+			mlx5_chains_get_table(nic_chains(priv), 0, 1, MLX5E_TC_FT_LEVEL);
+
+		if (IS_ERR(tc->t)) {
+			mutex_unlock(&tc->t_lock);
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Failed to create tc offload table");
 			netdev_err(priv->netdev,
 				   "Failed to create tc offload table\n");
-			return PTR_ERR(priv->fs.tc.t);
+			return PTR_ERR(tc->t);
 		}
 	}
 
@@ -994,6 +980,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
+	struct mlx5e_tc_table *tc = &priv->fs.tc;
 	struct mlx5_fc *counter = NULL;
 
 	counter = attr->counter;
@@ -1002,8 +989,9 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	mlx5_fc_destroy(priv->mdev, counter);
 
 	mutex_lock(&priv->fs.tc.t_lock);
-	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) && priv->fs.tc.t) {
-		mlx5_destroy_flow_table(priv->fs.tc.t);
+	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) &&
+	    !IS_ERR_OR_NULL(tc->t)) {
+		mlx5_chains_put_table(nic_chains(priv), 0, 1, MLX5E_TC_FT_LEVEL);
 		priv->fs.tc.t = NULL;
 	}
 	mutex_unlock(&priv->fs.tc.t_lock);
@@ -4951,9 +4939,27 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
+static int mlx5e_tc_nic_get_ft_size(struct mlx5_core_dev *dev)
+{
+	int tc_grp_size, tc_tbl_size;
+	u32 max_flow_counter;
+
+	max_flow_counter = (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
+			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
+
+	tc_grp_size = min_t(int, max_flow_counter, MLX5E_TC_TABLE_MAX_GROUP_SIZE);
+
+	tc_tbl_size = min_t(int, tc_grp_size * MLX5E_TC_TABLE_NUM_GROUPS,
+			    BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev, log_max_ft_size)));
+
+	return tc_tbl_size;
+}
+
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct mlx5_core_dev *dev = priv->mdev;
+	struct mlx5_chains_attr attr = {};
 	int err;
 
 	mlx5e_mod_hdr_tbl_init(&tc->mod_hdr);
@@ -4965,6 +4971,17 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	if (err)
 		return err;
 
+	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
+	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
+	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
+	attr.default_ft = priv->fs.vlan.ft.t;
+
+	tc->chains = mlx5_chains_create(dev, &attr);
+	if (IS_ERR(tc->chains)) {
+		err = PTR_ERR(tc->chains);
+		goto err_chains;
+	}
+
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
 	err = register_netdevice_notifier_dev_net(priv->netdev,
 						  &tc->netdevice_nb,
@@ -4972,8 +4989,15 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	if (err) {
 		tc->netdevice_nb.notifier_call = NULL;
 		mlx5_core_warn(priv->mdev, "Failed to register netdev notifier\n");
+		goto err_reg;
 	}
 
+	return 0;
+
+err_reg:
+	mlx5_chains_destroy(tc->chains);
+err_chains:
+	rhashtable_destroy(&tc->ht);
 	return err;
 }
 
@@ -4998,13 +5022,15 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_mod_hdr_tbl_destroy(&tc->mod_hdr);
 	mutex_destroy(&tc->hairpin_tbl_lock);
 
-	rhashtable_destroy(&tc->ht);
+	rhashtable_free_and_destroy(&tc->ht, _mlx5e_tc_del_flow, NULL);
 
 	if (!IS_ERR_OR_NULL(tc->t)) {
-		mlx5_destroy_flow_table(tc->t);
+		mlx5_chains_put_table(tc->chains, 0, 1, MLX5E_TC_FT_LEVEL);
 		tc->t = NULL;
 	}
 	mutex_destroy(&tc->t_lock);
+
+	mlx5_chains_destroy(tc->chains);
 }
 
 int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
-- 
2.26.2

