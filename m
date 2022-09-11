Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1110D5B5202
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 01:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiIKXmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 19:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiIKXl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 19:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1E2275C3
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 16:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 728CF61128
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50318C433C1;
        Sun, 11 Sep 2022 23:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662939702;
        bh=ZeBEBXBBPMyOlZnQ8pKNDMLa80JfWYMdwawEeUuC+wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXnyEXNGF9iUKrQ3+mwkascUsiGR7Gwnhd/PqMCpsH9EKhs36qdWGD7swTgs7/vGc
         1Ww/ex19S5dDm2YB7dfDV4tbyu7MzZK9fEV9aps0a3W1SObv8z7elIH6fjXivTHFjs
         Qew6T3RfnGKjzyrq/yXKYfXF9P807yuD4GHOXnfsH/HpyVSoaRN95WmE73KTGbWWxT
         sYm3ZtvqFMUNpdf7oK5OsDrrVx2GMpeiUb6MI9h5dS+KrQaj3W5u90IgcJE2PGDORq
         UAPvFD57uGgMd37RUJF99SrQSdkKky/BsXrl0l3SoRmBSWDGB+ygQRhjU5n+KkdhD+
         znGFNSGrvfmcQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next 08/10] net/mlx5e: Move MACsec initialization from profile init stage to profile enable stage
Date:   Mon, 12 Sep 2022 00:40:57 +0100
Message-Id: <20220911234059.98624-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220911234059.98624-1-saeed@kernel.org>
References: <20220911234059.98624-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Postpone MACsec initialization to the mlx5e profile enable stage to have
user access region (UAR) pages and other resources ready before MACsec
initialization to initialize advanced steering operation (ASO) hardware
resources.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 905025a10a8a..4503de92ac80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5055,10 +5055,6 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	}
 	priv->fs = fs;
 
-	err = mlx5e_macsec_init(priv);
-	if (err)
-		mlx5_core_err(mdev, "MACsec initialization failed, %d\n", err);
-
 	err = mlx5e_ipsec_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
@@ -5076,7 +5072,6 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_ktls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
-	mlx5e_macsec_cleanup(priv);
 	mlx5e_fs_cleanup(priv->fs);
 }
 
@@ -5202,9 +5197,14 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
+	int err;
 
 	mlx5e_fs_init_l2_addr(priv->fs, netdev);
 
+	err = mlx5e_macsec_init(priv);
+	if (err)
+		mlx5_core_err(mdev, "MACsec initialization failed, %d\n", err);
+
 	/* Marking the link as currently not needed by the Driver */
 	if (!netif_running(netdev))
 		mlx5e_modify_admin_state(mdev, MLX5_PORT_DOWN);
@@ -5262,6 +5262,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	mlx5e_disable_async_events(priv);
 	mlx5_lag_remove_netdev(mdev, priv->netdev);
 	mlx5_vxlan_reset_to_default(mdev->vxlan);
+	mlx5e_macsec_cleanup(priv);
 }
 
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
-- 
2.37.3

