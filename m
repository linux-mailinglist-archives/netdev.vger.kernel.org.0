Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6AC40371C
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 11:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348369AbhIHJmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 05:42:36 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51134 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347806AbhIHJmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 05:42:33 -0400
Received: by mail-io1-f70.google.com with SMTP id b202-20020a6bb2d3000000b005b7fb465c4aso1203619iof.17
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 02:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Z8I1vY5pt7WQ1k3fpskyKT/+buflsqqcXMb5Y4ZXMMA=;
        b=DZBOCbSIGmjKCEXSQFz+rffaM60IiiJDyJ+yPQYOxViTCISnVzoTsI4JBKbKHGaPHp
         SY/Hwj1cBW8R1s78vzLc5U1UCFieqQ1lK/BRwwSPUB5eo1IBdzEOXbI6tFVazhX7XQRR
         9Y9+q7Qc8RliZh0xe0uaOhQU1ELR+aD1kRRBavIW0y3vuEP1f8DPAGouFDNlp+Cp8o4V
         kpRj9W5b7A1ib6yj1MrcpcEz6imwTpH6cFs3DebeiOFv8sIUtnl8m908ATD7EYLWIxqA
         dPl4jffIuDevIV04coJkdpWaLDgIbj872kGDKE0XyqcHbmfKD4JRMw1GPmCHouIoI7Xu
         V2Rg==
X-Gm-Message-State: AOAM530TVAyPz4GafOmgneSMMjrfudy/PsV/0i/2qCIpg0PkLqmf6oKw
        TOVQMOKCvHu2GRhrdzPvjwD5dMp3HZo4VyWEwyvgiHluCZxn
X-Google-Smtp-Source: ABdhPJziMAcqJprhzHNe6Himpl903jKdSUAp7zHuOwXYXFH/KG8tQVMIcAr3X8An6yHvhBYRnhmUHzs3OtZxgLF+wzdJHYpLUu4b
MIME-Version: 1.0
X-Received: by 2002:a6b:c8c7:: with SMTP id y190mr2467146iof.210.1631094085869;
 Wed, 08 Sep 2021 02:41:25 -0700 (PDT)
