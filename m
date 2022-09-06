Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3525ADEE2
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbiIFFXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiIFFWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D726D560
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE1CE612D4
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DDBC43470;
        Tue,  6 Sep 2022 05:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441714;
        bh=VFOCZxfeTbA6HlPqJ3J1ikUGhiSH8Mpe7ZAmaGx1SHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTBzUAmVE1+n592e5ij7+gdYnsd6trsGMyU+c4rQ3tXENrmz5ACjTnvYnqrp9qYTp
         Itz0DehXydxG0ie/SHD7nu5bpHGikUHdPSBv5Id/HzYBfdY4Hks57lWxPB7W9ge/Jj
         r62TtumuAObiavOI3GoYaQU3LHWy+4dx2ed4yN35WRFfEi/gGS1Zwb2KiNkt3IHWXj
         1HEe1agFtmqDH51/bSgk6zCK8t77UcTIQocH2jp9Y1297WI5BDn0ZxUsm/wcM+02YT
         yvWIIRhfdJZlFkDG8FqFhGhjhE4knuhd2TDY2pKtgSdVtLrMiC1cJtHRI32Xv556tk
         OARn34u7CwvRA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 17/17] net/mlx5e: Add support to configure more than one macsec offload device
Date:   Mon,  5 Sep 2022 22:21:29 -0700
Message-Id: <20220906052129.104507-18-saeed@kernel.org>
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

Add the ability to add up to 16 MACsec offload interfaces
over the same physical interface

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 221 ++++++++++++++----
 1 file changed, 175 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 4ff44bec8e03..d9d18b039d8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -51,10 +51,18 @@ static const struct rhashtable_params rhash_sci = {
 	.min_size = 1,
 };
 
