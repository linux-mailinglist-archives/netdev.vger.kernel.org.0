Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5036CDF8
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 14:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390287AbfGRMSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 08:18:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47559 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfGRMSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 08:18:08 -0400
Received: by mail-io1-f71.google.com with SMTP id r27so30695192iob.14
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 05:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=P37V7g1ilZLvMKuYYt4IQej0o6/UvzFQGZC5ukrNMIA=;
        b=pmKVABGn4uF+Y51QmLUbtCfdvRyn1ZXtoBv8DLSVbWVIXXtzthps/EL9w41djoXbgV
         EVVXwlqv2QrRoQk5A6ZoBmV8uM/CQm0aq4gaHFYu/7JGbWt96E47tGI7LjfMEIeOIuvP
         BrJPfezVO4atEWtcbMtGODVYICJtkLMErkEGmRAVEnH7UfA+lFIsrkHsyWif0yb10zid
         4pz1cmNSO4tTP/cGdR7LCIILBszVGh2fSEZuTIVcvBTOQgLN/toX9dITYTOICLdWcZ0O
         gCaew8NF6vYqfL68crBuWSMpmGn3fDNBD+L11GcmxEiHCPIUVllms7o3fd+N4giYRi+a
         h+MA==
X-Gm-Message-State: APjAAAVo47Y3RuOaLpzKqG580MJnw/1bwgH4LCiUpmz+Rb5hs+Teuj47
        h2Tz7RqUy+GPV0B6AVLw0iYmNpjSJZEnSPdzrKJIs6bhJXo+
X-Google-Smtp-Source: APXvYqxwfXaPGbiaVaPMOCDgxL4Cb3HWOLvagdS0PGniB53GHXEOOXOrNxmjYBFlxx8F7DgW7RfcT+VmDbzLSbQADRqj+f7pTiPr
MIME-Version: 1.0
X-Received: by 2002:a02:ccd2:: with SMTP id k18mr48043620jaq.3.1563452287347;
 Thu, 18 Jul 2019 05:18:07 -0700 (PDT)
Date:   Thu, 18 Jul 2019 05:18:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035f65d058df39aed@google.com>
Subject: KASAN: use-after-free Read in nr_insert_socket
From:   syzbot <syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com>
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

HEAD commit:    a5b64700 fix: taprio: Change type of txtime-delay paramete..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1588b458600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87305c3ca9c25c70
dashboard link: https://syzkaller.appspot.com/bug?extid=9399c158fcc09b21d0d2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105a61a4600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153ef948600000

The bug was bisected to:

commit c8c8218ec5af5d2598381883acbefbf604e56b5e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jun 27 21:30:58 2019 +0000

     netrom: fix a memory leak in nr_rx_frame()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=159ef948600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=179ef948600000
console output: https://syzkaller.appspot.com/x/log.txt?x=139ef948600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com
Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")

==================================================================
BUG: KASAN: use-after-free in atomic_read  
/./include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x81/0x200  
/lib/refcount.c:123
Read of size 4 at addr ffff8880a5d3f380 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.2.0+ #89
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack /lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 /lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 /mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 /mm/kasan/report.c:482
  kasan_report+0x12/0x20 /mm/kasan/common.c:612
  check_memory_region_inline /mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 /mm/kasan/generic.c:192
  __kasan_check_read+0x11/0x20 /mm/kasan/common.c:92
  atomic_read /./include/asm-generic/atomic-instrumented.h:26 [inline]
  refcount_inc_not_zero_checked+0x81/0x200 /lib/refcount.c:123
  refcount_inc_checked+0x17/0x70 /lib/refcount.c:156
  sock_hold /./include/net/sock.h:649 [inline]
  sk_add_node /./include/net/sock.h:701 [inline]
  nr_insert_socket+0x2d/0xe0 /net/netrom/af_netrom.c:137
  nr_rx_frame+0x1605/0x1e80 /net/netrom/af_netrom.c:1023
  nr_loopback_timer+0x7b/0x170 /net/netrom/nr_loopback.c:59
  call_timer_fn+0x1ac/0x780 /kernel/time/timer.c:1322
  expire_timers /kernel/time/timer.c:1366 [inline]
  __run_timers /kernel/time/timer.c:1685 [inline]
  __run_timers /kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 /kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c /kernel/softirq.c:292
  invoke_softirq /kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 /kernel/softirq.c:413
  exiting_irq /./arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 /arch/x86/kernel/apic/apic.c:1095
  apic_timer_interrupt+0xf/0x20 /arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 /./arch/x86/include/asm/irqflags.h:61
