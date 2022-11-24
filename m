Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4270B637366
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiKXILR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiKXILO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA117DAD17
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6047D62021
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8DDC433C1;
        Thu, 24 Nov 2022 08:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277461;
        bh=HHoxRj2tVUMkQ59d+1fDuTeYTDyBPadEvKKVs7VSUOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xwn9bg3GV1SmJN+4sMo8YK9DcXrLa/HUhqAhat//42Cv4+wCSZSVL6Ng8I2OongI+
         nk5Vd7jFbLFk9EMw3xQRzyuGQzK0dqjpQZ0JHe/vm3zc5abKn5mbxj3OQyhuoM9Scs
         WEcqGRFOwQqMpGpSpofgF41n1fgyklnn7zm5Hl3cxX0Dt3Ce0Fix2BmX9mpaDI1Uog
         HNeyCTMTmHxCk7akrv4VPpULPf7P/jbbMWVUZq8oLoYqptVJincSdc98msvMpoVocN
         55/ABkHGcnUfdAOTigQkO+uD/hWFqP5vSy8L9AC2zhx9cOavW3JZQNHk3/aVBQ/IY9
         opzunAlNjLUmA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [net 09/15] net/mlx5e: MACsec, fix memory leak when MACsec device is deleted
Date:   Thu, 24 Nov 2022 00:10:34 -0800
Message-Id: <20221124081040.171790-10-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124081040.171790-1-saeed@kernel.org>
References: <20221124081040.171790-1-saeed@kernel.org>
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

From: Raed Salem <raeds@nvidia.com>

When the MACsec netdevice is deleted, all related Rx/Tx HW/SW
states should be released/deallocated, however currently part
of the Rx security channel association data is not cleaned
properly, hence the memory leaks.

Fix by make sure all related Rx Sc resources are cleaned/freed,
while at it improve code by grouping release SC context in a
function so it can be used in both delete MACsec device and
delete Rx SC operations.

Fixes: 5a39816a75e5 ("net/mlx5e: Add MACsec offload SecY support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 77 ++++++++-----------
 1 file changed, 33 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 96fa553ef93a..b51de07d5bad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -823,16 +823,43 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 	return err;
 }
 
+static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec_rx_sc *rx_sc)
+{
+	struct mlx5e_macsec_sa *rx_sa;
+	int i;
+
+	for (i = 0; i < MACSEC_NUM_AN; ++i) {
+		rx_sa = rx_sc->rx_sa[i];
+		if (!rx_sa)
+			continue;
+
+		mlx5e_macsec_cleanup_sa(macsec, rx_sa, false);
+		mlx5_destroy_encryption_key(macsec->mdev, rx_sa->enc_key_id);
+
+		kfree(rx_sa);
+		rx_sc->rx_sa[i] = NULL;
+	}
+
+	/* At this point the relevant MACsec offload Rx rule already removed at
+	 * mlx5e_macsec_cleanup_sa need to wait for datapath to finish current
+	 * Rx related data propagating using xa_erase which uses rcu to sync,
+	 * once fs_id is erased then this rx_sc is hidden from datapath.
+	 */
+	list_del_rcu(&rx_sc->rx_sc_list_element);
+	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
+	metadata_dst_free(rx_sc->md_dst);
+	kfree(rx_sc->sc_xarray_element);
+	kfree_rcu(rx_sc);
+}
+
 static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 {
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
-	struct mlx5e_macsec_sa *rx_sa;
 	struct mlx5e_macsec *macsec;
 	struct list_head *list;
 	int err = 0;
-	int i;
 
 	mutex_lock(&priv->macsec->lock);
 
@@ -854,31 +881,7 @@ static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 		goto out;
 	}
 
-	for (i = 0; i < MACSEC_NUM_AN; ++i) {
-		rx_sa = rx_sc->rx_sa[i];
-		if (!rx_sa)
-			continue;
-
-		mlx5e_macsec_cleanup_sa(macsec, rx_sa, false);
-		mlx5_destroy_encryption_key(macsec->mdev, rx_sa->enc_key_id);
-
-		kfree(rx_sa);
-		rx_sc->rx_sa[i] = NULL;
-	}
-
-/*
- * At this point the relevant MACsec offload Rx rule already removed at
- * mlx5e_macsec_cleanup_sa need to wait for datapath to finish current
- * Rx related data propagating using xa_erase which uses rcu to sync,
- * once fs_id is erased then this rx_sc is hidden from datapath.
- */
-	list_del_rcu(&rx_sc->rx_sc_list_element);
-	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
-	metadata_dst_free(rx_sc->md_dst);
-	kfree(rx_sc->sc_xarray_element);
-
-	kfree_rcu(rx_sc);
-
+	macsec_del_rxsc_ctx(macsec, rx_sc);
 out:
 	mutex_unlock(&macsec->lock);
 
@@ -1239,7 +1242,6 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
-	struct mlx5e_macsec_sa *rx_sa;
 	struct mlx5e_macsec_sa *tx_sa;
 	struct mlx5e_macsec *macsec;
 	struct list_head *list;
@@ -1268,28 +1270,15 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 	}
 
 	list = &macsec_device->macsec_rx_sc_list_head;
-	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element) {
-		for (i = 0; i < MACSEC_NUM_AN; ++i) {
-			rx_sa = rx_sc->rx_sa[i];
-			if (!rx_sa)
-				continue;
-
-			mlx5e_macsec_cleanup_sa(macsec, rx_sa, false);
-			mlx5_destroy_encryption_key(macsec->mdev, rx_sa->enc_key_id);
-			kfree(rx_sa);
-			rx_sc->rx_sa[i] = NULL;
-		}
-
-		list_del_rcu(&rx_sc->rx_sc_list_element);
-
-		kfree_rcu(rx_sc);
-	}
+	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element)
+		macsec_del_rxsc_ctx(macsec, rx_sc);
 
 	kfree(macsec_device->dev_addr);
 	macsec_device->dev_addr = NULL;
 
 	list_del_rcu(&macsec_device->macsec_device_list_element);
 	--macsec->num_of_devices;
+	kfree(macsec_device);
 
 out:
 	mutex_unlock(&macsec->lock);
-- 
2.38.1

