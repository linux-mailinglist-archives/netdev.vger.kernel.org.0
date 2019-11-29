Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7676F10D251
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfK2IQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:16:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:39782 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfK2IQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 03:16:10 -0500
Received: by mail-io1-f70.google.com with SMTP id u13so17434944iol.6
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 00:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=AwcCGb7KsCpa79UEtOA464CD/IKJAmHuJiBH6WO8loY=;
        b=n1QOSH5jOGQ87NYBIEQsmrRiUU1amUUI0phk9Tp0PuOuzEZfuYodMp4eMAhwIt5muy
         XK0mjTN24eI0Vjvr0M43lFlKjYIkrsIcjRoGEZModTgVaMFR6slJSDNu+ox3Ax4kwmxc
         /xB/7YDQG00jSGRL8xk8MBSecsse1C15JKq3pf5I8k2QNs6SvdKrmc0YkjhvTyvEiApj
         c+HVta+Yw9t8pB7GvfnDcZu4igKsPou9ZzIKqLOKTtde66uvKqtLvLdxL+lOklP7uUtQ
         GBX+esVLkipqMtDPZX5JFoK46XAcByaiByePK3BQqZC91YRaWvyAUl9k1iHI5TvxD67R
         rVxQ==
X-Gm-Message-State: APjAAAUO1LcIeqfBuZGKX0YhLHDJIuGB2K1isxrkkI/JwT5LfknukDz0
        D53N4cRJth/4AyCLlgLTVJc0Rd8t5pbh0rel5bqqXBcQK1Qa
X-Google-Smtp-Source: APXvYqwFHk6mxg2Lu7CRNOnD1s8Ows1XQz2PxL+0+NcYkpVSNXDEpE1frZBQ2NJoHouaLAxAdZqR3W2tJb7p9vHct1Hh6EvHQeFH
MIME-Version: 1.0
X-Received: by 2002:a5d:9b08:: with SMTP id y8mr7598324ion.108.1575015367819;
 Fri, 29 Nov 2019 00:16:07 -0800 (PST)
Date:   Fri, 29 Nov 2019 00:16:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000083c858059877d77c@google.com>
Subject: KASAN: use-after-free Write in nr_release
From:   syzbot <syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com>
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

HEAD commit:    81b6b964 Merge branch 'master' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1553197ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6349516b24252b37
dashboard link: https://syzkaller.appspot.com/bug?extid=caa188bdfc1eeafeb418
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_fetch_add  
include/asm-generic/atomic-instrumented.h:111 [inline]
BUG: KASAN: use-after-free in refcount_add include/linux/refcount.h:188  
[inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:228  
[inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:648 [inline]
BUG: KASAN: use-after-free in nr_release+0x65/0x4c0  
net/netrom/af_netrom.c:498
Write of size 4 at addr ffff88805abb0080 by task syz-executor.1/8686

CPU: 1 PID: 8686 Comm: syz-executor.1 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  __kasan_check_write+0x14/0x20 mm/kasan/common.c:98
  atomic_fetch_add include/asm-generic/atomic-instrumented.h:111 [inline]
  refcount_add include/linux/refcount.h:188 [inline]
  refcount_inc include/linux/refcount.h:228 [inline]
  sock_hold include/net/sock.h:648 [inline]
  nr_release+0x65/0x4c0 net/netrom/af_netrom.c:498
  __sock_release+0xce/0x280 net/socket.c:591
  sock_close+0x1e/0x30 net/socket.c:1269
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x414211
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffdfe3cb280 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 000000000000000a RCX: 0000000000414211
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
RBP: 0000000000000001 R08: 000000008135072a R09: ffffffffffffffff
R10: 00007ffdfe3cb360 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 0000000000761a30 R15: 000000000075bf2c

Allocated by task 8697:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc include/linux/slab.h:561 [inline]
  sk_prot_alloc+0x23a/0x310 net/core/sock.c:1603
  sk_alloc+0x39/0xfd0 net/core/sock.c:1657
  nr_create+0xb9/0x5e0 net/netrom/af_netrom.c:411
  __sock_create+0x3ce/0x730 net/socket.c:1419
  sock_create net/socket.c:1470 [inline]
  __sys_socket+0x103/0x220 net/socket.c:1512
  __do_sys_socket net/socket.c:1521 [inline]
  __se_sys_socket net/socket.c:1519 [inline]
  __x64_sys_socket+0x73/0xb0 net/socket.c:1519
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8686:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1640 [inline]
  __sk_destruct+0x4fc/0x6f0 net/core/sock.c:1724
  sk_destruct+0xd5/0x110 net/core/sock.c:1739
  __sk_free+0xfb/0x360 net/core/sock.c:1750
  sk_free+0x83/0xb0 net/core/sock.c:1761
  sock_put include/net/sock.h:1729 [inline]
  nr_release+0x3f4/0x4c0 net/netrom/af_netrom.c:532
  __sock_release+0xce/0x280 net/socket.c:591
  sock_close+0x1e/0x30 net/socket.c:1269
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88805abb0000
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
  2048-byte region [ffff88805abb0000, ffff88805abb0800)
The buggy address belongs to the page:
page:ffffea00016aec00 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0
raw: 01fffc0000000200 ffffea00016eaa48 ffffea000276f1c8 ffff8880aa400e00
raw: 0000000000000000 ffff88805abb0000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88805abaff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88805abb0000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88805abb0080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff88805abb0100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88805abb0180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
