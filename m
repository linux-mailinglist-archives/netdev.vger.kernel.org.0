Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABBB63BCF9
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiK2JaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiK2JaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171EB5BD4C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C02B5B811D6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5240FC433C1;
        Tue, 29 Nov 2022 09:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669714210;
        bh=c27r3GhuOJTHbxQdbCQPVMZ4C+/znej3VDXfV4UNzZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X49Iy1XuHnFAzSeFOcUiE40iJm3GuvvhVWgjT0Czkbo6O/4+B5dIVQGlJzeEFl46P
         8yFIClxWoI5HtsLwLvU4sewH0J9z8oZTr+/owJweY2AzNq3f/V0zpswvwPTvcN7p8o
         QcfawBNVuLt0SszqCzST0CxCF32vVsdpAFx3/Raa01kL31BW0fA8tJR3McxVGfU05B
         jZ0sRsyrftVlcugbdh5yS0TdypuggtqCJS5fF/Ef1ub85deI/TBtlc6KHdcxcerIaj
         zUgD+dHS+K0/lC12Kv4nA8FFesE/55a/HZ+pJKYMeBKW6jTRH5qZRGkkF+KkV2qQHk
         H3nqI3MXVtJyg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net 2/2] net/mlx5: Lag, Fix for loop when checking lag
Date:   Tue, 29 Nov 2022 01:30:06 -0800
Message-Id: <20221129093006.378840-2-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129093006.378840-1-saeed@kernel.org>
References: <20221129093006.378840-1-saeed@kernel.org>
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

From: Chris Mi <cmi@nvidia.com>

The cited commit adds a for loop to check if each port supports lag
or not. But dev is not initialized correctly. Fix it by initializing
dev for each iteration.

Fixes: e87c6a832f88 ("net/mlx5: E-switch, Fix duplicate lag creation")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reported-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4070dc1d17cb..32c3e0a649a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -700,11 +700,13 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 			return false;
 
 #ifdef CONFIG_MLX5_ESWITCH
-	dev = ldev->pf[MLX5_LAG_P1].dev;
-	for (i = 0; i  < ldev->ports; i++)
+	for (i = 0; i < ldev->ports; i++) {
+		dev = ldev->pf[i].dev;
 		if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && !is_mdev_switchdev_mode(dev))
 			return false;
+	}
 
+	dev = ldev->pf[MLX5_LAG_P1].dev;
 	mode = mlx5_eswitch_mode(dev);
 	for (i = 0; i < ldev->ports; i++)
 		if (mlx5_eswitch_mode(ldev->pf[i].dev) != mode)
-- 
2.38.1

