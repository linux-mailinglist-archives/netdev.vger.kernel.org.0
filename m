Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D95E7780E
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfG0KCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:02:10 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52478 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbfG0KCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:02:10 -0400
Received: by mail-io1-f71.google.com with SMTP id p12so61544324iog.19
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zWQKKZIrJCP94WNsAhl6Mgx7aVCzU5BMz5E1nzrFKXs=;
        b=K1fgQdnm1TwpUyh8dbkpuRfP7KEVUlartmFbc4T6oul9jCS17dbsKo6UOhx9uerUF2
         HIAJSmpXzmD7/POcy0Dd6xsCMopRirKCsIZQdX/6d1ZgbbWJZgpd7+VaUE6URnLJR1Ut
         gdkWNn/EllN/PRZMCPJy0sttjC1kyE6TSk/rVFRoqLtv3mT5/wCZarrMpdwiKxwaSpmf
         fqz6A/UWo145lB8zeZk1+Ro5luuvPkGU1IJHZ7/izhlaJc8qYAK9cpU319BTxxzKUdEm
         Frr9WpHmDW1mUAiP0/K8X+lmiuIQYjRHDQaRDv/DEnJqpl6YbaaOHYgxQgyteOdQbzds
         nBFA==
X-Gm-Message-State: APjAAAVKxOc0BeEMDPOjLCIm761xjdnhx+hEvzkHOga33vmLa0aE2PAy
        ZKh/MLw5WdQPf6qY4AZHnNYWyDZrLsCAzYFOmzhnkBHpm3u8
X-Google-Smtp-Source: APXvYqwDpi85ToVNt+Ziy7ofcwoq85M6ak47hMWTz1/I+jhaKy+daiRqj8UfNzqf3Eq8zDV7ANCErGRibvrnTHrkYd5fw9kf1FHg
MIME-Version: 1.0
X-Received: by 2002:a02:9991:: with SMTP id a17mr74112620jal.1.1564221306158;
 Sat, 27 Jul 2019 02:55:06 -0700 (PDT)
Date:   Sat, 27 Jul 2019 02:55:06 -0700
In-Reply-To: <0000000000007e8b70058acbd60f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004dc9c9058ea6a755@google.com>
Subject: Re: KASAN: use-after-free Read in nr_release
From:   syzbot <syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    3ea54d9b Merge tag 'docs-5.3-1' of git://git.lwn.net/linux
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=140a9794600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4809ada7c73f0407
dashboard link: https://syzkaller.appspot.com/bug?extid=6eaef7158b19e3fec3a0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156f25a2600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13fae0e8600000

The bug was bisected to:

commit c8c8218ec5af5d2598381883acbefbf604e56b5e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jun 27 21:30:58 2019 +0000

     netrom: fix a memory leak in nr_rx_frame()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a3bcd0600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a3bcd0600000
console output: https://syzkaller.appspot.com/x/log.txt?x=14a3bcd0600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com
Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x81/0x200  
lib/refcount.c:123
Read of size 4 at addr ffff888093589300 by task syz-executor118/6083

CPU: 1 PID: 6083 Comm: syz-executor118 Not tainted 5.3.0-rc1+ #85
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:612
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
RIP: 0033:0x406901
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 24 1a 00 00 c3 48  
83 ec 08 e8 6a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 b3 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffede643710 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000406901
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000006dcc30 R08: 0000000120080522 R09: 0000000120080522
R10: 00007ffede643730 R11: 0000000000000293 R12: 00007ffede643760
R13: 0000000000000004 R14: 00000000006dcc3c R15: 0000000000000064

Allocated by task 0:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc include/linux/slab.h:557 [inline]
  sk_prot_alloc+0x23a/0x310 net/core/sock.c:1603
  sk_alloc+0x39/0xf70 net/core/sock.c:1657
  nr_make_new net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0x733/0x1e73 net/netrom/af_netrom.c:959
  nr_loopback_timer+0x7b/0x170 net/netrom/nr_loopback.c:59
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c kernel/softirq.c:292

