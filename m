Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ABF353676
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhDDEUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236819AbhDDEUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA72B61380;
        Sun,  4 Apr 2021 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510013;
        bh=97PIXh/3mxh7XIOjh9y9zII69mqWCAY/LQmimfWVVDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSc2m/fQNIMeDedJ8BTwdvNL7c0O3WuNgQ/WOYqGxYWHvDHPyO/nwNq+XeU5c7o4/
         Hz8h2RncW/CmNvtJhqZQ1YemxiM345fswr/QtZEqdBWv+5EKZV8ldHTVUuIfNfxtKU
         P99qdXdHLRTIVIgvZ3Arr8yXj41U+Af193U4DkOILgYW/X9Ogzy9UtuoA+HcD+X4mq
         vx+F+UqBfyb0pvE3DIAjj3YJIMzgNpyLFixEj3XsAuY//WulDVY/K0Hv27wXlAxNDo
         hM+QnYYQexaSB2UKDUkjWi+S8F9oRkDTHFYytKTFO8/PDhzVSn/cSTxggLpFTQDnhD
         PakVTnisDcYcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5e: Dynamic alloc arfs table for netdev when needed
Date:   Sat,  3 Apr 2021 21:19:53 -0700
Message-Id: <20210404041954.146958-16-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@nvidia.com>

Dynamic allocate arfs table in mlx5e_priv for EN netdev
when needed. Don't allocate it for representor netdev.

