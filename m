Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16760449AC7
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbhKHRfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230348AbhKHRfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:35:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC35A60D07;
        Mon,  8 Nov 2021 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636392743;
        bh=W+U0YuhMmHqVj32jBJZKbSWPlhS/yukLMU5H8zvlcM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=szgi1V9dMWe7gZMgvd4tRbMJiG6BFwVhdwBTV3xk7dpX4OiarxJI+HqC02Wtax0NQ
         z8x5pwBg6VoaQX7/Ru98VQXvCok27IHd9LIWviXamxG6pw5I1Xo9wbz0o3eGJmDS1k
         UG51FxAafOLe34ouF+qxQYpVryObKSG9oxFPF4CQUYsRE/tps+W9SjbM7zEfeyn2c/
         BM3kh8r4SQL0rwAdPoBofZFCK9o2pz/bu0WybD6a0G01J9LjnlJQo/Ny3P8+f2eoJR
         AHKCt9gTiWnYdEfiqnxRh8p4DKGYpkjgkdcGE42fBdjl2qsG5CXh3F2Z7ua3PfRo7w
         Q6twNO1sTjbEA==
Date:   Mon, 8 Nov 2021 19:32:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYlfI4UgpEsMt5QI@unreal>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
 <YYABqfFy//g5Gdis@nanopsycho>
 <YYBTg4nW2BIVadYE@shredder>
 <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
 <YYgJ1bnECwUWvNqD@shredder>
 <YYgSzEHppKY3oYTb@unreal>
 <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 08:09:18AM -0800, Jakub Kicinski wrote:
> On Sun, 7 Nov 2021 19:54:20 +0200 Leon Romanovsky wrote:
> > > >  (3) should we let drivers take refs on the devlink instance?  
> > > 
> > > I think it's fine mainly because I don't expect it to be used by too
> > > many drivers other than netdevsim which is somewhat special. Looking at
> > > the call sites of devlink_get() in netdevsim, it is only called from
> > > places (debugfs and trap workqueue) that shouldn't be present in real
> > > drivers.  
> > 
> > Sorry, I'm obligated to ask. In which universe is it ok to create new
> > set of API that no real driver should use?
> 
> I think it's common sense. We're just exporting something to make our
> lives easier somewhere else in the three. Do you see a way in which
> taking refs on devlink can help out-of-tree code?

I didn't go such far in my thoughts. My main concern is that you ore
exposing broken devlink internals in the hope that drivers will do better
locking. I wanted to show that internal locking should be fixed first.

https://lore.kernel.org/netdev/cover.1636390483.git.leonro@nvidia.com/T/#m093f067d0cafcbe6c05ed469bcfd708dd1eb7f36

While this series fixes locking and after all my changes devlink started
to be more secure, that works correctly for simple drivers. However for
net namespace aware drivers it still stays DOA.

As you can see, devlink reload holds pernet_ops_rwsem, which drivers should
take too in order to unregister_netdevice_notifier.

So for me, the difference between netdevsim and real device (mlx5) is
too huge to really invest time into netdevsim-centric API, because it
won't solve any of real world problems.

sudo ip netns add n1
sudo devlink dev reload pci/0000:00:09.0 netns n1
sudo ip netns del n1

