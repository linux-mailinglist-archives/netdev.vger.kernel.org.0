Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66D46232AE
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiKISlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiKISlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:41:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE5213E84
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:41:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B4D961C7B
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9864DC433D7;
        Wed,  9 Nov 2022 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019260;
        bh=j/IkUxT0bNiaJ6xKi/w6cAeDxSi7neNNh5ho+eQtYOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1s4ux3Ie3j2fz003ZXQjkl1gW47ZuneT2GDy8kCwS3fqiH6lK14UUsJL+VFc2BHM
         B4F2X5vYeP00sPTUAdjX7TYAuNGvPW57BP9ADrxp0TdPndCdYhi05UhR82I5ni6Z86
         LFpeHbpHwODERXn5zZSyhKcvqJaOOCVHfA5vD0uw3AMktfJNDOAUEQQiMsM+P9+Tmv
         BqDjHiTXak1CSbuOdE8eZ+t8ezzigqTCpo4Ql57AiKxgnS9aNybGJjgVrk1Ymi0rGU
         apmLSw7wHoJ+WrR+shuKPxxzIHJZVAxQcHzfdurz3GyQ12vp0HAJPCpn8wCgw6gXkX
         0XB6un1p2JquA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [V3 net 04/10] net/mlx5: fw_reset: Don't try to load device in case PCI isn't working
Date:   Wed,  9 Nov 2022 10:40:44 -0800
Message-Id: <20221109184050.108379-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109184050.108379-1-saeed@kernel.org>
References: <20221109184050.108379-1-saeed@kernel.org>
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

In case PCI reads fail after unload, there is no use in trying to
load the device.

Fixes: 5ec697446f46 ("net/mlx5: Add support for devlink reload action fw activate")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 07c583996c29..9d908a0ccfef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -152,7 +152,8 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 		mlx5_unload_one(dev);
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
-		mlx5_load_one(dev, false);
+		else
+			mlx5_load_one(dev, false);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
-- 
2.38.1

