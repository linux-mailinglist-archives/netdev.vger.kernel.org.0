Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223C06B8DF3
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCNI7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCNI7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:59:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAC1911D3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D96A4615FE
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178B7C433D2;
        Tue, 14 Mar 2023 08:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784339;
        bh=jDNmKN1uoMTaBU3Vl2z/TYmmsi4zJ3MirQ6tfepgLYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDaHCon0bErd8YVLnzj+4HiFmR2atX4r9AzO7bOvhGr8dQtSzQZXqLbfjKk/oTyv9
         wa8lHfmeUAqSvZR9zVORs/WhLUGiTtTJqq3CP/tqVUFQLi1Z23w9K+KM2FmJx2lAvm
         KpLU6M5QkzC4pd5Z/SDcD7aBee4tbNgI4lru0N3MRplA/czQlTJYXfi+s9FBegYDOS
         aM1qAl8lM0eWwYvGlzH293mHa5zKpf6P/erj+1rPdguFNAQcji1HPZx/QkNS9gNtzj
         3gsllq+mbtEYDhbmLgGPFRCf9BTmZ6vxFb8kl5QQFoPF+4srK6Yt4KJdlBo16BbGTd
         XvpqHq5hZC0ug==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Paul Blakey <paulb@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next 1/9] net/mlx5: fs_chains: Refactor to detach chains from tc usage
Date:   Tue, 14 Mar 2023 10:58:36 +0200
Message-Id: <bb8570d532d569285b5bff981578507bd15350cb.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

To support more generic chains that will be used on other
namespaces and without tc, refactor to remove the dependency
on tc terms.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 20 +----
 .../mellanox/mlx5/core/eswitch_offloads.c     |  6 +-
 .../mellanox/mlx5/core/lib/fs_chains.c        | 89 +++++++++----------
 .../mellanox/mlx5/core/lib/fs_chains.h        |  9 +-
 4 files changed, 55 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 70b8d2dfa751..98c9befb7803 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5186,22 +5186,6 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static int mlx5e_tc_nic_get_ft_size(struct mlx5_core_dev *dev)
-{
-	int tc_grp_size, tc_tbl_size;
-	u32 max_flow_counter;
-
-	max_flow_counter = (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
-			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
-
-	tc_grp_size = min_t(int, max_flow_counter, MLX5E_TC_TABLE_MAX_GROUP_SIZE);
-
-	tc_tbl_size = min_t(int, tc_grp_size * MLX5E_TC_TABLE_NUM_GROUPS,
-			    BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev, log_max_ft_size)));
-
-	return tc_tbl_size;
-}
-
 static int mlx5e_tc_nic_create_miss_table(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
@@ -5274,10 +5258,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 		attr.flags = MLX5_CHAINS_AND_PRIOS_SUPPORTED |
 			MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
-	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
 	attr.default_ft = tc->miss_t;
 	attr.mapping = chains_mapping;
+	attr.fs_base_prio = MLX5E_TC_PRIO;
 
 	tc->chains = mlx5_chains_create(dev, &attr);
 	if (IS_ERR(tc->chains)) {
@@ -5285,6 +5269,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 		goto err_miss;
 	}
 
+	mlx5_chains_print_info(tc->chains);
+
 	tc->post_act = mlx5e_tc_post_act_init(priv, tc->chains, MLX5_FLOW_NAMESPACE_KERNEL);
 	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &tc->mod_hdr,
 				 MLX5_FLOW_NAMESPACE_KERNEL, tc->post_act);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d766a64b1823..5b02880dfa20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1374,14 +1374,11 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
 	struct mlx5_flow_table *nf_ft, *ft;
 	struct mlx5_chains_attr attr = {};
 	struct mlx5_fs_chains *chains;
-	u32 fdb_max;
 	int err;
 
-	fdb_max = 1 << MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size);
-
 	esw_init_chains_offload_flags(esw, &attr.flags);
 	attr.ns = MLX5_FLOW_NAMESPACE_FDB;
-	attr.max_ft_sz = fdb_max;
+	attr.fs_base_prio = FDB_TC_OFFLOAD;
 	attr.max_grp_num = esw->params.large_group_num;
 	attr.default_ft = miss_fdb;
 	attr.mapping = esw->offloads.reg_c0_obj_pool;
@@ -1392,6 +1389,7 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
 		esw_warn(dev, "Failed to create fdb chains err(%d)\n", err);
 		return err;
 	}
+	mlx5_chains_print_info(chains);
 
 	esw->fdb_table.offloads.esw_chains_priv = chains;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 81ed91fee59b..db9df9798ffa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -14,10 +14,8 @@
 #define chains_lock(chains) ((chains)->lock)
 #define chains_ht(chains) ((chains)->chains_ht)
 #define prios_ht(chains) ((chains)->prios_ht)
