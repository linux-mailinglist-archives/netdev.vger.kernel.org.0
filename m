Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9F559D0E5
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbiHWF4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240411AbiHWFzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6F65F210
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C81FB81B7F
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942D4C433C1;
        Tue, 23 Aug 2022 05:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234149;
        bh=Zqjo1r1MLsqGFgoZXeEJk25F4tU9V/l0tbvBYSic7qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S10fXXWnkzIxpyYWZx8XkeRiHGN3KIska9Ju3eBXmjs2Y//Uzhcs/Rwe093KFJrVK
         u/OX+4CtBBnq2qzYEttMs0LuTNEictYIce4VfshKTwAG3FCWfQi7xqmjrirgDy3x+q
         whFnz39St6Bm6wtHjKENck3bvJOAOrWbNiEaJ8KYqr3QMBdTykj4Ab5tyFnw6ut+3q
         lX9GEQpjGRrhDVzenPk+4Ci9FBEpi5nGa0QGqFVorzMJo7oSC1h/o3FNnZvrb1ZPME
         4QNaI5eQaM9kcmFzazC5zdchrLvd8nSD+Q7vNGOCxj850NguGaGQxNHtyLWCVBnXmR
         5BAVnPjBs8JRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Directly get flow_steering struct as input when init/cleanup ethtool steering
Date:   Mon, 22 Aug 2022 22:55:24 -0700
Message-Id: <20220823055533.334471-7-saeed@kernel.org>
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

Let both mlx5e_ethtool_init_steering and mlx5e_ethtool_cleanup_steering
get ethtool steering struct as input instead of priv, as passing priv is
obsolete.
Also modify other function through the flow similarly.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  8 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  4 ++--
 .../mellanox/mlx5/core/en_fs_ethtool.c        | 20 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  4 ++--
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  4 ++--
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index ee999d79f6c8..20ca670fc226 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -109,14 +109,14 @@ struct mlx5e_ethtool_steering {
 	int                             tot_num_rules;
 };
 
-void mlx5e_ethtool_init_steering(struct mlx5e_priv *priv);
-void mlx5e_ethtool_cleanup_steering(struct mlx5e_priv *priv);
+void mlx5e_ethtool_init_steering(struct mlx5e_flow_steering *fs);
+void mlx5e_ethtool_cleanup_steering(struct mlx5e_flow_steering *fs);
 int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd);
 int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
 			    struct ethtool_rxnfc *info, u32 *rule_locs);
 #else
-static inline void mlx5e_ethtool_init_steering(struct mlx5e_priv *priv)    { }
-static inline void mlx5e_ethtool_cleanup_steering(struct mlx5e_priv *priv) { }
+static inline void mlx5e_ethtool_init_steering(struct mlx5e_flow_steering *fs) { }
+static inline void mlx5e_ethtool_cleanup_steering(struct mlx5e_flow_steering *fs) { }
 static inline int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd)
 { return -EOPNOTSUPP; }
 static inline int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index eef674cf0f1d..dc73c0cfca6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1342,7 +1342,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destory_vlan_table;
 
-	mlx5e_ethtool_init_steering(priv);
+	mlx5e_ethtool_init_steering(priv->fs);
 
 	return 0;
 
@@ -1368,7 +1368,7 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_destroy_ttc_table(priv);
 	mlx5e_destroy_inner_ttc_table(priv);
 	mlx5e_arfs_destroy_tables(priv);
-	mlx5e_ethtool_cleanup_steering(priv);
+	mlx5e_ethtool_cleanup_steering(priv->fs);
 }
 
 static int mlx5e_fs_vlan_alloc(struct mlx5e_flow_steering *fs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 82c8262341bf..3abd3db72e07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -501,10 +501,10 @@ add_ethtool_flow_rule(struct mlx5e_priv *priv,
 	return err ? ERR_PTR(err) : rule;
 }
 
-static void del_ethtool_rule(struct mlx5e_priv *priv,
+static void del_ethtool_rule(struct mlx5e_flow_steering *fs,
 			     struct mlx5e_ethtool_rule *eth_rule)
 {
-	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(fs);
 	if (eth_rule->rule)
 		mlx5_del_flow_rules(eth_rule->rule);
 	if (eth_rule->rss)
@@ -535,7 +535,7 @@ static struct mlx5e_ethtool_rule *get_ethtool_rule(struct mlx5e_priv *priv,
 
 	eth_rule = find_ethtool_rule(priv, location);
 	if (eth_rule)
-		del_ethtool_rule(priv, eth_rule);
+		del_ethtool_rule(priv->fs, eth_rule);
 
 	eth_rule = kzalloc(sizeof(*eth_rule), GFP_KERNEL);
 	if (!eth_rule)
@@ -758,7 +758,7 @@ mlx5e_ethtool_flow_replace(struct mlx5e_priv *priv,
 	return 0;
 
 del_ethtool_rule:
-	del_ethtool_rule(priv, eth_rule);
+	del_ethtool_rule(priv->fs, eth_rule);
 
 	return err;
 }
@@ -778,7 +778,7 @@ mlx5e_ethtool_flow_remove(struct mlx5e_priv *priv, int location)
 		goto out;
 	}
 
-	del_ethtool_rule(priv, eth_rule);
+	del_ethtool_rule(priv->fs, eth_rule);
 out:
 	return err;
 }
@@ -831,19 +831,19 @@ mlx5e_ethtool_get_all_flows(struct mlx5e_priv *priv,
 	return err;
 }
 
-void mlx5e_ethtool_cleanup_steering(struct mlx5e_priv *priv)
+void mlx5e_ethtool_cleanup_steering(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(fs);
 	struct mlx5e_ethtool_rule *iter;
 	struct mlx5e_ethtool_rule *temp;
 
 	list_for_each_entry_safe(iter, temp, &ethtool->rules, list)
-		del_ethtool_rule(priv, iter);
+		del_ethtool_rule(fs, iter);
 }
 
-void mlx5e_ethtool_init_steering(struct mlx5e_priv *priv)
+void mlx5e_ethtool_init_steering(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(fs);
 
 	INIT_LIST_HEAD(&ethtool->rules);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 8ef4ad0a6ce9..a6b54adb377a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -886,7 +886,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_root_ft;
 
-	mlx5e_ethtool_init_steering(priv);
+	mlx5e_ethtool_init_steering(priv->fs);
 
 	return 0;
 
@@ -907,7 +907,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 {
-	mlx5e_ethtool_cleanup_steering(priv);
+	mlx5e_ethtool_cleanup_steering(priv->fs);
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
 	mlx5_destroy_ttc_table(mlx5e_fs_get_ttc(priv->fs, false));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 039a7be1eb0b..1ce5ab9270f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -344,7 +344,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 		goto err_destroy_arfs_tables;
 	}
 
-	mlx5e_ethtool_init_steering(priv);
+	mlx5e_ethtool_init_steering(priv->fs);
 
 	return 0;
 
@@ -358,7 +358,7 @@ static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
 	mlx5e_destroy_ttc_table(priv);
 	mlx5e_arfs_destroy_tables(priv);
-	mlx5e_ethtool_cleanup_steering(priv);
+	mlx5e_ethtool_cleanup_steering(priv->fs);
 }
 
 static int mlx5i_init_rx(struct mlx5e_priv *priv)
-- 
2.37.1

