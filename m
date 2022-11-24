Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DF8637368
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiKXILb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiKXILP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D921DDFB5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AD5D61FF5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACDDC433C1;
        Thu, 24 Nov 2022 08:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277464;
        bh=gpPBakRdY217DwKyscVomXMsbuVw9o8HWWPr0eiMes4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YnlSsVwd1LmAMt0Y91SW6JGTAgfAloDngRTOxFoljAAFBr4I2zomlXjn+jmCJExCV
         Dtje6ja13JmHXfqDqAA+rdYRfOCKiTpslKBgR9E+32iWeVJk2JCrfp1FHrJC+j/qL+
         IXQ0KzaOi+y3qheCAspvotw2H/VjN9DypmKltPWZqWguMNoQiqkhKdUY53ORN6wxio
         WadJxsvOuafLf46jsbz+tS6pIDjYZigLWwDuBN9yUhYsyXuMC2P38i5ZXipXCPpIJ/
         uz/8vPcw9teKE8fT+LABVuO6cGZM1kXBVPOoHDjRLw+Q4v4JJL3Ycl1wEsPB+2jOIw
         ZfMnn1hG1QB4w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [net 11/15] net/mlx5e: MACsec, fix mlx5e_macsec_update_rxsa bail condition and functionality
Date:   Thu, 24 Nov 2022 00:10:36 -0800
Message-Id: <20221124081040.171790-12-saeed@kernel.org>
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

Fix update Rx SA wrong bail condition, naturally update functionality
needs to check that something changed otherwise bailout currently the
active state check does just the opposite, furthermore unlike deactivate
path which remove the macsec rules to deactivate the offload, the
activation path does not include the counter part installation of the
macsec rules.

Fix by using correct bailout condition and when Rx SA changes state to
active then add the relevant macsec rules.

While at it, refine function name to reflect more precisely its role.

Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 24 +++++++++----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 9c891a877998..c19581f1f733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -427,15 +427,15 @@ mlx5e_macsec_get_rx_sc_from_sc_list(const struct list_head *list, sci_t sci)
 	return NULL;
 }
 
-static int mlx5e_macsec_update_rx_sa(struct mlx5e_macsec *macsec,
-				     struct mlx5e_macsec_sa *rx_sa,
-				     bool active)
+static int macsec_rx_sa_active_update(struct macsec_context *ctx,
+				      struct mlx5e_macsec_sa *rx_sa,
+				      bool active)
 {
-	struct mlx5_core_dev *mdev = macsec->mdev;
-	struct mlx5_macsec_obj_attrs attrs = {};
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec *macsec = priv->macsec;
 	int err = 0;
 
-	if (rx_sa->active != active)
+	if (rx_sa->active == active)
 		return 0;
 
 	rx_sa->active = active;
@@ -444,13 +444,11 @@ static int mlx5e_macsec_update_rx_sa(struct mlx5e_macsec *macsec,
 		return 0;
 	}
 
-	attrs.sci = cpu_to_be64((__force u64)rx_sa->sci);
-	attrs.enc_key_id = rx_sa->enc_key_id;
-	err = mlx5e_macsec_create_object(mdev, &attrs, false, &rx_sa->macsec_obj_id);
+	err = mlx5e_macsec_init_sa(ctx, rx_sa, true, false);
 	if (err)
-		return err;
+		rx_sa->active = false;
 
-	return 0;
+	return err;
 }
 
 static bool mlx5e_macsec_secy_features_validate(struct macsec_context *ctx)
@@ -812,7 +810,7 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 		if (!rx_sa)
 			continue;
 
-		err = mlx5e_macsec_update_rx_sa(macsec, rx_sa, rx_sa->active && ctx_rx_sc->active);
+		err = macsec_rx_sa_active_update(ctx, rx_sa, rx_sa->active && ctx_rx_sc->active);
 		if (err)
 			goto out;
 	}
@@ -1023,7 +1021,7 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 		goto out;
 	}
 
-	err = mlx5e_macsec_update_rx_sa(macsec, rx_sa, ctx_rx_sa->active);
+	err = macsec_rx_sa_active_update(ctx, rx_sa, ctx_rx_sa->active);
 out:
 	mutex_unlock(&macsec->lock);
 
-- 
2.38.1

