Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BE939BDD
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 10:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfFHIgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 04:36:06 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:51765 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfFHIgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 04:36:06 -0400
Received: by mail-it1-f198.google.com with SMTP id w80so4067153itc.1
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 01:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fkX3S/tPJEfO5/PQ4Wk37gR465AkH5W+vB2a+wWl59Y=;
        b=QI1xgaeRZxcR2vNfOf2X2nr2TAOlfLLVaDJipbeAOurd+kSswe5j2H5uDC1T9FJRjE
         yvLEwQc3ddXMFgSremhchVuoHCJMyp4FpqToJk5IIfeXjDdsNBtKgT9MQrDK9aEzHeeJ
         S15pXe2mtLXtAQaalRQ3K3H0RymSwlqVUibuY8wpsBXYYGorBaYTlL6jwa7tHus73eiu
         pli0W56IG7gvx0jqahAxU6AlVXszAYj+dITsS9orYgaQYBwxxRy72I1bMU1Q8oIbflNV
         Q1mQ5hFDp9Rr1JTZ4ur3Iq/g+nLymu639le+2fgkx1dEQF0IvHNIkvLFAABfX5wFR9Gb
         K0Zg==
X-Gm-Message-State: APjAAAUGr9hyJMNPZyyaMZE++vM5KwZd5Fqxfjj29yCEvG8ffAVa74gO
        LBF3XIM1VaFzjD8nsYONmMSB+gxFB8xSJQimwzQzQtbH961a
X-Google-Smtp-Source: APXvYqxfMVxXk9WA9chqUCvvz96lOoRsKKqehXtwiABs8q4Gh1jv6ThJ6W6b3H3EnnYSaZDfWGLlyYRitrl38tk9NV1LLhaWCSem
MIME-Version: 1.0
X-Received: by 2002:a6b:5a0c:: with SMTP id o12mr3678402iob.281.1559982965162;
 Sat, 08 Jun 2019 01:36:05 -0700 (PDT)
Date:   Sat, 08 Jun 2019 01:36:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e8b70058acbd60f@google.com>
Subject: KASAN: use-after-free Read in nr_release
From:   syzbot <syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    85cb9287 net: rds: fix memory leak in rds_ib_flush_mr_pool
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=133e162ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f721a391cd46ea
dashboard link: https://syzkaller.appspot.com/bug?extid=6eaef7158b19e3fec3a0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x81/0x200  
lib/refcount.c:123
Read of size 4 at addr ffff88807bd1a3c0 by task syz-executor.4/31693

CPU: 1 PID: 31693 Comm: syz-executor.4 Not tainted 5.2.0-rc2+ #43
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x123/0x190 mm/kasan/generic.c:191
  kasan_check_read+0x11/0x20 mm/kasan/common.c:94
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  refcount_inc_not_zero_checked+0x81/0x200 lib/refcount.c:123
  refcount_inc_checked+0x17/0x70 lib/refcount.c:156
  sock_hold include/net/sock.h:654 [inline]
  nr_release+0x62/0x3b0 net/netrom/af_netrom.c:523
  __sock_release+0xce/0x2a0 net/socket.c:607
  sock_close+0x1b/0x30 net/socket.c:1279
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x412f61
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffda8e7f4d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000412f61
RDX: 0000000000000000 RSI: ffffffff87168e98 RDI: 0000000000000004
RBP: 0000000000000001 R08: ffffffff81009897 R09: 0000000017981f41
R10: 00007ffda8e7f5b0 R11: 0000000000000293 R12: 000000000075c920
R13: 000000000075c920 R14: 000000000018a8f4 R15: 000000000075c10c

Allocated by task 31694:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  __do_kmalloc mm/slab.c:3660 [inline]
  __kmalloc+0x15c/0x740 mm/slab.c:3669
  kmalloc include/linux/slab.h:552 [inline]
  sk_prot_alloc+0x19c/0x2e0 net/core/sock.c:1608
  sk_alloc+0x39/0xf70 net/core/sock.c:1662
  nr_create+0xb9/0x5e0 net/netrom/af_netrom.c:436
  __sock_create+0x3d8/0x730 net/socket.c:1430
  sock_create net/socket.c:1481 [inline]
  __sys_socket+0x103/0x220 net/socket.c:1523
  __do_sys_socket net/socket.c:1532 [inline]
  __se_sys_socket net/socket.c:1530 [inline]
  __x64_sys_socket+0x73/0xb0 net/socket.c:1530
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 31693:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kfree+0xcf/0x220 mm/slab.c:3755
  sk_prot_free net/core/sock.c:1645 [inline]
  __sk_destruct+0x4f7/0x6e0 net/core/sock.c:1731
  sk_destruct+0x7b/0x90 net/core/sock.c:1739
  __sk_free+0xce/0x300 net/core/sock.c:1750
  sk_free+0x42/0x50 net/core/sock.c:1761
  sock_put include/net/sock.h:1728 [inline]
  nr_release+0x332/0x3b0 net/netrom/af_netrom.c:557
  __sock_release+0xce/0x2a0 net/socket.c:607
  sock_close+0x1b/0x30 net/socket.c:1279
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88807bd1a340
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
  2048-byte region [ffff88807bd1a340, ffff88807bd1ab40)
The buggy address belongs to the page:
page:ffffea0001ef4680 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0xffff88807bd1b440 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002a48788 ffffea00018fc508 ffff8880aa400c40
raw: ffff88807bd1b440 ffff88807bd1a340 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88807bd1a280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88807bd1a300: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> ffff88807bd1a380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                            ^
  ffff88807bd1a400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88807bd1a480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
