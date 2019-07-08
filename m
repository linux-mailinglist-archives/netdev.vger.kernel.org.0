Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2369629BB
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404677AbfGHThK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:37:10 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33020 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391735AbfGHThI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:37:08 -0400
Received: by mail-io1-f71.google.com with SMTP id 132so17570168iou.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gnWX0kUsdC0eHJTIMNthjAqQdaNjnsisdz8RZUKdFIY=;
        b=fkZz7Zw2YPIL1xvLpF+VVr6FPBO1mlQ7/LbEEbUi2x55Vmh3ZcDQhUoqtD6sfGt1kd
         va+PtXtsx/uq11uXLyFgvnikyTPmf2qkvxxjLgGC/bazIT2BQ8jgntLUIzzN50Z3Y8s7
         c7eqzf8fiwuBmdE/TgA/kv8b0rZlQ3L9Lc+ShwCVC4Taf/PhHjvO4OicsD4+J5B3mqJ2
         9jYbdFCRNjUdrIaUy3yqfl+jMNufzT0uiDVGhJ7UUjrn/l9FuEIe/5SAg1KOxye2kM5K
         HC+CVaaNsQk8TMijn76ImhUIgEyjLeavBmT9o6y8iaT7V1NmKgQ8FgyjQFdMsoKvnGtL
         mJlA==
X-Gm-Message-State: APjAAAV96mTwgY1irKgEl+SO7VU3VidJxGESHjtGVLs61yGBazYC3R3h
        NnxWD0kY35UYJDanGz82I1Co4WVfucMk7JQfO4P57y1lMepE
X-Google-Smtp-Source: APXvYqx+P1gcjJTw+mYefApBU6g5uc8dauxNcKbcisA1Nv5cDy/iQvYLMOG+J0EhTcQjjvIVy1AbUhYpOOcfSYCQF1cvNV+G5XW6
MIME-Version: 1.0
X-Received: by 2002:a02:ab83:: with SMTP id t3mr23245388jan.133.1562614627005;
 Mon, 08 Jul 2019 12:37:07 -0700 (PDT)
Date:   Mon, 08 Jul 2019 12:37:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3810f058d30910b@google.com>
Subject: WARNING: held lock freed! (2)
From:   syzbot <syzbot+e54ed2cb16c6da22c549@syzkaller.appspotmail.com>
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

HEAD commit:    9d1bc24b bonding: validate ip header before check IPPROTO_..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=152fab25a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7c31a94f66cc0aa
dashboard link: https://syzkaller.appspot.com/bug?extid=e54ed2cb16c6da22c549
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ad60bba00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165d2453a00000

The bug was bisected to:

commit c8c8218ec5af5d2598381883acbefbf604e56b5e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jun 27 21:30:58 2019 +0000

     netrom: fix a memory leak in nr_rx_frame()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1489854ba00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1689854ba00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1289854ba00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e54ed2cb16c6da22c549@syzkaller.appspotmail.com
Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")

=========================
WARNING: held lock freed!
5.2.0-rc6+ #75 Not tainted
-------------------------
syz-executor315/8559 is freeing memory ffff88809faed2c0-ffff88809faedabf,  
with a lock still held there!
00000000cf45dbdb (sk_lock-AF_NETROM){+.+.}, at: lock_sock  
include/net/sock.h:1522 [inline]
00000000cf45dbdb (sk_lock-AF_NETROM){+.+.}, at: nr_release+0x11a/0x3b0  
net/netrom/af_netrom.c:522
2 locks held by syz-executor315/8559:
  #0: 00000000c0a19dcd (&sb->s_type->i_mutex_key#11){+.+.}, at: inode_lock  
include/linux/fs.h:778 [inline]
  #0: 00000000c0a19dcd (&sb->s_type->i_mutex_key#11){+.+.}, at:  
__sock_release+0x89/0x2a0 net/socket.c:600
  #1: 00000000cf45dbdb (sk_lock-AF_NETROM){+.+.}, at: lock_sock  
include/net/sock.h:1522 [inline]
  #1: 00000000cf45dbdb (sk_lock-AF_NETROM){+.+.}, at: nr_release+0x11a/0x3b0  
net/netrom/af_netrom.c:522

