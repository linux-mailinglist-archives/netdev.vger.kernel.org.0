Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06CE5959F9
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiHPLZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiHPLYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:24:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F327733A04
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DD8AB8169C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9851DC433D6;
        Tue, 16 Aug 2022 10:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646334;
        bh=M/5xKc982Z4Ux64qgYjxCH192m14i0Pehh1KksV+3sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqMnFtM4i82d34W00/GomkSDbtJX0zJtfi7yEp2j4bQ+jy3+yfUr1eECnbI7u5FAQ
         b2O/NndGGjY4KuJjexHw74vYo7uEPKQvrmylzJxI2WutW9HFtKQ1s9uBxF4wpweSQJ
         9UgPKt835b3awfJOP6i+UkTkY6D/C6MbiJuXS6suX3dPg6BeG8CeT+KWD+UB5EQB6K
         DLl5/HffrdENjKaVQNHup1NK/XadM5ofCcIn8NLaLMD2OPjzr0KoTmfzAQ+w7QLptX
         CiqNYxkwmRot6knUfAr+7N3jTtIRJHiC+XZh2YTWZjCd9GpLJTgLGOajkdhHHXtpZK
         g57ARAIbvOQmw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 09/26] net/mlx5e: Remove accesses to priv for low level IPsec FS code
Date:   Tue, 16 Aug 2022 13:37:57 +0300
Message-Id: <645769f53f9c864aae5493fb38e5005f8f7789d0.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

mlx5 priv structure is driver main structure that holds high level data.
That information is not needed for IPsec flow steering logic and the
pointer to mlx5e_priv was not supposed to be passed in the first place.

This change "cleans" the logic to rely on internal to IPsec structures
without touching global mlx5e_priv.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   8 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   7 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 102 +++++++++---------
 3 files changed, 57 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index e4fe0249c5be..56d70bbb4b5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -309,7 +309,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	if (err)
 		goto err_xfrm;
 
-	err = mlx5e_accel_ipsec_fs_add_rule(priv, sa_entry);
+	err = mlx5e_accel_ipsec_fs_add_rule(sa_entry);
 	if (err)
 		goto err_hw_ctx;
 
@@ -327,7 +327,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_add_rule:
-	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
+	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 err_hw_ctx:
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 err_xfrm:
@@ -347,10 +347,9 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
-	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
 	cancel_work_sync(&sa_entry->modify_work.work);
-	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
+	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 	kfree(sa_entry);
 }
@@ -383,6 +382,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	if (ret)
 		goto err_fs_init;
 
+	ipsec->fs = priv->fs;
 	priv->ipsec = ipsec;
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 02c3e6334cdd..3bba62f54604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -103,6 +103,7 @@ struct mlx5e_ipsec {
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
 	struct mlx5e_ipsec_sw_stats sw_stats;
 	struct workqueue_struct *wq;
+	struct mlx5e_flow_steering *fs;
 	struct mlx5e_ipsec_rx *rx_ipv4;
 	struct mlx5e_ipsec_rx *rx_ipv6;
 	struct mlx5e_ipsec_tx *tx;
@@ -148,10 +149,8 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *dev,
 
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
-int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5e_ipsec_sa_entry *sa_entry);
-void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5e_ipsec_sa_entry *sa_entry);
+int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
+void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index c9b93ea8eec5..e732ce19e039 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -42,11 +42,11 @@ static enum mlx5_traffic_types family2tt(u32 family)
 	return MLX5_TT_IPV6_IPSEC_ESP;
 }
 
-static int rx_err_add_rule(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
+static int rx_err_add_rule(struct mlx5_core_dev *mdev,
+			   struct mlx5e_ipsec_rx *rx,
 			   struct mlx5e_ipsec_rx_err *rx_err)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
-	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_flow_handle *fte;
@@ -99,11 +99,10 @@ static int rx_err_add_rule(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
 	return err;
 }
 
-static int rx_fs_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
+static int rx_fs_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table *ft = rx->ft.sa;
-	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -145,37 +144,37 @@ static int rx_fs_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
 	return err;
 }
 
-static void rx_destroy(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
+static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 {
 	mlx5_del_flow_rules(rx->miss_rule);
 	mlx5_destroy_flow_group(rx->miss_group);
 	mlx5_destroy_flow_table(rx->ft.sa);
 
 	mlx5_del_flow_rules(rx->rx_err.rule);
-	mlx5_modify_header_dealloc(priv->mdev, rx->rx_err.copy_modify_hdr);
+	mlx5_modify_header_dealloc(mdev, rx->rx_err.copy_modify_hdr);
 	mlx5_destroy_flow_table(rx->rx_err.ft);
 }
 
-static int rx_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
-		     u32 family)
+static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
+		     struct mlx5e_ipsec_rx *rx, u32 family)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *ft;
 	int err;
 
 	rx->default_dest =
