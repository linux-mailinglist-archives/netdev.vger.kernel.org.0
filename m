Return-Path: <netdev+bounces-9067-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A8A727024
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FF461C20F12
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A993B8AB;
	Wed,  7 Jun 2023 21:04:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417739231
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906CFC433A4;
	Wed,  7 Jun 2023 21:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171869;
	bh=nazBkLhFgUDUTNhrBxWBkILuuUUc4r4ig0UUvi9zxbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixqF92g9FtimdRl9wl2tgBtLY8lLmaL1ch7FB41Ov/AiiYq5VCNPU+NdKq8cAx4k3
	 J/P46xNFwGUbXoJZSM8dbte5KSz8f9fRAujESJA0mJCf/yVR8hbTsTB6VNQcMit5uq
	 ebR/ZZshcZZyTJcxD6H3eYZn/9IK8ldkXQBO3uBrWSmAMYMPUKElcHQU/hKyCbFtZG
	 0LRvhtX1ALWE/FVt4bOtgbG6k0mo7uBu52GUouMtAmXxpI5i5pbhYQc0LeMfmduk5x
	 OYCZwmtpFECxX5851j15k59ByRdFSAtTdX41IgD3s2G/NavKmK8ymg6tOEi0fQyq94
	 03FrTO8QD/fUA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Subject: [net-next V2 03/14] net/mlx5: LAG, check if all eswitches are paired for shared FDB
Date: Wed,  7 Jun 2023 14:03:59 -0700
Message-Id: <20230607210410.88209-4-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607210410.88209-1-saeed@kernel.org>
References: <20230607210410.88209-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Shared FDB LAG can only work if all eswitches are paired.
Also, whenever two eswitches are paired, devcom is marked as ready.

Therefore, in case of device with two eswitches, checking devcom was
sufficient. However, this is not correct for device with more than
two eswitches, which will be introduced in downstream patch.
Hence, check all eswitches are paired explicitly.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c42c16d9ccbc..d3608f198e0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -779,6 +779,13 @@ static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
 	return 0;
 }
 
+static inline int mlx5_eswitch_get_npeers(struct mlx5_eswitch *esw)
+{
+	if (mlx5_esw_allowed(esw))
+		return esw->num_peers;
+	return 0;
+}
+
 static inline struct mlx5_flow_table *
 mlx5_eswitch_get_slow_fdb(struct mlx5_eswitch *esw)
 {
@@ -826,6 +833,8 @@ static inline void
 mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 					 struct mlx5_eswitch *slave_esw) {}
 
+static inline int mlx5_eswitch_get_npeers(struct mlx5_eswitch *esw) { return 0; }
+
 static inline int
 mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index c55e36e0571d..dd8a19d85617 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -828,7 +828,9 @@ bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
 				      MLX5_DEVCOM_ESW_OFFLOADS) &&
 	    MLX5_CAP_GEN(dev1, lag_native_fdb_selection) &&
 	    MLX5_CAP_ESW(dev1, root_ft_on_other_esw) &&
-	    MLX5_CAP_ESW(dev0, esw_shared_ingress_acl))
+	    MLX5_CAP_ESW(dev0, esw_shared_ingress_acl) &&
+	    mlx5_eswitch_get_npeers(dev0->priv.eswitch) == MLX5_CAP_GEN(dev0, num_lag_ports) - 1 &&
+	    mlx5_eswitch_get_npeers(dev1->priv.eswitch) == MLX5_CAP_GEN(dev1, num_lag_ports) - 1)
 		return true;
 
 	return false;
-- 
2.40.1


