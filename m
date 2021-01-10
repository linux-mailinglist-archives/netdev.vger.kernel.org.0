Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC822F05CF
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 08:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbhAJHJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 02:09:09 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:55835 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbhAJHJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 02:09:05 -0500
Received: by mail-il1-f197.google.com with SMTP id c13so14424535ilg.22
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 23:08:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Fld8zGf0G2n9k/VSVug9v8xw4doWDdch5qYvdaP56FI=;
        b=cpfu85QWmoH/L+jN3OtqqpmOtqdyONcE3CEHtYQr3Nxhwhb9tvyoBa71e2vK0YZHiJ
         rM7D61g0dVCOvkp5r63DvfC2IoICACuEz+A7Bk8TSa1vXFZvVp8KfyJrCbOPPxhyBGVh
         DwDV1MKiL39fZ1bZozm69oLkv1io8bCLKKK28yWW+Dkox1mO+8oN31Ya/Bor6ja8DpKG
         HL74O4rfYlYDp5p+MJDZb1LSARe7QYv19orNAab50SiOzo1/eU6IG1n9G7ggRbtMF+NS
         h8wNxiFgjAGO34JyvxTrI33bKN5nNJccJqs4AgeZ6ny29F+tmyA+623uZZnNVFzV0j1I
         6PKg==
X-Gm-Message-State: AOAM530I1/EnBRaqjRIy+5dyD4/frHy4PuKHwbpCaPqNSInVvLaF4wkm
        sIei3r+L8buydHKXiCCnovHuFCaaBcDg841sPAjqAEYmVwpF
X-Google-Smtp-Source: ABdhPJzYbxEMMz77Q48kReR0b9oL42RlntGkJ2A1hfd6Z1/skj8HojXhVsDVqQseKP6E6UYOloH4HMEWwgnqFxOj2uf/XHb0tmOl
MIME-Version: 1.0
X-Received: by 2002:a5e:9b06:: with SMTP id j6mr10976526iok.171.1610262503069;
 Sat, 09 Jan 2021 23:08:23 -0800 (PST)
Date:   Sat, 09 Jan 2021 23:08:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007da00605b886740c@google.com>
Subject: possible deadlock in lock_sock_nested
From:   syzbot <syzbot+d8d5fa7f3a0c96bcdc78@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f6e7a024 Merge tag 'arc-5.11-rc3' of git://git.kernel.org/..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=135c95fb500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
dashboard link: https://syzkaller.appspot.com/bug?extid=d8d5fa7f3a0c96bcdc78
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8d5fa7f3a0c96bcdc78@syzkaller.appspotmail.com

========================================================
WARNING: possible irq lock inversion dependency detected
5.11.0-rc2-syzkaller #0 Not tainted
--------------------------------------------------------
kworker/1:0/19 just changed the state of lock:
ffff88805f80b0a0 (wq_mayday_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
ffff88805f80b0a0 (wq_mayday_lock){+.-.}-{2:2}, at: lock_sock_nested+0x3b/0x110 net/core/sock.c:3049
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&pool->lock){-.-.}-{2:2}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(wq_mayday_lock);
                               local_irq_disable();
                               lock(&pool->lock);
                               lock(wq_mayday_lock);
  <Interrupt>
    lock(&pool->lock);

 *** DEADLOCK ***

