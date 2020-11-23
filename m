Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1FF2C02B4
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgKWJzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:55:20 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:44364 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgKWJzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 04:55:19 -0500
Received: by mail-io1-f72.google.com with SMTP id p12so12286832ioj.11
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 01:55:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zJ12j5pv5Az/S+9kY6tzef+qUz2WbuayYYPs6x7cqx8=;
        b=F6t4EPC5hUf/JBIgGChRER0I2u2kD5K7lG298Hl96BN8N+ggzw00LWlVIcSDWVyF8g
         O7Ehu+9Xo3uVlPpcyUwu/orUjZaDsbVIaxFDQ19baORN0MTTKLtovW+LDvyTMRkBKJwk
         Iwc5HZ+HpNAel6IA2e56lbRCfLXx/z7klxKRxaGHxpLC7juvSKZwANZdBIluPACRVlf2
         FomGvpiB+H5WxYJoShomy+FC6zPlkZ0S3F/wN2gZJCaAUsOTHKcg0INEz9OICJ3UMPOH
         D0nCZpM/RhCeqpSD+ZoM5fXHIx2k/TH5M+1oAbKfMlHwGHK/584WRanwRRJ7eoR49XJd
         RIkA==
X-Gm-Message-State: AOAM5311luI9TQ0zQAR2poE9yPc0OhE3BFsUQzRZ8H3NujTzNuwHgNaz
        BeW6Ishu6itb1y+Ktf+aW2b4wMzHE0C494IobanvBdqJ6+4h
X-Google-Smtp-Source: ABdhPJzND7DGe3RsHCRfdr6ZoSQhKLO7EnUQe2826jcG7IvxIqnA1/MNVQQbJcRJUfjOj9YEp/s9f+/Vj8OJIEh1cC5SePgOg+Wx
MIME-Version: 1.0
X-Received: by 2002:a05:6638:283:: with SMTP id c3mr28349610jaq.134.1606125316419;
 Mon, 23 Nov 2020 01:55:16 -0800 (PST)
Date:   Mon, 23 Nov 2020 01:55:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3332805b4c330c3@google.com>
Subject: inconsistent lock state in io_file_data_ref_zero
From:   syzbot <syzbot+1f4ba1e5520762c523c6@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, davem@davemloft.net, io-uring@vger.kernel.org,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    27bba9c5 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11041f1e500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=330f3436df12fd44
dashboard link: https://syzkaller.appspot.com/bug?extid=1f4ba1e5520762c523c6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d9b775500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157e4f75500000

The issue was bisected to:

commit dcd479e10a0510522a5d88b29b8f79ea3467d501
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 9 12:17:11 2020 +0000

    mac80211: always wind down STA state

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130299a9500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=108299a9500000
console output: https://syzkaller.appspot.com/x/log.txt?x=170299a9500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f4ba1e5520762c523c6@syzkaller.appspotmail.com
Fixes: dcd479e10a05 ("mac80211: always wind down STA state")

================================
WARNING: inconsistent lock state
5.10.0-rc4-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff8880125202a8 (&file_data->lock){+.?.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880125202a8 (&file_data->lock){+.?.}-{2:2}, at: io_file_data_ref_zero+0x75/0x480 fs/io_uring.c:7361
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5435 [inline]
  lock_acquire+0x2a3/0x8c0 kernel/locking/lockdep.c:5400
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  io_sqe_files_register fs/io_uring.c:7496 [inline]
  __io_uring_register fs/io_uring.c:9660 [inline]
  __do_sys_io_uring_register+0x343a/0x40d0 fs/io_uring.c:9750
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
irq event stamp: 131582
hardirqs last  enabled at (131582): [<ffffffff88e80d52>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (131582): [<ffffffff88e80d52>] _raw_spin_unlock_irqrestore+0x42/0x50 kernel/locking/spinlock.c:191
hardirqs last disabled at (131581): [<ffffffff88e80b1e>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (131581): [<ffffffff88e80b1e>] _raw_spin_lock_irqsave+0x4e/0x50 kernel/locking/spinlock.c:159
softirqs last  enabled at (131566): [<ffffffff814279df>] irq_enter_rcu+0xcf/0xf0 kernel/softirq.c:360
softirqs last disabled at (131567): [<ffffffff89000eaf>] asm_call_irq_on_stack+0xf/0x20

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&file_data->lock);
  <Interrupt>
    lock(&file_data->lock);

 *** DEADLOCK ***

2 locks held by swapper/0/0:
 #0: ffffffff8b337700 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2466 [inline]
 #0: ffffffff8b337700 (rcu_callback){....}-{0:0}, at: rcu_core+0x576/0xe80 kernel/rcu/tree.c:2711
 #1: ffffffff8b337820 (rcu_read_lock){....}-{1:2}, at: percpu_ref_put_many.constprop.0+0x0/0x250 net/netfilter/xt_cgroup.c:62

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:3738 [inline]
 valid_state kernel/locking/lockdep.c:3749 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3952 [inline]
 mark_lock.cold+0x32/0x74 kernel/locking/lockdep.c:4409
 mark_usage kernel/locking/lockdep.c:4304 [inline]
 __lock_acquire+0x11b1/0x5c00 kernel/locking/lockdep.c:4784
 lock_acquire kernel/locking/lockdep.c:5435 [inline]
 lock_acquire+0x2a3/0x8c0 kernel/locking/lockdep.c:5400
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_file_data_ref_zero+0x75/0x480 fs/io_uring.c:7361
 percpu_ref_put_many.constprop.0+0x217/0x250 include/linux/percpu-refcount.h:322
 rcu_do_batch kernel/rcu/tree.c:2476 [inline]
 rcu_core+0x5df/0xe80 kernel/rcu/tree.c:2711
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x132/0x200 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:79 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:169 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:517
Code: 8d 21 88 f8 84 db 75 ac e8 74 29 88 f8 e8 2f e8 8d f8 e9 0c 00 00 00 e8 65 29 88 f8 0f 00 2d 5e 74 c0 00 e8 59 29 88 f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 b4 21 88 f8 48 85 db
RSP: 0018:ffffffff8b007d60 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffffffff19d8ff9
RDX: ffffffff8b09af80 RSI: ffffffff88e80687 RDI: 0000000000000000
RBP: ffff88814141d064 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
R13: ffff88814141d000 R14: ffff88814141d064 R15: ffff888014984004
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:648
 cpuid


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
