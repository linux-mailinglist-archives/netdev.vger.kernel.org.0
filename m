Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1F275167
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgIWGYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgIWGYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:44 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 753692223E;
        Wed, 23 Sep 2020 06:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842280;
        bh=eGzMisXgTdQr48w4Uf2io9ataDGwEVxIsfw5goV8r/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q18btxp+35wHyYHTWFkt6pANjaRwl6zy2SV/Q+c9rFvI57WQW6yBDbrGGjQq9bf14
         yyb7HuJNN2xej/xjNCF57nDkZziELhwPuzJbeWKVZY8GvvLtG/lqIln2DhQK1I3UQq
         Xzf2+UzXvBG8KKiDe/Q22/IcB22yfMTwBWEjPfJg=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Refactor multi chains and prios support
Date:   Tue, 22 Sep 2020 23:24:24 -0700
Message-Id: <20200923062438.15997-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Decouple the chains infrastructure from eswitch and make
it generic to support other steering namespaces.

The change defines an agnostic data structure to keep
all the relevant information for maintaining flow table
chaining in any steering namespace. Each namespace that
requires table chaining will be required to allocate
such data structure.

The chains creation code will receive the steering namespace
and flow table parameters from the caller so it will operate
agnosticly when creating the required resources to
maintain the table chaining function while Parts of the code
that are relevant to eswitch specific functionality are moved
to eswitch files.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  16 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  31 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  12 +-
 .../ethernet/mellanox/mlx5/core/esw/chains.c  | 944 ------------------
 .../ethernet/mellanox/mlx5/core/esw/chains.h  |  68 --
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  12 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 159 ++-
 .../mellanox/mlx5/core/lib/fs_chains.c        | 902 +++++++++++++++++
 .../mellanox/mlx5/core/lib/fs_chains.h        |  93 ++
 11 files changed, 1174 insertions(+), 1066 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 0b3eaa102751..9826a041e407 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -37,7 +37,7 @@ mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag_mp.o lib/geneve.o lib/port_tun.o \
 					en_rep.o en/rep/bond.o en/mod_hdr.o
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
-					en/mapping.o esw/chains.o en/tc_tun.o \
+					en/mapping.o lib/fs_chains.o en/tc_tun.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 79cc42d88eec..771e73f211fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -12,7 +12,7 @@
 #include "neigh.h"
 #include "en_rep.h"
 #include "eswitch.h"
-#include "esw/chains.h"
+#include "lib/fs_chains.h"
 #include "en/tc_ct.h"
 #include "en/mapping.h"
 #include "en/tc_tun.h"
@@ -191,7 +191,7 @@ static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
 	case TC_SETUP_CLSFLOWER:
 		memcpy(&tmp, f, sizeof(*f));
 
-		if (!mlx5_esw_chains_prios_supported(esw))
+		if (!mlx5_chains_prios_supported(esw_chains(esw)))
 			return -EOPNOTSUPP;
 
 		/* Re-use tc offload path by moving the ft flow to the
@@ -203,12 +203,12 @@ static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
 		 *
 		 * We only support chain 0 of FT offload.
 		 */
-		if (tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw))
+		if (tmp.common.prio >= mlx5_chains_get_prio_range(esw_chains(esw)))
 			return -EOPNOTSUPP;
 		if (tmp.common.chain_index != 0)
 			return -EOPNOTSUPP;
 
-		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
+		tmp.common.chain_index = mlx5_chains_get_nf_ft_chain(esw_chains(esw));
 		tmp.common.prio++;
 		err = mlx5e_rep_setup_tc_cls_flower(priv, &tmp, flags);
 		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
@@ -378,12 +378,12 @@ static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
 		 *
 		 * We only support chain 0 of FT offload.
 		 */
-		if (!mlx5_esw_chains_prios_supported(esw) ||
-		    tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw) ||
+		if (!mlx5_chains_prios_supported(esw_chains(esw)) ||
+		    tmp.common.prio >= mlx5_chains_get_prio_range(esw_chains(esw)) ||
 		    tmp.common.chain_index)
 			return -EOPNOTSUPP;
 
-		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
+		tmp.common.chain_index = mlx5_chains_get_nf_ft_chain(esw_chains(esw));
 		tmp.common.prio++;
 		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
 		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
@@ -626,7 +626,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
 