stack backtrace:
CPU: 0 PID: 8559 Comm: syz-executor315 Not tainted 5.2.0-rc6+ #75
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_freed_lock_bug kernel/locking/lockdep.c:5077 [inline]
  debug_check_no_locks_freed.cold+0x9d/0xa9 kernel/locking/lockdep.c:5110
  kfree+0xb1/0x220 mm/slab.c:3752
  sk_prot_free net/core/sock.c:1636 [inline]
  __sk_destruct+0x4f7/0x6e0 net/core/sock.c:1722
  sk_destruct+0x7b/0x90 net/core/sock.c:1730
  __sk_free+0xce/0x300 net/core/sock.c:1741
  sk_free+0x42/0x50 net/core/sock.c:1752
  sock_put include/net/sock.h:1725 [inline]
  nr_destroy_socket+0x3df/0x4a0 net/netrom/af_netrom.c:288
  nr_release+0x323/0x3b0 net/netrom/af_netrom.c:530
  __sock_release+0xce/0x2a0 net/socket.c:601
  sock_close+0x1b/0x30 net/socket.c:1273
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447269
Code: e8 7c 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f653a7bed88 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffff95 RBX: 00000000006dcc48 RCX: 0000000000447269
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000006dcc40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc4c
R13: 0000003066736362 R14: 002cc7eb47000000 R15: 0000003066736362
==================================================================
BUG: KASAN: use-after-free in debug_spin_lock_before  
kernel/locking/spinlock_debug.c:83 [inline]
BUG: KASAN: use-after-free in do_raw_spin_lock+0x28a/0x2e0  
kernel/locking/spinlock_debug.c:112
Read of size 4 at addr ffff88809faed34c by task syz-executor315/8559

CPU: 1 PID: 8559 Comm: syz-executor315 Not tainted 5.2.0-rc6+ #75
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:131
  debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
  do_raw_spin_lock+0x28a/0x2e0 kernel/locking/spinlock_debug.c:112
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
  _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  release_sock+0x20/0x1c0 net/core/sock.c:2928
  nr_release+0x2df/0x3b0 net/netrom/af_netrom.c:553
  __sock_release+0xce/0x2a0 net/socket.c:601
  sock_close+0x1b/0x30 net/socket.c:1273
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447269
Code: e8 7c 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f653a7bed88 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffff95 RBX: 00000000006dcc48 RCX: 0000000000447269
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000006dcc40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc4c
R13: 0000003066736362 R14: 002cc7eb47000000 R15: 0000003066736362

Allocated by task 8562:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  __do_kmalloc mm/slab.c:3660 [inline]
  __kmalloc+0x15c/0x740 mm/slab.c:3669
  kmalloc include/linux/slab.h:552 [inline]
  sk_prot_alloc+0x19c/0x2e0 net/core/sock.c:1599
  sk_alloc+0x39/0xf70 net/core/sock.c:1653
  nr_make_new net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0x733/0x1e70 net/netrom/af_netrom.c:959
  nr_loopback_timer+0x7b/0x170 net/netrom/nr_loopback.c:59
  call_timer_fn+0x193/0x720 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x66f/0x1740 kernel/time/timer.c:1698
  __do_softirq+0x25c/0x94c kernel/softirq.c:292

Freed by task 8559:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kfree+0xcf/0x220 mm/slab.c:3755
  sk_prot_free net/core/sock.c:1636 [inline]
  __sk_destruct+0x4f7/0x6e0 net/core/sock.c:1722
  sk_destruct+0x7b/0x90 net/core/sock.c:1730
  __sk_free+0xce/0x300 net/core/sock.c:1741
  sk_free+0x42/0x50 net/core/sock.c:1752
  sock_put include/net/sock.h:1725 [inline]
  nr_destroy_socket+0x3df/0x4a0 net/netrom/af_netrom.c:288
  nr_release+0x323/0x3b0 net/netrom/af_netrom.c:530
  __sock_release+0xce/0x2a0 net/socket.c:601
  sock_close+0x1b/0x30 net/socket.c:1273
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809faed2c0
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 140 bytes inside of
  2048-byte region [ffff88809faed2c0, ffff88809faedac0)
The buggy address belongs to the page:
page:ffffea00027ebb00 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000242cd08 ffffea00023df908 ffff8880aa400c40
raw: 0000000000000000 ffff88809faec1c0 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809faed200: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff88809faed280: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> ffff88809faed300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                               ^
  ffff88809faed380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809faed400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
