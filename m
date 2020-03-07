Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAC517CA49
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCGBZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:25:11 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:36850 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgCGBZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:25:11 -0500
Received: by mail-io1-f69.google.com with SMTP id 24so2705937ioz.3
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:25:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Nm4HsAgs4/0yQMfo2emBE21H/Z/pFUU7IYdmI4v3O0o=;
        b=cCNm24dDlVs5dZ3BJTaqrsOQpT9/gU1yvnqTOoePN+XfX1PtliRzvlf6ila/35hmQu
         svSd/mTh0BBLeM/3EB0tje2B6+mHavNFI0VOVGdbnkgXNl/4yHI3XUeIzzESnbAW3Vne
         HnGQoAqTdvE3X93T37EatYwV1Dm8A4o/l/hqf1mho1/+sUdEfiJD2zaBURM04o/N43j1
         D6Cg5vIQPHuSXjpkg78ZKnkC89QDKMHsSiZC9jw+ihCsTj82wS288AAffFGTRQIZU9q+
         G6gc9tBsJa3BgIStGhiezDjjOIgS5iISJRh7gVfhpSR8YhfYjbNQZ+gWH6WaG9lo4SRF
         50CA==
X-Gm-Message-State: ANhLgQ1RvJ/LD71COnF89x2G9RK1j59nqirmSpiv+Bpjg/lUSMP1/fl8
        FEcZk6p8wMwJeYhSWtnnTGlY3WqTj4NPMtDtLbK5vmBNqG2i
X-Google-Smtp-Source: ADFU+vsjcWEP3Tbe1+wcd5mTKH1dxnCCT7pkHPVoeFAJMRFFSQDTLq0Ck+PB588dnqoBenflzSi5dPjfBci5C6QuNbEUs2Z+6Pr+
MIME-Version: 1.0
X-Received: by 2002:a02:cf1b:: with SMTP id q27mr2929281jar.99.1583544310045;
 Fri, 06 Mar 2020 17:25:10 -0800 (PST)
Date:   Fri, 06 Mar 2020 17:25:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000161ee805a039a49e@google.com>
Subject: possible deadlock in siw_create_listen
From:   syzbot <syzbot+3fbea977bd382a4e6140@syzkaller.appspotmail.com>
To:     bmt@zurich.ibm.com, dledford@redhat.com, jgg@ziepe.ca,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    68e2c376 Merge branch 'hsr-several-code-cleanup-for-hsr-mo..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c92e91e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e519c35f474a428
dashboard link: https://syzkaller.appspot.com/bug?extid=3fbea977bd382a4e6140
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3fbea977bd382a4e6140@syzkaller.appspotmail.com

iwpm_register_pid: Unable to send a nlmsg (client = 2)
======================================================
WARNING: possible circular locking dependency detected
5.6.0-rc3-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.5/2139 is trying to acquire lock:
ffffffff8a34e5c0 (rtnl_mutex){+.+.}, at: siw_create_listen+0x329/0xed0 drivers/infiniband/sw/siw/siw_cm.c:1951

