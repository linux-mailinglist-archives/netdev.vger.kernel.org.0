Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9E11D59A
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbfLLScT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:32:19 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:51351 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbfLLScS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:32:18 -0500
Received: by mail-pg1-f201.google.com with SMTP id g20so1898446pgb.18
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aM3ymlZifwR3a9f8GuFO4yogWDQKC7L5vJ7yxlqVfJw=;
        b=CCCaP0J5euaLtD7nElNO/bLuSCaRFOC0v62IGIx5qyrZ5+XBLdwZP5wsajuZWXpYBb
         7FZQd9Go/0UTQLNGnTWRV6idWLha0GEx4FPKOdzaheIL1PD658+bEOcYDQN++9r8gArn
         DTXsZqGl7QY/GYzlUGQJiaJVmdle4AVJ6b45DY/5WwIvGj9RzF+fozgPIOzm22XoD6/O
         OefmUfgzibYvmtsR9x/3ALqO9VVjPuO7aUOPnyPj1gkuwrBXV/uPyMlv47whKQ0S6q1k
         btuWHIhqEGH/bxmSrOBOZoZRLt2Ox5hlgVmnhGaziYxO1QGGqxl6idRqFqeqLCZO5dxg
         Btuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aM3ymlZifwR3a9f8GuFO4yogWDQKC7L5vJ7yxlqVfJw=;
        b=aB2ruJ8HVLgRNrZPfzJbwlM2HF3qXCDyX6Jh/kSYbj3CVQI48yPTptsGvyO2mnTN5N
         leTmFVs+xoIIAZ/Kk7zQzkSZPBqlgPGUezTzP15ZAwsp//CmJ5Wza8HWGnTTNem7B/Vs
         +RPiEm2tVLo3FO/43u8480jC4Lo1Z0SbyYkMcosj9unuLx77GPrbmNNL8mmyqto+ZYMg
         Fq7/DTdR6Ja71RSCAOgiAt6DAGmXIuQXJlTJspCIPyWVsjKJe0RhjEq2nNDR9UX/ssuz
         5sZ1egBP4+X11SoLn4alS/YwAEq4HUq2+s6lu1exgSvChFdmvDutXnzBuPDx7Xch0h5M
         Jwvw==
X-Gm-Message-State: APjAAAXnmaPY46fU6xtXd3mY/kK1KomEPQ2A3F82EXPppNyaCwlm/UYt
        zj1+flGKUWrRqkyM2cDDRA1zPfbtZsW4OA==
X-Google-Smtp-Source: APXvYqxZNhBElYRHNM355wDIHOfBY9XDc7OiuPHQIga8DNU9Juof9+y/GxACl6WsZisLv9HXHe0SzlYXbG3ZUg==
X-Received: by 2002:a63:5920:: with SMTP id n32mr11901100pgb.443.1576175537627;
 Thu, 12 Dec 2019 10:32:17 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:32:13 -0800
Message-Id: <20191212183213.11396-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] 6pack,mkiss: fix possible deadlock
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We got another syzbot report [1] that tells us we must use
write_lock_irq()/write_unlock_irq() to avoid possible deadlock.

[1]

WARNING: inconsistent lock state
5.5.0-rc1-syzkaller #0 Not tainted
--------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-R} usage.
syz-executor826/9605 [HC1[1]:SC0[0]:HE0:SE1] takes:
ffffffff8a128718 (disc_data_lock){+-..}, at: sp_get.isra.0+0x1d/0xf0 drivers/net/ppp/ppp_synctty.c:138
{HARDIRQ-ON-W} state was registered at:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_write_lock_bh include/linux/rwlock_api_smp.h:203 [inline]
  _raw_write_lock_bh+0x33/0x50 kernel/locking/spinlock.c:319
  sixpack_close+0x1d/0x250 drivers/net/hamradio/6pack.c:657
  tty_ldisc_close.isra.0+0x119/0x1a0 drivers/tty/tty_ldisc.c:489
  tty_set_ldisc+0x230/0x6b0 drivers/tty/tty_ldisc.c:585
  tiocsetd drivers/tty/tty_io.c:2337 [inline]
  tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2597
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:545 [inline]
  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
  __do_sys_ioctl fs/ioctl.c:756 [inline]
  __se_sys_ioctl fs/ioctl.c:754 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
