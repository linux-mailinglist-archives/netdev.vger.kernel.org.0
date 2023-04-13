Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB04D6E174E
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDMWZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDMWZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE5C2108
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 15:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC19064206
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 22:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC60C433EF;
        Thu, 13 Apr 2023 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681424753;
        bh=lJ6fYg11JWUJZX9WaaT0GjpORV7HO2G6vlKDeXpyVqk=;
        h=From:To:Cc:Subject:Date:From;
        b=pIyQY+RlEzUJD/u638OBN7zs9ZqsjERwlV7YXtYiD+Y2sUGq6og3qXGNItAL7J4Z4
         8DjsryFxhLWhvUeQdZRwsHQ7Xq0MUlyBmFA/zvmED/VlNR3wBpJnvLyYG+J8wuxObr
         wnwUX7A/OfHpNGM0yXVqmKPz608N8R5VVXqJCTw98J7jnk8VQho387SAKPotqyjhbN
         TzEQXZOGV5GJao/KJZR+ogdWlzN5dMYgd/WjuBdVvmAocaZ4nScX2q/ChevDf/MBh1
         mJrTKcI//D2T3SkMuWwzJecNYeaz437asvjMK/q2bHW7YQ6nCc400QG58XCoWegxBA
         5Jk2CI90NKSMQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        paul@paul-moore.com, Jakub Kicinski <kuba@kernel.org>,
        saeedm@nvidia.com, leon@kernel.org, eranbe@nvidia.com,
        shayd@nvidia.com, moshe@nvidia.com
Subject: [PATCH net] Revert "net/mlx5: Enable management PF initialization"
Date:   Thu, 13 Apr 2023 15:25:47 -0700
Message-Id: <20230413222547.56901-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit fe998a3c77b9f989a30a2a01fb00d3729a6d53a4.

Paul reports that it causes a regression with IB on CX4
and FW 12.18.1000. In addition I think that the concept
of "management PF" is not fully accepted and requires
a discussion.

Fixes: fe998a3c77b9 ("net/mlx5: Enable management PF initialization")
Reported-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/all/CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: saeedm@nvidia.com
CC: leon@kernel.org
CC: eranbe@nvidia.com
CC: shayd@nvidia.com
CC: moshe@nvidia.com
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c     | 6 ------
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c    | 8 --------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 include/linux/mlx5/driver.h                       | 5 -----
 4 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 445fe30c3d0b..2e7806001fdc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -59,9 +59,6 @@ bool mlx5_eth_supported(struct mlx5_core_dev *dev)
 	if (!IS_ENABLED(CONFIG_MLX5_CORE_EN))
 		return false;
 
-	if (mlx5_core_is_management_pf(dev))
-		return false;
-
 	if (MLX5_CAP_GEN(dev, port_type) != MLX5_CAP_PORT_TYPE_ETH)
 		return false;
 
@@ -201,9 +198,6 @@ bool mlx5_rdma_supported(struct mlx5_core_dev *dev)
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return false;
 
-	if (mlx5_core_is_management_pf(dev))
-		return false;
-
 	if (dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_IB_ADEV)
 		return false;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index 7c9c4e40c019..d000236ddbac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -75,10 +75,6 @@ int mlx5_ec_init(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_ecpf(dev))
 		return 0;
 
-	/* Management PF don't have a peer PF */
-	if (mlx5_core_is_management_pf(dev))
-		return 0;
-
 	return mlx5_host_pf_init(dev);
 }
 
@@ -89,10 +85,6 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_ecpf(dev))
 		return;
 
-	/* Management PF don't have a peer PF */
-	if (mlx5_core_is_management_pf(dev))
-		return;
-
 	mlx5_host_pf_cleanup(dev);
 
 	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_HOST_PF]);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 8bdf28762f41..19fed514fc17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1488,7 +1488,7 @@ int mlx5_esw_sf_max_hpf_functions(struct mlx5_core_dev *dev, u16 *max_sfs, u16 *
 	void *hca_caps;
 	int err;
 
-	if (!mlx5_core_is_ecpf(dev) || mlx5_core_is_management_pf(dev)) {
+	if (!mlx5_core_is_ecpf(dev)) {
 		*max_sfs = 0;
 		return 0;
 	}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f33389b42209..7e225e41d55b 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1211,11 +1211,6 @@ static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
 	return dev->coredev_type == MLX5_COREDEV_VF;
 }
 
-static inline bool mlx5_core_is_management_pf(const struct mlx5_core_dev *dev)
-{
-	return MLX5_CAP_GEN(dev, num_ports) == 1 && !MLX5_CAP_GEN(dev, native_port_num);
-}
-
 static inline bool mlx5_core_is_ecpf(const struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
-- 
2.39.2