-	err = mlx5_eswitch_get_chain_for_tag(esw, reg_c0, &chain);
+	err = mlx5_get_chain_for_tag(esw_chains(esw), reg_c0, &chain);
 	if (err) {
 		netdev_dbg(priv->netdev,
 			   "Couldn't find chain for chain tag: %d, err: %d\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index bc5f72ec3623..579f888c22ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -14,7 +14,7 @@
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
 
-#include "esw/chains.h"
+#include "lib/fs_chains.h"
 #include "en/tc_ct.h"
 #include "en/mod_hdr.h"
 #include "en/mapping.h"
@@ -1485,8 +1485,8 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	 * don't go though all prios of this chain as normal tc rules
 	 * miss.
 	 */
-	err = mlx5_esw_chains_get_chain_mapping(esw, attr->chain,
-						&chain_mapping);
+	err = mlx5_chains_get_chain_mapping(esw_chains(esw), attr->chain,
+					    &chain_mapping);
 	if (err) {
 		ct_dbg("Failed to get chain register mapping for chain");
 		goto err_get_chain;
@@ -1582,7 +1582,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 err_mapping:
 	dealloc_mod_hdr_actions(&pre_mod_acts);
-	mlx5_esw_chains_put_chain_mapping(esw, ct_flow->chain_mapping);
+	mlx5_chains_put_chain_mapping(esw_chains(esw), ct_flow->chain_mapping);
 err_get_chain:
 	idr_remove(&ct_priv->fte_ids, fte_id);
 err_idr:
@@ -1694,7 +1694,7 @@ __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 	if (ct_flow->post_ct_rule) {
 		mlx5_eswitch_del_offloaded_rule(esw, ct_flow->post_ct_rule,
 						&ct_flow->post_ct_attr);
-		mlx5_esw_chains_put_chain_mapping(esw, ct_flow->chain_mapping);
+		mlx5_chains_put_chain_mapping(esw_chains(esw), ct_flow->chain_mapping);
 		idr_remove(&ct_priv->fte_ids, ct_flow->fte_id);
 		mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
 	}
@@ -1817,14 +1817,14 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 
 	ct_priv->esw = esw;
 	ct_priv->netdev = rpriv->netdev;
-	ct_priv->ct = mlx5_esw_chains_create_global_table(esw);
+	ct_priv->ct = mlx5_chains_create_global_table(esw_chains(esw));
 	if (IS_ERR(ct_priv->ct)) {
 		err = PTR_ERR(ct_priv->ct);
 		mlx5_tc_ct_init_err(rpriv, "failed to create ct table", err);
 		goto err_ct_tbl;
 	}
 
-	ct_priv->ct_nat = mlx5_esw_chains_create_global_table(esw);
+	ct_priv->ct_nat = mlx5_chains_create_global_table(esw_chains(esw));
 	if (IS_ERR(ct_priv->ct_nat)) {
 		err = PTR_ERR(ct_priv->ct_nat);
 		mlx5_tc_ct_init_err(rpriv, "failed to create ct nat table",
@@ -1832,7 +1832,7 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 		goto err_ct_nat_tbl;
 	}
 
-	ct_priv->post_ct = mlx5_esw_chains_create_global_table(esw);
+	ct_priv->post_ct = mlx5_chains_create_global_table(esw_chains(esw));
 	if (IS_ERR(ct_priv->post_ct)) {
 		err = PTR_ERR(ct_priv->post_ct);
 		mlx5_tc_ct_init_err(rpriv, "failed to create post ct table",
@@ -1852,9 +1852,9 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 	return 0;
 
 err_post_ct_tbl:
-	mlx5_esw_chains_destroy_global_table(esw, ct_priv->ct_nat);
+	mlx5_chains_destroy_global_table(esw_chains(esw), ct_priv->ct_nat);
 err_ct_nat_tbl:
-	mlx5_esw_chains_destroy_global_table(esw, ct_priv->ct);
+	mlx5_chains_destroy_global_table(esw_chains(esw), ct_priv->ct);
 err_ct_tbl:
 	mapping_destroy(ct_priv->labels_mapping);
 err_mapping_labels:
@@ -1871,13 +1871,18 @@ void
 mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 {
 	struct mlx5_tc_ct_priv *ct_priv = uplink_priv->ct_priv;
+	struct mlx5_fs_chains *chains;
+	struct mlx5_eswitch *esw;
 
 	if (!ct_priv)
 		return;
 
-	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->post_ct);
-	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct_nat);
-	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct);
+	esw = ct_priv->esw;
+	chains = esw_chains(esw);
+
+	mlx5_chains_destroy_global_table(chains, ct_priv->post_ct);
+	mlx5_chains_destroy_global_table(chains, ct_priv->ct_nat);
+	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
 	mapping_destroy(ct_priv->zone_mapping);
 	mapping_destroy(ct_priv->labels_mapping);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 97ba2da56cf9..9f5c97d22af4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -39,7 +39,6 @@
 #include <net/ipv6_stubs.h>
 
 #include "eswitch.h"
-#include "esw/chains.h"
 #include "en.h"
 #include "en_rep.h"
 #include "en/txrx.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 28053c3c4380..557769c16393 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -57,7 +57,6 @@
 #include "en/rep/neigh.h"
 #include "en_tc.h"
 #include "eswitch.h"
-#include "esw/chains.h"
 #include "fs_core.h"
 #include "en/port.h"
 #include "en/tc_tun.h"
@@ -66,6 +65,7 @@
 #include "en/mod_hdr.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
+#include "lib/fs_chains.h"
 #include "diag/en_tc_tracepoint.h"
 
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
@@ -1180,7 +1180,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	int err = 0;
 	int out_index;
 
-	if (!mlx5_esw_chains_prios_supported(esw) && attr->prio != 1) {
+	if (!mlx5_chains_prios_supported(esw_chains(esw)) && attr->prio != 1) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "E-switch priorities unsupported, upgrade FW");
 		return -EOPNOTSUPP;
@@ -1191,14 +1191,14 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	 * FDB_FT_CHAIN which is outside tc range.
 	 * See mlx5e_rep_setup_ft_cb().
 	 */
-	max_chain = mlx5_esw_chains_get_chain_range(esw);
+	max_chain = mlx5_chains_get_chain_range(esw_chains(esw));
 	if (!mlx5e_is_ft_flow(flow) && attr->chain > max_chain) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Requested chain is out of supported range");
 		return -EOPNOTSUPP;
 	}
 
-	max_prio = mlx5_esw_chains_get_prio_range(esw);
+	max_prio = mlx5_chains_get_prio_range(esw_chains(esw));
 	if (attr->prio > max_prio) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Requested priority is out of supported range");
@@ -3845,7 +3845,7 @@ static int mlx5_validate_goto_chain(struct mlx5_eswitch *esw,
 				    u32 actions,
 				    struct netlink_ext_ack *extack)
 {
-	u32 max_chain = mlx5_esw_chains_get_chain_range(esw);
+	u32 max_chain = mlx5_chains_get_chain_range(esw_chains(esw));
 	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	u32 dest_chain = act->chain_index;
@@ -3855,7 +3855,7 @@ static int mlx5_validate_goto_chain(struct mlx5_eswitch *esw,
 		return -EOPNOTSUPP;
 	}
 
-	if (!mlx5_esw_chains_backwards_supported(esw) &&
+	if (!mlx5_chains_backwards_supported(esw_chains(esw)) &&
 	    dest_chain <= attr->chain) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Goto lower numbered chain isn't supported");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
deleted file mode 100644
index d5bf908dfecd..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
+++ /dev/null
@@ -1,944 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
-// Copyright (c) 2020 Mellanox Technologies.
-
-#include <linux/mlx5/driver.h>
-#include <linux/mlx5/mlx5_ifc.h>
-#include <linux/mlx5/fs.h>
-
-#include "esw/chains.h"
-#include "en/mapping.h"
-#include "mlx5_core.h"
-#include "fs_core.h"
-#include "eswitch.h"
-#include "en.h"
-#include "en_tc.h"
-
-#define esw_chains_priv(esw) ((esw)->fdb_table.offloads.esw_chains_priv)
-#define esw_chains_lock(esw) (esw_chains_priv(esw)->lock)
-#define esw_chains_ht(esw) (esw_chains_priv(esw)->chains_ht)
-#define esw_chains_mapping(esw) (esw_chains_priv(esw)->chains_mapping)
-#define esw_prios_ht(esw) (esw_chains_priv(esw)->prios_ht)
-#define fdb_pool_left(esw) (esw_chains_priv(esw)->fdb_left)
-#define tc_slow_fdb(esw) ((esw)->fdb_table.offloads.slow_fdb)
-#define tc_end_fdb(esw) (esw_chains_priv(esw)->tc_end_fdb)
-#define fdb_ignore_flow_level_supported(esw) \
-	(MLX5_CAP_ESW_FLOWTABLE_FDB((esw)->dev, ignore_flow_level))
-#define fdb_modify_header_fwd_to_table_supported(esw) \
-	(MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_modify_header_fwd_to_table))
-
-/* Firmware currently has 4 pool of 4 sizes that it supports (ESW_POOLS),
- * and a virtual memory region of 16M (ESW_SIZE), this region is duplicated
- * for each flow table pool. We can allocate up to 16M of each pool,
- * and we keep track of how much we used via get_next_avail_sz_from_pool.
- * Firmware doesn't report any of this for now.
- * ESW_POOL is expected to be sorted from large to small and match firmware
- * pools.
- */
-#define ESW_SIZE (16 * 1024 * 1024)
-static const unsigned int ESW_POOLS[] = { 4 * 1024 * 1024,
-					  1 * 1024 * 1024,
-					  64 * 1024,
-					  128 };
-#define ESW_FT_TBL_SZ (64 * 1024)
-
-struct mlx5_esw_chains_priv {
-	struct rhashtable chains_ht;
-	struct rhashtable prios_ht;
-	/* Protects above chains_ht and prios_ht */
-	struct mutex lock;
-
-	struct mlx5_flow_table *tc_end_fdb;
-	struct mapping_ctx *chains_mapping;
-
-	int fdb_left[ARRAY_SIZE(ESW_POOLS)];
-};
-
-struct fdb_chain {
-	struct rhash_head node;
-
-	u32 chain;
-
-	int ref;
-	int id;
-
-	struct mlx5_eswitch *esw;
-	struct list_head prios_list;
-	struct mlx5_flow_handle *restore_rule;
-	struct mlx5_modify_hdr *miss_modify_hdr;
-};
-
-struct fdb_prio_key {
-	u32 chain;
-	u32 prio;
-	u32 level;
-};
-
-struct fdb_prio {
-	struct rhash_head node;
-	struct list_head list;
-
-	struct fdb_prio_key key;
-
-	int ref;
-
-	struct fdb_chain *fdb_chain;
-	struct mlx5_flow_table *fdb;
-	struct mlx5_flow_table *next_fdb;
-	struct mlx5_flow_group *miss_group;
-	struct mlx5_flow_handle *miss_rule;
-};
-
-static const struct rhashtable_params chain_params = {
-	.head_offset = offsetof(struct fdb_chain, node),
-	.key_offset = offsetof(struct fdb_chain, chain),
-	.key_len = sizeof_field(struct fdb_chain, chain),
-	.automatic_shrinking = true,
-};
-
-static const struct rhashtable_params prio_params = {
-	.head_offset = offsetof(struct fdb_prio, node),
-	.key_offset = offsetof(struct fdb_prio, key),
-	.key_len = sizeof_field(struct fdb_prio, key),
-	.automatic_shrinking = true,
-};
-
-bool mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw)
-{
-	return esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
-}
-
-bool mlx5_esw_chains_backwards_supported(struct mlx5_eswitch *esw)
-{
-	return mlx5_esw_chains_prios_supported(esw) &&
-	       fdb_ignore_flow_level_supported(esw);
-}
-
-u32 mlx5_esw_chains_get_chain_range(struct mlx5_eswitch *esw)
-{
-	if (!mlx5_esw_chains_prios_supported(esw))
-		return 1;
-
-	if (fdb_ignore_flow_level_supported(esw))
-		return UINT_MAX - 1;
-
-	return FDB_TC_MAX_CHAIN;
-}
-
-u32 mlx5_esw_chains_get_ft_chain(struct mlx5_eswitch *esw)
-{
-	return mlx5_esw_chains_get_chain_range(esw) + 1;
-}
-
-u32 mlx5_esw_chains_get_prio_range(struct mlx5_eswitch *esw)
-{
-	if (!mlx5_esw_chains_prios_supported(esw))
-		return 1;
-
-	if (fdb_ignore_flow_level_supported(esw))
-		return UINT_MAX;
-
-	return FDB_TC_MAX_PRIO;
-}
-
-static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
-{
-	if (fdb_ignore_flow_level_supported(esw))
-		return UINT_MAX;
-
-	return FDB_TC_LEVELS_PER_PRIO;
-}
-
-#define POOL_NEXT_SIZE 0
-static int
-mlx5_esw_chains_get_avail_sz_from_pool(struct mlx5_eswitch *esw,
-				       int desired_size)
-{
-	int i, found_i = -1;
-
-	for (i = ARRAY_SIZE(ESW_POOLS) - 1; i >= 0; i--) {
-		if (fdb_pool_left(esw)[i] && ESW_POOLS[i] > desired_size) {
-			found_i = i;
-			if (desired_size != POOL_NEXT_SIZE)
-				break;
-		}
-	}
-
-	if (found_i != -1) {
-		--fdb_pool_left(esw)[found_i];
-		return ESW_POOLS[found_i];
-	}
-
-	return 0;
-}
-
-static void
-mlx5_esw_chains_put_sz_to_pool(struct mlx5_eswitch *esw, int sz)
-{
-	int i;
-
-	for (i = ARRAY_SIZE(ESW_POOLS) - 1; i >= 0; i--) {
-		if (sz == ESW_POOLS[i]) {
-			++fdb_pool_left(esw)[i];
-			return;
-		}
-	}
-
-	WARN_ONCE(1, "Couldn't find size %d in fdb size pool", sz);
-}
-
-static void
-mlx5_esw_chains_init_sz_pool(struct mlx5_eswitch *esw)
-{
-	u32 fdb_max;
-	int i;
-
-	fdb_max = 1 << MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, log_max_ft_size);
-
-	for (i = ARRAY_SIZE(ESW_POOLS) - 1; i >= 0; i--)
-		fdb_pool_left(esw)[i] =
-			ESW_POOLS[i] <= fdb_max ? ESW_SIZE / ESW_POOLS[i] : 0;
-}
-
-static struct mlx5_flow_table *
-mlx5_esw_chains_create_fdb_table(struct mlx5_eswitch *esw,
-				 u32 chain, u32 prio, u32 level)
-{
-	struct mlx5_flow_table_attr ft_attr = {};
-	struct mlx5_flow_namespace *ns;
-	struct mlx5_flow_table *fdb;
-	int sz;
-
-	if (esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE)
-		ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
-				  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
-
-	sz = (chain == mlx5_esw_chains_get_ft_chain(esw)) ?
-	     mlx5_esw_chains_get_avail_sz_from_pool(esw, ESW_FT_TBL_SZ) :
-	     mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
-	if (!sz)
-		return ERR_PTR(-ENOSPC);
-	ft_attr.max_fte = sz;
-
-	/* We use tc_slow_fdb(esw) as the table's next_ft till
-	 * ignore_flow_level is allowed on FT creation and not just for FTEs.
-	 * Instead caller should add an explicit miss rule if needed.
-	 */
-	ft_attr.next_ft = tc_slow_fdb(esw);
-
-	/* The root table(chain 0, prio 1, level 0) is required to be
-	 * connected to the previous prio (FDB_BYPASS_PATH if exists).
-	 * We always create it, as a managed table, in order to align with
-	 * fs_core logic.
-	 */
-	if (!fdb_ignore_flow_level_supported(esw) ||
-	    (chain == 0 && prio == 1 && level == 0)) {
-		ft_attr.level = level;
-		ft_attr.prio = prio - 1;
-		ns = mlx5_get_fdb_sub_ns(esw->dev, chain);
-	} else {
-		ft_attr.flags |= MLX5_FLOW_TABLE_UNMANAGED;
-		ft_attr.prio = FDB_TC_OFFLOAD;
-		/* Firmware doesn't allow us to create another level 0 table,
-		 * so we create all unmanaged tables as level 1.
-		 *
-		 * To connect them, we use explicit miss rules with
-		 * ignore_flow_level. Caller is responsible to create
-		 * these rules (if needed).
-		 */
-		ft_attr.level = 1;
-		ns = mlx5_get_flow_namespace(esw->dev, MLX5_FLOW_NAMESPACE_FDB);
-	}
-
-	ft_attr.autogroup.num_reserved_entries = 2;
-	ft_attr.autogroup.max_num_groups = esw->params.large_group_num;
-	fdb = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
-	if (IS_ERR(fdb)) {
-		esw_warn(esw->dev,
-			 "Failed to create FDB table err %d (chain: %d, prio: %d, level: %d, size: %d)\n",
-			 (int)PTR_ERR(fdb), chain, prio, level, sz);
-		mlx5_esw_chains_put_sz_to_pool(esw, sz);
-		return fdb;
-	}
-
-	return fdb;
-}
-
-static void
-mlx5_esw_chains_destroy_fdb_table(struct mlx5_eswitch *esw,
-				  struct mlx5_flow_table *fdb)
-{
-	mlx5_esw_chains_put_sz_to_pool(esw, fdb->max_fte);
-	mlx5_destroy_flow_table(fdb);
-}
-
-static int
-create_fdb_chain_restore(struct fdb_chain *fdb_chain)
-{
-	char modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)];
-	struct mlx5_eswitch *esw = fdb_chain->esw;
-	struct mlx5_modify_hdr *mod_hdr;
-	u32 index;
-	int err;
-
-	if (fdb_chain->chain == mlx5_esw_chains_get_ft_chain(esw) ||
-	    !mlx5_esw_chains_prios_supported(esw))
-		return 0;
-
-	err = mapping_add(esw_chains_mapping(esw), &fdb_chain->chain, &index);
-	if (err)
-		return err;
-	if (index == MLX5_FS_DEFAULT_FLOW_TAG) {
-		/* we got the special default flow tag id, so we won't know
-		 * if we actually marked the packet with the restore rule
-		 * we create.
-		 *
-		 * This case isn't possible with MLX5_FS_DEFAULT_FLOW_TAG = 0.
-		 */
-		err = mapping_add(esw_chains_mapping(esw),
-				  &fdb_chain->chain, &index);
-		mapping_remove(esw_chains_mapping(esw),
-			       MLX5_FS_DEFAULT_FLOW_TAG);
-		if (err)
-			return err;
-	}
-
-	fdb_chain->id = index;
-
-	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
-	MLX5_SET(set_action_in, modact, field,
-		 mlx5e_tc_attr_to_reg_mappings[CHAIN_TO_REG].mfield);
-	MLX5_SET(set_action_in, modact, offset,
-		 mlx5e_tc_attr_to_reg_mappings[CHAIN_TO_REG].moffset * 8);
-	MLX5_SET(set_action_in, modact, length,
-		 mlx5e_tc_attr_to_reg_mappings[CHAIN_TO_REG].mlen * 8);
-	MLX5_SET(set_action_in, modact, data, fdb_chain->id);
-	mod_hdr = mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_FDB,
-					   1, modact);
-	if (IS_ERR(mod_hdr)) {
-		err = PTR_ERR(mod_hdr);
-		goto err_mod_hdr;
-	}
-	fdb_chain->miss_modify_hdr = mod_hdr;
-
-	fdb_chain->restore_rule = esw_add_restore_rule(esw, fdb_chain->id);
-	if (IS_ERR(fdb_chain->restore_rule)) {
-		err = PTR_ERR(fdb_chain->restore_rule);
-		goto err_rule;
-	}
-
-	return 0;
-
-err_rule:
-	mlx5_modify_header_dealloc(esw->dev, fdb_chain->miss_modify_hdr);
-err_mod_hdr:
-	/* Datapath can't find this mapping, so we can safely remove it */
-	mapping_remove(esw_chains_mapping(esw), fdb_chain->id);
-	return err;
-}
-
-static void destroy_fdb_chain_restore(struct fdb_chain *fdb_chain)
-{
-	struct mlx5_eswitch *esw = fdb_chain->esw;
-
-	if (!fdb_chain->miss_modify_hdr)
-		return;
-
-	mlx5_del_flow_rules(fdb_chain->restore_rule);
-	mlx5_modify_header_dealloc(esw->dev, fdb_chain->miss_modify_hdr);
-	mapping_remove(esw_chains_mapping(esw), fdb_chain->id);
-}
-
-static struct fdb_chain *
-mlx5_esw_chains_create_fdb_chain(struct mlx5_eswitch *esw, u32 chain)
-{
-	struct fdb_chain *fdb_chain = NULL;
-	int err;
-
-	fdb_chain = kvzalloc(sizeof(*fdb_chain), GFP_KERNEL);
-	if (!fdb_chain)
-		return ERR_PTR(-ENOMEM);
-
-	fdb_chain->esw = esw;
-	fdb_chain->chain = chain;
-	INIT_LIST_HEAD(&fdb_chain->prios_list);
-
-	err = create_fdb_chain_restore(fdb_chain);
-	if (err)
-		goto err_restore;
-
-	err = rhashtable_insert_fast(&esw_chains_ht(esw), &fdb_chain->node,
-				     chain_params);
-	if (err)
-		goto err_insert;
-
-	return fdb_chain;
-
-err_insert:
-	destroy_fdb_chain_restore(fdb_chain);
-err_restore:
-	kvfree(fdb_chain);
-	return ERR_PTR(err);
-}
-
-static void
-mlx5_esw_chains_destroy_fdb_chain(struct fdb_chain *fdb_chain)
-{
-	struct mlx5_eswitch *esw = fdb_chain->esw;
-
-	rhashtable_remove_fast(&esw_chains_ht(esw), &fdb_chain->node,
-			       chain_params);
-
-	destroy_fdb_chain_restore(fdb_chain);
-	kvfree(fdb_chain);
-}
-
-static struct fdb_chain *
-mlx5_esw_chains_get_fdb_chain(struct mlx5_eswitch *esw, u32 chain)
-{
-	struct fdb_chain *fdb_chain;
-
-	fdb_chain = rhashtable_lookup_fast(&esw_chains_ht(esw), &chain,
-					   chain_params);
-	if (!fdb_chain) {
-		fdb_chain = mlx5_esw_chains_create_fdb_chain(esw, chain);
-		if (IS_ERR(fdb_chain))
-			return fdb_chain;
-	}
-
-	fdb_chain->ref++;
-
-	return fdb_chain;
-}
-
-static struct mlx5_flow_handle *
-mlx5_esw_chains_add_miss_rule(struct fdb_chain *fdb_chain,
-			      struct mlx5_flow_table *fdb,
-			      struct mlx5_flow_table *next_fdb)
-{
-	struct mlx5_eswitch *esw = fdb_chain->esw;
-	struct mlx5_flow_destination dest = {};
-	struct mlx5_flow_act act = {};
-
-	act.flags  = FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
-	act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	dest.type  = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = next_fdb;
-
-	if (next_fdb == tc_end_fdb(esw) &&
-	    mlx5_esw_chains_prios_supported(esw)) {
-		act.modify_hdr = fdb_chain->miss_modify_hdr;
-		act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-	}
-
-	return mlx5_add_flow_rules(fdb, NULL, &act, &dest, 1);
-}
-
-static int
-mlx5_esw_chains_update_prio_prevs(struct fdb_prio *fdb_prio,
-				  struct mlx5_flow_table *next_fdb)
-{
-	struct mlx5_flow_handle *miss_rules[FDB_TC_LEVELS_PER_PRIO + 1] = {};
-	struct fdb_chain *fdb_chain = fdb_prio->fdb_chain;
-	struct fdb_prio *pos;
-	int n = 0, err;
-
-	if (fdb_prio->key.level)
-		return 0;
-
-	/* Iterate in reverse order until reaching the level 0 rule of
-	 * the previous priority, adding all the miss rules first, so we can
-	 * revert them if any of them fails.
-	 */
-	pos = fdb_prio;
-	list_for_each_entry_continue_reverse(pos,
-					     &fdb_chain->prios_list,
-					     list) {
-		miss_rules[n] = mlx5_esw_chains_add_miss_rule(fdb_chain,
-							      pos->fdb,
-							      next_fdb);
-		if (IS_ERR(miss_rules[n])) {
-			err = PTR_ERR(miss_rules[n]);
-			goto err_prev_rule;
-		}
-
-		n++;
-		if (!pos->key.level)
-			break;
-	}
-
-	/* Success, delete old miss rules, and update the pointers. */
-	n = 0;
-	pos = fdb_prio;
-	list_for_each_entry_continue_reverse(pos,
-					     &fdb_chain->prios_list,
-					     list) {
-		mlx5_del_flow_rules(pos->miss_rule);
-
-		pos->miss_rule = miss_rules[n];
-		pos->next_fdb = next_fdb;
-
-		n++;
-		if (!pos->key.level)
-			break;
-	}
-
-	return 0;
-
-err_prev_rule:
-	while (--n >= 0)
-		mlx5_del_flow_rules(miss_rules[n]);
-
-	return err;
-}
-
-static void
-mlx5_esw_chains_put_fdb_chain(struct fdb_chain *fdb_chain)
-{
-	if (--fdb_chain->ref == 0)
-		mlx5_esw_chains_destroy_fdb_chain(fdb_chain);
-}
-
-static struct fdb_prio *
-mlx5_esw_chains_create_fdb_prio(struct mlx5_eswitch *esw,
-				u32 chain, u32 prio, u32 level)
-{
-	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_flow_handle *miss_rule = NULL;
-	struct mlx5_flow_group *miss_group;
-	struct fdb_prio *fdb_prio = NULL;
-	struct mlx5_flow_table *next_fdb;
-	struct fdb_chain *fdb_chain;
-	struct mlx5_flow_table *fdb;
-	struct list_head *pos;
-	u32 *flow_group_in;
-	int err;
-
-	fdb_chain = mlx5_esw_chains_get_fdb_chain(esw, chain);
-	if (IS_ERR(fdb_chain))
-		return ERR_CAST(fdb_chain);
-
-	fdb_prio = kvzalloc(sizeof(*fdb_prio), GFP_KERNEL);
-	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!fdb_prio || !flow_group_in) {
-		err = -ENOMEM;
-		goto err_alloc;
-	}
-
-	/* Chain's prio list is sorted by prio and level.
-	 * And all levels of some prio point to the next prio's level 0.
-	 * Example list (prio, level):
-	 * (3,0)->(3,1)->(5,0)->(5,1)->(6,1)->(7,0)
-	 * In hardware, we will we have the following pointers:
-	 * (3,0) -> (5,0) -> (7,0) -> Slow path
-	 * (3,1) -> (5,0)
-	 * (5,1) -> (7,0)
-	 * (6,1) -> (7,0)
-	 */
-
-	/* Default miss for each chain: */
-	next_fdb = (chain == mlx5_esw_chains_get_ft_chain(esw)) ?
-		    tc_slow_fdb(esw) :
-		    tc_end_fdb(esw);
-	list_for_each(pos, &fdb_chain->prios_list) {
-		struct fdb_prio *p = list_entry(pos, struct fdb_prio, list);
-
-		/* exit on first pos that is larger */
-		if (prio < p->key.prio || (prio == p->key.prio &&
-					   level < p->key.level)) {
-			/* Get next level 0 table */
-			next_fdb = p->key.level == 0 ? p->fdb : p->next_fdb;
-			break;
-		}
-	}
-
-	fdb = mlx5_esw_chains_create_fdb_table(esw, chain, prio, level);
-	if (IS_ERR(fdb)) {
-		err = PTR_ERR(fdb);
-		goto err_create;
-	}
-
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index,
-		 fdb->max_fte - 2);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
-		 fdb->max_fte - 1);
-	miss_group = mlx5_create_flow_group(fdb, flow_group_in);
-	if (IS_ERR(miss_group)) {
-		err = PTR_ERR(miss_group);
-		goto err_group;
-	}
-
-	/* Add miss rule to next_fdb */
-	miss_rule = mlx5_esw_chains_add_miss_rule(fdb_chain, fdb, next_fdb);
-	if (IS_ERR(miss_rule)) {
-		err = PTR_ERR(miss_rule);
-		goto err_miss_rule;
-	}
-
-	fdb_prio->miss_group = miss_group;
-	fdb_prio->miss_rule = miss_rule;
-	fdb_prio->next_fdb = next_fdb;
-	fdb_prio->fdb_chain = fdb_chain;
-	fdb_prio->key.chain = chain;
-	fdb_prio->key.prio = prio;
-	fdb_prio->key.level = level;
-	fdb_prio->fdb = fdb;
-
-	err = rhashtable_insert_fast(&esw_prios_ht(esw), &fdb_prio->node,
-				     prio_params);
-	if (err)
-		goto err_insert;
-
-	list_add(&fdb_prio->list, pos->prev);
-
-	/* Table is ready, connect it */
-	err = mlx5_esw_chains_update_prio_prevs(fdb_prio, fdb);
-	if (err)
-		goto err_update;
-
-	kvfree(flow_group_in);
-	return fdb_prio;
-
-err_update:
-	list_del(&fdb_prio->list);
-	rhashtable_remove_fast(&esw_prios_ht(esw), &fdb_prio->node,
-			       prio_params);
-err_insert:
-	mlx5_del_flow_rules(miss_rule);
-err_miss_rule:
-	mlx5_destroy_flow_group(miss_group);
-err_group:
-	mlx5_esw_chains_destroy_fdb_table(esw, fdb);
-err_create:
-err_alloc:
-	kvfree(fdb_prio);
-	kvfree(flow_group_in);
-	mlx5_esw_chains_put_fdb_chain(fdb_chain);
-	return ERR_PTR(err);
-}
-
-static void
-mlx5_esw_chains_destroy_fdb_prio(struct mlx5_eswitch *esw,
-				 struct fdb_prio *fdb_prio)
-{
-	struct fdb_chain *fdb_chain = fdb_prio->fdb_chain;
-
-	WARN_ON(mlx5_esw_chains_update_prio_prevs(fdb_prio,
-						  fdb_prio->next_fdb));
-
-	list_del(&fdb_prio->list);
-	rhashtable_remove_fast(&esw_prios_ht(esw), &fdb_prio->node,
-			       prio_params);
-	mlx5_del_flow_rules(fdb_prio->miss_rule);
-	mlx5_destroy_flow_group(fdb_prio->miss_group);
-	mlx5_esw_chains_destroy_fdb_table(esw, fdb_prio->fdb);
-	mlx5_esw_chains_put_fdb_chain(fdb_chain);
-	kvfree(fdb_prio);
-}
-
-struct mlx5_flow_table *
-mlx5_esw_chains_get_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
-			  u32 level)
-{
-	struct mlx5_flow_table *prev_fts;
-	struct fdb_prio *fdb_prio;
-	struct fdb_prio_key key;
-	int l = 0;
-
-	if ((chain > mlx5_esw_chains_get_chain_range(esw) &&
-	     chain != mlx5_esw_chains_get_ft_chain(esw)) ||
-	    prio > mlx5_esw_chains_get_prio_range(esw) ||
-	    level > mlx5_esw_chains_get_level_range(esw))
-		return ERR_PTR(-EOPNOTSUPP);
-
-	/* create earlier levels for correct fs_core lookup when
-	 * connecting tables.
-	 */
-	for (l = 0; l < level; l++) {
-		prev_fts = mlx5_esw_chains_get_table(esw, chain, prio, l);
-		if (IS_ERR(prev_fts)) {
-			fdb_prio = ERR_CAST(prev_fts);
-			goto err_get_prevs;
-		}
-	}
-
-	key.chain = chain;
-	key.prio = prio;
-	key.level = level;
-
-	mutex_lock(&esw_chains_lock(esw));
-	fdb_prio = rhashtable_lookup_fast(&esw_prios_ht(esw), &key,
-					  prio_params);
-	if (!fdb_prio) {
-		fdb_prio = mlx5_esw_chains_create_fdb_prio(esw, chain,
-							   prio, level);
-		if (IS_ERR(fdb_prio))
-			goto err_create_prio;
-	}
-
-	++fdb_prio->ref;
-	mutex_unlock(&esw_chains_lock(esw));
-
-	return fdb_prio->fdb;
-
-err_create_prio:
-	mutex_unlock(&esw_chains_lock(esw));
-err_get_prevs:
-	while (--l >= 0)
-		mlx5_esw_chains_put_table(esw, chain, prio, l);
-	return ERR_CAST(fdb_prio);
-}
-
-void
-mlx5_esw_chains_put_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
-			  u32 level)
-{
-	struct fdb_prio *fdb_prio;
-	struct fdb_prio_key key;
-
-	key.chain = chain;
-	key.prio = prio;
-	key.level = level;
-
-	mutex_lock(&esw_chains_lock(esw));
-	fdb_prio = rhashtable_lookup_fast(&esw_prios_ht(esw), &key,
-					  prio_params);
-	if (!fdb_prio)
-		goto err_get_prio;
-
-	if (--fdb_prio->ref == 0)
-		mlx5_esw_chains_destroy_fdb_prio(esw, fdb_prio);
-	mutex_unlock(&esw_chains_lock(esw));
-
-	while (level-- > 0)
-		mlx5_esw_chains_put_table(esw, chain, prio, level);
-
-	return;
-
-err_get_prio:
-	mutex_unlock(&esw_chains_lock(esw));
-	WARN_ONCE(1,
-		  "Couldn't find table: (chain: %d prio: %d level: %d)",
-		  chain, prio, level);
-}
-
-struct mlx5_flow_table *
-mlx5_esw_chains_get_tc_end_ft(struct mlx5_eswitch *esw)
-{
-	return tc_end_fdb(esw);
-}
-
-struct mlx5_flow_table *
-mlx5_esw_chains_create_global_table(struct mlx5_eswitch *esw)
-{
-	u32 chain, prio, level;
-	int err;
-
-	if (!fdb_ignore_flow_level_supported(esw)) {
-		err = -EOPNOTSUPP;
-
-		esw_warn(esw->dev,
-			 "Couldn't create global flow table, ignore_flow_level not supported.");
-		goto err_ignore;
-	}
-
-	chain = mlx5_esw_chains_get_chain_range(esw),
-	prio = mlx5_esw_chains_get_prio_range(esw);
-	level = mlx5_esw_chains_get_level_range(esw);
-
-	return mlx5_esw_chains_create_fdb_table(esw, chain, prio, level);
-
-err_ignore:
-	return ERR_PTR(err);
-}
-
-void
-mlx5_esw_chains_destroy_global_table(struct mlx5_eswitch *esw,
-				     struct mlx5_flow_table *ft)
-{
-	mlx5_esw_chains_destroy_fdb_table(esw, ft);
-}
-
-static int
-mlx5_esw_chains_init(struct mlx5_eswitch *esw)
-{
-	struct mlx5_esw_chains_priv *chains_priv;
-	struct mlx5_core_dev *dev = esw->dev;
-	u32 max_flow_counter, fdb_max;
-	struct mapping_ctx *mapping;
-	int err;
-
-	chains_priv = kzalloc(sizeof(*chains_priv), GFP_KERNEL);
-	if (!chains_priv)
-		return -ENOMEM;
-	esw_chains_priv(esw) = chains_priv;
-
-	max_flow_counter = (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
-			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
-	fdb_max = 1 << MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size);
-
-	esw_debug(dev,
-		  "Init esw offloads chains, max counters(%d), groups(%d), max flow table size(%d)\n",
-		  max_flow_counter, esw->params.large_group_num, fdb_max);
-
-	mlx5_esw_chains_init_sz_pool(esw);
-
-	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev, multi_fdb_encap) &&
-	    esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE) {
-		esw->fdb_table.flags &= ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
-		esw_warn(dev, "Tc chains and priorities offload aren't supported, update firmware if needed\n");
-	} else if (!mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
-		esw->fdb_table.flags &= ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
-		esw_warn(dev, "Tc chains and priorities offload aren't supported\n");
-	} else if (!fdb_modify_header_fwd_to_table_supported(esw)) {
-		/* Disabled when ttl workaround is needed, e.g
-		 * when ESWITCH_IPV4_TTL_MODIFY_ENABLE = true in mlxconfig
-		 */
-		esw_warn(dev,
-			 "Tc chains and priorities offload aren't supported, check firmware version, or mlxconfig settings\n");
-		esw->fdb_table.flags &= ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
-	} else {
-		esw->fdb_table.flags |= ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
-		esw_info(dev, "Supported tc offload range - chains: %u, prios: %u\n",
-			 mlx5_esw_chains_get_chain_range(esw),
-			 mlx5_esw_chains_get_prio_range(esw));
-	}
-
-	err = rhashtable_init(&esw_chains_ht(esw), &chain_params);
-	if (err)
-		goto init_chains_ht_err;
-
-	err = rhashtable_init(&esw_prios_ht(esw), &prio_params);
-	if (err)
-		goto init_prios_ht_err;
-
-	mapping = mapping_create(sizeof(u32), esw_get_max_restore_tag(esw),
-				 true);
-	if (IS_ERR(mapping)) {
-		err = PTR_ERR(mapping);
-		goto mapping_err;
-	}
-	esw_chains_mapping(esw) = mapping;
-
-	mutex_init(&esw_chains_lock(esw));
-
-	return 0;
-
-mapping_err:
-	rhashtable_destroy(&esw_prios_ht(esw));
-init_prios_ht_err:
-	rhashtable_destroy(&esw_chains_ht(esw));
-init_chains_ht_err:
-	kfree(chains_priv);
-	return err;
-}
-
-static void
-mlx5_esw_chains_cleanup(struct mlx5_eswitch *esw)
-{
-	mutex_destroy(&esw_chains_lock(esw));
-	mapping_destroy(esw_chains_mapping(esw));
-	rhashtable_destroy(&esw_prios_ht(esw));
-	rhashtable_destroy(&esw_chains_ht(esw));
-
-	kfree(esw_chains_priv(esw));
-}
-
-static int
-mlx5_esw_chains_open(struct mlx5_eswitch *esw)
-{
-	struct mlx5_flow_table *ft;
-	int err;
-
-	/* Create tc_end_fdb(esw) which is the always created ft chain */
-	ft = mlx5_esw_chains_get_table(esw, mlx5_esw_chains_get_ft_chain(esw),
-				       1, 0);
-	if (IS_ERR(ft))
-		return PTR_ERR(ft);
-
-	tc_end_fdb(esw) = ft;
-
-	/* Always open the root for fast path */
-	ft = mlx5_esw_chains_get_table(esw, 0, 1, 0);
-	if (IS_ERR(ft)) {
-		err = PTR_ERR(ft);
-		goto level_0_err;
-	}
-
-	/* Open level 1 for split rules now if prios isn't supported  */
-	if (!mlx5_esw_chains_prios_supported(esw)) {
-		err = mlx5_esw_vport_tbl_get(esw);
-		if (err)
-			goto level_1_err;
-	}
-
-	return 0;
-
-level_1_err:
-	mlx5_esw_chains_put_table(esw, 0, 1, 0);
-level_0_err:
-	mlx5_esw_chains_put_table(esw, mlx5_esw_chains_get_ft_chain(esw), 1, 0);
-	return err;
-}
-
-static void
-mlx5_esw_chains_close(struct mlx5_eswitch *esw)
-{
-	if (!mlx5_esw_chains_prios_supported(esw))
-		mlx5_esw_vport_tbl_put(esw);
-	mlx5_esw_chains_put_table(esw, 0, 1, 0);
-	mlx5_esw_chains_put_table(esw, mlx5_esw_chains_get_ft_chain(esw), 1, 0);
-}
-
-int
-mlx5_esw_chains_create(struct mlx5_eswitch *esw)
-{
-	int err;
-
-	err = mlx5_esw_chains_init(esw);
-	if (err)
-		return err;
-
-	err = mlx5_esw_chains_open(esw);
-	if (err)
-		goto err_open;
-
-	return 0;
-
-err_open:
-	mlx5_esw_chains_cleanup(esw);
-	return err;
-}
-
-void
-mlx5_esw_chains_destroy(struct mlx5_eswitch *esw)
-{
-	mlx5_esw_chains_close(esw);
-	mlx5_esw_chains_cleanup(esw);
-}
-
-int
-mlx5_esw_chains_get_chain_mapping(struct mlx5_eswitch *esw, u32 chain,
-				  u32 *chain_mapping)
-{
-	return mapping_add(esw_chains_mapping(esw), &chain, chain_mapping);
-}
-
-int
-mlx5_esw_chains_put_chain_mapping(struct mlx5_eswitch *esw, u32 chain_mapping)
-{
-	return mapping_remove(esw_chains_mapping(esw), chain_mapping);
-}
-
-int mlx5_eswitch_get_chain_for_tag(struct mlx5_eswitch *esw, u32 tag,
-				   u32 *chain)
-{
-	int err;
-
-	err = mapping_find(esw_chains_mapping(esw), tag, chain);
-	if (err) {
-		esw_warn(esw->dev, "Can't find chain for tag: %d\n", tag);
-		return -ENOENT;
-	}
-
-	return 0;
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
deleted file mode 100644
index 7679ac359e31..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2020 Mellanox Technologies. */
-
-#ifndef __ML5_ESW_CHAINS_H__
-#define __ML5_ESW_CHAINS_H__
-
-#include "eswitch.h"
-
-#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-
-bool
-mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw);
-bool
-mlx5_esw_chains_backwards_supported(struct mlx5_eswitch *esw);
-u32
-mlx5_esw_chains_get_prio_range(struct mlx5_eswitch *esw);
-u32
-mlx5_esw_chains_get_chain_range(struct mlx5_eswitch *esw);
-u32
-mlx5_esw_chains_get_ft_chain(struct mlx5_eswitch *esw);
-
-struct mlx5_flow_table *
-mlx5_esw_chains_get_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
-			  u32 level);
-void
-mlx5_esw_chains_put_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
-			  u32 level);
-
-struct mlx5_flow_table *
-mlx5_esw_chains_get_tc_end_ft(struct mlx5_eswitch *esw);
-
-struct mlx5_flow_table *
-mlx5_esw_chains_create_global_table(struct mlx5_eswitch *esw);
-void
-mlx5_esw_chains_destroy_global_table(struct mlx5_eswitch *esw,
-				     struct mlx5_flow_table *ft);
-
-int
-mlx5_esw_chains_get_chain_mapping(struct mlx5_eswitch *esw, u32 chain,
-				  u32 *chain_mapping);
-int
-mlx5_esw_chains_put_chain_mapping(struct mlx5_eswitch *esw,
-				  u32 chain_mapping);
-
-int mlx5_esw_chains_create(struct mlx5_eswitch *esw);
-void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw);
-
-int
-mlx5_eswitch_get_chain_for_tag(struct mlx5_eswitch *esw, u32 tag, u32 *chain);
-
-#else /* CONFIG_MLX5_CLS_ACT */
-
-static inline struct mlx5_flow_table *
-mlx5_esw_chains_get_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
-			  u32 level) { return ERR_PTR(-EOPNOTSUPP); }
-static inline void
-mlx5_esw_chains_put_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
-			  u32 level) {}
-
-static inline struct mlx5_flow_table *
-mlx5_esw_chains_get_tc_end_ft(struct mlx5_eswitch *esw) { return ERR_PTR(-EOPNOTSUPP); }
-
-static inline int mlx5_esw_chains_create(struct mlx5_eswitch *esw) { return 0; }
-static inline void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw) {}
-
-#endif /* CONFIG_MLX5_CLS_ACT */
-
-#endif /* __ML5_ESW_CHAINS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 7455fbd21a0a..fc23d57e9e44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -42,6 +42,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include "lib/mpfs.h"
+#include "lib/fs_chains.h"
 #include "en/tc_ct.h"
 
 #ifdef CONFIG_MLX5_ESWITCH
