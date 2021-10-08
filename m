Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7D142631A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 05:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbhJHDiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 23:38:14 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55106 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJHDiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 23:38:11 -0400
Received: by mail-il1-f199.google.com with SMTP id 2-20020a920d02000000b002589c563709so5211564iln.21
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 20:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=902wbroTSJOlSvJHgphnrum66ZtbbqLlphvGKePnXOw=;
        b=DT/mF1hBF7onN3EdDF/pGEX/PVz9g0qQzP4Vxut0N8l3aaYeOd/QHi8wSp9wd/hCJ+
         b+zM6JXae+dW/JXPXlnTWo9VGn2RLM6qXwu6RLyfZELtv7vQEXrrikYdPndDfygGMgMw
         Kusx9prLvAtjQ/a6eUuZis+zC7bl0luHwlj9YouYBej8UiMTsEOkDnjyWa695nZuh4Ug
         piwsbGj5eFeENIZKiHHhWnMWruUBO1et60gVCTKYanXj7Lo+nfO7fAn1V/K65JNSKA2h
         Mzu3OzuwpWdYo1C4nvsnCKjFncoQK1OCBsI+wDDz4MFtkAgTBIAl/gJuYpBieSNmYwXH
         XvVA==
X-Gm-Message-State: AOAM530JYGpU6u9tHPEZ2Xh3s4nB2q0qBDd22q8HNQ0E7EudTCzIQr6e
        F+vr9ngTLMQzh8cRgj1G97bCsos9uhsN5wCHJScP/lPaz7sD
X-Google-Smtp-Source: ABdhPJzRSlTXftwQ0zX3Cgl6kQStt6njO61efk8cdBalTqUS9HF3tkN2RTgph8GvVXIOa+jC9rcsQ/Ad79h8M16uaHz0qTBoGuWO
MIME-Version: 1.0
X-Received: by 2002:a92:bd04:: with SMTP id c4mr6140147ile.217.1633664177003;
 Thu, 07 Oct 2021 20:36:17 -0700 (PDT)
Date:   Thu, 07 Oct 2021 20:36:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3e56405cdcf14cd@google.com>
Subject: [syzbot] possible deadlock in j1939_sk_errqueue
From:   syzbot <syzbot+ee1cd780f69483a8616b@syzkaller.appspotmail.com>
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

HEAD commit:    7cd8b1542a7b ptp_pch: Load module automatically if ID matc..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12ebf7df300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
dashboard link: https://syzkaller.appspot.com/bug?extid=ee1cd780f69483a8616b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ee1cd780f69483a8616b@syzkaller.appspotmail.com

vcan0: j1939_tp_rxtimer: 0xffff8881480fd400: rx timeout, send abort
======================================================
WARNING: possible circular locking dependency detected
5.15.0-rc3-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:6/9270 is trying to acquire lock:
ffff8880909c90d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:368 [inline]
ffff8880909c90d0 (&priv->j1939_socks_lock){+.-.}-{2:2}, at: j1939_sk_errqueue+0x9f/0x1a0 net/can/j1939/socket.c:1078

