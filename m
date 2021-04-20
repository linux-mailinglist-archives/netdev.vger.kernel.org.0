Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF033650C1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhDTDVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhDTDVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC5F461354;
        Tue, 20 Apr 2021 03:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888834;
        bh=6dJB+0SxQpwMKD/5u1uJjzeEJkyYKk5Q6KYHoayJE+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixfGxSRUVW8vvwZP7WJ6ohfJikCBK29BQeq2oCPb4XZ6YbkHQVYWuzkJfDXirrmHp
         YNN9gI0KMh0vp55FccJdYlAMiIds1qhGM079K7nSijEJrJzDw1/eFqVxIokHs9QH1y
         E7L9VbHkM1VVwgtRvz2EQYCBBoUi9RzaAUbZ7+w7GVbKQtoXa9iXbqugy0arbaTAZ+
         gD3QqmAfZmGxHr+qHLi05EdOxHG+vusFMZoumr+nNRjHSaIYjzCc18fz+zEzxbG0Eb
         xukXZbX0+b211SDHt92h0u+wkQL9tcfyRBPlMzKHz+evuHndYtxcJzoeUFf8QeW6pw
         Ea806cRKnEEOw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Fix lost changes during code movements
Date:   Mon, 19 Apr 2021 20:20:04 -0700
Message-Id: <20210420032018.58639-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

The changes done in commit [1] were missed by the code movements
done in [2], as they were developed in ~parallel.
Here we re-apply them.

[1] commit e4484d9df500 ("net/mlx5e: Enable striding RQ for Connect-X IPsec capable devices")
[2] commit b3a131c2a160 ("net/mlx5e: Move params logic into its dedicated file")

Fixes: b3a131c2a160 ("net/mlx5e: Move params logic into its dedicated file")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index f6ba568e00be..69f1f41b2b83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -6,6 +6,7 @@
 #include "en/port.h"
 #include "en_accel/en_accel.h"
 #include "accel/ipsec.h"
+#include "fpga/ipsec.h"
 
 static bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
 			    struct mlx5e_xsk_param *xsk)
@@ -282,7 +283,7 @@ bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 	if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
 		return false;
 
-	if (MLX5_IPSEC_DEV(mdev))
+	if (mlx5_fpga_is_ipsec_device(mdev))
 		return false;
 
 	if (params->xdp_prog) {
@@ -364,7 +365,7 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	u32 buf_size = 0;
 	int i;
 
-	if (MLX5_IPSEC_DEV(mdev))
+	if (mlx5_fpga_is_ipsec_device(mdev))
 		byte_count += MLX5E_METADATA_ETHER_LEN;
 
 	if (mlx5e_rx_is_linear_skb(params, xsk)) {
-- 
2.30.2