but task is already holding lock:
ffffffff8a1d3600 (lock#3){+.+.}, at: cma_add_one+0x5dc/0xb60 drivers/infiniband/core/cma.c:4663

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (lock#3){+.+.}:
       __mutex_lock_common kernel/locking/mutex.c:956 [inline]
       __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
       cma_netdev_callback+0xc5/0x380 drivers/infiniband/core/cma.c:4605
       notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
       call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
       call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
       call_netdevice_notifiers+0x79/0xa0 net/core/dev.c:1974
       bond_change_active_slave+0x80e/0x1d90 drivers/net/bonding/bond_main.c:944
       bond_select_active_slave+0x250/0xa60 drivers/net/bonding/bond_main.c:986
       bond_enslave+0x4281/0x4800 drivers/net/bonding/bond_main.c:1823
       do_set_master net/core/rtnetlink.c:2468 [inline]
       do_set_master+0x1d7/0x230 net/core/rtnetlink.c:2441
       __rtnl_newlink+0x11d4/0x1590 net/core/rtnetlink.c:3346
       rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
       rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
       netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
       netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
       netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
       netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
       ___sys_sendmsg+0x100/0x170 net/socket.c:2397
       __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
       do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (rtnl_mutex){+.+.}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain kernel/locking/lockdep.c:2970 [inline]
       __lock_acquire+0x201b/0x3ca0 kernel/locking/lockdep.c:3954
       lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
       __mutex_lock_common kernel/locking/mutex.c:956 [inline]
       __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
       siw_create_listen+0x329/0xed0 drivers/infiniband/sw/siw/siw_cm.c:1951
       iw_cm_listen+0x166/0x1e0 drivers/infiniband/core/iwcm.c:582
       cma_iw_listen drivers/infiniband/core/cma.c:2450 [inline]
       rdma_listen+0x5e2/0x910 drivers/infiniband/core/cma.c:3614
       cma_listen_on_dev+0x512/0x650 drivers/infiniband/core/cma.c:2501
       cma_add_one+0x6aa/0xb60 drivers/infiniband/core/cma.c:4666
       add_client_context+0x3b4/0x520 drivers/infiniband/core/device.c:681
       enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1316
       ib_register_device drivers/infiniband/core/device.c:1382 [inline]
       ib_register_device+0xa12/0xda0 drivers/infiniband/core/device.c:1343
       siw_device_register drivers/infiniband/sw/siw/siw_main.c:70 [inline]
       siw_newlink drivers/infiniband/sw/siw/siw_main.c:565 [inline]
       siw_newlink+0xdef/0x1310 drivers/infiniband/sw/siw/siw_main.c:542
       nldev_newlink+0x27f/0x400 drivers/infiniband/core/nldev.c:1538
       rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
       rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
       rdma_nl_rcv+0x586/0x900 drivers/infiniband/core/netlink.c:259
       netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
       netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
       netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
       ___sys_sendmsg+0x100/0x170 net/socket.c:2397
       __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
       do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lock#3);
                               lock(rtnl_mutex);
                               lock(lock#3);
  lock(rtnl_mutex);

 *** DEADLOCK ***

6 locks held by syz-executor.5/2139:
 #0: ffffffff8cf316c0 (&rdma_nl_types[idx].sem){.+.+}, at: rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:164 [inline]
 #0: ffffffff8cf316c0 (&rdma_nl_types[idx].sem){.+.+}, at: rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 #0: ffffffff8cf316c0 (&rdma_nl_types[idx].sem){.+.+}, at: rdma_nl_rcv+0x3ba/0x900 drivers/infiniband/core/netlink.c:259
 #1: ffffffff8a1c8fc8 (link_ops_rwsem){++++}, at: nldev_newlink+0x23b/0x400 drivers/infiniband/core/nldev.c:1528
 #2: ffffffff8a1bcae8 (devices_rwsem){++++}, at: enable_device_and_get+0xfc/0x3b0 drivers/infiniband/core/device.c:1306
 #3: ffffffff8a1bc9a8 (clients_rwsem){++++}, at: enable_device_and_get+0x15b/0x3b0 drivers/infiniband/core/device.c:1314
 #4: ffff8880550d8538 (&device->client_data_rwsem){++++}, at: add_client_context+0x382/0x520 drivers/infiniband/core/device.c:679
 #5: ffffffff8a1d3600 (lock#3){+.+.}, at: cma_add_one+0x5dc/0xb60 drivers/infiniband/core/cma.c:4663

stack backtrace:
CPU: 0 PID: 2139 Comm: syz-executor.5 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
 check_prev_add kernel/locking/lockdep.c:2475 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain kernel/locking/lockdep.c:2970 [inline]
 __lock_acquire+0x201b/0x3ca0 kernel/locking/lockdep.c:3954
 lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
 siw_create_listen+0x329/0xed0 drivers/infiniband/sw/siw/siw_cm.c:1951
 iw_cm_listen+0x166/0x1e0 drivers/infiniband/core/iwcm.c:582
 cma_iw_listen drivers/infiniband/core/cma.c:2450 [inline]
 rdma_listen+0x5e2/0x910 drivers/infiniband/core/cma.c:3614
 cma_listen_on_dev+0x512/0x650 drivers/infiniband/core/cma.c:2501
 cma_add_one+0x6aa/0xb60 drivers/infiniband/core/cma.c:4666
 add_client_context+0x3b4/0x520 drivers/infiniband/core/device.c:681
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1316
 ib_register_device drivers/infiniband/core/device.c:1382 [inline]
 ib_register_device+0xa12/0xda0 drivers/infiniband/core/device.c:1343
 siw_device_register drivers/infiniband/sw/siw/siw_main.c:70 [inline]
 siw_newlink drivers/infiniband/sw/siw/siw_main.c:565 [inline]
 siw_newlink+0xdef/0x1310 drivers/infiniband/sw/siw/siw_main.c:542
 nldev_newlink+0x27f/0x400 drivers/infiniband/core/nldev.c:1538
 rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x586/0x900 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c4a9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9634c65c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9634c666d4 RCX: 000000000045c4a9
RDX: 0000000000000000 RSI: 00000000200031c0 RDI: 0000000000000003
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009a3 R14: 00000000004d5798 R15: 000000000076bf2c
infiniband syz1: RDMA CMA: cma_listen_on_dev, error -22
infiniband syz1: RDMA CMA: cma_listen_on_dev, error -98


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
