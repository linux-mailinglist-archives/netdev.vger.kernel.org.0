Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7974D5C97
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347258AbiCKHl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347240AbiCKHlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CCA1B7602
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D91B9B82AD2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCC2C340E9;
        Fri, 11 Mar 2022 07:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984445;
        bh=McGPBfDlXiTM1tA61IeAgXBZLRJAffAXV9n7QttdHSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIDjpbNP4atx9mfKN2vdHqZDfoPVyeJ7cflS3p6gEERta3oGDUJ41edBgKOg33pW6
         2MKntT+jsQ6p7SWXTCeIrGdnEZoQo7v/e3StvpGQWu2KKwPMUCE/PYxWAWZ4aad0VT
         XsFcYuchQMXHn2kQe2hPYJR5UciXCMDgkvRxd95Vy/Jpv/88UtzbTJVN4CFSj5kd8H
         Da1HX8/7D+85HO3NHZQXM9cHDS+wOu4aei7MlHrfZZX1Kxy0HcOZP83MPz66gYx1mY
         tWclylL2Rm5d9ctJcIOGCNeSfvK397K/qVE3vcOfbQg6CvuF0XQNNluL/WK+gxs9V4
         xMxFKfZkJaKhw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: CT: Introduce a platform for multiple flow steering providers
Date:   Thu, 10 Mar 2022 23:40:24 -0800
Message-Id: <20220311074031.645168-9-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Currently, fs_core layer provides flow steering services to the driver
including: autogroups, allocating FTEs (flow table entries) and FTE ids,
and support of fte action modification. If then software steering is
configured, rule insertion will go through a translation layer from
firmware buffers to software steering objects (see fs_dr.c).

The connection tracking table is a system table that is not directly
controlled by the user and is a very high scale table. These fs_core
services introduces an overhead that may be optimized by using software
steering API directly.

Introduce ct flow steering interface to allow multiple flow steering
providers. Use the new interface to implement the current dmfs (device
managed flow steering) provider which uses fs_core insertion.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs.h | 24 +++++++
 .../mellanox/mlx5/core/en/tc/ct_fs_dmfs.c     | 64 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 33 +++++++++-
 4 files changed, 119 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b94cca45eb78..24cf559811b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -55,7 +55,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/a
 					en/tc/act/ct.o en/tc/act/sample.o en/tc/act/ptype.o \
 					en/tc/act/redirect_ingress.o
 
-mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
+mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o en/tc/ct_fs_dmfs.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
 
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h
new file mode 100644
index 000000000000..0df12d490f2b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. */
+
+#ifndef __MLX5_EN_TC_CT_FS_H__
+#define __MLX5_EN_TC_CT_FS_H__
+
+struct mlx5_ct_fs {
+	const struct net_device *netdev;
+	struct mlx5_core_dev *dev;
+};
+
+struct mlx5_ct_fs_rule {
+};
+
+struct mlx5_ct_fs_ops {
+	struct mlx5_ct_fs_rule * (*ct_rule_add)(struct mlx5_ct_fs *fs,
+						struct mlx5_flow_spec *spec,
+						struct mlx5_flow_attr *attr);
+	void (*ct_rule_del)(struct mlx5_ct_fs *fs, struct mlx5_ct_fs_rule *fs_rule);
+};
+
+struct mlx5_ct_fs_ops *mlx5_ct_fs_dmfs_ops_get(void);
+
+#endif /* __MLX5_EN_TC_CT_FS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c
new file mode 100644
index 000000000000..94bd525ca62e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. */
+
+#include "en_tc.h"
+#include "en/tc_ct.h"
+#include "en/tc/ct_fs.h"
+
+#define ct_dbg(fmt, args...)\
+	netdev_dbg(fs->netdev, "ct_fs_dmfs debug: " fmt "\n", ##args)
+
+struct mlx5_ct_fs_dmfs_rule {
+	struct mlx5_ct_fs_rule fs_rule;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_attr *attr;
+};
+
+static struct mlx5_ct_fs_rule *
+mlx5_ct_fs_dmfs_ct_rule_add(struct mlx5_ct_fs *fs, struct mlx5_flow_spec *spec,
+			    struct mlx5_flow_attr *attr)
+{
+	struct mlx5e_priv *priv = netdev_priv(fs->netdev);
+	struct mlx5_ct_fs_dmfs_rule *dmfs_rule;
+	int err;
+
+	dmfs_rule = kzalloc(sizeof(*dmfs_rule), GFP_KERNEL);
+	if (!dmfs_rule)
+		return ERR_PTR(-ENOMEM);
+
+	dmfs_rule->rule = mlx5_tc_rule_insert(priv, spec, attr);
+	if (IS_ERR(dmfs_rule->rule)) {
+		err = PTR_ERR(dmfs_rule->rule);
+		ct_dbg("Failed to add ct entry fs rule");
+		goto err_insert;
+	}
+
+	dmfs_rule->attr = attr;
+
+	return &dmfs_rule->fs_rule;
+
+err_insert:
+	kfree(dmfs_rule);
+	return ERR_PTR(err);
+}
+
+static void
+mlx5_ct_fs_dmfs_ct_rule_del(struct mlx5_ct_fs *fs, struct mlx5_ct_fs_rule *fs_rule)
+{
+	struct mlx5_ct_fs_dmfs_rule *dmfs_rule = container_of(fs_rule,
+							      struct mlx5_ct_fs_dmfs_rule,
+							      fs_rule);
+
+	mlx5_tc_rule_delete(netdev_priv(fs->netdev), dmfs_rule->rule, dmfs_rule->attr);
+	kfree(dmfs_rule);
+}
+
+static struct mlx5_ct_fs_ops dmfs_ops = {
+	.ct_rule_add = mlx5_ct_fs_dmfs_ct_rule_add,
+	.ct_rule_del = mlx5_ct_fs_dmfs_ct_rule_del,
+};
+
+struct mlx5_ct_fs_ops *mlx5_ct_fs_dmfs_ops_get(void)
+{
+	return &dmfs_ops;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 875e77af0ae6..09e88d8e17d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -18,6 +18,7 @@
 
 #include "lib/fs_chains.h"
 #include "en/tc_ct.h"
+#include "en/tc/ct_fs.h"
 #include "en/tc_priv.h"
 #include "en/mod_hdr.h"
 #include "en/mapping.h"
@@ -63,6 +64,8 @@ struct mlx5_tc_ct_priv {
 	struct mapping_ctx *labels_mapping;
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5_fs_chains *chains;
+	struct mlx5_ct_fs *fs;
+	struct mlx5_ct_fs_ops *fs_ops;
 	spinlock_t ht_lock; /* protects ft entries */
 };
 
@@ -74,7 +77,7 @@ struct mlx5_ct_flow {
 };
 
 struct mlx5_ct_zone_rule {
-	struct mlx5_flow_handle *rule;
+	struct mlx5_ct_fs_rule *rule;
 	struct mlx5e_mod_hdr_handle *mh;
 	struct mlx5_flow_attr *attr;
 	bool nat;
@@ -505,7 +508,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	ct_dbg("Deleting ct entry rule in zone %d", entry->tuple.zone);
 
-	mlx5_tc_rule_delete(netdev_priv(ct_priv->netdev), zone_rule->rule, attr);
+	ct_priv->fs_ops->ct_rule_del(ct_priv->fs, zone_rule->rule);
 	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, zone_rule->mh);
 	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 	kfree(attr);
@@ -816,7 +819,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_tc_ct_set_tuple_match(ct_priv, spec, flow_rule);
 	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
 
-	zone_rule->rule = mlx5_tc_rule_insert(priv, spec, attr);
+	zone_rule->rule = ct_priv->fs_ops->ct_rule_add(ct_priv->fs, spec, attr);
 	if (IS_ERR(zone_rule->rule)) {
 		err = PTR_ERR(zone_rule->rule);
 		ct_dbg("Failed to add ct entry rule, nat: %d", nat);
@@ -1960,6 +1963,22 @@ mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 	mutex_unlock(&priv->control_lock);
 }
 
+static int
+mlx5_tc_ct_fs_init(struct mlx5_tc_ct_priv *ct_priv)
+{
+	struct mlx5_ct_fs_ops *fs_ops = mlx5_ct_fs_dmfs_ops_get();
+
+	ct_priv->fs = kzalloc(sizeof(*ct_priv->fs), GFP_KERNEL);
+	if (!ct_priv->fs)
+		return -ENOMEM;
+
+	ct_priv->fs->netdev = ct_priv->netdev;
+	ct_priv->fs->dev = ct_priv->dev;
+	ct_priv->fs_ops = fs_ops;
+
+	return 0;
+}
+
 static int
 mlx5_tc_ct_init_check_esw_support(struct mlx5_eswitch *esw,
 				  const char **err_msg)
@@ -2098,8 +2117,14 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	if (rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params))
 		goto err_ct_tuples_nat_ht;
 
+	err = mlx5_tc_ct_fs_init(ct_priv);
+	if (err)
+		goto err_init_fs;
+
 	return ct_priv;
 
+err_init_fs:
+	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
 err_ct_tuples_nat_ht:
 	rhashtable_destroy(&ct_priv->ct_tuples_ht);
 err_ct_tuples_ht:
@@ -2130,6 +2155,8 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 
 	chains = ct_priv->chains;
 
+	kfree(ct_priv->fs);
+
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct_nat);
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
 	mapping_destroy(ct_priv->zone_mapping);
-- 
2.35.1

