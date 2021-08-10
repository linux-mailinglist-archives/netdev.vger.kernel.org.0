Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4773E5BE5
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241715AbhHJNiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241627AbhHJNiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6164C60F41;
        Tue, 10 Aug 2021 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628602671;
        bh=5iOodNNf45LFVCbt+fmoQm3wJTc3Bn41NbczBUOICdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGgVcfxf3mfkzE5QcBNSUZANrCaArrN3n44pxkAHiyC7gJlODQ79mFlJjVGSYih6I
         7x3Z8O0GVF7FjRTagQctw8YZqMifXLZyl7EWqGIXaB6xrtawSiYru+UfJHDhfVMMjw
         rB4tp6b6U9CiAFwmnfHls6y9cdKMVNtYDj8DrkATStOc5yMw96Nl8q7TAy7nvhIvLs
         WMDjQ+BN/ew4Dxzd5weLaCL2CeQihYAe+/B6PM5KZmuWiQLhdNcgDCHh2Ln5Bt8jN7
         Tklxk5CoHs3sNV9H9cIhy85lTczhdc2D6nfWbjeJRKsDyLm7BbaNqYOwjJ6SA5fefm
         rDnZnJxn4tkeg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 4/5] net/mlx5: Accept devlink user input after driver initialization complete
Date:   Tue, 10 Aug 2021 16:37:34 +0300
Message-Id: <1d6c2ebf166ed742dc53a2b3c25bb5b8afdcf7ec.1628599239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628599239.git.leonro@nvidia.com>
References: <cover.1628599239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The change of devlink_alloc() to accept device makes sure that device
is fully initialized and device_register() does nothing except allowing
users to use that devlink instance.

Such change ensures that no user input will be usable till that point and
it eliminates the need to worry about internal locking as long as devlink_register
is called last since all accesses to the devlink are during initialization.

