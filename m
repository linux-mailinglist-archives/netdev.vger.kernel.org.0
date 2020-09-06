Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A927325EC75
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 06:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgIFETV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 6 Sep 2020 00:19:21 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:48223 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgIFETR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 00:19:17 -0400
Received: by mail-io1-f79.google.com with SMTP id u3so3787285iow.15
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 21:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=oRuXBEU2m9kz1FVl/XMpb+Qpvd4JgVL1UCAX2eflOyg=;
        b=KlLu9FaZwLW4RKY04T90NyYJZzgD3v4MuiP7idwXMqcjV8m4XDpaQDZcWjKCpeuWXn
         WkQfpZ8Vqs87KhK/vblV7CLeU1DiYYN23c27CorGYrOjUyFRKe0aNAUy+7OH/RGLBJJV
         1hxv3hN7FC+Vxd7pTGumy8y4WlFy2vGCYPn/3g2GhuRpyXg21p8fpMie3FYiu+FilCOE
         giMDqeixB4UUGSQlAXCus5SwjkDI0scUIyXrHViY5FA9XXB9xTqF22Y4aTGDXxx8OEU8
         CZjkTSzQJe74jWIP9anXFeBGIzTen7t1jsUZPo3aO7sS4AZ2t3NYKMto0dAK6NT9nn2Z
         Rqiw==
X-Gm-Message-State: AOAM533nYxnrqJm6dGWkImdHEkNK36pCGa39H3dFjpm/NM6+PvA3kLuD
        Yboa3DQHIt3TSHO629uKC59h7T5dFjBZBkMobm0k2p8Dm/k1
X-Google-Smtp-Source: ABdhPJwI17bkMbgOa2deZLQ4pXLwGfwU8sBzrHlsUrF1wR4GnTT+CJX+WscZqzso1ME8LxuXwqTwrbeyvlH7uwqs1/F7hGOYl7ax
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4a1:: with SMTP id e1mr14777135ils.113.1599365955713;
 Sat, 05 Sep 2020 21:19:15 -0700 (PDT)
Date:   Sat, 05 Sep 2020 21:19:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a8014405ae9d6725@google.com>
Subject: possible deadlock in dev_uc_sync_multiple (3)
From:   syzbot <syzbot+72ab39c457a82e8f7ec1@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    dc1a9bf2 octeontx2-pf: Add UDP segmentation offload support
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13959d15900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b6856d16f78d8fa9
dashboard link: https://syzkaller.appspot.com/bug?extid=72ab39c457a82e8f7ec1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+72ab39c457a82e8f7ec1@syzkaller.appspotmail.com

batman_adv: batadv0: Removing interface: batadv_slave_1
batman_adv: batadv0: Removing interface: veth19
device  left promiscuous mode
bridge0: port 2() entered disabled state
device bond1 left promiscuous mode
device veth33 left promiscuous mode
======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:9/29997 is trying to acquire lock:
ffff88808e338280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_nested include/linux/netdevice.h:4286 [inline]
ffff88808e338280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_uc_sync_multiple+0xdc/0x190 net/core/dev_addr_lists.c:670

but task is already holding lock:
ffff88805c198280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: netif_addr_lock_nested include/linux/netdevice.h:4286 [inline]
ffff88805c198280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:925 [inline]
ffff88805c198280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: dev_mc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:918

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&dev_addr_list_lock_key/2){+...}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock_nested include/linux/netdevice.h:4286 [inline]
       dev_mc_sync+0xdc/0x190 net/core/dev_addr_lists.c:870
       vlan_dev_set_rx_mode+0x38/0x80 net/8021q/vlan_dev.c:487
       __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8205
       dev_uc_sync_multiple+0x155/0x190 net/core/dev_addr_lists.c:673
       bond_set_rx_mode+0x1ae/0x480 drivers/net/bonding/bond_main.c:3874
       __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8205
       __dev_mc_del net/core/dev_addr_lists.c:818 [inline]
       dev_mc_del+0x9e/0xb0 net/core/dev_addr_lists.c:833
       mrp_uninit_applicant+0x210/0x360 net/802/mrp.c:903
       unregister_vlan_dev+0x400/0x570 net/8021q/vlan.c:114
       default_device_exit_batch+0x22f/0x3d0 net/core/dev.c:10906
       ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
       cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> #0 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2a6b/0x5640 kernel/locking/lockdep.c:4426
       lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock_nested include/linux/netdevice.h:4286 [inline]
       dev_uc_sync_multiple+0xdc/0x190 net/core/dev_addr_lists.c:670
       bond_set_rx_mode+0x1ae/0x480 drivers/net/bonding/bond_main.c:3874
       __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8205
       dev_mc_unsync net/core/dev_addr_lists.c:927 [inline]
       dev_mc_unsync+0x139/0x190 net/core/dev_addr_lists.c:918
       vlan_dev_stop+0x51/0x350 net/8021q/vlan_dev.c:315
       __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1605
       dev_close_many+0x238/0x650 net/core/dev.c:1630
       rollback_registered_many+0x3a8/0x1210 net/core/dev.c:9260
       unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10428
       unregister_netdevice_many net/core/dev.c:10427 [inline]
       default_device_exit_batch+0x30c/0x3d0 net/core/dev.c:10911
       ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
       cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&dev_addr_list_lock_key/2);
                               lock(&vlan_netdev_addr_lock_key/1);
                               lock(&dev_addr_list_lock_key/2);
  lock(&vlan_netdev_addr_lock_key/1);

 *** DEADLOCK ***

