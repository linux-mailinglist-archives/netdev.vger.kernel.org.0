Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3312E4FACCE
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiDJIbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbiDJIbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0A662E6;
        Sun, 10 Apr 2022 01:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F024060EDB;
        Sun, 10 Apr 2022 08:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC607C385A4;
        Sun, 10 Apr 2022 08:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579364;
        bh=Xy917R2G9hCXQTLEuFXIKXOUKRhEJ63SBEz5vpwTty8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoXIZOm+hQg0Gf/6h/wt4gamYugoZ6kZJFYFsT5BEI+XKyD7SLYo15v9Y0UW2Ly/4
         EptaJCwO13xsWl9OVHQUyfN00yp9mrt1x7BMPwO4t/KXh4DFhQP/U+XX56FVKC+Vfl
         fbLKVkySQMBMo9jE7XP79moc6EkrqgEQCCm+LuoVccJdme69hJSSx9Pa3FcFnq2jon
         ri+dahSySsi9SKI3nTHBBMb0yExH9a+vODfatcXm437AsV2cRYKCaGrCgOzAjZ0nvb
         DxW136hJm9teZMdYL/1SRCPQbChyjzvZIBzXYh+z9+oHBHmjMSF8Bh+K4Rd7jsWmU/
         0+8KCf2VcT0/Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 11/17] net/mlx5: Make sure that no dangling IPsec FS pointers exist
Date:   Sun, 10 Apr 2022 11:28:29 +0300
Message-Id: <b34d88b5e12d1d332c47688fce60f8292e7b7d62.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

The IPsec FS code was implemented with anti-pattern there failures
in create functions left the system with dangling pointers that were
cleaned in global routines.

The less error prone approach is to make sure that failed function
cleans everything internally.

As part of this change, we remove the batch of one liners and rewrite
get/put functions to remove ambiguity.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 229 ++++++------------
 1 file changed, 73 insertions(+), 156 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 3e8972bab085..2975788292ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -60,7 +60,7 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_flow_handle *fte;
 	struct mlx5_flow_spec *spec;
-	int err = 0;
+	int err;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
@@ -96,101 +96,27 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 		goto out;
 	}
 
+	kvfree(spec);
 	rx_err->rule = fte;
 	rx_err->copy_modify_hdr = modify_hdr;
+	return 0;
 
 out:
-	if (err)
-		mlx5_modify_header_dealloc(mdev, modify_hdr);
+	mlx5_modify_header_dealloc(mdev, modify_hdr);
 out_spec:
 	kvfree(spec);
 	return err;
 }
 
-static void rx_err_del_rule(struct mlx5e_priv *priv,
-			    struct mlx5e_ipsec_rx_err *rx_err)
-{
-	if (rx_err->rule) {
-		mlx5_del_flow_rules(rx_err->rule);
-		rx_err->rule = NULL;
-	}
-
-	if (rx_err->copy_modify_hdr) {
-		mlx5_modify_header_dealloc(priv->mdev, rx_err->copy_modify_hdr);
-		rx_err->copy_modify_hdr = NULL;
-	}
-}
-
-static void rx_err_destroy_ft(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx_err *rx_err)
-{
-	rx_err_del_rule(priv, rx_err);
-
-	if (rx_err->ft) {
-		mlx5_destroy_flow_table(rx_err->ft);
-		rx_err->ft = NULL;
-	}
-}
-
-static int rx_err_create_ft(struct mlx5e_priv *priv,
-			    struct mlx5e_accel_fs_esp_prot *fs_prot,
-			    struct mlx5e_ipsec_rx_err *rx_err)
-{
-	struct mlx5_flow_table_attr ft_attr = {};
-	struct mlx5_flow_table *ft;
-	int err;
-
-	ft_attr.max_fte = 1;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
-	if (IS_ERR(ft)) {
-		err = PTR_ERR(ft);
-		netdev_err(priv->netdev, "fail to create ipsec rx inline ft err=%d\n", err);
-		return err;
-	}
-
-	rx_err->ft = ft;
-	err = rx_err_add_rule(priv, fs_prot, rx_err);
-	if (err)
-		goto out_err;
-
-	return 0;
-
-out_err:
-	mlx5_destroy_flow_table(ft);
-	rx_err->ft = NULL;
-	return err;
-}
-
-static void rx_fs_destroy(struct mlx5e_accel_fs_esp_prot *fs_prot)
-{
-	if (fs_prot->miss_rule) {
-		mlx5_del_flow_rules(fs_prot->miss_rule);
-		fs_prot->miss_rule = NULL;
-	}
-
-	if (fs_prot->miss_group) {
-		mlx5_destroy_flow_group(fs_prot->miss_group);
-		fs_prot->miss_group = NULL;
-	}
-
-	if (fs_prot->ft) {
-		mlx5_destroy_flow_table(fs_prot->ft);
-		fs_prot->ft = NULL;
-	}
-}
-
 static int rx_fs_create(struct mlx5e_priv *priv,
 			struct mlx5e_accel_fs_esp_prot *fs_prot)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_table *ft = fs_prot->ft;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_spec *spec;
