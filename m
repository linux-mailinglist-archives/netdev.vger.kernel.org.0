Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE2854BDEA
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbiFNWxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241827AbiFNWx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:53:26 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63AB14D3E
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 15:53:24 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id s189-20020a6b2cc6000000b00669add3c306so5041516ios.21
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 15:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bcKz89Rwh4iHGOl16T5LkMU3kB3uM/BsCIYJxAkbsBU=;
        b=S0o7f0+eG+3khf0CObioKFUnLPdY5gm6CD74HuNT3r84oe2rzkA0a6QnHbq4SpyeR1
         zpTXQHeMwWljj9LHisNy3/jzvEU0LUhhxr/h684HQl06K9bGjU+rdfnzPfD29CDJ3e1/
         FwKGOFbKrcjjpGbIo+bbH7r460++1nHEHwBgQ+RWZpQvtbsrxe8mE0gahRk3AMllkENz
         gXMizCAapgYhW585G3blxOOQv5kelqOsrRihau7Cycfm/xIafMfzmCoTQUWCppyxzGOI
         J3OUM7WDEgIQ1ITD4QBFpqqPthhRJAw9jJfiSfHhRTtDQQ4vfBToPrtV4DKBMf4ai7dr
         mSiw==
X-Gm-Message-State: AOAM531cQFGe0ZpnSVCtd4wLB2J/bxudhdXbm7wlisfSukX5LxCSQGy0
        QHOcMZqA8JGDapysfkjyOFop3PZjyqL5bp3nk4+/Ajy9npvO
X-Google-Smtp-Source: ABdhPJzHrmSSfr8eIPKH3o1Xc73RvyJCZsr9S8lmAeIYV4V3opiKOpgWR3JPCuxSaKnGV0XIk3u8cSyZA2y3xvBBa8GOvl7hqKsw
MIME-Version: 1.0
X-Received: by 2002:a05:6638:218c:b0:331:a10e:7702 with SMTP id
 s12-20020a056638218c00b00331a10e7702mr4127898jaj.147.1655247203881; Tue, 14
 Jun 2022 15:53:23 -0700 (PDT)
Date:   Tue, 14 Jun 2022 15:53:23 -0700
In-Reply-To: <000000000000f3e56405cdcf14cd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a594805e17045ed@google.com>
Subject: Re: [syzbot] possible deadlock in j1939_sk_errqueue
From:   syzbot <syzbot+ee1cd780f69483a8616b@syzkaller.appspotmail.com>
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

HEAD commit:    24625f7d91fb Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1391e2d7f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70e1a4d352a3c6ae
dashboard link: https://syzkaller.appspot.com/bug?extid=ee1cd780f69483a8616b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=163611bff00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157d01e7f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ee1cd780f69483a8616b@syzkaller.appspotmail.com

vcan0: j1939_tp_rxtimer: 0xffff88814717a000: rx timeout, send abort
vcan0: j1939_tp_rxtimer: 0xffff88807b7b3800: rx timeout, send abort
======================================================
WARNING: possible circular locking dependency detected
5.19.0-rc2-syzkaller-00049-g24625f7d91fb #0 Not tainted
------------------------------------------------------
swapper/0/0 is trying to acquire lock:
ffff8880777290d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
ffff8880777290d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: j1939_sk_errqueue+0x9f/0x1a0 net/can/j1939/socket.c:1078

but task is already holding lock:
ffff888077729088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
ffff888077729088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
ffff888077729088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_tp_rxtimer+0xe5/0x220 net/can/j1939/transport.c:1240

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&priv->active_session_list_lock){+.-.}-{2:2}:
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

-> #1 (&jsk->sk_session_queue_lock){+.-.}-{2:2}:
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

