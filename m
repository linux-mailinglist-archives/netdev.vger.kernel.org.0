Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D8126AF3B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgIOVMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8155421D7F;
        Tue, 15 Sep 2020 20:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201558;
        bh=tRi7dwj1PbSoYQrwCfZJ3a2NrpdhhjHDBAHIAGmp9aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZloJk3LOZ5KsKcScaPLvPY/Sk4UUI44mADgO/T3GQnnnkCHpYAMrHhn4u3oZjD71C
         tEE0CGrocTHpNZvCvzu/O7DNB7e6t3qFofmxnh7N+RmqV/h/jbjy5ywox3zOe88P0L
         xnxyQDulOzFA1T1460KaSTNKknifPOno3RJy/vvk=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Raed Salem <raeds@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/16] net/mlx5e: Add LAG warning for unsupported tx type
Date:   Tue, 15 Sep 2020 13:25:25 -0700
Message-Id: <20200915202533.64389-9-saeed@kernel.org>
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

If bond tx type is not active-backup or hash, LAG offload can't be
enabled. When CHANGEUPPER event is received, and both PFs (and only
them) under the same lag master are about to be enslaved, a warning
is returned for user to know the offload failure, otherwise PFs are
enslaved silently without LAG offload activated.

Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 8b6e2aae2783..191d3d5be46d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -355,7 +355,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 {
 	struct net_device *upper = info->upper_dev, *ndev_tmp;
 	struct netdev_lag_upper_info *lag_upper_info = NULL;
-	bool is_bonded;
+	bool is_bonded, is_in_lag, mode_supported;
 	int bond_status = 0;
 	int num_slaves = 0;
 	int idx;
@@ -391,13 +391,18 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	/* Determine bonding status:
 	 * A device is considered bonded if both its physical ports are slaves
 	 * of the same lag master, and only them.
-	 * Lag mode must be activebackup or hash.
 	 */
-	is_bonded = (num_slaves == MLX5_MAX_PORTS) &&
-		    (bond_status == 0x3) &&
-		    ((tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP) ||
-		     (tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH));
+	is_in_lag = num_slaves == MLX5_MAX_PORTS && bond_status == 0x3;
 
+	/* Lag mode must be activebackup or hash. */
+	mode_supported = tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP ||
+			 tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH;
+
+	if (is_in_lag && !mode_supported)
+		NL_SET_ERR_MSG_MOD(info->info.extack,
+				   "Can't activate LAG offload, TX type isn't supported");
+
+	is_bonded = is_in_lag && mode_supported;
 	if (tracker->is_bonded != is_bonded) {
 		tracker->is_bonded = is_bonded;
 		return 1;
-- 
2.26.2