Freed by task 6086:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1640 [inline]
  __sk_destruct+0x4f7/0x6e0 net/core/sock.c:1726
  sk_destruct+0x86/0xa0 net/core/sock.c:1734
  __sk_free+0xfb/0x360 net/core/sock.c:1745
  sk_free+0x42/0x50 net/core/sock.c:1756
  sock_put include/net/sock.h:1725 [inline]
  sock_efree+0x61/0x80 net/core/sock.c:2042
  skb_release_head_state+0xeb/0x250 net/core/skbuff.c:652
  skb_release_all+0x16/0x60 net/core/skbuff.c:663
  __kfree_skb net/core/skbuff.c:679 [inline]
  kfree_skb net/core/skbuff.c:697 [inline]
  kfree_skb+0x101/0x3c0 net/core/skbuff.c:691
  nr_accept+0x56e/0x700 net/netrom/af_netrom.c:819
  __sys_accept4+0x34e/0x6a0 net/socket.c:1754
  __do_sys_accept4 net/socket.c:1789 [inline]
  __se_sys_accept4 net/socket.c:1786 [inline]
  __x64_sys_accept4+0x97/0xf0 net/socket.c:1786
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888093589280
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
  2048-byte region [ffff888093589280, ffff888093589a80)
The buggy address belongs to the page:
page:ffffea00024d6200 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000228a508 ffffea00024cef08 ffff8880aa400e00
raw: 0000000000000000 ffff888093588180 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888093589200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff888093589280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888093589300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff888093589380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888093589400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
------------[ cut here ]------------
ODEBUG: activate not available (active state 0) object type: timer_list  
hint: nr_t1timer_expiry+0x0/0x340 net/netrom/nr_timer.c:157
WARNING: CPU: 1 PID: 6083 at lib/debugobjects.c:481  
debug_print_object+0x168/0x250 lib/debugobjects.c:481
Modules linked in:
CPU: 1 PID: 6083 Comm: syz-executor118 Tainted: G    B              
5.3.0-rc1+ #85
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:debug_print_object+0x168/0x250 lib/debugobjects.c:481
Code: dd e0 30 c6 87 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48  
8b 14 dd e0 30 c6 87 48 c7 c7 e0 25 c6 87 e8 50 c3 05 fe <0f> 0b 83 05 33  
4d 67 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
RSP: 0018:ffff888089fbfaf0 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c5bd6 RDI: ffffed10113f7f50
RBP: ffff888089fbfb30 R08: ffff8880924ea140 R09: fffffbfff134ac80
R10: fffffbfff134ac7f R11: ffffffff89a563ff R12: 0000000000000001
R13: ffffffff88db6460 R14: ffffffff8161fa40 R15: 1ffff110113f7f6c
FS:  0000555555b49880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f63ae9fde78 CR3: 000000009873d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  debug_object_activate+0x2e5/0x470 lib/debugobjects.c:680
  debug_timer_activate kernel/time/timer.c:710 [inline]
  __mod_timer kernel/time/timer.c:1035 [inline]
  mod_timer+0x452/0xc10 kernel/time/timer.c:1096
  sk_reset_timer+0x24/0x60 net/core/sock.c:2821
  nr_start_t1timer+0x6e/0xa0 net/netrom/nr_timer.c:52
  nr_release+0x1de/0x3e0 net/netrom/af_netrom.c:537
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
RIP: 0033:0x406901
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 24 1a 00 00 c3 48  
83 ec 08 e8 6a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 b3 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffede643710 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000406901
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000006dcc30 R08: 0000000120080522 R09: 0000000120080522
R10: 00007ffede643730 R11: 0000000000000293 R12: 00007ffede643760
R13: 0000000000000004 R14: 00000000006dcc3c R15: 0000000000000064
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<ffffffff81437c05>]  
copy_process+0x1815/0x6b00 kernel/fork.c:1960
softirqs last  enabled at (0): [<ffffffff81437cac>]  
copy_process+0x18bc/0x6b00 kernel/fork.c:1963
softirqs last disabled at (0): [<0000000000000000>] 0x0
---[ end trace f5b6f61236ba2f96 ]---
------------[ cut here ]------------

