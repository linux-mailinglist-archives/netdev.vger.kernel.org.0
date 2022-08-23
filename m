Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED6759D0DF
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240410AbiHWFzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240339AbiHWFzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AA15F202
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D444B81B7A
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7D9C433C1;
        Tue, 23 Aug 2022 05:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234146;
        bh=zWpv+idA+vNUYZyguWd6lgfivumtvTN8ctT+Zi5u01I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1pkUwwc14pBpXixV4SyoVfvs0MRUEkelm6UFD4nDOKwwuHCkBp/WFZn4U/IrBhGQ
         iTfRZFrPJ+NWMBKVcQXkecx5/bnT9yIOKrXsoBRBKne+TmYp6D3kUuELVz0Zu8XSnI
         vqvNHs0WJU4sBAFIPb1IaFudD071vzL7yLNk8Q2Q4Nvl1Jx5S1fSIO61ydiz/zZGBV
         4kwV6S1irdh0zAOpUQFoLiSkULJB5nAW0IHevGHBBLaZctDpO8YL6WdGy9wMwlbE/Y
         lHPtQvX1Fr8ihtfEucR62maaahhDenr1+YgMatOwOeYcvQKfWxopZQTE7XCPMW6//F
         UeEqTlN9E2Agg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Decouple fs_tt_redirect from en.h
Date:   Mon, 22 Aug 2022 22:55:20 -0700
Message-Id: <20220823055533.334471-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
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

From: Lama Kayal <lkayal@nvidia.com>

Make flow steering files fs_tt_redirect.c/h independent of en.h
such that it goes through the flow steering API only.

Make error reports be via mlx5_core API instead of netdev_err API, this
to ensure a safe decoupling from en.h, and prevent redundant argument
passing.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 -
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   5 +
 .../mellanox/mlx5/core/en/fs_tt_redirect.c    | 153 +++++++++---------
 .../mellanox/mlx5/core/en/fs_tt_redirect.h    |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  26 +--
 5 files changed, 103 insertions(+), 99 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a560df446bac..e464024481b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -856,11 +856,6 @@ enum {
 	MLX5E_STATE_XDP_ACTIVE,
 };
 
-enum {
-	MLX5E_TC_PRIO = 0,
-	MLX5E_NIC_PRIO
-};
-
 struct mlx5e_modify_sq_param {
 	int curr_state;
 	int next_state;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index c5ec9e01a6d2..ee999d79f6c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -16,6 +16,11 @@ enum {
 	MLX5E_TC_MISS_LEVEL,
 };
 
+enum {
+	MLX5E_TC_PRIO = 0,
+	MLX5E_NIC_PRIO
+};
+
 struct mlx5e_flow_table {
 	int num_groups;
 	struct mlx5_flow_table *t;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
index 4ed1bc32c967..db731019bb11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
 
-#include <linux/netdevice.h>
 #include "en/fs_tt_redirect.h"
 #include "fs_core.h"
+#include "mlx5_core.h"
 
 enum fs_udp_type {
 	FS_IPV4_UDP,
@@ -74,11 +74,11 @@ static void fs_udp_set_dport_flow(struct mlx5_flow_spec *spec, enum fs_udp_type
 }
 
 struct mlx5_flow_handle *
-mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
+mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_flow_steering *fs,
 				  enum mlx5_traffic_types ttc_type,
 				  u32 tir_num, u16 d_port)
 {
-	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(priv->fs);
+	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(fs);
 	enum fs_udp_type type = tt2fs_udp(ttc_type);
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_table *ft = NULL;
@@ -105,16 +105,16 @@ mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
 
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev, "%s: add %s rule failed, err %d\n",
-			   __func__, fs_udp_type2str(type), err);
+		mlx5_core_err(mlx5e_fs_get_mdev(fs), "%s: add %s rule failed, err %d\n",
+			      __func__, fs_udp_type2str(type), err);
 	}
 	return rule;
 }
 
