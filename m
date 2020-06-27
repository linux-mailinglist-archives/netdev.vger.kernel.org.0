Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9192220C41F
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 22:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgF0UlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 16:41:17 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:52429 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgF0UlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 16:41:16 -0400
Received: by mail-il1-f197.google.com with SMTP id o17so1313313ilt.19
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 13:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OpKGrZ/rza+W2ZjTp9f8Zf16IEiEVrX/SyobKRnmc34=;
        b=QkywFTJRMyY/L8zHX57E6MPgre0ZgwImr5k4PayxnjLK8VhLvbGSMn0flTssIj0pX/
         7TNAZH+NOeYeyDbXFu8oRuxhQFEGgXDBS7AsmOrBNFXfjEFboOyTb+UNKguZFcrqj3zs
         Fu8mQmX9KVONf8fuopIfdc6tx/EK4eE/sXLYdntzxNP68KafXZnksUijeUKYvfqVB6Nn
         dWvEUD3LaYHLl68Be4omaxGvhvuEAJcllsPwcSdjqYZoJugjAnd2F8+LqdRyvpT/vehH
         Kjft4qXtDkxFxVPXXKtTMKWkLUOl6f3XnCNcYo7wD0icRq0Qzb9rR69PcyjmTaDQIQ5N
         N3wg==
X-Gm-Message-State: AOAM533+ffgKFVqaUwRJybXYodvM1aznC6zDHbAP1XUsHTvvX7shPa+n
        t6qC1fnGgFDJJli3KoI4cdBB08yWTeAE8IXHRMvcRcmaPcaQ
X-Google-Smtp-Source: ABdhPJyfadJ7Sly0jNHF6/UX4WdtcFQ1e0NUsf7RzvjxffpFk2bR6/MnySTqazsXly8SwMbPQu2ya+xtR41Io8CTYVC5pqwBv+lK
MIME-Version: 1.0
X-Received: by 2002:a92:cd42:: with SMTP id v2mr8248163ilq.99.1593290475512;
 Sat, 27 Jun 2020 13:41:15 -0700 (PDT)
Date:   Sat, 27 Jun 2020 13:41:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d12abc05a916d8b0@google.com>
Subject: possible deadlock in dev_mc_sync
From:   syzbot <syzbot+4d35bd6ecc37bccfd165@syzkaller.appspotmail.com>
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

HEAD commit:    4a21185c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=105b374d100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=4d35bd6ecc37bccfd165
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4d35bd6ecc37bccfd165@syzkaller.appspotmail.com

netlink: 8 bytes leftover after parsing attributes in process `syz-executor.4'.
======================================================
WARNING: possible circular locking dependency detected
5.8.0-rc2-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.4/407 is trying to acquire lock:
ffff88805ddb2280 (&dev_addr_list_lock_key#2/2){+...}-{2:2}, at: netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
ffff88805ddb2280 (&dev_addr_list_lock_key#2/2){+...}-{2:2}, at: dev_mc_sync+0xdc/0x190 net/core/dev_addr_lists.c:861

but task is already holding lock:
ffff88809cebc280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
ffff88809cebc280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
ffff88809cebc280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_set_rx_mode net/core/dev.c:8204 [inline]
ffff88809cebc280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: __dev_open+0x28e/0x3d0 net/core/dev.c:1523

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
       dev_uc_sync_multiple+0xdc/0x190 net/core/dev_addr_lists.c:670
       team_set_rx_mode+0xce/0x220 drivers/net/team/team.c:1779
       __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8199
       dev_uc_unsync net/core/dev_addr_lists.c:696 [inline]
       dev_uc_unsync+0x139/0x190 net/core/dev_addr_lists.c:688
       macvlan_stop+0xfe/0x4c0 drivers/net/macvlan.c:678
       __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1599
       dev_close_many+0x238/0x650 net/core/dev.c:1624
       rollback_registered_many+0x3af/0xf60 net/core/dev.c:8945
       unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10113
       unregister_netdevice_many net/core/dev.c:10112 [inline]
       default_device_exit_batch+0x30c/0x3d0 net/core/dev.c:10596
       ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
       cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:291
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

-> #0 (&dev_addr_list_lock_key#2/2){+...}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2acb/0x56e0 kernel/locking/lockdep.c:4380
       lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
       dev_mc_sync+0xdc/0x190 net/core/dev_addr_lists.c:861
       vlan_dev_set_rx_mode+0x38/0x80 net/8021q/vlan_dev.c:487
       __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8199
       dev_set_rx_mode net/core/dev.c:8205 [inline]
       __dev_open+0x296/0x3d0 net/core/dev.c:1523
       __dev_change_flags+0x505/0x660 net/core/dev.c:8278
       rtnl_configure_link+0xee/0x230 net/core/rtnetlink.c:3021
       __rtnl_newlink+0x10bb/0x1730 net/core/rtnetlink.c:3357
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
  lock(&vlan_netdev_addr_lock_key/1);
                               lock(&dev_addr_list_lock_key#2/2);
                               lock(&vlan_netdev_addr_lock_key/1);
  lock(&dev_addr_list_lock_key#2/2);

 *** DEADLOCK ***

2 locks held by syz-executor.4/407:
 #0: ffffffff8a7b0228 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b0228 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 #1: ffff88809cebc280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
 #1: ffff88809cebc280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
 #1: ffff88809cebc280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_set_rx_mode net/core/dev.c:8204 [inline]
 #1: ffff88809cebc280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: __dev_open+0x28e/0x3d0 net/core/dev.c:1523

stack backtrace:
CPU: 1 PID: 407 Comm: syz-executor.4 Not tainted 5.8.0-rc2-syzkaller #0
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
 dev_mc_sync+0xdc/0x190 net/core/dev_addr_lists.c:861
 vlan_dev_set_rx_mode+0x38/0x80 net/8021q/vlan_dev.c:487
 __dev_set_rx_mode+0x1ea/0x300 net/core/dev.c:8199
 dev_set_rx_mode net/core/dev.c:8205 [inline]
 __dev_open+0x296/0x3d0 net/core/dev.c:1523
 __dev_change_flags+0x505/0x660 net/core/dev.c:8278
 rtnl_configure_link+0xee/0x230 net/core/rtnetlink.c:3021
 __rtnl_newlink+0x10bb/0x1730 net/core/rtnetlink.c:3357
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
RIP: 0033:0x45cb19
Code: Bad RIP value.
RSP: 002b:00007fe66d6eac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000502600 RCX: 000000000045cb19
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000012
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a40 R14: 00000000004cd276 R15: 00007fe66d6eb6d4
netlink: 8 bytes leftover after parsing attributes in process `syz-executor.4'.


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
