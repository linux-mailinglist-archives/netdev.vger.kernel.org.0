Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E298663921
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjAJGM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjAJGMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:12:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250F244342
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3A1EB8110A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A649C433D2;
        Tue, 10 Jan 2023 06:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331111;
        bh=RWPaH8yDy9zHin8hDnHb9izfjKtFZZ1zhLC2BcAN3t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmzNSYuxHFSxUHCilyTc2rXvhasklv1HcrkfI9dHR9GdV/wCeo38IwGKPrZHCCSgk
         kA3OWMmG0pQu/3R/7Y24wJvIWoano0hrmzu62mGx/YW3MjP6iEc1DqckH+2dW67FOK
         e+G8YojWYyCswT2NS21HEnddSHLFSW7QW1gIYcNUDGtm8XQmH+Xc7IH454Qv1+Vkih
         f/TVMo/fLQzPitkfCBzALwjASSI68aR4x4JFd7VrvEsWm03k4p+5baxqdIdlpB97vQ
         3QtGWs8zxMQGR3zsEXtSy0Wk0CzFDMmJmrs3QoIb702JXooV18H279QBs3433U+a1r
         b8axTzkWySdIQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 15/16] net/mlx5e: Fix macsec ssci attribute handling in offload path
Date:   Mon,  9 Jan 2023 22:11:22 -0800
Message-Id: <20230110061123.338427-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currently when macsec offload is set with extended packet number (epn)
enabled, the driver wrongly deduce the short secure channel identifier
(ssci) from the salt instead of the stand alone ssci attribute as it
should, consequently creating a mismatch between the kernel and driver's
ssci values.
Fix by using the ssci value from the relevant attribute.

Fixes: 4411a6c0abd3 ("net/mlx5e: Support MACsec offload extended packet number (EPN)")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 9369a580743e..cf7b3bb54c86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -62,6 +62,7 @@ struct mlx5e_macsec_sa {
 	u32 enc_key_id;
 	u32 next_pn;
 	sci_t sci;
+	ssci_t ssci;
 	salt_t salt;
 
 	struct rhash_head hash;
@@ -499,10 +500,11 @@ mlx5e_macsec_get_macsec_device_context(const struct mlx5e_macsec *macsec,
 }
 
 static void update_macsec_epn(struct mlx5e_macsec_sa *sa, const struct macsec_key *key,
-			      const pn_t *next_pn_halves)
+			      const pn_t *next_pn_halves, ssci_t ssci)
 {
 	struct mlx5e_macsec_epn_state *epn_state = &sa->epn_state;
 
+	sa->ssci = ssci;
 	sa->salt = key->salt;
 	epn_state->epn_enabled = 1;
 	epn_state->epn_msb = next_pn_halves->upper;
@@ -550,7 +552,8 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 	tx_sa->assoc_num = assoc_num;
 
 	if (secy->xpn)
-		update_macsec_epn(tx_sa, &ctx_tx_sa->key, &ctx_tx_sa->next_pn_halves);
+		update_macsec_epn(tx_sa, &ctx_tx_sa->key, &ctx_tx_sa->next_pn_halves,
+				  ctx_tx_sa->ssci);
 
 	err = mlx5_create_encryption_key(mdev, ctx->sa.key, secy->key_len,
 					 MLX5_ACCEL_OBJ_MACSEC_KEY,
@@ -945,7 +948,8 @@ static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 	rx_sa->fs_id = rx_sc->sc_xarray_element->fs_id;
 
 	if (ctx->secy->xpn)
-		update_macsec_epn(rx_sa, &ctx_rx_sa->key, &ctx_rx_sa->next_pn_halves);
+		update_macsec_epn(rx_sa, &ctx_rx_sa->key, &ctx_rx_sa->next_pn_halves,
+				  ctx_rx_sa->ssci);
 
 	err = mlx5_create_encryption_key(mdev, ctx->sa.key, ctx->secy->key_len,
 					 MLX5_ACCEL_OBJ_MACSEC_KEY,
-- 
2.39.0

