Return-Path: <netdev+bounces-8290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EB672389B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0A1D1C20E57
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28E15676;
	Tue,  6 Jun 2023 07:12:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5E763D8
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C973BC433B3;
	Tue,  6 Jun 2023 07:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686035557;
	bh=TxslIJuegigARBUmcC/zoGAApJ4huayWW1+6cWeHxpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a46XpxIYiXm1HK/5xiAAVGj3V5Kv54yVSDcG1UPiHvb3lpsdrY98xLG60bhW1LOrF
	 xE4etQwLlMSkromAmrtJ+bJOKh2/jLsI48XuSy8dizogImehSq1rzGvBPMjeTXAZOU
	 PXuOMRKxY8yB62m4XnP4fxnI/7j7fpJ/S7eHnEj6ehfi8H+scJYx9UUg0QClF9+xNY
	 /7k6F8yWAYcwVS+QEuItr69lU7bakn7XM/0Se4oweWtbKZ2Oib4pYeKVfWSnC7fMJ7
	 bhSuIMbA/ac3g9yqm/O3E3yerH4lj8uVZ6USCm3/l5HEvSlfcCHKr6rqfD66mJCAMP
	 Mq0KnA+s2zT8g==
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
Subject: [net-next 06/15] net/mlx5: LAG, block multipath LAG in case ldev have more than 2 ports
Date: Tue,  6 Jun 2023 00:12:10 -0700
Message-Id: <20230606071219.483255-7-saeed@kernel.org>
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


