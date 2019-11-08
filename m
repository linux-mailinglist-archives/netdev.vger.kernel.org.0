Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C7F5224
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbfKHREP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:04:15 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:42389 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbfKHREO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:04:14 -0500
Received: by mail-io1-f69.google.com with SMTP id w1so5827103ioj.9
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:04:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=s7s+0AUIh85QJo5bIS6QtBdWuP0XF27aERvqgQ8hEgw=;
        b=ELCzRYVh23WLl1Q8QNLfLECi39ZnWb4A7F7DyKoxv+YBKqN3GwgIrpzpgc11TiT7e1
         066G9AymTD+4mkBG11QRIrkgwiGt+0zcOnoofXiDrI9gpUs1T28uHsRCmfKbudfwQOIJ
         eMUt6XXmB2CvHnuCHOAqs6TeYQAfbrzk90tcHI8nOooH05Bf30H3nAyeOkEb/rPGk8/f
         1VDNEYWMMmxDqKFeDhJgXh+1CS+wIAX/IrEtG19bRYrJQMOkDRbdlUWAhBMXQk7z7MIH
         OUYhVKQJ144THQCIFwPlxfxS5Co4Y3AgI+rcYx4R3eysZKswgN+nfeembUtPpJc55wI1
         iidA==
X-Gm-Message-State: APjAAAVXdSLEc0OWBHuz8HoPO7INKPZOsE4yYd1TdoHbpge//twCrrXP
        rOtl58rkg3nVEcYIBbYklT3VqbV+qaM7WAmd2tYdVaU3bU2A
X-Google-Smtp-Source: APXvYqx+2483goQJH3/cpm8N4DuiOA1eSgQWI2TcafX7e5/N7Y8JNnxclkD+QFHfXEwadHc3wiUuWt8g62R3dNYkNh8zQ1Z73n7q
MIME-Version: 1.0
X-Received: by 2002:a92:9891:: with SMTP id a17mr14106877ill.292.1573232652212;
 Fri, 08 Nov 2019 09:04:12 -0800 (PST)
Date:   Fri, 08 Nov 2019 09:04:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006264c60596d8c5fa@google.com>
Subject: KASAN: use-after-free Read in j1939_session_deactivate
From:   syzbot <syzbot+a47537d3964ef6c874e1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    847120f8 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11077272e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
dashboard link: https://syzkaller.appspot.com/bug?extid=a47537d3964ef6c874e1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164973b4e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a47537d3964ef6c874e1@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_abort_one: 0x0000000017fc679a: 0x00000: (2) System  
resources were needed for another task so this connection managed session  
was terminated.
vcan0: j1939_tp_rxtimer: 0x000000000eaf12e4: abort rx timeout. Force  
session deactivation
==================================================================
BUG: KASAN: use-after-free in j1939_session_deactivate+0x80/0x90  
net/can/j1939/transport.c:1033
Read of size 8 at addr ffff88809958dc00 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  j1939_session_deactivate+0x80/0x90 net/can/j1939/transport.c:1033
  j1939_session_deactivate_activate_next+0x17/0x50  
net/can/j1939/transport.c:1041
  j1939_tp_rxtimer+0xc8/0x27b net/can/j1939/transport.c:1150
  __run_hrtimer kernel/time/hrtimer.c:1514 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1576
  hrtimer_run_softirq+0x17e/0x270 kernel/time/hrtimer.c:1593
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 9265:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:690 [inline]
  j1939_session_new+0x81/0x3f0 net/can/j1939/transport.c:1384
  j1939_tp_send+0x249/0x750 net/can/j1939/transport.c:1846
  j1939_sk_send_loop net/can/j1939/socket.c:995 [inline]
  j1939_sk_sendmsg+0xb76/0x1450 net/can/j1939/socket.c:1100
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __compat_sys_sendmsg net/compat.c:642 [inline]
  __do_compat_sys_sendmsg net/compat.c:649 [inline]
  __se_compat_sys_sendmsg net/compat.c:646 [inline]
  __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:646
  do_syscall_32_irqs_on arch/x86/entry/common.c:333 [inline]
  do_fast_syscall_32+0x27b/0xdb3 arch/x86/entry/common.c:404
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 9:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  j1939_session_destroy net/can/j1939/transport.c:272 [inline]
  __j1939_session_release net/can/j1939/transport.c:280 [inline]
  kref_put include/linux/kref.h:65 [inline]
  j1939_session_put+0x134/0x180 net/can/j1939/transport.c:285
  j1939_session_deactivate_locked net/can/j1939/transport.c:1021 [inline]
  j1939_session_deactivate_locked+0x245/0x2f0 net/can/j1939/transport.c:1009
  j1939_session_deactivate+0x3d/0x90 net/can/j1939/transport.c:1032
  j1939_session_deactivate_activate_next+0x17/0x50  
net/can/j1939/transport.c:1041
  j1939_tp_rxtimer+0xc8/0x27b net/can/j1939/transport.c:1150
  __run_hrtimer kernel/time/hrtimer.c:1514 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1576
  hrtimer_run_softirq+0x17e/0x270 kernel/time/hrtimer.c:1593
  __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff88809958dc00
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
  512-byte region [ffff88809958dc00, ffff88809958de00)
The buggy address belongs to the page:
page:ffffea0002656340 refcount:1 mapcount:0 mapping:ffff8880aa400a80  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00028faa88 ffffea0002a31c48 ffff8880aa400a80
raw: 0000000000000000 ffff88809958d000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809958db00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809958db80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88809958dc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff88809958dc80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809958dd00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