[  463.357081] ======================================================
[  463.357309] WARNING: possible circular locking dependency detected
[  463.357452] 5.15.0-rc7+ #286 Not tainted
[  463.357532] ------------------------------------------------------
[  463.357668] kworker/u16:1/9 is trying to acquire lock:
[  463.357777] ffff888011694648 (&devlink->lock){+.+.}-{3:3}, at: devlink_pernet_pre_exit+0x1b4/0x2a0
[  463.358006] 
[  463.358006] but task is already holding lock:
[  463.358150] ffffffff83602a50 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9c/0x8e0
[  463.358334] 
[  463.358334] which lock already depends on the new lock.
[  463.358334] 
[  463.358923] 
[  463.358923] the existing dependency chain (in reverse order) is:
[  463.359093] 
[  463.359093] -> #3 (pernet_ops_rwsem){++++}-{3:3}:
[  463.359291]        down_write+0x92/0x150
[  463.359386]        unregister_netdevice_notifier+0x1e/0x150
[  463.359519]        mlx5_ib_roce_cleanup+0x23a/0x480 [mlx5_ib]
[  463.359709]        mlx5r_remove+0xb4/0x130 [mlx5_ib]
[  463.359873]        auxiliary_bus_remove+0x52/0x70
[  463.359997]        __device_release_driver+0x334/0x660
[  463.360110]        device_release_driver+0x26/0x40
[  463.360225]        bus_remove_device+0x2a5/0x560
[  463.360331]        device_del+0x489/0xb80
[  463.360423]        mlx5_detach_device+0x14b/0x2c0 [mlx5_core]
[  463.360677]        mlx5_unload_one+0x2d/0xa0 [mlx5_core]
[  463.360849]        mlx5_devlink_reload_down+0x1be/0x360 [mlx5_core]
[  463.361019]        devlink_reload+0x48b/0x610
[  463.361108]        devlink_nl_cmd_reload+0x5c3/0xf90
[  463.361192]        genl_family_rcv_msg_doit+0x1e9/0x2f0
[  463.361288]        genl_rcv_msg+0x27f/0x4a0
[  463.361378]        netlink_rcv_skb+0x11e/0x340
[  463.361470]        genl_rcv+0x24/0x40
[  463.361538]        netlink_unicast+0x433/0x700
[  463.361627]        netlink_sendmsg+0x705/0xbe0
[  463.361720]        sock_sendmsg+0xb0/0xe0
[  463.361792]        __sys_sendto+0x192/0x240
[  463.361855]        __x64_sys_sendto+0xdc/0x1b0
[  463.361953]        do_syscall_64+0x3d/0x90
[  463.362016]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  463.362108] 
[  463.362108] -> #2 (mlx5_intf_mutex){+.+.}-{3:3}:
[  463.362249]        __mutex_lock+0x150/0x15c0
[  463.362340]        mlx5_lag_add_mdev+0x36/0x5e0 [mlx5_core]
[  463.362490]        mlx5_load+0x155/0x1c0 [mlx5_core]
[  463.362615]        mlx5_init_one+0x2d5/0x400 [mlx5_core]
[  463.362751]        probe_one+0x430/0x680 [mlx5_core]
[  463.362874]        pci_device_probe+0x2a0/0x4a0
[  463.362996]        really_probe+0x1cc/0xba0
[  463.363066]        __driver_probe_device+0x18f/0x470
[  463.363147]        driver_probe_device+0x49/0x120
[  463.363258]        __driver_attach+0x1ce/0x400
[  463.363358]        bus_for_each_dev+0x11e/0x1a0
[  463.363462]        bus_add_driver+0x309/0x570
[  463.363558]        driver_register+0x20f/0x390
[  463.363661]        value_read+0x62/0x160 [ib_core]
[  463.363821]        do_one_initcall+0xd5/0x400
[  463.363929]        do_init_module+0x1c8/0x760
[  463.364035]        load_module+0x7d9d/0xa4b0
[  463.364133]        __do_sys_finit_module+0x118/0x1a0
[  463.364232]        do_syscall_64+0x3d/0x90
[  463.364321]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  463.364422] 
[  463.364422] -> #1 (&dev->intf_state_mutex){+.+.}-{3:3}:
[  463.364554]        __mutex_lock+0x150/0x15c0
[  463.364658]        mlx5_unload_one+0x1e/0xa0 [mlx5_core]
[  463.364787]        mlx5_devlink_reload_down+0x1be/0x360 [mlx5_core]
[  463.364946]        devlink_reload+0x48b/0x610
[  463.365040]        devlink_nl_cmd_reload+0x5c3/0xf90
[  463.365137]        genl_family_rcv_msg_doit+0x1e9/0x2f0
[  463.365245]        genl_rcv_msg+0x27f/0x4a0
[  463.365310]        netlink_rcv_skb+0x11e/0x340
[  463.365404]        genl_rcv+0x24/0x40
[  463.365477]        netlink_unicast+0x433/0x700
[  463.365576]        netlink_sendmsg+0x705/0xbe0
[  463.365666]        sock_sendmsg+0xb0/0xe0
[  463.365746]        __sys_sendto+0x192/0x240
[  463.365817]        __x64_sys_sendto+0xdc/0x1b0
[  463.365907]        do_syscall_64+0x3d/0x90
[  463.365980]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  463.366074] 
[  463.366074] -> #0 (&devlink->lock){+.+.}-{3:3}:
[  463.366209]        __lock_acquire+0x2999/0x5a40
[  463.366322]        lock_acquire+0x1a9/0x4a0
[  463.366401]        __mutex_lock+0x150/0x15c0
[  463.366499]        devlink_pernet_pre_exit+0x1b4/0x2a0
[  463.366598]        cleanup_net+0x372/0x8e0
[  463.366674]        process_one_work+0x8f5/0x1580
[  463.366779]        worker_thread+0x58d/0x1330
[  463.366881]        kthread+0x379/0x450
[  463.366952]        ret_from_fork+0x1f/0x30
[  463.367020] 
[  463.367020] other info that might help us debug this:
[  463.367020] 
[  463.367173] Chain exists of:
[  463.367173]   &devlink->lock --> mlx5_intf_mutex --> pernet_ops_rwsem
[  463.367173] 
[  463.367360]  Possible unsafe locking scenario:
[  463.367360] 
[  463.367478]        CPU0                    CPU1
[  463.367574]        ----                    ----
[  463.367663]   lock(pernet_ops_rwsem);
[  463.367748]                                lock(mlx5_intf_mutex);
[  463.367874]                                lock(pernet_ops_rwsem);
[  463.368027]   lock(&devlink->lock);
[  463.368098] 
[  463.368098]  *** DEADLOCK ***
[  463.368098] 
[  463.368233] 3 locks held by kworker/u16:1/9:
[  463.368347]  #0: ffff888005df8938 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x80a/0x1580
[  463.371930]  #1: ffff8880059c7db0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x837/0x1580
[  463.372376]  #2: ffffffff83602a50 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9c/0x8e0
[  463.372638] 
[  463.372638] stack backtrace:
[  463.372804] CPU: 3 PID: 9 Comm: kworker/u16:1 Not tainted 5.15.0-rc7+ #286
[  463.372965] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  463.373258] Workqueue: netns cleanup_net
[  463.373366] Call Trace:
[  463.373444]  dump_stack_lvl+0x45/0x59
[  463.373545]  check_noncircular+0x268/0x310
[  463.373639]  ? print_circular_bug+0x460/0x460
[  463.373767]  ? mark_lock+0x104/0x2e30
[  463.373899]  ? find_busiest_group+0x1bc0/0x27a0
[  463.374083]  ? alloc_chain_hlocks+0x1e6/0x5a0
[  463.374254]  __lock_acquire+0x2999/0x5a40
[  463.374344]  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
[  463.374480]  ? __lock_acquire+0xbec/0x5a40
[  463.374585]  lock_acquire+0x1a9/0x4a0
[  463.374693]  ? devlink_pernet_pre_exit+0x1b4/0x2a0
[  463.374817]  ? lock_release+0x6c0/0x6c0
[  463.374905]  ? lock_is_held_type+0x98/0x110
[  463.374996]  ? lock_is_held_type+0x98/0x110
[  463.375089]  __mutex_lock+0x150/0x15c0
[  463.375178]  ? devlink_pernet_pre_exit+0x1b4/0x2a0
[  463.375291]  ? lock_downgrade+0x6d0/0x6d0
[  463.375381]  ? devlink_pernet_pre_exit+0x1b4/0x2a0
[  463.375507]  ? lock_is_held_type+0x98/0x110
[  463.375602]  ? find_held_lock+0x2d/0x110
[  463.375698]  ? mutex_lock_io_nested+0x1400/0x1400
[  463.375848]  ? lock_release+0x1f9/0x6c0
[  463.375978]  ? devlink_pernet_pre_exit+0x17e/0x2a0
[  463.376105]  ? lock_downgrade+0x6d0/0x6d0
[  463.376195]  ? lock_is_held_type+0x98/0x110
[  463.376283]  ? find_held_lock+0x2d/0x110
[  463.376379]  ? devlink_pernet_pre_exit+0x1b4/0x2a0
[  463.376529]  devlink_pernet_pre_exit+0x1b4/0x2a0
[  463.376675]  ? devlink_nl_cmd_reload+0xf90/0xf90
[  463.376790]  ? mark_held_locks+0x9f/0xe0
[  463.376887]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
[  463.377001]  ? __local_bh_enable_ip+0xa2/0x100
[  463.377148]  cleanup_net+0x372/0x8e0
[  463.377238]  ? unregister_pernet_device+0x70/0x70
[  463.377353]  ? lock_is_held_type+0x98/0x110
[  463.377467]  process_one_work+0x8f5/0x1580
[  463.377560]  ? lock_release+0x6c0/0x6c0
[  463.377647]  ? pwq_dec_nr_in_flight+0x230/0x230
[  463.377771]  ? rwlock_bug.part.0+0x90/0x90
[  463.377891]  worker_thread+0x58d/0x1330
[  463.377987]  ? process_one_work+0x1580/0x1580
[  463.378102]  kthread+0x379/0x450
[  463.378193]  ? _raw_spin_unlock_irq+0x24/0x30
[  463.378326]  ? set_kthread_struct+0x100/0x100
[  463.378457]  ret_from_fork+0x1f/0x30

> 
> BTW we can put the symbols in a namespace or under a kconfig, to aid
> reviews of drivers using them if you want.
