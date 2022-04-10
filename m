Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EA04FACBB
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiDJIbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiDJIbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B912258E61;
        Sun, 10 Apr 2022 01:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A97AB80AF9;
        Sun, 10 Apr 2022 08:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D85C385A1;
        Sun, 10 Apr 2022 08:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579334;
        bh=131rVzeXj4dhq4o/Wlbt1e0VKf9lg55MYI8qjL1sTl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToT+oM8cFSTkJN2qVyR62FEIIPhX8AIkp5Wze3Zq/VrT6z0/NRY8e4qEhie+KB5c3
         xdjiTxtgi93sn0B5uXdwRjLW56NhVZia122aVXY4mrIDowSHIUAtM/hJWe/iVPFetZ
         zlyMviiNi1ovr+sBpixkCP7m0SbyU81O1L3Xmebjb4K6eX65CX0bQz4Rei2lpZu3G5
         yIZ8kU0EpISFAgml9rdY+qVV0ohzU5cDHZXSnc1QmZycDKhFR3goDfAFODqaqt56i2
         fDa5bhciO3LI3SJ101NsLA3Z7i9T6XNbSqUPX8GUOM9/ap039w5yshaLjR1+k4jxKs
         0QT2vhiaO7k1Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 02/17] net/mlx5: Check IPsec TX flow steering namespace in advance
Date:   Sun, 10 Apr 2022 11:28:20 +0300
Message-Id: <123bc1de57218089184a77465218d930997a8cf6.1649578827.git.leonro@nvidia.com>
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

Ensure that flow steering is usable as early as possible, to understand
if crypto IPsec is supported or not.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h  |  1 -
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c |  1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c       | 16 +++++++++-------
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 678ffbb48a25..4130a871de61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -164,7 +164,6 @@ struct mlx5e_ptp_fs;
 
 struct mlx5e_flow_steering {
 	struct mlx5_flow_namespace      *ns;
-	struct mlx5_flow_namespace      *egress_ns;
 #ifdef CONFIG_MLX5_EN_RXNFC
 	struct mlx5e_ethtool_steering   ethtool;
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 5a10755dd4f1..285ccb773de6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -415,6 +415,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 
 	hash_init(ipsec->sadb_rx);
 	spin_lock_init(&ipsec->sadb_rx_lock);
+	ipsec->mdev = priv->mdev;
 	ipsec->en_priv = priv;
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
 					    priv->netdev->name);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index a0e9dade09e9..bbf48d4616f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -61,6 +61,7 @@ struct mlx5e_accel_fs_esp;
 struct mlx5e_ipsec_tx;
 
 struct mlx5e_ipsec {
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *en_priv;
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 869b5692e9b9..66b8ead8b579 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -35,6 +35,7 @@ struct mlx5e_accel_fs_esp {
 };
 
 struct mlx5e_ipsec_tx {
+	struct mlx5_flow_namespace *ns;
 	struct mlx5_flow_table *ft;
 	struct mutex mutex; /* Protect IPsec TX steering */
 	u32 refcnt;
@@ -338,15 +339,9 @@ static int tx_create(struct mlx5e_priv *priv)
 	struct mlx5_flow_table *ft;
 	int err;
 
-	priv->fs.egress_ns =
-		mlx5_get_flow_namespace(priv->mdev,
-					MLX5_FLOW_NAMESPACE_EGRESS_KERNEL);
-	if (!priv->fs.egress_ns)
-		return -EOPNOTSUPP;
-
 	ft_attr.max_fte = NUM_IPSEC_FTE;
 	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs.egress_ns, &ft_attr);
+	ft = mlx5_create_auto_grouped_flow_table(ipsec->tx_fs->ns, &ft_attr);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		netdev_err(priv->netdev, "fail to create ipsec tx ft err=%d\n", err);
@@ -658,9 +653,15 @@ int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
+	struct mlx5_flow_namespace *ns;
 	enum accel_fs_esp_type i;
 	int err = -ENOMEM;
 
+	ns = mlx5_get_flow_namespace(ipsec->mdev,
+				     MLX5_FLOW_NAMESPACE_EGRESS_KERNEL);
+	if (!ns)
+		return -EOPNOTSUPP;
+
 	ipsec->tx_fs = kzalloc(sizeof(*ipsec->tx_fs), GFP_KERNEL);
 	if (!ipsec->tx_fs)
 		return -ENOMEM;
@@ -670,6 +671,7 @@ int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 		goto err_rx;
 
 	mutex_init(&ipsec->tx_fs->mutex);
+	ipsec->tx_fs->ns = ns;
 
 	accel_esp = ipsec->rx_fs;
 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
-- 
2.35.1