This change fixes the following lockdep warning.

 ======================================================
 WARNING: possible circular locking dependency detected
 5.14.0-rc2+ #27 Not tainted
 ------------------------------------------------------
 devlink/265 is trying to acquire lock:
 ffff8880133c2bc0 (&dev->intf_state_mutex){+.+.}-{3:3}, at: mlx5_unload_one+0x1e/0xa0 [mlx5_core]
 but task is already holding lock:
 ffffffff8362b468 (devlink_mutex){+.+.}-{3:3}, at: devlink_nl_pre_doit+0x2b/0x8d0
 which lock already depends on the new lock.
 the existing dependency chain (in reverse order) is:

 -> #1 (devlink_mutex){+.+.}-{3:3}:
        __mutex_lock+0x149/0x1310
        devlink_register+0xe7/0x280
        mlx5_devlink_register+0x118/0x480 [mlx5_core]
        mlx5_init_one+0x34b/0x440 [mlx5_core]
        probe_one+0x480/0x6e0 [mlx5_core]
        pci_device_probe+0x2a0/0x4a0
        really_probe+0x1cb/0xba0
        __driver_probe_device+0x18f/0x470
        driver_probe_device+0x49/0x120
        __driver_attach+0x1ce/0x400
        bus_for_each_dev+0x11e/0x1a0
        bus_add_driver+0x309/0x570
        driver_register+0x20f/0x390
        0xffffffffa04a0062
        do_one_initcall+0xd5/0x400
        do_init_module+0x1c8/0x760
        load_module+0x7d9d/0xa4b0
        __do_sys_finit_module+0x118/0x1a0
        do_syscall_64+0x3d/0x90
        entry_SYSCALL_64_after_hwframe+0x44/0xae

 -> #0 (&dev->intf_state_mutex){+.+.}-{3:3}:
        __lock_acquire+0x2999/0x5a40
        lock_acquire+0x1a9/0x4a0
        __mutex_lock+0x149/0x1310
        mlx5_unload_one+0x1e/0xa0 [mlx5_core]
        mlx5_devlink_reload_down+0x185/0x2b0 [mlx5_core]
        devlink_reload+0x1f2/0x640
        devlink_nl_cmd_reload+0x6c3/0x10d0
        genl_family_rcv_msg_doit+0x1e9/0x2f0
        genl_rcv_msg+0x27f/0x4a0
        netlink_rcv_skb+0x11e/0x340
        genl_rcv+0x24/0x40
        netlink_unicast+0x433/0x700
        netlink_sendmsg+0x6fb/0xbe0
        sock_sendmsg+0xb0/0xe0
        __sys_sendto+0x192/0x240
        __x64_sys_sendto+0xdc/0x1b0
        do_syscall_64+0x3d/0x90
        entry_SYSCALL_64_after_hwframe+0x44/0xae

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(devlink_mutex);
                                lock(&dev->intf_state_mutex);
                                lock(devlink_mutex);
   lock(&dev->intf_state_mutex);

  *** DEADLOCK ***

 3 locks held by devlink/265:
  #0: ffffffff836371d0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40
  #1: ffffffff83637288 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x31a/0x4a0
  #2: ffffffff8362b468 (devlink_mutex){+.+.}-{3:3}, at: devlink_nl_pre_doit+0x2b/0x8d0

 stack backtrace:
 CPU: 0 PID: 265 Comm: devlink Not tainted 5.14.0-rc2+ #27
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Call Trace:
  dump_stack_lvl+0x45/0x59
  check_noncircular+0x268/0x310
  ? print_circular_bug+0x460/0x460
  ? __kernel_text_address+0xe/0x30
  ? alloc_chain_hlocks+0x1e6/0x5a0
  __lock_acquire+0x2999/0x5a40
  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
  ? add_lock_to_list.constprop.0+0x6c/0x530
  lock_acquire+0x1a9/0x4a0
  ? mlx5_unload_one+0x1e/0xa0 [mlx5_core]
  ? lock_release+0x6c0/0x6c0
  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
  ? lock_is_held_type+0x98/0x110
  __mutex_lock+0x149/0x1310
  ? mlx5_unload_one+0x1e/0xa0 [mlx5_core]
  ? lock_is_held_type+0x98/0x110
  ? mlx5_unload_one+0x1e/0xa0 [mlx5_core]
  ? find_held_lock+0x2d/0x110
  ? mutex_lock_io_nested+0x1160/0x1160
  ? mlx5_lag_is_active+0x72/0x90 [mlx5_core]
  ? lock_downgrade+0x6d0/0x6d0
  ? do_raw_spin_lock+0x12e/0x270
  ? rwlock_bug.part.0+0x90/0x90
  ? mlx5_unload_one+0x1e/0xa0 [mlx5_core]
  mlx5_unload_one+0x1e/0xa0 [mlx5_core]
  mlx5_devlink_reload_down+0x185/0x2b0 [mlx5_core]
  ? netlink_broadcast_filtered+0x308/0xac0
  ? mlx5_devlink_info_get+0x1f0/0x1f0 [mlx5_core]
  ? __build_skb_around+0x110/0x2b0
  ? __alloc_skb+0x113/0x2b0
  devlink_reload+0x1f2/0x640
  ? devlink_unregister+0x1e0/0x1e0
  ? security_capable+0x51/0x90
  devlink_nl_cmd_reload+0x6c3/0x10d0
  ? devlink_nl_cmd_get_doit+0x1e0/0x1e0
  ? devlink_nl_pre_doit+0x72/0x8d0
  genl_family_rcv_msg_doit+0x1e9/0x2f0
  ? __lock_acquire+0x15e2/0x5a40
  ? genl_family_rcv_msg_attrs_parse.constprop.0+0x240/0x240
  ? mutex_lock_io_nested+0x1160/0x1160
  ? security_capable+0x51/0x90
  genl_rcv_msg+0x27f/0x4a0
  ? genl_get_cmd+0x3c0/0x3c0
  ? lock_acquire+0x1a9/0x4a0
  ? devlink_nl_cmd_get_doit+0x1e0/0x1e0
  ? lock_release+0x6c0/0x6c0
  netlink_rcv_skb+0x11e/0x340
  ? genl_get_cmd+0x3c0/0x3c0
  ? netlink_ack+0x930/0x930
  genl_rcv+0x24/0x40
  netlink_unicast+0x433/0x700
  ? netlink_attachskb+0x750/0x750
  ? __alloc_skb+0x113/0x2b0
  netlink_sendmsg+0x6fb/0xbe0
  ? netlink_unicast+0x700/0x700
  ? netlink_unicast+0x700/0x700
  sock_sendmsg+0xb0/0xe0
  __sys_sendto+0x192/0x240
  ? __x64_sys_getpeername+0xb0/0xb0
  ? do_sys_openat2+0x10a/0x370
  ? down_write_nested+0x150/0x150
  ? do_user_addr_fault+0x215/0xd50
  ? __x64_sys_openat+0x11f/0x1d0
  ? __x64_sys_open+0x1a0/0x1a0
  __x64_sys_sendto+0xdc/0x1b0
  ? syscall_enter_from_user_mode+0x1d/0x50
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f50b50b6b3a
 Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 76 c3 0f 1f 44 00 00 55 48 83 ec 30 44 89 4c
 RSP: 002b:00007fff6c0d3f38 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
 RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f50b50b6b3a
 RDX: 0000000000000038 RSI: 000055763ac08440 RDI: 0000000000000003
 RBP: 000055763ac08410 R08: 00007f50b5192200 R09: 000000000000000c
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000000000000000 R14: 000055763ac08410 R15: 000055763ac08440
 mlx5_core 0000:00:09.0: firmware version: 4.8.9999
 mlx5_core 0000:00:09.0: 0.000 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x255 link)
 mlx5_core 0000:00:09.0 eth1: Link up

