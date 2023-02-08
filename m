Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F37F68E669
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjBHDD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjBHDDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368723D0A4
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A93236148F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBEFC433D2;
        Wed,  8 Feb 2023 03:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825399;
        bh=CQr5Mil6XePuKiYqb7SeyXpgH53XWwVBF8pefjIPtZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HR2kx24ubUNDdh996mYxxiNXUvGTEb++nVt7NK5EuKvgt159ytGb9Qu/doTZB2JVb
         Bi2ghHKoPdUFBQci0pnCOJLq26aE4MDVgzsBN8lKn2u7l/I1gYIvFAI0r7RCEJ1n7t
         d8HlQyNmP/7QEqkfSYTA561AF822XeFOLInxVESO8glKJLYEGch3TrSJpgHY4lIoyX
         0PU3uB1boXAe6bQInnXeIDa4Uzg2mmo5DAVUfXVm6ijRKlFlyfewqBGvsf8/HyHaVH
         JeuyQSx93iTKn+/cqz0IKg2y4sHThAx75hLZOg7vGhh3lnRSwcosich7omn24QU/At
         EZYGnXiN1gHYg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net 10/10] net/mlx5: Serialize module cleanup with reload and remove
Date:   Tue,  7 Feb 2023 19:03:02 -0800
Message-Id: <20230208030302.95378-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
References: <20230208030302.95378-1-saeed@kernel.org>
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

Currently, remove and reload flows can run in parallel to module cleanup.
This design is error prone. For example: aux_drivers callbacks are called
from both cleanup and remove flows with different lockings, which can
cause a deadlock[1].
Hence, serialize module cleanup with reload and remove.

[1]
       cleanup                        remove
       -------                        ------
   auxiliary_driver_unregister();
                                     devl_lock()
                                      auxiliary_device_delete(mlx5e_aux)
    device_lock(mlx5e_aux)
     devl_lock()
                                       device_lock(mlx5e_aux)

Fixes: 912cebf420c2 ("net/mlx5e: Connect ethernet part to auxiliary bus")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 3d5f2a4b1fed..4e1b5757528a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2110,7 +2110,7 @@ static int __init mlx5_init(void)
 	mlx5_core_verify_params();
 	mlx5_register_debugfs();
 
-	err = pci_register_driver(&mlx5_core_driver);
+	err = mlx5e_init();
 	if (err)
 		goto err_debug;
 
@@ -2118,16 +2118,16 @@ static int __init mlx5_init(void)
 	if (err)
 		goto err_sf;
 
-	err = mlx5e_init();
+	err = pci_register_driver(&mlx5_core_driver);
 	if (err)
-		goto err_en;
+		goto err_pci;
 
 	return 0;
 
-err_en:
+err_pci:
 	mlx5_sf_driver_unregister();
 err_sf:
-	pci_unregister_driver(&mlx5_core_driver);
+	mlx5e_cleanup();
 err_debug:
 	mlx5_unregister_debugfs();
 	return err;
@@ -2135,9 +2135,9 @@ static int __init mlx5_init(void)
 
 static void __exit mlx5_cleanup(void)
 {
-	mlx5e_cleanup();
-	mlx5_sf_driver_unregister();
 	pci_unregister_driver(&mlx5_core_driver);
+	mlx5_sf_driver_unregister();
+	mlx5e_cleanup();
 	mlx5_unregister_debugfs();
 }
 
-- 
2.39.1

