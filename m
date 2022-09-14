Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E847B5B8D03
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiINQ3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiINQ2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:28:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9291C85FA6
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:27:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D8B7B8171B
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 16:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B727BC433C1;
        Wed, 14 Sep 2022 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663172871;
        bh=ZeBEBXBBPMyOlZnQ8pKNDMLa80JfWYMdwawEeUuC+wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jt315etdayZGfjoGgiMhjPc05TkLR7q20bJM+JQjinnWACKl3BNRa7f7uZKSmFniK
         jgxC/OQnbA3XF4iDK/4qWWHlko1KUDJzDWsJfsg2AVRi2XDyRsfr23mp9wFJ5xzByZ
         OHVa5pSWtXeLnsPSWxlTePO2jHeImoTw3lZ5Ij1L0Ksm4TBkJiAiJzpgtXhpmd6jQY
         bm8BoZXaLzcfUdibtZBG50USoxjfIePlrysDhqP5rZQ64D8tB/vZ04nKNmXyBseNq6
         vVUAUMUtUTUjSKIyu84oiquBtHf7AKVROa6yr/E3nJi9Cj2dEa8S+zL8AIhlBt+Aco
         7BPujka/VW2BQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 08/10] net/mlx5e: Move MACsec initialization from profile init stage to profile enable stage
Date:   Wed, 14 Sep 2022 17:27:11 +0100
Message-Id: <20220914162713.203571-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220914162713.203571-1-saeed@kernel.org>
References: <20220914162713.203571-1-saeed@kernel.org>
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

