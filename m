Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E45716F773
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 06:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgBZFjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 00:39:13 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:42823 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgBZFjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 00:39:13 -0500
Received: by mail-il1-f197.google.com with SMTP id s13so2206576ili.9
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 21:39:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uGxEoBZdEJyr2cCmVlxRKNDAv9nNidTX1NIELXjoNOc=;
        b=rrFSpV9x+VcjRF8jVQOE6xCn6jIQKPGO/E4qgo42RJ+I8fChNcSiSvwnCB+AUPY9M9
         fk89HTmoDS2Zuo9hMIPh75yYxaTr6hD0ElcC6gonraZTz7gcK9j+WFnmUv3L8KOy4HOk
         s8gOXguyErgK3+Adlnzy6CfZUi/UCrwQH+1RTBrgowmUcihBzZ8aLSA4qu0IU/tt/JcT
         GtjKbUeLB+mdPtzLtAFbpKfP6Xe08RrpVAo8d9kVCN7YHlqI9VWU8QccSig15OVfL/ew
         jwSKFHYiyinNVscSTAfhXx08KDS4+m0LCJ9u0sjNgbcuBsZSZ73CBBIYz7YVkXcvYItn
         rQ7Q==
X-Gm-Message-State: APjAAAXJuDCcnEex36D3mP8ke9QipiG4V0Fx2TLtJB6APyQkEoD0bIce
        eNvt2Eq/xA+6X90v2QZxx2kAK/QzPe3zUrRpECjPAcr12D5H
X-Google-Smtp-Source: APXvYqy4gnuW9DglMt9Nv5AKwlkZy11b+ks+bWryygfXZGvB358RnZVYhqmqQCuE1vMEAOYnZraT5Nq1r5j5+kRXmaxEwauzjbBP
MIME-Version: 1.0
X-Received: by 2002:a02:cd82:: with SMTP id l2mr2059450jap.103.1582695550630;
 Tue, 25 Feb 2020 21:39:10 -0800 (PST)
Date:   Tue, 25 Feb 2020 21:39:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000153fac059f740693@google.com>
Subject: possible deadlock in cma_netdev_callback
From:   syzbot <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>
To:     chuck.lever@oracle.com, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        parav@mellanox.com, syzkaller-bugs@googlegroups.com,
        willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6132c1d9 net: core: devlink.c: Hold devlink->lock from the..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16978909e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=55de90ab5f44172b0c90
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12808281e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134ca6fde00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com

