Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DD13DF86A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbhHCXUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233670AbhHCXUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CFA60F93;
        Tue,  3 Aug 2021 23:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032823;
        bh=JcEopKgjR7krcW6ZEC6zhfogi5KM4huoKxlKQeSHzDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGF2wfSd2w6Dpu4I+XW80N4ha3px7GwDxpBJVREXt+rgusGBfT8ru+6L9UYqb4b4E
         w6lpCQRyzj8o3NMiuBbuw+OHYC32cSaXmTGT4IDCQmFaFLB0SH2vaDfQq73P6PAJx/
         kP+Mkvg6P6/bzKO1oOmDsNLIpsKJcldnQg09pBnkzMqXilEm9/qUtDpc03UvVonFFo
         rN6FHlj2FaZM0LcfE7sOjtE4eHBcu0ngM/PlxLSlSey2onOjTmXUMZ5fakkQ4wOAZ6
         UzvWh0WPU+SJouQ+Zmlnj34KpomkPW5PKaRWRdc1URGKJ/kKI9jg89yJk5V/cuLZYL
         gYxNRyrxiNU7g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 12/14] net/mlx5: Lag, move lag destruction to a workqueue
Date:   Tue,  3 Aug 2021 16:19:57 -0700
Message-Id: <20210803231959.26513-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

If a netdev is removed from the lag the lag should be destroyed.
With downstream patches this might trigger a reconfiguration of
representors on a different eswitch and such we don't have the proper
locking to so from this path. Move the destruction to be done by the
workqueue.

As the destruction won't affect the netdev side it okay to do so.
The RDMA side will be reconfigured and it already coded to handle such
reconfiguration.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 459e3e5ef13f..89cd2b2af50a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -371,12 +371,13 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	bool do_bond, roce_lag;
 	int err;
 
-	if (!mlx5_lag_is_ready(ldev))
-		return;
-
-	tracker = ldev->tracker;
+	if (!mlx5_lag_is_ready(ldev)) {
+		do_bond = false;
+	} else {
+		tracker = ldev->tracker;
 
-	do_bond = tracker.is_bonded && mlx5_lag_check_prereq(ldev);
+		do_bond = tracker.is_bonded && mlx5_lag_check_prereq(ldev);
+	}
 
 	if (do_bond && !__mlx5_lag_is_active(ldev)) {
 		roce_lag = !mlx5_sriov_is_enabled(dev0) &&
@@ -733,11 +734,11 @@ void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev,
 	if (!ldev)
 		return;
 
-	if (__mlx5_lag_is_active(ldev))
-		mlx5_disable_lag(ldev);
-
 	mlx5_ldev_remove_netdev(ldev, netdev);
 	ldev->flags &= ~MLX5_LAG_FLAG_READY;
+
+	if (__mlx5_lag_is_active(ldev))
+		mlx5_queue_bond_work(ldev, 0);
 }
 
 /* Must be called with intf_mutex held */
-- 
2.31.1

