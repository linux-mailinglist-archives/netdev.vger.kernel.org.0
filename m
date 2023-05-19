Return-Path: <netdev+bounces-3983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F96709EAC
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5A0A281B04
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4849814A81;
	Fri, 19 May 2023 17:56:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2035713ACF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78B5C4331E;
	Fri, 19 May 2023 17:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518978;
	bh=pwqvcScF8DMHfQwffmYK0Y2HN8FwtC3Y5YboX22dfyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXTYNQ8CTOEmz0Qsqrqov/KuyfYE02umeHpd424ie0VDekA5cNTzWP8yQ0r+AMOAy
	 jA2Me0W6KP6vlSuhWsfd6131/xoCDN1A0NWr2/OISsv/ZEUh2b99XtqI1hZB9RU5BL
	 pi21J572je57iOPEdwS25Fg9XEOJ0MTcGBrkq/LpNztqnCK8StWtGEEzPbuh7YLAO9
	 OYMVi53zqBL+cJrGu95d3/EUf0A+pL3BwV0/H9E4us9PHXffyRNv969NeUp8toDQ+X
	 UCs7DfQGsqZZENUvCWy2DK7Dxp2NJVUfoN4CiA0s21Yf7H0/GblG8mjuKrkCrmYorF
	 kCGLDr9/1XR/Q==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: E-Switch, Add a check that log_max_l2_table is valid
Date: Fri, 19 May 2023 10:55:53 -0700
Message-Id: <20230519175557.15683-12-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

If log_max_l2_table is 0 there is no really room for one L2 address.
and should be treated as not supported.
Do the check in MPFS init and for vport context events which
both used to update L2 address.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 3e3963424285..9b71819e049a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -712,6 +712,9 @@ void esw_vport_change_handle_locked(struct mlx5_vport *vport)
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	u8 mac[ETH_ALEN];
 
+	if (!MLX5_CAP_GEN(dev, log_max_l2_table))
+		return;
+
 	mlx5_query_nic_vport_mac_address(dev, vport->vport, true, mac);
 	esw_debug(dev, "vport[%d] Context Changed: perm mac: %pM\n",
 		  vport->vport, mac);
@@ -948,7 +951,8 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	vport->enabled = false;
 
 	/* Disable events from this vport */
-	arm_vport_context_events_cmd(esw->dev, vport->vport, 0);
+	if (MLX5_CAP_GEN(esw->dev, log_max_l2_table))
+		arm_vport_context_events_cmd(esw->dev, vport->vport, 0);
 
 	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
 	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
index 8ff16318e32d..4450091e181a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -99,7 +99,7 @@ int mlx5_mpfs_init(struct mlx5_core_dev *dev)
 	int l2table_size = 1 << MLX5_CAP_GEN(dev, log_max_l2_table);
 	struct mlx5_mpfs *mpfs;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!MLX5_ESWITCH_MANAGER(dev) || l2table_size == 1)
 		return 0;
 
 	mpfs = kzalloc(sizeof(*mpfs), GFP_KERNEL);
-- 
2.40.1


