Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8E247290
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFOXk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:40:57 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:34743 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfFOXk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:40:57 -0400
Received: by mail-qt1-f201.google.com with SMTP id p34so5770963qtp.1
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 16:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mcPP9X0QiWlF7GplY3izZlSJgOg6V70Xq/Tk5xaoY94=;
        b=bT1Ena+yyg8qmF4pBNNphlEtlsVYaMETxXrjcqC83f4KAnoyAIVSKok01F9/Whn1zx
         0Ac6KRIL4RyzS3S4ZhZVB2+HrVh6mNBiSIln5ERguJRsf8iodxuMWXLhPvEGrcBrLct6
         LT5nSt1eDvE2jTHKQ9NE3cAJgQsJDLtrVB37vrc8mmOLTgB6BPypvjaQBGTLENA7F75j
         Mcb9IpmINMgGmIA6TpPgRDan0iPTDHC/imvpNe2p1PZYYwpqXslNF4f2o+FN53WvEru9
         8lFAv846TJ6JQ+UYJEY3VHbiF9iE69Lv9oxV/oc2koyooseT+rq1TYG+kK5iqzqam05E
         Jl1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mcPP9X0QiWlF7GplY3izZlSJgOg6V70Xq/Tk5xaoY94=;
        b=RRgcqkHib7kMZwqpaypOdmnUQu75pjiXO1Y3f+dfKyF/5RRAPfqxUaghEUbHuQcuNE
         Hpq65w74u4oGYuuj/VjGpAEwjqJS//99+jk2XiWm5MAGAtKjcIJghPT0JydTzHqoNci+
         Z4ZimN2qkzmkdn/5PvwMTYwpVvw0FjTNMITitsJCni0wQ32ZWswm4K9kH+erQoKLmXhN
         t4dHquGuiWZRI6hPKn6dHfFPon0Phg7PR4wPtGRrFP/LLLtCPWu6lIgsbMoPtpD4p5fL
         AMWUs2Wlky0y1s8U8DoSiClCoi7tWf3WzPZcprqJ7FBpcigk11EFkLJ2wLbtwtoBIRzh
         WWcQ==
X-Gm-Message-State: APjAAAUMbX2c6VVl9NZZC0Q/kPvMZswE3Vk3D6FHDqwduUqAh/JsCE39
        hZANGNgQTguexbGSvysKmUSP4NjhA9Rutw==
X-Google-Smtp-Source: APXvYqzKbtKby6BoADt+LI+3VLl5hUy4HJRtA90kbNC5v9Gzcf7XlMkRZtGyAWjzLeGbeXbW4acnN85yDjt3JA==
X-Received: by 2002:ac8:38a8:: with SMTP id f37mr87191125qtc.150.1560642055634;
 Sat, 15 Jun 2019 16:40:55 -0700 (PDT)
Date:   Sat, 15 Jun 2019 16:40:52 -0700
Message-Id: <20190615234052.155231-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] ax25: fix inconsistent lock state in ax25_destroy_timer
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before thread in process context uses bh_lock_sock()
we must disable bh.

sysbot reported :

WARNING: inconsistent lock state
5.2.0-rc3+ #32 Not tainted

inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
blkid/26581 [HC0[0]:SC1[1]:HE1:SE0] takes:
00000000e0da85ee (slock-AF_AX25){+.?.}, at: spin_lock include/linux/spinlock.h:338 [inline]
00000000e0da85ee (slock-AF_AX25){+.?.}, at: ax25_destroy_timer+0x53/0xc0 net/ax25/af_ax25.c:275
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  ax25_rt_autobind+0x3ca/0x720 net/ax25/ax25_route.c:429
  ax25_connect.cold+0x30/0xa4 net/ax25/af_ax25.c:1221
  __sys_connect+0x264/0x330 net/socket.c:1834
  __do_sys_connect net/socket.c:1845 [inline]
  __se_sys_connect net/socket.c:1842 [inline]
  __x64_sys_connect+0x73/0xb0 net/socket.c:1842
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
irq event stamp: 2272
hardirqs last  enabled at (2272): [<ffffffff810065f3>] trace_hardirqs_on_thunk+0x1a/0x1c
hardirqs last disabled at (2271): [<ffffffff8100660f>] trace_hardirqs_off_thunk+0x1a/0x1c
softirqs last  enabled at (1522): [<ffffffff87400654>] __do_softirq+0x654/0x94c kernel/softirq.c:320
softirqs last disabled at (2267): [<ffffffff81449010>] invoke_softirq kernel/softirq.c:374 [inline]
softirqs last disabled at (2267): [<ffffffff81449010>] irq_exit+0x180/0x1d0 kernel/softirq.c:414

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(slock-AF_AX25);
  <Interrupt>
    lock(slock-AF_AX25);

 *** DEADLOCK ***