4 locks held by kworker/1:0/19:
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc90000d97da8 ((work_completion)(&(&chan->chan_timer)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
 #2: ffff88802fc01ad8 (&conn->chan_lock){+.+.}-{3:3}, at: l2cap_chan_timeout+0x69/0x2f0 net/bluetooth/l2cap_core.c:422
 #3: ffff8880623c6520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_chan_lock include/net/bluetooth/l2cap.h:852 [inline]
 #3: ffff8880623c6520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_chan_timeout+0xb5/0x2f0 net/bluetooth/l2cap_core.c:426

the shortest dependencies between 2nd lock and 1st lock:
 -> (&pool->lock){-.-.}-{2:2} {
    IN-HARDIRQ-W at:
                      lock_acquire kernel/locking/lockdep.c:5437 [inline]
                      lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                      __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                      _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                      __queue_work+0x375/0xf00 kernel/workqueue.c:1455
                      queue_work_on+0xc7/0xd0 kernel/workqueue.c:1524
                      tick_nohz_activate kernel/time/tick-sched.c:1285 [inline]
                      tick_nohz_activate kernel/time/tick-sched.c:1278 [inline]
                      tick_setup_sched_timer+0x1e8/0x320 kernel/time/tick-sched.c:1419
                      hrtimer_switch_to_hres kernel/time/hrtimer.c:738 [inline]
                      hrtimer_run_queues+0x339/0x400 kernel/time/hrtimer.c:1745
                      run_local_timers kernel/time/timer.c:1756 [inline]
                      update_process_times+0xc0/0x200 kernel/time/timer.c:1781
                      tick_periodic+0x79/0x230 kernel/time/tick-common.c:100
                      tick_handle_periodic+0x41/0x120 kernel/time/tick-common.c:112
                      local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1085 [inline]
                      __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1102
                      asm_call_irq_on_stack+0xf/0x20
                      __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
                      run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
                      sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1096
                      asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
                      native_restore_fl arch/x86/include/asm/irqflags.h:41 [inline]
                      arch_local_irq_restore arch/x86/include/asm/irqflags.h:84 [inline]
                      console_unlock+0x7b6/0xbb0 kernel/printk/printk.c:2560
                      vprintk_emit+0x189/0x490 kernel/printk/printk.c:2074
                      vprintk_func+0x8d/0x1e0 kernel/printk/printk_safe.c:393
                      printk+0xba/0xed kernel/printk/printk.c:2122
                      __clocksource_select.cold+0x7c/0xaf kernel/time/clocksource.c:776
                      clocksource_select kernel/time/clocksource.c:791 [inline]
                      clocksource_done_booting+0x35/0x44 kernel/time/clocksource.c:815
                      do_one_initcall+0x103/0x650 init/main.c:1217
                      do_initcall_level init/main.c:1290 [inline]
                      do_initcalls init/main.c:1306 [inline]
                      do_basic_setup init/main.c:1326 [inline]
                      kernel_init_freeable+0x605/0x689 init/main.c:1533
                      kernel_init+0xd/0x1b8 init/main.c:1415
                      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
    IN-SOFTIRQ-W at:
                      lock_acquire kernel/locking/lockdep.c:5437 [inline]
                      lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                      __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                      _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                      __queue_work+0x375/0xf00 kernel/workqueue.c:1455
                      call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1417
                      expire_timers kernel/time/timer.c:1457 [inline]
                      __run_timers.part.0+0x4a6/0xa50 kernel/time/timer.c:1731
                      __run_timers kernel/time/timer.c:1712 [inline]
                      run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1744
                      __do_softirq+0x2a5/0x9f7 kernel/softirq.c:343
                      asm_call_irq_on_stack+0xf/0x20
                      __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
                      run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
                      do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
                      invoke_softirq kernel/softirq.c:226 [inline]
                      __irq_exit_rcu kernel/softirq.c:420 [inline]
                      irq_exit_rcu+0x134/0x200 kernel/softirq.c:432
                      sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1096
                      asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
                      native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
                      arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
                      default_idle+0xe/0x10 arch/x86/kernel/process.c:688
                      default_idle_call+0x87/0xd0 kernel/sched/idle.c:112
                      cpuidle_idle_call kernel/sched/idle.c:194 [inline]
                      do_idle+0x3fa/0x590 kernel/sched/idle.c:299
                      cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:396
                      start_secondary+0x274/0x350 arch/x86/kernel/smpboot.c:271
                      secondary_startup_64_no_verify+0xb0/0xbb
    INITIAL USE at:
                     lock_acquire kernel/locking/lockdep.c:5437 [inline]
                     lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                     __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                     _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
                     pwq_adjust_max_active+0x177/0x5f0 kernel/workqueue.c:3726
                     link_pwq+0x144/0x290 kernel/workqueue.c:3792
                     alloc_and_link_pwqs kernel/workqueue.c:4186 [inline]
                     alloc_workqueue+0x66f/0xe70 kernel/workqueue.c:4308
                     workqueue_init_early+0x508/0x69b kernel/workqueue.c:5982
                     start_kernel+0x1f3/0x48c init/main.c:939
                     secondary_startup_64_no_verify+0xb0/0xbb
  }
  ... key      at: [<ffffffff8e4bf920>] __key.20+0x0/0x40
  ... acquired at:
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
   pool_mayday_timeout+0x36/0x5a0 kernel/workqueue.c:2046
   call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1417
   expire_timers kernel/time/timer.c:1462 [inline]
   __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1731
   __run_timers kernel/time/timer.c:1712 [inline]
   run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1744
   __do_softirq+0x2a5/0x9f7 kernel/softirq.c:343
   asm_call_irq_on_stack+0xf/0x20
   __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
   run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
   do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
   invoke_softirq kernel/softirq.c:226 [inline]
   __irq_exit_rcu kernel/softirq.c:420 [inline]
   irq_exit_rcu+0x134/0x200 kernel/softirq.c:432
   sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1096
   asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
   native_restore_fl arch/x86/include/asm/irqflags.h:41 [inline]
   arch_local_irq_restore arch/x86/include/asm/irqflags.h:84 [inline]
   lock_acquire kernel/locking/lockdep.c:5440 [inline]
   lock_acquire+0x2c7/0x740 kernel/locking/lockdep.c:5402
   rcu_lock_acquire include/linux/rcupdate.h:259 [inline]
   rcu_read_lock include/linux/rcupdate.h:648 [inline]
   inet_twsk_purge+0x112/0x7c0 net/ipv4/inet_timewait_sock.c:268
   ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
   setup_net+0x508/0x850 net/core/net_namespace.c:365
   copy_net_ns+0x31e/0x760 net/core/net_namespace.c:483
   create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
   unshare_nsproxy_namespaces+0xbd/0x1f0 kernel/nsproxy.c:226
   ksys_unshare+0x445/0x8e0 kernel/fork.c:2957
   __do_sys_unshare kernel/fork.c:3025 [inline]
   __se_sys_unshare kernel/fork.c:3023 [inline]
   __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3023
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> (wq_mayday_lock){+.-.}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire kernel/locking/lockdep.c:5437 [inline]
                    lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                    __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                    _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                    spin_lock_bh include/linux/spinlock.h:359 [inline]
                    lock_sock_nested+0x3b/0x110 net/core/sock.c:3049
                    l2cap_sock_teardown_cb+0xa1/0x660 net/bluetooth/l2cap_sock.c:1520
                    l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
                    l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
                    l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
                    process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
                    worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
                    kthread+0x3b1/0x4a0 kernel/kthread.c:292
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
   IN-SOFTIRQ-W at:
                    lock_acquire kernel/locking/lockdep.c:5437 [inline]
                    lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                    pool_mayday_timeout+0x36/0x5a0 kernel/workqueue.c:2046
                    call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1417
                    expire_timers kernel/time/timer.c:1462 [inline]
                    __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1731
                    __run_timers kernel/time/timer.c:1712 [inline]
                    run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1744
                    __do_softirq+0x2a5/0x9f7 kernel/softirq.c:343
                    asm_call_irq_on_stack+0xf/0x20
                    __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
                    run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
                    do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
                    invoke_softirq kernel/softirq.c:226 [inline]
                    __irq_exit_rcu kernel/softirq.c:420 [inline]
                    irq_exit_rcu+0x134/0x200 kernel/softirq.c:432
                    sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1096
                    asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
                    loop2+0x8/0x39e
   INITIAL USE at:
                   lock_acquire kernel/locking/lockdep.c:5437 [inline]
                   lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                   __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
                   _raw_spin_lock_irq+0x32/0x50 kernel/locking/spinlock.c:167
                   rescuer_thread+0x1cc/0xd30 kernel/workqueue.c:2495
                   kthread+0x3b1/0x4a0 kernel/kthread.c:292
                   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
 }
 ... key      at: [<ffffffff8b22dff8>] wq_mayday_lock+0x18/0x60
 ... acquired at:
   mark_usage kernel/locking/lockdep.c:4320 [inline]
   __lock_acquire+0x857/0x5500 kernel/locking/lockdep.c:4786
   lock_acquire kernel/locking/lockdep.c:5437 [inline]
   lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
   _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
   spin_lock_bh include/linux/spinlock.h:359 [inline]
   lock_sock_nested+0x3b/0x110 net/core/sock.c:3049
   l2cap_sock_teardown_cb+0xa1/0x660 net/bluetooth/l2cap_sock.c:1520
   l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
   l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
   l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
   process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
   worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
   kthread+0x3b1/0x4a0 kernel/kthread.c:292
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


stack backtrace:
CPU: 1 PID: 19 Comm: kworker/1:0 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_irq_inversion_bug kernel/locking/lockdep.c:3740 [inline]
 check_usage_backwards kernel/locking/lockdep.c:3884 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3974 [inline]
 mark_lock.cold+0x1a/0x73 kernel/locking/lockdep.c:4411
 mark_usage kernel/locking/lockdep.c:4320 [inline]
 __lock_acquire+0x857/0x5500 kernel/locking/lockdep.c:4786
 lock_acquire kernel/locking/lockdep.c:5437 [inline]
 lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3049
 l2cap_sock_teardown_cb+0xa1/0x660 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
================================================================================
UBSAN: array-index-out-of-bounds in kernel/locking/qspinlock.c:130:9
index 8847 is out of range for type 'long unsigned int [8]'
CPU: 1 PID: 19 Comm: kworker/1:0 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:356
 decode_tail kernel/locking/qspinlock.c:130 [inline]
 __pv_queued_spin_lock_slowpath+0xa3f/0xb40 kernel/locking/qspinlock.c:468
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3049
 l2cap_sock_teardown_cb+0xa1/0x660 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
