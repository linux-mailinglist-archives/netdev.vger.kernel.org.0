Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423232EE6DB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbhAGU3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbhAGU3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:29:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B12BF23444;
        Thu,  7 Jan 2021 20:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051339;
        bh=Z++OPqzpNMPLqTMveQtOkp61ltmum6Tnw6CjPqCNddE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GstvCP1as3ulpZUMcVzLBtnu1Gkx0Z77G+RNEV8F3+zyMJyN1p6oy7yLVBqLIxO+H
         BCtU994YdzYvlsxcGGuSxhKfArIgBo25Y7ytDpoA3oBK7sgKEkSld9amulRWwSGnc2
         mEwVtPt82hWtimaQhfMEpuKW81//grd/byhVHItqw+pGYAzEd8g3dgDJFafBfFj0EG
         TxG9mslprF2cEvv23bBHPvyH5zp09voLTEM/ZnggkRKiWXT2ZR3nsrZ+gUDSROpxH6
         gbff0zS29MQAKQi+yymqYm2DX2kXLcnd/ZpYhuzVEwwt5bWWzOTgJaUEqQUS6y4COY
         k/8MvxjYurz9Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/11] net/mlx5e: Add missing capability check for uplink follow
Date:   Thu,  7 Jan 2021 12:28:36 -0800
Message-Id: <20210107202845.470205-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Expose firmware indication that it supports setting eswitch uplink state
to follow (follow the physical link). Condition setting the eswitch
uplink admin-state with this capability bit. Older FW may not support
the uplink state setting.

Fixes: 7d0314b11cdd ("net/mlx5e: Modify uplink state on interface up/down")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 ++-
 include/linux/mlx5/mlx5_ifc.h                     | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7a79d330c075..6a852b4901aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3161,7 +3161,8 @@ static void mlx5e_modify_admin_state(struct mlx5_core_dev *mdev,
 
 	mlx5_set_port_admin_status(mdev, state);
 
-	if (mlx5_eswitch_mode(mdev) != MLX5_ESWITCH_LEGACY)
+	if (mlx5_eswitch_mode(mdev) == MLX5_ESWITCH_OFFLOADS ||
+	    !MLX5_CAP_GEN(mdev, uplink_follow))
 		return;
 
 	if (state == MLX5_PORT_UP)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8fbddec26eb8..442c0160caab 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1280,7 +1280,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   ece_support[0x1];
 	u8	   reserved_at_a4[0x7];
 	u8         log_max_srq[0x5];
-	u8         reserved_at_b0[0x2];
+	u8         reserved_at_b0[0x1];
+	u8         uplink_follow[0x1];
 	u8         ts_cqe_to_dest_cqn[0x1];
 	u8         reserved_at_b3[0xd];
 
-- 
2.26.2

