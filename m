Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3949D59D0DA
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbiHWF4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240378AbiHWFz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B32D5F218
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1FD56146F
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0EAC433D7;
        Tue, 23 Aug 2022 05:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234152;
        bh=93W8HkXeQZr8oT05ls5NCBRWW2l8IP6TfvTsIPqkB1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzJGsKQ1zEqvxDxHrLeB7WlxMS3Ug/W1J0oe3YRbgE2Y9KV692G+k74HlN4CF/Dcu
         jnJl7KGcEyo2VjfclQ6y1AxzaLuN1atjHspuGiV3pJEw83bh58p+OsyYL/w8MUVO1a
         OL1QeW0VEoMjTX0bM9VTrTnYFiM55KcHKuEZcZt5qokRvn0KLxqKMc0ju0oPyMTBlZ
         k49SNC0DVBiQLh8Ca44aMdv7HaBLkMktkt5QyL6Z4yKSymmP+OQPImdJMJQpXAHQwL
         +MPV8xSY5ZaakLGgQW/mJSb5p8ecSZAvNC0iK/zb/sOH3fq5dW5/8raPs5opWZmD7H
         FWRdMpFOeYTGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Make flow steering arfs independent of priv
Date:   Mon, 22 Aug 2022 22:55:27 -0700
Message-Id: <20220823055533.334471-10-saeed@kernel.org>
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

Decouple arfs flow steering functionality from priv.
Make all arfs functions defined under fs.h get flow_steering
struct as an argument, thus helping with the process of decoupling the
whole flow steering API from en.h.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   | 22 +++--
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c | 87 ++++++++++---------
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  9 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 10 ++-
 6 files changed, 74 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 66f71813702e..389f389b814b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -90,22 +90,28 @@ enum {
 };
 
 struct mlx5e_flow_steering;
+struct mlx5e_rx_res;
 struct mlx5e_priv;
 
 #ifdef CONFIG_MLX5_EN_ARFS
 struct mlx5e_arfs_tables;
 
-int mlx5e_arfs_create_tables(struct mlx5e_priv *priv);
-void mlx5e_arfs_destroy_tables(struct mlx5e_priv *priv);
-int mlx5e_arfs_enable(struct mlx5e_priv *priv);
-int mlx5e_arfs_disable(struct mlx5e_priv *priv);
+int mlx5e_arfs_create_tables(struct mlx5e_flow_steering *fs,
+			     struct mlx5e_rx_res *rx_res, bool ntuple);
+void mlx5e_arfs_destroy_tables(struct mlx5e_flow_steering *fs, bool ntuple);
+int mlx5e_arfs_enable(struct mlx5e_flow_steering *fs);
+int mlx5e_arfs_disable(struct mlx5e_flow_steering *fs);
 int mlx5e_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 			u16 rxq_index, u32 flow_id);
 #else
-static inline int mlx5e_arfs_create_tables(struct mlx5e_priv *priv) { return 0; }
-static inline void mlx5e_arfs_destroy_tables(struct mlx5e_priv *priv) {}
-static inline int mlx5e_arfs_enable(struct mlx5e_priv *priv) { return -EOPNOTSUPP; }
-static inline int mlx5e_arfs_disable(struct mlx5e_priv *priv) {	return -EOPNOTSUPP; }
+static inline int mlx5e_arfs_create_tables(struct mlx5e_flow_steering *fs,
+					   struct mlx5e_rx_res *rx_res, bool ntuple)
+{ return 0; }
+static inline void mlx5e_arfs_destroy_tables(struct mlx5e_flow_steering *fs, bool ntuple) {}
+static inline int mlx5e_arfs_enable(struct mlx5e_flow_steering *fs)
+{ return -EOPNOTSUPP; }
+static inline int mlx5e_arfs_disable(struct mlx5e_flow_steering *fs)
+{ return -EOPNOTSUPP; }
 #endif
 
 #ifdef CONFIG_MLX5_EN_TLS
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index bf233cf3f6f3..0ae1865086ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -114,37 +114,37 @@ static enum mlx5_traffic_types arfs_get_tt(enum arfs_type type)
 	}
 }
 
-static int arfs_disable(struct mlx5e_priv *priv)
+static int arfs_disable(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
 	int err, i;
 
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		/* Modify ttc rules destination back to their default */
 		err = mlx5_ttc_fwd_default_dest(ttc, arfs_get_tt(i));
 		if (err) {
-			netdev_err(priv->netdev,
-				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
-				   __func__, arfs_get_tt(i), err);
+			fs_err(fs,
+			       "%s: modify ttc[%d] default destination failed, err(%d)\n",
+			       __func__, arfs_get_tt(i), err);
 			return err;
 		}
 	}
 	return 0;
 }
 
-static void arfs_del_rules(struct mlx5e_priv *priv);
+static void arfs_del_rules(struct mlx5e_flow_steering *fs);
 
-int mlx5e_arfs_disable(struct mlx5e_priv *priv)
+int mlx5e_arfs_disable(struct mlx5e_flow_steering *fs)
 {
-	arfs_del_rules(priv);
+	arfs_del_rules(fs);
 
-	return arfs_disable(priv);
+	return arfs_disable(fs);
 }
 
