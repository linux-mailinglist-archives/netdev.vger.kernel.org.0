Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C066F58473D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiG1UrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiG1UrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:47:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C9A6C10D
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DB1761403
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB91AC433C1;
        Thu, 28 Jul 2022 20:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041219;
        bh=LC1N6Q9Md3CPasWjcvwl9rCG2mwzC4Qw47aJmo8tJEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6pGnjhFpUVtnxNgBK5WdaLQg12CDjvV73Js3YjbBUeSKPJa3WvpJr0TtHmloE7LE
         Gg3A/gH+oNbSPa2UOSSCsN3fuw7W8sWtZTYd+lsso3O2nM4DGkSSSIcjygIVpRjTj6
         NCgOErrGjRPIro6Oz8wgkGhF4Eb/BUmG/+Q/cVae4TDaoexnQYkchXL7LkfJvp3S2S
         s2kd3o4yEOsG7ZqD586MNywpmM+/AB8xAmKptCYJ4QIOlJ96pqquREgXc0CISvfLD7
         7LCOVSey19wfwODQG7dc7+11XbYn9MBDO2GiYQYHC3WdYXSkU5tNcm73iY1REGkPWY
         50IjXNQpV6Hxg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net 9/9] net/mlx5: Fix driver use of uninitialized timeout
Date:   Thu, 28 Jul 2022 13:46:40 -0700
Message-Id: <20220728204640.139990-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728204640.139990-1-saeed@kernel.org>
References: <20220728204640.139990-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, driver is setting default values to all timeouts during
function setup. The offending commit is using a timeout before
function setup, meaning: the timeout is 0 (or garbage), since no
value have been set.
This may result in failure to probe the driver:
mlx5_function_setup:1034:(pid 69850): Firmware over 4294967296 MS in pre-initializing state, aborting
probe_one:1591:(pid 69850): mlx5_init_one failed with error code -16

Hence, set default values to timeouts during tout_init()

Fixes: 37ca95e62ee2 ("net/mlx5: Increase FW pre-init timeout for health recovery")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c | 11 ++++-------
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  2 --
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
index d758848d34d0..696e45e2bd06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
@@ -32,20 +32,17 @@ static void tout_set(struct mlx5_core_dev *dev, u64 val, enum mlx5_timeouts_type
 	dev->timeouts->to[type] = val;
 }
 
-void mlx5_tout_set_def_val(struct mlx5_core_dev *dev)
+int mlx5_tout_init(struct mlx5_core_dev *dev)
 {
 	int i;
 
-	for (i = 0; i < MAX_TIMEOUT_TYPES; i++)
-		tout_set(dev, tout_def_sw_val[i], i);
-}
-
-int mlx5_tout_init(struct mlx5_core_dev *dev)
-{
 	dev->timeouts = kmalloc(sizeof(*dev->timeouts), GFP_KERNEL);
 	if (!dev->timeouts)
 		return -ENOMEM;
 
+	for (i = 0; i < MAX_TIMEOUT_TYPES; i++)
+		tout_set(dev, tout_def_sw_val[i], i);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
index 257c03eeab36..bc9e9aeda847 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
@@ -35,7 +35,6 @@ int mlx5_tout_init(struct mlx5_core_dev *dev);
 void mlx5_tout_cleanup(struct mlx5_core_dev *dev);
 void mlx5_tout_query_iseg(struct mlx5_core_dev *dev);
 int mlx5_tout_query_dtor(struct mlx5_core_dev *dev);
-void mlx5_tout_set_def_val(struct mlx5_core_dev *dev);
 u64 _mlx5_tout_ms(struct mlx5_core_dev *dev, enum mlx5_timeouts_types type);
 
 #define mlx5_tout_ms(dev, type) _mlx5_tout_ms(dev, MLX5_TO_##type##_MS)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 95f26624b57c..ba2e5232b90b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1023,8 +1023,6 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, u64 timeout)
 	if (mlx5_core_is_pf(dev))
 		pcie_print_link_status(dev->pdev);
 
-	mlx5_tout_set_def_val(dev);
-
 	/* wait for firmware to accept initialization segments configurations
 	 */
 	err = wait_fw_init(dev, timeout,
-- 
2.37.1

