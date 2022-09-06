Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3C5ADEEA
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbiIFFXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbiIFFWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6FC6D9C7
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A65460AFD
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EE5C433B5;
        Tue,  6 Sep 2022 05:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441712;
        bh=U1HGzGSfeGsDs8BitIrpQ1Y4tjowkR44rmmpFdtUo14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9XfBb2MqVE3ctN6VzaX9z5w8CYAJRYQNpVTB0YQ/pJH2F3tw/o9QgPoXUTY2N/7q
         LxFvJ3vFzkubHg/N9BAyP+PE87vtt6KZXHmHbYRZy2HG7DVTZ9w7URLLeCxsUK42W6
         DLyJoN+YnP/+x7cdb5/Qq8mwhYEgmSbL2FIAF3BvaQybaAzxGKEU1vLSTdY+U7f3dC
         GvoOZPo6pC8E7NX++Zdv7c0qEsuUqOG4zc4wXpzcCujUtH8tQeCw9yhRNg7GNTHoAp
         hWvQY7asRg8iHLk5TzaWNoHwwlC49IbuqmIqd3idHUOi27At9GbyxOvyN5cY3rNPGD
         teJsuEXFlWOlA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 15/17] net/mlx5e: Add MACsec offload SecY support
Date:   Mon,  5 Sep 2022 22:21:27 -0700
Message-Id: <20220906052129.104507-16-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Add offload support for MACsec SecY callbacks - add/update/delete.
add_secy is called when need to create a new MACsec interface.
upd_secy is called when source MAC address or tx SC was changed.
del_secy is called when need to destroy the MACsec interface.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 229 ++++++++++++++++++
 1 file changed, 229 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index d5559b4fce05..90ce4fe618b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -66,6 +66,7 @@ struct mlx5e_macsec {
 	/* Rx fs_id -> rx_sc mapping */
 	struct xarray sc_xarray;
 
+	unsigned char *dev_addr;
 	struct mlx5_core_dev *mdev;
 };
 
@@ -243,6 +244,42 @@ static int mlx5e_macsec_update_rx_sa(struct mlx5e_macsec *macsec,
 	return 0;
 }
 