-int mlx5e_arfs_enable(struct mlx5e_priv *priv)
+int mlx5e_arfs_enable(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
-	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(fs);
 	struct mlx5_flow_destination dest = {};
 	int err, i;
 
@@ -154,10 +154,9 @@ int mlx5e_arfs_enable(struct mlx5e_priv *priv)
 		/* Modify ttc rules destination to point on the aRFS FTs */
 		err = mlx5_ttc_fwd_dest(ttc, arfs_get_tt(i), &dest);
 		if (err) {
-			netdev_err(priv->netdev,
-				   "%s: modify ttc[%d] dest to arfs, failed err(%d)\n",
-				   __func__, arfs_get_tt(i), err);
-			arfs_disable(priv);
+			fs_err(fs, "%s: modify ttc[%d] dest to arfs, failed err(%d)\n",
+			       __func__, arfs_get_tt(i), err);
+			arfs_disable(fs);
 			return err;
 		}
 	}
@@ -170,12 +169,12 @@ static void arfs_destroy_table(struct arfs_table *arfs_t)
 	mlx5e_destroy_flow_table(&arfs_t->ft);
 }
 
-static void _mlx5e_cleanup_tables(struct mlx5e_priv *priv)
+static void _mlx5e_cleanup_tables(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(fs);
 	int i;
 
-	arfs_del_rules(priv);
+	arfs_del_rules(fs);
 	destroy_workqueue(arfs->wq);
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		if (!IS_ERR_OR_NULL(arfs->arfs_tables[i].ft.t))
@@ -183,21 +182,23 @@ static void _mlx5e_cleanup_tables(struct mlx5e_priv *priv)
 	}
 }
 
-void mlx5e_arfs_destroy_tables(struct mlx5e_priv *priv)
+void mlx5e_arfs_destroy_tables(struct mlx5e_flow_steering *fs, bool ntuple)
 {
-	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
-	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(fs);
+
+	if (!ntuple)
 		return;
 
-	_mlx5e_cleanup_tables(priv);
-	mlx5e_fs_set_arfs(priv->fs, NULL);
+	_mlx5e_cleanup_tables(fs);
+	mlx5e_fs_set_arfs(fs, NULL);
 	kvfree(arfs);
 }
 
