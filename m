Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E722D6B9D71
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCNRuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjCNRt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:49:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4A28F53D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C3676187A
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9971DC4339B;
        Tue, 14 Mar 2023 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816194;
        bh=53zrlc2Dxexx5a1GjEiXhd/Dh4owGhLuO5wBVWbKod8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PE8IW+XQE7/ofR7XLA+jsscFbe+7GKitum4fPyO2XFr4cJ9oetSvr6wEdPXHtJ6J0
         U4S7cbVZdZ4BvOVOzlIyjoNVmmjih3Z0Mftf+7MtaiRkF/dVPydFsrhAFJBdQiudSg
         SxPW1Wz2IGJxrKcJ2qEjYNugpCJpQiad1PD62BKv/xA7eEK3nUxXjzWMutFjbDmFws
         Gy6Uq3ByQoKBN2qACqawSGPfI502Q+UOwo99MxrVzmsdPdbkIzxqEXTDgqthzfMDhI
         ftecYgUXjZh6QGY27Ru2TPoWjnLwhWrRE58C1CEDuVDQgNlZnbZbgKHHZs76S1vLNc
         +EGhOaEeI48kw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net 09/14] net/mlx5: Set BREAK_FW_WAIT flag first when removing driver
Date:   Tue, 14 Mar 2023 10:49:35 -0700
Message-Id: <20230314174940.62221-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174940.62221-1-saeed@kernel.org>
References: <20230314174940.62221-1-saeed@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

Currently, BREAK_FW_WAIT flag is set after syncing with fw_reset.
However, fw_reset can call mlx5_load_one() which is waiting for fw
init bit and BREAK_FW_WAIT flag is intended to stop. e.g.: the driver
might wait on a loop it should exit.
Fix it by setting the flag before syncing with fw_reset.

Fixes: 8324a02c342a ("net/mlx5: Add exit route when waiting for FW")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f36a3aa4b5c8..f1de152a6113 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1789,11 +1789,11 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	/* mlx5_drain_fw_reset() is using devlink APIs. Hence, we must drain
 	 * fw_reset before unregistering the devlink.
 	 */
 	mlx5_drain_fw_reset(dev);
-	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
-- 
2.39.2

