Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549C453D247
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346522AbiFCTOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiFCTOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:14:23 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7CE3AA48
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 12:14:21 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id z22-20020a5e8616000000b0066576918849so3683483ioj.1
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 12:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=mbIzcX+AIuXY/JFhauCTFO9nUbsAJD8mgdZGwqjY3ZY=;
        b=eKntcPapl/rr68RMyO0KDln+cgBAQ8o/xgPCkzb3O+mtIZ1QweZTmbdLRrXhDXJm6V
         yQznI3Y2lhbgxO6z0nJorLZGCC+2qUvLV405v9UPdiPMsmnHTVEA2FQxb5LiXbCB9DvB
         URtR1qFhBGErCJeSYCiOTg+t+2au72xPSAJjwDvN/pM2Ghr3tRwE4aUWtA9ySbVgEP9f
         afWr99YQMGJFFXsfDC4HBNZ/YUTA77bhgEAqns6TtdDj8p/YBr7vwfmDBcI+Fe4bhTVA
         5RVpzRLuIssx91dwKyoOLD5+l46YEdDDdgTCAs+eSULeoKkDWWDKPK0r4fWvw2Av/SbJ
         yFUQ==
X-Gm-Message-State: AOAM533xXnDuavStv0yWsttv/Mc4SgoseR7wlzQtLA3xdsQ1QEnYyRPe
        SWmh/0NF2e3fobV15IA94LB0n+kUFDE1lldCxwTXr8H9ojPC
X-Google-Smtp-Source: ABdhPJw5YABemjic08ig6E1aUcqWR097SYkBOipbNeFWArX02xC9FCmHIRH/BRyA0kuc396BTdMFzebksFRVDgbrsypIxbWwCLbj
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d55:b0:330:f4e1:8da5 with SMTP id
 d21-20020a0566380d5500b00330f4e18da5mr6545061jak.315.1654283661229; Fri, 03
 Jun 2022 12:14:21 -0700 (PDT)
Date:   Fri, 03 Jun 2022 12:14:21 -0700
In-Reply-To: <00000000000095640f05cb78af37@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fc436905e08fedc5@google.com>
Subject: Re: [syzbot] possible deadlock in j1939_sk_queue_drop_all
From:   syzbot <syzbot+3bd970a1887812621b4c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kernel@pengutronix.de,
        kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        mkl@pengutronix.de, netdev@vger.kernel.org, pabeni@redhat.com,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    50fd82b3a9a9 Merge tag 'docs-5.19-2' of git://git.lwn.net/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=102da9cdf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc5a30a131480a80
dashboard link: https://syzkaller.appspot.com/bug?extid=3bd970a1887812621b4c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146bed83f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1365ecd3f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3bd970a1887812621b4c@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.18.0-syzkaller-12234-g50fd82b3a9a9 #0 Not tainted
------------------------------------------------------
syz-executor143/3611 is trying to acquire lock:
ffff888026e4d5c8 (&jsk->sk_session_queue_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
ffff888026e4d5c8 (&jsk->sk_session_queue_lock){+.-.}-{2:2}, at: j1939_sk_queue_drop_all+0x40/0x2f0 net/can/j1939/socket.c:139

but task is already holding lock:
ffff888073ce10d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
ffff888073ce10d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: j1939_sk_netdev_event_netdown+0x28/0x160 net/can/j1939/socket.c:1266

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&priv->j1939_socks_lock){+.-.}-{2:2}:
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:354 [inline]
       j1939_sk_errqueue+0x9f/0x1a0 net/can/j1939/socket.c:1078
       __j1939_session_cancel+0x3b9/0x460 net/can/j1939/transport.c:1124
       j1939_tp_rxtimer.cold+0x1f6/0x24f net/can/j1939/transport.c:1249
       __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
       __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
       hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1766
       __do_softirq+0x29b/0x9c2 kernel/softirq.c:571
       invoke_softirq kernel/softirq.c:445 [inline]
       __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
       irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
       sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1106
       asm_sysvec_apic_timer_interrupt+0x1b/0x20 arch/x86/include/asm/idtentry.h:649
       native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
       arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
       acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
       acpi_idle_do_entry+0x1c6/0x250 drivers/acpi/processor_idle.c:554
       acpi_idle_enter+0x369/0x510 drivers/acpi/processor_idle.c:691
       cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
       cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
       call_cpuidle kernel/sched/idle.c:155 [inline]
       cpuidle_idle_call kernel/sched/idle.c:236 [inline]
       do_idle+0x3e8/0x590 kernel/sched/idle.c:303
       cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
       start_secondary+0x21d/0x2b0 arch/x86/kernel/smpboot.c:266
       secondary_startup_64_no_verify+0xce/0xdb

