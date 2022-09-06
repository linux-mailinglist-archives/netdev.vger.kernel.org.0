Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8645ADEF6
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbiIFFWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiIFFVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AF26D55A
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BEBCB81627
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268E9C43470;
        Tue,  6 Sep 2022 05:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441707;
        bh=3Ylner2KFSxOELanPtAwdDF1snx7/QzO44/qReVgffM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWsDCDwAytg2XT/5ctaVPEMuClmBibD9yoq778E8P81cFvEX5bysFN+AKBL4C1MKb
         ys3LUwXveMYaJO8868msXNh3GUS3CYCzOnEgp3s+upCdqdbwhenpfQBZ4PZ6biu8Qo
         NHUdTv6SnKhWClvd7Y6qLHl/8OVTEAsgnrmpNoZO8Iy4HvpHw62iTEMZrZhCCQFkBs
         ucu5on26IycfY+INxUcJcXSz4akudCONpOpXyFKwlziOiW9CkOvwPlDOSQItBAFHpO
         0Gr+bs4G2Tiayl02UfcejDMgZIqZt3PSUoiUNDZWeR166gvRF0YOX7+rt2RMWcAz5w
         7Bsqt6129uR6g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 09/17] net/mlx5e: Add MACsec TX steering rules
Date:   Mon,  5 Sep 2022 22:21:21 -0700
Message-Id: <20220906052129.104507-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

Tx flow steering consists of two flow tables (FTs).

The first FT (crypto table) has two fixed rules:
One default miss rule so non MACsec offloaded packets bypass the MACSec
tables, another rule to make sure that MACsec key exchange (MKE) traffic
passes unencrypted as expected (matched of ethertype).
On each new MACsec offload flow, a new MACsec rule is added.
This rule is matched on metadata_reg_a (which contains the id of the
flow) and invokes the MACsec offload action on match.

The second FT (check table) has two fixed rules:
One rule for verifying that the previous offload actions were
finished successfully and packet need to be transmitted.
Another default rule for dropping packets that were failed in the
offload actions.

The MACsec FTs should be created on demand when the first MACsec rule is
added and destroyed when the last MACsec rule is deleted.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/en_accel/macsec.c      |  65 +-
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   | 676 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/macsec_fs.h   |  41 ++
 include/linux/mlx5/qp.h                       |   1 +
 5 files changed, 770 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index dd4b44a54712..889128638763 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -92,7 +92,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
-mlx5_core-$(CONFIG_MLX5_EN_MACSEC) += en_accel/macsec.o
+mlx5_core-$(CONFIG_MLX5_EN_MACSEC) += en_accel/macsec.o en_accel/macsec_fs.o
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index f23ff25b2a1b..a3ac410f137e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -7,6 +7,7 @@
 #include "en.h"
 #include "lib/mlx5.h"
 #include "en_accel/macsec.h"
+#include "en_accel/macsec_fs.h"
 
 #define MLX5_MACSEC_ASO_INC_SN  0x2
 #define MLX5_MACSEC_ASO_REG_C_4_5 0x2
@@ -18,9 +19,12 @@ struct mlx5e_macsec_sa {
 	u32 enc_key_id;
 	u32 next_pn;
 	sci_t sci;
+
+	struct mlx5e_macsec_tx_rule *tx_rule;
 };
 
 struct mlx5e_macsec {
+	struct mlx5e_macsec_fs *macsec_fs;
 	struct mlx5e_macsec_sa *tx_sa[MACSEC_NUM_AN];
 	struct mutex lock; /* Protects mlx5e_macsec internal contexts */
 
@@ -90,18 +94,26 @@ static void mlx5e_macsec_destroy_object(struct mlx5_core_dev *mdev, u32 macsec_o
 	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-static void mlx5e_macsec_cleanup_object(struct mlx5e_macsec *macsec,
-					struct mlx5e_macsec_sa *sa)
+static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec, struct mlx5e_macsec_sa *sa)
 {
+
+	if (!sa->tx_rule)
+		return;
+
+	mlx5e_macsec_fs_del_rule(macsec->macsec_fs, sa->tx_rule,
+				 MLX5_ACCEL_MACSEC_ACTION_ENCRYPT);
 	mlx5e_macsec_destroy_object(macsec->mdev, sa->macsec_obj_id);
+	sa->tx_rule = NULL;
 }
 
-static int mlx5e_macsec_init_object(struct macsec_context *ctx,
-				    struct mlx5e_macsec_sa *sa,
-				    bool encrypt)
+static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
+				struct mlx5e_macsec_sa *sa,
+				bool encrypt)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec *macsec = priv->macsec;
+	struct mlx5_macsec_rule_attrs rule_attrs;
+	struct mlx5e_macsec_tx_rule *tx_rule;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_macsec_obj_attrs obj_attrs;
 	int err;