-> #0 (&priv->j1939_socks_lock){+.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5665 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
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
       acpi_idle_do_entry+0x1c9/0x240 drivers/acpi/processor_idle.c:554
       acpi_idle_enter+0x369/0x510 drivers/acpi/processor_idle.c:691
       cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
       cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
       call_cpuidle kernel/sched/idle.c:155 [inline]
       cpuidle_idle_call kernel/sched/idle.c:236 [inline]
       do_idle+0x3e8/0x590 kernel/sched/idle.c:303
       cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
       rest_init+0x169/0x270 init/main.c:726
       arch_call_rest_init+0xf/0x14 init/main.c:882
       start_kernel+0x46e/0x48f init/main.c:1137
       secondary_startup_64_no_verify+0xce/0xdb

other info that might help us debug this:

Chain exists of:
  &priv->j1939_socks_lock --> &jsk->sk_session_queue_lock --> &priv->active_session_list_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&priv->active_session_list_lock);
                               lock(&jsk->sk_session_queue_lock);
                               lock(&priv->active_session_list_lock);
  lock(&priv->j1939_socks_lock);

 *** DEADLOCK ***

1 lock held by swapper/0/0:
 #0: ffff888077729088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #0: ffff888077729088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
 #0: ffff888077729088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_tp_rxtimer+0xe5/0x220 net/can/j1939/transport.c:1240

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc2-syzkaller-00049-g24625f7d91fb #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
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
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1b/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x240 drivers/acpi/processor_idle.c:554
Code: 89 de e8 4a 53 00 f8 84 db 75 98 e8 41 57 00 f8 e8 2c a7 06 f8 66 90 e8 35 57 00 f8 0f 00 2d 2e f0 b9 00 e8 29 57 00 f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 74 53 00 f8 48 85 db
RSP: 0018:ffffffff8ba07d38 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff8babc940 RSI: ffffffff897a1ad7 RDI: 0000000000000000
RBP: ffff888017071064 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
R13: ffff888017071000 R14: ffff888017071064 R15: ffff88801b1cd804
 acpi_idle_enter+0x369/0x510 drivers/acpi/processor_idle.c:691
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:155 [inline]
 cpuidle_idle_call kernel/sched/idle.c:236 [inline]
 do_idle+0x3e8/0x590 kernel/sched/idle.c:303
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
 rest_init+0x169/0x270 init/main.c:726
 arch_call_rest_init+0xf/0x14 init/main.c:882
 start_kernel+0x46e/0x48f init/main.c:1137
 secondary_startup_64_no_verify+0xce/0xdb
 </TASK>
vcan0: j1939_xtp_rx_abort_one: 0xffff88814717a000: 0x00000: (3) A timeout occurred and this is the connection abort to close the session.
vcan0: j1939_xtp_rx_abort_one: 0xffff88807b7b3800: 0x00000: (3) A timeout occurred and this is the connection abort to close the session.
----------------
Code disassembly (best guess):
   0:	89 de                	mov    %ebx,%esi
   2:	e8 4a 53 00 f8       	callq  0xf8005351
   7:	84 db                	test   %bl,%bl
   9:	75 98                	jne    0xffffffa3
   b:	e8 41 57 00 f8       	callq  0xf8005751
  10:	e8 2c a7 06 f8       	callq  0xf806a741
  15:	66 90                	xchg   %ax,%ax
  17:	e8 35 57 00 f8       	callq  0xf8005751
  1c:	0f 00 2d 2e f0 b9 00 	verw   0xb9f02e(%rip)        # 0xb9f051
  23:	e8 29 57 00 f8       	callq  0xf8005751
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	9c                   	pushfq <-- trapping instruction
  2b:	5b                   	pop    %rbx
  2c:	81 e3 00 02 00 00    	and    $0x200,%ebx
  32:	fa                   	cli
  33:	31 ff                	xor    %edi,%edi
  35:	48 89 de             	mov    %rbx,%rsi
  38:	e8 74 53 00 f8       	callq  0xf80053b1
  3d:	48 85 db             	test   %rbx,%rbx