-static int fs_udp_add_default_rule(struct mlx5e_priv *priv, enum fs_udp_type type)
+static int fs_udp_add_default_rule(struct mlx5e_flow_steering *fs, enum fs_udp_type type)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
-	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(priv->fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
+	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(fs);
 	struct mlx5e_flow_table *fs_udp_t;
 	struct mlx5_flow_destination dest;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -127,9 +127,9 @@ static int fs_udp_add_default_rule(struct mlx5e_priv *priv, enum fs_udp_type typ
 	rule = mlx5_add_flow_rules(fs_udp_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev,
-			   "%s: add default rule failed, fs type=%d, err %d\n",
-			   __func__, type, err);
+		mlx5_core_err(mlx5e_fs_get_mdev(fs),
+			      "%s: add default rule failed, fs type=%d, err %d\n",
+			      __func__, type, err);
 		return err;
 	}
 
@@ -205,14 +205,15 @@ static int fs_udp_create_groups(struct mlx5e_flow_table *ft, enum fs_udp_type ty
 	return err;
 }
 
-static int fs_udp_create_table(struct mlx5e_priv *priv, enum fs_udp_type type)
+static int fs_udp_create_table(struct mlx5e_flow_steering *fs, enum fs_udp_type type)
 {
-	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
-	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(priv->fs);
-	struct mlx5e_flow_table *ft = &fs_udp->tables[type];
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(fs, false);
+	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(fs);
 	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5e_flow_table *ft;
 	int err;
 
+	ft = &fs_udp->tables[type];
 	ft->num_groups = 0;
 
 	ft_attr.max_fte = MLX5E_FS_UDP_TABLE_SIZE;
@@ -226,14 +227,14 @@ static int fs_udp_create_table(struct mlx5e_priv *priv, enum fs_udp_type type)
 		return err;
 	}
 
-	netdev_dbg(priv->netdev, "Created fs %s table id %u level %u\n",
-		   fs_udp_type2str(type), ft->t->id, ft->t->level);
+	mlx5_core_dbg(mlx5e_fs_get_mdev(fs), "Created fs %s table id %u level %u\n",
+		      fs_udp_type2str(type), ft->t->id, ft->t->level);
 
 	err = fs_udp_create_groups(ft, type);
 	if (err)
 		goto err;
 
-	err = fs_udp_add_default_rule(priv, type);
+	err = fs_udp_add_default_rule(fs, type);
 	if (err)
 		goto err;
 
@@ -254,18 +255,18 @@ static void fs_udp_destroy_table(struct mlx5e_fs_udp *fs_udp, int i)
 	fs_udp->tables[i].t = NULL;
 }
 
-static int fs_udp_disable(struct mlx5e_priv *priv)
+static int fs_udp_disable(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
 	int err, i;
 
 	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
 		/* Modify ttc rules destination to point back to the indir TIRs */
 		err = mlx5_ttc_fwd_default_dest(ttc, fs_udp2tt(i));
 		if (err) {
-			netdev_err(priv->netdev,
-				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
-				   __func__, fs_udp2tt(i), err);
+			mlx5_core_err(mlx5e_fs_get_mdev(fs),
+				      "%s: modify ttc[%d] default destination failed, err(%d)\n",
+				      __func__, fs_udp2tt(i), err);
 			return err;
 		}
 	}
@@ -273,10 +274,10 @@ static int fs_udp_disable(struct mlx5e_priv *priv)
 	return 0;
 }
 
-static int fs_udp_enable(struct mlx5e_priv *priv)
+static int fs_udp_enable(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
-	struct mlx5e_fs_udp *udp = mlx5e_fs_get_udp(priv->fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
+	struct mlx5e_fs_udp *udp = mlx5e_fs_get_udp(fs);
 	struct mlx5_flow_destination dest = {};
 	int err, i;
 
@@ -287,18 +288,18 @@ static int fs_udp_enable(struct mlx5e_priv *priv)
 		/* Modify ttc rules destination to point on the accel_fs FTs */
 		err = mlx5_ttc_fwd_dest(ttc, fs_udp2tt(i), &dest);
 		if (err) {
-			netdev_err(priv->netdev,
-				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
-				   __func__, fs_udp2tt(i), err);
+			mlx5_core_err(mlx5e_fs_get_mdev(fs),
+				      "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+				      __func__, fs_udp2tt(i), err);
 			return err;
 		}
 	}
 	return 0;
 }
 
-void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_priv *priv)
+void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(priv->fs);
+	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(fs);
 	int i;
 
 	if (!fs_udp)
@@ -307,18 +308,18 @@ void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_priv *priv)
 	if (--fs_udp->ref_cnt)
 		return;
 
-	fs_udp_disable(priv);
+	fs_udp_disable(fs);
 
 	for (i = 0; i < FS_UDP_NUM_TYPES; i++)
 		fs_udp_destroy_table(fs_udp, i);
 
 	kfree(fs_udp);