@@ -116,7 +128,21 @@ static int mlx5e_macsec_init_object(struct macsec_context *ctx,
 	if (err)
 		return err;
 
+	rule_attrs.macsec_obj_id = sa->macsec_obj_id;
+	rule_attrs.action = MLX5_ACCEL_MACSEC_ACTION_ENCRYPT;
+
+	tx_rule = mlx5e_macsec_fs_add_rule(macsec->macsec_fs, ctx, &rule_attrs);
+	if (IS_ERR_OR_NULL(tx_rule))
+		goto destroy_macsec_object;
+
+	sa->tx_rule = tx_rule;
+
 	return 0;
+
+destroy_macsec_object:
+	mlx5e_macsec_destroy_object(mdev, sa->macsec_obj_id);
+
+	return err;
 }
 
 static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
@@ -168,7 +194,7 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 	    !tx_sa->active)
 		goto out;
 
-	err = mlx5e_macsec_init_object(ctx, tx_sa, tx_sc->encrypt);
+	err = mlx5e_macsec_init_sa(ctx, tx_sa, tx_sc->encrypt);
 	if (err)
 		goto destroy_encryption_key;
 
@@ -228,15 +254,17 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 		goto out;
 
 	if (ctx_tx_sa->active) {
-		err = mlx5e_macsec_init_object(ctx, tx_sa, tx_sc->encrypt);
+		err = mlx5e_macsec_init_sa(ctx, tx_sa, tx_sc->encrypt);
 		if (err)
 			goto out;
 	} else {
-		mlx5e_macsec_cleanup_object(macsec, tx_sa);
+		if (!tx_sa->tx_rule)
+			return -EINVAL;
+
+		mlx5e_macsec_cleanup_sa(macsec, tx_sa);
 	}
 
 	tx_sa->active = ctx_tx_sa->active;
-
 out:
 	mutex_unlock(&macsec->lock);
 
@@ -246,7 +274,6 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
-	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_sa *tx_sa;
 	struct mlx5e_macsec *macsec;
@@ -266,10 +293,8 @@ static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 		goto out;
 	}
 
-	mlx5e_macsec_cleanup_object(macsec, tx_sa);
-
-	mlx5_destroy_encryption_key(mdev, tx_sa->enc_key_id);
-
+	mlx5e_macsec_cleanup_sa(macsec, tx_sa);
+	mlx5_destroy_encryption_key(macsec->mdev, tx_sa->enc_key_id);
 	kfree(tx_sa);
 	macsec->tx_sa[assoc_num] = NULL;
 
@@ -334,6 +359,7 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_macsec *macsec = NULL;
+	struct mlx5e_macsec_fs *macsec_fs;
 	int err;
 
 	if (!mlx5e_is_macsec_device(priv->mdev)) {
@@ -359,12 +385,21 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 
 	macsec->mdev = mdev;
 
+	macsec_fs = mlx5e_macsec_fs_init(mdev, priv->netdev);
+	if (IS_ERR_OR_NULL(macsec_fs))
+		goto err_out;
+
+	macsec->macsec_fs = macsec_fs;
+
 	mlx5_core_dbg(mdev, "MACsec attached to netdevice\n");
 
 	return 0;
 
+err_out:
+	mlx5_core_dealloc_pd(priv->mdev, macsec->aso_pdn);
 err_pd:
 	kfree(macsec);
+	priv->macsec = NULL;
 	return err;
 }
 
@@ -375,6 +410,8 @@ void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
 	if (!macsec)
 		return;
 
