Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40037141DE0
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 13:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgASM5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 07:57:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:57037 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgASM5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 07:57:09 -0500
Received: by mail-il1-f198.google.com with SMTP id i68so23036166ill.23
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 04:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yrkN12Ir9F+vfz2Dvlu3TxsW0aKOP5JdAFcCDbRPRq4=;
        b=lCHnENRGxNlyDxhk/hXAAaFN8/bgAJjN2rimm/Qb1BqJWaLO+CATIQrCFxN9NH7aB2
         RIC7X7QklkP232u/r6UZ5+llICRAm+96TLFgrQq3ludMWKZ39H2tnMGwXKYHxsnY7Xl5
         IJFi2FGeVojp+cZwBqtlIlQA3LnQfXLoFSQIR0PtY8/NmNKRQK1Ec74IUzm9zGYQ+Fgw
         X8LlZKQvCP8IIxqVJq8psUqLiSrU/bQzPbG4aL7wAxkQe0Eb3pmKtS8kKzEaRa5/q+yB
         VZZSlItPcxaCUkyF7a4NY6nHqsn/3g8C0TtOQneLn7PGfIYYfHnBP0WbYjeOq+wIxUQ3
         RQjg==
X-Gm-Message-State: APjAAAUZ2u9HQse6OWs+rHNx5Pm1Uk46JqgySKoFbjKlUSiKfB+ve7KY
        Km1IReh4TmigxaSUJ/m8G4hqLDjsKSgKscrm23I6D7ji1p3k
X-Google-Smtp-Source: APXvYqzXry5dROEGnvmNmukmqlTHlZQ/OaEER9EuMeh1HL4CYRynZXhT77mjwRzsClNwyZydcIRXcGK0/a47cIZJBhm2SuSCkbDe
MIME-Version: 1.0
X-Received: by 2002:a6b:b683:: with SMTP id g125mr39422291iof.197.1579438629024;
 Sun, 19 Jan 2020 04:57:09 -0800 (PST)
Date:   Sun, 19 Jan 2020 04:57:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d7b1e059c7db653@google.com>
Subject: KASAN: use-after-free Read in bitmap_ip_ext_cleanup
From:   syzbot <syzbot+b554d01b6c7870b17da2@syzkaller.appspotmail.com>
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

HEAD commit:    9aaa2949 Merge branch '1GbE' of git://git.kernel.org/pub/s..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1012b166e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=b554d01b6c7870b17da2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15db12a5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15316faee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b554d01b6c7870b17da2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: use-after-free in bitmap_ip_ext_cleanup+0xd8/0x290 net/netfilter/ipset/ip_set_bitmap_gen.h:51
Read of size 8 at addr ffff8880a7ca67c0 by task syz-executor319/9852

CPU: 0 PID: 9852 Comm: syz-executor319 Not tainted 5.5.0-rc5-syzkaller #0
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
 bitmap_ip_ext_cleanup+0xd8/0x290 net/netfilter/ipset/ip_set_bitmap_gen.h:51
 bitmap_ip_destroy+0x17c/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:65
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
RIP: 0033:0x441459
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe37820b08 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441459
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 0000000000012efc R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402280
R13: 0000000000402310 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9852:
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
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x6ec/0xc20 net/netfilter/ipset/ip_set_bitmap_ip.c:327
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

Freed by task 9852:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 kvfree+0x61/0x70 mm/util.c:603
 ip_set_free+0x16/0x20 net/netfilter/ipset/ip_set_core.c:276
 bitmap_ip_destroy+0xae/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:63
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

The buggy address belongs to the object at ffff8880a7ca67c0
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a7ca67c0, ffff8880a7ca67e0)
The buggy address belongs to the page:
page:ffffea00029f2980 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff8880a7ca6fc1
raw: 00fffe0000000200 ffffea00026bfc88 ffffea00027d0708 ffff8880aa4001c0
raw: ffff8880a7ca6fc1 ffff8880a7ca6000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a7ca6680: 04 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a7ca6700: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
>ffff8880a7ca6780: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
                                           ^
 ffff8880a7ca6800: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
 ffff8880a7ca6880: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
