Return-Path: <netdev+bounces-3973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD241709E9C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1DFD281D37
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272D512B7E;
	Fri, 19 May 2023 17:56:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1270125D3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54759C4339B;
	Fri, 19 May 2023 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518970;
	bh=lOybPocjT/TZE6Ejk6Ckia0QNr5f73AUKpj2FgIp3AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W42uRknMteAkPq1QN1sz5YwawMmuv4tOD/ztITNCUqVnSY/+FdvY61tbYumn78s1p
	 RgnIn3SUqtk8rwdUFjU3UpubpNeQMtBIpd/n4rPn8/P1MRh28MjjwJtKZGvjiuNdms
	 GgJq6fsbqRexzKSLqKd1NdBmYYows/2EZL9xtuQoUJnVv2WGN9JtTcs4WU0a/JM9U2
	 2lzroUi6rLjF41d2CewW6TTwMGaY+C7cmBBnMUwcH9A1YbZEoahcDTg12YvYNDZUGo
	 uWBX4p65JYQWIGwnVB8VRyUnRDGjz27d0590uTI/dGXdedb+iugL+QzVuKeXn0gTge
	 8zILapEF5JOgQ==
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
Subject: [net-next 01/15] net/mlx5: Remove redundant esw multiport validate function
Date: Fri, 19 May 2023 10:55:43 -0700
Message-Id: <20230519175557.15683-2-saeed@kernel.org>
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

The function didn't validate the value and doesn't require value
validation as it will always be valid true or false values.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 23 +------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 4b607785d694..0e07971e024a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -464,27 +464,6 @@ static int mlx5_devlink_esw_multiport_get(struct devlink *devlink, u32 id,
 	ctx->val.vbool = mlx5_lag_is_mpesw(dev);
 	return 0;
 }
-
-static int mlx5_devlink_esw_multiport_validate(struct devlink *devlink, u32 id,
-					       union devlink_param_value val,
-					       struct netlink_ext_ack *extack)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	if (!MLX5_ESWITCH_MANAGER(dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "E-Switch is unsupported");
-		return -EOPNOTSUPP;
-	}
-
-	if (mlx5_eswitch_mode(dev) != MLX5_ESWITCH_OFFLOADS) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "E-Switch must be in switchdev mode");
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
 #endif
 
 static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
@@ -563,7 +542,7 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     mlx5_devlink_esw_multiport_get,
 			     mlx5_devlink_esw_multiport_set,
-			     mlx5_devlink_esw_multiport_validate),
+			     NULL),
 #endif
 	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_eq_depth_validate),
-- 
2.40.1


