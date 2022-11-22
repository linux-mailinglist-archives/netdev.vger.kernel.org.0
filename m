Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4263334D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiKVC3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiKVC2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:28:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D738286E4
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB09061541
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02BEC433D6;
        Tue, 22 Nov 2022 02:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084111;
        bh=YrDyNjEVRCzAIvoCedWCx29+9d9trcugxXtVTwgOanE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLy8oO/pxDZaTZ0AfC7VhcdIMtgKOKpqPJyOanilFFn0qtjHHL0i8recBulvVEI21
         oas66UTpFlwVdQkg4C/2ugq3OiYrOnRblhAgAzpTWZDegetrlO63oSF/tz52SdPzxS
         +zOCsV09eTpSVnsdHd/n8/agW72QO+AAyqoYyqbqtpVU5hbpjo/WfvZcjyuAYfH9Kg
         4jFLS5U3vVq62k6rGrUJfr6mdpLXyhDMwmWnzBP3old5nEIC0EHcdrk3PCdAO8BvfD
         nCdEU1+AAqGyuXKrkMTbwPFblpZIPkSxGCs1aMIxtbrrZp45pHCpo1tqEKSFyvM6IK
         D3a5ggmMoOl8g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net 08/14] net/mlx5: Fix sync reset event handler error flow
Date:   Mon, 21 Nov 2022 18:25:53 -0800
Message-Id: <20221122022559.89459-9-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

When sync reset now event handling fails on mlx5_pci_link_toggle() then
no reset was done. However, since mlx5_cmd_fast_teardown_hca() was
already done, the firmware function is closed and the driver is left
without firmware functionality.

Fix it by setting device error state and reopen the firmware resources.
Reopening is done by the thread that was called for devlink reload
fw_activate as it already holds the devlink lock.

Fixes: 5ec697446f46 ("net/mlx5: Add support for devlink reload action fw activate")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 9d908a0ccfef..1e46f9afa40e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -9,7 +9,8 @@ enum {
 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
 	MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
 	MLX5_FW_RESET_FLAGS_PENDING_COMP,
-	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS
+	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS,
+	MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED
 };
 
 struct mlx5_fw_reset {
@@ -406,7 +407,7 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	err = mlx5_pci_link_toggle(dev);
 	if (err) {
 		mlx5_core_warn(dev, "mlx5_pci_link_toggle failed, no reset done, err %d\n", err);
-		goto done;
+		set_bit(MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED, &fw_reset->reset_flags);
 	}
 
 	mlx5_enter_error_state(dev, true);
@@ -482,6 +483,10 @@ int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev)
 		goto out;
 	}
 	err = fw_reset->ret;
+	if (test_and_clear_bit(MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED, &fw_reset->reset_flags)) {
+		mlx5_unload_one_devl_locked(dev);
+		mlx5_load_one_devl_locked(dev, false);
+	}
 out:
 	clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
 	return err;
-- 
2.38.1