-#define tc_default_ft(chains) ((chains)->tc_default_ft)
-#define tc_end_ft(chains) ((chains)->tc_end_ft)
-#define ns_to_chains_fs_prio(ns) ((ns) == MLX5_FLOW_NAMESPACE_FDB ? \
-				  FDB_TC_OFFLOAD : MLX5E_TC_PRIO)
+#define chains_default_ft(chains) ((chains)->chains_default_ft)
+#define chains_end_ft(chains) ((chains)->chains_end_ft)
 #define FT_TBL_SZ (64 * 1024)
 
 struct mlx5_fs_chains {
@@ -28,13 +26,15 @@ struct mlx5_fs_chains {
 	/* Protects above chains_ht and prios_ht */
 	struct mutex lock;
 
-	struct mlx5_flow_table *tc_default_ft;
-	struct mlx5_flow_table *tc_end_ft;
+	struct mlx5_flow_table *chains_default_ft;
+	struct mlx5_flow_table *chains_end_ft;
 	struct mapping_ctx *chains_mapping;
 
 	enum mlx5_flow_namespace_type ns;
 	u32 group_num;
 	u32 flags;
+	int fs_base_prio;
+	int fs_base_level;
 };
 
 struct fs_chain {
@@ -145,7 +145,7 @@ void
 mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
 		       struct mlx5_flow_table *ft)
 {
-	tc_end_ft(chains) = ft;
+	chains_end_ft(chains) = ft;
 }
 
 static struct mlx5_flow_table *
@@ -164,11 +164,11 @@ mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 	sz = (chain == mlx5_chains_get_nf_ft_chain(chains)) ? FT_TBL_SZ : POOL_NEXT_SIZE;
 	ft_attr.max_fte = sz;
 
-	/* We use tc_default_ft(chains) as the table's next_ft till
+	/* We use chains_default_ft(chains) as the table's next_ft till
 	 * ignore_flow_level is allowed on FT creation and not just for FTEs.
 	 * Instead caller should add an explicit miss rule if needed.
 	 */
-	ft_attr.next_ft = tc_default_ft(chains);
+	ft_attr.next_ft = chains_default_ft(chains);
 
 	/* The root table(chain 0, prio 1, level 0) is required to be
 	 * connected to the previous fs_core managed prio.
@@ -177,22 +177,22 @@ mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 	 */
 	if (!mlx5_chains_ignore_flow_level_supported(chains) ||
 	    (chain == 0 && prio == 1 && level == 0)) {
-		ft_attr.level = level;
-		ft_attr.prio = prio - 1;
+		ft_attr.level = chains->fs_base_level;
+		ft_attr.prio = chains->fs_base_prio;
 		ns = (chains->ns == MLX5_FLOW_NAMESPACE_FDB) ?
 			mlx5_get_fdb_sub_ns(chains->dev, chain) :
 			mlx5_get_flow_namespace(chains->dev, chains->ns);
 	} else {
 		ft_attr.flags |= MLX5_FLOW_TABLE_UNMANAGED;
-		ft_attr.prio = ns_to_chains_fs_prio(chains->ns);
+		ft_attr.prio = chains->fs_base_prio;
 		/* Firmware doesn't allow us to create another level 0 table,
-		 * so we create all unmanaged tables as level 1.
+		 * so we create all unmanaged tables as level 1 (base + 1).
 		 *
 		 * To connect them, we use explicit miss rules with
 		 * ignore_flow_level. Caller is responsible to create
 		 * these rules (if needed).
 		 */
-		ft_attr.level = 1;
+		ft_attr.level = chains->fs_base_level + 1;
 		ns = mlx5_get_flow_namespace(chains->dev, chains->ns);
 	}
 
@@ -220,7 +220,8 @@ create_chain_restore(struct fs_chain *chain)
 	int err;
 
 	if (chain->chain == mlx5_chains_get_nf_ft_chain(chains) ||
-	    !mlx5_chains_prios_supported(chains))
+	    !mlx5_chains_prios_supported(chains) ||
+	    !chains->chains_mapping)
 		return 0;
 
 	err = mlx5_chains_get_chain_mapping(chains, chain->chain, &index);