-struct mlx5e_macsec {
-	struct mlx5e_macsec_fs *macsec_fs;
+struct mlx5e_macsec_device {
+	const struct net_device *netdev;
 	struct mlx5e_macsec_sa *tx_sa[MACSEC_NUM_AN];
 	struct list_head macsec_rx_sc_list_head;
+	unsigned char *dev_addr;
+	struct list_head macsec_device_list_element;
+};
+
+struct mlx5e_macsec {
+	struct list_head macsec_device_list_head;
+	int num_of_devices;
+	struct mlx5e_macsec_fs *macsec_fs;
 	struct mutex lock; /* Protects mlx5e_macsec internal contexts */
 
 	/* Global PD for MACsec object ASO context */
@@ -66,7 +74,6 @@ struct mlx5e_macsec {
 	/* Rx fs_id -> rx_sc mapping */
 	struct xarray sc_xarray;
 
-	unsigned char *dev_addr;
 	struct mlx5_core_dev *mdev;
 
 	/* Stats manage */
@@ -283,12 +290,29 @@ static bool mlx5e_macsec_secy_features_validate(struct macsec_context *ctx)
 	return true;
 }
 
+static struct mlx5e_macsec_device *
+mlx5e_macsec_get_macsec_device_context(const struct mlx5e_macsec *macsec,
+				       const struct macsec_context *ctx)
+{
+	struct mlx5e_macsec_device *iter;
+	const struct list_head *list;
+
+	list = &macsec->macsec_device_list_head;
+	list_for_each_entry_rcu(iter, list, macsec_device_list_element) {
+		if (iter->netdev == ctx->secy->netdev)
+			return iter;
+	}
+
+	return NULL;
+}
+
 static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 {
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct macsec_secy *secy = ctx->secy;
+	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -301,8 +325,14 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EEXIST;
+		goto out;
+	}
 
-	if (macsec->tx_sa[assoc_num]) {
+	if (macsec_device->tx_sa[assoc_num]) {
 		netdev_err(ctx->netdev, "MACsec offload tx_sa: %d already exist\n", assoc_num);
 		err = -EEXIST;
 		goto out;
@@ -314,19 +344,17 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 		goto out;
 	}
 
-	macsec->tx_sa[assoc_num] = tx_sa;
-
 	tx_sa->active = ctx_tx_sa->active;
 	tx_sa->next_pn = ctx_tx_sa->next_pn_halves.lower;
 	tx_sa->sci = secy->sci;
 	tx_sa->assoc_num = assoc_num;
-
 	err = mlx5_create_encryption_key(mdev, ctx->sa.key, secy->key_len,
 					 MLX5_ACCEL_OBJ_MACSEC_KEY,
 					 &tx_sa->enc_key_id);
 	if (err)
 		goto destroy_sa;
 
+	macsec_device->tx_sa[assoc_num] = tx_sa;
 	if (!secy->operational ||
 	    assoc_num != tx_sc->encoding_sa ||
 	    !tx_sa->active)
@@ -341,10 +369,10 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 	return 0;
 
 destroy_encryption_key:
+	macsec_device->tx_sa[assoc_num] = NULL;
 	mlx5_destroy_encryption_key(mdev, tx_sa->enc_key_id);
 destroy_sa:
 	kfree(tx_sa);
-	macsec->tx_sa[assoc_num] = NULL;
 out:
 	mutex_unlock(&macsec->lock);
 
@@ -356,6 +384,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_sa *tx_sa;
 	struct mlx5e_macsec *macsec;
@@ -368,12 +397,17 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
-	tx_sa = macsec->tx_sa[assoc_num];
 	netdev = ctx->netdev;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
 
+	tx_sa = macsec_device->tx_sa[assoc_num];
 	if (!tx_sa) {
 		netdev_err(netdev, "MACsec offload: TX sa 0x%x doesn't exist\n", assoc_num);
-
 		err = -EEXIST;
 		goto out;
 	}
@@ -396,8 +430,10 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 		if (err)
 			goto out;
 	} else {
-		if (!tx_sa->macsec_rule)
-			return -EINVAL;
+		if (!tx_sa->macsec_rule) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
 	}
@@ -412,6 +448,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_sa *tx_sa;
 	struct mlx5e_macsec *macsec;
@@ -421,10 +458,15 @@ static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 		return 0;
 
 	mutex_lock(&priv->macsec->lock);
-
 	macsec = priv->macsec;
-	tx_sa = macsec->tx_sa[ctx->sa.assoc_num];
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
 
+	tx_sa = macsec_device->tx_sa[assoc_num];
 	if (!tx_sa) {
 		netdev_err(ctx->netdev, "MACsec offload: TX sa 0x%x doesn't exist\n", assoc_num);
 		err = -EEXIST;
@@ -434,7 +476,7 @@ static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 	mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
 	mlx5_destroy_encryption_key(macsec->mdev, tx_sa->enc_key_id);
 	kfree_rcu(tx_sa);
-	macsec->tx_sa[assoc_num] = NULL;
+	macsec_device->tx_sa[assoc_num] = NULL;
 
 out:
 	mutex_unlock(&macsec->lock);
@@ -461,6 +503,7 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 	struct mlx5e_macsec_rx_sc_xarray_element *sc_xarray_element;
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *ctx_rx_sc = ctx->rx_sc;
+	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	struct list_head *rx_sc_list;
 	struct mlx5e_macsec *macsec;
@@ -471,9 +514,18 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 
 	mutex_lock(&priv->macsec->lock);
 	macsec = priv->macsec;
-	rx_sc_list = &macsec->macsec_rx_sc_list_head;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	rx_sc_list = &macsec_device->macsec_rx_sc_list_head;
 	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(rx_sc_list, ctx_rx_sc->sci);
 	if (rx_sc) {
+		netdev_err(ctx->netdev, "MACsec offload: rx_sc (sci %lld) already exists\n",
+			   ctx_rx_sc->sci);
 		err = -EEXIST;
 		goto out;
 	}
@@ -504,7 +556,7 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 
 	rx_sc->sci = ctx_rx_sc->sci;
 	rx_sc->active = ctx_rx_sc->active;
-	list_add_rcu(&rx_sc->rx_sc_list_element, &macsec->macsec_rx_sc_list_head);
+	list_add_rcu(&rx_sc->rx_sc_list_element, rx_sc_list);
 
 	rx_sc->sc_xarray_element = sc_xarray_element;
 	rx_sc->md_dst->u.macsec_info.sci = rx_sc->sci;
@@ -529,6 +581,7 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *ctx_rx_sc = ctx->rx_sc;
+	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	struct mlx5e_macsec_sa *rx_sa;
 	struct mlx5e_macsec *macsec;
@@ -542,7 +595,14 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
-	list = &macsec->macsec_rx_sc_list_head;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	list = &macsec_device->macsec_rx_sc_list_head;
 	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, ctx_rx_sc->sci);
 	if (!rx_sc) {
 		err = -EINVAL;
@@ -572,6 +632,7 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	struct mlx5e_macsec_sa *rx_sa;
 	struct mlx5e_macsec *macsec;
@@ -585,7 +646,14 @@ static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
-	list = &macsec->macsec_rx_sc_list_head;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	list = &macsec_device->macsec_rx_sc_list_head;
 	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, ctx->rx_sc->sci);
 	if (!rx_sc) {
 		netdev_err(ctx->netdev,
@@ -630,6 +698,7 @@ static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 {
 	const struct macsec_rx_sa *ctx_rx_sa = ctx->sa.rx_sa;
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -645,7 +714,14 @@ static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
-	list = &macsec->macsec_rx_sc_list_head;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	list = &macsec_device->macsec_rx_sc_list_head;
 	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
 	if (!rx_sc) {
 		netdev_err(ctx->netdev,
@@ -707,6 +783,7 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 {
 	const struct macsec_rx_sa *ctx_rx_sa = ctx->sa.rx_sa;
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	sci_t sci = ctx_rx_sa->sc->sci;
@@ -721,7 +798,14 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
-	list = &macsec->macsec_rx_sc_list_head;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	list = &macsec_device->macsec_rx_sc_list_head;
 	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
 	if (!rx_sc) {
 		netdev_err(ctx->netdev,
@@ -748,9 +832,7 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 		goto out;
 	}
 
-	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
 	err = mlx5e_macsec_update_rx_sa(macsec, rx_sa, ctx_rx_sa->active);
-
 out:
 	mutex_unlock(&macsec->lock);
 
@@ -760,6 +842,7 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec_device *macsec_device;
 	sci_t sci = ctx->sa.rx_sa->sc->sci;
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	u8 assoc_num = ctx->sa.assoc_num;
@@ -774,7 +857,14 @@ static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
-	list = &macsec->macsec_rx_sc_list_head;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	list = &macsec_device->macsec_rx_sc_list_head;
 	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
 	if (!rx_sc) {
 		netdev_err(ctx->netdev,
@@ -809,6 +899,7 @@ static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
 	const struct net_device *netdev = ctx->netdev;
+	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec *macsec;
 	int err = 0;
 
@@ -819,28 +910,47 @@ static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 		return -EINVAL;
 
 	mutex_lock(&priv->macsec->lock);
-
 	macsec = priv->macsec;
+	if (mlx5e_macsec_get_macsec_device_context(macsec, ctx)) {
+		netdev_err(netdev, "MACsec offload: MACsec net_device already exist\n");
+		goto out;
+	}
 
-	if (macsec->dev_addr) {
-		netdev_err(netdev, "Currently, only one MACsec offload device can be set\n");
-		err = -EINVAL;
+	if (macsec->num_of_devices >= MLX5_MACSEC_NUM_OF_SUPPORTED_INTERFACES) {
+		netdev_err(netdev, "Currently, only %d MACsec offload devices can be set\n",
+			   MLX5_MACSEC_NUM_OF_SUPPORTED_INTERFACES);
+		err = -EBUSY;
+		goto out;
+	}
+
+	macsec_device = kzalloc(sizeof(*macsec_device), GFP_KERNEL);
+	if (!macsec_device) {
+		err = -ENOMEM;
+		goto out;
 	}
 
-	macsec->dev_addr = kzalloc(dev->addr_len, GFP_KERNEL);
-	if (!macsec->dev_addr) {
+	macsec_device->dev_addr = kzalloc(dev->addr_len, GFP_KERNEL);
+	if (!macsec_device->dev_addr) {
+		kfree(macsec_device);
 		err = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(macsec->dev_addr, dev->dev_addr, dev->addr_len);
+	memcpy(macsec_device->dev_addr, dev->dev_addr, dev->addr_len);
+	macsec_device->netdev = dev;
+
+	INIT_LIST_HEAD_RCU(&macsec_device->macsec_rx_sc_list_head);
+	list_add_rcu(&macsec_device->macsec_device_list_element, &macsec->macsec_device_list_head);
+
+	++macsec->num_of_devices;
 out:
 	mutex_unlock(&macsec->lock);
 
 	return err;
 }
 
-static int macsec_upd_secy_hw_address(struct macsec_context *ctx)
+static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
+				      struct mlx5e_macsec_device *macsec_device)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
@@ -851,7 +961,7 @@ static int macsec_upd_secy_hw_address(struct macsec_context *ctx)
 	int i, err = 0;
 
 
-	list = &macsec->macsec_rx_sc_list_head;
+	list = &macsec_device->macsec_rx_sc_list_head;
 	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element) {
 		for (i = 0; i < MACSEC_NUM_AN; ++i) {
 			rx_sa = rx_sc->rx_sa[i];
@@ -876,7 +986,7 @@ static int macsec_upd_secy_hw_address(struct macsec_context *ctx)
 		}
 	}
 
-	memcpy(macsec->dev_addr, dev->dev_addr, dev->addr_len);
+	memcpy(macsec_device->dev_addr, dev->dev_addr, dev->addr_len);
 out:
 	return err;
 }
@@ -892,6 +1002,7 @@ static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
+	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_sa *tx_sa;
 	struct mlx5e_macsec *macsec;
 	int i, err = 0;
@@ -905,16 +1016,22 @@ static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
 
 	/* if the dev_addr hasn't change, it mean the callback is from macsec_changelink */
-	if (!memcmp(macsec->dev_addr, dev->dev_addr, dev->addr_len)) {
-		err = macsec_upd_secy_hw_address(ctx);
+	if (!memcmp(macsec_device->dev_addr, dev->dev_addr, dev->addr_len)) {
+		err = macsec_upd_secy_hw_address(ctx, macsec_device);
 		if (err)
 			goto out;
 	}
 
 	for (i = 0; i < MACSEC_NUM_AN; ++i) {
-		tx_sa = macsec->tx_sa[i];
+		tx_sa = macsec_device->tx_sa[i];
 		if (!tx_sa)
 			continue;
 
@@ -922,7 +1039,7 @@ static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 	}
 
 	for (i = 0; i < MACSEC_NUM_AN; ++i) {
-		tx_sa = macsec->tx_sa[i];
+		tx_sa = macsec_device->tx_sa[i];
 		if (!tx_sa)
 			continue;
 
@@ -942,32 +1059,40 @@ static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
 	struct mlx5e_macsec_sa *rx_sa;
 	struct mlx5e_macsec_sa *tx_sa;
 	struct mlx5e_macsec *macsec;
 	struct list_head *list;
+	int err = 0;
 	int i;
 
 	if (ctx->prepare)
 		return 0;
 
 	mutex_lock(&priv->macsec->lock);
-
 	macsec = priv->macsec;
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+
+		goto out;
+	}
 
 	for (i = 0; i < MACSEC_NUM_AN; ++i) {
-		tx_sa = macsec->tx_sa[i];
+		tx_sa = macsec_device->tx_sa[i];
 		if (!tx_sa)
 			continue;
 
 		mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
 		mlx5_destroy_encryption_key(macsec->mdev, tx_sa->enc_key_id);
 		kfree(tx_sa);
-		macsec->tx_sa[i] = NULL;
+		macsec_device->tx_sa[i] = NULL;
 	}
 
-	list = &macsec->macsec_rx_sc_list_head;
+	list = &macsec_device->macsec_rx_sc_list_head;
 	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element) {
 		for (i = 0; i < MACSEC_NUM_AN; ++i) {
 			rx_sa = rx_sc->rx_sa[i];
@@ -985,12 +1110,16 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 		kfree_rcu(rx_sc);
 	}
 
-	kfree(macsec->dev_addr);
-	macsec->dev_addr = NULL;
+	kfree(macsec_device->dev_addr);
+	macsec_device->dev_addr = NULL;
+
+	list_del_rcu(&macsec_device->macsec_device_list_element);
+	--macsec->num_of_devices;
 
+out:
 	mutex_unlock(&macsec->lock);
 
-	return 0;
+	return err;
 }
 
 bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev)
@@ -1140,7 +1269,7 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	if (!macsec)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&macsec->macsec_rx_sc_list_head);
+	INIT_LIST_HEAD(&macsec->macsec_device_list_head);
 	mutex_init(&macsec->lock);
 
 	err = mlx5_core_alloc_pd(mdev, &macsec->aso_pdn);
-- 
2.37.2

