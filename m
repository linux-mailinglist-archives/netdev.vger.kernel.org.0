Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DFE3FF3CB
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347316AbhIBTHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347300AbhIBTHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F343761053;
        Thu,  2 Sep 2021 19:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609565;
        bh=Hew74U7GpmfcRZXgkKrDNFf6XZrY2RoCliwDnX+TIvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOCzRdGf41PFaNQ9yMb8AXqQMpFFz/UmnsaJjWUt2wYU9dUgqeXJwTLvcpvTSJWj2
         I65LeDa8GBlwdCfFzURXeTNC2lcApEwQIpiOp20JTucfYS0fA/rwBw23ESsCYmYuVg
         psjxLg9BFeNzNgHiUYXXNPE++VG5Pvn9LM1t1CjpA+6XvkUZ58OCUzi1Z2NEHvIVBb
         P3rg+6buarlFj+gIp9C1CAzbDx+aI+xMQTSXTNw+SN8vlLU1qHFuLC3TmXEOrFjste
         7xi6W0tXj5wmUkuqK8uaDqaXltOVKhfNxO4Bfh6O0gngjkrrHylt5DtBqUNi/c8SCR
         z5kLymVT377/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Lag, don't update lag if lag isn't supported
Date:   Thu,  2 Sep 2021 12:05:41 -0700
Message-Id: <20210902190554.211497-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

In NICs that don't support LAG, the LAG control structure won't be
allocated. If it wasn't allocated it means LAG doesn't exists and can be
skipped.

Fixes: cac1eb2cf2e3 ("net/mlx5: Lag, properly lock eswitch if needed")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 49ca57c6d31d..ca5690b0a7ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -927,9 +927,12 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 	struct mlx5_core_dev *dev1;
 	struct mlx5_lag *ldev;
 
+	ldev = mlx5_lag_dev(dev);
+	if (!ldev)
+		return;
+
 	mlx5_dev_list_lock();
 
-	ldev = mlx5_lag_dev(dev);
 	dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	dev1 = ldev->pf[MLX5_LAG_P2].dev;
 
@@ -946,8 +949,11 @@ void mlx5_lag_enable_change(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
 
-	mlx5_dev_list_lock();
 	ldev = mlx5_lag_dev(dev);
+	if (!ldev)
+		return;
+
+	mlx5_dev_list_lock();
 	ldev->mode_changes_in_progress--;
 	mlx5_dev_list_unlock();
 	mlx5_queue_bond_work(ldev, 0);
-- 
2.31.1

