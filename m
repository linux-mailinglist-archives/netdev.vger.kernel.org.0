Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD84C1FF9
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245017AbiBWXk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244982AbiBWXkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA985C37D;
        Wed, 23 Feb 2022 15:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43D78CE1CF3;
        Wed, 23 Feb 2022 23:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D94C340F1;
        Wed, 23 Feb 2022 23:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659582;
        bh=PHRkMC9N71FB39X5i7CvBJfxyfkx1PayZ19p3SU4/BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAaLDlF3fOnSSNYVaGtgc07gON5zE+QUkhfr7t7dNSuYbNiyCOXrjxrre8DJq7OCT
         M/38wwLygWDhRetghFXeI7PI14nytHBTrYJaEYWKski9ERqidOxIPIs4RJ7FhQw+ms
         gz3T2ThCiJgYI4Jddsb0gNMLA6bI+Pthq4MhviGF6BT4K1o/3iboIGOOjMO6tGkAJo
         5p2qb8FIm+f+m5ZSaVyrH9UB7wOGplPb3tSRVthltnngyp5UxXsiQcdy0gKjK7ov3h
         tLAFQXypOZmT7yuAue8FCV35aNjzs4+YI5V/i5c+didkK7bFzzgDVt2bVppyZOoYEa
         vjPzWb3kuPChA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 08/17] net/mlx5: Lag, record inactive state of bond device
Date:   Wed, 23 Feb 2022 15:39:21 -0800
Message-Id: <20220223233930.319301-9-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

A bond device will drop duplicate packets (received on inactive ports)
by default. A flag (all_slaves_active) can be set to override such
behaviour. This flag is a global flag per bond device (ALB mode isn't
supported by mlx5 driver so it can be ignored)

When NETDEV_CHANGEUPPER / NETDEV_CHANGEINFODATA event is received check if
there is an interface that is inactive.

Downstream patch will use this information in order to decide if a drop
rule is needed.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 49 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  |  2 +-
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 05e8cbece095..125ac4befd74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <net/bonding.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eswitch.h>
 #include <linux/mlx5/vport.h>
@@ -619,6 +620,8 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	struct net_device *upper = info->upper_dev, *ndev_tmp;
 	struct netdev_lag_upper_info *lag_upper_info = NULL;
 	bool is_bonded, is_in_lag, mode_supported;
+	bool has_inactive = 0;
+	struct slave *slave;
 	int bond_status = 0;
 	int num_slaves = 0;
 	int changed = 0;
@@ -638,8 +641,12 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	rcu_read_lock();
 	for_each_netdev_in_bond_rcu(upper, ndev_tmp) {
 		idx = mlx5_lag_dev_get_netdev_idx(ldev, ndev_tmp);
-		if (idx >= 0)
+		if (idx >= 0) {
+			slave = bond_slave_get_rcu(ndev_tmp);
+			if (slave)
+				has_inactive |= bond_is_slave_inactive(slave);
 			bond_status |= (1 << idx);
+		}
 
 		num_slaves++;
 	}
@@ -654,6 +661,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 		tracker->hash_type = lag_upper_info->hash_type;
 	}
 
+	tracker->has_inactive = has_inactive;
 	/* Determine bonding status:
 	 * A device is considered bonded if both its physical ports are slaves
 	 * of the same lag master, and only them.
@@ -710,6 +718,38 @@ static int mlx5_handle_changelowerstate_event(struct mlx5_lag *ldev,
 	return 1;
 }
 
+static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
+					    struct lag_tracker *tracker,
+					    struct net_device *ndev)
+{
+	struct net_device *ndev_tmp;
+	struct slave *slave;
+	bool has_inactive = 0;
+	int idx;
+
+	if (!netif_is_lag_master(ndev))
+		return 0;
+
+	rcu_read_lock();
+	for_each_netdev_in_bond_rcu(ndev, ndev_tmp) {
+		idx = mlx5_lag_dev_get_netdev_idx(ldev, ndev_tmp);
+		if (idx < 0)
+			continue;
+
+		slave = bond_slave_get_rcu(ndev_tmp);
+		if (slave)
+			has_inactive |= bond_is_slave_inactive(slave);
+	}
+	rcu_read_unlock();
+
+	if (tracker->has_inactive == has_inactive)
+		return 0;
+
+	tracker->has_inactive = has_inactive;
+
+	return 1;
+}
+
 static int mlx5_lag_netdev_event(struct notifier_block *this,
 				 unsigned long event, void *ptr)
 {
@@ -718,7 +758,9 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 	struct mlx5_lag *ldev;
 	int changed = 0;
 
-	if ((event != NETDEV_CHANGEUPPER) && (event != NETDEV_CHANGELOWERSTATE))
+	if (event != NETDEV_CHANGEUPPER &&
+	    event != NETDEV_CHANGELOWERSTATE &&
+	    event != NETDEV_CHANGEINFODATA)
 		return NOTIFY_DONE;
 
 	ldev    = container_of(this, struct mlx5_lag, nb);
@@ -734,6 +776,9 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 		changed = mlx5_handle_changelowerstate_event(ldev, &tracker,
 							     ndev, ptr);
 		break;
+	case NETDEV_CHANGEINFODATA:
+		changed = mlx5_handle_changeinfodata_event(ldev, &tracker, ndev);
+		break;
 	}
 
 	ldev->tracker = tracker;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index e5d231c31b54..305d9adbe325 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -35,6 +35,7 @@ struct lag_tracker {
 	enum   netdev_lag_tx_type           tx_type;
 	struct netdev_lag_lower_state_info  netdev_state[MLX5_MAX_PORTS];
 	unsigned int is_bonded:1;
+	unsigned int has_inactive:1;
 	enum netdev_lag_hash hash_type;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 1ca01a5b6cdd..4213208d9ef7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -50,7 +50,7 @@ bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev)
 static void mlx5_lag_set_port_affinity(struct mlx5_lag *ldev,
 				       enum mlx5_lag_port_affinity port)
 {
-	struct lag_tracker tracker;
+	struct lag_tracker tracker = {};
 
 	if (!__mlx5_lag_is_multipath(ldev))
 		return;
-- 
2.35.1

