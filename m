Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56941420FD
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgASX5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:57:10 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:34138 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgASX5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:57:10 -0500
Received: by mail-io1-f71.google.com with SMTP id n26so18859606ioj.1
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 15:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bLPqWS4gmEOy+ebIjShF5FIOX/9QRtrFBn3FMxw6QXs=;
        b=LAGfTLreD+tZabY4HiitDcUadCEoSUdXb95Xlp9+sIwr0DEZnGb7w6YtDO4jQ3XETv
         HVjfeohNz6mcWZCjoDNdvsskMHFn1sc+UfjiflZxaaike+ZTKPkDMa95RQ/u8fAL6EGr
         7rnpcdgZcvoGDpq0mRVVP61oiaCEOLBFkHr89blhurfhLSMsiUQg4uR0M5bq/p7pj+Ya
         Qh6CJ1TO+8343p0QzDFHYXK+L9pr/xmJorW6S3QkV2ae9uwE0VtQFkJt2tGUHNLMoFNq
         b5CErfnhsJ3j7aPQ8E9DhFgsFRnlL2OdQWRxrUv2XEN7tDD6wcQLQeOfnJHdEKBEFH1g
         AhUw==
X-Gm-Message-State: APjAAAVN7fuGILghgxHH2Eb7RpDupoO26uG2PmJbpuzHLg6J3svkEmB2
        QusgljUsJ51G0GDNMUqfRVNEXziuP6zB2+JJexUvpIJMWlLm
X-Google-Smtp-Source: APXvYqwPpL0xTTd1D48oUxavZRVDVk5XcOR8lZt7YI4FSZl5VF8NRmyQXbwLbZ9viUPjFYhUcIuZdXo6v49UUHX22lIzmPMhYFoj
MIME-Version: 1.0
X-Received: by 2002:a92:9f1a:: with SMTP id u26mr8825182ili.72.1579478229160;
 Sun, 19 Jan 2020 15:57:09 -0800 (PST)
Date:   Sun, 19 Jan 2020 15:57:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c7999e059c86eebe@google.com>
Subject: KASAN: use-after-free Read in bitmap_ipmac_ext_cleanup
From:   syzbot <syzbot+33fc3ad6fa11675e1a7e@syzkaller.appspotmail.com>
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

HEAD commit:    7f013ede Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11c41495e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=33fc3ad6fa11675e1a7e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15102cc9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e38faee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+33fc3ad6fa11675e1a7e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: use-after-free in bitmap_ipmac_ext_cleanup+0xd8/0x290 net/netfilter/ipset/ip_set_bitmap_gen.h:51
Read of size 8 at addr ffff8880a2ac3a40 by task syz-executor324/9651

CPU: 0 PID: 9651 Comm: syz-executor324 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
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
 bitmap_ipmac_ext_cleanup+0xd8/0x290 net/netfilter/ipset/ip_set_bitmap_gen.h:51
 bitmap_ipmac_destroy+0x17c/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:65
 ip_set_create+0xe47/0x1500 net/netfilter/ipset/ip_set_core.c:1165
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442239
Code: e8 6c aa 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc7958b8c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000442239
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 0000000000016edc R08: 00000000004030f0 R09: 00000000004030f0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000403060
R13: 00000000004030f0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9651:
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
 init_map_ipmac net/netfilter/ipset/ip_set_bitmap_ipmac.c:302 [inline]
 bitmap_ipmac_create+0x4e8/0xa00 net/netfilter/ipset/ip_set_bitmap_ipmac.c:365
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9651:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 kvfree+0x61/0x70 mm/util.c:603
 ip_set_free+0x16/0x20 net/netfilter/ipset/ip_set_core.c:276
 bitmap_ipmac_destroy+0xae/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:63
 ip_set_create+0xe47/0x1500 net/netfilter/ipset/ip_set_core.c:1165
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a2ac3a40
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a2ac3a40, ffff8880a2ac3a60)
The buggy address belongs to the page:
page:ffffea00028ab0c0 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff8880a2ac3fc1
raw: 00fffe0000000200 ffffea000293f948 ffffea00025764c8 ffff8880aa4001c0
raw: ffff8880a2ac3fc1 ffff8880a2ac3000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a2ac3900: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a2ac3980: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880a2ac3a00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
                                           ^
 ffff8880a2ac3a80: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
 ffff8880a2ac3b00: fb fb fb fb fc fc fc fc 00 03 fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