-> #1 (&priv->active_session_list_lock){+.-.}-{2:2}:
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:354 [inline]
       j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
       j1939_session_activate+0x43/0x4b0 net/can/j1939/transport.c:1553
       j1939_sk_queue_activate_next_locked net/can/j1939/socket.c:181 [inline]
       j1939_sk_queue_activate_next+0x29b/0x460 net/can/j1939/socket.c:205
       j1939_session_deactivate_activate_next net/can/j1939/transport.c:1101 [inline]
       j1939_session_completed+0x19a/0x1f0 net/can/j1939/transport.c:1214
       j1939_xtp_rx_eoma_one net/can/j1939/transport.c:1384 [inline]
       j1939_xtp_rx_eoma+0x2a6/0x5f0 net/can/j1939/transport.c:1399
       j1939_tp_cmd_recv net/can/j1939/transport.c:2088 [inline]
       j1939_tp_recv+0x930/0xcb0 net/can/j1939/transport.c:2133
       j1939_can_recv+0x6ff/0x9a0 net/can/j1939/main.c:108
       deliver net/can/af_can.c:574 [inline]
       can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
       can_receive+0x31d/0x580 net/can/af_can.c:665
       can_rcv+0x120/0x1c0 net/can/af_can.c:696
       __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5478
       __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5592
       process_backlog+0x3a0/0x7c0 net/core/dev.c:5920
       __napi_poll+0xb3/0x6e0 net/core/dev.c:6486
       napi_poll net/core/dev.c:6553 [inline]
       net_rx_action+0x9c1/0xd90 net/core/dev.c:6664
       __do_softirq+0x29b/0x9c2 kernel/softirq.c:571
       run_ksoftirqd kernel/softirq.c:934 [inline]
       run_ksoftirqd+0x2d/0x60 kernel/softirq.c:926
       smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
       kthread+0x2e9/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302

-> #0 (&jsk->sk_session_queue_lock){+.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5665 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:354 [inline]
       j1939_sk_queue_drop_all+0x40/0x2f0 net/can/j1939/socket.c:139
       j1939_sk_netdev_event_netdown+0x7b/0x160 net/can/j1939/socket.c:1272
       j1939_netdev_notify+0x199/0x1d0 net/can/j1939/main.c:372
       notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
       call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
       call_netdevice_notifiers net/core/dev.c:1995 [inline]
       __dev_notify_flags+0x1da/0x2b0 net/core/dev.c:8571
       dev_change_flags+0x112/0x170 net/core/dev.c:8607
       do_setlink+0x961/0x3bb0 net/core/rtnetlink.c:2780
       __rtnl_newlink+0xd6a/0x17e0 net/core/rtnetlink.c:3546
       rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
       rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6089
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:734
       ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
       __sys_sendmsg net/socket.c:2575 [inline]
       __do_sys_sendmsg net/socket.c:2584 [inline]
       __se_sys_sendmsg net/socket.c:2582 [inline]
       __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x46/0xb0

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

2 locks held by syz-executor143/3611:
 #0: ffffffff8d5937e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8d5937e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3e5/0xc90 net/core/rtnetlink.c:6086
 #1: ffff888073ce10d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #1: ffff888073ce10d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: j1939_sk_netdev_event_netdown+0x28/0x160 net/can/j1939/socket.c:1266

stack backtrace:
CPU: 1 PID: 3611 Comm: syz-executor143 Not tainted 5.18.0-syzkaller-12234-g50fd82b3a9a9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5665 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:354 [inline]
 j1939_sk_queue_drop_all+0x40/0x2f0 net/can/j1939/socket.c:139
 j1939_sk_netdev_event_netdown+0x7b/0x160 net/can/j1939/socket.c:1272
 j1939_netdev_notify+0x199/0x1d0 net/can/j1939/main.c:372
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 __dev_notify_flags+0x1da/0x2b0 net/core/dev.c:8571
 dev_change_flags+0x112/0x170 net/core/dev.c:8607
 do_setlink+0x961/0x3bb0 net/core/rtnetlink.c:2780
 __rtnl_newlink+0xd6a/0x17e0 net/core/rtnetlink.c:3546
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
 rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6089
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fe42bbf0e89
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd26802168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffd26802178 RCX: 00007fe42bbf0e89
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000005
RBP: 0000000000000003 R08: bb1414ac00000000 R09: bb1414ac00000000
R10: bb1414ac00000000 R11: 0000000000000246 R12: 00007ffd26802180
R13: 00007ffd26802174 R14: 0000000000000003 R15: 0000000000000000
 </TASK>
A link change request failed with some changes committed already. Interface vxcan0 may have been left with an inconsistent configuration, please check.

