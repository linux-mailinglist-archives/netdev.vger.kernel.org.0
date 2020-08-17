Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64D24760B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404181AbgHQTcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:32:39 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:34904 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbgHQPb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 11:31:27 -0400
Received: by mail-il1-f199.google.com with SMTP id g6so12219653iln.2
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 08:31:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W7K7lW55Dn94R20eYYTCzBxa9B+ssGzLwKDqHmECJpA=;
        b=XfHagWTPN9+mR0BUPMYapYoqQijEyXoJlaZWgW455yOUgHgqQtwR87NcS9ULM0ejA8
         WzPTkHe9GDyACrUmazvtmljpxkA2L4Etb9FZPvJ8cVAvnFa+3Kt3DXCxjhFJ56IgoVeP
         oxsf5EafV5IiT+DOKr0RUv3U+yLVoAdW361U/I3/KGfl2nzE3lh/Ih2k8mQUkKuJxDqm
         dgbOFUfSmeHqyK+4muKReXuJLj28J3LJhlMIvmgzGG284Fh4MQv5UXohpmqIEQDv+NjK
         1fdF0+oup89wT88tUmc5CjCAveYfNQBcFveibsYBQVPoAez2oLo17/Ysjtqh9uDFqzHT
         7jvw==
X-Gm-Message-State: AOAM532sawW5ipj7hav8F+kJ3uvwXCLIqCcvx5gY+W1T3AUPTPi9JUD2
        XDY8rpINQyoYSSwqLbE0CKsRg0C1Z1d3Mb6O5dTgSPYKgvXU
X-Google-Smtp-Source: ABdhPJwYKxGHy0MLF+yiMDC0FLZLpIMQg10/YFZtRi/BhjGZeROGoSHU7CDMfq2pXT/HGoE9GTN7fsDoqqAxcyEImusSusSEAMtS
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29c3:: with SMTP id z3mr12649177ioq.126.1597678286698;
 Mon, 17 Aug 2020 08:31:26 -0700 (PDT)
Date:   Mon, 17 Aug 2020 08:31:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000be7fb805ad147615@google.com>
Subject: inconsistent lock state in sco_sock_timeout
From:   syzbot <syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com>
To:     a@unstable.cc, andrew@lunn.ch, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2cc3c4b3 Merge tag 'io_uring-5.9-2020-08-15' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10cf6aa6900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=19f02fc5c511a391
dashboard link: https://syzkaller.appspot.com/bug?extid=2f6d7c28bb4bf7e82060
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13071491900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ec5be2900000

The issue was bisected to:

commit 331c56ac73846fa267c04ee6aa9a00bb5fed9440
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Mon Aug 12 21:51:27 2019 +0000

    net: phy: add phy_speed_down_core and phy_resolve_min_speed

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1623bea6900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1523bea6900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1123bea6900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Fixes: 331c56ac7384 ("net: phy: add phy_speed_down_core and phy_resolve_min_speed")

================================
WARNING: inconsistent lock state
5.8.0-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/1/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff888088b810a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff888088b810a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at: sco_sock_timeout+0x2b/0x280 net/bluetooth/sco.c:83
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  sco_conn_del+0x100/0x710 net/bluetooth/sco.c:176
  hci_disconn_cfm include/net/bluetooth/hci_core.h:1438 [inline]
  hci_conn_hash_flush+0x127/0x200 net/bluetooth/hci_conn.c:1557
  hci_dev_do_close+0xb7b/0x1040 net/bluetooth/hci_core.c:1770
  hci_unregister_dev+0x185/0x1590 net/bluetooth/hci_core.c:3790
  vhci_release+0x73/0xc0 drivers/bluetooth/hci_vhci.c:340
  __fput+0x34f/0x7b0 fs/file_table.c:281
  task_work_run+0x137/0x1c0 kernel/task_work.c:141
  exit_task_work include/linux/task_work.h:25 [inline]
  do_exit+0x5f3/0x1f20 kernel/exit.c:806
  do_group_exit+0x161/0x2d0 kernel/exit.c:903
  get_signal+0x13bb/0x1d50 kernel/signal.c:2757
  arch_do_signal+0x33/0x610 arch/x86/kernel/signal.c:811
  exit_to_user_mode_loop kernel/entry/common.c:135 [inline]
  exit_to_user_mode_prepare+0x8d/0x1b0 kernel/entry/common.c:166
  syscall_exit_to_user_mode+0x5e/0x1a0 kernel/entry/common.c:241
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
irq event stamp: 1760434
hardirqs last  enabled at (1760434): [<ffffffff882bbc5f>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
hardirqs last  enabled at (1760434): [<ffffffff882bbc5f>] _raw_spin_unlock_irq+0x1f/0x80 kernel/locking/spinlock.c:199
hardirqs last disabled at (1760433): [<ffffffff882bbab1>] __raw_spin_lock_irq include/linux/spinlock_api_smp.h:126 [inline]
hardirqs last disabled at (1760433): [<ffffffff882bbab1>] _raw_spin_lock_irq+0x41/0x80 kernel/locking/spinlock.c:167
softirqs last  enabled at (1760422): [<ffffffff88292264>] sysvec_apic_timer_interrupt+0x14/0xf0 arch/x86/kernel/apic/apic.c:1091
softirqs last disabled at (1760423): [<ffffffff88400f2f>] asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

1 lock held by swapper/1/0:
 #0: ffffc90000da8dc0 ((&sk->sk_timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:45 [inline]
 #0: ffffc90000da8dc0 ((&sk->sk_timer)){+.-.}-{0:0}, at: call_timer_fn+0x57/0x160 kernel/time/timer.c:1403

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_usage_bug+0x1117/0x11d0 kernel/locking/lockdep.c:3350
 mark_lock_irq arch/x86/include/asm/paravirt.h:661 [inline]
 mark_lock+0x10e2/0x1b00 kernel/locking/lockdep.c:4006
 mark_usage kernel/locking/lockdep.c:3905 [inline]
 __lock_acquire+0xa99/0x2ab0 kernel/locking/lockdep.c:4380
 lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 sco_sock_timeout+0x2b/0x280 net/bluetooth/sco.c:83
 call_timer_fn+0x91/0x160 kernel/time/timer.c:1413
 expire_timers kernel/time/timer.c:1458 [inline]
 __run_timers+0x65e/0x830 kernel/time/timer.c:1755
 run_timer_softirq+0x46/0x80 kernel/time/timer.c:1768
 __do_softirq+0x236/0x66c kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x91/0xe0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu+0x1e1/0x1f0 kernel/softirq.c:423
 irq_exit_rcu+0x5/0x10 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0xd5/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:tick_nohz_idle_exit+0x2f2/0x3a0 kernel/time/tick-sched.c:1213
Code: 30 00 74 0c 48 c7 c7 08 15 4d 89 e8 f8 0b 4c 00 48 83 3d 48 52 e4 07 00 0f 84 a6 00 00 00 e8 95 37 0c 00 fb 66 0f 1f 44 00 00 <48> 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 7a 37 0c 00 0f 0b
RSP: 0018:ffffc90000d3fe68 EFLAGS: 00000293
RAX: ffffffff8168c2cb RBX: ffff8880ae927f80 RCX: ffff8880a9a3e340
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8168c29a
RBP: 000000b26607d004 R08: ffffffff817abce0 R09: ffffed1015d26c6c
R10: ffffed1015d26c6c R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880ae927f54 R14: dffffc0000000000 R15: 1ffff11015d24fea
 do_idle+0x5fe/0x650 kernel/sched/idle.c:289
 cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:372
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
