Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E41886B1D
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404237AbfHHUIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:08:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54105 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732704AbfHHUIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 16:08:04 -0400
Received: from p200300ddd71876597e7a91fffec98e25.dip0.t-ipconnect.de ([2003:dd:d718:7659:7e7a:91ff:fec9:8e25])
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hvohZ-0007MH-CH; Thu, 08 Aug 2019 22:07:57 +0200
Date:   Thu, 8 Aug 2019 22:07:51 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     syzbot <syzbot+2d55fb97f42947bbcddd@syzkaller.appspotmail.com>
cc:     Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        syzkaller-bugs@googlegroups.com,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: BUG: soft lockup in tcp_delack_timer
In-Reply-To: <00000000000094d2b5058f9df271@google.com>
Message-ID: <alpine.DEB.2.21.1908082206350.2882@nanos.tec.linutronix.de>
References: <00000000000094d2b5058f9df271@google.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Aug 2019, syzbot wrote:

Cc+ Eric, net-dev

> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    0d8b3265 Add linux-next specific files for 20190729
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1101fdc8600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ae96f3b8a7e885f7
> dashboard link: https://syzkaller.appspot.com/bug?extid=2d55fb97f42947bbcddd
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2d55fb97f42947bbcddd@syzkaller.appspotmail.com
> 
> net_ratelimit: 2 callbacks suppressed
> TCP: request_sock_TCPv6: Possible SYN flooding on port 20002. Sending cookies.
> Check SNMP counters.
> watchdog: BUG: soft lockup - CPU#0 stuck for 122s! [swapper/0:0]
> Modules linked in:
> irq event stamp: 92022
> hardirqs last  enabled at (92021): [<ffffffff81660331>]
> tick_nohz_idle_exit+0x181/0x2e0 kernel/time/tick-sched.c:1180
> hardirqs last disabled at (92022): [<ffffffff873d5d7d>]
> __schedule+0x1dd/0x15b0 kernel/sched/core.c:3862
> softirqs last  enabled at (90810): [<ffffffff876006cd>]
> __do_softirq+0x6cd/0x98c kernel/softirq.c:319
> softirqs last disabled at (90703): [<ffffffff8144fc1b>] invoke_softirq
> kernel/softirq.c:373 [inline]
> softirqs last disabled at (90703): [<ffffffff8144fc1b>] irq_exit+0x19b/0x1e0
> kernel/softirq.c:413
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-rc2-next-20190729 #54
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
> 01/01/2011
> RIP: 0010:cpu_relax arch/x86/include/asm/processor.h:656 [inline]
> RIP: 0010:virt_spin_lock arch/x86/include/asm/qspinlock.h:84 [inline]
> RIP: 0010:native_queued_spin_lock_slowpath+0x132/0x9f0
> kernel/locking/qspinlock.c:325
> Code: 00 00 00 48 8b 45 d0 65 48 33 04 25 28 00 00 00 0f 85 37 07 00 00 48 81
> c4 98 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 f3 90 <e9> 73 ff ff ff 8b 45
> 98 4c 8d 65 d8 3d 00 01 00 00 0f 84 e5 00 00
> RSP: 0018:ffff8880ae809b48 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffff8880621cd088 RCX: ffffffff8158f117
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8880621cd088
> RBP: ffff8880ae809c08 R08: 1ffff1100c439a11 R09: ffffed100c439a12
> R10: ffffed100c439a11 R11: ffff8880621cd08b R12: 0000000000000001
> R13: 0000000000000003 R14: ffffed100c439a11 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000001541e88 CR3: 0000000068089000 CR4: 00000000001406f0
> Call Trace:
> <IRQ>
> pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:642 [inline]
> queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
> queued_spin_lock include/asm-generic/qspinlock.h:81 [inline]
> do_raw_spin_lock+0x20e/0x2e0 kernel/locking/spinlock_debug.c:113
> __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
> _raw_spin_lock+0x37/0x40 kernel/locking/spinlock.c:151
> spin_lock include/linux/spinlock.h:338 [inline]
> tcp_delack_timer+0x2b/0x2a0 net/ipv4/tcp_timer.c:318
> call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1322
> expire_timers kernel/time/timer.c:1366 [inline]
> __run_timers kernel/time/timer.c:1685 [inline]
> __run_timers kernel/time/timer.c:1653 [inline]
> run_timer_softirq+0x697/0x17a0 kernel/time/timer.c:1698
> __do_softirq+0x262/0x98c kernel/softirq.c:292
> invoke_softirq kernel/softirq.c:373 [inline]
> irq_exit+0x19b/0x1e0 kernel/softirq.c:413
> exiting_irq arch/x86/include/asm/apic.h:536 [inline]
> smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1095
> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
> </IRQ>
> RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
> Code: c8 75 6e fa eb 8a 90 90 90 90 90 90 e9 07 00 00 00 0f 00 2d c4 b2 49 00
> f4 c3 66 90 e9 07 00 00 00 0f 00 2d b4 b2 49 00 fb f4 <c3> 90 55 48 89 e5 41
> 57 41 56 41 55 41 54 53 e8 8e 56 21 fa e8 29
> RSP: 0018:ffffffff88c07ce8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
> RAX: 1ffffffff11a5e87 RBX: ffffffff88c7a1c0 RCX: 1ffffffff134bca6
> RDX: dffffc0000000000 RSI: ffffffff81779dee RDI: ffffffff873e794c
> RBP: ffffffff88c07d18 R08: ffffffff88c7a1c0 R09: fffffbfff118f439
> R10: fffffbfff118f438 R11: ffffffff88c7a1c7 R12: dffffc0000000000
> R13: ffffffff89a5b340 R14: 0000000000000000 R15: 0000000000000000
> arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
> default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
> cpuidle_idle_call kernel/sched/idle.c:154 [inline]
> do_idle+0x413/0x760 kernel/sched/idle.c:263
> cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354
> rest_init+0x245/0x37b init/main.c:451
> arch_call_rest_init+0xe/0x1b
> start_kernel+0x912/0x951 init/main.c:785
> x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:472
> x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:453
> secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241
> Sending NMI from CPU 0 to CPUs 1:
> INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.339
> msecs
> NMI backtrace for cpu 1
> CPU: 1 PID: 7447 Comm: syz-executor.5 Not tainted 5.3.0-rc2-next-20190729 #54
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
> 01/01/2011
> RIP: 0010:cpu_relax arch/x86/include/asm/processor.h:656 [inline]
> RIP: 0010:virt_spin_lock arch/x86/include/asm/qspinlock.h:84 [inline]
> RIP: 0010:native_queued_spin_lock_slowpath+0x132/0x9f0
> kernel/locking/qspinlock.c:325
> Code: 00 00 00 48 8b 45 d0 65 48 33 04 25 28 00 00 00 0f 85 37 07 00 00 48 81
> c4 98 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 f3 90 <e9> 73 ff ff ff 8b 45
> 98 4c 8d 65 d8 3d 00 01 00 00 0f 84 e5 00 00
> RSP: 0018:ffff8880ae909210 EFLAGS: 00000202
> RAX: 0000000000000000 RBX: ffff8880621cd088 RCX: ffffffff8158f117
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8880621cd088
> RBP: ffff8880ae9092d0 R08: 1ffff1100c439a11 R09: ffffed100c439a12
> R10: ffffed100c439a11 R11: ffff8880621cd08b R12: 0000000000000001
> R13: 0000000000000003 R14: ffffed100c439a11 R15: 0000000000000001
> FS:  0000555557246940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b32b29000 CR3: 00000000a4e3a000 CR4: 00000000001406e0
> Call Trace:
> <IRQ>
> pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:642 [inline]
> queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
> queued_spin_lock include/asm-generic/qspinlock.h:81 [inline]
> do_raw_spin_lock+0x20e/0x2e0 kernel/locking/spinlock_debug.c:113
> __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
> _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
> spin_lock_bh include/linux/spinlock.h:343 [inline]
> release_sock+0x20/0x1c0 net/core/sock.c:2932
> wait_on_pending_writer+0x20f/0x420 net/tls/tls_main.c:91
> tls_sk_proto_cleanup+0x2c5/0x3e0 net/tls/tls_main.c:295
> tls_sk_proto_unhash+0x90/0x3f0 net/tls/tls_main.c:330
> tcp_set_state+0x5b9/0x7d0 net/ipv4/tcp.c:2235
> tcp_done+0xe2/0x320 net/ipv4/tcp.c:3824
> tcp_reset+0x132/0x500 net/ipv4/tcp_input.c:4080
> tcp_validate_incoming+0xa2d/0x1660 net/ipv4/tcp_input.c:5440
> tcp_rcv_established+0x6b5/0x1e70 net/ipv4/tcp_input.c:5648
> tcp_v6_do_rcv+0x41e/0x12c0 net/ipv6/tcp_ipv6.c:1356
> tcp_v6_rcv+0x31f1/0x3500 net/ipv6/tcp_ipv6.c:1588
> ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
> ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
> NF_HOOK include/linux/netfilter.h:305 [inline]
> NF_HOOK include/linux/netfilter.h:299 [inline]
> ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
> dst_input include/net/dst.h:442 [inline]
> ip6_rcv_finish+0x1de/0x2f0 net/ipv6/ip6_input.c:76
> NF_HOOK include/linux/netfilter.h:305 [inline]
> NF_HOOK include/linux/netfilter.h:299 [inline]
> ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:272
> __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:4999
> __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5113
> process_backlog+0x206/0x750 net/core/dev.c:5924
> napi_poll net/core/dev.c:6347 [inline]
> net_rx_action+0x508/0x10c0 net/core/dev.c:6413
> __do_softirq+0x262/0x98c kernel/softirq.c:292
> do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1080
> </IRQ>
> do_softirq.part.0+0x11a/0x170 kernel/softirq.c:337
> do_softirq kernel/softirq.c:329 [inline]
> __local_bh_enable_ip+0x211/0x270 kernel/softirq.c:189
> local_bh_enable include/linux/bottom_half.h:32 [inline]
> inet_csk_listen_stop+0x1e0/0x850 net/ipv4/inet_connection_sock.c:993
> tcp_close+0xd5b/0x10e0 net/ipv4/tcp.c:2338
> inet_release+0xed/0x200 net/ipv4/af_inet.c:427
> inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
> __sock_release+0xce/0x280 net/socket.c:590
> sock_close+0x1e/0x30 net/socket.c:1268
> __fput+0x2ff/0x890 fs/file_table.c:280
> ____fput+0x16/0x20 fs/file_table.c:313
> task_work_run+0x145/0x1c0 kernel/task_work.c:113
> tracehook_notify_resume include/linux/tracehook.h:188 [inline]
> exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
> prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
> syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
> do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
> entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x413511
> Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83
> ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2
> e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:00007ffebfc402f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413511
> RDX: 0000000000000000 RSI: 000000000000183f RDI: 0000000000000004
> RBP: 0000000000000001 R08: 00000000c44ab83f R09: 00000000c44ab843
> R10: 00007ffebfc403d0 R11: 0000000000000293 R12: 000000000075c9a0
> R13: 000000000075c9a0 R14: 0000000000760750 R15: ffffffffffffffff
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
