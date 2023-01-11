Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC646653D3
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbjAKFjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236589AbjAKFiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D99F16
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C456161A30
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C038C433D2;
        Wed, 11 Jan 2023 05:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415058;
        bh=vCNax68yQVpsuqRCKHitVtKm57DYl4bJ/Ds8Z9WYoh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAGpAER8EheCm87iUfYqutrNzkio2vwUTRajKl8OTU/ncAr2E0KVyZDtA/VLpahGX
         7lhSMQ5DGzkn++KMqES94obPZEirFyRDda+pSn3tR7Xl42W1g4Q/eudZKjTSSNfD4P
         xXQWlb6JBS1Z6ZX5P3mWcPsFHljKgQUd0Xr/Rvvjz/ipv05MiqVrZodkB1Wo5OaB4r
         ks2+cAzdP8q2eKiz+4haEwrXsHbKxRSSPSpiIw2lcUKrBXHzoX/8dhxvOPrXyMqqZ0
         mXUKFYhyFu+xVMeaVoxBeIIvrwq59+/jxGZh8IRTdKCircPmpEVKO1fjCMKGp/vncP
         o4n/ECTKQ5yLA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 09/15] net/mlx5: Enable management PF initialization
Date:   Tue, 10 Jan 2023 21:30:39 -0800
Message-Id: <20230111053045.413133-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Enable initialization of DPU Management PF, which is a new loopback PF
designed for communication with BMC.
For now Management PF doesn't support nor require most upper layer
protocols so avoid them.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c     | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c    | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 include/linux/mlx5/driver.h                       | 5 +++++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 0571e40c6ee5..5b6b0b126e52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -59,6 +59,9 @@ bool mlx5_eth_supported(struct mlx5_core_dev *dev)
 	if (!IS_ENABLED(CONFIG_MLX5_CORE_EN))
 		return false;
 
+	if (mlx5_core_is_management_pf(dev))
+		return false;
+
 	if (MLX5_CAP_GEN(dev, port_type) != MLX5_CAP_PORT_TYPE_ETH)
 		return false;
 
@@ -198,6 +201,9 @@ bool mlx5_rdma_supported(struct mlx5_core_dev *dev)
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return false;
 
+	if (mlx5_core_is_management_pf(dev))
+		return false;
+
 	if (dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_IB_ADEV)
 		return false;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index 464eb3a18450..b70e36025d92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -75,6 +75,10 @@ int mlx5_ec_init(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_ecpf(dev))
 		return 0;
 
+	/* Management PF don't have a peer PF */
+	if (mlx5_core_is_management_pf(dev))
+		return 0;
+
 	return mlx5_host_pf_init(dev);
 }
 
@@ -85,6 +89,10 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_ecpf(dev))
 		return;
 
+	/* Management PF don't have a peer PF */
+	if (mlx5_core_is_management_pf(dev))
+		return;
+
 	mlx5_host_pf_cleanup(dev);
 
 	err = mlx5_wait_for_pages(dev, &dev->priv.host_pf_pages);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 0dfd5742c6fe..bbb6dab3b21f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1488,7 +1488,7 @@ int mlx5_esw_sf_max_hpf_functions(struct mlx5_core_dev *dev, u16 *max_sfs, u16 *
 	void *hca_caps;
 	int err;
 
-	if (!mlx5_core_is_ecpf(dev)) {
+	if (!mlx5_core_is_ecpf(dev) || mlx5_core_is_management_pf(dev)) {
 		*max_sfs = 0;
 		return 0;
 	}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0c4f6acf59ca..50a5780367fa 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1202,6 +1202,11 @@ static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
 	return dev->coredev_type == MLX5_COREDEV_VF;
 }
 
+static inline bool mlx5_core_is_management_pf(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, num_ports) == 1 && !MLX5_CAP_GEN(dev, native_port_num);
+}
+
 static inline bool mlx5_core_is_ecpf(const struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
-- 
2.39.0

