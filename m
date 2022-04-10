Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164E04FACB6
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiDJIbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiDJIbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11676261;
        Sun, 10 Apr 2022 01:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ACCEB80B00;
        Sun, 10 Apr 2022 08:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1BFC385A1;
        Sun, 10 Apr 2022 08:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579338;
        bh=JzhcExK73bxwPt/6y+3hgq/CESu7MEE2W0oR1RMrLiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoQsewPxxKItatDyRzycTXE+/iHBehLy2LpPrj52JBSbRDpuVmGKBsClRno50k9bz
         1ExHH1OGIATsfUiYZFibgpkk1f+hOct8qLrjb9LshlRZPrMXJBHm2i6Of1+dRxbj8p
         of0j4Q1x8gBA6VApDNqiQyNgSJuxKF7vNfSzaqeF2RwdpNDFSGkERoKCoZwzZgktRa
         /QfMR+3OYgqdFd8loKEcl4OAeLu5dziphOFxF3+bNTzkr92akDb0fNmETlAyrhJgSo
         acbDeQ9IFj275ifXuLJlB0mhMMCIo5Cim0GhAzffeiwHL7iwu4D6ZWvnMoLX5GY/EX
         G9mT4Tyda6zFA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 04/17] net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
Date:   Sun, 10 Apr 2022 11:28:22 +0300
Message-Id: <573cebbc9915839cb6d89a7a1fb90ef80c2a5ab3.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in one-liners wrappers to call internal functions.
Let's remove them, together with rename of functions to remove _accel_
notation from their names.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 25 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 14 +++++------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    | 14 +++++------
 3 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index be30b6e2a00f..7f8aad4cad18 100644
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
+	err = mlx5e_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
+				      sa_entry->ipsec_obj_id,
+				      &sa_entry->ipsec_rule);
 	if (err)
 		goto err_hw_ctx;
 
@@ -351,7 +338,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_add_rule:
-	mlx5e_xfrm_fs_del_rule(priv, sa_entry);
+	mlx5e_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
+				&sa_entry->ipsec_rule);
 err_hw_ctx:
 	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
 err_xfrm:
@@ -378,7 +366,8 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 
 	if (sa_entry->hw_context) {
 		flush_workqueue(sa_entry->ipsec->wq);
-		mlx5e_xfrm_fs_del_rule(priv, sa_entry);
+		mlx5e_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
+					&sa_entry->ipsec_rule);
 		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
 		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index dcc6ff0fc521..3b715da86e6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -600,10 +600,10 @@ static void tx_del_rule(struct mlx5e_priv *priv,
 	tx_ft_put(priv);
 }
 
-int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5_accel_esp_xfrm_attrs *attrs,
-				  u32 ipsec_obj_id,
-				  struct mlx5e_ipsec_rule *ipsec_rule)
+int mlx5e_ipsec_fs_add_rule(struct mlx5e_priv *priv,
+			    struct mlx5_accel_esp_xfrm_attrs *attrs,
+			    u32 ipsec_obj_id,
+			    struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
@@ -611,9 +611,9 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 		return tx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
 }
 
-void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5_accel_esp_xfrm_attrs *attrs,
-				   struct mlx5e_ipsec_rule *ipsec_rule)
+void mlx5e_ipsec_fs_del_rule(struct mlx5e_priv *priv,
+			     struct mlx5_accel_esp_xfrm_attrs *attrs,
+			     struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		rx_del_rule(priv, attrs, ipsec_rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
index 8e0e829ab58f..011af408ee03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
@@ -11,11 +11,11 @@
 
 void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
 int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
-int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5_accel_esp_xfrm_attrs *attrs,
-				  u32 ipsec_obj_id,
-				  struct mlx5e_ipsec_rule *ipsec_rule);
-void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5_accel_esp_xfrm_attrs *attrs,
-				   struct mlx5e_ipsec_rule *ipsec_rule);
+int mlx5e_ipsec_fs_add_rule(struct mlx5e_priv *priv,
+			    struct mlx5_accel_esp_xfrm_attrs *attrs,
+			    u32 ipsec_obj_id,
+			    struct mlx5e_ipsec_rule *ipsec_rule);
+void mlx5e_ipsec_fs_del_rule(struct mlx5e_priv *priv,
+			     struct mlx5_accel_esp_xfrm_attrs *attrs,
+			     struct mlx5e_ipsec_rule *ipsec_rule);
 #endif /* __MLX5_IPSEC_STEERING_H__ */
-- 
2.35.1