-	struct mlx5_flow_table *ft;
 	u32 *flow_group_in;
 	int err = 0;
 
@@ -201,20 +127,6 @@ static int rx_fs_create(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	/* Create FT */
-	ft_attr.max_fte = NUM_IPSEC_FTE;
-	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft_attr.autogroup.num_reserved_entries = 1;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
-	if (IS_ERR(ft)) {
-		err = PTR_ERR(ft);
-		netdev_err(priv->netdev, "fail to create ipsec rx ft err=%d\n", err);
-		goto out;
-	}
-	fs_prot->ft = ft;
-
 	/* Create miss_group */
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ft->max_fte - 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ft->max_fte - 1);
@@ -229,19 +141,19 @@ static int rx_fs_create(struct mlx5e_priv *priv,
 	/* Create miss rule */
 	miss_rule = mlx5_add_flow_rules(ft, spec, &flow_act, &fs_prot->default_dest, 1);
 	if (IS_ERR(miss_rule)) {
+		mlx5_destroy_flow_group(fs_prot->miss_group);
 		err = PTR_ERR(miss_rule);
 		netdev_err(priv->netdev, "fail to create ipsec rx miss_rule err=%d\n", err);
 		goto out;
 	}
 	fs_prot->miss_rule = miss_rule;
-
 out:
 	kvfree(flow_group_in);
 	kvfree(spec);
 	return err;
 }
 
-static int rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+static void rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
@@ -251,17 +163,21 @@ static int rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	/* The netdev unreg already happened, so all offloaded rule are already removed */
 	fs_prot = &accel_esp->fs_prot[type];
 
-	rx_fs_destroy(fs_prot);
-
-	rx_err_destroy_ft(priv, &fs_prot->rx_err);
+	mlx5_del_flow_rules(fs_prot->miss_rule);
+	mlx5_destroy_flow_group(fs_prot->miss_group);
+	mlx5_destroy_flow_table(fs_prot->ft);
 
-	return 0;
+	mlx5_del_flow_rules(fs_prot->rx_err.rule);
+	mlx5_modify_header_dealloc(priv->mdev, fs_prot->rx_err.copy_modify_hdr);
+	mlx5_destroy_flow_table(fs_prot->rx_err.ft);
 }
 
 static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 {
+	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
+	struct mlx5_flow_table *ft;
 	int err;
 
 	accel_esp = priv->ipsec->rx_fs;
@@ -270,14 +186,45 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	fs_prot->default_dest =
 		mlx5_ttc_get_default_dest(priv->fs.ttc, fs_esp2tt(type));
 
-	err = rx_err_create_ft(priv, fs_prot, &fs_prot->rx_err);
+	ft_attr.max_fte = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
+
+	fs_prot->rx_err.ft = ft;
+	err = rx_err_add_rule(priv, fs_prot, &fs_prot->rx_err);
 	if (err)
-		return err;
+		goto err_add;
+
+	/* Create FT */
+	ft_attr.max_fte = NUM_IPSEC_FTE;
+	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+	ft_attr.autogroup.num_reserved_entries = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_fs_ft;
+	}
+	fs_prot->ft = ft;
 
 	err = rx_fs_create(priv, fs_prot);
 	if (err)
-		rx_destroy(priv, type);
+		goto err_fs;
+
+	return 0;
 
+err_fs:
+	mlx5_destroy_flow_table(fs_prot->ft);
+err_fs_ft:
+	mlx5_del_flow_rules(fs_prot->rx_err.rule);
+	mlx5_modify_header_dealloc(priv->mdev, fs_prot->rx_err.copy_modify_hdr);
+err_add:
+	mlx5_destroy_flow_table(fs_prot->rx_err.ft);
 	return err;
 }
 
