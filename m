Return-Path: <netdev+bounces-4546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D07E70D34E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27E33281281
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F46B1DDD8;
	Tue, 23 May 2023 05:43:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F1E1D2DD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC300C433AE;
	Tue, 23 May 2023 05:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820586;
	bh=StDubvEUQSo/msMPrsl1izYoSEYL7sUEkSdw0LrXQ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k25uwL1BjgTUbPiZra5B292dtbEH1276IIVcFgrirFjWEiFhvGRJK3whNl4zIYLKZ
	 EIWq0BfoHd0Kj2wIKilVdXz7fQ2OkbPk6bn4/GyIuI9iMSQS2KULfszqrtumZIg8kz
	 Eavo6xWvGAMlgSad8Oiv5AgG5lp1Lmda2Yvb4XoevTwQeK5vd0H17p7gvbwQAUyCrd
	 d9/cS+g8vj7EeotTLB7EbI7xDLYNQFfpKMj9GNGKxYm8qgZPIruvAVsIgYiEEfNwmd
	 I1c+C1E8SVUSiDXR3NJABuNphqtW1DFooy5GAJoBFg9PRRBgVwaPAU2mA2iS6xFZnJ
	 9/5/Q/PzUH1Pg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Subject: [net 12/15] net/mlx5: Devcom, serialize devcom registration
Date: Mon, 22 May 2023 22:42:39 -0700
Message-Id: <20230523054242.21596-13-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523054242.21596-1-saeed@kernel.org>
References: <20230523054242.21596-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

From one hand, mlx5 driver is allowing to probe PFs in parallel.
From the other hand, devcom, which is a share resource between PFs, is
registered without any lock. This might resulted in memory problems.

Hence, use the global mlx5_dev_list_lock in order to serialize devcom
registration.

Fixes: fadd59fc50d0 ("net/mlx5: Introduce inter-device communication mechanism")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/devcom.c  | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 8f978491dd32..b7d779d08d83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -3,6 +3,7 @@
 
 #include <linux/mlx5/vport.h>
 #include "lib/devcom.h"
+#include "mlx5_core.h"
 
 static LIST_HEAD(devcom_list);
 
@@ -77,6 +78,7 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 	if (MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_DEVCOM_PORTS_SUPPORTED)
 		return NULL;
 
+	mlx5_dev_list_lock();
 	sguid0 = mlx5_query_nic_system_image_guid(dev);
 	list_for_each_entry(iter, &devcom_list, list) {
 		struct mlx5_core_dev *tmp_dev = NULL;
@@ -102,8 +104,10 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 
 	if (!priv) {
 		priv = mlx5_devcom_list_alloc();
-		if (!priv)
-			return ERR_PTR(-ENOMEM);
+		if (!priv) {
+			devcom = ERR_PTR(-ENOMEM);
+			goto out;
+		}
 
 		idx = 0;
 		new_priv = true;
@@ -114,12 +118,14 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 	if (!devcom) {
 		if (new_priv)
 			kfree(priv);
-		return ERR_PTR(-ENOMEM);
+		devcom = ERR_PTR(-ENOMEM);
+		goto out;
 	}
 
 	if (new_priv)
 		list_add(&priv->list, &devcom_list);
-
+out:
+	mlx5_dev_list_unlock();
 	return devcom;
 }
 
@@ -132,6 +138,7 @@ void mlx5_devcom_unregister_device(struct mlx5_devcom *devcom)
 	if (IS_ERR_OR_NULL(devcom))
 		return;
 
+	mlx5_dev_list_lock();
 	priv = devcom->priv;
 	priv->devs[devcom->idx] = NULL;
 
@@ -142,10 +149,12 @@ void mlx5_devcom_unregister_device(struct mlx5_devcom *devcom)
 			break;
 
 	if (i != MLX5_DEVCOM_PORTS_SUPPORTED)
-		return;
+		goto out;
 
 	list_del(&priv->list);
 	kfree(priv);
+out:
+	mlx5_dev_list_unlock();
 }
 
 void mlx5_devcom_register_component(struct mlx5_devcom *devcom,
-- 
2.40.1


