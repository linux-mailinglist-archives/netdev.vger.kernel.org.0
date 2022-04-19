Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE44506885
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348616AbiDSKRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345410AbiDSKRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5A529CAA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ED38B81652
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C302C385A5;
        Tue, 19 Apr 2022 10:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363249;
        bh=dEfJvwdw3dLe8hjGLQErSCnc5nrRVR3ObYHtvx76YfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFwqJMlRZtlATZmoUUFK95sksM+z2j9puzIJkE3olAscI9bNX48rSS0TPzttEWY4q
         QUL25mKa3sGWrHZV0pVsOL5PS07veJ9B+HI+Iw2HOn6YDGSSO+JqyNVpH7nPIoVIPL
         6Ynzxh6YYEfI0uw32xhhCeFzIMol+/VFvljRwiaUuZTd+DQl49sgfqCgWNE7ahtfu9
         bccr07uicj1ETcp4Y/wxR/TzNskV0UrGmfU3joRmeYlgLy/qrMoHmjQPIjKOBzNKIN
         l6gBnPFPuVwurLd9qRf9dTl5kIEfSIPBxz/q71SMOtp0+/sgTpK9PoksFc4UCUyieM
         ydu5djNBkrcgw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 04/17] net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
Date:   Tue, 19 Apr 2022 13:13:40 +0300
Message-Id: <6d362755de8eb93430361544a7c941b114c7ce7e.1650363043.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363043.git.leonro@nvidia.com>
References: <cover.1650363043.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in one-liners wrappers to call internal functions.
Let's remove them, together with rename of functions to remove _accel_
notation from their names.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 25 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 +--
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index b04d5de91d87..251178e6e82b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -271,21 +271,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 	return 0;
 }
 
-static int mlx5e_xfrm_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	return mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
-					     sa_entry->ipsec_obj_id,
-					     &sa_entry->ipsec_rule);
-}
-
-static void mlx5e_xfrm_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
-				      &sa_entry->ipsec_rule);
-}
-
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
@@ -334,7 +319,9 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	}
 
 	sa_entry->ipsec_obj_id = sa_handle;
-	err = mlx5e_xfrm_fs_add_rule(priv, sa_entry);
+	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
+					    sa_entry->ipsec_obj_id,
+					    &sa_entry->ipsec_rule);
 	if (err)
 		goto err_hw_ctx;
 
@@ -351,7 +338,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_add_rule:
-	mlx5e_xfrm_fs_del_rule(priv, sa_entry);
+	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
+				      &sa_entry->ipsec_rule);
 err_hw_ctx:
 	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
 err_xfrm:
@@ -378,7 +366,8 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 
 	if (sa_entry->hw_context) {
 		flush_workqueue(sa_entry->ipsec->wq);
-		mlx5e_xfrm_fs_del_rule(priv, sa_entry);
+		mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
+					      &sa_entry->ipsec_rule);
 		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
 		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index f733a6e61196..bffad18a59d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -612,8 +612,8 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 }
 
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5_accel_esp_xfrm_attrs *attrs,
-				   struct mlx5e_ipsec_rule *ipsec_rule)
+			     struct mlx5_accel_esp_xfrm_attrs *attrs,
+			     struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		rx_del_rule(priv, attrs, ipsec_rule);
-- 
2.35.1