@@ -62,6 +63,9 @@
 #define mlx5_esw_has_fwd_fdb(dev) \
 	MLX5_CAP_ESW_FLOWTABLE(dev, fdb_multi_path_to_table)
 
+#define esw_chains(esw) \
+	((esw)->fdb_table.offloads.esw_chains_priv)
+
 struct vport_ingress {
 	struct mlx5_flow_table *acl;
 	struct mlx5_flow_handle *allow_rule;
@@ -154,12 +158,6 @@ struct mlx5_vport {
 	enum mlx5_eswitch_vport_event enabled_events;
 };
 
-enum offloads_fdb_flags {
-	ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED = BIT(0),
-};
-
-struct mlx5_esw_chains_priv;
-
 struct mlx5_eswitch_fdb {
 	union {
 		struct legacy_fdb {
@@ -183,7 +181,7 @@ struct mlx5_eswitch_fdb {
 			struct mlx5_flow_handle *miss_rule_multi;
 			int vlan_push_pop_refcount;
 
-			struct mlx5_esw_chains_priv *esw_chains_priv;
+			struct mlx5_fs_chains *esw_chains_priv;
 			struct {
 				DECLARE_HASHTABLE(table, 8);
 				/* Protects vports.table */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 00bcf97cecbc..38eef5a8feb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -39,12 +39,12 @@
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "esw/acl/ofld.h"
-#include "esw/chains.h"
 #include "rdma.h"
 #include "en.h"
 #include "fs_core.h"
 #include "lib/devcom.h"
 #include "lib/eq.h"
+#include "lib/fs_chains.h"
 
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
@@ -294,6 +294,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 {
 	struct mlx5_flow_destination dest[MLX5_MAX_FLOW_FWD_VPORTS + 1] = {};
 	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND, };
+	struct mlx5_fs_chains *chains = esw_chains(esw);
 	bool split = !!(attr->split_count);
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_table *fdb;
@@ -329,12 +330,12 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
 			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 			dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-			dest[i].ft = mlx5_esw_chains_get_tc_end_ft(esw);
+			dest[i].ft = mlx5_chains_get_tc_end_ft(chains);
 			i++;
 		} else if (attr->dest_chain) {
 			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
-			ft = mlx5_esw_chains_get_table(esw, attr->dest_chain,
-						       1, 0);
+			ft = mlx5_chains_get_table(chains, attr->dest_chain,
+						   1, 0);
 			if (IS_ERR(ft)) {
 				rule = ERR_CAST(ft);
 				goto err_create_goto_table;
@@ -385,8 +386,8 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		fdb = esw_vport_tbl_get(esw, attr);
 	} else {
 		if (attr->chain || attr->prio)
-			fdb = mlx5_esw_chains_get_table(esw, attr->chain,
-							attr->prio, 0);
+			fdb = mlx5_chains_get_table(chains, attr->chain,
+						    attr->prio, 0);
 		else
 			fdb = attr->fdb;
 
@@ -416,10 +417,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (split)
 		esw_vport_tbl_put(esw, attr);
 	else if (attr->chain || attr->prio)
-		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
+		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 err_esw_get:
 	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) && attr->dest_chain)
-		mlx5_esw_chains_put_table(esw, attr->dest_chain, 1, 0);
+		mlx5_chains_put_table(chains, attr->dest_chain, 1, 0);
 err_create_goto_table:
 	return rule;
 }
@@ -431,12 +432,13 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 {
 	struct mlx5_flow_destination dest[MLX5_MAX_FLOW_FWD_VPORTS + 1] = {};
 	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND, };
+	struct mlx5_fs_chains *chains = esw_chains(esw);
 	struct mlx5_flow_table *fast_fdb;
 	struct mlx5_flow_table *fwd_fdb;
 	struct mlx5_flow_handle *rule;
 	int i;
 
-	fast_fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio, 0);
+	fast_fdb = mlx5_chains_get_table(chains, attr->chain, attr->prio, 0);
 	if (IS_ERR(fast_fdb)) {
 		rule = ERR_CAST(fast_fdb);
 		goto err_get_fast;
@@ -483,7 +485,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 add_err:
 	esw_vport_tbl_put(esw, attr);
 err_get_fwd:
-	mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
+	mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 err_get_fast:
 	return rule;
 }
@@ -494,6 +496,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 			struct mlx5_esw_flow_attr *attr,
 			bool fwd_rule)
 {
+	struct mlx5_fs_chains *chains = esw_chains(esw);
 	bool split = (attr->split_count > 0);
 	int i;
 
@@ -511,15 +514,14 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 
 	if (fwd_rule)  {
 		esw_vport_tbl_put(esw, attr);
-		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
+		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 	} else {
 		if (split)
 			esw_vport_tbl_put(esw, attr);
 		else if (attr->chain || attr->prio)
-			mlx5_esw_chains_put_table(esw, attr->chain, attr->prio,
-						  0);
+			mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 		if (attr->dest_chain)
-			mlx5_esw_chains_put_table(esw, attr->dest_chain, 1, 0);
+			mlx5_chains_put_table(chains, attr->dest_chain, 1, 0);
 	}
 }
 
@@ -1137,6 +1139,126 @@ static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
 	}
 }
 
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+#define fdb_modify_header_fwd_to_table_supported(esw) \
+	(MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_modify_header_fwd_to_table))
+static void esw_init_chains_offload_flags(struct mlx5_eswitch *esw, u32 *flags)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, ignore_flow_level))
+		*flags |= MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
+
+	if (!MLX5_CAP_ESW_FLOWTABLE(dev, multi_fdb_encap) &&
+	    esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE) {
+		*flags &= ~MLX5_CHAINS_AND_PRIOS_SUPPORTED;
+		esw_warn(dev, "Tc chains and priorities offload aren't supported, update firmware if needed\n");
+	} else if (!mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
+		*flags &= ~MLX5_CHAINS_AND_PRIOS_SUPPORTED;
+		esw_warn(dev, "Tc chains and priorities offload aren't supported\n");
+	} else if (!fdb_modify_header_fwd_to_table_supported(esw)) {
+		/* Disabled when ttl workaround is needed, e.g
+		 * when ESWITCH_IPV4_TTL_MODIFY_ENABLE = true in mlxconfig
+		 */
+		esw_warn(dev,
+			 "Tc chains and priorities offload aren't supported, check firmware version, or mlxconfig settings\n");
+		*flags &= ~MLX5_CHAINS_AND_PRIOS_SUPPORTED;
+	} else {
+		*flags |= MLX5_CHAINS_AND_PRIOS_SUPPORTED;
+		esw_info(dev, "Supported tc chains and prios offload\n");
+	}
+
+	if (esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE)
+		*flags |= MLX5_CHAINS_FT_TUNNEL_SUPPORTED;
+}
+
+static int
+esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_flow_table *nf_ft, *ft;
+	struct mlx5_chains_attr attr = {};
+	struct mlx5_fs_chains *chains;
+	u32 fdb_max;
+	int err;
+
+	fdb_max = 1 << MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size);
+
+	esw_init_chains_offload_flags(esw, &attr.flags);
+	attr.ns = MLX5_FLOW_NAMESPACE_FDB;
+	attr.max_ft_sz = fdb_max;
+	attr.max_grp_num = esw->params.large_group_num;
+	attr.default_ft = miss_fdb;
+	attr.max_restore_tag = esw_get_max_restore_tag(esw);
+
+	chains = mlx5_chains_create(dev, &attr);
+	if (IS_ERR(chains)) {
+		err = PTR_ERR(chains);
+		esw_warn(dev, "Failed to create fdb chains err(%d)\n", err);
+		return err;
+	}
+
+	esw->fdb_table.offloads.esw_chains_priv = chains;
+
+	/* Create tc_end_ft which is the always created ft chain */
+	nf_ft = mlx5_chains_get_table(chains, mlx5_chains_get_nf_ft_chain(chains),
+				      1, 0);
+	if (IS_ERR(nf_ft)) {
+		err = PTR_ERR(nf_ft);
+		goto nf_ft_err;
+	}
+
+	/* Always open the root for fast path */
+	ft = mlx5_chains_get_table(chains, 0, 1, 0);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto level_0_err;
+	}
+
+	/* Open level 1 for split fdb rules now if prios isn't supported  */
+	if (!mlx5_chains_prios_supported(chains)) {
+		err = mlx5_esw_vport_tbl_get(esw);
+		if (err)
+			goto level_1_err;
+	}
+
+	mlx5_chains_set_end_ft(chains, nf_ft);
+
+	return 0;
+
+level_1_err:
+	mlx5_chains_put_table(chains, 0, 1, 0);
+level_0_err:
+	mlx5_chains_put_table(chains, mlx5_chains_get_nf_ft_chain(chains), 1, 0);
+nf_ft_err:
+	mlx5_chains_destroy(chains);
+	esw->fdb_table.offloads.esw_chains_priv = NULL;
+
+	return err;
+}
+
+static void
+esw_chains_destroy(struct mlx5_eswitch *esw, struct mlx5_fs_chains *chains)
+{
+	if (!mlx5_chains_prios_supported(chains))
+		mlx5_esw_vport_tbl_put(esw);
+	mlx5_chains_put_table(chains, 0, 1, 0);
+	mlx5_chains_put_table(chains, mlx5_chains_get_nf_ft_chain(chains), 1, 0);
+	mlx5_chains_destroy(chains);
+}
+
+#else /* CONFIG_MLX5_CLS_ACT */
+
+static int
+esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
+{ return 0; }
+
+static void
+esw_chains_destroy(struct mlx5_eswitch *esw, struct mlx5_fs_chains *chains)
+{}
+
+#endif
+
 static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
