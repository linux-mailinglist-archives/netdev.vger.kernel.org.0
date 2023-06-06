Return-Path: <netdev+bounces-8287-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E3B723894
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 934242814FB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28F35674;
	Tue,  6 Jun 2023 07:12:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814FE5698
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD6CC4339C;
	Tue,  6 Jun 2023 07:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686035553;
	bh=nazBkLhFgUDUTNhrBxWBkILuuUUc4r4ig0UUvi9zxbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXoj2ddee2b6lQEPeSCPsyIAHrUWs8yvk74sIuzrv82y59QW7qb+4l1H68sfwB0Jz
	 nykwrsldQ9RDnMb1y9Q/FG4x5ArCiLTxGqkLcxLq7QIGMVuICYefGPYdkJuQrTjO1c
	 x+F//nlhd4SBKkcVpHuC9Rt26tLgBtWOI8COU1tVuW1EWx7lbghEy5toUxBNHhMXZj
	 F8sk1gzGZgTf1eVOPQWKlYDtdj6qidK3PLx3+45VAThFw8jDC+H1UvjCdo5q+jlIqa
	 xzqoLt+i+4ivWWxnj3EXuAJlyi9DcW1EmD36ASh0A56ZhpRKaFyV6jCEGOjC6gWx7z
	 58aOm2WXb2UBg==
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
Subject: [net-next 03/15] net/mlx5: LAG, check if all eswitches are paired for shared FDB
Date: Tue,  6 Jun 2023 00:12:07 -0700
Message-Id: <20230606071219.483255-4-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606071219.483255-1-saeed@kernel.org>
References: <20230606071219.483255-1-saeed@kernel.org>
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


