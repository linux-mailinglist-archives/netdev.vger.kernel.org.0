Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B269A5ADEE1
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237412AbiIFFWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiIFFVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B986C6D573
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 327B7B81622
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD54AC433D6;
        Tue,  6 Sep 2022 05:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441709;
        bh=+Q+VlQmOu+XL38MAJooXJvvALc/6E915qq5lcyr+3A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDoY2DC+tJTH/AHqw3i2Vh5r81HovRZCwIYd9aWpyAi5S3gul3OeA2JxVHc7NPR3l
         6EV/Eq9rwz3TcuoQ4mFdlvm39uIkfxjSiJgNhqaJEgUWkkY8eNTs8CVhwvLuvhLdcF
         Wpj7+TTT5OWP7yy/pso+qPlN1wBc6BUjP/dq2o6eO8t6Sns2oYli+ryFK9PlQJ5nqH
         0Sh7N/RPjFFBV/CZOcpmw9fzXKSRmAQ9Am9vgBxdc7zuv8jCyZYwlnkPiRcNT1Og2U
         tY8aijSEZwo8CF/rYVJZwN/XcScm0jfoLE9DEVJN6RYa4vNvkSaYUuqdXba9ttpRBg
         3orqSNFVoWngQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 11/17] net/mlx5e: Add MACsec offload Rx command support
Date:   Mon,  5 Sep 2022 22:21:23 -0700
Message-Id: <20220906052129.104507-12-saeed@kernel.org>
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

Add a support for Connect-X MACsec offload Rx SA & SC commands:
add, update and delete.

SCs are created on demend and aren't limited by number and unique by SCI.
Each Rx SA must be associated with Rx SC according to SCI.

Follow-up patches will implement the Rx steering.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 383 +++++++++++++++++-
 1 file changed, 377 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 4a792f161ed8..12711a638d07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -26,6 +26,14 @@ struct mlx5e_macsec_sa {
 	struct rcu_head rcu_head;
 };
 
