Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02E53D83D9
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhG0XVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233414AbhG0XU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5894B60F5E;
        Tue, 27 Jul 2021 23:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428057;
        bh=UiKdMONG33AJPMkQRdMxShMFSxi4u5GzfcIWB35xMvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2hGdML5/i2/pK8r51mN+fTlhN9mgHpFSgMWc62ncA0FrbELGWD4Q+gMsqLCEpnbM
         2/+Vp52gp96tfBqxPDgZ7u6E01DRLRa5hEroc7gHkxvnzP3Mcn0n7gx5Z4fjdaqae0
         W3Zt4IZuO8TJc6nIRaJ9fGbu5EAdAlIlJ0y75HEk1OWMGys/qFmMAvyEnKlirVo8+g
         RP/3dpzviywzv7nvbrp/5hQA0oCfKQIWzaL5TnwWLPA3bV3UHZAQbsr2nlMkjHBces
         IDdyUAfE44o87eP+vhI0ETIrxINcRVcXW3w7FX5yweNYV0X/KxGP5og4Fv6i6Aw4O1
         nvrHMyBEfUocQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/12] net/mlx5: Unload device upon firmware fatal error
Date:   Tue, 27 Jul 2021 16:20:48 -0700
Message-Id: <20210727232050.606896-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When fw_fatal reporter reports an error, the firmware in not responding.
Unload the device to ensure that the driver closes all its resources,
even if recovery is not due (user disabled auto-recovery or reporter is
in grace period). On successful recovery the device is loaded back up.

Fixes: b3bd076f7501 ("net/mlx5: Report devlink health on FW fatal issues")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 9ff163c5bcde..9abeb80ffa31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -626,8 +626,16 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	}
 	fw_reporter_ctx.err_synd = health->synd;
 	fw_reporter_ctx.miss_counter = health->miss_counter;
-	devlink_health_report(health->fw_fatal_reporter,
-			      "FW fatal error reported", &fw_reporter_ctx);
+	if (devlink_health_report(health->fw_fatal_reporter,
+				  "FW fatal error reported", &fw_reporter_ctx) == -ECANCELED) {
+		/* If recovery wasn't performed, due to grace period,
+		 * unload the driver. This ensures that the driver
+		 * closes all its resources and it is not subjected to
+		 * requests from the kernel.
+		 */
+		mlx5_core_err(dev, "Driver is in error state. Unloading\n");
+		mlx5_unload_one(dev);
+	}
 }
 
 static const struct devlink_health_reporter_ops mlx5_fw_fatal_reporter_ops = {
-- 
2.31.1

