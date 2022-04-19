Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D1450687B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiDSKQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239605AbiDSKQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5678622517
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E82E060DF8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40C0C385A7;
        Tue, 19 Apr 2022 10:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363242;
        bh=FVLNlYH5e5s6ZSi1P0tLCHLDQNgtemCSdZK/WINoRvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZcifEbYLsOSMOap/2ZtF6+lTu+La55z1CeDlwFi4uS1VOmhtn5x5ITHG5XRCn7ZR
         NQA3ak+6+G6T2PR9DInLitgz20BwLFZ501ZSPU5YAMGT5GrCRAj0mRsjqo2mVdj1Ny
         t7CMH7VPZ5yW3+WaZ6vgSjlSNyWBe7BNFQs7H0Qw1z0jf479nbMAJ3q1DCeG/GH6Je
         bwx4r9TRBOrQpanxmHgrNsn1bRbtnBW+1ZpgDaS5/xdvR6bJCTehZuMLtizxuZ/lkG
         cPS1g0/HqjsJ396R7/7D1qbgeRaeogNUhvyqiXzKyWKg4ifNQWM6vK6yIwREhMks7A
         2beoND0p0cwHA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 01/17] net/mlx5: Simplify IPsec flow steering init/cleanup functions
Date:   Tue, 19 Apr 2022 13:13:37 +0300
Message-Id: <60c7c87dd83c8e36f0b96027db1eb8a207f3753d.1650363043.git.leonro@nvidia.com>
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

Remove multiple function wrappers to make sure that IPsec FS initialization
and cleanup functions present one place to help with code readability.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 73 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |  4 +-
 3 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c280a18ff002..b6e430d53fae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -424,7 +424,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	}
 
 	priv->ipsec = ipsec;
-	mlx5e_accel_ipsec_fs_init(priv);
+	mlx5e_accel_ipsec_fs_init(ipsec);
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return 0;
 }
@@ -436,7 +436,7 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 	if (!ipsec)
 		return;
 
-	mlx5e_accel_ipsec_fs_cleanup(priv);
+	mlx5e_accel_ipsec_fs_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
 
 	kfree(ipsec);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 66b529e36ea1..029a9a70ba0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -632,81 +632,54 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 		tx_del_rule(priv, ipsec_rule);
 }
 
-static void fs_cleanup_tx(struct mlx5e_priv *priv)
-{
-	mutex_destroy(&priv->ipsec->tx_fs->mutex);
-	WARN_ON(priv->ipsec->tx_fs->refcnt);
-	kfree(priv->ipsec->tx_fs);
-	priv->ipsec->tx_fs = NULL;
-}
-
-static void fs_cleanup_rx(struct mlx5e_priv *priv)
+void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
 	enum accel_fs_esp_type i;
 
-	accel_esp = priv->ipsec->rx_fs;
+	if (!ipsec->rx_fs)
+		return;
+
+	mutex_destroy(&ipsec->tx_fs->mutex);
+	WARN_ON(ipsec->tx_fs->refcnt);
+	kfree(ipsec->tx_fs);
+
+	accel_esp = ipsec->rx_fs;
 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
 		fs_prot = &accel_esp->fs_prot[i];
 		mutex_destroy(&fs_prot->prot_mutex);
 		WARN_ON(fs_prot->refcnt);
 	}
-	kfree(priv->ipsec->rx_fs);
-	priv->ipsec->rx_fs = NULL;
-}
-
-static int fs_init_tx(struct mlx5e_priv *priv)
-{
-	priv->ipsec->tx_fs =
-		kzalloc(sizeof(struct mlx5e_ipsec_tx), GFP_KERNEL);
-	if (!priv->ipsec->tx_fs)
-		return -ENOMEM;
-
-	mutex_init(&priv->ipsec->tx_fs->mutex);
-	return 0;
+	kfree(ipsec->rx_fs);
 }
 
-static int fs_init_rx(struct mlx5e_priv *priv)
+int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
 	enum accel_fs_esp_type i;
+	int err = -ENOMEM;
 
-	priv->ipsec->rx_fs =
-		kzalloc(sizeof(struct mlx5e_accel_fs_esp), GFP_KERNEL);
-	if (!priv->ipsec->rx_fs)
+	ipsec->tx_fs = kzalloc(sizeof(*ipsec->tx_fs), GFP_KERNEL);
+	if (!ipsec->tx_fs)
 		return -ENOMEM;
 
-	accel_esp = priv->ipsec->rx_fs;
+	ipsec->rx_fs = kzalloc(sizeof(*ipsec->rx_fs), GFP_KERNEL);
+	if (!ipsec->rx_fs)
+		goto err_rx;
+
+	mutex_init(&ipsec->tx_fs->mutex);
+
+	accel_esp = ipsec->rx_fs;
 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
 		fs_prot = &accel_esp->fs_prot[i];
 		mutex_init(&fs_prot->prot_mutex);
 	}
 
 	return 0;
-}
-
-void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv)
-{
-	if (!priv->ipsec->rx_fs)
-		return;
-
-	fs_cleanup_tx(priv);
-	fs_cleanup_rx(priv);
-}
-
-int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv)
-{
-	int err;
-
-	err = fs_init_tx(priv);
-	if (err)
-		return err;
-
-	err = fs_init_rx(priv);
-	if (err)
-		fs_cleanup_tx(priv);
 
+err_rx:
+	kfree(ipsec->tx_fs);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
index b70953979709..e4eeb2ba21c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
@@ -9,8 +9,8 @@
 #include "ipsec_offload.h"
 #include "en/fs.h"
 
-void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv);
-int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv);
+void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
+int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 				  struct mlx5_accel_esp_xfrm_attrs *attrs,
 				  u32 ipsec_obj_id,
-- 
2.35.1

