Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95947281A89
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 20:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388459AbgJBSHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 14:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388415AbgJBSHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 14:07:12 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B890F20795;
        Fri,  2 Oct 2020 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601662031;
        bh=w+QVxxP55yI3sX1a82g1F0LBqlN4hzZX0fsd64D7n/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cm9iDxYYxJdpgE9574g0nVwwPvmghw0Az95Hjt76LXCURzfzc5Kb0sZoyaTxFMRjE
         fh8/jt/E2u8CXxyJcOuIUBidWWejFMbFLqtV+WGntIJghX12nbvz6Z67OV9zwQuZyV
         8x7VZ2+3IDXLuSYXa7GC/oOaFc9LimZzO1o1VRnw=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V3 12/14] net/mlx5e: Fix VLAN cleanup flow
Date:   Fri,  2 Oct 2020 11:06:52 -0700
Message-Id: <20201002180654.262800-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002180654.262800-1-saeed@kernel.org>
References: <20201002180654.262800-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Prior to this patch unloading an interface in promiscuous mode with RX
VLAN filtering feature turned off - resulted in a warning. This is due
to a wrong condition in the VLAN rules cleanup flow, which left the
any-vid rules in the VLAN steering table. These rules prevented
destroying the flow group and the flow table.

The any-vid rules are removed in 2 flows, but none of them remove it in
case both promiscuous is set and VLAN filtering is off. Fix the issue by
changing the condition of the VLAN table cleanup flow to clean also in
case of promiscuous mode.

mlx5_core 0000:00:08.0: mlx5_destroy_flow_group:2123:(pid 28729): Flow group 20 wasn't destroyed, refcount > 1
mlx5_core 0000:00:08.0: mlx5_destroy_flow_group:2123:(pid 28729): Flow group 19 wasn't destroyed, refcount > 1
mlx5_core 0000:00:08.0: mlx5_destroy_flow_table:2112:(pid 28729): Flow table 262149 wasn't destroyed, refcount > 1
...
...
------------[ cut here ]------------
FW pages counter is 11560 after reclaiming all pages
WARNING: CPU: 1 PID: 28729 at
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:660
mlx5_reclaim_startup_pages+0x178/0x230 [mlx5_core]
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
  mlx5_function_teardown+0x2f/0x90 [mlx5_core]
  mlx5_unload_one+0x71/0x110 [mlx5_core]
  remove_one+0x44/0x80 [mlx5_core]
  pci_device_remove+0x3e/0xc0
  device_release_driver_internal+0xfb/0x1c0
  device_release_driver+0x12/0x20
  pci_stop_bus_device+0x68/0x90
  pci_stop_and_remove_bus_device+0x12/0x20
  hv_eject_device_work+0x6f/0x170 [pci_hyperv]
  ? __schedule+0x349/0x790
  process_one_work+0x206/0x400
  worker_thread+0x34/0x3f0
  ? process_one_work+0x400/0x400
  kthread+0x126/0x140
  ? kthread_park+0x90/0x90
  ret_from_fork+0x22/0x30
   ---[ end trace 6283bde8d26170dc ]---

Fixes: 9df30601c843 ("net/mlx5e: Restore vlan filter after seamless reset")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 64d002d92250..55a4c3adaa05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -415,8 +415,12 @@ static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
 	for_each_set_bit(i, priv->fs.vlan.active_svlans, VLAN_N_VID)
 		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	if (priv->fs.vlan.cvlan_filter_disabled &&
-	    !(priv->netdev->flags & IFF_PROMISC))
+	WARN_ON_ONCE(!(test_bit(MLX5E_STATE_DESTROYING, &priv->state)));
+
+	/* must be called after DESTROY bit is set and
+	 * set_rx_mode is called and flushed
+	 */
+	if (priv->fs.vlan.cvlan_filter_disabled)
 		mlx5e_del_any_vid_rules(priv);
 }
 
-- 
2.26.2