but task is already holding lock:
ffff8880909c9088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:368 [inline]
ffff8880909c9088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
ffff8880909c9088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_tp_rxtimer+0x1c0/0x36b net/can/j1939/transport.c:1243

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&priv->active_session_list_lock){+.-.}-{2:2}:
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:368 [inline]
       j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
       j1939_session_activate+0x43/0x4b0 net/can/j1939/transport.c:1554
       j1939_sk_queue_activate_next_locked net/can/j1939/socket.c:181 [inline]
       j1939_sk_queue_activate_next+0x29b/0x460 net/can/j1939/socket.c:205
       j1939_session_deactivate_activate_next net/can/j1939/transport.c:1101 [inline]
       j1939_session_completed+0x80/0x120 net/can/j1939/transport.c:1214
       j1939_xtp_rx_eoma_one net/can/j1939/transport.c:1385 [inline]
       j1939_xtp_rx_eoma+0x2a6/0x5f0 net/can/j1939/transport.c:1400
       j1939_tp_cmd_recv net/can/j1939/transport.c:2079 [inline]
       j1939_tp_recv+0x430/0xb40 net/can/j1939/transport.c:2118
       j1939_can_recv+0x6d7/0x930 net/can/j1939/main.c:101
       deliver net/can/af_can.c:574 [inline]
       can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
       can_receive+0x31d/0x580 net/can/af_can.c:665
       can_rcv+0x120/0x1c0 net/can/af_can.c:696
       __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5436
       __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5550
       process_backlog+0x2a5/0x6c0 net/core/dev.c:6427
       __napi_poll+0xaf/0x440 net/core/dev.c:6986
       napi_poll net/core/dev.c:7053 [inline]
       net_rx_action+0x801/0xb40 net/core/dev.c:7140
       __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
       run_ksoftirqd kernel/softirq.c:920 [inline]
       run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
       smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
       kthread+0x3e5/0x4d0 kernel/kthread.c:319
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #1 (&jsk->sk_session_queue_lock){+.-.}-{2:2}:
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:368 [inline]
       j1939_sk_queue_drop_all+0x40/0x2f0 net/can/j1939/socket.c:139
       j1939_sk_netdev_event_netdown+0x7b/0x160 net/can/j1939/socket.c:1272
       j1939_netdev_notify+0x199/0x1d0 net/can/j1939/main.c:362
       notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
       call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
       call_netdevice_notifiers net/core/dev.c:2022 [inline]
       dev_close_many+0x2ff/0x620 net/core/dev.c:1597
       unregister_netdevice_many+0x3ff/0x1790 net/core/dev.c:11020
       rtnl_delete_link net/core/rtnetlink.c:3063 [inline]
       rtnl_dellink+0x354/0xa80 net/core/rtnetlink.c:3115
       rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
       netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
       netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
       sock_sendmsg_nosec net/socket.c:704 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:724
       ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&priv->j1939_socks_lock){+.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:368 [inline]
       j1939_sk_errqueue+0x9f/0x1a0 net/can/j1939/socket.c:1078
       __j1939_session_cancel+0x3b9/0x460 net/can/j1939/transport.c:1124
       j1939_tp_rxtimer+0x2a8/0x36b net/can/j1939/transport.c:1250
       __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
       __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
       hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1766
       __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
       invoke_softirq kernel/softirq.c:432 [inline]
       __irq_exit_rcu+0x123/0x180 kernel/softirq.c:636
       irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
       sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       batadv_nc_process_nc_paths.part.0+0x24e/0x3c0 net/batman-adv/network-coding.c:685
       batadv_nc_process_nc_paths net/batman-adv/network-coding.c:681 [inline]
       batadv_nc_worker+0xc46/0xfa0 net/batman-adv/network-coding.c:730
       process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
       worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
       kthread+0x3e5/0x4d0 kernel/kthread.c:319
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

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

3 locks held by kworker/u4:6/9270:
 #0: ffff888025be1938 ((wq_completion)bat_events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888025be1938 ((wq_completion)bat_events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888025be1938 ((wq_completion)bat_events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888025be1938 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888025be1938 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888025be1938 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc9000451fdb0 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffff8880909c9088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:368 [inline]
 #2: ffff8880909c9088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
 #2: ffff8880909c9088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_tp_rxtimer+0x1c0/0x36b net/can/j1939/transport.c:1243

stack backtrace:
CPU: 0 PID: 9270 Comm: kworker/u4:6 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:368 [inline]
 j1939_sk_errqueue+0x9f/0x1a0 net/can/j1939/socket.c:1078
 __j1939_session_cancel+0x3b9/0x460 net/can/j1939/transport.c:1124
 j1939_tp_rxtimer+0x2a8/0x36b net/can/j1939/transport.c:1250
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1766
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:636
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:batadv_nc_process_nc_paths.part.0+0x24e/0x3c0 net/batman-adv/network-coding.c:685
Code: c6 43 5f d2 88 48 c7 c7 60 fe 97 8b e8 0b f0 88 f8 48 8b 44 24 28 83 44 24 14 01 0f b6 00 84 c0 74 08 3c 03 0f 8e 2e 01 00 00 <48> 8b 44 24 18 44 8b 7c 24 14 8b 58 10 44 89 fe 89 df e8 4b a6 a3
RSP: 0018:ffffc9000451fc20 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffc9000451fba8
RDX: 1ffff11004b9fbed RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88806ecd5790 R14: ffff88806ecd4c80 R15: 0000000000000400
 batadv_nc_process_nc_paths net/batman-adv/network-coding.c:681 [inline]
 batadv_nc_worker+0xc46/0xfa0 net/batman-adv/network-coding.c:730
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
vcan0: j1939_tp_rxtimer: 0xffff8881480fd400: abort rx timeout. Force session deactivation
----------------
Code disassembly (best guess), 5 bytes skipped:
   0:	48 c7 c7 60 fe 97 8b 	mov    $0xffffffff8b97fe60,%rdi
   7:	e8 0b f0 88 f8       	callq  0xf888f017
   c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  11:	83 44 24 14 01       	addl   $0x1,0x14(%rsp)
  16:	0f b6 00             	movzbl (%rax),%eax
  19:	84 c0                	test   %al,%al
  1b:	74 08                	je     0x25
  1d:	3c 03                	cmp    $0x3,%al
  1f:	0f 8e 2e 01 00 00    	jle    0x153
* 25:	48 8b 44 24 18       	mov    0x18(%rsp),%rax <-- trapping instruction
  2a:	44 8b 7c 24 14       	mov    0x14(%rsp),%r15d
  2f:	8b 58 10             	mov    0x10(%rax),%ebx
  32:	44 89 fe             	mov    %r15d,%esi
  35:	89 df                	mov    %ebx,%edi
  37:	e8                   	.byte 0xe8
  38:	4b a6                	rex.WXB cmpsb %es:(%rdi),%ds:(%rsi)
  3a:	a3                   	.byte 0xa3


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