Signed-off-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   | 28 +-----
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c | 95 +++++++++++++------
 2 files changed, 69 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index d53fb1e31b05..cbfe31fb2b12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -200,31 +200,7 @@ static inline int mlx5e_ethtool_get_rxnfc(struct net_device *dev,
 #endif /* CONFIG_MLX5_EN_RXNFC */
 
 #ifdef CONFIG_MLX5_EN_ARFS
-#define ARFS_HASH_SHIFT BITS_PER_BYTE
-#define ARFS_HASH_SIZE BIT(BITS_PER_BYTE)
-
-struct arfs_table {
-	struct mlx5e_flow_table  ft;
-	struct mlx5_flow_handle	 *default_rule;
-	struct hlist_head	 rules_hash[ARFS_HASH_SIZE];
-};
-
-enum  arfs_type {
-	ARFS_IPV4_TCP,
-	ARFS_IPV6_TCP,
-	ARFS_IPV4_UDP,
-	ARFS_IPV6_UDP,
-	ARFS_NUM_TYPES,
-};
-
-struct mlx5e_arfs_tables {
-	struct arfs_table arfs_tables[ARFS_NUM_TYPES];
-	/* Protect aRFS rules list */
-	spinlock_t                     arfs_lock;
-	struct list_head               rules;
-	int                            last_filter_id;
-	struct workqueue_struct        *wq;
-};
+struct mlx5e_arfs_tables;
 
 int mlx5e_arfs_create_tables(struct mlx5e_priv *priv);
 void mlx5e_arfs_destroy_tables(struct mlx5e_priv *priv);
@@ -260,7 +236,7 @@ struct mlx5e_flow_steering {
 	struct mlx5e_ttc_table          ttc;
 	struct mlx5e_ttc_table          inner_ttc;
 #ifdef CONFIG_MLX5_EN_ARFS
-	struct mlx5e_arfs_tables        arfs;
+	struct mlx5e_arfs_tables       *arfs;
 #endif
 #ifdef CONFIG_MLX5_EN_TLS
 	struct mlx5e_accel_fs_tcp      *accel_tcp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 39475f6565c7..d5b1eb74d5e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -36,6 +36,32 @@
 #include <linux/ipv6.h>
 #include "en.h"
 
+#define ARFS_HASH_SHIFT BITS_PER_BYTE
+#define ARFS_HASH_SIZE BIT(BITS_PER_BYTE)
+
+struct arfs_table {
+	struct mlx5e_flow_table  ft;
+	struct mlx5_flow_handle	 *default_rule;
+	struct hlist_head	 rules_hash[ARFS_HASH_SIZE];
+};
+
+enum arfs_type {
+	ARFS_IPV4_TCP,
+	ARFS_IPV6_TCP,
+	ARFS_IPV4_UDP,
+	ARFS_IPV6_UDP,
+	ARFS_NUM_TYPES,
+};
+
+struct mlx5e_arfs_tables {
+	struct arfs_table arfs_tables[ARFS_NUM_TYPES];
+	/* Protect aRFS rules list */
+	spinlock_t                     arfs_lock;
+	struct list_head               rules;
+	int                            last_filter_id;
+	struct workqueue_struct        *wq;
+};
+
 struct arfs_tuple {
 	__be16 etype;
 	u8     ip_proto;
@@ -121,7 +147,7 @@ int mlx5e_arfs_enable(struct mlx5e_priv *priv)
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
-		dest.ft = priv->fs.arfs.arfs_tables[i].ft.t;
+		dest.ft = priv->fs.arfs->arfs_tables[i].ft.t;
 		/* Modify ttc rules destination to point on the aRFS FTs */
 		err = mlx5e_ttc_fwd_dest(priv, arfs_get_tt(i), &dest);
 		if (err) {
@@ -141,25 +167,31 @@ static void arfs_destroy_table(struct arfs_table *arfs_t)
 	mlx5e_destroy_flow_table(&arfs_t->ft);
 }
 
-void mlx5e_arfs_destroy_tables(struct mlx5e_priv *priv)
+static void _mlx5e_cleanup_tables(struct mlx5e_priv *priv)
 {
 	int i;
 
-	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
-		return;
-
 	arfs_del_rules(priv);
-	destroy_workqueue(priv->fs.arfs.wq);
+	destroy_workqueue(priv->fs.arfs->wq);
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
-		if (!IS_ERR_OR_NULL(priv->fs.arfs.arfs_tables[i].ft.t))
-			arfs_destroy_table(&priv->fs.arfs.arfs_tables[i]);
+		if (!IS_ERR_OR_NULL(priv->fs.arfs->arfs_tables[i].ft.t))
+			arfs_destroy_table(&priv->fs.arfs->arfs_tables[i]);
 	}
 }
 
+void mlx5e_arfs_destroy_tables(struct mlx5e_priv *priv)
+{
+	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
+		return;
+
+	_mlx5e_cleanup_tables(priv);
+	kvfree(priv->fs.arfs);
+}
+
 static int arfs_add_default_rule(struct mlx5e_priv *priv,
 				 enum arfs_type type)
 {
-	struct arfs_table *arfs_t = &priv->fs.arfs.arfs_tables[type];
+	struct arfs_table *arfs_t = &priv->fs.arfs->arfs_tables[type];
 	struct mlx5e_tir *tir = priv->indir_tir;
 	struct mlx5_flow_destination dest = {};
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -290,7 +322,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 static int arfs_create_table(struct mlx5e_priv *priv,
 			     enum arfs_type type)
 {
-	struct mlx5e_arfs_tables *arfs = &priv->fs.arfs;
+	struct mlx5e_arfs_tables *arfs = priv->fs.arfs;
 	struct mlx5e_flow_table *ft = &arfs->arfs_tables[type].ft;
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
@@ -330,20 +362,27 @@ int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
 		return 0;
 
-	spin_lock_init(&priv->fs.arfs.arfs_lock);
-	INIT_LIST_HEAD(&priv->fs.arfs.rules);
-	priv->fs.arfs.wq = create_singlethread_workqueue("mlx5e_arfs");
-	if (!priv->fs.arfs.wq)
+	priv->fs.arfs = kvzalloc(sizeof(*priv->fs.arfs), GFP_KERNEL);
+	if (!priv->fs.arfs)
 		return -ENOMEM;
 
+	spin_lock_init(&priv->fs.arfs->arfs_lock);
+	INIT_LIST_HEAD(&priv->fs.arfs->rules);
+	priv->fs.arfs->wq = create_singlethread_workqueue("mlx5e_arfs");
+	if (!priv->fs.arfs->wq)
+		goto err;
+
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		err = arfs_create_table(priv, i);
 		if (err)
-			goto err;
+			goto err_des;
 	}
 	return 0;
+
+err_des:
+	_mlx5e_cleanup_tables(priv);
 err:
-	mlx5e_arfs_destroy_tables(priv);
+	kvfree(priv->fs.arfs);
 	return err;
 }
 
@@ -358,8 +397,8 @@ static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 	int j;
 
 	HLIST_HEAD(del_list);
-	spin_lock_bh(&priv->fs.arfs.arfs_lock);
-	mlx5e_for_each_arfs_rule(arfs_rule, htmp, priv->fs.arfs.arfs_tables, i, j) {
+	spin_lock_bh(&priv->fs.arfs->arfs_lock);
+	mlx5e_for_each_arfs_rule(arfs_rule, htmp, priv->fs.arfs->arfs_tables, i, j) {
 		if (!work_pending(&arfs_rule->arfs_work) &&
 		    rps_may_expire_flow(priv->netdev,
 					arfs_rule->rxq, arfs_rule->flow_id,
@@ -370,7 +409,7 @@ static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 				break;
 		}
 	}
-	spin_unlock_bh(&priv->fs.arfs.arfs_lock);
+	spin_unlock_bh(&priv->fs.arfs->arfs_lock);
 	hlist_for_each_entry_safe(arfs_rule, htmp, &del_list, hlist) {
 		if (arfs_rule->rule)
 			mlx5_del_flow_rules(arfs_rule->rule);
@@ -387,12 +426,12 @@ static void arfs_del_rules(struct mlx5e_priv *priv)
 	int j;
 
 	HLIST_HEAD(del_list);
-	spin_lock_bh(&priv->fs.arfs.arfs_lock);
-	mlx5e_for_each_arfs_rule(rule, htmp, priv->fs.arfs.arfs_tables, i, j) {
+	spin_lock_bh(&priv->fs.arfs->arfs_lock);
+	mlx5e_for_each_arfs_rule(rule, htmp, priv->fs.arfs->arfs_tables, i, j) {
 		hlist_del_init(&rule->hlist);
 		hlist_add_head(&rule->hlist, &del_list);
 	}
-	spin_unlock_bh(&priv->fs.arfs.arfs_lock);
+	spin_unlock_bh(&priv->fs.arfs->arfs_lock);
 
 	hlist_for_each_entry_safe(rule, htmp, &del_list, hlist) {
 		cancel_work_sync(&rule->arfs_work);
@@ -436,7 +475,7 @@ static struct arfs_table *arfs_get_table(struct mlx5e_arfs_tables *arfs,
 static struct mlx5_flow_handle *arfs_add_rule(struct mlx5e_priv *priv,
 					      struct arfs_rule *arfs_rule)
 {
-	struct mlx5e_arfs_tables *arfs = &priv->fs.arfs;
+	struct mlx5e_arfs_tables *arfs = priv->fs.arfs;
 	struct arfs_tuple *tuple = &arfs_rule->tuple;
 	struct mlx5_flow_handle *rule = NULL;
 	struct mlx5_flow_destination dest = {};
@@ -554,9 +593,9 @@ static void arfs_handle_work(struct work_struct *work)
 
 	mutex_lock(&priv->state_lock);
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		spin_lock_bh(&priv->fs.arfs.arfs_lock);
+		spin_lock_bh(&priv->fs.arfs->arfs_lock);
 		hlist_del(&arfs_rule->hlist);
-		spin_unlock_bh(&priv->fs.arfs.arfs_lock);
+		spin_unlock_bh(&priv->fs.arfs->arfs_lock);
 
 		mutex_unlock(&priv->state_lock);
 		kfree(arfs_rule);
@@ -609,7 +648,7 @@ static struct arfs_rule *arfs_alloc_rule(struct mlx5e_priv *priv,
 	tuple->dst_port = fk->ports.dst;
 
 	rule->flow_id = flow_id;
-	rule->filter_id = priv->fs.arfs.last_filter_id++ % RPS_NO_FILTER;
+	rule->filter_id = priv->fs.arfs->last_filter_id++ % RPS_NO_FILTER;
 
 	hlist_add_head(&rule->hlist,
 		       arfs_hash_bucket(arfs_t, tuple->src_port,
@@ -653,7 +692,7 @@ int mlx5e_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 			u16 rxq_index, u32 flow_id)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct mlx5e_arfs_tables *arfs = &priv->fs.arfs;
+	struct mlx5e_arfs_tables *arfs = priv->fs.arfs;
 	struct arfs_table *arfs_t;
 	struct arfs_rule *arfs_rule;
 	struct flow_keys fk;
@@ -687,7 +726,7 @@ int mlx5e_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 			return -ENOMEM;
 		}
 	}
-	queue_work(priv->fs.arfs.wq, &arfs_rule->arfs_work);
+	queue_work(priv->fs.arfs->wq, &arfs_rule->arfs_work);
 	spin_unlock_bh(&arfs->arfs_lock);
 	return arfs_rule->filter_id;
 }
-- 
2.30.2

