Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4393D42AE3A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhJLUzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234787AbhJLUza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 16:55:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6464C60E09;
        Tue, 12 Oct 2021 20:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634072008;
        bh=wlxcfEJmGwlkekdFOWGIBR/thzjxkCg6JgGbcnDEm8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCf4IqYv142vvji0mgSJ7pSUTT+IFcrCScpTzMcNOELuNQpOHp80jWdNwsAGNr3Ob
         2GHNDTKFd5Nrs40moEfYS8YNdbB8/1WuDMRB31Yzns0e63BxkSNVo7wWLQwLoIcUse
         sgKdih/oIH92PzlWQhTTc5zfaHfNnCGp6sagFvbXiDaunJH9uZU9Hi4tlRBjZ8WEzy
         ikafM0EZtNttOHu6AHY6VBr14k3XwvfDV3w2UgdXWN9c509Z+B39UjnLimk4pWoeZi
         pgOnaqIW0O4N2nh0ymhUBZUb593kP8sE6wZGNjIh0NL3xHqwo7TVpMzrSzztytwAa1
         ZFKNUeyu5Hjsw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/6] net/mlx5: Fix cleanup of bridge delayed work
Date:   Tue, 12 Oct 2021 13:53:18 -0700
Message-Id: <20211012205323.20123-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012205323.20123-1-saeed@kernel.org>
References: <20211012205323.20123-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, bridge cleanup is calling to cancel_delayed_work(). When this
function is finished, there is a chance that the delayed work is still
running. Also, the delayed work is queueing itself.
As a result, we might execute the delayed work after the bridge cleanup
have finished and hit a null-ptr oops[1].

Fix it by using cancel_delayed_work_sync(), which is waiting until the
work is done and will cancel the queue work.

[1]
[ 8202.143043 ] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 8202.144438 ] #PF: supervisor write access in kernel mode
[ 8202.145476 ] #PF: error_code(0x0002) - not-present page
[ 8202.146520 ] PGD 0 P4D 0
[ 8202.147126 ] Oops: 0002 [#1] SMP NOPTI
[ 8202.147899 ] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.14.0-rc6_for_upstream_min_debug_2021_08_25_16_06 #1
[ 8202.149741 ] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[ 8202.151908 ] RIP: 0010:_raw_spin_lock+0xc/0x20
[ 8202.156234 ] RSP: 0018:ffff88846f885ea0 EFLAGS: 00010046
[ 8202.157289 ] RAX: 0000000000000000 RBX: ffff88846f880000 RCX: 0000000000000000
[ 8202.158731 ] RDX: 0000000000000001 RSI: ffff8881004000c8 RDI: 0000000000000000
[ 8202.160177 ] RBP: ffff8881fe684978 R08: ffff888100140000 R09: ffffffff824455b8
[ 8202.161569 ] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[ 8202.163004 ] R13: 0000000000000012 R14: 0000000000000200 R15: ffff88812992d000
[ 8202.164018 ] FS:  0000000000000000(0000) GS:ffff88846f880000(0000) knlGS:0000000000000000
[ 8202.164960 ] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8202.165634 ] CR2: 0000000000000000 CR3: 0000000108cac004 CR4: 0000000000370ea0
[ 8202.166450 ] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8202.167807 ] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 8202.168852 ] Call Trace:
[ 8202.169421 ]  <IRQ>
[ 8202.169792 ]  __queue_work+0xf2/0x3d0
[ 8202.170481 ]  ? queue_work_node+0x40/0x40
[ 8202.171270 ]  call_timer_fn+0x2b/0x100
[ 8202.171932 ]  __run_timers.part.0+0x152/0x220
[ 8202.172717 ]  ? __hrtimer_run_queues+0x171/0x290
[ 8202.173526 ]  ? kvm_clock_get_cycles+0xd/0x10
[ 8202.174232 ]  ? ktime_get+0x35/0x90
[ 8202.174943 ]  run_timer_softirq+0x26/0x50
[ 8202.175745 ]  __do_softirq+0xc7/0x271
[ 8202.176373 ]  irq_exit_rcu+0x93/0xb0
[ 8202.176983 ]  sysvec_apic_timer_interrupt+0x72/0x90
[ 8202.177755 ]  </IRQ>
[ 8202.178245 ]  asm_sysvec_apic_timer_interrupt+0x12/0x20

Fixes: c636a0f0f3f0 ("net/mlx5: Bridge, dynamic entry ageing")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index b5ddaa82755f..c6d2f8c78db7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -475,9 +475,6 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 		esw_warn(mdev, "Failed to allocate bridge offloads workqueue\n");
 		goto err_alloc_wq;
 	}
-	INIT_DELAYED_WORK(&br_offloads->update_work, mlx5_esw_bridge_update_work);
-	queue_delayed_work(br_offloads->wq, &br_offloads->update_work,
-			   msecs_to_jiffies(MLX5_ESW_BRIDGE_UPDATE_INTERVAL));
 
 	br_offloads->nb.notifier_call = mlx5_esw_bridge_switchdev_event;
 	err = register_switchdev_notifier(&br_offloads->nb);
@@ -500,6 +497,9 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 			 err);
 		goto err_register_netdev;
 	}
+	INIT_DELAYED_WORK(&br_offloads->update_work, mlx5_esw_bridge_update_work);
+	queue_delayed_work(br_offloads->wq, &br_offloads->update_work,
+			   msecs_to_jiffies(MLX5_ESW_BRIDGE_UPDATE_INTERVAL));
 	return;
 
 err_register_netdev:
@@ -523,10 +523,10 @@ void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
 	if (!br_offloads)
 		return;
 
+	cancel_delayed_work_sync(&br_offloads->update_work);
 	unregister_netdevice_notifier(&br_offloads->netdev_nb);
 	unregister_switchdev_blocking_notifier(&br_offloads->nb_blk);
 	unregister_switchdev_notifier(&br_offloads->nb);
-	cancel_delayed_work(&br_offloads->update_work);
 	destroy_workqueue(br_offloads->wq);
 	rtnl_lock();
 	mlx5_esw_bridge_cleanup(esw);
-- 
2.31.1