+	mlx5e_macsec_fs_cleanup(macsec->macsec_fs);
+
 	priv->macsec = NULL;
 
 	mlx5_core_dealloc_pd(priv->mdev, macsec->aso_pdn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
new file mode 100644
index 000000000000..5c2397c34318
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -0,0 +1,676 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <net/macsec.h>
+#include <linux/netdevice.h>
+#include <linux/mlx5/qp.h>
+#include "fs_core.h"
+#include "en/fs.h"
+#include "en_accel/macsec_fs.h"
+#include "mlx5_core.h"
+
+/* MACsec TX flow steering */
+#define CRYPTO_NUM_MAXSEC_FTE BIT(15)
+#define CRYPTO_TABLE_DEFAULT_RULE_GROUP_SIZE 1
+
+#define TX_CRYPTO_TABLE_LEVEL 0
+#define TX_CRYPTO_TABLE_NUM_GROUPS 3
+#define TX_CRYPTO_TABLE_MKE_GROUP_SIZE 1
+#define TX_CRYPTO_TABLE_SA_GROUP_SIZE \
+	(CRYPTO_NUM_MAXSEC_FTE - (TX_CRYPTO_TABLE_MKE_GROUP_SIZE + \
+				  CRYPTO_TABLE_DEFAULT_RULE_GROUP_SIZE))
+#define TX_CHECK_TABLE_LEVEL 1
+#define TX_CHECK_TABLE_NUM_FTE 2
+
+#define MLX5_MACSEC_TAG_LEN 8 /* SecTAG length with ethertype and without the optional SCI */
+
+#define MLX5_ETH_WQE_FT_META_MACSEC_MASK 0x3E
+
+struct mlx5_sectag_header {
+	__be16 ethertype;
+	u8 tci_an;
+	u8 sl;
+	u32 pn;
+	u8 sci[MACSEC_SCI_LEN]; /* optional */
+}  __packed;
+
+struct mlx5e_macsec_tx_rule {
+	struct mlx5_flow_handle *rule;
+	struct mlx5_pkt_reformat *pkt_reformat;
+	u32 fs_id;
+};
+
+struct mlx5e_macsec_tx {
+	struct mlx5e_flow_table ft_crypto;
+	struct mlx5_flow_handle *crypto_miss_rule;
+	struct mlx5_flow_handle *crypto_mke_rule;
+
+	struct mlx5_flow_table *ft_check;
+	struct mlx5_flow_group  *ft_check_group;
+	struct mlx5_fc *check_miss_rule_counter;
+	struct mlx5_flow_handle *check_miss_rule;
+	struct mlx5_fc *check_rule_counter;
+	struct mlx5_flow_handle *check_rule;
+
+	struct ida tx_halloc;
+
+	u32 refcnt;
+};
+
+struct mlx5e_macsec_fs {
+	struct mlx5_core_dev *mdev;
+	struct net_device *netdev;
+	struct mlx5e_macsec_tx *tx_fs;
+};
+
+static void macsec_fs_tx_destroy(struct mlx5e_macsec_fs *macsec_fs)
+{
+	struct mlx5e_macsec_tx *tx_fs = macsec_fs->tx_fs;
+
+	/* Tx check table */
+	if (tx_fs->check_rule) {
+		mlx5_del_flow_rules(tx_fs->check_rule);
+		tx_fs->check_rule = NULL;
+	}
+
+	if (tx_fs->check_miss_rule) {
+		mlx5_del_flow_rules(tx_fs->check_miss_rule);
+		tx_fs->check_miss_rule = NULL;
+	}
+
+	if (tx_fs->ft_check_group) {
+		mlx5_destroy_flow_group(tx_fs->ft_check_group);
+		tx_fs->ft_check_group = NULL;
+	}
+
+	if (tx_fs->ft_check) {
+		mlx5_destroy_flow_table(tx_fs->ft_check);
+		tx_fs->ft_check = NULL;
+	}
+
+	/* Tx crypto table */
+	if (tx_fs->crypto_mke_rule) {
+		mlx5_del_flow_rules(tx_fs->crypto_mke_rule);
+		tx_fs->crypto_mke_rule = NULL;
+	}
+
+	if (tx_fs->crypto_miss_rule) {
+		mlx5_del_flow_rules(tx_fs->crypto_miss_rule);
+		tx_fs->crypto_miss_rule = NULL;
+	}
+
+	mlx5e_destroy_flow_table(&tx_fs->ft_crypto);
+}
+
+static int macsec_fs_tx_create_crypto_table_groups(struct mlx5e_flow_table *ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	int mclen = MLX5_ST_SZ_BYTES(fte_match_param);
+	int ix = 0;
+	u32 *in;
+	int err;
+	u8 *mc;
+
+	ft->g = kcalloc(TX_CRYPTO_TABLE_NUM_GROUPS, sizeof(*ft->g), GFP_KERNEL);
+	if (!ft->g)
+		return -ENOMEM;
+	in = kvzalloc(inlen, GFP_KERNEL);
+
+	if (!in) {
+		kfree(ft->g);
+		return -ENOMEM;
+	}
+
+	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	/* Flow Group for MKE match */
+	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_TO_ONES(fte_match_param, mc, outer_headers.ethertype);
+
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += TX_CRYPTO_TABLE_MKE_GROUP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err;
+	ft->num_groups++;
+
+	/* Flow Group for SA rules */
+	memset(in, 0, inlen);
+	memset(mc, 0, mclen);
+	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_MISC_PARAMETERS_2);
+	MLX5_SET(fte_match_param, mc, misc_parameters_2.metadata_reg_a,
+		 MLX5_ETH_WQE_FT_META_MACSEC_MASK);
+
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += TX_CRYPTO_TABLE_SA_GROUP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err;
+	ft->num_groups++;
+
+	/* Flow Group for l2 traps */
+	memset(in, 0, inlen);
+	memset(mc, 0, mclen);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += CRYPTO_TABLE_DEFAULT_RULE_GROUP_SIZE;
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
+static struct mlx5_flow_table
+	*macsec_fs_auto_group_table_create(struct mlx5_flow_namespace *ns, int flags,
+					   int level, int max_fte)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_table *fdb = NULL;
+
+	/* reserve entry for the match all miss group and rule */
+	ft_attr.autogroup.num_reserved_entries = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft_attr.prio = 0;
+	ft_attr.flags = flags;
+	ft_attr.level = level;
+	ft_attr.max_fte = max_fte;
+
+	fdb = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+
+	return fdb;
+}
+
+static int macsec_fs_tx_create(struct mlx5e_macsec_fs *macsec_fs)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5e_macsec_tx *tx_fs = macsec_fs->tx_fs;
+	struct net_device *netdev = macsec_fs->netdev;
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5e_flow_table *ft_crypto;
+	struct mlx5_flow_table *flow_table;
+	struct mlx5_flow_group *flow_group;
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	u32 *flow_group_in;
+	int err = 0;
+
+	ns = mlx5_get_flow_namespace(macsec_fs->mdev, MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
+	if (!ns)
+		return -ENOMEM;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		goto out_spec;
+
+	ft_crypto = &tx_fs->ft_crypto;
+
+	/* Tx crypto table  */
+	ft_attr.flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
+	ft_attr.level = TX_CRYPTO_TABLE_LEVEL;
+	ft_attr.max_fte = CRYPTO_NUM_MAXSEC_FTE;
+
+	flow_table = mlx5_create_flow_table(ns, &ft_attr);
+	if (IS_ERR(flow_table)) {
+		err = PTR_ERR(flow_table);
+		netdev_err(netdev, "Failed to create MACsec Tx crypto table err(%d)\n", err);
+		goto out_flow_group;
+	}
+	ft_crypto->t = flow_table;
+
+	/* Tx crypto table groups */
+	err = macsec_fs_tx_create_crypto_table_groups(ft_crypto);
+	if (err) {
+		netdev_err(netdev,
+			   "Failed to create default flow group for MACsec Tx crypto table err(%d)\n",
+			   err);
+		goto err;
+	}
+
+	/* Tx crypto table MKE rule - MKE packets shouldn't be offloaded */
+	memset(&flow_act, 0, sizeof(flow_act));
+	memset(spec, 0, sizeof(*spec));
+	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ethertype);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ethertype, ETH_P_PAE);
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+
+	rule = mlx5_add_flow_rules(ft_crypto->t, spec, &flow_act, NULL, 0);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(netdev, "Failed to add MACsec TX MKE rule, err=%d\n", err);
+		goto err;
+	}
+	tx_fs->crypto_mke_rule = rule;
+
+	/* Tx crypto table Default miss rule */
+	memset(&flow_act, 0, sizeof(flow_act));
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	rule = mlx5_add_flow_rules(ft_crypto->t, NULL, &flow_act, NULL, 0);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(netdev, "Failed to add MACsec Tx table default miss rule %d\n", err);
+		goto err;
+	}
+	tx_fs->crypto_miss_rule = rule;
+
+	/* Tx check table */
+	flow_table = macsec_fs_auto_group_table_create(ns, 0, TX_CHECK_TABLE_LEVEL,
+						       TX_CHECK_TABLE_NUM_FTE);
+	if (IS_ERR(flow_table)) {
+		err = PTR_ERR(flow_table);
+		netdev_err(netdev, "fail to create MACsec TX check table, err(%d)\n", err);
+		goto err;
+	}
+	tx_fs->ft_check = flow_table;
+
+	/* Tx check table Default miss group/rule */
+	memset(flow_group_in, 0, inlen);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_table->max_fte - 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_table->max_fte - 1);
+	flow_group = mlx5_create_flow_group(tx_fs->ft_check, flow_group_in);
+	if (IS_ERR(flow_group)) {
+		err = PTR_ERR(flow_group);
+		netdev_err(netdev,
+			   "Failed to create default flow group for MACsec Tx crypto table err(%d)\n",
+			   err);
+		goto err;
+	}
+	tx_fs->ft_check_group = flow_group;
+
+	/* Tx check table default drop rule */
+	memset(&dest, 0, sizeof(struct mlx5_flow_destination));
+	memset(&flow_act, 0, sizeof(flow_act));
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest.counter_id = mlx5_fc_id(tx_fs->check_miss_rule_counter);
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP | MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	rule = mlx5_add_flow_rules(tx_fs->ft_check,  NULL, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(netdev, "Failed to added MACsec tx check drop rule, err(%d)\n", err);
+		goto err;
+	}
+	tx_fs->check_miss_rule = rule;
+
+	/* Tx check table rule */
+	memset(spec, 0, sizeof(struct mlx5_flow_spec));
+	memset(&dest, 0, sizeof(struct mlx5_flow_destination));
+	memset(&flow_act, 0, sizeof(flow_act));
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters_2.metadata_reg_c_4);
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_4, 0);
+	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
+
+	flow_act.flags = FLOW_ACT_NO_APPEND;
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW | MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest.counter_id = mlx5_fc_id(tx_fs->check_rule_counter);
+	rule = mlx5_add_flow_rules(tx_fs->ft_check, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(netdev, "Failed to add MACsec check rule, err=%d\n", err);
+		goto err;
+	}
+	tx_fs->check_rule = rule;
+
+	goto out_flow_group;
+
+err:
+	macsec_fs_tx_destroy(macsec_fs);
+out_flow_group:
+	kvfree(flow_group_in);
+out_spec:
+	kvfree(spec);
+	return err;
+}
+
+static int macsec_fs_tx_ft_get(struct mlx5e_macsec_fs *macsec_fs)
+{
+	struct mlx5e_macsec_tx *tx_fs = macsec_fs->tx_fs;
+	int err = 0;
+
+	if (tx_fs->refcnt)
+		goto out;
+
+	err = macsec_fs_tx_create(macsec_fs);
+	if (err)
+		return err;
+
+out:
+	tx_fs->refcnt++;
+	return err;
+}
+
+static void macsec_fs_tx_ft_put(struct mlx5e_macsec_fs *macsec_fs)
+{
+	struct mlx5e_macsec_tx *tx_fs = macsec_fs->tx_fs;
+
+	if (--tx_fs->refcnt)
+		return;
+
+	macsec_fs_tx_destroy(macsec_fs);
+}
+
+static int macsec_fs_tx_setup_fte(struct mlx5e_macsec_fs *macsec_fs,
+				  struct mlx5_flow_spec *spec,
+				  struct mlx5_flow_act *flow_act,
+				  u32 macsec_obj_id,
+				  u32 *fs_id)
+{
+	struct mlx5e_macsec_tx *tx_fs = macsec_fs->tx_fs;
+	int err = 0;
+	u32 id;
+
+	err = ida_alloc_range(&tx_fs->tx_halloc, 1, MLX5_MACSEC_NUM_OF_SUPPORTED_INTERFACES,
+			      GFP_KERNEL);
+	if (err < 0)
+		return err;
+
+	id = err;
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
+
+	/* Metadata match */
+	MLX5_SET(fte_match_param, spec->match_criteria, misc_parameters_2.metadata_reg_a,
+		 MLX5_ETH_WQE_FT_META_MACSEC_MASK);
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_a,
+		 MLX5_ETH_WQE_FT_META_MACSEC | id << 2);
+
+	*fs_id = id;
+	flow_act->crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_MACSEC;
+	flow_act->crypto.obj_id = macsec_obj_id;
+
+	mlx5_core_dbg(macsec_fs->mdev, "Tx fte: macsec obj_id %u, fs_id %u\n", macsec_obj_id, id);
+	return 0;
+}
+
+static void macsec_fs_tx_create_sectag_header(const struct macsec_context *ctx,
+					      char *reformatbf,
+					      size_t *reformat_size)
+{
+	const struct macsec_secy *secy = ctx->secy;
+	bool sci_present = macsec_send_sci(secy);
+	struct mlx5_sectag_header sectag = {};
+	const struct macsec_tx_sc *tx_sc;
+
+	tx_sc = &secy->tx_sc;
+	sectag.ethertype = htons(ETH_P_MACSEC);
+
+	if (sci_present) {
+		sectag.tci_an |= MACSEC_TCI_SC;
+		memcpy(&sectag.sci, &secy->sci,
+		       sizeof(sectag.sci));
+	} else {
+		if (tx_sc->end_station)
+			sectag.tci_an |= MACSEC_TCI_ES;
+		if (tx_sc->scb)
+			sectag.tci_an |= MACSEC_TCI_SCB;
+	}
+
+	/* With GCM, C/E clear for !encrypt, both set for encrypt */
+	if (tx_sc->encrypt)
+		sectag.tci_an |= MACSEC_TCI_CONFID;
+	else if (secy->icv_len != MACSEC_DEFAULT_ICV_LEN)
+		sectag.tci_an |= MACSEC_TCI_C;
+
+	sectag.tci_an |= tx_sc->encoding_sa;
+
+	*reformat_size = MLX5_MACSEC_TAG_LEN + (sci_present ? MACSEC_SCI_LEN : 0);
+
+	memcpy(reformatbf, &sectag, *reformat_size);
+}
+
+static void macsec_fs_tx_del_rule(struct mlx5e_macsec_fs *macsec_fs,
+				  struct mlx5e_macsec_tx_rule *tx_rule)
+{
+	if (tx_rule->rule) {
+		mlx5_del_flow_rules(tx_rule->rule);
+		tx_rule->rule = NULL;
+	}
+
+	if (tx_rule->pkt_reformat) {
+		mlx5_packet_reformat_dealloc(macsec_fs->mdev, tx_rule->pkt_reformat);
+		tx_rule->pkt_reformat = NULL;
+	}
+
+	if (tx_rule->fs_id) {
+		ida_free(&macsec_fs->tx_fs->tx_halloc, tx_rule->fs_id);
+		tx_rule->fs_id = 0;
+	}
+
+	kfree(tx_rule);
+
+	macsec_fs_tx_ft_put(macsec_fs);
+}
+
+static struct mlx5e_macsec_tx_rule *
+macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
+		      const struct macsec_context *macsec_ctx,
+		      struct mlx5_macsec_rule_attrs *attrs)
+{
+	char reformatbf[MLX5_MACSEC_TAG_LEN + MACSEC_SCI_LEN];
+	struct mlx5_pkt_reformat_params reformat_params = {};
+	struct mlx5e_macsec_tx *tx_fs = macsec_fs->tx_fs;
+	struct net_device *netdev = macsec_fs->netdev;
+	struct mlx5_flow_destination dest = {};
+	struct mlx5e_macsec_tx_rule *tx_rule;
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	size_t reformat_size;
+	int err = 0;
+	u32 fs_id;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return NULL;
+
+	err = macsec_fs_tx_ft_get(macsec_fs);
+	if (err)
+		goto out_spec;
+
+	tx_rule = kzalloc(sizeof(*tx_rule), GFP_KERNEL);
+	if (!tx_rule) {
+		macsec_fs_tx_ft_put(macsec_fs);
+		goto out_spec;
+	}
+
+	/* Tx crypto table crypto rule */
+	macsec_fs_tx_create_sectag_header(macsec_ctx, reformatbf, &reformat_size);
+
+	reformat_params.type = MLX5_REFORMAT_TYPE_ADD_MACSEC;
+	reformat_params.size = reformat_size;
+	reformat_params.data = reformatbf;
+	flow_act.pkt_reformat = mlx5_packet_reformat_alloc(macsec_fs->mdev,
+							   &reformat_params,
+							   MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
+	if (IS_ERR(flow_act.pkt_reformat)) {
+		err = PTR_ERR(flow_act.pkt_reformat);
+		netdev_err(netdev, "Failed to allocate MACsec Tx reformat context err=%d\n",  err);
+		goto err;
+	}
+	tx_rule->pkt_reformat = flow_act.pkt_reformat;
+
+	err = macsec_fs_tx_setup_fte(macsec_fs, spec, &flow_act, attrs->macsec_obj_id, &fs_id);
+	if (err) {
+		netdev_err(netdev,
+			   "Failed to add packet reformat for MACsec TX crypto rule, err=%d\n",
+			   err);
+		goto err;
+	}
+
+	tx_rule->fs_id = fs_id;
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT |
+			  MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = tx_fs->ft_check;
+	rule = mlx5_add_flow_rules(tx_fs->ft_crypto.t, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(netdev, "Failed to add MACsec TX crypto rule, err=%d\n", err);
+		goto err;
+	}
+	tx_rule->rule = rule;
+
+	goto out_spec;
+
+err:
+	macsec_fs_tx_del_rule(macsec_fs, tx_rule);
+	tx_rule = NULL;
+out_spec:
+	kvfree(spec);
+
+	return tx_rule;
+}
+
+static void macsec_fs_tx_cleanup(struct mlx5e_macsec_fs *macsec_fs)
+{
+	struct mlx5e_macsec_tx *tx_fs = macsec_fs->tx_fs;
+	struct mlx5_core_dev *mdev = macsec_fs->mdev;
+
+	if (!tx_fs)
+		return;
+
+	if (tx_fs->refcnt) {
+		netdev_err(macsec_fs->netdev,
+			   "Can't destroy MACsec offload tx_fs, refcnt(%u) isn't 0\n",
+			   tx_fs->refcnt);
+		return;
+	}
+
+	ida_destroy(&tx_fs->tx_halloc);
+
+	if (tx_fs->check_miss_rule_counter) {
+		mlx5_fc_destroy(mdev, tx_fs->check_miss_rule_counter);
+		tx_fs->check_miss_rule_counter = NULL;
+	}
+
+	if (tx_fs->check_rule_counter) {
+		mlx5_fc_destroy(mdev, tx_fs->check_rule_counter);
+		tx_fs->check_rule_counter = NULL;
+	}
+
+	kfree(tx_fs);
+	macsec_fs->tx_fs = NULL;
+}
+
+static int macsec_fs_tx_init(struct mlx5e_macsec_fs *macsec_fs)
+{
+	struct net_device *netdev = macsec_fs->netdev;
+	struct mlx5_core_dev *mdev = macsec_fs->mdev;
+	struct mlx5e_macsec_tx *tx_fs;
+	struct mlx5_fc *flow_counter;
+	int err;
+
+	tx_fs = kzalloc(sizeof(*tx_fs), GFP_KERNEL);
+	if (!tx_fs)
+		return -ENOMEM;
+
+	flow_counter = mlx5_fc_create(mdev, false);
+	if (IS_ERR(flow_counter)) {
+		err = PTR_ERR(flow_counter);
+		netdev_err(netdev,
+			   "Failed to create MACsec Tx encrypt flow counter, err(%d)\n",
+			   err);
+		goto err_encrypt_counter;
+	}
+	tx_fs->check_rule_counter = flow_counter;
+
+	flow_counter = mlx5_fc_create(mdev, false);
+	if (IS_ERR(flow_counter)) {
+		err = PTR_ERR(flow_counter);
+		netdev_err(netdev,
+			   "Failed to create MACsec Tx drop flow counter, err(%d)\n",
+			   err);
+		goto err_drop_counter;
+	}
+	tx_fs->check_miss_rule_counter = flow_counter;
+
+	ida_init(&tx_fs->tx_halloc);
+
+	macsec_fs->tx_fs = tx_fs;
+
+	return 0;
+
+err_drop_counter:
+	mlx5_fc_destroy(mdev, tx_fs->check_rule_counter);
+	tx_fs->check_rule_counter = NULL;
+
+err_encrypt_counter:
+	kfree(tx_fs);
+	macsec_fs->tx_fs = NULL;
+
+	return err;
+}
+
+struct mlx5e_macsec_tx_rule *
+mlx5e_macsec_fs_add_rule(struct mlx5e_macsec_fs *macsec_fs,
+			 const struct macsec_context *macsec_ctx,
+			 struct mlx5_macsec_rule_attrs *attrs)
+{
+	if (attrs->action == MLX5_ACCEL_MACSEC_ACTION_ENCRYPT)
+		return macsec_fs_tx_add_rule(macsec_fs, macsec_ctx, attrs);
+
+	return NULL;
+}
+
+void mlx5e_macsec_fs_del_rule(struct mlx5e_macsec_fs *macsec_fs,
+			      struct mlx5e_macsec_tx_rule *tx_rule,
+			      int action)
+{
+	if (action == MLX5_ACCEL_MACSEC_ACTION_ENCRYPT)
+		macsec_fs_tx_del_rule(macsec_fs, tx_rule);
+}
+
+void mlx5e_macsec_fs_cleanup(struct mlx5e_macsec_fs *macsec_fs)
+{
+	macsec_fs_tx_cleanup(macsec_fs);
+	kfree(macsec_fs);
+}
+
+struct mlx5e_macsec_fs *
+mlx5e_macsec_fs_init(struct mlx5_core_dev *mdev,
+		     struct net_device *netdev)
+{
+	struct mlx5e_macsec_fs *macsec_fs;
+	int err;
+
+	macsec_fs = kzalloc(sizeof(*macsec_fs), GFP_KERNEL);
+	if (!macsec_fs)
+		return NULL;
+
+	macsec_fs->mdev = mdev;
+	macsec_fs->netdev = netdev;
+
+	err = macsec_fs_tx_init(macsec_fs);
+	if (err) {
+		netdev_err(netdev, "MACsec offload: Failed to init tx_fs, err=%d\n", err);
+		goto err;
+	}
+
+	return macsec_fs;
+
+err:
+	kfree(macsec_fs);
+	return NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h
new file mode 100644
index 000000000000..b31137ecc986
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_MACSEC_STEERING_H__
+#define __MLX5_MACSEC_STEERING_H__
+
+#ifdef CONFIG_MLX5_EN_MACSEC
+
+#include "en_accel/macsec.h"
+
+#define MLX5_MACSEC_NUM_OF_SUPPORTED_INTERFACES 16
+
+struct mlx5e_macsec_fs;
+struct mlx5e_macsec_tx_rule;
+
+struct mlx5_macsec_rule_attrs {
+	u32 macsec_obj_id;
+	int action;
+};
+
+enum mlx5_macsec_action {
+	MLX5_ACCEL_MACSEC_ACTION_ENCRYPT,
+};
+
+void mlx5e_macsec_fs_cleanup(struct mlx5e_macsec_fs *macsec_fs);
+
+struct mlx5e_macsec_fs *
+mlx5e_macsec_fs_init(struct mlx5_core_dev *mdev, struct net_device *netdev);
+
+struct mlx5e_macsec_tx_rule *
+mlx5e_macsec_fs_add_rule(struct mlx5e_macsec_fs *macsec_fs,
+			 const struct macsec_context *ctx,
+			 struct mlx5_macsec_rule_attrs *attrs);
+
+void mlx5e_macsec_fs_del_rule(struct mlx5e_macsec_fs *macsec_fs,
+			      struct mlx5e_macsec_tx_rule *macsec_rule,
+			      int action);
+
+#endif
+
+#endif /* __MLX5_MACSEC_STEERING_H__ */
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 8bda3ba5b109..be640c749d5e 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -252,6 +252,7 @@ enum {
 
 enum {
 	MLX5_ETH_WQE_FT_META_IPSEC = BIT(0),
+	MLX5_ETH_WQE_FT_META_MACSEC = BIT(1),
 };
 
 struct mlx5_wqe_eth_seg {
-- 
2.37.2

