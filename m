Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B834A6B33
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbiBBFGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiBBFGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC8FC06174A
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB129B8299D
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125C5C340F1;
        Wed,  2 Feb 2022 05:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778396;
        bh=tQozSJSPLQNZcw8QLjB1PX+Ji4lmnqfRvzxOOdxJFY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRxF9K7kz5Ha+uEjOLkFtWhl8vFV36JHjGUeg5Cyu5T7KZZ1owmRsUPpC9LNG9STA
         X6aa6ypItro0rmnbbM8zEQ5PGMhV49AVZ9g4hvDnfWqk284TNPXCQUWCDe+LTYlCkc
         L5fL/uynROkrm9yR6ZvhHC0Az5BPTwLmKtlPqaxfbXcAyVWkJpbSLxPBqppJ5w9jDd
         LH2/Aiexh2rdytIfqMf8jeq91b8YcaxJQhrISF4Vy1Uj9Tq1PBkpWmy9yYItBX8c5z
         Yqo31FuoSzzxpKc3tqOnBB/ZK7Ho6f0mrNj0wub9OV4JgXYn/JfSmLwgHoPcfmXRmv
         HFlnvcFo0W8BQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/18] net/mlx5: Bridge, Fix devlink deadlock on net namespace deletion
Date:   Tue,  1 Feb 2022 21:03:54 -0800
Message-Id: <20220202050404.100122-9-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

When changing mode to switchdev, rep bridge init registered to netdevice
notifier holds the devlink lock and then takes pernet_ops_rwsem.
At that time deleting a netns holds pernet_ops_rwsem and then takes
the devlink lock.

Example sequence is:
$ ip netns add foo
$ devlink dev eswitch set pci/0000:00:08.0 mode switchdev &
$ ip netns del foo

deleting netns trace:

[ 1185.365555]  ? devlink_pernet_pre_exit+0x74/0x1c0
[ 1185.368331]  ? mutex_lock_io_nested+0x13f0/0x13f0
[ 1185.370984]  ? xt_find_table+0x40/0x100
[ 1185.373244]  ? __mutex_lock+0x24a/0x15a0
[ 1185.375494]  ? net_generic+0xa0/0x1c0
[ 1185.376844]  ? wait_for_completion_io+0x280/0x280
[ 1185.377767]  ? devlink_pernet_pre_exit+0x74/0x1c0
[ 1185.378686]  devlink_pernet_pre_exit+0x74/0x1c0
[ 1185.379579]  ? devlink_nl_cmd_get_dumpit+0x3a0/0x3a0
[ 1185.380557]  ? xt_find_table+0xda/0x100
[ 1185.381367]  cleanup_net+0x372/0x8e0

changing mode to switchdev trace:

[ 1185.411267]  down_write+0x13a/0x150
[ 1185.412029]  ? down_write_killable+0x180/0x180
[ 1185.413005]  register_netdevice_notifier+0x1e/0x210
[ 1185.414000]  mlx5e_rep_bridge_init+0x181/0x360 [mlx5_core]
[ 1185.415243]  mlx5e_uplink_rep_enable+0x269/0x480 [mlx5_core]
[ 1185.416464]  ? mlx5e_uplink_rep_disable+0x210/0x210 [mlx5_core]
[ 1185.417749]  mlx5e_attach_netdev+0x232/0x400 [mlx5_core]
[ 1185.418906]  mlx5e_netdev_attach_profile+0x15b/0x1e0 [mlx5_core]
[ 1185.420172]  mlx5e_netdev_change_profile+0x15a/0x1d0 [mlx5_core]
[ 1185.421459]  mlx5e_vport_rep_load+0x557/0x780 [mlx5_core]
[ 1185.422624]  ? mlx5e_stats_grp_vport_rep_num_stats+0x10/0x10 [mlx5_core]
[ 1185.424006]  mlx5_esw_offloads_rep_load+0xdb/0x190 [mlx5_core]
[ 1185.425277]  esw_offloads_enable+0xd74/0x14a0 [mlx5_core]

Fix this by registering rep bridges for per net netdev notifier
instead of global one, which operats on the net namespace without holding
the pernet_ops_rwsem.

Fixes: 19e9bfa044f3 ("net/mlx5: Bridge, add offload infrastructure")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index d5cb27667005..48dc121b2cb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -491,7 +491,7 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 	}
 
 	br_offloads->netdev_nb.notifier_call = mlx5_esw_bridge_switchdev_port_event;
-	err = register_netdevice_notifier(&br_offloads->netdev_nb);
+	err = register_netdevice_notifier_net(&init_net, &br_offloads->netdev_nb);
 	if (err) {
 		esw_warn(mdev, "Failed to register bridge offloads netdevice notifier (err=%d)\n",
 			 err);
@@ -526,7 +526,7 @@ void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	cancel_delayed_work_sync(&br_offloads->update_work);
-	unregister_netdevice_notifier(&br_offloads->netdev_nb);
+	unregister_netdevice_notifier_net(&init_net, &br_offloads->netdev_nb);
 	unregister_switchdev_blocking_notifier(&br_offloads->nb_blk);
 	unregister_switchdev_notifier(&br_offloads->nb);
 	destroy_workqueue(br_offloads->wq);
-- 
2.34.1