iwpm_register_pid: Unable to send a nlmsg (client = 2)
infiniband syz1: RDMA CMA: cma_listen_on_dev, error -98
netlink: 'syz-executor639': attribute type 1 has an invalid length.
8021q: adding VLAN 0 to HW filter on device bond1
bond1: (slave gretap1): making interface the new active one
======================================================
WARNING: possible circular locking dependency detected
5.6.0-rc2-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor639/9689 is trying to acquire lock:
ffffffff8a5d2a60 (lock#3){+.+.}, at: cma_netdev_callback+0xc6/0x380 drivers/infiniband/core/cma.c:4605

but task is already holding lock:
ffffffff8a74da00 (rtnl_mutex){+.+.}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
ffffffff8a74da00 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x405/0xaf0 net/core/rtnetlink.c:5433

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (rtnl_mutex){+.+.}:
       __mutex_lock_common kernel/locking/mutex.c:956 [inline]
       __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
       mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
       rtnl_lock+0x17/0x20 net/core/rtnetlink.c:72
       siw_create_listen+0x329/0xed0 drivers/infiniband/sw/siw/siw_cm.c:1951
       iw_cm_listen+0x16e/0x1f0 drivers/infiniband/core/iwcm.c:582
       cma_iw_listen drivers/infiniband/core/cma.c:2450 [inline]
       rdma_listen+0x613/0x970 drivers/infiniband/core/cma.c:3614
       cma_listen_on_dev+0x530/0x6a0 drivers/infiniband/core/cma.c:2501
       cma_add_one+0x6fe/0xbf0 drivers/infiniband/core/cma.c:4666
       add_client_context+0x3dd/0x550 drivers/infiniband/core/device.c:681
       enable_device_and_get+0x1df/0x3c0 drivers/infiniband/core/device.c:1316
       ib_register_device drivers/infiniband/core/device.c:1382 [inline]
       ib_register_device+0xa89/0xe40 drivers/infiniband/core/device.c:1343
       siw_device_register drivers/infiniband/sw/siw/siw_main.c:70 [inline]
       siw_newlink drivers/infiniband/sw/siw/siw_main.c:565 [inline]
       siw_newlink+0xdef/0x1310 drivers/infiniband/sw/siw/siw_main.c:542
       nldev_newlink+0x28a/0x430 drivers/infiniband/core/nldev.c:1538
       rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
       rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
       rdma_nl_rcv+0x5d9/0x980 drivers/infiniband/core/netlink.c:259
       netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
       netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
       netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xd7/0x130 net/socket.c:672
       ____sys_sendmsg+0x753/0x880 net/socket.c:2343
       ___sys_sendmsg+0x100/0x170 net/socket.c:2397
       __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
       __do_sys_sendmsg net/socket.c:2439 [inline]
       __se_sys_sendmsg net/socket.c:2437 [inline]
       __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (lock#3){+.+.}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain kernel/locking/lockdep.c:2970 [inline]
       __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
       lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
       __mutex_lock_common kernel/locking/mutex.c:956 [inline]
       __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
       mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
       cma_netdev_callback+0xc6/0x380 drivers/infiniband/core/cma.c:4605
       notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
       __raw_notifier_call_chain kernel/notifier.c:361 [inline]
       raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
       call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
       call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1933
       call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
       call_netdevice_notifiers+0x79/0xa0 net/core/dev.c:1974
       bond_change_active_slave+0x185b/0x2050 drivers/net/bonding/bond_main.c:944
       bond_select_active_slave+0x276/0xae0 drivers/net/bonding/bond_main.c:986
       bond_enslave+0x44ef/0x4af0 drivers/net/bonding/bond_main.c:1823
       do_set_master net/core/rtnetlink.c:2468 [inline]
       do_set_master+0x1dd/0x240 net/core/rtnetlink.c:2441
       __rtnl_newlink+0x13a3/0x1790 net/core/rtnetlink.c:3346
       rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3377
       rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5436
       netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
       rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5454
       netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
       netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
       netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xd7/0x130 net/socket.c:672
       ____sys_sendmsg+0x753/0x880 net/socket.c:2343
       ___sys_sendmsg+0x100/0x170 net/socket.c:2397
       __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
       __do_sys_sendmsg net/socket.c:2439 [inline]
       __se_sys_sendmsg net/socket.c:2437 [inline]
       __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rtnl_mutex);
                               lock(lock#3);
                               lock(rtnl_mutex);
  lock(lock#3);

 *** DEADLOCK ***

1 lock held by syz-executor639/9689:
 #0: ffffffff8a74da00 (rtnl_mutex){+.+.}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a74da00 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x405/0xaf0 net/core/rtnetlink.c:5433

stack backtrace:
CPU: 0 PID: 9689 Comm: syz-executor639 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1684
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
 check_prev_add kernel/locking/lockdep.c:2475 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain kernel/locking/lockdep.c:2970 [inline]
 __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
 mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
 cma_netdev_callback+0xc6/0x380 drivers/infiniband/core/cma.c:4605
 notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers+0x79/0xa0 net/core/dev.c:1974
 bond_change_active_slave+0x185b/0x2050 drivers/net/bonding/bond_main.c:944
 bond_select_active_slave+0x276/0xae0 drivers/net/bonding/bond_main.c:986
 bond_enslave+0x44ef/0x4af0 drivers/net/bonding/bond_main.c:1823
 do_set_master net/core/rtnetlink.c:2468 [inline]
 do_set_master+0x1dd/0x240 net/core/rtnetlink.c:2441
 __rtnl_newlink+0x13a3/0x1790 net/core/rtnetlink.c:3346
 rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3377
 rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5436
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5454
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440509
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff80af47a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440509
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401d90
R13: 0000000000401e20 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
