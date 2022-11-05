Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8ADB61D81B
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKEHKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKEHKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:10:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81EF2D1F1
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F1D9604EF
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFFDC433D6;
        Sat,  5 Nov 2022 07:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632239;
        bh=kOdsZRiv1HyCBToNXoUhw6burHFf84lwGJyD3yHQNa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uz1tesBW2gDkGuckLW/UPjoKN4WjndbHPUnXsIVCgsbG/qDtP5fXNvXAr5NBw1UwB
         DCLjfVWL6uP+kgj2FsvjadiYfEjoeQOlQotsaedOAuMOXmT2Uf7Dk34qLNR+lzb0bl
         7Jbu4XWuxDZ9lTyJ2Qqictde9pM1KOBB8E8+6Tz8W5lknbk7p206e8dXjDDkGnl1+t
         nkvhBIKlG24yvPWfPiPnN/OR80MtSrnW+2ZcoC6uAfGGY3d+qp3EPRg426Ifs1tLCu
         iqtd33sl5L34sK4Zcho9R8Tc+Do58/p3kd++F1AEjFuqAkQPhFnKVyD3Cqhwo1zjmE
         hW4pAfoHVIjdw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [V2 net 05/11] net/mlx5: Fix possible deadlock on mlx5e_tx_timeout_work
Date:   Sat,  5 Nov 2022 00:10:22 -0700
Message-Id: <20221105071028.578594-6-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221105071028.578594-1-saeed@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Due to the cited patch, devlink health commands take devlink lock and
this may result in deadlock for mlx5e_tx_reporter as it takes local
state_lock before calling devlink health report and on the other hand
devlink health commands such as diagnose for same reporter take local
state_lock after taking devlink lock (see kernel log below).

To fix it, remove local state_lock from mlx5e_tx_timeout_work() before
calling devlink_health_report() and take care to cancel the work before
any call to close channels, which may free the SQs that should be
handled by the work. Before cancel_work_sync(), use current_work() to
check we are not calling it from within the work, as
mlx5e_tx_timeout_work() itself may close the channels and reopen as part
of recovery flow.

Kernel log:
======================================================
WARNING: possible circular locking dependency detected
6.0.0-rc3_for_upstream_debug_2022_08_30_13_10 #1 Not tainted
------------------------------------------------------
kworker/u16:2/65 is trying to acquire lock:
ffff888122f6c2f8 (&devlink->lock_key#2){+.+.}-{3:3}, at: devlink_health_report+0x2f1/0x7e0

but task is already holding lock:
ffff888121d20be0 (&priv->state_lock){+.+.}-{3:3}, at: mlx5e_tx_timeout_work+0x70/0x280 [mlx5_core]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&priv->state_lock){+.+.}-{3:3}:
       __mutex_lock+0x12c/0x14b0
       mlx5e_rx_reporter_diagnose+0x71/0x700 [mlx5_core]
       devlink_nl_cmd_health_reporter_diagnose_doit+0x212/0xa50
       genl_family_rcv_msg_doit+0x1e9/0x2f0
       genl_rcv_msg+0x2e9/0x530
       netlink_rcv_skb+0x11d/0x340
       genl_rcv+0x24/0x40
       netlink_unicast+0x438/0x710
       netlink_sendmsg+0x788/0xc40
       sock_sendmsg+0xb0/0xe0
       __sys_sendto+0x1c1/0x290
       __x64_sys_sendto+0xdd/0x1b0
       do_syscall_64+0x3d/0x90
       entry_SYSCALL_64_after_hwframe+0x46/0xb0

