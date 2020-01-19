Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E3E1420C4
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgASXRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:17:11 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:42186 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbgASXRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:17:10 -0500
Received: by mail-io1-f70.google.com with SMTP id e7so18770089iog.9
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 15:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=o7NxxVjuXhzckD2wvrNsaxZRFmEA1IgP3Ag9532iMjc=;
        b=iYtZyalRwMDu18uJ6hMnMgIs+DQP65vekuQ75sYkoUomxTSb8GdBXlz/Vc+RVRBKFI
         N6cetMOwALoWUVbEB8vU4U/TA5TQcMjBgB4ZAU/pwp1q7BAOlGnlXXCVAQgMZmj62WDW
         7P5/F73kVjA/uZtFoYKqOkzZf2A0CSEletk56POITphe6IQRRfBzSxvb5C5gFYMDut6v
         U9u7nsoRlMNzNHhGtOe2DhamMLGh4WocN5tVK0FNUZXN3fMPGoFAbFisXRhWm2M8ti0N
         nlX/s2Ce3hazzoKFACKcOqxecFZtPCzpRpkj0rHuie3HFkDaX+fmCWKY8gVxQZVXBU40
         dbNg==
X-Gm-Message-State: APjAAAWB7+UcNdxRbdfN39oF0Zv016mMF69xRl6VrkWaN2Y7xWRFsSox
        +R4QnbBNjDkVAUGNx0HJPPZNDWYRRdIew3O6DRfQ12/orQjJ
X-Google-Smtp-Source: APXvYqwxDxyPxdB9mz6fz4rP2N6TpCZbkslR9r3ez5A05iHVluh495cBP8LmLgR+ghqnnjTyQKiyBLqsjhMlO6yVjLmFpPnScpv1
MIME-Version: 1.0
X-Received: by 2002:a6b:8e47:: with SMTP id q68mr37912695iod.274.1579475829193;
 Sun, 19 Jan 2020 15:17:09 -0800 (PST)
Date:   Sun, 19 Jan 2020 15:17:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bb0378059c865fdf@google.com>
Subject: KASAN: use-after-free Read in bitmap_ip_destroy
From:   syzbot <syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com>
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

HEAD commit:    8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1327fa85e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=8b5f151de2f35100bbc5
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e22559e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16056faee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: use-after-free in bitmap_ip_ext_cleanup net/netfilter/ipset/ip_set_bitmap_gen.h:51 [inline]
BUG: KASAN: use-after-free in bitmap_ip_destroy+0x1f2/0x3c0 net/netfilter/ipset/ip_set_bitmap_gen.h:65
Read of size 8 at addr ffff888096ae7ec0 by task syz-executor670/8711

CPU: 0 PID: 8711 Comm: syz-executor670 Not tainted 5.5.0-rc6-syzkaller #0
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
 bitmap_ip_ext_cleanup net/netfilter/ipset/ip_set_bitmap_gen.h:51 [inline]
 bitmap_ip_destroy+0x1f2/0x3c0 net/netfilter/ipset/ip_set_bitmap_gen.h:65
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
RIP: 0033:0x441459
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc4e627408 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441459
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 000000000001283d R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402280
R13: 0000000000402310 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8711:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:513
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x254/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc+0x21/0x40 include/linux/slab.h:670
 ip_set_alloc+0x32/0x60 net/netfilter/ipset/ip_set_core.c:255
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x48b/0xac0 net/netfilter/ipset/ip_set_bitmap_ip.c:327
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

Freed by task 8711:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10d/0x220 mm/slab.c:3757
 kvfree+0x46/0x50 mm/util.c:603
 ip_set_free+0x15/0x20 net/netfilter/ipset/ip_set_core.c:276
 bitmap_ip_destroy+0xb6/0x3c0 net/netfilter/ipset/ip_set_bitmap_gen.h:63
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

The buggy address belongs to the object at ffff888096ae7ec0
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff888096ae7ec0, ffff888096ae7ee0)
The buggy address belongs to the page:
page:ffffea00025ab9c0 refcount:1 mapcount:0 mapping:ffff8880aa8001c0 index:0xffff888096ae7fc1
raw: 00fffe0000000200 ffffea00027e2388 ffffea0002844388 ffff8880aa8001c0
raw: ffff888096ae7fc1 ffff888096ae7000 000000010000003a 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888096ae7d80: fb fb fb fb fc fc fc fc 00 00 01 fc fc fc fc fc
 ffff888096ae7e00: 00 02 fc fc fc fc fc fc 00 00 00 fc fc fc fc fc
>ffff888096ae7e80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
                                           ^
 ffff888096ae7f00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff888096ae7f80: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
