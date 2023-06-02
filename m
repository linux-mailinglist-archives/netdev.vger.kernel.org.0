Return-Path: <netdev+bounces-7552-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE657720998
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 574AB281AD6
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B160D1E526;
	Fri,  2 Jun 2023 19:13:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857581DDEA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52180C433A8;
	Fri,  2 Jun 2023 19:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685733186;
	bh=zXOWpQzpHEk9WVK3ejkS3ldD0ks/QDJ00Xwv0LIeXsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5cWBCdkzFoB1An+A/Pmxn82myPkHQHELGSULuBiVswLJZ8ZNcvFzFmWBsng9htNO
	 8ghd7l0GYmGnCZcTgNyEBgqsAb2lCFkSxP0q2AD6CHTAgXy7FhAueGAbh/Zc2etXAh
	 f9O7jgxCcVOwzVZUmu4DEjqYqaXw3zZM0f4DJGJMtbiZ8+Byr73oBwtsjJOp/OXXMM
	 Wcs/szZ33M8xcszaXYijbQotd1Cny6pMQdQHGlZpt0jFsR6icIRi5VM7jsehOdIpOf
	 Z3ag0ZTPbgIc2hHvWumKh8SKhD1kHw4V/mJft0TQw8JaPImap/xUbfuEIgznO1yaR4
	 IZQ/Ax/rRWkPg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next V2 04/14] net/mlx5e: en_tc, re-factor query route port
Date: Fri,  2 Jun 2023 12:12:51 -0700
Message-Id: <20230602191301.47004-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602191301.47004-1-saeed@kernel.org>
References: <20230602191301.47004-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Bloch <mbloch@nvidia.com>

query for peer esw outside of if scope.
This is preparation for query route port over multiple peers.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 32 ++++++++-----------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6f9adb940588..a096005fd163 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1666,8 +1666,10 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 {
 	struct mlx5e_priv *out_priv, *route_priv;
 	struct mlx5_core_dev *route_mdev;
+	struct mlx5_devcom *devcom;
 	struct mlx5_eswitch *esw;
 	u16 vhca_id;
+	int err;
 
 	out_priv = netdev_priv(out_dev);
 	esw = out_priv->mdev->priv.eswitch;
@@ -1675,28 +1677,20 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	route_mdev = route_priv->mdev;
 
 	vhca_id = MLX5_CAP_GEN(route_mdev, vhca_id);
-	if (mlx5_lag_is_active(out_priv->mdev)) {
-		struct mlx5_devcom *devcom;
-		int err;
-
-		/* In lag case we may get devices from different eswitch instances.
-		 * If we failed to get vport num, it means, mostly, that we on the wrong
-		 * eswitch.
-		 */
-		err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
-		if (err != -ENOENT)
-			return err;
-
-		rcu_read_lock();
-		devcom = out_priv->mdev->priv.devcom;
-		esw = mlx5_devcom_get_peer_data_rcu(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-		err = esw ? mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport) : -ENODEV;
-		rcu_read_unlock();
+	err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+	if (!err)
+		return err;
 
+	if (!mlx5_lag_is_active(out_priv->mdev))
 		return err;
-	}
 
-	return mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+	rcu_read_lock();
+	devcom = out_priv->mdev->priv.devcom;
+	esw = mlx5_devcom_get_peer_data_rcu(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	err = esw ? mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport) : -ENODEV;
+	rcu_read_unlock();
+
+	return err;
 }
 
 static int
-- 
2.40.1