Code: e8 2b 7b fa eb 8a 90 90 90 90 90 90 e9 07 00 00 00 0f 00 2d d4 0e 57  
00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d c4 0e 57 00 fb f4 <c3> 90 55 48 89  
e5 41 57 41 56 41 55 41 54 53 e8 7e 27 2f fa e8 59
RSP: 0018:ffff8880a98e7d68 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff11a5ca5 RBX: ffff8880a98ce340 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffff8880a98cebcc
RBP: ffff8880a98e7d98 R08: ffff8880a98ce340 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff89a29778 R14: 0000000000000000 R15: 0000000000000001
  arch_cpu_idle+0xa/0x10 /arch/x86/kernel/process.c:571
  default_idle_call+0x84/0xb0 /kernel/sched/idle.c:94
  cpuidle_idle_call /kernel/sched/idle.c:154 [inline]
  do_idle+0x413/0x760 /kernel/sched/idle.c:263
  cpu_startup_entry+0x1b/0x20 /kernel/sched/idle.c:354
  start_secondary+0x315/0x430 /arch/x86/kernel/smpboot.c:264
  secondary_startup_64+0xa4/0xb0 /arch/x86/kernel/head_64.S:243

Allocated by task 0:
  save_stack+0x23/0x90 /mm/kasan/common.c:69
  set_track /mm/kasan/common.c:77 [inline]
  __kasan_kmalloc /mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 /mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 /mm/kasan/common.c:501
  __do_kmalloc /mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x780 /mm/slab.c:3664
  kmalloc /./include/linux/slab.h:557 [inline]
  sk_prot_alloc+0x23a/0x310 /net/core/sock.c:1603
  sk_alloc+0x39/0xf70 /net/core/sock.c:1657
  nr_make_new /net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0x733/0x1e80 /net/netrom/af_netrom.c:959
  nr_loopback_timer+0x7b/0x170 /net/netrom/nr_loopback.c:59
  call_timer_fn+0x1ac/0x780 /kernel/time/timer.c:1322
  expire_timers /kernel/time/timer.c:1366 [inline]
  __run_timers /kernel/time/timer.c:1685 [inline]
  __run_timers /kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 /kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c /kernel/softirq.c:292

Freed by task 11342:
  save_stack+0x23/0x90 /mm/kasan/common.c:69
  set_track /mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 /mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 /mm/kasan/common.c:457
  __cache_free /mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 /mm/slab.c:3756
  sk_prot_free /net/core/sock.c:1640 [inline]
  __sk_destruct+0x4f7/0x6e0 /net/core/sock.c:1726
  sk_destruct+0x86/0xa0 /net/core/sock.c:1734
  __sk_free+0xfb/0x360 /net/core/sock.c:1745
  sk_free+0x42/0x50 /net/core/sock.c:1756
  sock_put /./include/net/sock.h:1725 [inline]
  sock_efree+0x61/0x80 /net/core/sock.c:2042
  skb_release_head_state+0xeb/0x260 /net/core/skbuff.c:652
  skb_release_all+0x16/0x60 /net/core/skbuff.c:663
  __kfree_skb /net/core/skbuff.c:679 [inline]
  kfree_skb /net/core/skbuff.c:697 [inline]
  kfree_skb+0x101/0x3c0 /net/core/skbuff.c:691
  nr_accept+0x570/0x720 /net/netrom/af_netrom.c:819
  __sys_accept4+0x34e/0x6a0 /net/socket.c:1750
  __do_sys_accept4 /net/socket.c:1785 [inline]
  __se_sys_accept4 /net/socket.c:1782 [inline]
  __x64_sys_accept4+0x97/0xf0 /net/socket.c:1782
  do_syscall_64+0xfd/0x6a0 /arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a5d3f300
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
  2048-byte region [ffff8880a5d3f300, ffff8880a5d3fb00)
The buggy address belongs to the page:
page:ffffea0002974f80 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00021bf808 ffffea000282a708 ffff8880aa400e00
raw: 0000000000000000 ffff8880a5d3e200 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a5d3f280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a5d3f300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880a5d3f380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff8880a5d3f400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a5d3f480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
