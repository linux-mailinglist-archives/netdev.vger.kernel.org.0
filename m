Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909B761D81C
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiKEHKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiKEHKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:10:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101DA2EF14
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADEA0B81649
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA36C433C1;
        Sat,  5 Nov 2022 07:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632238;
        bh=j/IkUxT0bNiaJ6xKi/w6cAeDxSi7neNNh5ho+eQtYOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIOBFPXfWb3Nr2BH2p0GupBCskIAbhmSEBLON2edCjK+Ycaw49xviupjt5gu8IW6s
         YwSkvX7kEQhaZdzdCrLAZHLjeVygfK/LbtMN6W0V8AobsjEFT03H906vchzMAxQeB2
         09H2TFiGoIEnKfk6s6scBpEiHe4oe+92cXlRLJqk8IPlR39ZDsTzKLr6CWd38sNlS3
         M+YxZPeUWWKfJIcP5QgPvhPSKzRYTaB1aWMbZcc48aIx4rr/EuxQMmGvg14Xdb20ez
         EC8FP+r92hHFZ0ZwBjvYQ529yhiSIl2wuFgGIuaQGjeBHE+GpOSqJ+tjqyBnBdeGMU
         voe6VSGJgvMwA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [V2 net 04/11] net/mlx5: fw_reset: Don't try to load device in case PCI isn't working
Date:   Sat,  5 Nov 2022 00:10:21 -0700
Message-Id: <20221105071028.578594-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221105071028.578594-1-saeed@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