Date:   Wed, 08 Sep 2021 02:41:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000095640f05cb78af37@google.com>
Subject: [syzbot] possible deadlock in j1939_sk_queue_drop_all
From:   syzbot <syzbot+3bd970a1887812621b4c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    29ce8f970107 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1549d3f5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f9d4c9ff8c5ae7
dashboard link: https://syzkaller.appspot.com/bug?extid=3bd970a1887812621b4c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3bd970a1887812621b4c@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc7-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.2/24182 is trying to acquire lock:
ffff88802d66f578 (&jsk->sk_session_queue_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
ffff88802d66f578 (&jsk->sk_session_queue_lock){+.-.}-{2:2}, at: j1939_sk_queue_drop_all+0x40/0x2f0 net/can/j1939/socket.c:139

but task is already holding lock:
ffff88807b54d0d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
ffff88807b54d0d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: j1939_sk_netdev_event_netdown+0x28/0x160 net/can/j1939/socket.c:1266

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&priv->j1939_socks_lock){+.-.}-{2:2}:
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
       spin_lock_bh include/linux/spinlock.h:359 [inline]
       j1939_sk_errqueue+0x9f/0x1a0 net/can/j1939/socket.c:1078
       __j1939_session_cancel+0x3b9/0x460 net/can/j1939/transport.c:1124
       j1939_tp_rxtimer+0x2a8/0x36b net/can/j1939/transport.c:1250
       __run_hrtimer kernel/time/hrtimer.c:1537 [inline]
       __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1601
       hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1618
       __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
       invoke_softirq kernel/softirq.c:432 [inline]
       __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
       irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
       sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5593
       __might_fault mm/memory.c:5261 [inline]
       __might_fault+0x106/0x180 mm/memory.c:5246
       _copy_from_user+0x27/0x180 lib/usercopy.c:13
       copy_from_user include/linux/uaccess.h:192 [inline]
       __copy_msghdr_from_user+0x91/0x4b0 net/socket.c:2288
       copy_msghdr_from_user net/socket.c:2339 [inline]
       sendmsg_copy_msghdr+0xa1/0x160 net/socket.c:2437
       ___sys_sendmsg+0xc6/0x170 net/socket.c:2456
       __sys_sendmmsg+0x195/0x470 net/socket.c:2546
       __do_sys_sendmmsg net/socket.c:2575 [inline]
       __se_sys_sendmmsg net/socket.c:2572 [inline]
       __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2572
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #1 (&priv->active_session_list_lock){+.-.}-{2:2}:
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
       spin_lock_bh include/linux/spinlock.h:359 [inline]
       j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
       j1939_session_activate+0x43/0x4b0 net/can/j1939/transport.c:1554
       j1939_sk_queue_activate_next_locked net/can/j1939/socket.c:181 [inline]
       j1939_sk_queue_activate_next+0x29b/0x460 net/can/j1939/socket.c:205
       j1939_session_deactivate_activate_next+0x2e/0x35 net/can/j1939/transport.c:1101
       j1939_xtp_rx_abort_one.cold+0x20b/0x33c net/can/j1939/transport.c:1341
       j1939_xtp_rx_abort net/can/j1939/transport.c:1352 [inline]
       j1939_tp_cmd_recv net/can/j1939/transport.c:2085 [inline]
       j1939_tp_recv+0x8f4/0xb40 net/can/j1939/transport.c:2118
       j1939_can_recv+0x6d7/0x930 net/can/j1939/main.c:101
       deliver net/can/af_can.c:574 [inline]
       can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
       can_receive+0x31d/0x580 net/can/af_can.c:665
       can_rcv+0x120/0x1c0 net/can/af_can.c:696
       __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5436
       __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5550
       process_backlog+0x2a5/0x6c0 net/core/dev.c:6427
       __napi_poll+0xaf/0x440 net/core/dev.c:6982
       napi_poll net/core/dev.c:7049 [inline]
       net_rx_action+0x801/0xb40 net/core/dev.c:7136
       __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
       run_ksoftirqd kernel/softirq.c:920 [inline]
       run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
       smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
       kthread+0x3e5/0x4d0 kernel/kthread.c:319
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #0 (&jsk->sk_session_queue_lock){+.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
       spin_lock_bh include/linux/spinlock.h:359 [inline]
       j1939_sk_queue_drop_all+0x40/0x2f0 net/can/j1939/socket.c:139
       j1939_sk_netdev_event_netdown+0x7b/0x160 net/can/j1939/socket.c:1272
       j1939_netdev_notify+0x199/0x1d0 net/can/j1939/main.c:362
       notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
       call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
       call_netdevice_notifiers net/core/dev.c:2022 [inline]
       dev_close_many+0x2ff/0x620 net/core/dev.c:1597
       dev_close net/core/dev.c:1619 [inline]
       dev_close net/core/dev.c:1613 [inline]
       __dev_change_net_namespace+0xd4a/0x1360 net/core/dev.c:11164
       do_setlink+0x275/0x3970 net/core/rtnetlink.c:2624
       __rtnl_newlink+0xde6/0x1750 net/core/rtnetlink.c:3391
       rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
       rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
       netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
       netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
       sock_sendmsg_nosec net/socket.c:704 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:724
       ____sys_sendmsg+0x6e8/0x810 net/socket.c:2406
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2460
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2489
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  &jsk->sk_session_queue_lock --> &priv->active_session_list_lock --> &priv->j1939_socks_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&priv->j1939_socks_lock);
                               lock(&priv->active_session_list_lock);
                               lock(&priv->j1939_socks_lock);
  lock(&jsk->sk_session_queue_lock);

 *** DEADLOCK ***

2 locks held by syz-executor.2/24182:
 #0: ffffffff8d0cd7a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0cd7a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 #1: ffff88807b54d0d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #1: ffff88807b54d0d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: j1939_sk_netdev_event_netdown+0x28/0x160 net/can/j1939/socket.c:1266

stack backtrace:
CPU: 1 PID: 24182 Comm: syz-executor.2 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 j1939_sk_queue_drop_all+0x40/0x2f0 net/can/j1939/socket.c:139
 j1939_sk_netdev_event_netdown+0x7b/0x160 net/can/j1939/socket.c:1272
 j1939_netdev_notify+0x199/0x1d0 net/can/j1939/main.c:362
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 dev_close_many+0x2ff/0x620 net/core/dev.c:1597
 dev_close net/core/dev.c:1619 [inline]
 dev_close net/core/dev.c:1613 [inline]
 __dev_change_net_namespace+0xd4a/0x1360 net/core/dev.c:11164
 do_setlink+0x275/0x3970 net/core/rtnetlink.c:2624
 __rtnl_newlink+0xde6/0x1750 net/core/rtnetlink.c:3391
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2406
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2460
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2489
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7926a42188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffcf598798f R14: 00007f7926a42300 R15: 0000000000022000
device vcan0 entered promiscuous mode
IPv6: ADDRCONF(NETDEV_CHANGE): vcan0: link becomes ready


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