+static bool mlx5e_macsec_secy_features_validate(struct macsec_context *ctx)
+{
+	const struct net_device *netdev = ctx->netdev;
+	const struct macsec_secy *secy = ctx->secy;
+
+	if (secy->validate_frames != MACSEC_VALIDATE_STRICT) {
+		netdev_err(netdev,
+			   "MACsec offload is supported only when validate_frame is in strict mode\n");
+		return false;
+	}
+
+	if (secy->icv_len != MACSEC_DEFAULT_ICV_LEN) {
+		netdev_err(netdev, "MACsec offload is supported only when icv_len is %d\n",
+			   MACSEC_DEFAULT_ICV_LEN);
+		return false;
+	}
+
+	if (!secy->protect_frames) {
+		netdev_err(netdev,
+			   "MACsec offload is supported only when protect_frames is set\n");
+		return false;
+	}
+
+	if (secy->xpn) {
+		netdev_err(netdev, "MACsec offload: xpn is not supported\n");
+		return false;
+	}
+
+	if (secy->replay_protect) {
+		netdev_err(netdev, "MACsec offload: replay protection is not supported\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 {
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
@@ -764,6 +801,195 @@ static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 	return err;
 }
 
+static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	const struct net_device *dev = ctx->secy->netdev;
+	const struct net_device *netdev = ctx->netdev;
+	struct mlx5e_macsec *macsec;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	if (!mlx5e_macsec_secy_features_validate(ctx))
+		return -EINVAL;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+
+	if (macsec->dev_addr) {
+		netdev_err(netdev, "Currently, only one MACsec offload device can be set\n");
+		err = -EINVAL;
+	}
+
+	macsec->dev_addr = kzalloc(dev->addr_len, GFP_KERNEL);
+	if (!macsec->dev_addr) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(macsec->dev_addr, dev->dev_addr, dev->addr_len);
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int macsec_upd_secy_hw_address(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	const struct net_device *dev = ctx->secy->netdev;
+	struct mlx5e_macsec *macsec = priv->macsec;
+	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
+	struct mlx5e_macsec_sa *rx_sa;
+	struct list_head *list;
+	int i, err = 0;
+
+
+	list = &macsec->macsec_rx_sc_list_head;
+	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element) {
+		for (i = 0; i < MACSEC_NUM_AN; ++i) {
+			rx_sa = rx_sc->rx_sa[i];
+			if (!rx_sa || !rx_sa->macsec_rule)
+				continue;
+
+			mlx5e_macsec_cleanup_sa(macsec, rx_sa, false);
+		}
+	}
+
+	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element) {
+		for (i = 0; i < MACSEC_NUM_AN; ++i) {
+			rx_sa = rx_sc->rx_sa[i];
+			if (!rx_sa)
+				continue;
+
+			if (rx_sa->active) {
+				err = mlx5e_macsec_init_sa(ctx, rx_sa, false, false);
+				if (err)
+					goto out;
+			}
+		}
+	}
+
+	memcpy(macsec->dev_addr, dev->dev_addr, dev->addr_len);
+out:
+	return err;
+}
+
+/* this function is called from 2 macsec ops functions:
+ *  macsec_set_mac_address – MAC address was changed, therefore we need to destroy
+ *  and create new Tx contexts(macsec object + steering).
+ *  macsec_changelink – in this case the tx SC or SecY may be changed, therefore need to
+ *  destroy Tx and Rx contexts(macsec object + steering)
+ */
+static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
+{
+	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	const struct net_device *dev = ctx->secy->netdev;
+	struct mlx5e_macsec_sa *tx_sa;
+	struct mlx5e_macsec *macsec;
+	int i, err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	if (!mlx5e_macsec_secy_features_validate(ctx))
+		return -EINVAL;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+
+	/* if the dev_addr hasn't change, it mean the callback is from macsec_changelink */
+	if (!memcmp(macsec->dev_addr, dev->dev_addr, dev->addr_len)) {
+		err = macsec_upd_secy_hw_address(ctx);
+		if (err)
+			goto out;
+	}
+
+	for (i = 0; i < MACSEC_NUM_AN; ++i) {
+		tx_sa = macsec->tx_sa[i];
+		if (!tx_sa)
+			continue;
+
+		mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
+	}
+
+	for (i = 0; i < MACSEC_NUM_AN; ++i) {
+		tx_sa = macsec->tx_sa[i];
+		if (!tx_sa)
+			continue;
+
+		if (tx_sa->assoc_num == tx_sc->encoding_sa && tx_sa->active) {
+			err = mlx5e_macsec_init_sa(ctx, tx_sa, tx_sc->encrypt, true);
+			if (err)
+				goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
+	struct mlx5e_macsec_sa *rx_sa;
+	struct mlx5e_macsec_sa *tx_sa;
+	struct mlx5e_macsec *macsec;
+	struct list_head *list;
+	int i;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+
+	for (i = 0; i < MACSEC_NUM_AN; ++i) {
+		tx_sa = macsec->tx_sa[i];
+		if (!tx_sa)
+			continue;
+
+		mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
+		mlx5_destroy_encryption_key(macsec->mdev, tx_sa->enc_key_id);
+		kfree(tx_sa);
+		macsec->tx_sa[i] = NULL;
+	}
+
+	list = &macsec->macsec_rx_sc_list_head;
+	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element) {
+		for (i = 0; i < MACSEC_NUM_AN; ++i) {
+			rx_sa = rx_sc->rx_sa[i];
+			if (!rx_sa)
+				continue;
+
+			mlx5e_macsec_cleanup_sa(macsec, rx_sa, false);
+			mlx5_destroy_encryption_key(macsec->mdev, rx_sa->enc_key_id);
+			kfree(rx_sa);
+			rx_sc->rx_sa[i] = NULL;
+		}
+
+		list_del_rcu(&rx_sc->rx_sc_list_element);
+
+		kfree_rcu(rx_sc);
+	}
+
+	kfree(macsec->dev_addr);
+	macsec->dev_addr = NULL;
+
+	mutex_unlock(&macsec->lock);
+
+	return 0;
+}
+
 static bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev)
 {
 	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
@@ -805,6 +1031,9 @@ static const struct macsec_ops macsec_offload_ops = {
 	.mdo_add_rxsa = mlx5e_macsec_add_rxsa,
 	.mdo_upd_rxsa = mlx5e_macsec_upd_rxsa,
 	.mdo_del_rxsa = mlx5e_macsec_del_rxsa,
+	.mdo_add_secy = mlx5e_macsec_add_secy,
+	.mdo_upd_secy = mlx5e_macsec_upd_secy,
+	.mdo_del_secy = mlx5e_macsec_del_secy,
 };
 
 bool mlx5e_macsec_handle_tx_skb(struct mlx5e_macsec *macsec, struct sk_buff *skb)
-- 
2.37.2