irq event stamp: 3946
hardirqs last  enabled at (3945): [<ffffffff87c86e43>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
hardirqs last  enabled at (3945): [<ffffffff87c86e43>] _raw_spin_unlock_irq+0x23/0x80 kernel/locking/spinlock.c:199
hardirqs last disabled at (3946): [<ffffffff8100675f>] trace_hardirqs_off_thunk+0x1a/0x1c arch/x86/entry/thunk_64.S:42
softirqs last  enabled at (2658): [<ffffffff86a8b4df>] spin_unlock_bh include/linux/spinlock.h:383 [inline]
softirqs last  enabled at (2658): [<ffffffff86a8b4df>] clusterip_netdev_event+0x46f/0x670 net/ipv4/netfilter/ipt_CLUSTERIP.c:222
softirqs last disabled at (2656): [<ffffffff86a8b22b>] spin_lock_bh include/linux/spinlock.h:343 [inline]
softirqs last disabled at (2656): [<ffffffff86a8b22b>] clusterip_netdev_event+0x1bb/0x670 net/ipv4/netfilter/ipt_CLUSTERIP.c:196

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(disc_data_lock);
  <Interrupt>
    lock(disc_data_lock);

 *** DEADLOCK ***

5 locks held by syz-executor826/9605:
 #0: ffff8880a905e198 (&tty->legacy_mutex){+.+.}, at: tty_lock+0xc7/0x130 drivers/tty/tty_mutex.c:19
 #1: ffffffff899a56c0 (rcu_read_lock){....}, at: mutex_spin_on_owner+0x0/0x330 kernel/locking/mutex.c:413
 #2: ffff8880a496a2b0 (&(&i->lock)->rlock){-.-.}, at: spin_lock include/linux/spinlock.h:338 [inline]
 #2: ffff8880a496a2b0 (&(&i->lock)->rlock){-.-.}, at: serial8250_interrupt+0x2d/0x1a0 drivers/tty/serial/8250/8250_core.c:116
 #3: ffffffff8c104048 (&port_lock_key){-.-.}, at: serial8250_handle_irq.part.0+0x24/0x330 drivers/tty/serial/8250/8250_port.c:1823
 #4: ffff8880a905e090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref+0x22/0x90 drivers/tty/tty_ldisc.c:288

stack backtrace:
CPU: 1 PID: 9605 Comm: syz-executor826 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_usage_bug.cold+0x327/0x378 kernel/locking/lockdep.c:3101
 valid_state kernel/locking/lockdep.c:3112 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3309 [inline]
 mark_lock+0xbb4/0x1220 kernel/locking/lockdep.c:3666
 mark_usage kernel/locking/lockdep.c:3554 [inline]
 __lock_acquire+0x1e55/0x4a00 kernel/locking/lockdep.c:3909
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
 __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
 _raw_read_lock+0x32/0x50 kernel/locking/spinlock.c:223
 sp_get.isra.0+0x1d/0xf0 drivers/net/ppp/ppp_synctty.c:138
 sixpack_write_wakeup+0x25/0x340 drivers/net/hamradio/6pack.c:402
 tty_wakeup+0xe9/0x120 drivers/tty/tty_io.c:536
 tty_port_default_wakeup+0x2b/0x40 drivers/tty/tty_port.c:50
 tty_port_tty_wakeup+0x57/0x70 drivers/tty/tty_port.c:387
 uart_write_wakeup+0x46/0x70 drivers/tty/serial/serial_core.c:104
 serial8250_tx_chars+0x495/0xaf0 drivers/tty/serial/8250/8250_port.c:1761
 serial8250_handle_irq.part.0+0x2a2/0x330 drivers/tty/serial/8250/8250_port.c:1834
 serial8250_handle_irq drivers/tty/serial/8250/8250_port.c:1820 [inline]
 serial8250_default_handle_irq+0xc0/0x150 drivers/tty/serial/8250/8250_port.c:1850
 serial8250_interrupt+0xf1/0x1a0 drivers/tty/serial/8250/8250_core.c:126
 __handle_irq_event_percpu+0x15d/0x970 kernel/irq/handle.c:149
 handle_irq_event_percpu+0x74/0x160 kernel/irq/handle.c:189
 handle_irq_event+0xa7/0x134 kernel/irq/handle.c:206
 handle_edge_irq+0x25e/0x8d0 kernel/irq/chip.c:830
 generic_handle_irq_desc include/linux/irqdesc.h:156 [inline]
 do_IRQ+0xde/0x280 arch/x86/kernel/irq.c:250
 common_interrupt+0xf/0xf arch/x86/entry/entry_64.S:607
 </IRQ>
RIP: 0010:cpu_relax arch/x86/include/asm/processor.h:685 [inline]
RIP: 0010:mutex_spin_on_owner+0x247/0x330 kernel/locking/mutex.c:579
Code: c3 be 08 00 00 00 4c 89 e7 e8 e5 06 59 00 4c 89 e0 48 c1 e8 03 42 80 3c 38 00 0f 85 e1 00 00 00 49 8b 04 24 a8 01 75 96 f3 90 <e9> 2f fe ff ff 0f 0b e8 0d 19 09 00 84 c0 0f 85 ff fd ff ff 48 c7
RSP: 0018:ffffc90001eafa20 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffd7
RAX: 0000000000000000 RBX: ffff88809fd9e0c0 RCX: 1ffffffff13266dd
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
RBP: ffffc90001eafa60 R08: 1ffff11013d22898 R09: ffffed1013d22899
R10: ffffed1013d22898 R11: ffff88809e9144c7 R12: ffff8880a905e138
R13: ffff88809e9144c0 R14: 0000000000000000 R15: dffffc0000000000
 mutex_optimistic_spin kernel/locking/mutex.c:673 [inline]
 __mutex_lock_common kernel/locking/mutex.c:962 [inline]
 __mutex_lock+0x32b/0x13c0 kernel/locking/mutex.c:1106
 mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1121
 tty_lock+0xc7/0x130 drivers/tty/tty_mutex.c:19
 tty_release+0xb5/0xe90 drivers/tty/tty_io.c:1665
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0x8e7/0x2ef0 kernel/exit.c:797
 do_group_exit+0x135/0x360 kernel/exit.c:895
 __do_sys_exit_group kernel/exit.c:906 [inline]
 __se_sys_exit_group kernel/exit.c:904 [inline]
 __x64_sys_exit_group+0x44/0x50 kernel/exit.c:904
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43fef8
Code: Bad RIP value.
RSP: 002b:00007ffdb07d2338 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043fef8
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004bf730 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000

Fixes: 6e4e2f811bad ("6pack,mkiss: fix lock inconsistency")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/hamradio/6pack.c | 4 ++--
 drivers/net/hamradio/mkiss.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 23281aeeb2226ee4dc9d7655aebc247c94c94def..71d6629e65c970e7e133cfa615aa01341a68d43f 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -654,10 +654,10 @@ static void sixpack_close(struct tty_struct *tty)
 {
 	struct sixpack *sp;
 
-	write_lock_bh(&disc_data_lock);
+	write_lock_irq(&disc_data_lock);
 	sp = tty->disc_data;
 	tty->disc_data = NULL;
-	write_unlock_bh(&disc_data_lock);
+	write_unlock_irq(&disc_data_lock);
 	if (!sp)
 		return;
 
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index c5bfa19ddb932f2369b1a933f34c61a17b00b1b9..deef14215110494783720b94908b432537ee664a 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -773,10 +773,10 @@ static void mkiss_close(struct tty_struct *tty)
 {
 	struct mkiss *ax;
 
-	write_lock_bh(&disc_data_lock);
+	write_lock_irq(&disc_data_lock);
 	ax = tty->disc_data;
 	tty->disc_data = NULL;
-	write_unlock_bh(&disc_data_lock);
+	write_unlock_irq(&disc_data_lock);
 
 	if (!ax)
 		return;
-- 
2.24.1.735.g03f4e72817-goog

