Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A86640EEA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiLBULT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiLBULQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90BDF140A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2201CCE1FA5
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE513C433C1;
        Fri,  2 Dec 2022 20:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011864;
        bh=FuDQCNEjCV89VCeI5HJPE0tt64WwyDwKNaEvp+Din6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7+iGXgoI3VlKKITWOQ9/K2sVKNJk2V/2iDWk1XsqjZFKeE7zdWvT5arjtr7Q4ZX2
         fI7qAz76FJVTj6MB12lnvtjjSo7jXwHTL8Zv2T1D0tQ+fpjvgdoxXQf3v6XMeDMrh4
         fXWHb+wn9g/pfcgODmU/Q3gA8oav9Esd6YFyWCcqlb6dhDiGp4J749r5X9L3oOSmGp
         pe1vlC452GRq5st6cp9f8anobTHIlVvyjDah4MBZBQZ+CmIjzjgwidPBorgvGlE1E5
         Z0ZZB5hPKYNDOPwuCjzFq3djhCF24zM9BFXO1H8dsFuUPgc2Jbd9FlpoIEqyAxVpiw
         jXhCj4uignpOw==
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
Subject: [PATCH xfrm-next 06/16] net/mlx5e: Create symmetric IPsec RX and TX flow steering structs
Date:   Fri,  2 Dec 2022 22:10:27 +0200
Message-Id: <b341b098b66ea5c95a7b53cc8fc858508581e6f0.1670011671.git.leonro@nvidia.com>
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

Remove AF family obfuscation by creating symmetric structs for RX and
TX IPsec flow steering chains. This simplifies to us low level IPsec
FS creation logic without need to dig into multiple levels of structs.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   7 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 277 ++++++++----------
 2 files changed, 130 insertions(+), 154 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 05790b7d062f..6b961ff08ed7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -94,7 +94,7 @@ struct mlx5e_ipsec_sw_stats {
 	atomic64_t ipsec_tx_drop_trailer;
 };
 
