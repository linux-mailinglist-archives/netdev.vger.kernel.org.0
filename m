Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A0712BA36
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfL0SRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728227AbfL0SQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:16:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D21D02173E;
        Fri, 27 Dec 2019 18:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470564;
        bh=Pd7giwswZBOFusMt3mc3xVpe5NPJN7jLjBKPe19rk/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eftwX/T4ZhDcbBUZ3i4TCBAqrycX5JvMN9OFRDm9Zu7O2vgE6V253gLShcGdhrkmC
         MJNT7pjJQ8CT/aHJd8L4S4NE59XDcNsghM+Jjuu0WCIXJ7Eio9t/ciE9WjRkv64oM0
         Id9z83UU8DCjS0TYdhiFf/8pihF8QW0ILNTnAM2s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/25] 6pack,mkiss: fix possible deadlock
Date:   Fri, 27 Dec 2019 13:15:36 -0500
Message-Id: <20191227181549.8040-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181549.8040-1-sashal@kernel.org>
References: <20191227181549.8040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5c9934b6767b16ba60be22ec3cbd4379ad64170d ]

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
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 4 ++--
 drivers/net/hamradio/mkiss.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 5a1e98547031..732c68ed166a 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -669,10 +669,10 @@ static void sixpack_close(struct tty_struct *tty)
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
index 0758d0816840..470d416f2b86 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -783,10 +783,10 @@ static void mkiss_close(struct tty_struct *tty)
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
2.20.1

