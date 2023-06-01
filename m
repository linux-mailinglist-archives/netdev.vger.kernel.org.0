Return-Path: <netdev+bounces-7003-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DF37192EE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B1A4281675
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3223F51B;
	Thu,  1 Jun 2023 06:01:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997DAA93F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52DCC433A8;
	Thu,  1 Jun 2023 06:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599295;
	bh=olPKvWLwjghnTRaNG+skYxOapuQ0pAh6NnYYY4Zzt6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyDnmWA19eXocKZ9nQAOivBuY4zNXKNKEoaigIlVojIp2ntFBk3CyjJM0n7hozTVC
	 Opbna9SP1FY9HkrNCxMgiqe6uk8MVAVU7jsYJLzxpJxaRVk7qIOzGopdkawS/6b5l3
	 dgUdexb8r8v/pnDyY7I+Ed67frnuDvZ96QUVExonzGdjNGXQ2XRtiKwXewpyq9Qf9Z
	 qB2zgIfuXlNAu5VMT/ZA5URnyJWrC+u21rBZ5sU5vcCoV+ug4PAiHKkfd5KRCEj9Jd
	 5osXRMpRj2ZUuC/UvEathVX0e7uoVkHM4hGHoWpUcqIZsaSq0Yo7r3sYZ6pactjTnD
	 tVXmiPg2cFrZw==
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
Subject: [net-next 04/14] net/mlx5e: en_tc, re-factor query route port
Date: Wed, 31 May 2023 23:01:08 -0700
Message-Id: <20230601060118.154015-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601060118.154015-1-saeed@kernel.org>
References: <20230601060118.154015-1-saeed@kernel.org>
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
index 6bf0fd3038bf..2135c0ef8560 100644
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