-struct mlx5e_accel_fs_esp;
+struct mlx5e_ipsec_rx;
 struct mlx5e_ipsec_tx;
 
 struct mlx5e_ipsec {
@@ -103,8 +103,9 @@ struct mlx5e_ipsec {
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
 	struct mlx5e_ipsec_sw_stats sw_stats;
 	struct workqueue_struct *wq;
-	struct mlx5e_accel_fs_esp *rx_fs;
-	struct mlx5e_ipsec_tx *tx_fs;
+	struct mlx5e_ipsec_rx *rx_ipv4;
+	struct mlx5e_ipsec_rx *rx_ipv6;
+	struct mlx5e_ipsec_tx *tx;
 };
 
 struct mlx5e_ipsec_esn_state {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 886263228b5d..a8cf3f8d0515 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -9,49 +9,40 @@
 
 #define NUM_IPSEC_FTE BIT(15)
 
-enum accel_fs_esp_type {
-	ACCEL_FS_ESP4,
-	ACCEL_FS_ESP6,
-	ACCEL_FS_ESP_NUM_TYPES,
-};
-
 struct mlx5e_ipsec_rx_err {
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_modify_hdr *copy_modify_hdr;
 };
 
-struct mlx5e_accel_fs_esp_prot {
-	struct mlx5_flow_table *ft;
+struct mlx5e_ipsec_ft {
+	struct mutex mutex; /* Protect changes to this struct */
+	struct mlx5_flow_table *sa;
+	u32 refcnt;
+};
+
+struct mlx5e_ipsec_rx {
+	struct mlx5e_ipsec_ft ft;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
 	struct mlx5_flow_destination default_dest;
 	struct mlx5e_ipsec_rx_err rx_err;
-	u32 refcnt;
-	struct mutex prot_mutex; /* protect ESP4/ESP6 protocol */
-};
-
-struct mlx5e_accel_fs_esp {
-	struct mlx5e_accel_fs_esp_prot fs_prot[ACCEL_FS_ESP_NUM_TYPES];
 };
 
 struct mlx5e_ipsec_tx {
+	struct mlx5e_ipsec_ft ft;
 	struct mlx5_flow_namespace *ns;
-	struct mlx5_flow_table *ft;
-	struct mutex mutex; /* Protect IPsec TX steering */
-	u32 refcnt;
 };
 
 /* IPsec RX flow steering */
-static enum mlx5_traffic_types fs_esp2tt(enum accel_fs_esp_type i)
+static enum mlx5_traffic_types family2tt(u32 family)
 {
-	if (i == ACCEL_FS_ESP4)
+	if (family == AF_INET)
 		return MLX5_TT_IPV4_IPSEC_ESP;
 	return MLX5_TT_IPV6_IPSEC_ESP;
 }
 
-static int rx_err_add_rule(struct mlx5e_priv *priv,
-			   struct mlx5e_accel_fs_esp_prot *fs_prot,
+static int rx_err_add_rule(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
 			   struct mlx5e_ipsec_rx_err *rx_err)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
@@ -89,7 +80,7 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 			  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	flow_act.modify_hdr = modify_hdr;
 	fte = mlx5_add_flow_rules(rx_err->ft, spec, &flow_act,
-				  &fs_prot->default_dest, 1);
+				  &rx->default_dest, 1);
 	if (IS_ERR(fte)) {
 		err = PTR_ERR(fte);
 		netdev_err(priv->netdev, "fail to add ipsec rx err copy rule err=%d\n", err);
@@ -108,11 +99,10 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 	return err;
 }
 
-static int rx_fs_create(struct mlx5e_priv *priv,
-			struct mlx5e_accel_fs_esp_prot *fs_prot)
+static int rx_fs_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_flow_table *ft = fs_prot->ft;
+	struct mlx5_flow_table *ft = rx->ft.sa;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -136,56 +126,45 @@ static int rx_fs_create(struct mlx5e_priv *priv,
 		netdev_err(priv->netdev, "fail to create ipsec rx miss_group err=%d\n", err);
 		goto out;
 	}
-	fs_prot->miss_group = miss_group;
+	rx->miss_group = miss_group;
 
 	/* Create miss rule */
-	miss_rule = mlx5_add_flow_rules(ft, spec, &flow_act, &fs_prot->default_dest, 1);
+	miss_rule =
+		mlx5_add_flow_rules(ft, spec, &flow_act, &rx->default_dest, 1);
 	if (IS_ERR(miss_rule)) {
-		mlx5_destroy_flow_group(fs_prot->miss_group);
+		mlx5_destroy_flow_group(rx->miss_group);
 		err = PTR_ERR(miss_rule);
 		netdev_err(priv->netdev, "fail to create ipsec rx miss_rule err=%d\n", err);
 		goto out;
 	}
-	fs_prot->miss_rule = miss_rule;
+	rx->miss_rule = miss_rule;
 out:
 	kvfree(flow_group_in);
 	kvfree(spec);
 	return err;
 }
 
-static void rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+static void rx_destroy(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
 {
-	struct mlx5e_accel_fs_esp_prot *fs_prot;
-	struct mlx5e_accel_fs_esp *accel_esp;
-
-	accel_esp = priv->ipsec->rx_fs;
+	mlx5_del_flow_rules(rx->miss_rule);
+	mlx5_destroy_flow_group(rx->miss_group);
+	mlx5_destroy_flow_table(rx->ft.sa);
 
-	/* The netdev unreg already happened, so all offloaded rule are already removed */
-	fs_prot = &accel_esp->fs_prot[type];
-
-	mlx5_del_flow_rules(fs_prot->miss_rule);
-	mlx5_destroy_flow_group(fs_prot->miss_group);
-	mlx5_destroy_flow_table(fs_prot->ft);
-
-	mlx5_del_flow_rules(fs_prot->rx_err.rule);
-	mlx5_modify_header_dealloc(priv->mdev, fs_prot->rx_err.copy_modify_hdr);
-	mlx5_destroy_flow_table(fs_prot->rx_err.ft);
+	mlx5_del_flow_rules(rx->rx_err.rule);
+	mlx5_modify_header_dealloc(priv->mdev, rx->rx_err.copy_modify_hdr);
+	mlx5_destroy_flow_table(rx->rx_err.ft);
 }
 
-static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+static int rx_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
+		     u32 family)
 {
 	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	struct mlx5_flow_table_attr ft_attr = {};
-	struct mlx5e_accel_fs_esp_prot *fs_prot;
-	struct mlx5e_accel_fs_esp *accel_esp;
 	struct mlx5_flow_table *ft;
 	int err;
 
-	accel_esp = priv->ipsec->rx_fs;
-	fs_prot = &accel_esp->fs_prot[type];
-	fs_prot->default_dest =
-		mlx5_ttc_get_default_dest(ttc, fs_esp2tt(type));
+	rx->default_dest = mlx5_ttc_get_default_dest(ttc, family2tt(family));
 
 	ft_attr.max_fte = 1;
 	ft_attr.autogroup.max_num_groups = 1;
@@ -195,8 +174,8 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
-	fs_prot->rx_err.ft = ft;
-	err = rx_err_add_rule(priv, fs_prot, &fs_prot->rx_err);
+	rx->rx_err.ft = ft;
+	err = rx_err_add_rule(priv, rx, &rx->rx_err);
 	if (err)
 		goto err_add;
 
@@ -211,76 +190,82 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 		err = PTR_ERR(ft);
 		goto err_fs_ft;
 	}
-	fs_prot->ft = ft;
+	rx->ft.sa = ft;
 
-	err = rx_fs_create(priv, fs_prot);
+	err = rx_fs_create(priv, rx);
 	if (err)
 		goto err_fs;
 
 	return 0;
 
 err_fs:
-	mlx5_destroy_flow_table(fs_prot->ft);
+	mlx5_destroy_flow_table(rx->ft.sa);
 err_fs_ft:
-	mlx5_del_flow_rules(fs_prot->rx_err.rule);
-	mlx5_modify_header_dealloc(priv->mdev, fs_prot->rx_err.copy_modify_hdr);
+	mlx5_del_flow_rules(rx->rx_err.rule);
+	mlx5_modify_header_dealloc(priv->mdev, rx->rx_err.copy_modify_hdr);
 err_add:
-	mlx5_destroy_flow_table(fs_prot->rx_err.ft);
+	mlx5_destroy_flow_table(rx->rx_err.ft);
 	return err;
 }
 
-static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5e_priv *priv, u32 family)
 {
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
-	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5_flow_destination dest = {};
-	struct mlx5e_accel_fs_esp *accel_esp;
+	struct mlx5e_ipsec_rx *rx;
 	int err = 0;
 
-	accel_esp = priv->ipsec->rx_fs;
-	fs_prot = &accel_esp->fs_prot[type];
-	mutex_lock(&fs_prot->prot_mutex);
-	if (fs_prot->refcnt)
+	if (family == AF_INET)
+		rx = priv->ipsec->rx_ipv4;
+	else
+		rx = priv->ipsec->rx_ipv6;
+
+	mutex_lock(&rx->ft.mutex);
+	if (rx->ft.refcnt)
 		goto skip;
 
 	/* create FT */
-	err = rx_create(priv, type);
+	err = rx_create(priv, rx, family);
 	if (err)
 		goto out;
 
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = fs_prot->ft;
-	mlx5_ttc_fwd_dest(ttc, fs_esp2tt(type), &dest);
+	dest.ft = rx->ft.sa;
+	mlx5_ttc_fwd_dest(ttc, family2tt(family), &dest);
 
 skip:
-	fs_prot->refcnt++;
+	rx->ft.refcnt++;
 out:
-	mutex_unlock(&fs_prot->prot_mutex);
-	return err;
+	mutex_unlock(&rx->ft.mutex);
+	if (err)
+		return ERR_PTR(err);
+	return rx;
 }
 