@@ -291,21 +238,21 @@ static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	accel_esp = priv->ipsec->rx_fs;
 	fs_prot = &accel_esp->fs_prot[type];
 	mutex_lock(&fs_prot->prot_mutex);
-	if (fs_prot->refcnt++)
-		goto out;
+	if (fs_prot->refcnt)
+		goto skip;
 
 	/* create FT */
 	err = rx_create(priv, type);
-	if (err) {
-		fs_prot->refcnt--;
+	if (err)
 		goto out;
-	}
 
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = fs_prot->ft;
 	mlx5_ttc_fwd_dest(priv->fs.ttc, fs_esp2tt(type), &dest);
 
+skip:
+	fs_prot->refcnt++;
 out:
 	mutex_unlock(&fs_prot->prot_mutex);
 	return err;
@@ -319,7 +266,8 @@ static void rx_ft_put(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	accel_esp = priv->ipsec->rx_fs;
 	fs_prot = &accel_esp->fs_prot[type];
 	mutex_lock(&fs_prot->prot_mutex);
-	if (--fs_prot->refcnt)
+	fs_prot->refcnt--;
+	if (fs_prot->refcnt)
 		goto out;
 
 	/* disconnect */
@@ -352,32 +300,20 @@ static int tx_create(struct mlx5e_priv *priv)
 	return 0;
 }
 
-static void tx_destroy(struct mlx5e_priv *priv)
-{
-	struct mlx5e_ipsec *ipsec = priv->ipsec;
-
-	if (IS_ERR_OR_NULL(ipsec->tx_fs->ft))
-		return;
-
-	mlx5_destroy_flow_table(ipsec->tx_fs->ft);
-	ipsec->tx_fs->ft = NULL;
-}
-
 static int tx_ft_get(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ipsec_tx *tx_fs = priv->ipsec->tx_fs;
 	int err = 0;
 
 	mutex_lock(&tx_fs->mutex);
-	if (tx_fs->refcnt++)
-		goto out;
+	if (tx_fs->refcnt)
+		goto skip;
 
 	err = tx_create(priv);
-	if (err) {
-		tx_fs->refcnt--;
+	if (err)
 		goto out;
-	}
-
+skip:
+	tx_fs->refcnt++;
 out:
 	mutex_unlock(&tx_fs->mutex);
 	return err;
@@ -388,11 +324,11 @@ static void tx_ft_put(struct mlx5e_priv *priv)
 	struct mlx5e_ipsec_tx *tx_fs = priv->ipsec->tx_fs;
 
 	mutex_lock(&tx_fs->mutex);
-	if (--tx_fs->refcnt)
+	tx_fs->refcnt--;
+	if (tx_fs->refcnt)
 		goto out;
 
-	tx_destroy(priv);
-
+	mlx5_destroy_flow_table(tx_fs->ft);
 out:
 	mutex_unlock(&tx_fs->mutex);
 }
@@ -579,32 +515,6 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 	return err;
 }
 
-static void rx_del_rule(struct mlx5e_priv *priv,
-			struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
-
-	mlx5_del_flow_rules(ipsec_rule->rule);
-	ipsec_rule->rule = NULL;
-
-	mlx5_modify_header_dealloc(priv->mdev, ipsec_rule->set_modify_hdr);
-	ipsec_rule->set_modify_hdr = NULL;
-
-	rx_ft_put(priv,
-		  sa_entry->attrs.is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
-}
-
-static void tx_del_rule(struct mlx5e_priv *priv,
-			struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
-
-	mlx5_del_flow_rules(ipsec_rule->rule);
-	ipsec_rule->rule = NULL;
-
-	tx_ft_put(priv);
-}
-
 int mlx5e_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 			    struct mlx5e_ipsec_sa_entry *sa_entry)
 {
@@ -617,12 +527,19 @@ int mlx5e_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 void mlx5e_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 			     struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+
+	mlx5_del_flow_rules(ipsec_rule->rule);
+
 	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT) {
-		tx_del_rule(priv, sa_entry);
+		tx_ft_put(priv);
 		return;
 	}
 
-	rx_del_rule(priv, sa_entry);
+	mlx5_modify_header_dealloc(mdev, ipsec_rule->set_modify_hdr);
+	rx_ft_put(priv,
+		  sa_entry->attrs.is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
 }
 
 void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
-- 
2.35.1