-	mlx5e_fs_set_udp(priv->fs, NULL);
+	mlx5e_fs_set_udp(fs, NULL);
 }
 
-int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv)
+int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_fs_udp *udp = mlx5e_fs_get_udp(priv->fs);
+	struct mlx5e_fs_udp *udp = mlx5e_fs_get_udp(fs);
 	int i, err;
 
 	if (udp) {
@@ -329,15 +330,15 @@ int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv)
 	udp = kzalloc(sizeof(*udp), GFP_KERNEL);
 	if (!udp)
 		return -ENOMEM;
-	mlx5e_fs_set_udp(priv->fs, udp);
+	mlx5e_fs_set_udp(fs, udp);
 
 	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
-		err = fs_udp_create_table(priv, i);
+		err = fs_udp_create_table(fs, i);
 		if (err)
 			goto err_destroy_tables;
 	}
 
-	err = fs_udp_enable(priv);
+	err = fs_udp_enable(fs);
 	if (err)
 		goto err_destroy_tables;
 
@@ -350,7 +351,7 @@ int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv)
 		fs_udp_destroy_table(udp, i);
 
 	kfree(udp);
-	mlx5e_fs_set_udp(priv->fs, NULL);
+	mlx5e_fs_set_udp(fs, NULL);
 	return err;
 }
 
@@ -362,10 +363,10 @@ static void fs_any_set_ethertype_flow(struct mlx5_flow_spec *spec, u16 ether_typ
 }
 
 struct mlx5_flow_handle *
-mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_priv *priv,
+mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_flow_steering *fs,
 				  u32 tir_num, u16 ether_type)
 {
-	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(fs);
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_table *ft = NULL;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -388,16 +389,16 @@ mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_priv *priv,
 
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev, "%s: add ANY rule failed, err %d\n",
-			   __func__, err);
+		mlx5_core_err(mlx5e_fs_get_mdev(fs), "%s: add ANY rule failed, err %d\n",
+			      __func__, err);
 	}
 	return rule;
 }
 
-static int fs_any_add_default_rule(struct mlx5e_priv *priv)
+static int fs_any_add_default_rule(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
-	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(fs);
 	struct mlx5e_flow_table *fs_any_t;
 	struct mlx5_flow_destination dest;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -409,9 +410,9 @@ static int fs_any_add_default_rule(struct mlx5e_priv *priv)
 	rule = mlx5_add_flow_rules(fs_any_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev,
-			   "%s: add default rule failed, fs type=ANY, err %d\n",
-			   __func__, err);
+		mlx5_core_err(mlx5e_fs_get_mdev(fs),
+			      "%s: add default rule failed, fs type=ANY, err %d\n",
+			      __func__, err);
 		return err;
 	}
 
@@ -476,10 +477,10 @@ static int fs_any_create_groups(struct mlx5e_flow_table *ft)
 	return err;
 }
 
-static int fs_any_create_table(struct mlx5e_priv *priv)
+static int fs_any_create_table(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
-	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(fs, false);
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(fs);
 	struct mlx5e_flow_table *ft = &fs_any->table;
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
@@ -497,14 +498,14 @@ static int fs_any_create_table(struct mlx5e_priv *priv)
 		return err;
 	}
 
-	netdev_dbg(priv->netdev, "Created fs ANY table id %u level %u\n",
-		   ft->t->id, ft->t->level);
+	mlx5_core_dbg(mlx5e_fs_get_mdev(fs), "Created fs ANY table id %u level %u\n",
+		      ft->t->id, ft->t->level);
 
 	err = fs_any_create_groups(ft);
 	if (err)
 		goto err;
 
-	err = fs_any_add_default_rule(priv);
+	err = fs_any_add_default_rule(fs);
 	if (err)
 		goto err;
 
@@ -515,26 +516,26 @@ static int fs_any_create_table(struct mlx5e_priv *priv)
 	return err;
 }
 
-static int fs_any_disable(struct mlx5e_priv *priv)
+static int fs_any_disable(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
 	int err;
 
 	/* Modify ttc rules destination to point back to the indir TIRs */
 	err = mlx5_ttc_fwd_default_dest(ttc, MLX5_TT_ANY);
 	if (err) {
-		netdev_err(priv->netdev,
-			   "%s: modify ttc[%d] default destination failed, err(%d)\n",
-			   __func__, MLX5_TT_ANY, err);
+		mlx5_core_err(mlx5e_fs_get_mdev(fs),
+			      "%s: modify ttc[%d] default destination failed, err(%d)\n",
+			      __func__, MLX5_TT_ANY, err);
 		return err;
 	}
 	return 0;
 }
 
