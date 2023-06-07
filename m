Return-Path: <netdev+bounces-9071-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9E2B727040
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E6B61C20F13
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A6F3B8D6;
	Wed,  7 Jun 2023 21:04:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32E63AE5F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1B4C43443;
	Wed,  7 Jun 2023 21:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171875;
	bh=TvvFLrdrNCJQMZKS4rYmyo47SA0euHg3Lv0phWxoJSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSWxJPR2XDTZfBHykvj3Orgtd0KwdyvdROlOKqzrpvobz37Hfi5QWOXjJb0E/L9hw
	 6SEqTNlgh55ooJYUJlu/eMjueshE324T0W4/0exVgcpm4bMJF+8/ZA0m5I89pttwiM
	 fBAblx+im4Il8qgr0ZtjTVVq108/GDYG6M5xjwwFhsoudIIDJg68vWjoTyy3jeD27o
	 aXdOrmDmF2j167gIQjyZwiee4BoeyxKfaseXStucoYbaxhIwXRBd/msdKQkpu/ENS3
	 ke3Zqfzh1w8LUXsR/wvS9BhE7jW5VF6zEgLpoHZcF57lktX5te74O2JBVwW9AnytJA
	 MRuzzRg++/YLg==
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
Subject: [net-next V2 07/14] net/mlx5: LAG, block multiport eswitch LAG in case ldev have more than 2 ports
Date: Wed,  7 Jun 2023 14:04:03 -0700
Message-Id: <20230607210410.88209-8-saeed@kernel.org>
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

multiport eswitch LAG is not supported over more than two ports. Add a check in
order to block multiport eswitch LAG over such devices.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 0c0ef600f643..0e869a76dfe4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -65,6 +65,7 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 	return err;
 }
 
+#define MLX5_LAG_MPESW_OFFLOADS_SUPPORTED_PORTS 2
 static int enable_mpesw(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
@@ -74,6 +75,9 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 	if (ldev->mode != MLX5_LAG_MODE_NONE)
 		return -EINVAL;
 
+	if (ldev->ports > MLX5_LAG_MPESW_OFFLOADS_SUPPORTED_PORTS)
+		return -EOPNOTSUPP;
+
 	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
 	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
 	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
-- 
2.40.1


