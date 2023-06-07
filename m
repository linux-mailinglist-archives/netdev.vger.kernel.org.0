Return-Path: <netdev+bounces-9070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37ED472703E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E67A9280DF8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B2D73B8CC;
	Wed,  7 Jun 2023 21:04:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E963AE5F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68DDC43443;
	Wed,  7 Jun 2023 21:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171873;
	bh=TxslIJuegigARBUmcC/zoGAApJ4huayWW1+6cWeHxpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYx5RbsLi1Kzi0ybBEfI1pY1di15TKg7oIC628VTgPV6sdOH7y9vxyrfvnqbGib2X
	 GSuZgTJdl2Ko0xxxlR1f1sJxV0/fRPMTg3wla86eRZL3cb+sKrzH4Qz3HWaQRzQU7E
	 g4EUbr2KwXp2MJ7eEvU8gtlcGjJvsrxGmZOAKFsmYsuVQ0d+GH2sCA7Vzo5TVcnzu7
	 5qsUvbMVXx0bUEyi4mJ7T2Sg7UbSjS34RPbcz962HmNlNg/e6/s3KkA9wQzOJkqdxI
	 QHH4JUG4/FwhrDJRFs/uwByXEgbT7HYw3f0EW/jsMb8SvYh7Dul3bKHfYr9/NOWlK/
	 xPSNAHuejGVjA==
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
Subject: [net-next V2 06/14] net/mlx5: LAG, block multipath LAG in case ldev have more than 2 ports
Date: Wed,  7 Jun 2023 14:04:02 -0700
Message-Id: <20230607210410.88209-7-saeed@kernel.org>
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

multipath LAG is not supported over more than two ports. Add a check in
order to block multipath LAG over such configurations.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index d85a8dfc153d..976caa8e6922 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -14,6 +14,7 @@ static bool __mlx5_lag_is_multipath(struct mlx5_lag *ldev)
 	return ldev->mode == MLX5_LAG_MODE_MULTIPATH;
 }
 
+#define MLX5_LAG_MULTIPATH_OFFLOADS_SUPPORTED_PORTS 2
 static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 {
 	if (!mlx5_lag_is_ready(ldev))
@@ -22,6 +23,9 @@ static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 	if (__mlx5_lag_is_active(ldev) && !__mlx5_lag_is_multipath(ldev))
 		return false;
 
+	if (ldev->ports > MLX5_LAG_MULTIPATH_OFFLOADS_SUPPORTED_PORTS)
+		return false;
+
 	return mlx5_esw_multipath_prereq(ldev->pf[MLX5_LAG_P1].dev,
 					 ldev->pf[MLX5_LAG_P2].dev);
 }
-- 
2.40.1


