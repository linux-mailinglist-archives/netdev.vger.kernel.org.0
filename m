Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDE73562BD
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348579AbhDGEzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344935AbhDGEyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA5E7613C6;
        Wed,  7 Apr 2021 04:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771278;
        bh=nrWvwM/TLgu253SWcQpTU5t2/MljfU01Oj8upaetVqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJXAQu3MY07nXl+jSEi9L7zzGgu3miuECa8P7rf1yYP8TlUlkgMHYTTJFK6Vcxp8p
         vwp7/FFgsKB2xOQgwAWRG1Pmk1Mo7neV7jya9YjoodsQNEtnnRkytzJ9mW3+Z2nj5R
         bJvu17fDylZFPKxv9sN9IfyIFqcan47u8e7ZAD1JuhowDD3J8calVWQbDgW4QLzGLd
         Ov3kek6Chp33H3lBrJ/v4/ZdjXSB9qHfFMfCmxklb0nDBc7uA9XgLQcjffNaLbsIU1
         LXm+iUFU866aYtyFTrA/C66tou/TZis47fGk26jdDMLnE959upF+s06EVKX1Dx3TMr
         r5yBVxebSDaDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/13] net/mlx5: Instantiate separate mapping objects for FDB and NIC tables
Date:   Tue,  6 Apr 2021 21:54:14 -0700
Message-Id: <20210407045421.148987-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently, the u32 chain id is mapped to u16 value which is stored on
the lower 16 bits of reg_c0 for FDB and reg_b for NIC tables. The
mapping is internally maintained by the chains object. However, with
the introduction of reg_c0 objects the fdb may store more than just
the chain id on reg_c0. This is not relevant for NIC tables.

Separate the chains mapping instantiation for FDB and NIC tables.
Remove the mapping from the chains object. For FDB tables, create
the mapping per eswitch. For NIC tables, create the mapping per tc
table. Pass the corresponding mapping pointer when creating the
chains object.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  5 ++-
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  1 +
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 19 +++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 16 ++++++-
 .../mellanox/mlx5/core/lib/fs_chains.c        | 42 +++----------------
 .../mellanox/mlx5/core/lib/fs_chains.h        |  5 +--
 8 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 4c86b68ad26c..5bedc2c4d26f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -37,9 +37,10 @@ mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag_mp.o lib/geneve.o lib/port_tun.o \
-					en_rep.o en/rep/bond.o en/mod_hdr.o
+					en_rep.o en/rep/bond.o en/mod_hdr.o \
+					en/mapping.o
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
-					en/mapping.o lib/fs_chains.o en/tc_tun.o \
+					lib/fs_chains.o en/tc_tun.o \
 					esw/indir_table.o en/tc_tun_encap.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 373bd89484cb..1d5ce07b83f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -29,6 +29,7 @@ struct mlx5e_tc_table {
 	struct netdev_net_notifier	netdevice_nn;
 
 	struct mlx5_tc_ct_priv         *ct;
+	struct mapping_ctx             *mapping;
 };
 
 struct mlx5e_flow_table {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index dde83cba85c3..9b55a5c394d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -641,7 +641,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
 
-	err = mlx5_get_mapped_object(esw_chains(esw), reg_c0, &mapped_obj);
+	err = mapping_find(esw->offloads.reg_c0_obj_pool, reg_c0, &mapped_obj);
 	if (err) {
 		netdev_dbg(priv->netdev,
 			   "Couldn't find mapped object for reg_c0: %d, err: %d\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9b5607ddb9a2..c938215c8fbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4731,6 +4731,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 	struct mlx5_core_dev *dev = priv->mdev;
+	struct mapping_ctx *chains_mapping;
 	struct mlx5_chains_attr attr = {};
 	int err;
 
@@ -4745,15 +4746,22 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 
 	lockdep_set_class(&tc->ht.mutex, &tc_ht_lock_key);
 
-	if (MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level)) {
+	chains_mapping = mapping_create(sizeof(struct mlx5_mapped_obj),
+					MLX5E_TC_TABLE_CHAIN_TAG_MASK, true);
+	if (IS_ERR(chains_mapping)) {
+		err = PTR_ERR(chains_mapping);
+		goto err_mapping;
+	}
+	tc->mapping = chains_mapping;
+
+	if (MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level))
 		attr.flags = MLX5_CHAINS_AND_PRIOS_SUPPORTED |
 			MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
-		attr.max_restore_tag = MLX5E_TC_TABLE_CHAIN_TAG_MASK;
-	}
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
 	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
 	attr.default_ft = mlx5e_vlan_get_flowtable(priv->fs.vlan);
+	attr.mapping = chains_mapping;
 
 	tc->chains = mlx5_chains_create(dev, &attr);
 	if (IS_ERR(tc->chains)) {
@@ -4780,6 +4788,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	mlx5_tc_ct_clean(tc->ct);
 	mlx5_chains_destroy(tc->chains);
 err_chains:
+	mapping_destroy(chains_mapping);
+err_mapping:
 	rhashtable_destroy(&tc->ht);
 	return err;
 }
@@ -4814,6 +4824,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	mutex_destroy(&tc->t_lock);
 
 	mlx5_tc_ct_clean(tc->ct);
+	mapping_destroy(tc->mapping);
 	mlx5_chains_destroy(tc->chains);
 }
 
