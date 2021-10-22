Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E664E437635
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 13:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhJVLyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 07:54:43 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52070 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbhJVLyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 07:54:40 -0400
Received: by mail-il1-f198.google.com with SMTP id a14-20020a927f0e000000b002597075cb35so2305719ild.18
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 04:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TpOrTQ0YqVBm4j2wWjK2yEf2nDCJV6B1tvSZTnvwQgE=;
        b=fLib4UodbW2bxSGf4kHQVtqDJhiWW9LG5Hyc0uH75rDj/oxwcE30lIVJN3yEZMQlJn
         21sZpIut+O2BjRa1Ou92lanVnQDv1zjZj9agXP8TUj+Lyosf3mna79T2rRVnIPMaHqZa
         h3+a4avosIfcMjCChL7Fj3Srz5jMN2wM6lFDDRaQzCh2nNgXQ7ewo2RGE27sk3W3PvAV
         QufN07oMA7hIqQO4skjOL2pyERUlacPSY53yqOxYekW0J45lWVCPPfeNSoS3rRIWMYuj
         pbk7wVXL3XtYpLy4yg/z1DSBa5a9xg1J9j15VdycWc07gaM5oiP+3kwX4Fv3qUquROqh
         iSwQ==
X-Gm-Message-State: AOAM533Exe5w0/381INvxyJv3VCNU0c0MtUj6ArnHjCmUiZgVUnl5eCL
        8kTqifkkAKbaLMg5AJgrESrz079lCqeVQgxYFlIqkP/KzYtL
X-Google-Smtp-Source: ABdhPJynERh2zBclqhc4kwJuTvnOqdkDJmF/CHWtV8sW4HxaePX00bne/qKj9ixjk9SE6M1QTujZkecq1EC+Q01HUm70Up4bS1m9
MIME-Version: 1.0
X-Received: by 2002:a92:6c0c:: with SMTP id h12mr7391337ilc.32.1634903542738;
 Fri, 22 Oct 2021 04:52:22 -0700 (PDT)
Date:   Fri, 22 Oct 2021 04:52:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8364c05ceefa4cf@google.com>
Subject: [syzbot] possible deadlock in j1939_session_activate
From:   syzbot <syzbot+f32cbede7fd867ce0d56@syzkaller.appspotmail.com>
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

HEAD commit:    fac3cb82a54a net: bridge: mcast: use multicast_membership_..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11554c0cb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
dashboard link: https://syzkaller.appspot.com/bug?extid=f32cbede7fd867ce0d56
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f32cbede7fd867ce0d56@syzkaller.appspotmail.com

vxcan0: j1939_tp_rxtimer: 0xffff888075703400: abort rx timeout. Force session deactivation
======================================================
WARNING: possible circular locking dependency detected
5.15.0-rc5-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.1/10231 is trying to acquire lock:
ffff888035e15088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:368 [inline]
ffff888035e15088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
ffff888035e15088 (&priv->active_session_list_lock){+.-.}-{2:2}, at: j1939_session_activate+0x43/0x4b0 net/can/j1939/transport.c:1554

but task is already holding lock:
ffff88808959e5c0 (&jsk->sk_session_queue_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:368 [inline]
ffff88808959e5c0 (&jsk->sk_session_queue_lock){+.-.}-{2:2}, at: j1939_sk_queue_activate_next+0x56/0x460 net/can/j1939/socket.c:204

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&jsk->sk_session_queue_lock){+.-.}-{2:2}:
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
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2510
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1935
       sock_sendmsg_nosec net/socket.c:704 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:724
       ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #1 (&priv->j1939_socks_lock){+.-.}-{2:2}:
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:368 [inline]
       j1939_sk_errqueue+0x9f/0x1a0 net/can/j1939/socket.c:1078
       __j1939_session_cancel+0x3b9/0x460 net/can/j1939/transport.c:1124
       j1939_session_cancel net/can/j1939/transport.c:1135 [inline]
       j1939_xtp_rx_dat_one+0xbc2/0xed0 net/can/j1939/transport.c:1907
       j1939_xtp_rx_dat net/can/j1939/transport.c:1935 [inline]
       j1939_tp_recv+0x4ec/0xb40 net/can/j1939/transport.c:2108
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

