Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A6A26AF3E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgIOVNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E0D20936;
        Tue, 15 Sep 2020 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201557;
        bh=rStx+vWtUWZHmIZuOtNmbT5SBsevn4dvruAYjyoc7aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCoT92F48NpxNiaW/HQqv+/0LZ6X3EON001AaC7XZuVKuPT4qR49LjZnp06r/5uwU
         7cyitgUvU2rFIv50JlfZBXAzbJTCqoAe7BsUHIa9eD7tSaX5HE4uwHTLjyaoccKAc/
         sQC4Aa2sKWnNFALctLgLRpmbVUKJlmbvxQfCmlUc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5e: Return a valid errno if can't get lag device index
Date:   Tue, 15 Sep 2020 13:25:24 -0700
Message-Id: <20200915202533.64389-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

Change the return value to -ENOENT, to make it more meaningful.

Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c    | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 874c70e8cc54..8b6e2aae2783 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -102,7 +102,7 @@ int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 		if (ldev->pf[i].netdev == ndev)
 			return i;
 
-	return -1;
+	return -ENOENT;
 }
 
 static bool __mlx5_lag_is_roce(struct mlx5_lag *ldev)
@@ -374,7 +374,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	rcu_read_lock();
 	for_each_netdev_in_bond_rcu(upper, ndev_tmp) {
 		idx = mlx5_lag_dev_get_netdev_idx(ldev, ndev_tmp);
-		if (idx > -1)
+		if (idx >= 0)
 			bond_status |= (1 << idx);
 
 		num_slaves++;
@@ -418,7 +418,7 @@ static int mlx5_handle_changelowerstate_event(struct mlx5_lag *ldev,
 		return 0;
 
 	idx = mlx5_lag_dev_get_netdev_idx(ldev, ndev);
-	if (idx == -1)
+	if (idx < 0)
 		return 0;
 
 	/* This information is used to determine virtual to physical
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 9e68f5926ab6..d192d25cff33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -131,7 +131,12 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 			struct net_device *nh_dev = nh->fib_nh_dev;
 			int i = mlx5_lag_dev_get_netdev_idx(ldev, nh_dev);
 
-			mlx5_lag_set_port_affinity(ldev, ++i);
+			if (i < 0)
+				i = MLX5_LAG_NORMAL_AFFINITY;
+			else
+				++i;
+
+			mlx5_lag_set_port_affinity(ldev, i);
 		}
 		return;
 	}
-- 
2.26.2