-static void rx_ft_put(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+static void rx_ft_put(struct mlx5e_priv *priv, u32 family)
 {
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
-	struct mlx5e_accel_fs_esp_prot *fs_prot;
-	struct mlx5e_accel_fs_esp *accel_esp;
-
-	accel_esp = priv->ipsec->rx_fs;
-	fs_prot = &accel_esp->fs_prot[type];
-	mutex_lock(&fs_prot->prot_mutex);
-	fs_prot->refcnt--;
-	if (fs_prot->refcnt)
+	struct mlx5e_ipsec_rx *rx;
+
+	if (family == AF_INET)
+		rx = priv->ipsec->rx_ipv4;
+	else
+		rx = priv->ipsec->rx_ipv6;
+
+	mutex_lock(&rx->ft.mutex);
+	rx->ft.refcnt--;
+	if (rx->ft.refcnt)
 		goto out;
 
 	/* disconnect */
-	mlx5_ttc_fwd_default_dest(ttc, fs_esp2tt(type));
+	mlx5_ttc_fwd_default_dest(ttc, family2tt(family));
 
 	/* remove FT */
-	rx_destroy(priv, type);
+	rx_destroy(priv, rx);
 
 out:
-	mutex_unlock(&fs_prot->prot_mutex);
+	mutex_unlock(&rx->ft.mutex);
 }
 
 /* IPsec TX flow steering */
@@ -293,47 +278,49 @@ static int tx_create(struct mlx5e_priv *priv)
 
 	ft_attr.max_fte = NUM_IPSEC_FTE;
 	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(ipsec->tx_fs->ns, &ft_attr);
+	ft = mlx5_create_auto_grouped_flow_table(ipsec->tx->ns, &ft_attr);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		netdev_err(priv->netdev, "fail to create ipsec tx ft err=%d\n", err);
 		return err;
 	}