1 lock held by blkid/26581:
 #0: 0000000010fd154d ((&ax25->dtimer)){+.-.}, at: lockdep_copy_map include/linux/lockdep.h:175 [inline]
 #0: 0000000010fd154d ((&ax25->dtimer)){+.-.}, at: call_timer_fn+0xe0/0x720 kernel/time/timer.c:1312

stack backtrace:
CPU: 1 PID: 26581 Comm: blkid Not tainted 5.2.0-rc3+ #32
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_usage_bug.cold+0x393/0x4a2 kernel/locking/lockdep.c:2935
 valid_state kernel/locking/lockdep.c:2948 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3138 [inline]
 mark_lock+0xd46/0x1370 kernel/locking/lockdep.c:3513
 mark_irqflags kernel/locking/lockdep.c:3391 [inline]
 __lock_acquire+0x159f/0x5490 kernel/locking/lockdep.c:3745
 lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 ax25_destroy_timer+0x53/0xc0 net/ax25/af_ax25.c:275
 call_timer_fn+0x193/0x720 kernel/time/timer.c:1322
 expire_timers kernel/time/timer.c:1366 [inline]
 __run_timers kernel/time/timer.c:1685 [inline]
 __run_timers kernel/time/timer.c:1653 [inline]
 run_timer_softirq+0x66f/0x1740 kernel/time/timer.c:1698
 __do_softirq+0x25c/0x94c kernel/softirq.c:293
 invoke_softirq kernel/softirq.c:374 [inline]
 irq_exit+0x180/0x1d0 kernel/softirq.c:414
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x13b/0x550 arch/x86/kernel/apic/apic.c:1068
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
 </IRQ>
RIP: 0033:0x7f858d5c3232
Code: 8b 61 08 48 8b 84 24 d8 00 00 00 4c 89 44 24 28 48 8b ac 24 d0 00 00 00 4c 8b b4 24 e8 00 00 00 48 89 7c 24 68 48 89 4c 24 78 <48> 89 44 24 58 8b 84 24 e0 00 00 00 89 84 24 84 00 00 00 8b 84 24
RSP: 002b:00007ffcaf0cf5c0 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
RAX: 00007f858d7d27a8 RBX: 00007f858d7d8820 RCX: 00007f858d3940d8
RDX: 00007ffcaf0cf798 RSI: 00000000f5e616f3 RDI: 00007f858d394fee
RBP: 0000000000000000 R08: 00007ffcaf0cf780 R09: 00007f858d7db480
R10: 0000000000000000 R11: 0000000009691a75 R12: 0000000000000005
R13: 00000000f5e616f3 R14: 0000000000000000 R15: 00007ffcaf0cf798

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ax25/ax25_route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 09fdd0aac4b907b926b3ecc70d3cdde207b73b12..b40e0bce67ead7d1dd36f435aa51bb9c53fa0e19 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -426,9 +426,11 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25_address *addr)
 	}
 
 	if (ax25->sk != NULL) {
+		local_bh_disable();
 		bh_lock_sock(ax25->sk);
 		sock_reset_flag(ax25->sk, SOCK_ZAPPED);
 		bh_unlock_sock(ax25->sk);
+		local_bh_enable();
 	}
 
 put:
-- 
2.22.0.410.gd8fdbe21b5-goog

