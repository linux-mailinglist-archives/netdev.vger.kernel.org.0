Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B98B17D6FC
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 00:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgCHXNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 19:13:16 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40985 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgCHXNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 19:13:15 -0400
Received: by mail-io1-f69.google.com with SMTP id n15so5470392iog.8
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 16:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=abYmmhF6Q7DLK3Z0QKmJcgEQC2mjkVTtHh82fGU2+rc=;
        b=LLOPJAOpCJZObdjzngCsSE/w8xdhlmkHU6tpH5EgAtKnFQOMZXEOaexlf6Ej/XTQmp
         s32AyLHz5ev/JCWZLJuwQrtu01AubrltimpRQ6ZXI5m6xqoNgVXluUy2bedMRjwwcV9D
         2JAbjLD8Q/eyPYA9USUZlA4wSzTvEoHvcJRqpI/ptwMbXFgOa20SZm1Rf2LOJWgweSy5
         iSoQ7e8u2XL2rKPU6KSKTCRMWKnVyDOsEGU3S0VtfZqN75vTl/AeXm2tB/CsVOI/noKr
         KgplyUcdu1lmefhW+MDKZd7wQCH1RQ/CoadRrVyaqTaQHgajy2RGnkmTxJ3nn20oiVUZ
         U8jg==
X-Gm-Message-State: ANhLgQ2wdr46uLjfldq5HuPVozKQBTtzizqRtzKhvclU3G56GxP7mynD
        qTkaOh7M1/abpMaByPkc/eKOdnl8ygCWsriwnXSKl1fSDGMp
X-Google-Smtp-Source: ADFU+vtd9wHLTBgvqgbn0NZbUEEirAQbL87tn3frzt1CkTcKlcVwA9WMFIVBaQfXCkR8oMG1kJvwFe9iMv7EWkoSWwrrGcLqr++I
MIME-Version: 1.0
X-Received: by 2002:a92:9f4e:: with SMTP id u75mr12953754ili.116.1583709195084;
 Sun, 08 Mar 2020 16:13:15 -0700 (PDT)
Date:   Sun, 08 Mar 2020 16:13:15 -0700
In-Reply-To: <000000000000161ee805a039a49e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000002a8c05a0600814@google.com>
Subject: Re: possible deadlock in siw_create_listen
From:   syzbot <syzbot+3fbea977bd382a4e6140@syzkaller.appspotmail.com>
To:     bmt@zurich.ibm.com, dledford@redhat.com, jgg@ziepe.ca,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    425c075d Merge branch 'tun-debug'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1531a0b1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=598678fc6e800071
dashboard link: https://syzkaller.appspot.com/bug?extid=3fbea977bd382a4e6140
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e3df31e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=163d0439e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3fbea977bd382a4e6140@syzkaller.appspotmail.com

bond1: (slave gretap1): making interface the new active one
bond1: (slave gretap1): Enslaving as an active interface with an up link
iwpm_register_pid: Unable to send a nlmsg (client = 2)
======================================================
WARNING: possible circular locking dependency detected
5.6.0-rc3-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor343/9626 is trying to acquire lock:
ffffffff8a34eb80 (rtnl_mutex){+.+.}, at: siw_create_listen+0x329/0xed0 drivers/infiniband/sw/siw/siw_cm.c:1951

but task is already holding lock:
ffffffff8a1d3ba0 (lock#3){+.+.}, at: cma_add_one+0x5dc/0xb60 drivers/infiniband/core/cma.c:4663

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

6 locks held by syz-executor343/9626:
 #0: ffffffff8cf2f700 (&rdma_nl_types[idx].sem){.+.+}, at: rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:164 [inline]
 #0: ffffffff8cf2f700 (&rdma_nl_types[idx].sem){.+.+}, at: rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 #0: ffffffff8cf2f700 (&rdma_nl_types[idx].sem){.+.+}, at: rdma_nl_rcv+0x3ba/0x900 drivers/infiniband/core/netlink.c:259
 #1: ffffffff8a1c9568 (link_ops_rwsem){++++}, at: nldev_newlink+0x23b/0x400 drivers/infiniband/core/nldev.c:1528
 #2: ffffffff8a1bd088 (devices_rwsem){++++}, at: enable_device_and_get+0xfc/0x3b0 drivers/infiniband/core/device.c:1306
 #3: ffffffff8a1bcf48 (clients_rwsem){++++}, at: enable_device_and_get+0x15b/0x3b0 drivers/infiniband/core/device.c:1314
 #4: ffff88808f288538 (&device->client_data_rwsem){++++}, at: add_client_context+0x382/0x520 drivers/infiniband/core/device.c:679
 #5: ffffffff8a1d3ba0 (lock#3){+.+.}, at: cma_add_one+0x5dc/0xb60 drivers/infiniband/core/cma.c:4663

stack backtrace:
CPU: 0 PID: 9626 Comm: syz-executor343 Not tainted 5.6.0-rc3-syzkaller #0
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
RIP: 0033:0x443679
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc6eef77d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443679
RDX: 0000000000000000 RSI: 00000000200031c0 RDI: 0000000000000005
RBP: 00007ffc6eef77f0 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000404c10 R14: 0000000000000000 R15: 0000000000000000
infiniband syz2: RDMA CMA: cma_listen_on_dev, error -98

