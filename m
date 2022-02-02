Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345F54A6B31
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiBBFGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiBBFGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 796ECB83013
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ADFC340F0;
        Wed,  2 Feb 2022 05:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778398;
        bh=8Ft4a6cxFvbaaP1u10UvHnHMchLNbUuusbeQNuQvcCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+blcNHmTUhz0OsCTRQXbghEhW+W1ZcAty2LLV6YtEL++oeOlq7wePtsaUJ1Q8Jnj
         Cz3a22e1Pemb9wm4vsqYPe5ZwJNtCfGxTNg9xMluT4BG4qW+2edlqk7dlh3McBn/dT
         CfwwJ9jdiWY210jlP43VuFRMX3yKayhQ0AUwbTtq93jBBWDdxM302OqCJqckHxrbRN
         BcW7NeaeLA4oBfcIoO5q8GzYkdn5qYrxzRSDj5qDhb+5liTlLnqQH1znuKYb2pyf8e
         M/RbeT7vyNHBW3lIngq9FkMO+6QYr1QH2m2GLckM/oHGI6po/+33JCbQSszeXLNANn
         SbA1raWrumM0w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/18] net/mlx5e: Fix handling of wrong devices during bond netevent
Date:   Tue,  1 Feb 2022 21:03:57 -0800
Message-Id: <20220202050404.100122-12-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Current implementation of bond netevent handler only check if
the handled netdev is VF representor and it missing a check if
the VF representor is on the same phys device of the bond handling
the netevent.

Fix by adding the missing check and optimizing the check if
the netdev is VF representor so it will not access uninitialized
private data and crashes.

BUG: kernel NULL pointer dereference, address: 000000000000036c
PGD 0 P4D 0
Oops: 0000 [#1] SMP NOPTI
Workqueue: eth3bond0 bond_mii_monitor [bonding]
RIP: 0010:mlx5e_is_uplink_rep+0xc/0x50 [mlx5_core]
RSP: 0018:ffff88812d69fd60 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8881cf800000 RCX: 0000000000000000
RDX: ffff88812d69fe10 RSI: 000000000000001b RDI: ffff8881cf800880
RBP: ffff8881cf800000 R08: 00000445cabccf2b R09: 0000000000000008
R10: 0000000000000004 R11: 0000000000000008 R12: ffff88812d69fe10
R13: 00000000fffffffe R14: ffff88820c0f9000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88846fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000036c CR3: 0000000103d80006 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 mlx5e_eswitch_uplink_rep+0x31/0x40 [mlx5_core]
 mlx5e_rep_is_lag_netdev+0x94/0xc0 [mlx5_core]
 mlx5e_rep_esw_bond_netevent+0xeb/0x3d0 [mlx5_core]
 raw_notifier_call_chain+0x41/0x60
 call_netdevice_notifiers_info+0x34/0x80
 netdev_lower_state_changed+0x4e/0xa0
 bond_mii_monitor+0x56b/0x640 [bonding]
 process_one_work+0x1b9/0x390
 worker_thread+0x4d/0x3d0
 ? rescuer_thread+0x350/0x350
 kthread+0x124/0x150
 ? set_kthread_struct+0x40/0x40
 ret_from_fork+0x1f/0x30

Fixes: 7e51891a237f ("net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c | 32 ++++++++-----------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index 9c076aa20306..b6f5c1bcdbcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -183,18 +183,7 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 
 static bool mlx5e_rep_is_lag_netdev(struct net_device *netdev)
 {
-	struct mlx5e_rep_priv *rpriv;
-	struct mlx5e_priv *priv;
-
-	/* A given netdev is not a representor or not a slave of LAG configuration */
-	if (!mlx5e_eswitch_rep(netdev) || !netif_is_lag_port(netdev))
-		return false;
-
-	priv = netdev_priv(netdev);
-	rpriv = priv->ppriv;
-
-	/* Egress acl forward to vport is supported only non-uplink representor */
-	return rpriv->rep->vport != MLX5_VPORT_UPLINK;
+	return netif_is_lag_port(netdev) && mlx5e_eswitch_vf_rep(netdev);
 }
 
 static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *ptr)
@@ -210,9 +199,6 @@ static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *pt
 	u16 fwd_vport_num;
 	int err;
 
-	if (!mlx5e_rep_is_lag_netdev(netdev))
-		return;
-
 	info = ptr;
 	lag_info = info->lower_state_info;
 	/* This is not an event of a representor becoming active slave */
@@ -266,9 +252,6 @@ static void mlx5e_rep_changeupper_event(struct net_device *netdev, void *ptr)
 	struct net_device *lag_dev;
 	struct mlx5e_priv *priv;
 
-	if (!mlx5e_rep_is_lag_netdev(netdev))
-		return;
-
 	priv = netdev_priv(netdev);
 	rpriv = priv->ppriv;
 	lag_dev = info->upper_dev;
@@ -293,6 +276,19 @@ static int mlx5e_rep_esw_bond_netevent(struct notifier_block *nb,
 				       unsigned long event, void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_rep_bond *bond;
+	struct mlx5e_priv *priv;
+
+	if (!mlx5e_rep_is_lag_netdev(netdev))
+		return NOTIFY_DONE;
+
+	bond = container_of(nb, struct mlx5e_rep_bond, nb);
+	priv = netdev_priv(netdev);
+	rpriv = mlx5_eswitch_get_uplink_priv(priv->mdev->priv.eswitch, REP_ETH);
+	/* Verify VF representor is on the same device of the bond handling the netevent. */
+	if (rpriv->uplink_priv.bond != bond)
+		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_CHANGELOWERSTATE:
-- 
2.34.1