-static int fs_any_enable(struct mlx5e_priv *priv)
+static int fs_any_enable(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
-	struct mlx5e_fs_any *any = mlx5e_fs_get_any(priv->fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
+	struct mlx5e_fs_any *any = mlx5e_fs_get_any(fs);
 	struct mlx5_flow_destination dest = {};
 	int err;
 
@@ -544,9 +545,9 @@ static int fs_any_enable(struct mlx5e_priv *priv)
 	/* Modify ttc rules destination to point on the accel_fs FTs */
 	err = mlx5_ttc_fwd_dest(ttc, MLX5_TT_ANY, &dest);
 	if (err) {
-		netdev_err(priv->netdev,
-			   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
-			   __func__, MLX5_TT_ANY, err);
+		mlx5_core_err(mlx5e_fs_get_mdev(fs),
+			      "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+			      __func__, MLX5_TT_ANY, err);
 		return err;
 	}
 	return 0;
@@ -562,9 +563,9 @@ static void fs_any_destroy_table(struct mlx5e_fs_any *fs_any)
 	fs_any->table.t = NULL;
 }
 
-void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_priv *priv)
+void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(fs);
 
 	if (!fs_any)
 		return;
@@ -572,17 +573,17 @@ void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_priv *priv)
 	if (--fs_any->ref_cnt)
 		return;
 
-	fs_any_disable(priv);
+	fs_any_disable(fs);
 
 	fs_any_destroy_table(fs_any);
 
 	kfree(fs_any);
-	mlx5e_fs_set_any(priv->fs, NULL);
+	mlx5e_fs_set_any(fs, NULL);
 }
 
-int mlx5e_fs_tt_redirect_any_create(struct mlx5e_priv *priv)
+int mlx5e_fs_tt_redirect_any_create(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(fs);
 	int err;
 
 	if (fs_any) {
@@ -593,13 +594,13 @@ int mlx5e_fs_tt_redirect_any_create(struct mlx5e_priv *priv)
 	fs_any = kzalloc(sizeof(*fs_any), GFP_KERNEL);
 	if (!fs_any)
 		return -ENOMEM;
-	mlx5e_fs_set_any(priv->fs, fs_any);
+	mlx5e_fs_set_any(fs, fs_any);
 
-	err = fs_any_create_table(priv);
+	err = fs_any_create_table(fs);
 	if (err)
 		return err;
 
-	err = fs_any_enable(priv);
+	err = fs_any_enable(fs);
 	if (err)
 		goto err_destroy_table;
 
@@ -611,6 +612,6 @@ int mlx5e_fs_tt_redirect_any_create(struct mlx5e_priv *priv)
 	fs_any_destroy_table(fs_any);
 
 	kfree(fs_any);
-	mlx5e_fs_set_any(priv->fs, NULL);
+	mlx5e_fs_set_any(fs, NULL);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
index 7a70c4f38fda..5780fd7ad507 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
@@ -4,23 +4,22 @@
 #ifndef __MLX5E_FS_TT_REDIRECT_H__
 #define __MLX5E_FS_TT_REDIRECT_H__
 
-#include "en.h"
 #include "en/fs.h"
 
 void mlx5e_fs_tt_redirect_del_rule(struct mlx5_flow_handle *rule);
 
 /* UDP traffic type redirect */
 struct mlx5_flow_handle *
-mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
+mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_flow_steering *fs,
 				  enum mlx5_traffic_types ttc_type,
 				  u32 tir_num, u16 d_port);
-void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_priv *priv);
-int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv);
+void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_flow_steering *fs);
+int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_flow_steering *fs);
 
 /* ANY traffic type redirect*/
 struct mlx5_flow_handle *
-mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_priv *priv,
+mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_flow_steering *fs,
 				  u32 tir_num, u16 ether_type);
