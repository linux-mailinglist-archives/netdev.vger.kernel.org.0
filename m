Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9114B26BFDB
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIPIvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:51:48 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:37709 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgIPIvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:51:17 -0400
Received: by mail-io1-f79.google.com with SMTP id 80so4515834iou.4
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 01:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A3zXw0rwPpsrJBkbg4lNri/dy9RfTpE2Fi9t1Xpxlfc=;
        b=pEPlVcJAncJVHPRbkGbfmrZdc1HidOZRfJ/TNLIChQbuLIkko/p/ptrOR2w6BOCfiL
         v3XA6mb3pJTJSEb5OK7IycKJNylModwNtblljouJayQN7hQLV1Vp7UsrGuQcsP5uiTkL
         +Ebn2TL9kUBCozcMY20I2WFHbf6UuDnLg21cY0w12k23us7M9WKHx+Z3E5W5rt+lWnXf
         pWfl53tS422tlrKv8Ll1IF/qzmHRdbnbrezKaAQLeoMK3TjFFTKwKMIbPlhrn8FpZo2W
         5byRbpNF2yC7ozuHd6Q5I9iaVkqjUM4Ub7kk7X85I0Dr3/4R/21stYkCxDSe7kOx041s
         zm1g==
X-Gm-Message-State: AOAM533ezUp/YR19TTVo04joBCNoQr0e0Xlap6e46CBBkJ95ZY2kHfdK
        5aWkljY762Zw75Yp27N0M0YibGwLn7v/NT1RixbDtBjKOIey
X-Google-Smtp-Source: ABdhPJz3RzBbF1FCnxzoOC7m08w7ZLo2HEITQXqMjR7h0HRfqIozCff5Ihnq7kPNxfX3bb8mjmEGSqf9yFoUFd3020djEpMLtK/4
MIME-Version: 1.0
X-Received: by 2002:a02:c942:: with SMTP id u2mr20736844jao.114.1600246275242;
 Wed, 16 Sep 2020 01:51:15 -0700 (PDT)
Date:   Wed, 16 Sep 2020 01:51:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ca028b05af6a5e4c@google.com>
Subject: possible deadlock in xfrm_policy_lookup_inexact_addr
From:   syzbot <syzbot+0c9fc3836c6c057a975a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5fa35f24 Add linux-next specific files for 20200916
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14268701900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bdb7e39caf48f53
dashboard link: https://syzkaller.appspot.com/bug?extid=0c9fc3836c6c057a975a
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0c9fc3836c6c057a975a@syzkaller.appspotmail.com