@@ -1192,9 +1314,9 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	}
 	esw->fdb_table.offloads.slow_fdb = fdb;
 
-	err = mlx5_esw_chains_create(esw);
+	err = esw_chains_create(esw, fdb);
 	if (err) {
-		esw_warn(dev, "Failed to create fdb chains err(%d)\n", err);
+		esw_warn(dev, "Failed to open fdb chains err(%d)\n", err);
 		goto fdb_chains_err;
 	}
 
@@ -1288,7 +1410,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 peer_miss_err:
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
 send_vport_err:
-	mlx5_esw_chains_destroy(esw);
+	esw_chains_destroy(esw, esw_chains(esw));
 fdb_chains_err:
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
 slow_fdb_err:
@@ -1312,7 +1434,8 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
 
-	mlx5_esw_chains_destroy(esw);
+	esw_chains_destroy(esw, esw_chains(esw));
+
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
 	/* Holds true only as long as DMFS is the default */
 	mlx5_flow_namespace_set_mode(esw->fdb_table.offloads.ns,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
new file mode 100644
index 000000000000..5bd65cdc9b07
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -0,0 +1,902 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies.
+
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/mlx5_ifc.h>
+#include <linux/mlx5/fs.h>
+
+#include "lib/fs_chains.h"
+#include "en/mapping.h"
+#include "mlx5_core.h"
+#include "fs_core.h"
+#include "eswitch.h"
+#include "en.h"
+#include "en_tc.h"
+
+#define chains_lock(chains) ((chains)->lock)
+#define chains_ht(chains) ((chains)->chains_ht)
+#define chains_mapping(chains) ((chains)->chains_mapping)
+#define prios_ht(chains) ((chains)->prios_ht)
+#define ft_pool_left(chains) ((chains)->ft_left)
+#define tc_default_ft(chains) ((chains)->tc_default_ft)
+#define tc_end_ft(chains) ((chains)->tc_end_ft)
+#define ns_to_chains_fs_prio(ns) ((ns) == MLX5_FLOW_NAMESPACE_FDB ? \
+				  FDB_TC_OFFLOAD : MLX5E_TC_PRIO)
+
+/* Firmware currently has 4 pool of 4 sizes that it supports (FT_POOLS),
+ * and a virtual memory region of 16M (MLX5_FT_SIZE), this region is duplicated
+ * for each flow table pool. We can allocate up to 16M of each pool,
+ * and we keep track of how much we used via get_next_avail_sz_from_pool.
+ * Firmware doesn't report any of this for now.
+ * ESW_POOL is expected to be sorted from large to small and match firmware
+ * pools.
+ */
+#define FT_SIZE (16 * 1024 * 1024)
+static const unsigned int FT_POOLS[] = { 4 * 1024 * 1024,
+					  1 * 1024 * 1024,
+					  64 * 1024,
+					  128 };
+#define FT_TBL_SZ (64 * 1024)
+
+struct mlx5_fs_chains {
+	struct mlx5_core_dev *dev;
+
+	struct rhashtable chains_ht;
+	struct rhashtable prios_ht;
+	/* Protects above chains_ht and prios_ht */
+	struct mutex lock;
+
+	struct mlx5_flow_table *tc_default_ft;
+	struct mlx5_flow_table *tc_end_ft;
+	struct mapping_ctx *chains_mapping;
+
+	enum mlx5_flow_namespace_type ns;
+	u32 group_num;
+	u32 flags;
+
+	int ft_left[ARRAY_SIZE(FT_POOLS)];
+};
+
+struct fs_chain {
+	struct rhash_head node;
+
+	u32 chain;
+
+	int ref;
+	int id;
+
+	struct mlx5_fs_chains *chains;
+	struct list_head prios_list;
+	struct mlx5_flow_handle *restore_rule;
+	struct mlx5_modify_hdr *miss_modify_hdr;
+};
+
+struct prio_key {
+	u32 chain;
+	u32 prio;
+	u32 level;
+};
+
+struct prio {
+	struct rhash_head node;
+	struct list_head list;
+
+	struct prio_key key;
+
+	int ref;
+
+	struct fs_chain *chain;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_table *next_ft;
+	struct mlx5_flow_group *miss_group;
+	struct mlx5_flow_handle *miss_rule;
+};
+
+static const struct rhashtable_params chain_params = {
+	.head_offset = offsetof(struct fs_chain, node),
+	.key_offset = offsetof(struct fs_chain, chain),
+	.key_len = sizeof_field(struct fs_chain, chain),
+	.automatic_shrinking = true,
+};
+
+static const struct rhashtable_params prio_params = {
+	.head_offset = offsetof(struct prio, node),
+	.key_offset = offsetof(struct prio, key),
+	.key_len = sizeof_field(struct prio, key),
+	.automatic_shrinking = true,
+};
+
+bool mlx5_chains_prios_supported(struct mlx5_fs_chains *chains)
+{
+	return chains->flags & MLX5_CHAINS_AND_PRIOS_SUPPORTED;
+}
+
+static bool mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains)
+{
+	return chains->flags & MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
+}
+
+bool mlx5_chains_backwards_supported(struct mlx5_fs_chains *chains)
+{
+	return mlx5_chains_prios_supported(chains) &&
+	       mlx5_chains_ignore_flow_level_supported(chains);
+}
+
+u32 mlx5_chains_get_chain_range(struct mlx5_fs_chains *chains)
+{
+	if (!mlx5_chains_prios_supported(chains))
+		return 1;
+
+	if (mlx5_chains_ignore_flow_level_supported(chains))
+		return UINT_MAX - 1;
+
+	/* We should get here only for eswitch case */
+	return FDB_TC_MAX_CHAIN;
+}
+
+u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
+{
+	return mlx5_chains_get_chain_range(chains) + 1;
+}
+
+u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
+{
+	if (!mlx5_chains_prios_supported(chains))
+		return 1;
+
+	if (mlx5_chains_ignore_flow_level_supported(chains))
+		return UINT_MAX;
+
+	/* We should get here only for eswitch case */
+	return FDB_TC_MAX_PRIO;
+}
+
+static unsigned int mlx5_chains_get_level_range(struct mlx5_fs_chains *chains)
+{
+	if (mlx5_chains_ignore_flow_level_supported(chains))
+		return UINT_MAX;
+
+	/* Same value for FDB and NIC RX tables */
+	return FDB_TC_LEVELS_PER_PRIO;
+}
+
+void
+mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
+		       struct mlx5_flow_table *ft)
+{
+	tc_end_ft(chains) = ft;
+}
+
+#define POOL_NEXT_SIZE 0
+static int
+mlx5_chains_get_avail_sz_from_pool(struct mlx5_fs_chains *chains,
+				   int desired_size)
+{
+	int i, found_i = -1;
+
+	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--) {
+		if (ft_pool_left(chains)[i] && FT_POOLS[i] > desired_size) {
+			found_i = i;
+			if (desired_size != POOL_NEXT_SIZE)
+				break;
+		}
+	}
+
+	if (found_i != -1) {
+		--ft_pool_left(chains)[found_i];
+		return FT_POOLS[found_i];
+	}
+
+	return 0;
+}
+
+static void
+mlx5_chains_put_sz_to_pool(struct mlx5_fs_chains *chains, int sz)
+{
+	int i;
+
+	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--) {
+		if (sz == FT_POOLS[i]) {
+			++ft_pool_left(chains)[i];
+			return;
+		}
+	}
+
+	WARN_ONCE(1, "Couldn't find size %d in flow table size pool", sz);
+}
+
+static void
+mlx5_chains_init_sz_pool(struct mlx5_fs_chains *chains, u32 ft_max)
+{
+	int i;
+
+	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--)
+		ft_pool_left(chains)[i] =
+			FT_POOLS[i] <= ft_max ? FT_SIZE / FT_POOLS[i] : 0;
+}
+
+static struct mlx5_flow_table *
+mlx5_chains_create_table(struct mlx5_fs_chains *chains,
+			 u32 chain, u32 prio, u32 level)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_flow_table *ft;
+	int sz;
+
+	if (chains->flags & MLX5_CHAINS_FT_TUNNEL_SUPPORTED)
+		ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
+				  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
+
+	sz = (chain == mlx5_chains_get_nf_ft_chain(chains)) ?
+	     mlx5_chains_get_avail_sz_from_pool(chains, FT_TBL_SZ) :
+	     mlx5_chains_get_avail_sz_from_pool(chains, POOL_NEXT_SIZE);
+	if (!sz)
+		return ERR_PTR(-ENOSPC);
+	ft_attr.max_fte = sz;
+
+	/* We use tc_default_ft(chains) as the table's next_ft till
+	 * ignore_flow_level is allowed on FT creation and not just for FTEs.
+	 * Instead caller should add an explicit miss rule if needed.
+	 */
+	ft_attr.next_ft = tc_default_ft(chains);
+
+	/* The root table(chain 0, prio 1, level 0) is required to be
+	 * connected to the previous fs_core managed prio.
+	 * We always create it, as a managed table, in order to align with
+	 * fs_core logic.
+	 */
+	if (!mlx5_chains_ignore_flow_level_supported(chains) ||
+	    (chain == 0 && prio == 1 && level == 0)) {
+		ft_attr.level = level;
+		ft_attr.prio = prio - 1;
+		ns = (chains->ns == MLX5_FLOW_NAMESPACE_FDB) ?
+			mlx5_get_fdb_sub_ns(chains->dev, chain) :
+			mlx5_get_flow_namespace(chains->dev, chains->ns);
+	} else {
+		ft_attr.flags |= MLX5_FLOW_TABLE_UNMANAGED;
+		ft_attr.prio = ns_to_chains_fs_prio(chains->ns);
+		/* Firmware doesn't allow us to create another level 0 table,
+		 * so we create all unmanaged tables as level 1.
+		 *
+		 * To connect them, we use explicit miss rules with
+		 * ignore_flow_level. Caller is responsible to create
+		 * these rules (if needed).
+		 */
+		ft_attr.level = 1;
+		ns = mlx5_get_flow_namespace(chains->dev, chains->ns);
+	}
+
+	ft_attr.autogroup.num_reserved_entries = 2;
+	ft_attr.autogroup.max_num_groups = chains->group_num;
+	ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		mlx5_core_warn(chains->dev, "Failed to create chains table err %d (chain: %d, prio: %d, level: %d, size: %d)\n",
+			       (int)PTR_ERR(ft), chain, prio, level, sz);
+		mlx5_chains_put_sz_to_pool(chains, sz);
+		return ft;
+	}
+
+	return ft;
+}
+
+static void
+mlx5_chains_destroy_table(struct mlx5_fs_chains *chains,
+			  struct mlx5_flow_table *ft)
+{
+	mlx5_chains_put_sz_to_pool(chains, ft->max_fte);
+	mlx5_destroy_flow_table(ft);
+}
+
+static int
+create_chain_restore(struct fs_chain *chain)
+{
+	struct mlx5_eswitch *esw = chain->chains->dev->priv.eswitch;
+	char modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)];
+	struct mlx5_fs_chains *chains = chain->chains;
+	enum mlx5e_tc_attr_to_reg chain_to_reg;
+	struct mlx5_modify_hdr *mod_hdr;
+	u32 index;
+	int err;
+
+	if (chain->chain == mlx5_chains_get_nf_ft_chain(chains) ||
+	    !mlx5_chains_prios_supported(chains))
+		return 0;
+
+	err = mapping_add(chains_mapping(chains), &chain->chain, &index);
+	if (err)
+		return err;
+	if (index == MLX5_FS_DEFAULT_FLOW_TAG) {
+		/* we got the special default flow tag id, so we won't know
+		 * if we actually marked the packet with the restore rule
+		 * we create.
+		 *
+		 * This case isn't possible with MLX5_FS_DEFAULT_FLOW_TAG = 0.
+		 */
+		err = mapping_add(chains_mapping(chains),
+				  &chain->chain, &index);
+		mapping_remove(chains_mapping(chains),
+			       MLX5_FS_DEFAULT_FLOW_TAG);
+		if (err)
+			return err;
+	}
+
+	chain->id = index;
+
+	if (chains->ns == MLX5_FLOW_NAMESPACE_FDB) {
+		chain_to_reg = CHAIN_TO_REG;
+		chain->restore_rule = esw_add_restore_rule(esw, chain->id);
+		if (IS_ERR(chain->restore_rule)) {
+			err = PTR_ERR(chain->restore_rule);
+			goto err_rule;
+		}
+	} else {
+		err = -EINVAL;
+		goto err_rule;
+	}
+
+	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
+	MLX5_SET(set_action_in, modact, field,
+		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mfield);
+	MLX5_SET(set_action_in, modact, offset,
+		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].moffset * 8);
+	MLX5_SET(set_action_in, modact, length,
+		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mlen * 8);
+	MLX5_SET(set_action_in, modact, data, chain->id);
+	mod_hdr = mlx5_modify_header_alloc(chains->dev, chains->ns,
+					   1, modact);
+	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
+		goto err_mod_hdr;
+	}
+	chain->miss_modify_hdr = mod_hdr;
+
+	return 0;
+
+err_mod_hdr:
+	if (!IS_ERR_OR_NULL(chain->restore_rule))
+		mlx5_del_flow_rules(chain->restore_rule);
+err_rule:
+	/* Datapath can't find this mapping, so we can safely remove it */
+	mapping_remove(chains_mapping(chains), chain->id);
+	return err;
+}
+
+static void destroy_chain_restore(struct fs_chain *chain)
+{
+	struct mlx5_fs_chains *chains = chain->chains;
+
+	if (!chain->miss_modify_hdr)
+		return;
+
+	if (chain->restore_rule)
+		mlx5_del_flow_rules(chain->restore_rule);
+
+	mlx5_modify_header_dealloc(chains->dev, chain->miss_modify_hdr);
+	mapping_remove(chains_mapping(chains), chain->id);
+}
+
+static struct fs_chain *
+mlx5_chains_create_chain(struct mlx5_fs_chains *chains, u32 chain)
+{
+	struct fs_chain *chain_s = NULL;
+	int err;
+
+	chain_s = kvzalloc(sizeof(*chain_s), GFP_KERNEL);
+	if (!chain_s)
+		return ERR_PTR(-ENOMEM);
+
+	chain_s->chains = chains;
+	chain_s->chain = chain;
+	INIT_LIST_HEAD(&chain_s->prios_list);
+
+	err = create_chain_restore(chain_s);
+	if (err)
+		goto err_restore;
+
+	err = rhashtable_insert_fast(&chains_ht(chains), &chain_s->node,
+				     chain_params);
+	if (err)
+		goto err_insert;
+
+	return chain_s;
+
+err_insert:
+	destroy_chain_restore(chain_s);
+err_restore:
+	kvfree(chain_s);
+	return ERR_PTR(err);
+}
+
+static void
+mlx5_chains_destroy_chain(struct fs_chain *chain)
+{
+	struct mlx5_fs_chains *chains = chain->chains;
+
+	rhashtable_remove_fast(&chains_ht(chains), &chain->node,
+			       chain_params);
+
+	destroy_chain_restore(chain);
+	kvfree(chain);
+}
+
+static struct fs_chain *
+mlx5_chains_get_chain(struct mlx5_fs_chains *chains, u32 chain)
+{
+	struct fs_chain *chain_s;
+
+	chain_s = rhashtable_lookup_fast(&chains_ht(chains), &chain,
+					 chain_params);
+	if (!chain_s) {
+		chain_s = mlx5_chains_create_chain(chains, chain);
+		if (IS_ERR(chain_s))
+			return chain_s;
+	}
+
+	chain_s->ref++;
+
+	return chain_s;
+}
+
+static struct mlx5_flow_handle *
+mlx5_chains_add_miss_rule(struct fs_chain *chain,
+			  struct mlx5_flow_table *ft,
+			  struct mlx5_flow_table *next_ft)
+{
+	struct mlx5_fs_chains *chains = chain->chains;
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act act = {};
+
+	act.flags  = FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
+	act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dest.type  = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = next_ft;
+
+	if (next_ft == tc_end_ft(chains) &&
+	    chain->chain != mlx5_chains_get_nf_ft_chain(chains) &&
+	    mlx5_chains_prios_supported(chains)) {
+		act.modify_hdr = chain->miss_modify_hdr;
+		act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	}
+
+	return mlx5_add_flow_rules(ft, NULL, &act, &dest, 1);
+}
+
+static int
+mlx5_chains_update_prio_prevs(struct prio *prio,
+			      struct mlx5_flow_table *next_ft)
+{
+	struct mlx5_flow_handle *miss_rules[FDB_TC_LEVELS_PER_PRIO + 1] = {};
+	struct fs_chain *chain = prio->chain;
+	struct prio *pos;
+	int n = 0, err;
+
+	if (prio->key.level)
+		return 0;
+
+	/* Iterate in reverse order until reaching the level 0 rule of
+	 * the previous priority, adding all the miss rules first, so we can
+	 * revert them if any of them fails.
+	 */
+	pos = prio;
+	list_for_each_entry_continue_reverse(pos,
+					     &chain->prios_list,
+					     list) {
+		miss_rules[n] = mlx5_chains_add_miss_rule(chain,
+							  pos->ft,
+							  next_ft);
+		if (IS_ERR(miss_rules[n])) {
+			err = PTR_ERR(miss_rules[n]);
+			goto err_prev_rule;
+		}
+
+		n++;
+		if (!pos->key.level)
+			break;
+	}
+
+	/* Success, delete old miss rules, and update the pointers. */
+	n = 0;
+	pos = prio;
+	list_for_each_entry_continue_reverse(pos,
+					     &chain->prios_list,
+					     list) {
+		mlx5_del_flow_rules(pos->miss_rule);
+
+		pos->miss_rule = miss_rules[n];
+		pos->next_ft = next_ft;
+
+		n++;
+		if (!pos->key.level)
+			break;
+	}
+
+	return 0;
+
+err_prev_rule:
+	while (--n >= 0)
+		mlx5_del_flow_rules(miss_rules[n]);
+
+	return err;
+}
+
+static void
+mlx5_chains_put_chain(struct fs_chain *chain)
+{
+	if (--chain->ref == 0)
+		mlx5_chains_destroy_chain(chain);
+}
+
+static struct prio *
+mlx5_chains_create_prio(struct mlx5_fs_chains *chains,
+			u32 chain, u32 prio, u32 level)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_handle *miss_rule = NULL;
+	struct mlx5_flow_group *miss_group;
+	struct mlx5_flow_table *next_ft;
+	struct mlx5_flow_table *ft;
+	struct prio *prio_s = NULL;
+	struct fs_chain *chain_s;
+	struct list_head *pos;
+	u32 *flow_group_in;
+	int err;
+
+	chain_s = mlx5_chains_get_chain(chains, chain);
+	if (IS_ERR(chain_s))
+		return ERR_CAST(chain_s);
+
+	prio_s = kvzalloc(sizeof(*prio_s), GFP_KERNEL);
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!prio_s || !flow_group_in) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+
+	/* Chain's prio list is sorted by prio and level.
+	 * And all levels of some prio point to the next prio's level 0.
+	 * Example list (prio, level):
+	 * (3,0)->(3,1)->(5,0)->(5,1)->(6,1)->(7,0)
+	 * In hardware, we will we have the following pointers:
+	 * (3,0) -> (5,0) -> (7,0) -> Slow path
+	 * (3,1) -> (5,0)
+	 * (5,1) -> (7,0)
+	 * (6,1) -> (7,0)
+	 */
+
+	/* Default miss for each chain: */
+	next_ft = (chain == mlx5_chains_get_nf_ft_chain(chains)) ?
+		  tc_default_ft(chains) :
+		  tc_end_ft(chains);
+	list_for_each(pos, &chain_s->prios_list) {
+		struct prio *p = list_entry(pos, struct prio, list);
+
+		/* exit on first pos that is larger */
+		if (prio < p->key.prio || (prio == p->key.prio &&
+					   level < p->key.level)) {
+			/* Get next level 0 table */
+			next_ft = p->key.level == 0 ? p->ft : p->next_ft;
+			break;
+		}
+	}
+
+	ft = mlx5_chains_create_table(chains, chain, prio, level);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_create;
+	}
+
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index,
+		 ft->max_fte - 2);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+		 ft->max_fte - 1);
+	miss_group = mlx5_create_flow_group(ft, flow_group_in);
+	if (IS_ERR(miss_group)) {
+		err = PTR_ERR(miss_group);
+		goto err_group;
+	}
+
+	/* Add miss rule to next_ft */
+	miss_rule = mlx5_chains_add_miss_rule(chain_s, ft, next_ft);
+	if (IS_ERR(miss_rule)) {
+		err = PTR_ERR(miss_rule);
+		goto err_miss_rule;
+	}
+
+	prio_s->miss_group = miss_group;
+	prio_s->miss_rule = miss_rule;
+	prio_s->next_ft = next_ft;
+	prio_s->chain = chain_s;
+	prio_s->key.chain = chain;
+	prio_s->key.prio = prio;
+	prio_s->key.level = level;
+	prio_s->ft = ft;
+
+	err = rhashtable_insert_fast(&prios_ht(chains), &prio_s->node,
+				     prio_params);
+	if (err)
+		goto err_insert;
+
+	list_add(&prio_s->list, pos->prev);
+
+	/* Table is ready, connect it */
+	err = mlx5_chains_update_prio_prevs(prio_s, ft);
+	if (err)
+		goto err_update;
+
+	kvfree(flow_group_in);
+	return prio_s;
+
+err_update:
+	list_del(&prio_s->list);
+	rhashtable_remove_fast(&prios_ht(chains), &prio_s->node,
+			       prio_params);
+err_insert:
+	mlx5_del_flow_rules(miss_rule);
+err_miss_rule:
+	mlx5_destroy_flow_group(miss_group);
+err_group:
+	mlx5_chains_destroy_table(chains, ft);
+err_create:
+err_alloc:
+	kvfree(prio_s);
+	kvfree(flow_group_in);
+	mlx5_chains_put_chain(chain_s);
+	return ERR_PTR(err);
+}
+
+static void
+mlx5_chains_destroy_prio(struct mlx5_fs_chains *chains,
+			 struct prio *prio)
+{
+	struct fs_chain *chain = prio->chain;
+
+	WARN_ON(mlx5_chains_update_prio_prevs(prio,
+					      prio->next_ft));
+
+	list_del(&prio->list);
+	rhashtable_remove_fast(&prios_ht(chains), &prio->node,
+			       prio_params);
+	mlx5_del_flow_rules(prio->miss_rule);
+	mlx5_destroy_flow_group(prio->miss_group);
+	mlx5_chains_destroy_table(chains, prio->ft);
+	mlx5_chains_put_chain(chain);
+	kvfree(prio);
+}
+
+struct mlx5_flow_table *
+mlx5_chains_get_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
+		      u32 level)
+{
+	struct mlx5_flow_table *prev_fts;
+	struct prio *prio_s;
+	struct prio_key key;
+	int l = 0;
+
+	if ((chain > mlx5_chains_get_chain_range(chains) &&
+	     chain != mlx5_chains_get_nf_ft_chain(chains)) ||
+	    prio > mlx5_chains_get_prio_range(chains) ||
+	    level > mlx5_chains_get_level_range(chains))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* create earlier levels for correct fs_core lookup when
+	 * connecting tables.
+	 */
+	for (l = 0; l < level; l++) {
+		prev_fts = mlx5_chains_get_table(chains, chain, prio, l);
+		if (IS_ERR(prev_fts)) {
+			prio_s = ERR_CAST(prev_fts);
+			goto err_get_prevs;
+		}
+	}
+
+	key.chain = chain;
+	key.prio = prio;
+	key.level = level;
+
+	mutex_lock(&chains_lock(chains));
+	prio_s = rhashtable_lookup_fast(&prios_ht(chains), &key,
+					prio_params);
+	if (!prio_s) {
+		prio_s = mlx5_chains_create_prio(chains, chain,
+						 prio, level);
+		if (IS_ERR(prio_s))
+			goto err_create_prio;
+	}
+
+	++prio_s->ref;
+	mutex_unlock(&chains_lock(chains));
+
+	return prio_s->ft;
+
+err_create_prio:
+	mutex_unlock(&chains_lock(chains));
+err_get_prevs:
+	while (--l >= 0)
+		mlx5_chains_put_table(chains, chain, prio, l);
+	return ERR_CAST(prio_s);
+}
+
+void
+mlx5_chains_put_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
+		      u32 level)
+{
+	struct prio *prio_s;
+	struct prio_key key;
+
+	key.chain = chain;
+	key.prio = prio;
+	key.level = level;
+
+	mutex_lock(&chains_lock(chains));
+	prio_s = rhashtable_lookup_fast(&prios_ht(chains), &key,
+					prio_params);
+	if (!prio_s)
+		goto err_get_prio;
+
+	if (--prio_s->ref == 0)
+		mlx5_chains_destroy_prio(chains, prio_s);
+	mutex_unlock(&chains_lock(chains));
+
+	while (level-- > 0)
+		mlx5_chains_put_table(chains, chain, prio, level);
+
+	return;
+
+err_get_prio:
+	mutex_unlock(&chains_lock(chains));
+	WARN_ONCE(1,
+		  "Couldn't find table: (chain: %d prio: %d level: %d)",
+		  chain, prio, level);
+}
+
+struct mlx5_flow_table *
+mlx5_chains_get_tc_end_ft(struct mlx5_fs_chains *chains)
+{
+	return tc_end_ft(chains);
+}
+
+struct mlx5_flow_table *
+mlx5_chains_create_global_table(struct mlx5_fs_chains *chains)
+{
+	u32 chain, prio, level;
+	int err;
+
+	if (!mlx5_chains_ignore_flow_level_supported(chains)) {
+		err = -EOPNOTSUPP;
+
+		mlx5_core_warn(chains->dev,
+			       "Couldn't create global flow table, ignore_flow_level not supported.");
+		goto err_ignore;
+	}
+
+	chain = mlx5_chains_get_chain_range(chains),
+	prio = mlx5_chains_get_prio_range(chains);
+	level = mlx5_chains_get_level_range(chains);
+
+	return mlx5_chains_create_table(chains, chain, prio, level);
+
+err_ignore:
+	return ERR_PTR(err);
+}
+
+void
+mlx5_chains_destroy_global_table(struct mlx5_fs_chains *chains,
+				 struct mlx5_flow_table *ft)
+{
+	mlx5_chains_destroy_table(chains, ft);
+}
+
+static struct mlx5_fs_chains *
+mlx5_chains_init(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
+{
+	struct mlx5_fs_chains *chains_priv;
+	struct mapping_ctx *mapping;
+	u32 max_flow_counter;
+	int err;
+
+	chains_priv = kzalloc(sizeof(*chains_priv), GFP_KERNEL);
+	if (!chains_priv)
+		return ERR_PTR(-ENOMEM);
+
+	max_flow_counter = (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
+			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
+
+	mlx5_core_dbg(dev,
+		      "Init flow table chains, max counters(%d), groups(%d), max flow table size(%d)\n",
+		      max_flow_counter, attr->max_grp_num, attr->max_ft_sz);
+
+	chains_priv->dev = dev;
+	chains_priv->flags = attr->flags;
+	chains_priv->ns = attr->ns;
+	chains_priv->group_num = attr->max_grp_num;
+	tc_default_ft(chains_priv) = tc_end_ft(chains_priv) = attr->default_ft;
+
+	mlx5_core_info(dev, "Supported tc offload range - chains: %u, prios: %u\n",
+		       mlx5_chains_get_chain_range(chains_priv),
+		       mlx5_chains_get_prio_range(chains_priv));
+
+	mlx5_chains_init_sz_pool(chains_priv, attr->max_ft_sz);
+
+	err = rhashtable_init(&chains_ht(chains_priv), &chain_params);
+	if (err)
+		goto init_chains_ht_err;
+
+	err = rhashtable_init(&prios_ht(chains_priv), &prio_params);
+	if (err)
+		goto init_prios_ht_err;
+
+	mapping = mapping_create(sizeof(u32), attr->max_restore_tag,
+				 true);
+	if (IS_ERR(mapping)) {
+		err = PTR_ERR(mapping);
+		goto mapping_err;
+	}
+	chains_mapping(chains_priv) = mapping;
+
+	mutex_init(&chains_lock(chains_priv));
+
+	return chains_priv;
+
+mapping_err:
+	rhashtable_destroy(&prios_ht(chains_priv));
+init_prios_ht_err:
+	rhashtable_destroy(&chains_ht(chains_priv));
+init_chains_ht_err:
+	kfree(chains_priv);
+	return ERR_PTR(err);
+}
+
+static void
+mlx5_chains_cleanup(struct mlx5_fs_chains *chains)
+{
+	mutex_destroy(&chains_lock(chains));
+	mapping_destroy(chains_mapping(chains));
+	rhashtable_destroy(&prios_ht(chains));
+	rhashtable_destroy(&chains_ht(chains));
+
+	kfree(chains);
+}
+
+struct mlx5_fs_chains *
+mlx5_chains_create(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
+{
+	struct mlx5_fs_chains *chains;
+
+	chains = mlx5_chains_init(dev, attr);
+
+	return chains;
+}
+
+void
+mlx5_chains_destroy(struct mlx5_fs_chains *chains)
+{
+	mlx5_chains_cleanup(chains);
+}
+
+int
+mlx5_chains_get_chain_mapping(struct mlx5_fs_chains *chains, u32 chain,
+			      u32 *chain_mapping)
+{
+	return mapping_add(chains_mapping(chains), &chain, chain_mapping);
+}
+
+int
+mlx5_chains_put_chain_mapping(struct mlx5_fs_chains *chains, u32 chain_mapping)
+{
+	return mapping_remove(chains_mapping(chains), chain_mapping);
+}
+
+int mlx5_get_chain_for_tag(struct mlx5_fs_chains *chains, u32 tag,
+			   u32 *chain)
+{
+	int err;
+
+	err = mapping_find(chains_mapping(chains), tag, chain);
+	if (err) {
+		mlx5_core_warn(chains->dev, "Can't find chain for tag: %d\n", tag);
+		return -ENOENT;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
new file mode 100644
index 000000000000..6d5be31b05dd
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies. */
+
+#ifndef __ML5_ESW_CHAINS_H__
+#define __ML5_ESW_CHAINS_H__
+
+#include <linux/mlx5/fs.h>
+
+struct mlx5_fs_chains;
+
+enum mlx5_chains_flags {
+	MLX5_CHAINS_AND_PRIOS_SUPPORTED = BIT(0),
+	MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED = BIT(1),
+	MLX5_CHAINS_FT_TUNNEL_SUPPORTED = BIT(2),
+};
+
+struct mlx5_chains_attr {
+	enum mlx5_flow_namespace_type ns;
+	u32 flags;
+	u32 max_ft_sz;
+	u32 max_grp_num;
+	struct mlx5_flow_table *default_ft;
+	u32 max_restore_tag;
+};
+
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
+bool
+mlx5_chains_prios_supported(struct mlx5_fs_chains *chains);
+bool
+mlx5_chains_backwards_supported(struct mlx5_fs_chains *chains);
+u32
+mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains);
+u32
+mlx5_chains_get_chain_range(struct mlx5_fs_chains *chains);
+u32
+mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains);
+
+struct mlx5_flow_table *
+mlx5_chains_get_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
+		      u32 level);
+void
+mlx5_chains_put_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
+		      u32 level);
+
+struct mlx5_flow_table *
+mlx5_chains_get_tc_end_ft(struct mlx5_fs_chains *chains);
+
+struct mlx5_flow_table *
+mlx5_chains_create_global_table(struct mlx5_fs_chains *chains);
+void
+mlx5_chains_destroy_global_table(struct mlx5_fs_chains *chains,
+				 struct mlx5_flow_table *ft);
+
+int
+mlx5_chains_get_chain_mapping(struct mlx5_fs_chains *chains, u32 chain,
+			      u32 *chain_mapping);
+int
+mlx5_chains_put_chain_mapping(struct mlx5_fs_chains *chains,
+			      u32 chain_mapping);
+
+struct mlx5_fs_chains *
+mlx5_chains_create(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr);
+void mlx5_chains_destroy(struct mlx5_fs_chains *chains);
+
+int
+mlx5_get_chain_for_tag(struct mlx5_fs_chains *chains, u32 tag, u32 *chain);
+
+void
+mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
+		       struct mlx5_flow_table *ft);
+
+#else /* CONFIG_MLX5_CLS_ACT */
+
+static inline struct mlx5_flow_table *
+mlx5_chains_get_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
+		      u32 level) { return ERR_PTR(-EOPNOTSUPP); }
+static inline void
+mlx5_chains_put_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
+		      u32 level) {};
+
+static inline struct mlx5_flow_table *
+mlx5_chains_get_tc_end_ft(struct mlx5_fs_chains *chains) { return ERR_PTR(-EOPNOTSUPP); }
+
+static inline struct mlx5_fs_chains *
+mlx5_chains_create(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
+{ return NULL; }
+static inline void
+mlx5_chains_destroy(struct mlx5_fs_chains *chains) {};
+
+#endif /* CONFIG_MLX5_CLS_ACT */
+
+#endif /* __ML5_ESW_CHAINS_H__ */
-- 
2.26.2