-> #0 (&devlink->lock_key#2){+.+.}-{3:3}:
       __lock_acquire+0x2c8a/0x6200
       lock_acquire+0x1c1/0x550
       __mutex_lock+0x12c/0x14b0
       devlink_health_report+0x2f1/0x7e0
       mlx5e_health_report+0xc9/0xd7 [mlx5_core]
       mlx5e_reporter_tx_timeout+0x2ab/0x3d0 [mlx5_core]
       mlx5e_tx_timeout_work+0x1c1/0x280 [mlx5_core]
       process_one_work+0x7c2/0x1340
       worker_thread+0x59d/0xec0
       kthread+0x28f/0x330
       ret_from_fork+0x1f/0x30

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&priv->state_lock);
                               lock(&devlink->lock_key#2);
                               lock(&priv->state_lock);
  lock(&devlink->lock_key#2);

 *** DEADLOCK ***

4 locks held by kworker/u16:2/65:
 #0: ffff88811a55b138 ((wq_completion)mlx5e#2){+.+.}-{0:0}, at: process_one_work+0x6e2/0x1340
 #1: ffff888101de7db8 ((work_completion)(&priv->tx_timeout_work)){+.+.}-{0:0}, at: process_one_work+0x70f/0x1340
 #2: ffffffff84ce8328 (rtnl_mutex){+.+.}-{3:3}, at: mlx5e_tx_timeout_work+0x53/0x280 [mlx5_core]
 #3: ffff888121d20be0 (&priv->state_lock){+.+.}-{3:3}, at: mlx5e_tx_timeout_work+0x70/0x280 [mlx5_core]

stack backtrace:
CPU: 1 PID: 65 Comm: kworker/u16:2 Not tainted 6.0.0-rc3_for_upstream_debug_2022_08_30_13_10 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: mlx5e mlx5e_tx_timeout_work [mlx5_core]
Call Trace:
 <TASK>
 dump_stack_lvl+0x57/0x7d
 check_noncircular+0x278/0x300
 ? print_circular_bug+0x460/0x460
 ? find_held_lock+0x2d/0x110
 ? __stack_depot_save+0x24c/0x520
 ? alloc_chain_hlocks+0x228/0x700
 __lock_acquire+0x2c8a/0x6200
 ? register_lock_class+0x1860/0x1860
 ? kasan_save_stack+0x1e/0x40
 ? kasan_set_free_info+0x20/0x30
 ? ____kasan_slab_free+0x11d/0x1b0
 ? kfree+0x1ba/0x520
 ? devlink_health_do_dump.part.0+0x171/0x3a0
 ? devlink_health_report+0x3d5/0x7e0
 lock_acquire+0x1c1/0x550
 ? devlink_health_report+0x2f1/0x7e0
 ? lockdep_hardirqs_on_prepare+0x400/0x400
 ? find_held_lock+0x2d/0x110
 __mutex_lock+0x12c/0x14b0
 ? devlink_health_report+0x2f1/0x7e0
 ? devlink_health_report+0x2f1/0x7e0
 ? mutex_lock_io_nested+0x1320/0x1320
 ? trace_hardirqs_on+0x2d/0x100
 ? bit_wait_io_timeout+0x170/0x170
 ? devlink_health_do_dump.part.0+0x171/0x3a0
 ? kfree+0x1ba/0x520
 ? devlink_health_do_dump.part.0+0x171/0x3a0
 devlink_health_report+0x2f1/0x7e0
 mlx5e_health_report+0xc9/0xd7 [mlx5_core]
 mlx5e_reporter_tx_timeout+0x2ab/0x3d0 [mlx5_core]
 ? lockdep_hardirqs_on_prepare+0x400/0x400
 ? mlx5e_reporter_tx_err_cqe+0x1b0/0x1b0 [mlx5_core]
 ? mlx5e_tx_reporter_timeout_dump+0x70/0x70 [mlx5_core]
 ? mlx5e_tx_reporter_dump_sq+0x320/0x320 [mlx5_core]
 ? mlx5e_tx_timeout_work+0x70/0x280 [mlx5_core]
 ? mutex_lock_io_nested+0x1320/0x1320
 ? process_one_work+0x70f/0x1340
 ? lockdep_hardirqs_on_prepare+0x400/0x400
 ? lock_downgrade+0x6e0/0x6e0
 mlx5e_tx_timeout_work+0x1c1/0x280 [mlx5_core]
 process_one_work+0x7c2/0x1340
 ? lockdep_hardirqs_on_prepare+0x400/0x400
 ? pwq_dec_nr_in_flight+0x230/0x230
 ? rwlock_bug.part.0+0x90/0x90
 worker_thread+0x59d/0xec0
 ? process_one_work+0x1340/0x1340
 kthread+0x28f/0x330
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: c90005b5f75c ("devlink: Hold the instance lock in health callbacks")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 364f04309149..09296f1ae448 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2954,6 +2954,9 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	netif_carrier_off(netdev);
 
 	mlx5e_deactivate_priv_channels(priv);
+	/* Once deactivated, new tx_timeout_work won't be initiated. */
+	if (current_work() != &priv->tx_timeout_work)
+		cancel_work_sync(&priv->tx_timeout_work);
 
 	old_chs = priv->channels;
 	priv->channels = *new_chs;
@@ -3106,6 +3109,7 @@ int mlx5e_close_locked(struct net_device *netdev)
 
 	netif_carrier_off(priv->netdev);
 	mlx5e_deactivate_priv_channels(priv);
+	cancel_work_sync(&priv->tx_timeout_work);
 	mlx5e_close_channels(&priv->channels);
 
 	return 0;
@@ -4657,7 +4661,6 @@ static void mlx5e_tx_timeout_work(struct work_struct *work)
 	int i;
 
 	rtnl_lock();
-	mutex_lock(&priv->state_lock);
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		goto unlock;
@@ -4676,7 +4679,6 @@ static void mlx5e_tx_timeout_work(struct work_struct *work)
 	}
 
 unlock:
-	mutex_unlock(&priv->state_lock);
 	rtnl_unlock();
 }
 
-- 
2.38.1

