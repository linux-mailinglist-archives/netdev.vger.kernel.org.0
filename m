Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6D421F775
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgGNQhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:37:24 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:54556 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgGNQhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 12:37:23 -0400
Received: by mail-il1-f200.google.com with SMTP id d18so12269847ill.21
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 09:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=75r0bKaYzCUPJq0CQLzub/SBEorxWQMEleK0P8TUUfo=;
        b=UdpkGDoFBjrXm4VVSj+efzSxWl5R2bcCBEV+9RjHThqEAY+a21HnQZm/aFdCXYsFZA
         TcmRtphhCm41XGMu2XOnS5VGCoUNDkRSAoRL0+tvbRaU3h0/rNw+/lR9oXHhr9RPv/Wc
         c7EjSe/Xx6ktI+nSZMVpBD0zWq0s6Ls369kKGW1fv55Ysa04CF8xAgZB2hXRlfRy2HNd
         Ufkf4QJilXzImUgSmZTzbC69bRu/21zMsM6Qfzn4OuUmhTSyuyFPzD6af2ndlW5nSn+w
         BKR69KHLK05zIgja0F/EASPQbRjGd86RNGGuJelkop6arn578p0C8B5cfbddpWHR+Weg
         RsFA==
X-Gm-Message-State: AOAM532B0ZlEaf0kOkwV8Yj++ovrmZW8SkwKhM7Np54dHyfng8xO3SRF
        DUt+OMLHyX5fXgkNT5MxJ2bo3YB7F8zWmmkLij/0w9T5N4my
X-Google-Smtp-Source: ABdhPJzjfKrJmrpaSlNo9wjgOZ7gFUKTYGavk0VCi3LaJt0DkbD8WH+ZB9yxwHFIZtZaKZun6QKnhMio/AtIXGIKPgRidbDZJL6I
MIME-Version: 1.0
X-Received: by 2002:a92:cece:: with SMTP id z14mr5319119ilq.120.1594744642220;
 Tue, 14 Jul 2020 09:37:22 -0700 (PDT)
Date:   Tue, 14 Jul 2020 09:37:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8398205aa696bc3@google.com>
Subject: possible deadlock in dev_uc_unsync
From:   syzbot <syzbot+708f34079caa31416e39@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8fb49c01 Merge branch 'Expose-port-split-attributes'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1196f38f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=415c682f6b7a0cbf
dashboard link: https://syzkaller.appspot.com/bug?extid=708f34079caa31416e39
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+708f34079caa31416e39@syzkaller.appspotmail.com

device bridge_slave_1 left promiscuous mode
bridge0: port 2(bridge_slave_1) entered disabled state
device bridge_slave_0 left promiscuous mode
bridge0: port 1(bridge_slave_0) entered disabled state
======================================================
WARNING: possible circular locking dependency detected
5.8.0-rc2-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:3/91 is trying to acquire lock:
ffff8880a25c8280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
ffff8880a25c8280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_uc_unsync net/core/dev_addr_lists.c:694 [inline]
ffff8880a25c8280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_uc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:688

but task is already holding lock:
ffff8880a74f2280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
ffff8880a74f2280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
ffff8880a74f2280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_uc_unsync net/core/dev_addr_lists.c:693 [inline]
ffff8880a74f2280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_uc_unsync+0xb0/0x190 net/core/dev_addr_lists.c:688

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
       dev_mc_unsync net/core/dev_addr_lists.c:915 [inline]
       dev_mc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:909
       vlan_dev_stop+0x51/0x350 net/8021q/vlan_dev.c:315
       __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1605
       dev_close_many+0x238/0x650 net/core/dev.c:1630
       rollback_registered_many+0x3af/0xf60 net/core/dev.c:8953
       unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10121
       unregister_netdevice_many net/core/dev.c:10120 [inline]
       default_device_exit_batch+0x30c/0x3d0 net/core/dev.c:10604
       ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
       cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:291
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

-> #0 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2acb/0x56e0 kernel/locking/lockdep.c:4380
       lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
       dev_uc_unsync net/core/dev_addr_lists.c:694 [inline]
       dev_uc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:688
       macvlan_stop+0xfe/0x4c0 drivers/net/macvlan.c:678
       __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1605
       dev_close_many+0x238/0x650 net/core/dev.c:1630
       rollback_registered_many+0x3af/0xf60 net/core/dev.c:8953
       unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10121
       unregister_netdevice_many net/core/dev.c:10120 [inline]
       default_device_exit_batch+0x30c/0x3d0 net/core/dev.c:10604
       ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
       cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:291
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&macvlan_netdev_addr_lock_key/1);
                               lock(&vlan_netdev_addr_lock_key/1);
                               lock(&macvlan_netdev_addr_lock_key/1);
  lock(&vlan_netdev_addr_lock_key/1);

 *** DEADLOCK ***

5 locks held by kworker/u4:3/91:
 #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000e57da8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a7a4930 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xa00 net/core/net_namespace.c:565
 #3: ffffffff8a7b17a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock_unregistering net/core/dev.c:10557 [inline]
 #3: ffffffff8a7b17a8 (rtnl_mutex){+.+.}-{3:3}, at: default_device_exit_batch+0xea/0x3d0 net/core/dev.c:10595
 #4: ffff8880a74f2280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
 #4: ffff8880a74f2280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
 #4: ffff8880a74f2280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_uc_unsync net/core/dev_addr_lists.c:693 [inline]
 #4: ffff8880a74f2280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_uc_unsync+0xb0/0x190 net/core/dev_addr_lists.c:688

