Return-Path: <netdev+bounces-9072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B25A9727042
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A20E1C20F83
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124A33C092;
	Wed,  7 Jun 2023 21:04:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1F13AE68
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD85C433AA;
	Wed,  7 Jun 2023 21:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171876;
	bh=mrByyCHRUD3MFLkEdjFLeU+JfKMp9/Y7nWbhtLMYeb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMN5CGsSZAeNvo5H5NdVh8sDUEHr1x2f2bAcLyyzD6ymGKeIxb6dx8xwS+eUTh0Qa
	 mhbkfOI4PJ8DjnpFqvK5KaHu7xerWJEjZBRV5gVfrpeXX6bNcEqLCAzTf6nSk11mPi
	 X8PFtK8KppmHhgskQu3NBI8/TBCCtSFU9ghOtDHtmOKrM1jt2OSB3ON0CpXTTFW5k/
	 9b6D0FH1Rw5eyQjKdyqJfyNg/UjPtZldpTF61ncC/cMJLq1rhLzrs21FrU2tCD8Yxj
	 81iu/CFqoTF5diAOKISjxfvR7f1pmSRbs5Vz5t2lD2AYWrPK9UjJ0iCJD4fN5u5UCz
	 5tVCNX6dRMOJg==
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
Subject: [net-next V2 08/14] net/mlx5: Enable 4 ports VF LAG
Date: Wed,  7 Jun 2023 14:04:04 -0700
Message-Id: <20230607210410.88209-9-saeed@kernel.org>
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

Now, after all preparation are done, enable 4 ports VF LAG

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c    | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 6ce71c42c755..ffd7e17b8ebe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -711,7 +711,7 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	return 0;
 }
 
-#define MLX5_LAG_OFFLOADS_SUPPORTED_PORTS 2
+#define MLX5_LAG_OFFLOADS_SUPPORTED_PORTS 4
 bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 {
 #ifdef CONFIG_MLX5_ESWITCH
@@ -737,7 +737,7 @@ bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 		if (mlx5_eswitch_mode(ldev->pf[i].dev) != mode)
 			return false;
 
-	if (mode == MLX5_ESWITCH_OFFLOADS && ldev->ports != MLX5_LAG_OFFLOADS_SUPPORTED_PORTS)
+	if (mode == MLX5_ESWITCH_OFFLOADS && ldev->ports > MLX5_LAG_OFFLOADS_SUPPORTED_PORTS)
 		return false;
 #else
 	for (i = 0; i < ldev->ports; i++)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 8472bbb3cd58..78c94b22bdc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -75,13 +75,14 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 
 	if (!mlx5_core_is_pf(dev))
 		return NULL;
-	if (MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_DEVCOM_PORTS_SUPPORTED)
+	if (MLX5_CAP_GEN(dev, num_lag_ports) > MLX5_DEVCOM_PORTS_SUPPORTED)
 		return NULL;
 
 	mlx5_dev_list_lock();
 	sguid0 = mlx5_query_nic_system_image_guid(dev);
 	list_for_each_entry(iter, &devcom_list, list) {
-		struct mlx5_core_dev *tmp_dev = NULL;
+		/* There is at least one device in iter */
+		struct mlx5_core_dev *tmp_dev;
 
 		idx = -1;
 		for (i = 0; i < MLX5_DEVCOM_PORTS_SUPPORTED; i++) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
index bb1970ba8730..d953a01b8eaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
@@ -6,7 +6,7 @@
 
 #include <linux/mlx5/driver.h>
 
-#define MLX5_DEVCOM_PORTS_SUPPORTED 2
+#define MLX5_DEVCOM_PORTS_SUPPORTED 4
 
 enum mlx5_devcom_components {
 	MLX5_DEVCOM_ESW_OFFLOADS,
-- 
2.40.1