-	ipsec->tx_fs->ft = ft;
+	ipsec->tx->ft.sa = ft;
 	return 0;
 }
 
-static int tx_ft_get(struct mlx5e_priv *priv)
+static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5e_priv *priv)
 {
-	struct mlx5e_ipsec_tx *tx_fs = priv->ipsec->tx_fs;
+	struct mlx5e_ipsec_tx *tx = priv->ipsec->tx;
 	int err = 0;
 
-	mutex_lock(&tx_fs->mutex);
-	if (tx_fs->refcnt)
+	mutex_lock(&tx->ft.mutex);
+	if (tx->ft.refcnt)
 		goto skip;
 
 	err = tx_create(priv);
 	if (err)
 		goto out;
 skip:
-	tx_fs->refcnt++;
+	tx->ft.refcnt++;
 out:
-	mutex_unlock(&tx_fs->mutex);
-	return err;
+	mutex_unlock(&tx->ft.mutex);
+	if (err)
+		return ERR_PTR(err);
+	return tx;
 }
 
 static void tx_ft_put(struct mlx5e_priv *priv)
 {
-	struct mlx5e_ipsec_tx *tx_fs = priv->ipsec->tx_fs;
+	struct mlx5e_ipsec_tx *tx = priv->ipsec->tx;
 
-	mutex_lock(&tx_fs->mutex);
-	tx_fs->refcnt--;
-	if (tx_fs->refcnt)
+	mutex_lock(&tx->ft.mutex);
+	tx->ft.refcnt--;
+	if (tx->ft.refcnt)
 		goto out;
 
-	mlx5_destroy_flow_table(tx_fs->ft);
+	mlx5_destroy_flow_table(tx->ft.sa);
 out:
-	mutex_unlock(&tx_fs->mutex);
+	mutex_unlock(&tx->ft.mutex);
 }
 
 static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
@@ -401,22 +388,16 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	u32 ipsec_obj_id = sa_entry->ipsec_obj_id;
 	struct mlx5_modify_hdr *modify_hdr = NULL;
-	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5_flow_destination dest = {};
-	struct mlx5e_accel_fs_esp *accel_esp;
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
-	enum accel_fs_esp_type type;
 	struct mlx5_flow_spec *spec;
+	struct mlx5e_ipsec_rx *rx;
 	int err = 0;
 
