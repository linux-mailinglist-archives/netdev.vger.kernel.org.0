Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BAF6CBE2
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 11:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbfGRJ2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 05:28:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:53202 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbfGRJ2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 05:28:06 -0400
Received: by mail-io1-f71.google.com with SMTP id p12so30218327iog.19
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 02:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=aehmJjOM6NTMfICBBLWXVMICW/l3Uzx/pd8fPk7XKgE=;
        b=kvdpTJGVDTJGxWmURqINd3sYhp10cRx36g2vCx6snUWVyEdLXLo2xSmbPUHbCOP5Ux
         xcGk2PoGhzDxrKD9sKiDP84J20tK1hTWHXT5gwtY9HEMxLdmhX93h2VSsgU8ZOtm+AwY
         MPbMflyol0Iqzv5HLGHMgy/4GuNXdll6gT5AUeAKBeDZthOc+iwWYDh0uCj0JvN/qvEP
         Lj5j6b0qAZyWFzD6feGfsLmJfpvVVOsyT+yQhaAXwq/BOxbv1qalUX6JWwyK2QlOKvls
         ICtB3PFhTgLCN/yh36WS5uXHgpQlgR65/5mLERhlyruBFXCkDybgxPlYujbj/G7dMAcO
         JPlw==
X-Gm-Message-State: APjAAAWpJh52mLyVqEWVSdtQnGpMTXxoY9aBn8OrXDK4tTT9kn4Rh8oV
        PbaYs60chB1aoHd1E+Ey0ga6jqbqV82gotjsGPNAKkYX9UI5
X-Google-Smtp-Source: APXvYqx09dppUw17eSm9qjx9XCgUBIaWOI4XLatTk9WmnhjzjNZRBUEqNeli3h9Udfv16e9/imYMgFAf6bZ1s1xymasHJAtiVoU4
MIME-Version: 1.0
X-Received: by 2002:a02:914c:: with SMTP id b12mr519167jag.105.1563442085501;
 Thu, 18 Jul 2019 02:28:05 -0700 (PDT)
Date:   Thu, 18 Jul 2019 02:28:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000222512058df13ac9@google.com>
Subject: WARNING: refcount bug in nr_rx_frame
From:   syzbot <syzbot+622bdabb128acc33427d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0a8ad0ff Merge tag 'for-linus-5.3-ofs1' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f3cb70600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88095c4f62402bcd
dashboard link: https://syzkaller.appspot.com/bug?extid=622bdabb128acc33427d
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140a8cafa00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123b2e68600000

The bug was bisected to:

commit c8c8218ec5af5d2598381883acbefbf604e56b5e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jun 27 21:30:58 2019 +0000

     netrom: fix a memory leak in nr_rx_frame()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1479a100600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1679a100600000
console output: https://syzkaller.appspot.com/x/log.txt?x=1279a100600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+622bdabb128acc33427d@syzkaller.appspotmail.com
Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")

------------[ cut here ]------------
refcount_t: increment on 0; use-after-free.
WARNING: CPU: 1 PID: 0 at lib/refcount.c:156 refcount_inc_checked+0x4b/0x50  
/lib/refcount.c:156
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.2.0+ #33
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack /lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 /lib/dump_stack.c:113
  panic+0x29b/0x7d9 /kernel/panic.c:219
  __warn+0x22f/0x230 /kernel/panic.c:576
  report_bug+0x190/0x290 /lib/bug.c:186
  fixup_bug /arch/x86/kernel/traps.c:179 [inline]
  do_error_trap+0xd7/0x440 /arch/x86/kernel/traps.c:272
  do_invalid_op+0x36/0x40 /arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 /arch/x86/entry/entry_64.S:1008
RIP: 0010:refcount_inc_checked+0x4b/0x50 /lib/refcount.c:156
Code: 3d d9 5e 94 05 01 75 08 e8 22 8f 11 fe 5b 5d c3 e8 1a 8f 11 fe c6 05  
c3 5e 94 05 01 48 c7 c7 49 ca 87 88 31 c0 e8 35 ca e2 fd <0f> 0b eb df 90  
55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 e4 e0
RSP: 0018:ffff8880aeb09b40 EFLAGS: 00010246
RAX: d6b548c1187c2900 RBX: ffff8880a149f6c0 RCX: ffff8880a98bc340
RDX: 0000000000000302 RSI: 0000000000000302 RDI: 0000000000000000
RBP: ffff8880aeb09b48 R08: ffffffff81600c14 R09: fffffbfff13bb2bb
R10: fffffbfff13bb2bb R11: 0000000000000000 R12: ffff88808240aa40
R13: dffffc0000000000 R14: 0000000000000004 R15: ffff8880a149f640
  sock_hold /./include/net/sock.h:649 [inline]
  sk_add_node /./include/net/sock.h:701 [inline]
  nr_insert_socket /net/netrom/af_netrom.c:137 [inline]
  nr_rx_frame+0x17bc/0x1e40 /net/netrom/af_netrom.c:1023
  nr_loopback_timer+0x6a/0x140 /net/netrom/nr_loopback.c:59
  call_timer_fn+0xec/0x200 /kernel/time/timer.c:1322
  expire_timers /kernel/time/timer.c:1366 [inline]
  __run_timers+0x7cd/0x9c0 /kernel/time/timer.c:1685
  run_timer_softirq+0x4a/0x90 /kernel/time/timer.c:1698
  __do_softirq+0x333/0x7c4 /./arch/x86/include/asm/paravirt.h:777
  invoke_softirq /kernel/softirq.c:373 [inline]
  irq_exit+0x227/0x230 /kernel/softirq.c:413
  exiting_irq /./arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x113/0x280 /arch/x86/kernel/apic/apic.c:1095
  apic_timer_interrupt+0xf/0x20 /arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 /./arch/x86/include/asm/irqflags.h:61
Code: 08 fa eb ae 89 d9 80 e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 a4 04 08  
fa eb b0 90 90 e9 07 00 00 00 0f 00 2d e6 9c 58 00 fb f4 <c3> 90 e9 07 00  
00 00 0f 00 2d d6 9c 58 00 f4 c3 90 90 55 48 89 e5
RSP: 0018:ffff8880a98cfd38 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff11950db RBX: ffff8880a98bc340 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff812cde8a RDI: ffff8880a98bcb78
RBP: ffff8880a98cfd40 R08: ffff8880a98bcb90 R09: ffffed1015317869
R10: ffffed1015317869 R11: 0000000000000000 R12: 0000000000000001
R13: 1ffff11015317868 R14: dffffc0000000000 R15: dffffc0000000000
  arch_cpu_idle+0xa/0x10 /arch/x86/kernel/process.c:571
  default_idle_call+0x59/0xa0 /kernel/sched/idle.c:94
  cpuidle_idle_call /kernel/sched/idle.c:154 [inline]
  do_idle+0x180/0x780 /kernel/sched/idle.c:263
  cpu_startup_entry+0x25/0x30 /kernel/sched/idle.c:354
  start_secondary+0x3f4/0x490 /arch/x86/kernel/smpboot.c:264
  secondary_startup_64+0xa4/0xb0 /arch/x86/kernel/head_64.S:243
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
