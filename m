Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED98534E023
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhC3E2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhC3E1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36ACC6044F;
        Tue, 30 Mar 2021 04:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078468;
        bh=nuaJ7ErzfpttZK9R2bM3btU82CpFfbVJBG9iNKXu9qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7O3KdK2UFjRGfRSMCF2nc0vY5nM8VDIyG970ROrIqnHzWYoJRK8vueoWEOEGNmQ1
         2eqcIO9yQfrzqg+FcWtXghD7rAIsu85Y3PynLPxiDrPKQLRXxhN/gmvI/aGs1fpiDg
         anSAmKwpHAWk9/GRSVDQAu9+6IbWSFZ0W++IHyy35tNuUcWtcd0X4jgAEQwgBHGv/L
         XpFvVfT5dg5RpntX76TSPheUY3vS+MwX0aNOrTbfB8ovCozDUUBL2A/D3SZtbZuF2e
         B/T1MZKVCESQFU8UibNjI659ipjsDeNydNhH3bm+75vHJbzoqr+Lqruq29jRCJzrYd
         i722nWk3/0VEA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/12] net/mlx5e: Introduce Flow Steering ANY API
Date:   Mon, 29 Mar 2021 21:27:38 -0700
Message-Id: <20210330042741.198601-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add a new FS API which captures the ANY traffic from the traffic
classifier into a dedicated FS table. The table consists of a group
matching the ethertype and a must-be-last group which contains a default
rule redirecting the unmatched packets back to the RSS logic.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   3 +
 .../mellanox/mlx5/core/en/fs_tt_redirect.c    | 262 ++++++++++++++++++
 .../mellanox/mlx5/core/en/fs_tt_redirect.h    |   7 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   2 +-
 4 files changed, 273 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 496f5b9fe070..c61fbb9c6fa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -138,6 +138,7 @@ enum {
 	MLX5E_TTC_FT_LEVEL,
 	MLX5E_INNER_TTC_FT_LEVEL,
 	MLX5E_FS_TT_UDP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
+	MLX5E_FS_TT_ANY_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #ifdef CONFIG_MLX5_EN_TLS
 	MLX5E_ACCEL_FS_TCP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #endif
@@ -243,6 +244,7 @@ struct mlx5e_accel_fs_tcp;
 #endif
 
 struct mlx5e_fs_udp;
+struct mlx5e_fs_any;
 
 struct mlx5e_flow_steering {
 	struct mlx5_flow_namespace      *ns;
@@ -263,6 +265,7 @@ struct mlx5e_flow_steering {
 	struct mlx5e_accel_fs_tcp      *accel_tcp;
 #endif
 	struct mlx5e_fs_udp            *udp;
+	struct mlx5e_fs_any            *any;
 };
 
 struct ttc_params {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
index c37a7a7929c3..909faa6c89d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -17,6 +17,12 @@ struct mlx5e_fs_udp {
 	int ref_cnt;
 };
 
+struct mlx5e_fs_any {
+	struct mlx5e_flow_table table;
+	struct mlx5_flow_handle *default_rule;
+	int ref_cnt;
+};
+
 static char *fs_udp_type2str(enum fs_udp_type i)
 {
 	switch (i) {
@@ -341,3 +347,259 @@ int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv)
 	priv->fs.udp = NULL;
 	return err;
 }
+
+static void fs_any_set_ethertype_flow(struct mlx5_flow_spec *spec, u16 ether_type)
+{
+	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ethertype);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ethertype, ether_type);
+}
+
+struct mlx5_flow_handle *
+mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_priv *priv,
+				  u32 tir_num, u16 ether_type)
+{
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_table *ft = NULL;
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	struct mlx5e_fs_any *fs_any;
+	int err;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return ERR_PTR(-ENOMEM);
+
+	fs_any = priv->fs.any;
+	ft = fs_any->table.t;
+
+	fs_any_set_ethertype_flow(spec, ether_type);
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+	dest.tir_num = tir_num;
+
+	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
+	kvfree(spec);
+
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(priv->netdev, "%s: add ANY rule failed, err %d\n",
+			   __func__, err);
+	}
+	return rule;
+}
+
+static int fs_any_add_default_rule(struct mlx5e_priv *priv)
+{
+	struct mlx5e_flow_table *fs_any_t;
+	struct mlx5_flow_destination dest;
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	struct mlx5e_fs_any *fs_any;
+	int err;
+
+	fs_any = priv->fs.any;
+	fs_any_t = &fs_any->table;
+
+	dest = mlx5e_ttc_get_default_dest(priv, MLX5E_TT_ANY);
+	rule = mlx5_add_flow_rules(fs_any_t->t, NULL, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(priv->netdev,
+			   "%s: add default rule failed, fs type=ANY, err %d\n",
+			   __func__, err);
+		return err;
+	}
+
+	fs_any->default_rule = rule;
+	return 0;
+}
+
+#define MLX5E_FS_ANY_NUM_GROUPS	(2)
+#define MLX5E_FS_ANY_GROUP1_SIZE	(BIT(16))
+#define MLX5E_FS_ANY_GROUP2_SIZE	(BIT(0))
+#define MLX5E_FS_ANY_TABLE_SIZE		(MLX5E_FS_ANY_GROUP1_SIZE +\
+					 MLX5E_FS_ANY_GROUP2_SIZE)
+
+static int fs_any_create_groups(struct mlx5e_flow_table *ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	void *outer_headers_c;
+	int ix = 0;
+	u32 *in;
+	int err;
+	u8 *mc;
+
+	ft->g = kcalloc(MLX5E_FS_UDP_NUM_GROUPS, sizeof(*ft->g), GFP_KERNEL);
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if  (!in || !ft->g) {
+		kfree(ft->g);
+		kvfree(in);
+		return -ENOMEM;
+	}
+
+	/* Match on ethertype */
+	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+	outer_headers_c = MLX5_ADDR_OF(fte_match_param, mc, outer_headers);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ethertype);
+	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5E_FS_ANY_GROUP1_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err;
+	ft->num_groups++;
+
+	/* Default Flow Group */
+	memset(in, 0, inlen);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5E_FS_ANY_GROUP2_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err;
+	ft->num_groups++;
+
+	kvfree(in);
+	return 0;
+
+err:
+	err = PTR_ERR(ft->g[ft->num_groups]);
+	ft->g[ft->num_groups] = NULL;
+	kvfree(in);
+
+	return err;
+}
+
+static int fs_any_create_table(struct mlx5e_priv *priv)
+{
+	struct mlx5e_flow_table *ft = &priv->fs.any->table;
+	struct mlx5_flow_table_attr ft_attr = {};
+	int err;
+
+	ft->num_groups = 0;
+
+	ft_attr.max_fte = MLX5E_FS_UDP_TABLE_SIZE;
+	ft_attr.level = MLX5E_FS_TT_ANY_FT_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+
+	ft->t = mlx5_create_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft->t)) {
+		err = PTR_ERR(ft->t);
+		ft->t = NULL;
+		return err;
+	}
+
+	netdev_dbg(priv->netdev, "Created fs ANY table id %u level %u\n",
+		   ft->t->id, ft->t->level);
+
+	err = fs_any_create_groups(ft);
+	if (err)
+		goto err;
+
+	err = fs_any_add_default_rule(priv);
+	if (err)
+		goto err;
+
+	return 0;
+
+err:
+	mlx5e_destroy_flow_table(ft);
+	return err;
+}
+
+static int fs_any_disable(struct mlx5e_priv *priv)
+{
+	int err;
+
+	/* Modify ttc rules destination to point back to the indir TIRs */
+	err = mlx5e_ttc_fwd_default_dest(priv, MLX5E_TT_ANY);
+	if (err) {
+		netdev_err(priv->netdev,
+			   "%s: modify ttc[%d] default destination failed, err(%d)\n",
+			   __func__, MLX5E_TT_ANY, err);
+		return err;
+	}
+	return 0;
+}
+
+static int fs_any_enable(struct mlx5e_priv *priv)
+{
+	struct mlx5_flow_destination dest = {};
+	int err;
+
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = priv->fs.any->table.t;
+
+	/* Modify ttc rules destination to point on the accel_fs FTs */
+	err = mlx5e_ttc_fwd_dest(priv, MLX5E_TT_ANY, &dest);
+	if (err) {
+		netdev_err(priv->netdev,
+			   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+			   __func__, MLX5E_TT_ANY, err);
+		return err;
+	}
+	return 0;
+}
+
+static void fs_any_destroy_table(struct mlx5e_fs_any *fs_any)
+{
+	if (IS_ERR_OR_NULL(fs_any->table.t))
+		return;
+
+	mlx5_del_flow_rules(fs_any->default_rule);
+	mlx5e_destroy_flow_table(&fs_any->table);
+	fs_any->table.t = NULL;
+}
+
+void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_priv *priv)
+{
+	struct mlx5e_fs_any *fs_any = priv->fs.any;
+
+	if (!fs_any)
+		return;
+
+	if (--fs_any->ref_cnt)
+		return;
+
+	fs_any_disable(priv);
+
+	fs_any_destroy_table(fs_any);
+
+	kfree(fs_any);
+	priv->fs.any = NULL;
+}
+
+int mlx5e_fs_tt_redirect_any_create(struct mlx5e_priv *priv)
+{
+	int err;
+
+	if (priv->fs.any) {
+		priv->fs.any->ref_cnt++;
+		return 0;
+	}
+
+	priv->fs.any = kzalloc(sizeof(*priv->fs.any), GFP_KERNEL);
+	if (!priv->fs.any)
+		return -ENOMEM;
+
+	err = fs_any_create_table(priv);
+	if (err)
+		return err;
+
+	err = fs_any_enable(priv);
+	if (err)
+		goto err_destroy_table;
+
+	priv->fs.any->ref_cnt = 1;
+
+	return 0;
+
+err_destroy_table:
+	fs_any_destroy_table(priv->fs.any);
+
+	kfree(priv->fs.any);
+	priv->fs.any = NULL;
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
index b840d5cafb57..8385df24eb99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
@@ -16,4 +16,11 @@ mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
 				  u32 tir_num, u16 d_port);
 void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_priv *priv);
 int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv);
+
+/* ANY traffic type redirect*/
+struct mlx5_flow_handle *
+mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_priv *priv,
+				  u32 tir_num, u16 ether_type);
+void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_priv *priv);
+int mlx5e_fs_tt_redirect_any_create(struct mlx5e_priv *priv);
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index b9ebacdcbdfe..dbd910656574 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -105,7 +105,7 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/aRFS/accel/{esp, esp_err}} */
+/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}} */
 #define KERNEL_NIC_PRIO_NUM_LEVELS 7
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
-- 
2.30.2

