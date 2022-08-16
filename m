Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5929F595830
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiHPK2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiHPK10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:27:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC698E089
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0D00B81661
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1891C433C1;
        Tue, 16 Aug 2022 08:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660639656;
        bh=Kx4qBNCc7R/7q8MhhpEHs06umv65XKuQ2khConZ/28k=;
        h=From:To:Cc:Subject:Date:From;
        b=g8f/1bO5IBOPY296fMvnwZ5JBfF7TX3N2HAxhJn3ja5EoaNvhz16cV5rF9GCBCJ/A
         AANu1UkF9chHMYBIL95EoVRqBM69Elbc8/PqZ7KkqFTMdXM7Qkq4KOJol+5WUfWUA+
         MBr8fwfBu3wdoXgjPv+AO1QXd35m79p5OgSIdOyWw6vjf6Ggc8Dmx1Gj4XD3lzm9nd
         Est4Oc0EswOW93588Gw1WLT5C/cdcHX9Qe5FWrb2slz0WwKcCnsJqz2DOGgMwV6v01
         HHbMDH3s888YQZEhLMVk3wQE6TJHJj2JOA0Q89psFJiTCKrDDmXNWkZkQY3bHtGGVl
         B1AJMRdFaW3Ow==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Lama Kayal <lkayal@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Allocate flow steering storage during uplink initialization
Date:   Tue, 16 Aug 2022 11:47:23 +0300
Message-Id: <ae46fa5bed3c67f937bfdfc0370101278f5422f1.1660639564.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
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

IPsec code relies on valid priv->fs pointer that is the case in NIC
flow, but not correct in uplink. Before commit that mentioned in the
Fixes line, that pointer was valid in all flows as it was allocated
together with priv struct.

In addition, the cleanup representors routine called to that
not-initialized priv->fs pointer and its internals which caused NULL
deference.

So, move FS allocation to be as early as possible.

Fixes: af8bbf730068 ("net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4c1599de652c..0c66774a1720 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -696,6 +696,13 @@ static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
+	priv->fs = mlx5e_fs_init(priv->profile, mdev,
+				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+	if (!priv->fs) {
+		netdev_err(priv->netdev, "FS allocation failed\n");
+		return -ENOMEM;
+	}
+
 	mlx5e_build_rep_params(netdev);
 	mlx5e_timestamp_init(priv);
 
@@ -708,12 +715,21 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	int err;
 
+	priv->fs = mlx5e_fs_init(priv->profile, mdev,
+				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+	if (!priv->fs) {
+		netdev_err(priv->netdev, "FS allocation failed\n");
+		return -ENOMEM;
+	}
+
 	err = mlx5e_ipsec_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "Uplink rep IPsec initialization failed, %d\n", err);
 
 	mlx5e_vxlan_set_netdev_info(priv);
-	return mlx5e_init_rep(mdev, netdev);
+	mlx5e_build_rep_params(netdev);
+	mlx5e_timestamp_init(priv);
+	return 0;
 }
 
 static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
@@ -836,13 +852,6 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	priv->fs = mlx5e_fs_init(priv->profile, mdev,
-				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
-	if (!priv->fs) {
-		netdev_err(priv->netdev, "FS allocation failed\n");
-		return -ENOMEM;
-	}
-
 	priv->rx_res = mlx5e_rx_res_alloc();
 	if (!priv->rx_res) {
 		err = -ENOMEM;
-- 
2.37.2

