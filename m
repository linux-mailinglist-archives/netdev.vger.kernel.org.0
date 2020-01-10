Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0013764F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgAJSoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:44:23 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:40950 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgAJSoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:44:12 -0500
Received: by mail-io1-f70.google.com with SMTP id e200so2096105iof.7
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 10:44:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tk7IzU1+Ff+iBlcp7kcc9OnaVKjvRQkgJFkjelqPdrU=;
        b=mjKGZ76pBCA1oAZ2c8AdRggmITIjDpGznCVsVV3+4jvRVzHnTy3nxDJgPLRF7KHixd
         BXOPpw/que3Cff1MOOdLsJICHB+9UcxLvHDR3ETIykA4rXZb+2LpRsCZ7eofgJ5Q56uY
         9MvXdtM5ljBNAlQAGAsVujSx9hO0VBpy/HCTDPg/KHbRpjTYbIRHziZ4uUBbytOG73nG
         rwGpYw2UIS5iJrZwVLuh9PCYhqowUgsUTreJVjXGOn2wq1nvKcV9ciSWQvpOouWyvP7I
         4BhjZ1WTK1WxERPFNy/7M2V8sHsIFLYR/2AdIF7OUZYwZE1izGmbqVjtvmLQITg06fuV
         1zTw==
X-Gm-Message-State: APjAAAWrnNUOVPcjXJUDKWcisKtkPMsSgTAZjKANw8SaXpEwILerzc+F
        xxhIp/wyEuLPQQzPol8tfVNoxzWxBzPSwOmgisfk7KFq/ex+
X-Google-Smtp-Source: APXvYqzmOhJxEVf32F17vjKnNYfCU5gBhsnzuAA1+G40B6JgFWlk+6DkHBLgXI0NjCCcSuPYDm6xh9c/4vr3cWrhFZi51vgtmrKP
MIME-Version: 1.0
X-Received: by 2002:a92:d3c6:: with SMTP id c6mr3996515ilh.228.1578681851394;
 Fri, 10 Jan 2020 10:44:11 -0800 (PST)
Date:   Fri, 10 Jan 2020 10:44:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f744e0059bcd8216@google.com>
Subject: KASAN: use-after-free Read in bitmap_port_ext_cleanup
From:   syzbot <syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b07f636f Merge tag 'tpmdd-next-20200108' of git://git.infr..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c03259e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=4c3cc6dbe7259dbf9054
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c365c6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117df9e1e00000

The bug was bisected to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

     hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118759e1e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=138759e1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=158759e1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

==================================================================
BUG: KASAN: use-after-free in test_bit  
include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: use-after-free in bitmap_port_ext_cleanup+0xe6/0x2a0  
net/netfilter/ipset/ip_set_bitmap_gen.h:51
Read of size 8 at addr ffff8880a87a47c0 by task syz-executor559/9563

CPU: 0 PID: 9563 Comm: syz-executor559 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:639
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
  test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
  bitmap_port_ext_cleanup+0xe6/0x2a0  
net/netfilter/ipset/ip_set_bitmap_gen.h:51
  bitmap_port_destroy+0x17c/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:65
  ip_set_create+0xe47/0x1500 net/netfilter/ipset/ip_set_core.c:1165
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __compat_sys_sendmsg net/compat.c:642 [inline]
  __do_compat_sys_sendmsg net/compat.c:649 [inline]
  __se_compat_sys_sendmsg net/compat.c:646 [inline]
  __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:646
  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
  do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f8ea39
Code: 00 00 00 89 d3 5b 5e 5f 5d c3 b8 80 96 98 00 eb c4 8b 04 24 c3 8b 1c  
24 c3 8b 34 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffc15a2c EFLAGS: 00000202 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020001080
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffc15b44
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9563:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
  __do_kmalloc mm/slab.c:3656 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3665
  kmalloc include/linux/slab.h:561 [inline]
  kzalloc include/linux/slab.h:670 [inline]
  ip_set_alloc+0x38/0x5e net/netfilter/ipset/ip_set_core.c:255
  init_map_port net/netfilter/ipset/ip_set_bitmap_port.c:234 [inline]
  bitmap_port_create+0x3dc/0x7c0 net/netfilter/ipset/ip_set_bitmap_port.c:276
  ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __compat_sys_sendmsg net/compat.c:642 [inline]
  __do_compat_sys_sendmsg net/compat.c:649 [inline]
  __se_compat_sys_sendmsg net/compat.c:646 [inline]
  __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:646
  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
  do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 9563:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  kasan_set_free_info mm/kasan/common.c:335 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3757
  kvfree+0x61/0x70 mm/util.c:603
  ip_set_free+0x16/0x20 net/netfilter/ipset/ip_set_core.c:276
  bitmap_port_destroy+0xae/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:63
  ip_set_create+0xe47/0x1500 net/netfilter/ipset/ip_set_core.c:1165
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __compat_sys_sendmsg net/compat.c:642 [inline]
  __do_compat_sys_sendmsg net/compat.c:649 [inline]
  __se_compat_sys_sendmsg net/compat.c:646 [inline]
  __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:646
  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
  do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

The buggy address belongs to the object at ffff8880a87a47c0
  which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
  32-byte region [ffff8880a87a47c0, ffff8880a87a47e0)
The buggy address belongs to the page:
page:ffffea0002a1e900 refcount:1 mapcount:0 mapping:ffff8880aa4001c0  
index:0xffff8880a87a4fc1
raw: 00fffe0000000200 ffffea0002a25108 ffffea00027a3188 ffff8880aa4001c0
raw: ffff8880a87a4fc1 ffff8880a87a4000 000000010000002e 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a87a4680: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff8880a87a4700: fb fb fb fb fc fc fc fc 00 05 fc fc fc fc fc fc
> ffff8880a87a4780: 00 05 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
                                            ^
  ffff8880a87a4800: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff8880a87a4880: 06 fc fc fc fc fc fc fc 00 00 fc fc fc fc fc fc
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
