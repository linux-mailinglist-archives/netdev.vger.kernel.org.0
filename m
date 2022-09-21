Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2DD5BFF40
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiIUNwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiIUNvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:51:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443D38672C
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:51:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DA896300B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B512C433D6;
        Wed, 21 Sep 2022 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663768299;
        bh=BBouAnUEy/rokGu/m2EUwiDW1ZUfc+drijmnGJp/H5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDH/8XWAH8lVx81/JSZfuELwrEE6f3Mlm7klimZevwwj7iD6IUCjGju00CMa5Ealp
         KsmFlcoc0sKh3D7CVg6avIU6Tm5OZGHcxV2oBgVoaRB0LShO++lh0+UvUqIbI+edh5
         cB9UAGWZijKebVj5YswTVskiV3G5J2JH1HZS+5utseonLIUsQUQV4v1cFFUqcyGnOw
         u5E9N2NHWY1VgIBo33PHUvjvAYOb9X0IIL+wGhKSNyLSjHsXAMFIFwapQyTNNX30Kh
         3XPqpVD5ogRV9FJtdyLB/JDwpp1esn6NsM0qU7lKhDJcyekhN29owEXzAQbyhD1cCJ
         dL0QRbDLthpNg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, sundeep.lkml@gmail.com,
        saeedm@nvidia.com, liorna@nvidia.com, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com,
        sd@queasysnail.net, netdev@vger.kernel.org
Subject: [PATCH net-next 6/7] net/mlx5e: macsec: remove checks on the prepare phase
Date:   Wed, 21 Sep 2022 15:51:17 +0200
Message-Id: <20220921135118.968595-7-atenart@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921135118.968595-1-atenart@kernel.org>
References: <20220921135118.968595-1-atenart@kernel.org>
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

Remove checks on the prepare phase as it is now unused by the MACsec
core implementation.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 36 -------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index ea362072a984..c33e9ffe8b57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -321,9 +321,6 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 	struct mlx5e_macsec *macsec;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
@@ -393,9 +390,6 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 	struct net_device *netdev;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
@@ -456,9 +450,6 @@ static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 	struct mlx5e_macsec *macsec;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 	macsec = priv->macsec;
 	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
@@ -511,9 +502,6 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 	struct mlx5e_macsec *macsec;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 	macsec = priv->macsec;
 	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
@@ -591,9 +579,6 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 	int i;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
@@ -642,9 +627,6 @@ static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 	int err = 0;
 	int i;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
@@ -710,9 +692,6 @@ static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 	struct list_head *list;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
@@ -794,9 +773,6 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 	struct list_head *list;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
@@ -853,9 +829,6 @@ static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 	struct list_head *list;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 
 	macsec = priv->macsec;
@@ -905,9 +878,6 @@ static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 	struct mlx5e_macsec *macsec;
 	int err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (!mlx5e_macsec_secy_features_validate(ctx))
 		return -EINVAL;
 
@@ -1008,9 +978,6 @@ static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 	struct mlx5e_macsec *macsec;
 	int i, err = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (!mlx5e_macsec_secy_features_validate(ctx))
 		return -EINVAL;
 
@@ -1069,9 +1036,6 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 	int err = 0;
 	int i;
 
-	if (ctx->prepare)
-		return 0;
-
 	mutex_lock(&priv->macsec->lock);
 	macsec = priv->macsec;
 	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
-- 
2.37.3