-	accel_esp = priv->ipsec->rx_fs;
-	type = (attrs->family == AF_INET) ? ACCEL_FS_ESP4 : ACCEL_FS_ESP6;
-	fs_prot = &accel_esp->fs_prot[type];
-
-	err = rx_ft_get(priv, type);
-	if (err)
-		return err;
+	rx = rx_ft_get(priv, attrs->family);
+	if (IS_ERR(rx))
+		return PTR_ERR(rx);
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
@@ -449,8 +430,8 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	flow_act.modify_hdr = modify_hdr;
-	dest.ft = fs_prot->rx_err.ft;
-	rule = mlx5_add_flow_rules(fs_prot->ft, spec, &flow_act, &dest, 1);
+	dest.ft = rx->rx_err.ft;
+	rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		netdev_err(priv->netdev, "fail to add RX ipsec rule err=%d\n",
@@ -465,7 +446,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 out_err:
 	if (modify_hdr)
 		mlx5_modify_header_dealloc(priv->mdev, modify_hdr);
-	rx_ft_put(priv, type);
+	rx_ft_put(priv, attrs->family);
 
 out:
 	kvfree(spec);
@@ -478,11 +459,12 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
+	struct mlx5e_ipsec_tx *tx;
 	int err = 0;
 
-	err = tx_ft_get(priv);
-	if (err)
-		return err;
+	tx = tx_ft_get(priv);
+	if (IS_ERR(tx))
+		return PTR_ERR(tx);
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
@@ -502,7 +484,7 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW |
 			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT;
-	rule = mlx5_add_flow_rules(priv->ipsec->tx_fs->ft, spec, &flow_act, NULL, 0);
+	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, NULL, 0);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		netdev_err(priv->netdev, "fail to add TX ipsec rule err=%d\n",
@@ -533,7 +515,6 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 {
 	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
-	enum accel_fs_esp_type type;
 
 	mlx5_del_flow_rules(ipsec_rule->rule);
 
@@ -543,38 +524,30 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 	}
 
 	mlx5_modify_header_dealloc(mdev, ipsec_rule->set_modify_hdr);
-	type = (sa_entry->attrs.family == AF_INET) ? ACCEL_FS_ESP4 : ACCEL_FS_ESP6;
-	rx_ft_put(priv, type);
+	rx_ft_put(priv, sa_entry->attrs.family);
 }
 
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
 {
-	struct mlx5e_accel_fs_esp_prot *fs_prot;
-	struct mlx5e_accel_fs_esp *accel_esp;
-	enum accel_fs_esp_type i;
-
-	if (!ipsec->rx_fs)
+	if (!ipsec->tx)
 		return;
 
-	mutex_destroy(&ipsec->tx_fs->mutex);
-	WARN_ON(ipsec->tx_fs->refcnt);
-	kfree(ipsec->tx_fs);
+	mutex_destroy(&ipsec->tx->ft.mutex);
+	WARN_ON(ipsec->tx->ft.refcnt);
+	kfree(ipsec->tx);
 
-	accel_esp = ipsec->rx_fs;
-	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
-		fs_prot = &accel_esp->fs_prot[i];
-		mutex_destroy(&fs_prot->prot_mutex);
-		WARN_ON(fs_prot->refcnt);
-	}
-	kfree(ipsec->rx_fs);
+	mutex_destroy(&ipsec->rx_ipv4->ft.mutex);
+	WARN_ON(ipsec->rx_ipv4->ft.refcnt);
+	kfree(ipsec->rx_ipv4);
+
+	mutex_destroy(&ipsec->rx_ipv6->ft.mutex);
+	WARN_ON(ipsec->rx_ipv6->ft.refcnt);
+	kfree(ipsec->rx_ipv6);
 }
 
 int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 {
-	struct mlx5e_accel_fs_esp_prot *fs_prot;
-	struct mlx5e_accel_fs_esp *accel_esp;
 	struct mlx5_flow_namespace *ns;
-	enum accel_fs_esp_type i;
 	int err = -ENOMEM;
 
 	ns = mlx5_get_flow_namespace(ipsec->mdev,
@@ -582,26 +555,28 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 	if (!ns)
 		return -EOPNOTSUPP;
 
-	ipsec->tx_fs = kzalloc(sizeof(*ipsec->tx_fs), GFP_KERNEL);
-	if (!ipsec->tx_fs)
+	ipsec->tx = kzalloc(sizeof(*ipsec->tx), GFP_KERNEL);
+	if (!ipsec->tx)
 		return -ENOMEM;
 
-	ipsec->rx_fs = kzalloc(sizeof(*ipsec->rx_fs), GFP_KERNEL);
-	if (!ipsec->rx_fs)
-		goto err_rx;
+	ipsec->rx_ipv4 = kzalloc(sizeof(*ipsec->rx_ipv4), GFP_KERNEL);
+	if (!ipsec->rx_ipv4)
+		goto err_rx_ipv4;
 
-	mutex_init(&ipsec->tx_fs->mutex);
-	ipsec->tx_fs->ns = ns;
+	ipsec->rx_ipv6 = kzalloc(sizeof(*ipsec->rx_ipv6), GFP_KERNEL);
+	if (!ipsec->rx_ipv6)
+		goto err_rx_ipv6;
 
-	accel_esp = ipsec->rx_fs;
-	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
-		fs_prot = &accel_esp->fs_prot[i];
-		mutex_init(&fs_prot->prot_mutex);
-	}
+	mutex_init(&ipsec->tx->ft.mutex);
+	mutex_init(&ipsec->rx_ipv4->ft.mutex);
+	mutex_init(&ipsec->rx_ipv6->ft.mutex);
+	ipsec->tx->ns = ns;
 
 	return 0;
 
-err_rx:
-	kfree(ipsec->tx_fs);
+err_rx_ipv6:
+	kfree(ipsec->rx_ipv4);
+err_rx_ipv4:
+	kfree(ipsec->tx);
 	return err;
 }
-- 
2.38.1

