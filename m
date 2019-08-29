Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF0A1871
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfH2L2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:28:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:52375 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbfH2L2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 07:28:08 -0400
Received: by mail-io1-f72.google.com with SMTP id q5so3574275iof.19
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 04:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jm0AoHzXqdgzw5LLLgvxIqcYRxO7mGVi27Qk0d1O4E4=;
        b=N3YjxuwVq2WwrrKl3Fw1Iq6cGyh4+CNR22S91jq5e8mmPuPnGYGlcozeBpsPH+/X5M
         9jwrilH75lJuKwYj2pCwgWcklGUy5R/Rj87wtL3EaiBZyijjjaRgT49JKZSX7GyZqoKJ
         KtV+0KLwnocbr5yJAU9ZBz5KSEeUMOcOw7B19Oli4kKym4BlfXefdfZxPA/9MGH8z9ox
         rfrgIBr5Wdtu6g+MClmfp02VymQL+K5ZBVI1EBQEOnARmLHqhDprMsSIGSX4uVySdqWn
         /DnQxTSziH7jLvQF1BiACJWys2vXl2GROwE0wQsttd7mMPJDuu53hfP7UcsfF/4gK5HR
         7jtA==
X-Gm-Message-State: APjAAAXARmLONFZdyjQ5UfwGJf4k9uLrYoTDSmCfeevV5JxsheENR4z2
        7nLpsLzRVsMhM/rtEj00MEqN+Tez2o+f9F7rewIyf9mO7zp2
X-Google-Smtp-Source: APXvYqwqUCZfDytgW8WQRfldcOib9wfo8lV7j7B+lMVeBmVKUfAlZK8vs/1Md2nS+NvNXA4QlQN2sGnE1VwnDOlb/+2FnX8Ls433
MIME-Version: 1.0
X-Received: by 2002:a02:4e43:: with SMTP id r64mr6978224jaa.34.1567078087463;
 Thu, 29 Aug 2019 04:28:07 -0700 (PDT)
Date:   Thu, 29 Aug 2019 04:28:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd21b205913fccfa@google.com>
Subject: KASAN: use-after-free Read in nr_release (2)
From:   syzbot <syzbot+fd05016a0b263a41eb33@syzkaller.appspotmail.com>
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

HEAD commit:    6525771f Merge tag 'arc-5.3-rc7' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11f44d82600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a6a2b9826fdadf9
dashboard link: https://syzkaller.appspot.com/bug?extid=fd05016a0b263a41eb33
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16c627ca600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fd05016a0b263a41eb33@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x81/0x200  
lib/refcount.c:123
Read of size 4 at addr ffff888094849540 by task syz-executor.2/9817

CPU: 1 PID: 9817 Comm: syz-executor.2 Not tainted 5.3.0-rc6+ #128
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:618
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  __kasan_check_read+0x11/0x20 mm/kasan/common.c:92
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  refcount_inc_not_zero_checked+0x81/0x200 lib/refcount.c:123
  refcount_inc_checked+0x17/0x70 lib/refcount.c:156
  sock_hold include/net/sock.h:649 [inline]
  nr_release+0x62/0x3e0 net/netrom/af_netrom.c:520
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413561
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffcd6d6ea60 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000413561
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 00007ffcd6d6eb40 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 0000000000761aa0 R15: ffffffffffffffff

Allocated by task 9818:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:493 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:466
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:507
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc include/linux/slab.h:557 [inline]
  sk_prot_alloc+0x23a/0x310 net/core/sock.c:1603
  sk_alloc+0x39/0xf70 net/core/sock.c:1657
  nr_create+0xb9/0x5e0 net/netrom/af_netrom.c:433
  __sock_create+0x3d8/0x730 net/socket.c:1418
  sock_create net/socket.c:1469 [inline]
  __sys_socket+0x103/0x220 net/socket.c:1511
  __do_sys_socket net/socket.c:1520 [inline]
  __se_sys_socket net/socket.c:1518 [inline]
  __x64_sys_socket+0x73/0xb0 net/socket.c:1518
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9817:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:455
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:463
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1640 [inline]
  __sk_destruct+0x4f7/0x6e0 net/core/sock.c:1726
  sk_destruct+0x86/0xa0 net/core/sock.c:1734
  __sk_free+0xfb/0x360 net/core/sock.c:1745
  sk_free+0x42/0x50 net/core/sock.c:1756
  sock_put include/net/sock.h:1725 [inline]
  nr_release+0x356/0x3e0 net/netrom/af_netrom.c:554
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880948494c0
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
  2048-byte region [ffff8880948494c0, ffff888094849cc0)
The buggy address belongs to the page:
page:ffffea0002521200 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00024ff508 ffffea0002560088 ffff8880aa400e00
raw: 0000000000000000 ffff8880948483c0 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888094849400: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff888094849480: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> ffff888094849500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                            ^
  ffff888094849580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888094849600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
