Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB35232490
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 20:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgG2SYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 14:24:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:50236 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgG2SYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 14:24:17 -0400
Received: by mail-il1-f200.google.com with SMTP id l17so17232494ilj.17
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 11:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IN3u1GDaVYrE0AqJpCcuAghgATliVHxr+eqMDVhObqs=;
        b=cNNhOP2h3Te/A4I/Qjc5ET0o9VBcYf1fnoSRHFKGtkkGYdBZ6M4LaMT0fbfQAhCyJ0
         Zk7SzghDpiYjw2Ph1W6UpMqMSRBHNc1X3hX93w/Ax34J8Cll0X9sHh6PVWvHK2LWFk/o
         tuySwxM4FJfn7FJEQTRz1VK4MuIUYRv3QgV//Pkgfj2fpCUzWefVXgb2wTRvoO3dDP5L
         BZgz1UW3E+LZ5hMWlEIZ+AGUmMV5gEF1g/4wzgRZCT9HsANVx4aSojjmuodqSyRTZoff
         RPg+DfoeeFgKjEGWLwhN2jmuPE4RBaYnhz6RBqXGtn4rw05rkjTtfBRTroo+vfPVmiOz
         Gb6w==
X-Gm-Message-State: AOAM530ISD5pZLqKcdcIGJkNEfbvFs2RHO2nnI58GbhTumMmilyfzZBe
        atcn//E1G5AWtLrVNmv+c2xrMTekZKfJs1iO3lBKK4aIYE0t
X-Google-Smtp-Source: ABdhPJzDdjVeuzNxfsWgoyLwtVyCMDItdjj0F1H43aKdI4WmT5YabaRvgiE9in7nPhgKpLeSwm+qoMqibvGJCGE07Lb1fcBBsxh+
MIME-Version: 1.0
X-Received: by 2002:a6b:5a04:: with SMTP id o4mr32524747iob.171.1596047055708;
 Wed, 29 Jul 2020 11:24:15 -0700 (PDT)
Date:   Wed, 29 Jul 2020 11:24:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cce79b05ab98a99c@google.com>
Subject: KASAN: use-after-free Write in __alloc_skb (3)
From:   syzbot <syzbot+7569bc4cd6fad9f1e551@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    68845a55 Merge branch 'akpm' into master (patches from And..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f85f78900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=7569bc4cd6fad9f1e551
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1517668c900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10280564900000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13dc473c900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=103c473c900000
console output: https://syzkaller.appspot.com/x/log.txt?x=17dc473c900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7569bc4cd6fad9f1e551@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memset include/linux/string.h:391 [inline]
BUG: KASAN: use-after-free in __alloc_skb+0x2f6/0x550 net/core/skbuff.c:239
Write of size 32 at addr ffff8881a7463f40 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 memset+0x20/0x40 mm/kasan/common.c:84
 memset include/linux/string.h:391 [inline]
 __alloc_skb+0x2f6/0x550 net/core/skbuff.c:239
 alloc_skb include/linux/skbuff.h:1083 [inline]
 alloc_skb_with_frags+0x92/0x570 net/core/skbuff.c:5770
 sock_alloc_send_pskb+0x72a/0x880 net/core/sock.c:2356
 mld_newpack+0x1e0/0x770 net/ipv6/mcast.c:1606
 add_grhead+0x265/0x330 net/ipv6/mcast.c:1710
 add_grec+0xe2c/0x1090 net/ipv6/mcast.c:1841
 mld_send_cr net/ipv6/mcast.c:1967 [inline]
 mld_ifc_timer_expire+0x596/0xf10 net/ipv6/mcast.c:2474
 call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1415
 expire_timers kernel/time/timer.c:1460 [inline]
 __run_timers.part.0+0x54c/0xa20 kernel/time/timer.c:1784
 __run_timers kernel/time/timer.c:1756 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1797
 __do_softirq+0x34c/0xa60 kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x111/0x170 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x229/0x270 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x54/0x120 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:585
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: ff 4c 89 ef e8 33 c9 ca f9 e9 8e fe ff ff 48 89 df e8 26 c9 ca f9 eb 8a cc cc cc cc e9 07 00 00 00 0f 00 2d 74 5f 60 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 64 5f 60 00 f4 c3 cc cc 55 53 e8 29
RSP: 0018:ffffc90000d3fc88 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880a9636340 RSI: ffffffff87e85c48 RDI: ffffffff87e85c1e
RBP: ffff8880a68e7864 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8880a68e7864
R13: 1ffff920001a7f9b R14: ffff8880a68e7865 R15: 0000000000000001
 arch_safe_halt arch/x86/include/asm/paravirt.h:150 [inline]
 acpi_safe_halt+0x8d/0x110 drivers/acpi/processor_idle.c:111
 acpi_idle_do_entry+0x15c/0x1b0 drivers/acpi/processor_idle.c:525
 acpi_idle_enter+0x3f9/0xab0 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0xff/0x960 drivers/cpuidle/cpuidle.c:235
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:346
 call_cpuidle kernel/sched/idle.c:126 [inline]
 cpuidle_idle_call kernel/sched/idle.c:214 [inline]
 do_idle+0x431/0x6d0 kernel/sched/idle.c:276
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:372
 start_secondary+0x2b3/0x370 arch/x86/kernel/smpboot.c:268
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243

The buggy address belongs to the page:
page:ffffea00069d18c0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0x57ffe0000000000()
raw: 057ffe0000000000 ffffea00069d18c8 ffffea00069d18c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881a7463e00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881a7463e80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8881a7463f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                           ^
 ffff8881a7463f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881a7464000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
