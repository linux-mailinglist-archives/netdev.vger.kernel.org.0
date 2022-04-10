Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E4B4FACB9
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiDJIbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiDJIa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E340E58E4F;
        Sun, 10 Apr 2022 01:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62D6A60A77;
        Sun, 10 Apr 2022 08:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC31C385A4;
        Sun, 10 Apr 2022 08:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579325;
        bh=Jy0RlDm+jOs7OXRYJnkkcY5JQyMIauZlHPEl+FeeKnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e41LaCjjcfgiZG82lQCutCmkwj6ngtuvVGvBW7yaF5EzZICMETTKbhzA5p84JsodM
         VTw0vyC0Y84NQmXnEo75mK0xVBoqn9MU4MroGhGBSMcZqpzrpz5Qb/OEb3Us4NoRNX
         snywJveUlPSWJ6gkmv/XqPd1PrjXZhbBnTMfCXv1Soshs8RHd0duQiKEce2LU8foJb
         ldh1fbXgvWe+HUrnujz8lfwWSrThcOx7lMIs1zMVBDCZfTrkx71ozAJ7oyufnKt0Ow
         5rmQ+xiJN7yJMvGyOi502KTAQj5di+D4h8XTEmBkJntTapLFgoFIjGKS5HIPJokh4Z
         Q7hpRlIck5NSQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 01/17] net/mlx5: Simplify IPsec flow steering init/cleanup functions
Date:   Sun, 10 Apr 2022 11:28:19 +0300
Message-Id: <3f7001272e4dc51fcef031bf896a7e01a2b4b7f6.1649578827.git.leonro@nvidia.com>
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

Cleanup IPsec FS initialization and cleanup functions.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 73 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |  4 +-
 3 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c280a18ff002..5a10755dd4f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -424,7 +424,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	}
 
 	priv->ipsec = ipsec;
-	mlx5e_accel_ipsec_fs_init(priv);
+	mlx5e_ipsec_fs_init(ipsec);
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return 0;
 }
@@ -436,7 +436,7 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 	if (!ipsec)
 		return;
 
-	mlx5e_accel_ipsec_fs_cleanup(priv);
+	mlx5e_ipsec_fs_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
 
 	kfree(ipsec);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 66b529e36ea1..869b5692e9b9 100644
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
+void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
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
+int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
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
index b70953979709..8e0e829ab58f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
@@ -9,8 +9,8 @@
 #include "ipsec_offload.h"
 #include "en/fs.h"
 
-void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv);
-int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv);
+void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
+int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 				  struct mlx5_accel_esp_xfrm_attrs *attrs,
 				  u32 ipsec_obj_id,
-- 
2.35.1