-		mlx5_ttc_get_default_dest(priv->fs->ttc, family2tt(family));
+		mlx5_ttc_get_default_dest(ipsec->fs->ttc, family2tt(family));
 
 	ft_attr.max_fte = 1;
 	ft_attr.autogroup.max_num_groups = 1;
 	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs->ns, &ft_attr);
+	ft = mlx5_create_auto_grouped_flow_table(ipsec->fs->ns, &ft_attr);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
 	rx->rx_err.ft = ft;
-	err = rx_err_add_rule(priv, rx, &rx->rx_err);
+	err = rx_err_add_rule(mdev, rx, &rx->rx_err);
 	if (err)
 		goto err_add;
 
@@ -185,14 +184,14 @@ static int rx_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
 	ft_attr.prio = MLX5E_NIC_PRIO;
 	ft_attr.autogroup.num_reserved_entries = 1;
 	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs->ns, &ft_attr);
+	ft = mlx5_create_auto_grouped_flow_table(ipsec->fs->ns, &ft_attr);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_fs_ft;
 	}
 	rx->ft.sa = ft;
 
-	err = rx_fs_create(priv, rx);
+	err = rx_fs_create(mdev, rx);
 	if (err)
 		goto err_fs;
 
@@ -202,36 +201,37 @@ static int rx_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
 	mlx5_destroy_flow_table(rx->ft.sa);
 err_fs_ft:
 	mlx5_del_flow_rules(rx->rx_err.rule);
-	mlx5_modify_header_dealloc(priv->mdev, rx->rx_err.copy_modify_hdr);
+	mlx5_modify_header_dealloc(mdev, rx->rx_err.copy_modify_hdr);
 err_add:
 	mlx5_destroy_flow_table(rx->rx_err.ft);
 	return err;
 }
 
-static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5e_priv *priv, u32 family)
+static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5_core_dev *mdev,
+					struct mlx5e_ipsec *ipsec, u32 family)
 {
 	struct mlx5_flow_destination dest = {};
 	struct mlx5e_ipsec_rx *rx;
 	int err = 0;
 
 	if (family == AF_INET)
-		rx = priv->ipsec->rx_ipv4;
+		rx = ipsec->rx_ipv4;
 	else
-		rx = priv->ipsec->rx_ipv6;
+		rx = ipsec->rx_ipv6;
 
 	mutex_lock(&rx->ft.mutex);
 	if (rx->ft.refcnt)
 		goto skip;
 
 	/* create FT */
-	err = rx_create(priv, rx, family);
+	err = rx_create(mdev, ipsec, rx, family);
 	if (err)
 		goto out;
 
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = rx->ft.sa;
-	mlx5_ttc_fwd_dest(priv->fs->ttc, family2tt(family), &dest);
+	mlx5_ttc_fwd_dest(ipsec->fs->ttc, family2tt(family), &dest);
 
 skip:
 	rx->ft.refcnt++;
@@ -242,14 +242,15 @@ static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5e_priv *priv, u32 family)
 	return rx;
 }
 
-static void rx_ft_put(struct mlx5e_priv *priv, u32 family)
+static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
+		      u32 family)
 {
 	struct mlx5e_ipsec_rx *rx;
 
 	if (family == AF_INET)
-		rx = priv->ipsec->rx_ipv4;
+		rx = ipsec->rx_ipv4;
 	else
-		rx = priv->ipsec->rx_ipv6;
+		rx = ipsec->rx_ipv6;
 
 	mutex_lock(&rx->ft.mutex);
 	rx->ft.refcnt--;
@@ -257,46 +258,45 @@ static void rx_ft_put(struct mlx5e_priv *priv, u32 family)
 		goto out;
 
 	/* disconnect */
-	mlx5_ttc_fwd_default_dest(priv->fs->ttc, family2tt(family));
+	mlx5_ttc_fwd_default_dest(ipsec->fs->ttc, family2tt(family));
 
 	/* remove FT */
-	rx_destroy(priv, rx);
+	rx_destroy(mdev, rx);
 
 out:
 	mutex_unlock(&rx->ft.mutex);
 }
 
 /* IPsec TX flow steering */
-static int tx_create(struct mlx5e_priv *priv)
+static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
-	struct mlx5e_ipsec *ipsec = priv->ipsec;
-	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_flow_table *ft;
 	int err;
 
 	ft_attr.max_fte = NUM_IPSEC_FTE;
 	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(ipsec->tx->ns, &ft_attr);
