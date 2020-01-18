Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD3141872
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 17:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgARQhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 11:37:12 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:55816 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgARQhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 11:37:11 -0500
Received: by mail-il1-f200.google.com with SMTP id p8so21473245ilp.22
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 08:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oHMk30k/8GxhsmxZEdWC76nXuYoxUYefnJNRsWX1wVw=;
        b=ME5JquOIA+4UaWopm0/2o07orsU3ZK0awv6q0NT4bRsc9l/QLCTBJPptsxxaGNjGyT
         s9lxaQ5U7SN6QoGzk6LRKuFX6VVFjtONQM8P7MFMGg0j6/+Tv9iU5MseRmFkp60z5T7l
         /TepYcugBImHLSy2wBYXFJQwOuoEAw3NCo0XGWLBUsW14HJ0IWnwww15ge6DeFiCRE/4
         7cjeCIHSpSlwOVUhrkopqtOZ8L4bo2b93vfpQXR2/lW4i65fyVizR30p4DTMoy9NOkQp
         X6WA1DMJszbA+rdoN6+tIwYt1lRlePC2vNw/c8hfyUDiKyQVrDBePrS0q9G9grEb+Qd2
         Ogsw==
X-Gm-Message-State: APjAAAU0Z0y1JPbZaYoZmcjLldxB0QknOnoaJlOAuxTGfsOZ0AwuuI7h
        t3nIKJL69o69WUim9CM5KL2U3S8CzKuMsSMCs8PvuVPIRjdp
X-Google-Smtp-Source: APXvYqwahZGeDjKh9Sl6STLzcBNrVDg8T4A+SxAK868Hid35FULGj7t6aW4bpRshbsgWWAKULERBhRLd5kUGl74PRbDRbnBVj/5C
MIME-Version: 1.0
X-Received: by 2002:a5e:8e4b:: with SMTP id r11mr36581069ioo.167.1579365430567;
 Sat, 18 Jan 2020 08:37:10 -0800 (PST)
Date:   Sat, 18 Jan 2020 08:37:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000075aa7d059c6cab3c@google.com>
Subject: KASAN: use-after-free Read in bitmap_port_destroy
From:   syzbot <syzbot+8ccfc03b082d0ab9b84b@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    25e73aad Merge tag 'io_uring-5.5-2020-01-16' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1295c8bee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=8ccfc03b082d0ab9b84b
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128db1d1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152b74c9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8ccfc03b082d0ab9b84b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: use-after-free in bitmap_port_ext_cleanup net/netfilter/ipset/ip_set_bitmap_gen.h:51 [inline]
BUG: KASAN: use-after-free in bitmap_port_destroy+0x1f2/0x3c0 net/netfilter/ipset/ip_set_bitmap_gen.h:65
Read of size 8 at addr ffff8880a5048a40 by task syz-executor419/8736

CPU: 1 PID: 8736 Comm: syz-executor419 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x149/0x1c0 mm/kasan/report.c:506
 kasan_report+0x26/0x50 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:182 [inline]
 check_memory_region+0x2b6/0x2f0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 bitmap_port_ext_cleanup net/netfilter/ipset/ip_set_bitmap_gen.h:51 [inline]
 bitmap_port_destroy+0x1f2/0x3c0 net/netfilter/ipset/ip_set_bitmap_gen.h:65
 ip_set_create+0xae0/0xfd0 net/netfilter/ipset/ip_set_core.c:1165
 nfnetlink_rcv_msg+0x9ae/0xcd0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1e0/0x1e50 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2424
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441399
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc467ccc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441399
RDX: 0000000000000000 RSI: 0000000020001080 RDI: 0000000000000003
RBP: 0000000000013851 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004021c0
R13: 0000000000402250 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8736:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:513
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x254/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc+0x21/0x40 include/linux/slab.h:670
 ip_set_alloc+0x32/0x60 net/netfilter/ipset/ip_set_core.c:255
 init_map_port net/netfilter/ipset/ip_set_bitmap_port.c:234 [inline]
 bitmap_port_create+0x32c/0x790 net/netfilter/ipset/ip_set_bitmap_port.c:276
 ip_set_create+0x421/0xfd0 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0x9ae/0xcd0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1e0/0x1e50 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2424
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8736:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10d/0x220 mm/slab.c:3757
 kvfree+0x46/0x50 mm/util.c:603
 ip_set_free+0x15/0x20 net/netfilter/ipset/ip_set_core.c:276
 bitmap_port_destroy+0xb6/0x3c0 net/netfilter/ipset/ip_set_bitmap_gen.h:63
 ip_set_create+0xae0/0xfd0 net/netfilter/ipset/ip_set_core.c:1165
 nfnetlink_rcv_msg+0x9ae/0xcd0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1e0/0x1e50 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2424
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a5048a40
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a5048a40, ffff8880a5048a60)
The buggy address belongs to the page:
page:ffffea0002941200 refcount:1 mapcount:0 mapping:ffff8880aa8001c0 index:0xffff8880a5048fc1
raw: 00fffe0000000200 ffffea0002a257c8 ffffea00029a6b88 ffff8880aa8001c0
raw: ffff8880a5048fc1 ffff8880a5048000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a5048900: 05 fc fc fc fc fc fc fc 05 fc fc fc fc fc fc fc
 ffff8880a5048980: 05 fc fc fc fc fc fc fc 00 00 01 fc fc fc fc fc
>ffff8880a5048a00: 00 00 01 fc fc fc fc fc fb fb fb fb fc fc fc fc
                                           ^
 ffff8880a5048a80: 06 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a5048b00: 00 00 01 fc fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
