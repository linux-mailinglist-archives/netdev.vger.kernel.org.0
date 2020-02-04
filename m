Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379EB1513B0
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 01:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgBDAiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 19:38:13 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:33589 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgBDAiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 19:38:12 -0500
Received: by mail-io1-f69.google.com with SMTP id i8so10619417ioi.0
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 16:38:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8lBfRE5DzjrWOh7AtAjbKlIa2fCtISUtqCR+PeGHF7g=;
        b=Jv25b53spI4gTgZrLFj38sdxAFmMw9rCqwBiMpoH+mnRzqRNwcCbEoGOE848QtZXIi
         KllYbGGCyeJ+4IUHwDCJuBnJ0vTWGzs7uRxenw1V8QbYsni9v9wW4suWP9tSXonV6LVB
         uGrVKhY0OW0caNaGZCDV3kcPUbVO2mSqGFKoJnr9uG7cTaAkP/qmt3SUhzGmGjQ00ndq
         tO/9IJ/gMwWqU5Lfbh76ni8GQkIxtWUDZ1YBhT06fZTqRT+Tgw5zaUlL+t8iisu4X+CY
         XQB67jgS2KpJMuVL17EylFImeIAQFtFdQpLDkXHZOPgh093f8VU/4TxNOdKHcMdMaz4v
         T5vA==
X-Gm-Message-State: APjAAAWOLC+NXp14zGM0JMDDfaJgFXafYI0IWj064oVkyA1E2zOESqxg
        kDKYZAt94zODDuby/dJaRTrjs2bd1sPV38yo9nCJA6y7FuXO
X-Google-Smtp-Source: APXvYqzkyVy8V1zeVu37zAoYgu01IEACWIyNDYI7t0e0/UjNWAR9uOtxzs6ybRYhX8bxiVzUhBIRL2vkvexpPBIEpe6vZkSodF6K
MIME-Version: 1.0
X-Received: by 2002:a92:884e:: with SMTP id h75mr24756337ild.199.1580776692186;
 Mon, 03 Feb 2020 16:38:12 -0800 (PST)
Date:   Mon, 03 Feb 2020 16:38:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000350337059db54167@google.com>
Subject: inconsistent lock state in rxrpc_put_client_conn
From:   syzbot <syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3d80c653 Merge tag 'rxrpc-fixes-20200203' of git://git.ker..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16a38595e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95b275782b150c86
dashboard link: https://syzkaller.appspot.com/bug?extid=3f1fd6b8cbf8702d134e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ac314ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ec4c5ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.5.0-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/1/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff88808e8fa1c8 (&(&local->client_conns_lock)->rlock){+.?.}, at: spin_lock include/linux/spinlock.h:338 [inline]
ffff88808e8fa1c8 (&(&local->client_conns_lock)->rlock){+.?.}, at: rxrpc_put_one_client_conn net/rxrpc/conn_client.c:948 [inline]
ffff88808e8fa1c8 (&(&local->client_conns_lock)->rlock){+.?.}, at: rxrpc_put_client_conn+0x6ed/0xc90 net/rxrpc/conn_client.c:1001
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  rxrpc_get_client_conn net/rxrpc/conn_client.c:304 [inline]
  rxrpc_connect_call+0x358/0x4e30 net/rxrpc/conn_client.c:701
  rxrpc_new_client_call+0x9c0/0x1ad0 net/rxrpc/call_object.c:290
  rxrpc_new_client_call_for_sendmsg net/rxrpc/sendmsg.c:595 [inline]
  rxrpc_do_sendmsg+0xffa/0x1d5f net/rxrpc/sendmsg.c:652
  rxrpc_sendmsg+0x4d6/0x5f0 net/rxrpc/af_rxrpc.c:586
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:672
  ____sys_sendmsg+0x358/0x880 net/socket.c:2343
  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2487
  __do_sys_sendmmsg net/socket.c:2516 [inline]
  __se_sys_sendmmsg net/socket.c:2513 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2513
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
irq event stamp: 130510
hardirqs last  enabled at (130510): [<ffffffff87e8d446>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (130510): [<ffffffff87e8d446>] _raw_spin_unlock_irqrestore+0x66/0xe0 kernel/locking/spinlock.c:191
hardirqs last disabled at (130509): [<ffffffff87e8d7bf>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (130509): [<ffffffff87e8d7bf>] _raw_spin_lock_irqsave+0x6f/0xcd kernel/locking/spinlock.c:159
softirqs last  enabled at (130494): [<ffffffff8147535c>] _local_bh_enable+0x1c/0x30 kernel/softirq.c:162
softirqs last disabled at (130495): [<ffffffff81477d5b>] invoke_softirq kernel/softirq.c:373 [inline]
softirqs last disabled at (130495): [<ffffffff81477d5b>] irq_exit+0x19b/0x1e0 kernel/softirq.c:413

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&local->client_conns_lock)->rlock);
  <Interrupt>
    lock(&(&local->client_conns_lock)->rlock);

 *** DEADLOCK ***

1 lock held by swapper/1/0:
 #0: ffffffff89babe80 (rcu_callback){....}, at: rcu_do_batch kernel/rcu/tree.c:2176 [inline]
 #0: ffffffff89babe80 (rcu_callback){....}, at: rcu_core+0x562/0x1390 kernel/rcu/tree.c:2410

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_usage_bug.cold+0x327/0x378 kernel/locking/lockdep.c:3100
 valid_state kernel/locking/lockdep.c:3111 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3308 [inline]
 mark_lock+0xbb4/0x1220 kernel/locking/lockdep.c:3665
 mark_usage kernel/locking/lockdep.c:3565 [inline]
 __lock_acquire+0x1e8e/0x4a00 kernel/locking/lockdep.c:3908
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 rxrpc_put_one_client_conn net/rxrpc/conn_client.c:948 [inline]
 rxrpc_put_client_conn+0x6ed/0xc90 net/rxrpc/conn_client.c:1001
 rxrpc_put_connection net/rxrpc/ar-internal.h:965 [inline]
 rxrpc_rcu_destroy_call+0xbd/0x200 net/rxrpc/call_object.c:572
 rcu_do_batch kernel/rcu/tree.c:2186 [inline]
 rcu_core+0x5e1/0x1390 kernel/rcu/tree.c:2410
 rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2419
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: b8 43 cb f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 24 bf 5f 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 14 bf 5f 00 fb f4 <c3> cc 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 4e 19 7a f9 e8 e9
RSP: 0018:ffffc90000d3fd68 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff13675b2 RBX: ffff8880a99fc340 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffff8880a99fcbd4
RBP: ffffc90000d3fd98 R08: ffff8880a99fc340 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff8aa3e080 R14: 0000000000000000 R15: 0000000000000001
 arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:686
 default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