stack backtrace:
CPU: 1 PID: 91 Comm: kworker/u4:3 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 check_noncircular+0x324/0x3e0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain kernel/locking/lockdep.c:3218 [inline]
 __lock_acquire+0x2acb/0x56e0 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
 netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
 dev_uc_unsync net/core/dev_addr_lists.c:694 [inline]
 dev_uc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:688
 macvlan_stop+0xfe/0x4c0 drivers/net/macvlan.c:678
 __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1605
 dev_close_many+0x238/0x650 net/core/dev.c:1630
 rollback_registered_many+0x3af/0xf60 net/core/dev.c:8953
 unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10121
 unregister_netdevice_many net/core/dev.c:10120 [inline]
 default_device_exit_batch+0x30c/0x3d0 net/core/dev.c:10604
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
device veth1_to_batadv left promiscuous mode
device veth0_to_team left promiscuous mode
device veth1_to_bridge left promiscuous mode
device veth0 left promiscuous mode
device veth1_macvtap left promiscuous mode
device veth0_macvtap left promiscuous mode
device veth1_vlan left promiscuous mode
device veth0_vlan left promiscuous mode
bond0 (unregistering): (slave macvlan60): Releasing backup interface
bond0 (unregistering): (slave macvlan59): Releasing backup interface
bond0 (unregistering): (slave macvlan58): Releasing backup interface
bond0 (unregistering): (slave macvlan57): Releasing backup interface
bond0 (unregistering): (slave macvlan56): Releasing backup interface
bond0 (unregistering): (slave macvlan55): Releasing backup interface
bond0 (unregistering): (slave macvlan54): Releasing backup interface
bond0 (unregistering): (slave macvlan53): Releasing backup interface
bond0 (unregistering): (slave macvlan52): Releasing backup interface
bond0 (unregistering): (slave macvlan51): Releasing backup interface
bond0 (unregistering): (slave macvlan50): Releasing backup interface
bond0 (unregistering): (slave macvlan49): Releasing backup interface
bond0 (unregistering): (slave macvlan48): Releasing backup interface
bond0 (unregistering): (slave macvlan47): Releasing backup interface
bond0 (unregistering): (slave macvlan46): Releasing backup interface
bond0 (unregistering): (slave macvlan45): Releasing backup interface
bond0 (unregistering): (slave macvlan44): Releasing backup interface
bond0 (unregistering): (slave macvlan43): Releasing backup interface
bond0 (unregistering): (slave macvlan42): Releasing backup interface
bond0 (unregistering): (slave macvlan41): Releasing backup interface
bond0 (unregistering): (slave macvlan40): Releasing backup interface
bond0 (unregistering): (slave macvlan39): Releasing backup interface
bond0 (unregistering): (slave macvlan38): Releasing backup interface
bond0 (unregistering): (slave macvlan37): Releasing backup interface
bond0 (unregistering): (slave macvlan36): Releasing backup interface
bond0 (unregistering): (slave macvlan35): Releasing backup interface
bond0 (unregistering): (slave macvlan34): Releasing backup interface
bond0 (unregistering): (slave macvlan33): Releasing backup interface
bond0 (unregistering): (slave macvlan32): Releasing backup interface
bond0 (unregistering): (slave macvlan31): Releasing backup interface
bond0 (unregistering): (slave macvlan30): Releasing backup interface
bond0 (unregistering): (slave macvlan29): Releasing backup interface
bond0 (unregistering): (slave macvlan28): Releasing backup interface
bond0 (unregistering): (slave macvlan27): Releasing backup interface
bond0 (unregistering): (slave macvlan26): Releasing backup interface
bond0 (unregistering): (slave macvlan25): Releasing backup interface
bond0 (unregistering): (slave macvlan24): Releasing backup interface
bond0 (unregistering): (slave macvlan23): Releasing backup interface
bond0 (unregistering): (slave macvlan22): Releasing backup interface
bond0 (unregistering): (slave macvlan21): Releasing backup interface
bond0 (unregistering): (slave macvlan20): Releasing backup interface
bond0 (unregistering): (slave macvlan19): Releasing backup interface
bond0 (unregistering): (slave macvlan18): Releasing backup interface
bond0 (unregistering): (slave macvlan17): Releasing backup interface
bond0 (unregistering): (slave macvlan16): Releasing backup interface
bond0 (unregistering): (slave macvlan15): Releasing backup interface
bond0 (unregistering): (slave macvlan14): Releasing backup interface
bond0 (unregistering): (slave macvlan13): Releasing backup interface
bond0 (unregistering): (slave macvlan12): Releasing backup interface
bond0 (unregistering): (slave macvlan11): Releasing backup interface
bond0 (unregistering): (slave macvlan10): Releasing backup interface
bond0 (unregistering): (slave macvlan9): Releasing backup interface
bond0 (unregistering): (slave macvlan8): Releasing backup interface
bond0 (unregistering): (slave macvlan7): Releasing backup interface
bond0 (unregistering): (slave macvlan6): Releasing backup interface
bond0 (unregistering): (slave macvlan5): Releasing backup interface
bond0 (unregistering): (slave macvlan4): Releasing backup interface
bond0 (unregistering): (slave macvlan3): Releasing backup interface
bond0 (unregistering): (slave macvlan2): Releasing backup interface
team0 (unregistering): Port device team_slave_1 removed
team0 (unregistering): Port device team_slave_0 removed
bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
bond0 (unregistering): Released all slaves


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