+	ft = mlx5_create_auto_grouped_flow_table(tx->ns, &ft_attr);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		mlx5_core_err(mdev, "fail to create ipsec tx ft err=%d\n", err);
 		return err;
 	}
-	ipsec->tx->ft.sa = ft;
+	tx->ft.sa = ft;
 	return 0;
 }
 
-static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5e_priv *priv)
+static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
+					struct mlx5e_ipsec *ipsec)
 {
-	struct mlx5e_ipsec_tx *tx = priv->ipsec->tx;
+	struct mlx5e_ipsec_tx *tx = ipsec->tx;
 	int err = 0;
 
 	mutex_lock(&tx->ft.mutex);
 	if (tx->ft.refcnt)
 		goto skip;
 
-	err = tx_create(priv);
+	err = tx_create(mdev, tx);
 	if (err)
 		goto out;
 skip:
@@ -308,9 +308,9 @@ static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5e_priv *priv)
 	return tx;
 }
 
-static void tx_ft_put(struct mlx5e_priv *priv)
+static void tx_ft_put(struct mlx5e_ipsec *ipsec)
 {
-	struct mlx5e_ipsec_tx *tx = priv->ipsec->tx;
+	struct mlx5e_ipsec_tx *tx = ipsec->tx;
 
 	mutex_lock(&tx->ft.mutex);
 	tx->ft.refcnt--;
@@ -378,13 +378,13 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
 	flow_act->flags |= FLOW_ACT_NO_APPEND;
 }
 
-static int rx_add_rule(struct mlx5e_priv *priv,
-		       struct mlx5e_ipsec_sa_entry *sa_entry)
+static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	u32 ipsec_obj_id = sa_entry->ipsec_obj_id;
 	struct mlx5_modify_hdr *modify_hdr = NULL;
 	struct mlx5_flow_destination dest = {};
@@ -394,7 +394,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	struct mlx5e_ipsec_rx *rx;
 	int err = 0;
 
-	rx = rx_ft_get(priv, attrs->family);
+	rx = rx_ft_get(mdev, ipsec, attrs->family);
 	if (IS_ERR(rx))
 		return PTR_ERR(rx);
 
@@ -414,7 +414,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	MLX5_SET(set_action_in, action, offset, 0);
 	MLX5_SET(set_action_in, action, length, 32);
 
-	modify_hdr = mlx5_modify_header_alloc(priv->mdev, MLX5_FLOW_NAMESPACE_KERNEL,
+	modify_hdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL,
 					      1, action);
 	if (IS_ERR(modify_hdr)) {
 		err = PTR_ERR(modify_hdr);
@@ -443,25 +443,25 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 
 out_err:
 	if (modify_hdr)
-		mlx5_modify_header_dealloc(priv->mdev, modify_hdr);
-	rx_ft_put(priv, attrs->family);
+		mlx5_modify_header_dealloc(mdev, modify_hdr);
+	rx_ft_put(mdev, ipsec, attrs->family);
 
 out:
 	kvfree(spec);
 	return err;
 }
 
-static int tx_add_rule(struct mlx5e_priv *priv,
-		       struct mlx5e_ipsec_sa_entry *sa_entry)
+static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_tx *tx;
 	int err = 0;
 
-	tx = tx_ft_get(priv);
+	tx = tx_ft_get(mdev, ipsec);
 	if (IS_ERR(tx))
 		return PTR_ERR(tx);
 
@@ -495,21 +495,19 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 out:
 	kvfree(spec);
 	if (err)
-		tx_ft_put(priv);
+		tx_ft_put(ipsec);
 	return err;
 }
 
-int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5e_ipsec_sa_entry *sa_entry)
+int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT)
-		return tx_add_rule(priv, sa_entry);
+		return tx_add_rule(sa_entry);
 
-	return rx_add_rule(priv, sa_entry);
+	return rx_add_rule(sa_entry);
 }
 
-void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5e_ipsec_sa_entry *sa_entry)
+void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
@@ -517,12 +515,12 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 	mlx5_del_flow_rules(ipsec_rule->rule);
 
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
-		tx_ft_put(priv);
+		tx_ft_put(sa_entry->ipsec);
 		return;
 	}
 
 	mlx5_modify_header_dealloc(mdev, ipsec_rule->set_modify_hdr);
-	rx_ft_put(priv, sa_entry->attrs.family);
+	rx_ft_put(mdev, sa_entry->ipsec, sa_entry->attrs.family);
 }
 
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
-- 
2.37.2