=====================================================
WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
5.9.0-rc5-next-20200916-syzkaller #0 Not tainted
-----------------------------------------------------
kworker/1:4/8015 [HC0[0]:SC0[4]:HE0:SE0] is trying to acquire:
ffff8880962d8928 (&s->seqcount#12){+.+.}-{0:0}, at: xfrm_policy_lookup_inexact_addr+0x57/0x200 net/xfrm/xfrm_policy.c:1909

and this task is already holding:
ffff88808b9284d0 (&peer->endpoint_lock){++-.}-{2:2}, at: wg_socket_send_skb_to_peer+0x5e/0x220 drivers/net/wireguard/socket.c:172
which would create a new lock dependency:
 (&peer->endpoint_lock){++-.}-{2:2} -> (&s->seqcount#12){+.+.}-{0:0}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&peer->endpoint_lock){++-.}-{2:2}

... which became SOFTIRQ-irq-safe at:
  lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
  __raw_write_lock_bh include/linux/rwlock_api_smp.h:203 [inline]
  _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:319
  wg_socket_clear_peer_endpoint_src+0x1b/0xa0 drivers/net/wireguard/socket.c:309
  wg_expired_retransmit_handshake+0xbd/0x3a0 drivers/net/wireguard/timers.c:73
  call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1413
  expire_timers kernel/time/timer.c:1458 [inline]
  __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1755
  __run_timers kernel/time/timer.c:1736 [inline]
  run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
  __do_softirq+0x202/0xa42 kernel/softirq.c:298
  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
  do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
  invoke_softirq kernel/softirq.c:393 [inline]
  __irq_exit_rcu kernel/softirq.c:423 [inline]
  irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
  sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
  native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:60
  arch_safe_halt arch/x86/include/asm/paravirt.h:150 [inline]
  acpi_safe_halt+0x95/0x180 drivers/acpi/processor_idle.c:111
  acpi_idle_do_entry+0x15c/0x1b0 drivers/acpi/processor_idle.c:524
  acpi_idle_enter+0x403/0xac0 drivers/acpi/processor_idle.c:650
  cpuidle_enter_state+0x150/0xa70 drivers/cpuidle/cpuidle.c:243
  cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:355
  call_cpuidle kernel/sched/idle.c:132 [inline]
  cpuidle_idle_call kernel/sched/idle.c:213 [inline]
  do_idle+0x48e/0x730 kernel/sched/idle.c:273
  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:369
  secondary_startup_64_no_verify+0xa6/0xab

to a SOFTIRQ-irq-unsafe lock:
 (&s->seqcount#12){+.+.}-{0:0}

... which became SOFTIRQ-irq-unsafe at:
...
  lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
  write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
  write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
  write_seqlock include/linux/seqlock.h:883 [inline]
  xfrm_set_spdinfo+0x302/0x660 net/xfrm/xfrm_user.c:1185
  xfrm_user_rcv_msg+0x414/0x700 net/xfrm/xfrm_user.c:2684
  netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2692
  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
  sock_sendmsg_nosec net/socket.c:651 [inline]
  sock_sendmsg+0xcf/0x120 net/socket.c:671
  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2362
  ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2449
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&s->seqcount#12);
                               local_irq_disable();
                               lock(&peer->endpoint_lock);
                               lock(&s->seqcount#12);
  <Interrupt>
    lock(&peer->endpoint_lock);

 *** DEADLOCK ***

5 locks held by kworker/1:4/8015:
 #0: ffff88809423e538 ((wq_completion)wg-crypt-wg0#10){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88809423e538 ((wq_completion)wg-crypt-wg0#10){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88809423e538 ((wq_completion)wg-crypt-wg0#10){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88809423e538 ((wq_completion)wg-crypt-wg0#10){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88809423e538 ((wq_completion)wg-crypt-wg0#10){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88809423e538 ((wq_completion)wg-crypt-wg0#10){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2240
 #1: ffffc90015affda8 ((work_completion)(&queue->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2244
 #2: ffff88808b9284d0 (&peer->endpoint_lock){++-.}-{2:2}, at: wg_socket_send_skb_to_peer+0x5e/0x220 drivers/net/wireguard/socket.c:172
 #3: ffffffff89e71c60 (rcu_read_lock_bh){....}-{1:2}, at: send6+0x2ce/0xbc0 drivers/net/wireguard/socket.c:116
 #4: ffffffff89e71cc0 (rcu_read_lock){....}-{1:2}, at: xfrm_policy_lookup_bytype+0x104/0xa40 net/xfrm/xfrm_policy.c:2082

the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
-> (&peer->endpoint_lock){++-.}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                    __raw_write_lock_bh include/linux/rwlock_api_smp.h:203 [inline]
                    _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:319
                    wg_socket_set_peer_endpoint drivers/net/wireguard/socket.c:282 [inline]
                    wg_socket_set_peer_endpoint+0x37c/0xbd0 drivers/net/wireguard/socket.c:272
                    set_peer+0x965/0x1030 drivers/net/wireguard/netlink.c:447
                    wg_set_device+0xcab/0x1520 drivers/net/wireguard/netlink.c:589
                    genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
                    genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
                    genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
                    netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
                    genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
                    netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
                    netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
                    netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
                    sock_sendmsg_nosec net/socket.c:651 [inline]
                    sock_sendmsg+0xcf/0x120 net/socket.c:671
                    __sys_sendto+0x21c/0x320 net/socket.c:1992
                    __do_sys_sendto net/socket.c:2004 [inline]
                    __se_sys_sendto net/socket.c:2000 [inline]
                    __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2000
                    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                    entry_SYSCALL_64_after_hwframe+0x44/0xa9
   HARDIRQ-ON-R at:
                    lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                    __raw_read_lock_bh include/linux/rwlock_api_smp.h:176 [inline]
                    _raw_read_lock_bh+0x3b/0x70 kernel/locking/spinlock.c:247
                    wg_socket_send_skb_to_peer drivers/net/wireguard/socket.c:172 [inline]
                    wg_socket_send_buffer_to_peer+0x168/0x340 drivers/net/wireguard/socket.c:199
                    wg_packet_send_handshake_initiation+0x1fc/0x240 drivers/net/wireguard/send.c:40
                    wg_packet_handshake_send_worker+0x18/0x30 drivers/net/wireguard/send.c:51
                    process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
                    worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
                    kthread+0x3af/0x4a0 kernel/kthread.c:292
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
   IN-SOFTIRQ-W at:
                    lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                    __raw_write_lock_bh include/linux/rwlock_api_smp.h:203 [inline]
                    _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:319
                    wg_socket_clear_peer_endpoint_src+0x1b/0xa0 drivers/net/wireguard/socket.c:309
                    wg_expired_retransmit_handshake+0xbd/0x3a0 drivers/net/wireguard/timers.c:73
                    call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1413
                    expire_timers kernel/time/timer.c:1458 [inline]
                    __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1755
                    __run_timers kernel/time/timer.c:1736 [inline]
                    run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
                    __do_softirq+0x202/0xa42 kernel/softirq.c:298
                    asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
                    __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
                    run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
                    do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
                    invoke_softirq kernel/softirq.c:393 [inline]
                    __irq_exit_rcu kernel/softirq.c:423 [inline]
                    irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
                    sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
                    asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
                    native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:60
                    arch_safe_halt arch/x86/include/asm/paravirt.h:150 [inline]
                    acpi_safe_halt+0x95/0x180 drivers/acpi/processor_idle.c:111
                    acpi_idle_do_entry+0x15c/0x1b0 drivers/acpi/processor_idle.c:524
                    acpi_idle_enter+0x403/0xac0 drivers/acpi/processor_idle.c:650
                    cpuidle_enter_state+0x150/0xa70 drivers/cpuidle/cpuidle.c:243
                    cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:355
                    call_cpuidle kernel/sched/idle.c:132 [inline]
                    cpuidle_idle_call kernel/sched/idle.c:213 [inline]
                    do_idle+0x48e/0x730 kernel/sched/idle.c:273
                    cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:369
                    secondary_startup_64_no_verify+0xa6/0xab
   INITIAL USE at:
                   lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                   __raw_write_lock_bh include/linux/rwlock_api_smp.h:203 [inline]
                   _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:319
                   wg_socket_set_peer_endpoint drivers/net/wireguard/socket.c:282 [inline]
                   wg_socket_set_peer_endpoint+0x37c/0xbd0 drivers/net/wireguard/socket.c:272
                   set_peer+0x965/0x1030 drivers/net/wireguard/netlink.c:447
                   wg_set_device+0xcab/0x1520 drivers/net/wireguard/netlink.c:589
                   genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
                   genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
                   genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
                   netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
                   genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
                   netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
                   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
                   netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
                   sock_sendmsg_nosec net/socket.c:651 [inline]
                   sock_sendmsg+0xcf/0x120 net/socket.c:671
                   __sys_sendto+0x21c/0x320 net/socket.c:1992
                   __do_sys_sendto net/socket.c:2004 [inline]
                   __se_sys_sendto net/socket.c:2000 [inline]
                   __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2000
                   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                   entry_SYSCALL_64_after_hwframe+0x44/0xa9
   (null) at:
general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 PID: 8015 Comm: kworker/1:4 Not tainted 5.9.0-rc5-next-20200916-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-crypt-wg0 wg_packet_tx_worker
RIP: 0010:print_lock_trace kernel/locking/lockdep.c:1751 [inline]
RIP: 0010:print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
RIP: 0010:print_shortest_lock_dependencies.cold+0x110/0x2af kernel/locking/lockdep.c:2263
Code: 48 8b 04 24 48 c1 e8 03 42 80 3c 20 00 74 09 48 8b 3c 24 e8 c1 2b d9 f9 48 8b 04 24 48 8b 00 48 8d 78 14 48 89 fa 48 c1 ea 03 <42> 0f b6 0c 22 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85
RSP: 0018:ffffc90015aff288 EFLAGS: 00010003
RAX: 0000000000000001 RBX: ffffc90015aff3e0 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff815c26b7 RDI: 0000000000000015
RBP: ffffc90015aff3e0 R08: 0000000000000004 R09: ffff8880ae720f8b
R10: 0000000000000000 R11: 6c6c756e28202020 R12: dffffc0000000000
R13: ffffffff8ca101a8 R14: 0000000000000009 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000746918 CR3: 0000000096f43000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 print_bad_irq_dependency kernel/locking/lockdep.c:2395 [inline]
 check_irq_usage.cold+0x42d/0x5b0 kernel/locking/lockdep.c:2634
 check_prev_add kernel/locking/lockdep.c:2823 [inline]
 check_prevs_add kernel/locking/lockdep.c:2944 [inline]
 validate_chain kernel/locking/lockdep.c:3562 [inline]
 __lock_acquire+0x2800/0x55d0 kernel/locking/lockdep.c:4796
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
 seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
 xfrm_policy_lookup_inexact_addr+0x57/0x200 net/xfrm/xfrm_policy.c:1909
 xfrm_policy_find_inexact_candidates+0xac/0x1d0 net/xfrm/xfrm_policy.c:1953
 xfrm_policy_lookup_bytype+0x4b8/0xa40 net/xfrm/xfrm_policy.c:2108
 xfrm_policy_lookup net/xfrm/xfrm_policy.c:2144 [inline]
 xfrm_bundle_lookup net/xfrm/xfrm_policy.c:2944 [inline]
 xfrm_lookup_with_ifid+0xaa1/0x2100 net/xfrm/xfrm_policy.c:3085
 xfrm_lookup net/xfrm/xfrm_policy.c:3177 [inline]
 xfrm_lookup_route+0x36/0x1e0 net/xfrm/xfrm_policy.c:3188
 ip6_dst_lookup_flow+0x159/0x1d0 net/ipv6/ip6_output.c:1162
 send6+0x62f/0xbc0 drivers/net/wireguard/socket.c:139
 wg_socket_send_skb_to_peer+0xf5/0x220 drivers/net/wireguard/socket.c:177
 wg_packet_create_data_done drivers/net/wireguard/send.c:252 [inline]
 wg_packet_tx_worker+0x2f9/0x980 drivers/net/wireguard/send.c:280
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Modules linked in:
---[ end trace 8a68a086c40da004 ]---
RIP: 0010:print_lock_trace kernel/locking/lockdep.c:1751 [inline]
RIP: 0010:print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
RIP: 0010:print_shortest_lock_dependencies.cold+0x110/0x2af kernel/locking/lockdep.c:2263
Code: 48 8b 04 24 48 c1 e8 03 42 80 3c 20 00 74 09 48 8b 3c 24 e8 c1 2b d9 f9 48 8b 04 24 48 8b 00 48 8d 78 14 48 89 fa 48 c1 ea 03 <42> 0f b6 0c 22 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85
RSP: 0018:ffffc90015aff288 EFLAGS: 00010003
RAX: 0000000000000001 RBX: ffffc90015aff3e0 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff815c26b7 RDI: 0000000000000015
RBP: ffffc90015aff3e0 R08: 0000000000000004 R09: ffff8880ae720f8b
R10: 0000000000000000 R11: 6c6c756e28202020 R12: dffffc0000000000
R13: ffffffff8ca101a8 R14: 0000000000000009 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000746918 CR3: 0000000096f43000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