-void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_priv *priv);
-int mlx5e_fs_tt_redirect_any_create(struct mlx5e_priv *priv);
+void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_flow_steering *fs);
+int mlx5e_fs_tt_redirect_any_create(struct mlx5e_flow_steering *fs);
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 23f4ddc8ef88..3fdaacc2abde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -624,35 +624,39 @@ static int mlx5e_ptp_set_state(struct mlx5e_ptp *c, struct mlx5e_params *params)
 
 static void mlx5e_ptp_rx_unset_fs(struct mlx5e_priv *priv)
 {
-	struct mlx5e_ptp_fs *ptp_fs = mlx5e_fs_get_ptp(priv->fs);
+	struct mlx5e_flow_steering *fs = priv->fs;
+	struct mlx5e_ptp_fs *ptp_fs;
 
+	ptp_fs = mlx5e_fs_get_ptp(fs);
 	if (!ptp_fs->valid)
 		return;
 
 	mlx5e_fs_tt_redirect_del_rule(ptp_fs->l2_rule);
-	mlx5e_fs_tt_redirect_any_destroy(priv);
+	mlx5e_fs_tt_redirect_any_destroy(fs);
 
 	mlx5e_fs_tt_redirect_del_rule(ptp_fs->udp_v6_rule);
 	mlx5e_fs_tt_redirect_del_rule(ptp_fs->udp_v4_rule);
-	mlx5e_fs_tt_redirect_udp_destroy(priv);
+	mlx5e_fs_tt_redirect_udp_destroy(fs);
 	ptp_fs->valid = false;
 }
 
 static int mlx5e_ptp_rx_set_fs(struct mlx5e_priv *priv)
 {
-	struct mlx5e_ptp_fs *ptp_fs = mlx5e_fs_get_ptp(priv->fs);
 	u32 tirn = mlx5e_rx_res_get_tirn_ptp(priv->rx_res);
+	struct mlx5e_flow_steering *fs = priv->fs;
 	struct mlx5_flow_handle *rule;
+	struct mlx5e_ptp_fs *ptp_fs;
 	int err;
 
+	ptp_fs = mlx5e_fs_get_ptp(fs);
 	if (ptp_fs->valid)
 		return 0;
 
-	err = mlx5e_fs_tt_redirect_udp_create(priv);
+	err = mlx5e_fs_tt_redirect_udp_create(fs);
 	if (err)
 		goto out_free;
 
-	rule = mlx5e_fs_tt_redirect_udp_add_rule(priv, MLX5_TT_IPV4_UDP,
+	rule = mlx5e_fs_tt_redirect_udp_add_rule(fs, MLX5_TT_IPV4_UDP,
 						 tirn, PTP_EV_PORT);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -660,7 +664,7 @@ static int mlx5e_ptp_rx_set_fs(struct mlx5e_priv *priv)
 	}
 	ptp_fs->udp_v4_rule = rule;
 
-	rule = mlx5e_fs_tt_redirect_udp_add_rule(priv, MLX5_TT_IPV6_UDP,
+	rule = mlx5e_fs_tt_redirect_udp_add_rule(fs, MLX5_TT_IPV6_UDP,
 						 tirn, PTP_EV_PORT);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -668,11 +672,11 @@ static int mlx5e_ptp_rx_set_fs(struct mlx5e_priv *priv)
 	}
 	ptp_fs->udp_v6_rule = rule;
 
-	err = mlx5e_fs_tt_redirect_any_create(priv);
+	err = mlx5e_fs_tt_redirect_any_create(fs);
 	if (err)
 		goto out_destroy_udp_v6_rule;
 
-	rule = mlx5e_fs_tt_redirect_any_add_rule(priv, tirn, ETH_P_1588);
+	rule = mlx5e_fs_tt_redirect_any_add_rule(fs, tirn, ETH_P_1588);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		goto out_destroy_fs_any;
@@ -683,13 +687,13 @@ static int mlx5e_ptp_rx_set_fs(struct mlx5e_priv *priv)
 	return 0;
 
 out_destroy_fs_any:
-	mlx5e_fs_tt_redirect_any_destroy(priv);
+	mlx5e_fs_tt_redirect_any_destroy(fs);
 out_destroy_udp_v6_rule:
 	mlx5e_fs_tt_redirect_del_rule(ptp_fs->udp_v6_rule);
 out_destroy_udp_v4_rule:
 	mlx5e_fs_tt_redirect_del_rule(ptp_fs->udp_v4_rule);
 out_destroy_fs_udp:
-	mlx5e_fs_tt_redirect_udp_destroy(priv);
+	mlx5e_fs_tt_redirect_udp_destroy(fs);
 out_free:
 	return err;
 }
-- 
2.37.1