+struct mlx5e_macsec_rx_sc {
+	bool active;
+	sci_t sci;
+	struct mlx5e_macsec_sa *rx_sa[MACSEC_NUM_AN];
+	struct list_head rx_sc_list_element;
+	struct rcu_head rcu_head;
+};
+
 static const struct rhashtable_params rhash_sci = {
 	.key_len = sizeof_field(struct mlx5e_macsec_sa, sci),
 	.key_offset = offsetof(struct mlx5e_macsec_sa, sci),
@@ -37,6 +45,7 @@ static const struct rhashtable_params rhash_sci = {
 struct mlx5e_macsec {
 	struct mlx5e_macsec_fs *macsec_fs;
 	struct mlx5e_macsec_sa *tx_sa[MACSEC_NUM_AN];
+	struct list_head macsec_rx_sc_list_head;
 	struct mutex lock; /* Protects mlx5e_macsec internal contexts */
 
 	/* Global PD for MACsec object ASO context */
@@ -58,6 +67,7 @@ struct mlx5_macsec_obj_attrs {
 
 static int mlx5e_macsec_create_object(struct mlx5_core_dev *mdev,
 				      struct mlx5_macsec_obj_attrs *attrs,
+				      bool is_tx,
 				      u32 *macsec_obj_id)
 {
 	u32 in[MLX5_ST_SZ_DW(create_macsec_obj_in)] = {};
@@ -76,8 +86,10 @@ static int mlx5e_macsec_create_object(struct mlx5_core_dev *mdev,
 	MLX5_SET(macsec_offload_obj, obj, macsec_aso_access_pd, attrs->aso_pdn);
 
 	MLX5_SET(macsec_aso, aso_ctx, valid, 0x1);
-	MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_INC_SN);
-	MLX5_SET(macsec_aso, aso_ctx, mode_parameter, attrs->next_pn);
+	if (is_tx) {
+		MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_INC_SN);
+		MLX5_SET(macsec_aso, aso_ctx, mode_parameter, attrs->next_pn);
+	}
 
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
@@ -127,7 +139,8 @@ static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec, struct mlx5e_ma
 
 static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 				struct mlx5e_macsec_sa *sa,
-				bool encrypt)
+				bool encrypt,
+				bool is_tx)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec *macsec = priv->macsec;
@@ -143,7 +156,7 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	obj_attrs.encrypt = encrypt;
 	obj_attrs.aso_pdn = macsec->aso_pdn;
 
-	err = mlx5e_macsec_create_object(mdev, &obj_attrs, &sa->macsec_obj_id);
+	err = mlx5e_macsec_create_object(mdev, &obj_attrs, is_tx, &sa->macsec_obj_id);
 	if (err)
 		return err;
 
@@ -169,6 +182,45 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	return err;
 }
 
+static struct mlx5e_macsec_rx_sc *
+mlx5e_macsec_get_rx_sc_from_sc_list(const struct list_head *list, sci_t sci)
+{
+	struct mlx5e_macsec_rx_sc *iter;
+
+	list_for_each_entry_rcu(iter, list, rx_sc_list_element) {
+		if (iter->sci == sci)
+			return iter;
+	}
+
+	return NULL;
+}
+
+static int mlx5e_macsec_update_rx_sa(struct mlx5e_macsec *macsec,
+				     struct mlx5e_macsec_sa *rx_sa,
+				     bool active)
+{
+	struct mlx5_core_dev *mdev = macsec->mdev;
+	struct mlx5_macsec_obj_attrs attrs;
+	int err = 0;
+
+	if (rx_sa->active != active)
+		return 0;
+
+	rx_sa->active = active;
+	if (!active) {
+		mlx5e_macsec_destroy_object(mdev, rx_sa->macsec_obj_id);
+		return 0;
+	}
+
+	attrs.sci = rx_sa->sci;
+	attrs.enc_key_id = rx_sa->enc_key_id;
+	err = mlx5e_macsec_create_object(mdev, &attrs, false, &rx_sa->macsec_obj_id);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 {
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
@@ -218,7 +270,7 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 	    !tx_sa->active)
 		goto out;
 
-	err = mlx5e_macsec_init_sa(ctx, tx_sa, tx_sc->encrypt);
+	err = mlx5e_macsec_init_sa(ctx, tx_sa, tx_sc->encrypt, true);
 	if (err)
 		goto destroy_encryption_key;
 
@@ -278,7 +330,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 		goto out;
 
 	if (ctx_tx_sa->active) {
-		err = mlx5e_macsec_init_sa(ctx, tx_sa, tx_sc->encrypt);
+		err = mlx5e_macsec_init_sa(ctx, tx_sa, tx_sc->encrypt, true);
 		if (err)
 			goto out;
 	} else {
@@ -342,6 +394,318 @@ static u32 mlx5e_macsec_get_sa_from_hashtable(struct rhashtable *sci_hash, sci_t
 	return fs_id;
 }
 
+static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	const struct macsec_rx_sc *ctx_rx_sc = ctx->rx_sc;
+	struct mlx5e_macsec_rx_sc *rx_sc;
+	struct list_head *rx_sc_list;
+	struct mlx5e_macsec *macsec;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+	macsec = priv->macsec;
+	rx_sc_list = &macsec->macsec_rx_sc_list_head;
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(rx_sc_list, ctx_rx_sc->sci);
+	if (rx_sc) {
+		err = -EEXIST;
+		goto out;
+	}
+
+	rx_sc = kzalloc(sizeof(*rx_sc), GFP_KERNEL);
+	if (!rx_sc) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	rx_sc->sci = ctx_rx_sc->sci;
+	rx_sc->active = ctx_rx_sc->active;
+	list_add_rcu(&rx_sc->rx_sc_list_element, &macsec->macsec_rx_sc_list_head);
+
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	const struct macsec_rx_sc *ctx_rx_sc = ctx->rx_sc;
+	struct mlx5e_macsec_rx_sc *rx_sc;
+	struct mlx5e_macsec_sa *rx_sa;
+	struct mlx5e_macsec *macsec;
+	struct list_head *list;
+	int i;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+	list = &macsec->macsec_rx_sc_list_head;
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, ctx_rx_sc->sci);
+	if (!rx_sc) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rx_sc->active = ctx_rx_sc->active;
+	if (rx_sc->active == ctx_rx_sc->active)
+		goto out;
+
+	for (i = 0; i < MACSEC_NUM_AN; ++i) {
+		rx_sa = rx_sc->rx_sa[i];
+		if (!rx_sa)
+			continue;
+
+		err = mlx5e_macsec_update_rx_sa(macsec, rx_sa, rx_sa->active && ctx_rx_sc->active);
+		if (err)
+			goto out;
+	}
+
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_macsec_rx_sc *rx_sc;
+	struct mlx5e_macsec_sa *rx_sa;
+	struct mlx5e_macsec *macsec;
+	struct list_head *list;
+	int err = 0;
+	int i;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+	list = &macsec->macsec_rx_sc_list_head;
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, ctx->rx_sc->sci);
+	if (!rx_sc) {
+		netdev_err(ctx->netdev,
+			   "MACsec offload rx_sc sci %lld doesn't exist\n",
+			   ctx->sa.rx_sa->sc->sci);
+		err = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < MACSEC_NUM_AN; ++i) {
+		rx_sa = rx_sc->rx_sa[i];
+		if (!rx_sa)
+			continue;
+
+		mlx5e_macsec_destroy_object(mdev, rx_sa->macsec_obj_id);
+		mlx5_destroy_encryption_key(mdev, rx_sa->enc_key_id);
+
+		kfree(rx_sa);
+		rx_sc->rx_sa[i] = NULL;
+	}
+
+	list_del_rcu(&rx_sc->rx_sc_list_element);
+
+	kfree_rcu(rx_sc);
+
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_rx_sa *ctx_rx_sa = ctx->sa.rx_sa;
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5_macsec_obj_attrs attrs;
+	u8 assoc_num = ctx->sa.assoc_num;
+	struct mlx5e_macsec_rx_sc *rx_sc;
+	sci_t sci = ctx_rx_sa->sc->sci;
+	struct mlx5e_macsec_sa *rx_sa;
+	struct mlx5e_macsec *macsec;
+	struct list_head *list;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+	list = &macsec->macsec_rx_sc_list_head;
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
+	if (!rx_sc) {
+		netdev_err(ctx->netdev,
+			   "MACsec offload rx_sc sci %lld doesn't exist\n",
+			   ctx->sa.rx_sa->sc->sci);
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (rx_sc->rx_sa[assoc_num]) {
+		netdev_err(ctx->netdev,
+			   "MACsec offload rx_sc sci %lld rx_sa %d already exist\n",
+			   sci, assoc_num);
+		err = -EEXIST;
+		goto out;
+	}
+
+	rx_sa = kzalloc(sizeof(*rx_sa), GFP_KERNEL);
+	if (!rx_sa) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	rx_sa->active = ctx_rx_sa->active;
+	rx_sa->next_pn = ctx_rx_sa->next_pn;
+	rx_sa->sci = sci;
+	rx_sa->assoc_num = assoc_num;
+	err = mlx5_create_encryption_key(mdev, ctx->sa.key, ctx->secy->key_len,
+					 MLX5_ACCEL_OBJ_MACSEC_KEY,
+					 &rx_sa->enc_key_id);
+	if (err)
+		goto destroy_sa;
+
+	rx_sc->rx_sa[assoc_num] = rx_sa;
+	if (!rx_sa->active)
+		goto out;
+
+	attrs.sci = rx_sa->sci;
+	attrs.enc_key_id = rx_sa->enc_key_id;
+
+	//TODO - add support for both authentication and encryption flows
+	err = mlx5e_macsec_create_object(mdev, &attrs, false, &rx_sa->macsec_obj_id);
+	if (err)
+		goto destroy_encryption_key;
+
+	goto out;
+
+destroy_encryption_key:
+	rx_sc->rx_sa[assoc_num] = NULL;
+	mlx5_destroy_encryption_key(mdev, rx_sa->enc_key_id);
+destroy_sa:
+	kfree(rx_sa);
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_rx_sa *ctx_rx_sa = ctx->sa.rx_sa;
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	u8 assoc_num = ctx->sa.assoc_num;
+	struct mlx5e_macsec_rx_sc *rx_sc;
+	sci_t sci = ctx_rx_sa->sc->sci;
+	struct mlx5e_macsec_sa *rx_sa;
+	struct mlx5e_macsec *macsec;
+	struct list_head *list;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+	list = &macsec->macsec_rx_sc_list_head;
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
+	if (!rx_sc) {
+		netdev_err(ctx->netdev,
+			   "MACsec offload rx_sc sci %lld doesn't exist\n",
+			   ctx->sa.rx_sa->sc->sci);
+		err = -EINVAL;
+		goto out;
+	}
+
+	rx_sa = rx_sc->rx_sa[assoc_num];
+	if (rx_sa) {
+		netdev_err(ctx->netdev,
+			   "MACsec offload rx_sc sci %lld rx_sa %d already exist\n",
+			   sci, assoc_num);
+		err = -EEXIST;
+		goto out;
+	}
+
+	if (rx_sa->next_pn != ctx_rx_sa->next_pn_halves.lower) {
+		netdev_err(ctx->netdev,
+			   "MACsec offload update RX sa %d PN isn't supported\n",
+			   assoc_num);
+		err = -EINVAL;
+		goto out;
+	}
+
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
+	err = mlx5e_macsec_update_rx_sa(macsec, rx_sa, ctx_rx_sa->active);
+
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	sci_t sci = ctx->sa.rx_sa->sc->sci;
+	struct mlx5e_macsec_rx_sc *rx_sc;
+	u8 assoc_num = ctx->sa.assoc_num;
+	struct mlx5e_macsec_sa *rx_sa;
+	struct mlx5e_macsec *macsec;
+	struct list_head *list;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+	list = &macsec->macsec_rx_sc_list_head;
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
+	if (!rx_sc) {
+		netdev_err(ctx->netdev,
+			   "MACsec offload rx_sc sci %lld doesn't exist\n",
+			   ctx->sa.rx_sa->sc->sci);
+		err = -EINVAL;
+		goto out;
+	}
+
+	rx_sa = rx_sc->rx_sa[assoc_num];
+	if (rx_sa) {
+		netdev_err(ctx->netdev,
+			   "MACsec offload rx_sc sci %lld rx_sa %d already exist\n",
+			   sci, assoc_num);
+		err = -EEXIST;
+		goto out;
+	}
+
+	mlx5e_macsec_destroy_object(mdev, rx_sa->macsec_obj_id);
+	mlx5_destroy_encryption_key(mdev, rx_sa->enc_key_id);
+
+	kfree(rx_sa);
+	rx_sc->rx_sa[assoc_num] = NULL;
+
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
 static bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev)
 {
 	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
@@ -377,6 +741,12 @@ static const struct macsec_ops macsec_offload_ops = {
 	.mdo_add_txsa = mlx5e_macsec_add_txsa,
 	.mdo_upd_txsa = mlx5e_macsec_upd_txsa,
 	.mdo_del_txsa = mlx5e_macsec_del_txsa,
+	.mdo_add_rxsc = mlx5e_macsec_add_rxsc,
+	.mdo_upd_rxsc = mlx5e_macsec_upd_rxsc,
+	.mdo_del_rxsc = mlx5e_macsec_del_rxsc,
+	.mdo_add_rxsa = mlx5e_macsec_add_rxsa,
+	.mdo_upd_rxsa = mlx5e_macsec_upd_rxsa,
+	.mdo_del_rxsa = mlx5e_macsec_del_rxsa,
 };
 
 bool mlx5e_macsec_handle_tx_skb(struct mlx5e_macsec *macsec, struct sk_buff *skb)
@@ -439,6 +809,7 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	if (!macsec)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&macsec->macsec_rx_sc_list_head);
 	mutex_init(&macsec->lock);
 
 	err = mlx5_core_alloc_pd(mdev, &macsec->aso_pdn);
-- 
2.37.2

