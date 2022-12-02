Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC235640EEC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiLBULd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiLBULS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A63F4EA3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23626221E
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8DEC433C1;
        Fri,  2 Dec 2022 20:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011872;
        bh=cew3o5183PzKIFxHFUpGU3XDci8yb74G8KgqViaYHaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHGPQ497BF1FQH9TW/JXkQU3VUi2Yp2QK8IBuAJrI23HBN2j9HVE7pErRiVw13L8s
         UheE75RG4ZiW+EWlhuhn4MK8lOROVnAXZi1Ppe4MFrbXlDbx88xMDlS+JRK/ZCHN4H
         pWIneKgqB0GMqH+RFJkcpXW0drL0CUS5EGVMwuJnGZRairBDRNHllcw8EjI+UrfoF4
         smfBcWwJY9RIW5fDOGXjOBcq39MbiKSAAYj0X4QucSxP8yxURlxfGzoqienPvILBid
         8lrGR5LexL3Ao61wLIWhKgYSox7txK2bZ9v+qIJpbZW/ZlH0nCiz35SkYaA4ctW0rf
         dgT5SZ7THv3Xw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 08/16] net/mlx5e: Remove accesses to priv for low level IPsec FS code
Date:   Fri,  2 Dec 2022 22:10:29 +0200
Message-Id: <bf412bb34fb22cae66bae7de98e04ee5c3ade902.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   8 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   7 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 100 +++++++++---------
 3 files changed, 56 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 14ed72b26bbe..f518322c1ac1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -306,7 +306,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	if (err)
 		goto err_xfrm;
 
-	err = mlx5e_accel_ipsec_fs_add_rule(priv, sa_entry);
+	err = mlx5e_accel_ipsec_fs_add_rule(sa_entry);
 	if (err)
 		goto err_hw_ctx;
 
@@ -324,7 +324,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_add_rule:
-	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
+	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 err_hw_ctx:
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 err_xfrm:
@@ -344,10 +344,9 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
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
@@ -378,6 +377,7 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	if (ret)
 		goto err_fs_init;
 
+	ipsec->fs = priv->fs;
 	priv->ipsec = ipsec;
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 6b961ff08ed7..db0ccf2a797a 100644
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
index 08feff765032..8e87d8d02511 100644
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
@@ -145,22 +144,22 @@ static int rx_fs_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
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
-	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(ipsec->fs, false);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *ft;
 	int err;
@@ -176,7 +175,7 @@ static int rx_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
 		return PTR_ERR(ft);
 
 	rx->rx_err.ft = ft;
-	err = rx_err_add_rule(priv, rx, &rx->rx_err);
+	err = rx_err_add_rule(mdev, rx, &rx->rx_err);
 	if (err)
 		goto err_add;
 
@@ -193,7 +192,7 @@ static int rx_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
 	}
 	rx->ft.sa = ft;
 
-	err = rx_fs_create(priv, rx);
+	err = rx_fs_create(mdev, rx);
 	if (err)
 		goto err_fs;
 
@@ -203,30 +202,31 @@ static int rx_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
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
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
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
 
@@ -244,15 +244,16 @@ static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5e_priv *priv, u32 family)
 	return rx;
 }
 
-static void rx_ft_put(struct mlx5e_priv *priv, u32 family)
+static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
+		      u32 family)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
 	struct mlx5e_ipsec_rx *rx;
 
 	if (family == AF_INET)
-		rx = priv->ipsec->rx_ipv4;
+		rx = ipsec->rx_ipv4;
 	else
-		rx = priv->ipsec->rx_ipv6;
+		rx = ipsec->rx_ipv6;
 
 	mutex_lock(&rx->ft.mutex);
 	rx->ft.refcnt--;
@@ -263,43 +264,42 @@ static void rx_ft_put(struct mlx5e_priv *priv, u32 family)
 	mlx5_ttc_fwd_default_dest(ttc, family2tt(family));
 
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
@@ -311,9 +311,9 @@ static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5e_priv *priv)
 	return tx;
 }
 
-static void tx_ft_put(struct mlx5e_priv *priv)
+static void tx_ft_put(struct mlx5e_ipsec *ipsec)
 {
-	struct mlx5e_ipsec_tx *tx = priv->ipsec->tx;
+	struct mlx5e_ipsec_tx *tx = ipsec->tx;
 
 	mutex_lock(&tx->ft.mutex);
 	tx->ft.refcnt--;
@@ -382,13 +382,13 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
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
@@ -398,7 +398,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	struct mlx5e_ipsec_rx *rx;
 	int err = 0;
 
-	rx = rx_ft_get(priv, attrs->family);
+	rx = rx_ft_get(mdev, ipsec, attrs->family);
 	if (IS_ERR(rx))
 		return PTR_ERR(rx);
 
@@ -418,7 +418,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	MLX5_SET(set_action_in, action, offset, 0);
 	MLX5_SET(set_action_in, action, length, 32);
 
-	modify_hdr = mlx5_modify_header_alloc(priv->mdev, MLX5_FLOW_NAMESPACE_KERNEL,
+	modify_hdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL,
 					      1, action);
 	if (IS_ERR(modify_hdr)) {
 		err = PTR_ERR(modify_hdr);
@@ -447,25 +447,25 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 
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
 
@@ -499,21 +499,19 @@ static int tx_add_rule(struct mlx5e_priv *priv,
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
@@ -521,12 +519,12 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
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
2.38.1

