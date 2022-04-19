Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E35E506886
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350577AbiDSKRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347298AbiDSKQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:16:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1609225E93
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D1161157
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F508C385A7;
        Tue, 19 Apr 2022 10:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363246;
        bh=+DpDil2es04/F/BmX99OBbw34Gi6cW5luZnT3gqYMoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phyzHna0nZxttFs5hSnxkDIjoi2UGzBNDQLXYh9sUzmBokDp3WZUzjaall4W1gz3s
         STLMZtLNnkgbdD914J0IB9L6JOacnA69ZdrtTyh+ieZBZzR1ApDr6Ud7K0VKbLI3YL
         swoVBNw0FLVO8nJD+TJeHrQLbqdJy11od3Ot2G9u59drz0myE53pxNIt7z91X2AcoH
         OhUdJBVSeK86E4SLXr+ZL5wpmXj+2fCUlfBprNRz7+QbV3+z6VeMENcHv0asRKUG/B
         wrHesxcJzR70PGZFNjwmlJpeedHWfzalO0Zzb10zYKZHXnAf7qNfoOjR5WyNltAb+F
         3kel1YVtHiXzg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 02/17] net/mlx5: Check IPsec TX flow steering namespace in advance
Date:   Tue, 19 Apr 2022 13:13:38 +0300
Message-Id: <99d701638b435ace1ce0382d3073054554bf7b1f.1650363043.git.leonro@nvidia.com>
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

Ensure that flow steering is usable as early as possible, to understand
if crypto IPsec is supported or not.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
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
index b6e430d53fae..40700bf61924 100644
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
index 029a9a70ba0e..55fb6d4cf4ae 100644
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
@@ -658,9 +653,15 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
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
@@ -670,6 +671,7 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 		goto err_rx;
 
 	mutex_init(&ipsec->tx_fs->mutex);
+	ipsec->tx_fs->ns = ns;
 
 	accel_esp = ipsec->rx_fs;
 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
-- 
2.35.1