-static int arfs_add_default_rule(struct mlx5e_priv *priv,
+static int arfs_add_default_rule(struct mlx5e_flow_steering *fs,
+				 struct mlx5e_rx_res *rx_res,
 				 enum arfs_type type)
 {
-	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(fs);
 	struct arfs_table *arfs_t = &arfs->arfs_tables[type];
 	struct mlx5_flow_destination dest = {};
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -207,23 +208,21 @@ static int arfs_add_default_rule(struct mlx5e_priv *priv,
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 	tt = arfs_get_tt(type);
 	if (tt == -EINVAL) {
-		netdev_err(priv->netdev, "%s: bad arfs_type: %d\n",
-			   __func__, type);
+		fs_err(fs, "%s: bad arfs_type: %d\n", __func__, type);
 		return -EINVAL;
 	}
 
 	/* FIXME: Must use mlx5_ttc_get_default_dest(),
 	 * but can't since TTC default is not setup yet !
 	 */
-	dest.tir_num = mlx5e_rx_res_get_tirn_rss(priv->rx_res, tt);
+	dest.tir_num = mlx5e_rx_res_get_tirn_rss(rx_res, tt);
 	arfs_t->default_rule = mlx5_add_flow_rules(arfs_t->ft.t, NULL,
 						   &flow_act,
 						   &dest, 1);
 	if (IS_ERR(arfs_t->default_rule)) {
 		err = PTR_ERR(arfs_t->default_rule);
 		arfs_t->default_rule = NULL;
-		netdev_err(priv->netdev, "%s: add rule failed, arfs type=%d\n",
-			   __func__, type);
+		fs_err(fs, "%s: add rule failed, arfs type=%d\n", __func__, type);
 	}
 
 	return err;
@@ -325,11 +324,12 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 	return err;
 }
 
-static int arfs_create_table(struct mlx5e_priv *priv,
+static int arfs_create_table(struct mlx5e_flow_steering *fs,
+			     struct mlx5e_rx_res *rx_res,
 			     enum arfs_type type)
 {
-	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
-	struct mlx5e_arfs_tables *arfs = mlx5e_fs_get_arfs(priv->fs);
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(fs, false);
+	struct mlx5e_arfs_tables *arfs = mlx5e_fs_get_arfs(fs);
 	struct mlx5e_flow_table *ft = &arfs->arfs_tables[type].ft;
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
@@ -351,7 +351,7 @@ static int arfs_create_table(struct mlx5e_priv *priv,
 	if (err)
 		goto err;
 
-	err = arfs_add_default_rule(priv, type);
+	err = arfs_add_default_rule(fs, rx_res,  type);
 	if (err)
 		goto err;
 
@@ -361,13 +361,14 @@ static int arfs_create_table(struct mlx5e_priv *priv,
 	return err;
 }
 
-int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
+int mlx5e_arfs_create_tables(struct mlx5e_flow_steering *fs,
+			     struct mlx5e_rx_res *rx_res, bool ntuple)
 {
 	struct mlx5e_arfs_tables *arfs;
 	int err = -ENOMEM;
 	int i;
 
-	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
+	if (!ntuple)
 		return 0;
 
 	arfs = kvzalloc(sizeof(*arfs), GFP_KERNEL);
@@ -380,19 +381,19 @@ int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 	if (!arfs->wq)
 		goto err;
 
-	mlx5e_fs_set_arfs(priv->fs, arfs);
+	mlx5e_fs_set_arfs(fs, arfs);
 
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
-		err = arfs_create_table(priv, i);
+		err = arfs_create_table(fs, rx_res, i);
 		if (err)
 			goto err_des;
 	}
 	return 0;
 
 err_des:
-	_mlx5e_cleanup_tables(priv);
+	_mlx5e_cleanup_tables(fs);
 err:
-	mlx5e_fs_set_arfs(priv->fs, NULL);
+	mlx5e_fs_set_arfs(fs, NULL);
 	kvfree(arfs);
 	return err;
 }
@@ -430,9 +431,9 @@ static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 	}
 }
 
-static void arfs_del_rules(struct mlx5e_priv *priv)
+static void arfs_del_rules(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_arfs_tables *arfs = mlx5e_fs_get_arfs(priv->fs);
+	struct mlx5e_arfs_tables *arfs = mlx5e_fs_get_arfs(fs);
 	struct hlist_node *htmp;
 	struct arfs_rule *rule;
 	HLIST_HEAD(del_list);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 551468dbc93f..e5befe5d34b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -495,14 +495,14 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	arfs_enabled = opened && (priv->netdev->features & NETIF_F_NTUPLE);
 	if (arfs_enabled)
-		mlx5e_arfs_disable(priv);
+		mlx5e_arfs_disable(priv->fs);
 
 	/* Switch to new channels, set new parameters and close old ones */
 	err = mlx5e_safe_switch_params(priv, &new_params,
 				       mlx5e_num_channels_changed_ctx, NULL, true);
 
 	if (arfs_enabled) {
-		int err2 = mlx5e_arfs_enable(priv);
+		int err2 = mlx5e_arfs_enable(priv->fs);
 
 		if (err2)
 			netdev_err(priv->netdev, "%s: mlx5e_arfs_enable failed: %d\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 734faf7e821d..1c7842dd0462 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1303,7 +1303,8 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 		return -EOPNOTSUPP;
 
 	mlx5e_fs_set_ns(priv->fs, ns, false);
-	err = mlx5e_arfs_create_tables(priv);
+	err = mlx5e_arfs_create_tables(priv->fs, priv->rx_res,
+				       !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
 	if (err) {
 		fs_err(fs, "Failed to create arfs tables, err=%d\n", err);
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
@@ -1350,7 +1351,8 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 err_destroy_inner_ttc_table:
 	mlx5e_destroy_inner_ttc_table(priv);
 err_destroy_arfs_tables:
-	mlx5e_arfs_destroy_tables(priv);
+	mlx5e_arfs_destroy_tables(priv->fs,
+				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
 
 	return err;
 }
@@ -1362,7 +1364,8 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_destroy_l2_table(priv);
 	mlx5e_destroy_ttc_table(priv);
 	mlx5e_destroy_inner_ttc_table(priv);
-	mlx5e_arfs_destroy_tables(priv);
+	mlx5e_arfs_destroy_tables(priv->fs,
+				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
 	mlx5e_ethtool_cleanup_steering(priv->fs);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0c1ead96f591..f334cbcd003d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3824,9 +3824,9 @@ static int set_feature_arfs(struct net_device *netdev, bool enable)
 	int err;
 
 	if (enable)
-		err = mlx5e_arfs_enable(priv);
+		err = mlx5e_arfs_enable(priv->fs);
 	else
-		err = mlx5e_arfs_disable(priv);
+		err = mlx5e_arfs_disable(priv->fs);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 6a95566bf149..c3149e391f10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -330,8 +330,8 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 		return -EINVAL;
 
 	mlx5e_fs_set_ns(priv->fs, ns, false);
-
-	err = mlx5e_arfs_create_tables(priv);
+	err = mlx5e_arfs_create_tables(priv->fs, priv->rx_res,
+				       !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
 			   err);
@@ -350,7 +350,8 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	return 0;
 
 err_destroy_arfs_tables:
-	mlx5e_arfs_destroy_tables(priv);
+	mlx5e_arfs_destroy_tables(priv->fs,
+				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
 
 	return err;
 }
@@ -358,7 +359,8 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
 	mlx5e_destroy_ttc_table(priv);
-	mlx5e_arfs_destroy_tables(priv);
+	mlx5e_arfs_destroy_tables(priv->fs,
+				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
 	mlx5e_ethtool_cleanup_steering(priv->fs);
 }
 
-- 
2.37.1