-> #0 (&priv->active_session_list_lock){+.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
       _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:368 [inline]
       j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
       j1939_session_activate+0x43/0x4b0 net/can/j1939/transport.c:1554
       j1939_sk_queue_activate_next_locked net/can/j1939/socket.c:181 [inline]
       j1939_sk_queue_activate_next+0x29b/0x460 net/can/j1939/socket.c:205
       j1939_session_deactivate_activate_next+0x2e/0x35 net/can/j1939/transport.c:1101
       j1939_tp_rxtimer+0xcc/0x36b net/can/j1939/transport.c:1228
       __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
       __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
       hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1766
       __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
       invoke_softirq kernel/softirq.c:432 [inline]
       __irq_exit_rcu+0x123/0x180 kernel/softirq.c:636
       irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
       sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       mm_update_next_owner+0x341/0x7a0 kernel/exit.c:379
       exit_mm kernel/exit.c:500 [inline]
       do_exit+0xab4/0x2a30 kernel/exit.c:812
       do_group_exit+0x125/0x310 kernel/exit.c:922
       get_signal+0x47f/0x2160 kernel/signal.c:2868
       arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
       handle_signal_work kernel/entry/common.c:148 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
       exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
       __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
       syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
       do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  &priv->active_session_list_lock --> &priv->j1939_socks_lock --> &jsk->sk_session_queue_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&jsk->sk_session_queue_lock);
                               lock(&priv->j1939_socks_lock);
                               lock(&jsk->sk_session_queue_lock);
  lock(&priv->active_session_list_lock);

 *** DEADLOCK ***

2 locks held by syz-executor.1/10231:
 #0: ffffffff8b60a098 (tasklist_lock){.+.+}-{2:2}, at: mm_update_next_owner+0x100/0x7a0 kernel/exit.c:367
 #1: ffff88808959e5c0 (&jsk->sk_session_queue_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:368 [inline]
 #1: ffff88808959e5c0 (&jsk->sk_session_queue_lock){+.-.}-{2:2}, at: j1939_sk_queue_activate_next+0x56/0x460 net/can/j1939/socket.c:204

stack backtrace:
CPU: 1 PID: 10231 Comm: syz-executor.1 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
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
 j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
 j1939_session_activate+0x43/0x4b0 net/can/j1939/transport.c:1554
 j1939_sk_queue_activate_next_locked net/can/j1939/socket.c:181 [inline]
 j1939_sk_queue_activate_next+0x29b/0x460 net/can/j1939/socket.c:205
 j1939_session_deactivate_activate_next+0x2e/0x35 net/can/j1939/transport.c:1101
 j1939_tp_rxtimer+0xcc/0x36b net/can/j1939/transport.c:1228
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
RIP: 0010:mm_update_next_owner+0x341/0x7a0 kernel/exit.c:379
Code: a8 05 00 00 4c 89 f0 48 c1 e8 03 80 3c 18 00 0f 85 5a 04 00 00 48 8b 85 a8 05 00 00 48 8d a8 48 fa ff ff 49 39 c6 75 32 eb 6c <e8> ba ee 30 00 48 8d bd b8 05 00 00 48 89 f8 48 c1 e8 03 80 3c 18
RSP: 0018:ffffc900041c7b40 EFLAGS: 00000207
RAX: 1ffff11005a9742a RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff88801c113900 RSI: ffffffff8145e986 RDI: ffff88801c113e98
RBP: ffff88802d4b9c80 R08: 0000000000000001 R09: ffffffff8b60a083
R10: fffffbfff16c1410 R11: 0000000000000000 R12: ffff888090651500
R13: ffff88802d4ba150 R14: ffff888021c0a228 R15: ffff88801c113900
 exit_mm kernel/exit.c:500 [inline]
 do_exit+0xab4/0x2a30 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4b967e3a39
Code: Unable to access opcode bytes at RIP 0x7f4b967e3a0f.
RSP: 002b:00007f4b93d38188 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: 0000000000000002 RBX: 00007f4b968e7020 RCX: 00007f4b967e3a39
RDX: 0492492492492627 RSI: 00000000200000c0 RDI: 0000000000000006
RBP: 00007f4b9683dc5f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff9fcb162f R14: 00007f4b93d38300 R15: 0000000000022000
vxcan0: j1939_tp_rxtimer: 0xffff888078ce8000: rx timeout, send abort
vxcan0: j1939_tp_rxtimer: 0xffff888078ce8000: abort rx timeout. Force session deactivation
----------------
Code disassembly (best guess):
   0:	a8 05                	test   $0x5,%al
   2:	00 00                	add    %al,(%rax)
   4:	4c 89 f0             	mov    %r14,%rax
   7:	48 c1 e8 03          	shr    $0x3,%rax
   b:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
   f:	0f 85 5a 04 00 00    	jne    0x46f
  15:	48 8b 85 a8 05 00 00 	mov    0x5a8(%rbp),%rax
  1c:	48 8d a8 48 fa ff ff 	lea    -0x5b8(%rax),%rbp
  23:	49 39 c6             	cmp    %rax,%r14
  26:	75 32                	jne    0x5a
  28:	eb 6c                	jmp    0x96
* 2a:	e8 ba ee 30 00       	callq  0x30eee9 <-- trapping instruction
  2f:	48 8d bd b8 05 00 00 	lea    0x5b8(%rbp),%rdi
  36:	48 89 f8             	mov    %rdi,%rax
  39:	48 c1 e8 03          	shr    $0x3,%rax
  3d:	80                   	.byte 0x80
  3e:	3c 18                	cmp    $0x18,%al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