@@ -380,7 +381,7 @@ mlx5_chains_add_miss_rule(struct fs_chain *chain,
 	dest.type  = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = next_ft;
 
-	if (next_ft == tc_end_ft(chains) &&
+	if (chains->chains_mapping && next_ft == chains_end_ft(chains) &&
 	    chain->chain != mlx5_chains_get_nf_ft_chain(chains) &&
 	    mlx5_chains_prios_supported(chains)) {
 		act.modify_hdr = chain->miss_modify_hdr;
@@ -494,8 +495,8 @@ mlx5_chains_create_prio(struct mlx5_fs_chains *chains,
 
 	/* Default miss for each chain: */
 	next_ft = (chain == mlx5_chains_get_nf_ft_chain(chains)) ?
-		  tc_default_ft(chains) :
-		  tc_end_ft(chains);
+		  chains_default_ft(chains) :
+		  chains_end_ft(chains);
 	list_for_each(pos, &chain_s->prios_list) {
 		struct prio *p = list_entry(pos, struct prio, list);
 
@@ -681,7 +682,7 @@ mlx5_chains_put_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
 struct mlx5_flow_table *
 mlx5_chains_get_tc_end_ft(struct mlx5_fs_chains *chains)
 {
-	return tc_end_ft(chains);
+	return chains_end_ft(chains);
 }
 
 struct mlx5_flow_table *
@@ -718,48 +719,38 @@ mlx5_chains_destroy_global_table(struct mlx5_fs_chains *chains,
 static struct mlx5_fs_chains *
 mlx5_chains_init(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
 {
-	struct mlx5_fs_chains *chains_priv;
-	u32 max_flow_counter;
+	struct mlx5_fs_chains *chains;
 	int err;
 
-	chains_priv = kzalloc(sizeof(*chains_priv), GFP_KERNEL);
-	if (!chains_priv)
+	chains = kzalloc(sizeof(*chains), GFP_KERNEL);
+	if (!chains)
 		return ERR_PTR(-ENOMEM);
 
-	max_flow_counter = (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
-			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
-
-	mlx5_core_dbg(dev,
-		      "Init flow table chains, max counters(%d), groups(%d), max flow table size(%d)\n",
-		      max_flow_counter, attr->max_grp_num, attr->max_ft_sz);
-
-	chains_priv->dev = dev;
-	chains_priv->flags = attr->flags;
-	chains_priv->ns = attr->ns;
-	chains_priv->group_num = attr->max_grp_num;
-	chains_priv->chains_mapping = attr->mapping;
-	tc_default_ft(chains_priv) = tc_end_ft(chains_priv) = attr->default_ft;
+	chains->dev = dev;
+	chains->flags = attr->flags;
+	chains->ns = attr->ns;
+	chains->group_num = attr->max_grp_num;
+	chains->chains_mapping = attr->mapping;
+	chains->fs_base_prio = attr->fs_base_prio;
+	chains->fs_base_level = attr->fs_base_level;
+	chains_default_ft(chains) = chains_end_ft(chains) = attr->default_ft;
 
-	mlx5_core_info(dev, "Supported tc offload range - chains: %u, prios: %u\n",
-		       mlx5_chains_get_chain_range(chains_priv),
-		       mlx5_chains_get_prio_range(chains_priv));
-
-	err = rhashtable_init(&chains_ht(chains_priv), &chain_params);
+	err = rhashtable_init(&chains_ht(chains), &chain_params);
 	if (err)
 		goto init_chains_ht_err;
 
-	err = rhashtable_init(&prios_ht(chains_priv), &prio_params);
+	err = rhashtable_init(&prios_ht(chains), &prio_params);
 	if (err)
 		goto init_prios_ht_err;
 
-	mutex_init(&chains_lock(chains_priv));
+	mutex_init(&chains_lock(chains));
 
-	return chains_priv;
+	return chains;
 
 init_prios_ht_err:
-	rhashtable_destroy(&chains_ht(chains_priv));
+	rhashtable_destroy(&chains_ht(chains));
 init_chains_ht_err:
-	kfree(chains_priv);
+	kfree(chains);
 	return ERR_PTR(err);
 }
 
@@ -808,3 +799,9 @@ mlx5_chains_put_chain_mapping(struct mlx5_fs_chains *chains, u32 chain_mapping)
 
 	return mapping_remove(ctx, chain_mapping);
 }
+
+void
+mlx5_chains_print_info(struct mlx5_fs_chains *chains)
+{
+	mlx5_core_dbg(chains->dev, "Flow table chains groups(%d)\n", chains->group_num);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
index d50bdb226cef..8972fe05723a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
@@ -17,8 +17,9 @@ enum mlx5_chains_flags {
 
 struct mlx5_chains_attr {
 	enum mlx5_flow_namespace_type ns;
+	int fs_base_prio;
+	int fs_base_level;
 	u32 flags;
-	u32 max_ft_sz;
 	u32 max_grp_num;
 	struct mlx5_flow_table *default_ft;
 	struct mapping_ctx *mapping;
@@ -68,6 +69,8 @@ void mlx5_chains_destroy(struct mlx5_fs_chains *chains);
 void
 mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
 		       struct mlx5_flow_table *ft);
+void
+mlx5_chains_print_info(struct mlx5_fs_chains *chains);
 
 #else /* CONFIG_MLX5_CLS_ACT */
 
@@ -89,7 +92,9 @@ static inline struct mlx5_fs_chains *
 mlx5_chains_create(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
 { return NULL; }
 static inline void
-mlx5_chains_destroy(struct mlx5_fs_chains *chains) {};
+mlx5_chains_destroy(struct mlx5_fs_chains *chains) {}
+static inline void
+mlx5_chains_print_info(struct mlx5_fs_chains *chains) {}
 
 #endif /* CONFIG_MLX5_CLS_ACT */
 
-- 
2.39.2

