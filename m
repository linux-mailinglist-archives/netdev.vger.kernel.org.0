Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147E3506882
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350580AbiDSKRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350016AbiDSKRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E860C2AC7A
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A87F60FE4
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F6FC385A5;
        Tue, 19 Apr 2022 10:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363257;
        bh=sJP/8frb0tc/3D99dpaNAtF5x6n3N3yzo+juKd2sl/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyeHQ2s6/DfYakxZ1kw/2PvBC+8PKmVulJnt/0xNzcp9ty6jMz9OIMACVZFj9VmJD
         gZ2KLzpwGR3Rxm/LBtwtgIP/fyqkzFxJnwcn7lfUmTaPh3Q2k2B01qi37icZyv+46b
         Y4sVpM/+7BUGaJYGo4XVIQFOHGbVPMJqcJCQiJNT5RaFvnqAmrleb4jfKGtFOq7PVx
         VA/+JEin/1mBdQMHEwi6MY5LlXFdRm6XMJLHJS2zGHdcsugqx1877rQj3fAWC4wSbQ
         Rdyjl8JCid1TaE/dLZ8BjR3Bud8EleamoEJlWYcEzFA57NyV55nqP0M0tzGZXajI11
         o4VJmH3x0qQ+g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 03/17] net/mlx5: Don't hide fallback to software IPsec in FS code
Date:   Tue, 19 Apr 2022 13:13:39 +0300
Message-Id: <7d47bc40d60f580d692789bfd0bf784d481edd24.1650363043.git.leonro@nvidia.com>
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

The XFRM code performs fallback to software IPsec if .xdo_dev_state_add()
returns -EOPNOTSUPP. This is what mlx5 did very deep in its stack trace,
despite have all the knowledge that IPsec is not going to work in very
early stage.

This is achieved by making sure that priv->ipsec pointer is valid for
fully working and supported hardware crypto IPsec engine.

In case, the hardware IPsec is not supported, the XFRM code will set NULL
to xso->dev and it will prevent from calls to various .xdo_dev_state_*()
callbacks.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 41 ++++++++-----------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  6 ---
 2 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 40700bf61924..b04d5de91d87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -43,17 +43,7 @@
 
 static struct mlx5e_ipsec_sa_entry *to_ipsec_sa_entry(struct xfrm_state *x)
 {
-	struct mlx5e_ipsec_sa_entry *sa;
-
-	if (!x)
-		return NULL;
-
-	sa = (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
-	if (!sa)
-		return NULL;
-
-	WARN_ON(sa->x != x);
-	return sa;
+	return (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
 }
 
 struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *ipsec,
@@ -306,6 +296,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	int err;
 
 	priv = netdev_priv(netdev);
+	if (!priv->ipsec)
+		return -EOPNOTSUPP;
 
 	err = mlx5e_xfrm_validate_state(x);
 	if (err)
@@ -375,9 +367,6 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 
-	if (!sa_entry)
-		return;
-
 	if (x->xso.flags & XFRM_OFFLOAD_INBOUND)
 		mlx5e_ipsec_sadb_rx_del(sa_entry);
 }
@@ -387,9 +376,6 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
-	if (!sa_entry)
-		return;
-
 	if (sa_entry->hw_context) {
 		flush_workqueue(sa_entry->ipsec->wq);
 		mlx5e_xfrm_fs_del_rule(priv, sa_entry);
@@ -402,7 +388,8 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 
 int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
-	struct mlx5e_ipsec *ipsec = NULL;
+	struct mlx5e_ipsec *ipsec;
+	int ret;
 
 	if (!mlx5_ipsec_device_caps(priv->mdev)) {
 		netdev_dbg(priv->netdev, "Not an IPSec offload device\n");
@@ -420,14 +407,23 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
 					    priv->netdev->name);
 	if (!ipsec->wq) {
-		kfree(ipsec);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_wq;
 	}
 
+	ret = mlx5e_accel_ipsec_fs_init(ipsec);
+	if (ret)
+		goto err_fs_init;
+
 	priv->ipsec = ipsec;
-	mlx5e_accel_ipsec_fs_init(ipsec);
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return 0;
+
+err_fs_init:
+	destroy_workqueue(ipsec->wq);
+err_wq:
+	kfree(ipsec);
+	return (ret != -EOPNOTSUPP) ? ret : 0;
 }
 
 void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
@@ -487,9 +483,6 @@ static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 	struct mlx5e_ipsec_modify_state_work *modify_work;
 	bool need_update;
 
-	if (!sa_entry)
-		return;
-
 	need_update = mlx5e_ipsec_update_esn_state(sa_entry);
 	if (!need_update)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 55fb6d4cf4ae..f733a6e61196 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -605,9 +605,6 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 				  u32 ipsec_obj_id,
 				  struct mlx5e_ipsec_rule *ipsec_rule)
 {
-	if (!priv->ipsec->rx_fs)
-		return -EOPNOTSUPP;
-
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
 	else
@@ -618,9 +615,6 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 				   struct mlx5_accel_esp_xfrm_attrs *attrs,
 				   struct mlx5e_ipsec_rule *ipsec_rule)
 {
-	if (!priv->ipsec->rx_fs)
-		return;
-
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		rx_del_rule(priv, attrs, ipsec_rule);
 	else
-- 
2.35.1

