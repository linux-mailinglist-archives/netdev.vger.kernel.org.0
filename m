Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BD51A541C
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgDKXEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbgDKXES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BBF621775;
        Sat, 11 Apr 2020 23:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646258;
        bh=UtqJJfKM7fpX/qy2Rl6r2Z1tPkK90rlDbrkhz5ErUJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+xppoDsk8MtAtc6b2bvzo6nOA4guiCjV5xGwhnNyDahVAgq/JpCK1Xu6G3nRvUgK
         QStkj6t1NXu8L1JBoWTzLjmjaRnuRavMiTdDYvUv2yMRazeSz3/4ctv5fnWg7xxOBR
         mvpSmoAdItmj6tkyEJ1qiV9jSqq6bv0enDRHEmbU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 024/149] net/mlx5: E-Switch, Hold mutex when querying drop counter in legacy mode
Date:   Sat, 11 Apr 2020 19:01:41 -0400
Message-Id: <20200411230347.22371-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

[ Upstream commit 14c844cbf3503076de6e2e48d575216f1600b19f ]

Consider scenario below, CPU 1 is at risk to query already destroyed
drop counters. Need to apply the same state mutex when disabling vport.

+-------------------------------+-------------------------------------+
| CPU 0                         | CPU 1                               |
+-------------------------------+-------------------------------------+
| mlx5_device_disable_sriov     | mlx5e_get_vf_stats                  |
| mlx5_eswitch_disable          | mlx5_eswitch_get_vport_stats        |
| esw_disable_vport             | mlx5_eswitch_query_vport_drop_stats |
| mlx5_fc_destroy(drop_counter) | mlx5_fc_query(drop_counter)         |
+-------------------------------+-------------------------------------+

Fixes: b8a0dbe3a90b ("net/mlx5e: E-switch, Add steering drop counters")
Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index e49acd0c5da5c..b9451f25f22cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2600,9 +2600,13 @@ static int mlx5_eswitch_query_vport_drop_stats(struct mlx5_core_dev *dev,
 	u64 bytes = 0;
 	int err = 0;
 
-	if (!vport->enabled || esw->mode != MLX5_ESWITCH_LEGACY)
+	if (esw->mode != MLX5_ESWITCH_LEGACY)
 		return 0;
 
+	mutex_lock(&esw->state_lock);
+	if (!vport->enabled)
+		goto unlock;
+
 	if (vport->egress.legacy.drop_counter)
 		mlx5_fc_query(dev, vport->egress.legacy.drop_counter,
 			      &stats->rx_dropped, &bytes);
@@ -2613,20 +2617,22 @@ static int mlx5_eswitch_query_vport_drop_stats(struct mlx5_core_dev *dev,
 
 	if (!MLX5_CAP_GEN(dev, receive_discard_vport_down) &&
 	    !MLX5_CAP_GEN(dev, transmit_discard_vport_down))
-		return 0;
+		goto unlock;
 
 	err = mlx5_query_vport_down_stats(dev, vport->vport, 1,
 					  &rx_discard_vport_down,
 					  &tx_discard_vport_down);
 	if (err)
-		return err;
+		goto unlock;
 
 	if (MLX5_CAP_GEN(dev, receive_discard_vport_down))
 		stats->rx_dropped += rx_discard_vport_down;
 	if (MLX5_CAP_GEN(dev, transmit_discard_vport_down))
 		stats->tx_dropped += tx_discard_vport_down;
 
-	return 0;
+unlock:
+	mutex_unlock(&esw->state_lock);
+	return err;
 }
 
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
-- 
2.20.1

