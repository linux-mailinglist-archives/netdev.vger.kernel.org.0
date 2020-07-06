Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2769A215B05
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgGFPmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:42:36 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:41373 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729606AbgGFPm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:42:27 -0400
Received: by mail-il1-f200.google.com with SMTP id k6so27961634ilg.8
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SdFBYNt6WtvkPpJM1KJwyhopP5DLN5qVlixPic0GYE8=;
        b=RmrkT/hFI0rPIp3Dwcn5Q80pLPJL7r4+AGBSnY1SyYAEl31cwYyBXSyhthO2Ut3P8G
         BIqj7S1Y8Xp3vLRgWizOct0s0lhRr0+ktegSZMU+t9yQXNfazRh7rBAHTqewDzrQH2iy
         dSX+uaLNFQknEjbUbKhl6MUBdpOJvEyBZ4wIXMBCWbkfeMq757EnHr+ZX6WGbQDZ9P6c
         L+6TXpYWhsbEHGBNQwSKm6Y95mqU7NKJ1Gpi/baH5c6fmTd252qkm4EGszfGoqdIT3Td
         ggvfjEFu29TWfjCCdDtohFA4a6wQRqqrh/B6BIErhgS9vblCNe43Hhx8DWMtPSQJLENG
         4lpw==
X-Gm-Message-State: AOAM5314/fH4JjQ7eAlLSoxwzeTYAflPjw1zpTky/0o7Gp2giZ33JaQ+
        Pcwi1YH1ml2SvqJmxkEU7Nb/QE2YsLNkFm8ZgQx6rMXTT4eL
X-Google-Smtp-Source: ABdhPJzlliNiJwiXFrE9n03lcmPypZ0ktUsuHsEPSrwvQCXHlVX0zmadn0yu5pq7qrF+qsqPJwYG+EnxicKrIE4f3HZZYMuxi7bM
MIME-Version: 1.0
X-Received: by 2002:a5d:9c0e:: with SMTP id 14mr26246422ioe.109.1594050145584;
 Mon, 06 Jul 2020 08:42:25 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:42:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae8d6e05a9c7b889@google.com>
Subject: possible deadlock in dev_uc_sync
From:   syzbot <syzbot+4a0f7bc34e3997a6c7df@syzkaller.appspotmail.com>
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

HEAD commit:    e44f65fd xen-netfront: remove redundant assignment to vari..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1741774b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
dashboard link: https://syzkaller.appspot.com/bug?extid=4a0f7bc34e3997a6c7df
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4a0f7bc34e3997a6c7df@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.8.0-rc2-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.3/10181 is trying to acquire lock:
ffff8880681cc280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
ffff8880681cc280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: dev_uc_sync+0xdc/0x190 net/core/dev_addr_lists.c:640

but task is already holding lock:
ffff888069c62280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
ffff888069c62280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
ffff888069c62280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_set_rx_mode net/core/dev.c:8212 [inline]
ffff888069c62280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: __dev_open+0x319/0x470 net/core/dev.c:1529

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
       dev_uc_sync_multiple+0xdc/0x190 net/core/dev_addr_lists.c:670
       bond_set_rx_mode+0x1ae/0x480 drivers/net/bonding/bond_main.c:3846
       __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8207
       dev_mc_unsync net/core/dev_addr_lists.c:917 [inline]
       dev_mc_unsync+0x139/0x190 net/core/dev_addr_lists.c:909
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

-> #0 (&dev_addr_list_lock_key/2){+...}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2acb/0x56e0 kernel/locking/lockdep.c:4380
       lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
       dev_uc_sync+0xdc/0x190 net/core/dev_addr_lists.c:640
       macvlan_set_mac_lists+0x55/0x110 drivers/net/macvlan.c:802
       __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8207
       dev_set_rx_mode net/core/dev.c:8213 [inline]
       __dev_open+0x321/0x470 net/core/dev.c:1529
       dev_open net/core/dev.c:1557 [inline]
       dev_open+0xe8/0x150 net/core/dev.c:1550
       bond_enslave+0x927/0x48a0 drivers/net/bonding/bond_main.c:1714
       do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2476
       __rtnl_newlink+0x132f/0x1730 net/core/rtnetlink.c:3366
       rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3397
       rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5460
       netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
       netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
       netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
       do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&macvlan_netdev_addr_lock_key/1);
                               lock(&dev_addr_list_lock_key/2);
                               lock(&macvlan_netdev_addr_lock_key/1);
  lock(&dev_addr_list_lock_key/2);

 *** DEADLOCK ***

2 locks held by syz-executor.3/10181:
 #0: ffffffff8a7b08e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b08e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 #1: ffff888069c62280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
 #1: ffff888069c62280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
 #1: ffff888069c62280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_set_rx_mode net/core/dev.c:8212 [inline]
 #1: ffff888069c62280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: __dev_open+0x319/0x470 net/core/dev.c:1529

stack backtrace:
CPU: 1 PID: 10181 Comm: syz-executor.3 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
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
 dev_uc_sync+0xdc/0x190 net/core/dev_addr_lists.c:640
 macvlan_set_mac_lists+0x55/0x110 drivers/net/macvlan.c:802
 __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8207
 dev_set_rx_mode net/core/dev.c:8213 [inline]
 __dev_open+0x321/0x470 net/core/dev.c:1529
 dev_open net/core/dev.c:1557 [inline]
 dev_open+0xe8/0x150 net/core/dev.c:1550
 bond_enslave+0x927/0x48a0 drivers/net/bonding/bond_main.c:1714
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2476
 __rtnl_newlink+0x132f/0x1730 net/core/rtnetlink.c:3366
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3397
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007f485c5bdc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000502760 RCX: 000000000045cb29
RDX: 0000000004000890 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a43 R14: 00000000004cd2a1 R15: 00007f485c5be6d4
8021q: adding VLAN 0 to HW filter on device macvlan4


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
