Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9ED7453AEC
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhKPU0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhKPU0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056BE61B08;
        Tue, 16 Nov 2021 20:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094220;
        bh=SHl0egmbcwN+gHhElyfypi561EIs4o5ySux3uCLBCHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsvlbLWCHk6fi9bInVT90G3YIxfX5arKxXBLR4zaEYWiTG2zxiKfD5uk7sM1vB1HX
         XBxw3cArdQoJ/GxDur4uweQoYX7iE7s6k+JoxjYajWetqiz3K5o7lQLWGJqNHtBl98
         JGhBXFspnidxYynEvaY0eLx5/mk8O1u+ohCWOoqSdmoV/i2a3FIqhp+E/1ND/sBkcM
         UUc79D+w6XUqMQeqTh+trv/d1EfaGdkr5Dk5ye/rx8vebtion9/BM/N+5cO07+xwsD
         P0dVFpRaNWUGzZwerDoJKnzdQCoOvECNotpnFcaGCid4TqJg9RVHvkYGX/otZ95gR3
         Mvg5eJcb2TaOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/12] net/mlx5: Lag, update tracker when state change event received
Date:   Tue, 16 Nov 2021 12:23:20 -0800
Message-Id: <20211116202321.283874-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

Currently, In NETDEV_CHANGELOWERSTATE/NETDEV_CHANGEUPPERSTATE events
handling, tracking is not fully completed if the LAG device is not ready
at the time the events occur. But, we must keep track of the upper and
lower states after receiving the events because RoCE needs this info in
mlx5_lag_get_roce_netdev() - in order to return the corresponding port
that its running on. Returning the wrong (not most recent) port will lead
to gids table being incorrect.

For example: If during the attachment of a slave to the bond, the other
non-attached port performs pci_reload, then the LAG device is not ready,
but that should not result in dismissing attached slave tracker update
automatically (which is performed in mlx5_handle_changelowerstate()), Since
these events might not come later, which can lead to both bond ports
having tx_enabled=0 - which is not a valid state of LAG bond.

Fixes: 9b412cc35f00 ("net/mlx5e: Add LAG warning if bond slave is not lag master")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 28 +++++++++----------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 48d2ea690d7a..4ddf6b330a44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -615,6 +615,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	bool is_bonded, is_in_lag, mode_supported;
 	int bond_status = 0;
 	int num_slaves = 0;
+	int changed = 0;
 	int idx;
 
 	if (!netif_is_lag_master(upper))
@@ -653,27 +654,27 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	 */
 	is_in_lag = num_slaves == MLX5_MAX_PORTS && bond_status == 0x3;
 
-	if (!mlx5_lag_is_ready(ldev) && is_in_lag) {
-		NL_SET_ERR_MSG_MOD(info->info.extack,
-				   "Can't activate LAG offload, PF is configured with more than 64 VFs");
-		return 0;
-	}
-
 	/* Lag mode must be activebackup or hash. */
 	mode_supported = tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP ||
 			 tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH;
 
-	if (is_in_lag && !mode_supported)
-		NL_SET_ERR_MSG_MOD(info->info.extack,
-				   "Can't activate LAG offload, TX type isn't supported");
-
 	is_bonded = is_in_lag && mode_supported;
 	if (tracker->is_bonded != is_bonded) {
 		tracker->is_bonded = is_bonded;
-		return 1;
+		changed = 1;
 	}
 
-	return 0;
+	if (!is_in_lag)
+		return changed;
+
+	if (!mlx5_lag_is_ready(ldev))
+		NL_SET_ERR_MSG_MOD(info->info.extack,
+				   "Can't activate LAG offload, PF is configured with more than 64 VFs");
+	else if (!mode_supported)
+		NL_SET_ERR_MSG_MOD(info->info.extack,
+				   "Can't activate LAG offload, TX type isn't supported");
+
+	return changed;
 }
 
 static int mlx5_handle_changelowerstate_event(struct mlx5_lag *ldev,
@@ -716,9 +717,6 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 
 	ldev    = container_of(this, struct mlx5_lag, nb);
 
-	if (!mlx5_lag_is_ready(ldev) && event == NETDEV_CHANGELOWERSTATE)
-		return NOTIFY_DONE;
-
 	tracker = ldev->tracker;
 
 	switch (event) {
-- 
2.31.1