@@ -4981,7 +4992,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 	chain_tag = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
 
-	err = mlx5_get_mapped_object(nic_chains(priv), chain_tag, &mapped_obj);
+	err = mapping_find(tc->mapping, chain_tag, &mapped_obj);
 	if (err) {
 		netdev_dbg(priv->netdev,
 			   "Couldn't find chain for chain tag: %d, err: %d\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c5b35e7f8aed..a97396330160 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -217,6 +217,7 @@ struct mlx5_esw_offload {
 	struct mlx5_flow_table *ft_offloads_restore;
 	struct mlx5_flow_group *restore_group;
 	struct mlx5_modify_hdr *restore_copy_hdr_id;
+	struct mapping_ctx *reg_c0_obj_pool;
 
 	struct mlx5_flow_table *ft_offloads;
 	struct mlx5_flow_group *vport_rx_group;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 117d9fa93ff5..510e9b8b24fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -47,6 +47,7 @@
 #include "lib/eq.h"
 #include "lib/fs_chains.h"
 #include "en_tc.h"
+#include "en/mapping.h"
 
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
@@ -1428,7 +1429,7 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
 	attr.max_ft_sz = fdb_max;
 	attr.max_grp_num = esw->params.large_group_num;
 	attr.default_ft = miss_fdb;
-	attr.max_restore_tag = ESW_REG_C0_USER_DATA_METADATA_MASK;
+	attr.mapping = esw->offloads.reg_c0_obj_pool;
 
 	chains = mlx5_chains_create(dev, &attr);
 	if (IS_ERR(chains)) {
@@ -2595,6 +2596,7 @@ static int mlx5_esw_host_number_init(struct mlx5_eswitch *esw)
 
 int esw_offloads_enable(struct mlx5_eswitch *esw)
 {
+	struct mapping_ctx *reg_c0_obj_pool;
 	struct mlx5_vport *vport;
 	int err, i;
 
@@ -2622,6 +2624,15 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_vport_metadata;
 
+	reg_c0_obj_pool = mapping_create(sizeof(struct mlx5_mapped_obj),
+					 ESW_REG_C0_USER_DATA_METADATA_MASK,
+					 true);
+	if (IS_ERR(reg_c0_obj_pool)) {
+		err = PTR_ERR(reg_c0_obj_pool);
+		goto err_pool;
+	}
+	esw->offloads.reg_c0_obj_pool = reg_c0_obj_pool;
+
 	err = esw_offloads_steering_init(esw);
 	if (err)
 		goto err_steering_init;
@@ -2648,6 +2659,8 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 err_uplink:
 	esw_offloads_steering_cleanup(esw);
 err_steering_init:
+	mapping_destroy(reg_c0_obj_pool);
+err_pool:
 	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
 	esw_offloads_metadata_uninit(esw);
@@ -2686,6 +2699,7 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
+	mapping_destroy(esw->offloads.reg_c0_obj_pool);
 	esw_offloads_metadata_uninit(esw);
 	esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 	mlx5_rdma_disable_roce(esw->dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 00ff809dcfe8..00ef10a1a9f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -7,15 +7,11 @@
 
 #include "lib/fs_chains.h"
 #include "en/mapping.h"
-#include "mlx5_core.h"
 #include "fs_core.h"
-#include "eswitch.h"
-#include "en.h"
 #include "en_tc.h"
 
 #define chains_lock(chains) ((chains)->lock)
 #define chains_ht(chains) ((chains)->chains_ht)
-#define chains_mapping(chains) ((chains)->chains_mapping)
 #define prios_ht(chains) ((chains)->prios_ht)
 #define ft_pool_left(chains) ((chains)->ft_left)
 #define tc_default_ft(chains) ((chains)->tc_default_ft)
@@ -300,7 +296,7 @@ create_chain_restore(struct fs_chain *chain)
 	    !mlx5_chains_prios_supported(chains))
 		return 0;
 
-	err = mapping_add(chains_mapping(chains), &chain->chain, &index);
+	err = mlx5_chains_get_chain_mapping(chains, chain->chain, &index);
 	if (err)
 		return err;
 	if (index == MLX5_FS_DEFAULT_FLOW_TAG) {
@@ -310,10 +306,8 @@ create_chain_restore(struct fs_chain *chain)
 		 *
 		 * This case isn't possible with MLX5_FS_DEFAULT_FLOW_TAG = 0.
 		 */
-		err = mapping_add(chains_mapping(chains),
-				  &chain->chain, &index);
-		mapping_remove(chains_mapping(chains),
-			       MLX5_FS_DEFAULT_FLOW_TAG);
+		err = mlx5_chains_get_chain_mapping(chains, chain->chain, &index);
+		mapping_remove(chains->chains_mapping, MLX5_FS_DEFAULT_FLOW_TAG);
 		if (err)
 			return err;
 	}
@@ -361,7 +355,7 @@ create_chain_restore(struct fs_chain *chain)
 		mlx5_del_flow_rules(chain->restore_rule);
 err_rule:
 	/* Datapath can't find this mapping, so we can safely remove it */
-	mapping_remove(chains_mapping(chains), chain->id);
+	mapping_remove(chains->chains_mapping, chain->id);
 	return err;
 }
 
@@ -376,7 +370,7 @@ static void destroy_chain_restore(struct fs_chain *chain)
 		mlx5_del_flow_rules(chain->restore_rule);
 
 	mlx5_modify_header_dealloc(chains->dev, chain->miss_modify_hdr);
-	mapping_remove(chains_mapping(chains), chain->id);
+	mapping_remove(chains->chains_mapping, chain->id);
 }
 
 static struct fs_chain *
@@ -797,7 +791,6 @@ static struct mlx5_fs_chains *
 mlx5_chains_init(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
 {
 	struct mlx5_fs_chains *chains_priv;
-	struct mapping_ctx *mapping;
 	u32 max_flow_counter;
 	int err;
 
@@ -816,6 +809,7 @@ mlx5_chains_init(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
 	chains_priv->flags = attr->flags;
 	chains_priv->ns = attr->ns;
 	chains_priv->group_num = attr->max_grp_num;
+	chains_priv->chains_mapping = attr->mapping;
 	tc_default_ft(chains_priv) = tc_end_ft(chains_priv) = attr->default_ft;
 
 	mlx5_core_info(dev, "Supported tc offload range - chains: %u, prios: %u\n",
@@ -832,19 +826,10 @@ mlx5_chains_init(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
 	if (err)
 		goto init_prios_ht_err;
 
-	mapping = mapping_create(sizeof(struct mlx5_mapped_obj), attr->max_restore_tag, true);
-	if (IS_ERR(mapping)) {
-		err = PTR_ERR(mapping);
-		goto mapping_err;
-	}
-	chains_mapping(chains_priv) = mapping;
-
 	mutex_init(&chains_lock(chains_priv));
 
 	return chains_priv;
 
-mapping_err:
-	rhashtable_destroy(&prios_ht(chains_priv));
 init_prios_ht_err:
 	rhashtable_destroy(&chains_ht(chains_priv));
 init_chains_ht_err:
@@ -856,7 +841,6 @@ static void
 mlx5_chains_cleanup(struct mlx5_fs_chains *chains)
 {
 	mutex_destroy(&chains_lock(chains));
-	mapping_destroy(chains_mapping(chains));
 	rhashtable_destroy(&prios_ht(chains));
 	rhashtable_destroy(&chains_ht(chains));
 
@@ -898,17 +882,3 @@ mlx5_chains_put_chain_mapping(struct mlx5_fs_chains *chains, u32 chain_mapping)
 
 	return mapping_remove(ctx, chain_mapping);
 }
-
-int
-mlx5_get_mapped_object(struct mlx5_fs_chains *chains, u32 tag, struct mlx5_mapped_obj *obj)
-{
-	int err;
-
-	err = mapping_find(chains->chains_mapping, tag, obj);
-	if (err) {
-		mlx5_core_warn(chains->dev, "Can't find chain for tag: %d\n", tag);
-		return -ENOENT;
-	}
-
-	return 0;
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
index 75a3bba12a78..e96f345e7dae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
@@ -21,7 +21,7 @@ struct mlx5_chains_attr {
 	u32 max_ft_sz;
 	u32 max_grp_num;
 	struct mlx5_flow_table *default_ft;
-	u32 max_restore_tag;
+	struct mapping_ctx *mapping;
 };
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
@@ -64,9 +64,6 @@ struct mlx5_fs_chains *
 mlx5_chains_create(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr);
 void mlx5_chains_destroy(struct mlx5_fs_chains *chains);
 
-int
-mlx5_get_mapped_object(struct mlx5_fs_chains *chains, u32 tag, struct mlx5_mapped_obj *obj);
-
 void
 mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
 		       struct mlx5_flow_table *ft);
-- 
2.30.2