7 locks held by kworker/u4:9/29997:
 #0: ffff8880a97b0138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a97b0138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a97b0138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a97b0138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a97b0138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a97b0138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc9000664fda8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a7dd0b0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xa00 net/core/net_namespace.c:565
 #3: ffffffff8a7ea188 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock_unregistering net/core/dev.c:10864 [inline]
 #3: ffffffff8a7ea188 (rtnl_mutex){+.+.}-{3:3}, at: default_device_exit_batch+0xea/0x3d0 net/core/dev.c:10902
 #4: ffff888051100280 (&vlan_netdev_addr_lock_key){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #4: ffff888051100280 (&vlan_netdev_addr_lock_key){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4291 [inline]
 #4: ffff888051100280 (&vlan_netdev_addr_lock_key){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:924 [inline]
 #4: ffff888051100280 (&vlan_netdev_addr_lock_key){+...}-{2:2}, at: dev_mc_unsync+0xb0/0x190 net/core/dev_addr_lists.c:918
 #5: ffff88805c198280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: netif_addr_lock_nested include/linux/netdevice.h:4286 [inline]
 #5: ffff88805c198280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:925 [inline]
 #5: ffff88805c198280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: dev_mc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:918
 #6: ffffffff89bd6b40 (rcu_read_lock){....}-{1:2}, at: bond_set_rx_mode+0x0/0x480 drivers/net/bonding/bond_main.c:943

stack backtrace:
CPU: 1 PID: 29997 Comm: kworker/u4:9 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 check_noncircular+0x324/0x3e0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain kernel/locking/lockdep.c:3218 [inline]
 __lock_acquire+0x2a6b/0x5640 kernel/locking/lockdep.c:4426
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
 _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
 netif_addr_lock_nested include/linux/netdevice.h:4286 [inline]
 dev_uc_sync_multiple+0xdc/0x190 net/core/dev_addr_lists.c:670
 bond_set_rx_mode+0x1ae/0x480 drivers/net/bonding/bond_main.c:3874
 __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8205
 dev_mc_unsync net/core/dev_addr_lists.c:927 [inline]
 dev_mc_unsync+0x139/0x190 net/core/dev_addr_lists.c:918
 vlan_dev_stop+0x51/0x350 net/8021q/vlan_dev.c:315
 __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1605
 dev_close_many+0x238/0x650 net/core/dev.c:1630
 rollback_registered_many+0x3a8/0x1210 net/core/dev.c:9260
 unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10428
 unregister_netdevice_many net/core/dev.c:10427 [inline]
 default_device_exit_batch+0x30c/0x3d0 net/core/dev.c:10911
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
device bond0 left promiscuous mode
device bond_slave_0 left promiscuous mode
device bond_slave_1 left promiscuous mode
device vlan8 left promiscuous mode
device veth1_macvtap left promiscuous mode
device veth0_macvtap left promiscuous mode
device veth1_vlan left promiscuous mode
device veth0_vlan left promiscuous mode
bond0 (unregistering): (slave vlan8): Releasing backup interface
bond20 (unregistering): Released all slaves
bond19 (unregistering): Released all slaves
bond18 (unregistering): Released all slaves
bond17 (unregistering): Released all slaves
bond16 (unregistering): Released all slaves
bond15 (unregistering): Released all slaves
bond14 (unregistering): Released all slaves
bond13 (unregistering): (slave veth158): Releasing backup interface
bond13 (unregistering): (slave veth156): Releasing backup interface
bond13 (unregistering): Released all slaves
@� (unregistering): Port device veth154 removed
bond12 (unregistering): Released all slaves
@� (unregistering): Port device bond11 removed
bond11 (unregistering): Released all slaves
bond10 (unregistering): Released all slaves
bond9 (unregistering): Released all slaves
bond8 (unregistering): Released all slaves
bond7 (unregistering): Released all slaves
bond6 (unregistering): Released all slaves
bond5 (unregistering): Released all slaves
bond4 (unregistering): Released all slaves
bond3 (unregistering): Released all slaves
bond2 (unregistering): Released all slaves
bond1 (unregistering): (slave veth33): Releasing backup interface
bond1 (unregistering): Released all slaves
@� (unregistering): Port device team_slave_1 removed
@� (unregistering): Port device team_slave_0 removed
bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
bond0 (unregistering): Released all slaves


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