Fixes: a6f3b62386a0 ("net/mlx5: Move devlink registration before interfaces load")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c   | 10 ++--------
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 13 ++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 12 ++++++++++--
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index f38553ff538b..9b058f97c8fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -643,14 +643,11 @@ int mlx5_devlink_register(struct devlink *devlink)
 {
 	int err;
 
-	err = devlink_register(devlink);
-	if (err)
-		return err;
-
 	err = devlink_params_register(devlink, mlx5_devlink_params,
 				      ARRAY_SIZE(mlx5_devlink_params));
 	if (err)
-		goto params_reg_err;
+		return err;
+
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
 
@@ -663,8 +660,6 @@ int mlx5_devlink_register(struct devlink *devlink)
 traps_reg_err:
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
-params_reg_err:
-	devlink_unregister(devlink);
 	return err;
 }
 
@@ -673,5 +668,4 @@ void mlx5_devlink_unregister(struct devlink *devlink)
 	mlx5_devlink_traps_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
-	devlink_unregister(devlink);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a8efd9f1af4c..9f10049a63f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1494,10 +1494,20 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
+	err = devlink_register(devlink);
+	if (err) {
+		mlx5_core_err(dev,
+			      "devlink_register failed with error code %d\n",
+			      err);
+		goto devlink_reg_err;
+	}
 	if (!mlx5_core_is_mp_slave(dev))
 		devlink_reload_enable(devlink);
 	return 0;
-
+devlink_reg_err:
+	mlx5_crdump_disable(dev);
+	mlx5_drain_health_wq(dev);
+	mlx5_uninit_one(dev);
 err_init_one:
 	mlx5_pci_close(dev);
 pci_init_err:
@@ -1516,6 +1526,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devlink_reload_disable(devlink);
+	devlink_unregister(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 052f48068dc1..b0f2b9db6d85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -46,9 +46,17 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
 		goto init_one_err;
 	}
+
+	err = devlink_register(devlink);
+	if (err) {
+		mlx5_core_warn(mdev, "devlink_register err=%d\n", err);
+		goto devlink_reg_err;
+	}
 	devlink_reload_enable(devlink);
 	return 0;
 
+devlink_reg_err:
+	mlx5_uninit_one(mdev);
 init_one_err:
 	iounmap(mdev->iseg);
 remap_err:
@@ -61,10 +69,10 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 {
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
-	struct devlink *devlink;
+	struct devlink *devlink = priv_to_devlink(sf_dev->mdev);
 
-	devlink = priv_to_devlink(sf_dev->mdev);
 	devlink_reload_disable(devlink);
+	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
 	mlx5_mdev_uninit(sf_dev->mdev);
-- 
2.31.1

