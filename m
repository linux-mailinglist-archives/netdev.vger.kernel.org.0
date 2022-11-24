Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE63F637364
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiKXILP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiKXILD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C1ADA4C2
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498E362022
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982EDC433D6;
        Thu, 24 Nov 2022 08:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277460;
        bh=E/jx9l1K7KT79Rq66866cVqar0baT+ue/d5aDJ4/La0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWHLsYQaYo3KrwF0a5XM+owOVGRt5Tc0GcyVXOE6HjXLf/XiDqQLOzE5lnqWe0T5k
         jOujs2dh2aqmaabbXxEU2YzFMqv/r+xQoYP0h/Fhwk8vqtZIXpR9K2T3C/cBQwuSKT
         Gajah4xKmPjGLD2c2kHduT7ik7GaMc/COdg+j/hTZQ9Qmcd063W4bpjFTa9S3Fg665
         eOIIOaos8cpV6m8bxio/rITgvLnRRUyeQMrjgWv/cwruPjNq2WddzGlgsLY6PFkNOp
         aYNMEoSirW2i2suKq/BptSCKxTglAD4C75qaTKRWpKtVN5+TwGCdSUKiBwk53jZmd1
         3dW/KMPGFlGDw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [net 08/15] net/mlx5e: MACsec, fix RX data path 16 RX security channel limit
Date:   Thu, 24 Nov 2022 00:10:33 -0800
Message-Id: <20221124081040.171790-9-saeed@kernel.org>
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

Currently the data path metadata flow id mask wrongly limits the
number of different RX security channels (SC) to 16, whereas in
adding RX SC the limit is "2^16 - 1" this cause an overlap in
metadata flow id once more than 16 RX SCs is added, this corrupts
MACsec RX offloaded flow handling.

Fix by using the correct mask, while at it improve code to use this
mask when adding the Rx rule and improve visibility of such errors
by adding debug massage.

Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 11 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.h |  6 ++++--
 .../ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c  |  4 ++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 3dc6c987b8da..96fa553ef93a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -736,9 +736,14 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 
 	sc_xarray_element->rx_sc = rx_sc;
 	err = xa_alloc(&macsec->sc_xarray, &sc_xarray_element->fs_id, sc_xarray_element,
-		       XA_LIMIT(1, USHRT_MAX), GFP_KERNEL);
-	if (err)
+		       XA_LIMIT(1, MLX5_MACEC_RX_FS_ID_MAX), GFP_KERNEL);
+	if (err) {
+		if (err == -EBUSY)
+			netdev_err(ctx->netdev,
+				   "MACsec offload: unable to create entry for RX SC (%d Rx SCs already allocated)\n",
+				   MLX5_MACEC_RX_FS_ID_MAX);
 		goto destroy_sc_xarray_elemenet;
+	}
 
 	rx_sc->md_dst = metadata_dst_alloc(0, METADATA_MACSEC, GFP_KERNEL);
 	if (!rx_sc->md_dst) {
@@ -1748,7 +1753,7 @@ void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
 	if (!macsec)
 		return;
 
-	fs_id = MLX5_MACSEC_METADATA_HANDLE(macsec_meta_data);
+	fs_id = MLX5_MACSEC_RX_METADAT_HANDLE(macsec_meta_data);
 
 	rcu_read_lock();
 	sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
index d580b4a91253..347380a2cd9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
@@ -10,9 +10,11 @@
 #include <net/macsec.h>
 #include <net/dst_metadata.h>
 
-/* Bit31 - 30: MACsec marker, Bit3-0: MACsec id */
+/* Bit31 - 30: MACsec marker, Bit15-0: MACsec id */
+#define MLX5_MACEC_RX_FS_ID_MAX USHRT_MAX /* Must be power of two */
+#define MLX5_MACSEC_RX_FS_ID_MASK MLX5_MACEC_RX_FS_ID_MAX
 #define MLX5_MACSEC_METADATA_MARKER(metadata)  ((((metadata) >> 30) & 0x3)  == 0x1)
-#define MLX5_MACSEC_METADATA_HANDLE(metadata)  ((metadata) & GENMASK(3, 0))
+#define MLX5_MACSEC_RX_METADAT_HANDLE(metadata)  ((metadata) & MLX5_MACSEC_RX_FS_ID_MASK)
 
 struct mlx5e_priv;
 struct mlx5e_macsec;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 96cec6d826c2..f87a1c4021bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -1146,10 +1146,10 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	ft_crypto = &rx_tables->ft_crypto;
 
 	/* Set bit[31 - 30] macsec marker - 0x01 */
-	/* Set bit[3-0] fs id */
+	/* Set bit[15-0] fs id */
 	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
-	MLX5_SET(set_action_in, action, data, fs_id | BIT(30));
+	MLX5_SET(set_action_in, action, data, MLX5_MACSEC_RX_METADAT_HANDLE(fs_id) | BIT(30));
 	MLX5_SET(set_action_in, action, offset, 0);
 	MLX5_SET(set_action_in, action, length, 32);
 
-- 
2.38.1

