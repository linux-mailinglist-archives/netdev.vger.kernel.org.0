Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAB24FACB4
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbiDJIbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiDJIbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6FA58E61;
        Sun, 10 Apr 2022 01:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C15060EF2;
        Sun, 10 Apr 2022 08:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747FDC385A4;
        Sun, 10 Apr 2022 08:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579330;
        bh=fT8/zZxxOVTdZU3in93mCS+LUJa7xFiR5b2ZdSMmkG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQVgaYcNcmFibr1A9MSZvBoix65gzMHwQGXDwZ5q951yi1JdDherZ3cDhushvY7mh
         2svb0pCkLBAFflCc4VCVH8bff+0DVnlCJNPn7ogjGwDyjQA1Fj8ASUB4K9jP3jt4vh
         kNfJ8IEQQGJEmeG6kbTKalgEDNzgk/OxxUU1sICC+KfMjIyV25HxOlAbDdVFguH2EU
         f4p6KScQdsK5z/lRgRXJfIhyr8gvI/hr7jSKSWDAkhBRo6TmoNCtpulH9vStX6BPtR
         ttV2HZksigBXZXj/TvUNcGD9rMljuBsOXM73rcMSizEBZyTHkTcU+GkJCOj/ZCozd/
         Rek4Rab4TUWRQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 03/17] net/mlx5: Don't hide fallback to software IPsec in FS code
Date:   Sun, 10 Apr 2022 11:28:21 +0300
Message-Id: <a3c54b79647bec0b60b736adf99174e06a309d02.1649578827.git.leonro@nvidia.com>
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
index 285ccb773de6..be30b6e2a00f 100644
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
 
+	ret = mlx5e_ipsec_fs_init(ipsec);
+	if (ret)
+		goto err_fs_init;
+
 	priv->ipsec = ipsec;
-	mlx5e_ipsec_fs_init(ipsec);
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
index 66b8ead8b579..dcc6ff0fc521 100644
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

