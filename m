Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5267647A580
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 08:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhLTHvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 02:51:25 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:54113 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbhLTHvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 02:51:24 -0500
Received: by mail-il1-f199.google.com with SMTP id x8-20020a92dc48000000b002b2abc6e1cbso1920195ilq.20
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 23:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=k+oh/barm49OOMLCuH5Qq/8fv//gkPP4Xxv49J9PI+M=;
        b=cRo6mQ11qI9q2LrH9sMni3WIfTaOiA6NIgLt+GxsJwH5uvbM/X0G5mdAAvxlKE24lL
         oC/SnsukhQZZ13Yhx86pR2UOV8s4d29H7Ser72o7lHi3Ht+cbFrUNVN6YP6Mal6cYOGl
         y6Kqosb0qIyYW59VA/N5OnUYznBpaLwoQiKnnf2YzqfKyabYCfOl5rqnfoPni3DznBoC
         Ib17lWvw0Jd7MO2rq3hh1uV1IrcJhinLpMJ1xzSx38usM1B07q+44y2Q5zyT6J/lYjBH
         Agrc/vn4yj8v+lNpANmjpy7onwveBN5GtDoD5wG15nJJ5d6lN6mYjVxZWMbAS54+kyXM
         Ofag==
X-Gm-Message-State: AOAM531OyF34Zl0qI86WIilrcMKU9kjIRj43mWeNrB5qla7x2DSsfVfJ
        kE+oMWcMMQvWRMwJe7L8ZiVcFi8tGcFhU5GUEqXPZON1S44d
X-Google-Smtp-Source: ABdhPJy9LcoD3pXUasgvgP/+GgUTUUcnCn/gOHPhVRZodA56ei8PTFzjWujBVdKQJ/N3pIYlzq3ZwYC5nRiESq/IXCisRR5J1KRq
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a62:: with SMTP id w2mr7821608ilv.9.1639986684231;
 Sun, 19 Dec 2021 23:51:24 -0800 (PST)
Date:   Sun, 19 Dec 2021 23:51:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0069f05d38f279d@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nf_hook_entries_grow
From:   syzbot <syzbot+e918523f77e62790d6d9@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9eaa88c7036e Merge tag 'libata-5.16-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=170edb15b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=10f3f669b8093e95
dashboard link: https://syzkaller.appspot.com/bug?extid=e918523f77e62790d6d9
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1781a643b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15130199b00000

The issue was bisected to:

commit 6001a930ce0378b62210d4f83583fc88a903d89d
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Feb 15 11:28:07 2021 +0000

    netfilter: nftables: introduce table ownership

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1548a7f5b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1748a7f5b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1348a7f5b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e918523f77e62790d6d9@syzkaller.appspotmail.com
Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")

==================================================================
BUG: KASAN: use-after-free in nf_hook_entries_grow+0x5a7/0x700 net/netfilter/core.c:142 net/netfilter/core.c:142
Read of size 4 at addr ffff8880736f7438 by task syz-executor579/3666

CPU: 0 PID: 3666 Comm: syz-executor579 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 __dump_stack lib/dump_stack.c:88 [inline] lib/dump_stack.c:106
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106 lib/dump_stack.c:106
 print_address_description+0x65/0x380 mm/kasan/report.c:247 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 __kasan_report mm/kasan/report.c:433 [inline] mm/kasan/report.c:450
 kasan_report+0x19a/0x1f0 mm/kasan/report.c:450 mm/kasan/report.c:450
 nf_hook_entries_grow+0x5a7/0x700 net/netfilter/core.c:142 net/netfilter/core.c:142
 __nf_register_net_hook+0x27e/0x8d0 net/netfilter/core.c:429 net/netfilter/core.c:429
 nf_register_net_hook+0xaa/0x180 net/netfilter/core.c:571 net/netfilter/core.c:571
 nft_register_flowtable_net_hooks+0x3c5/0x730 net/netfilter/nf_tables_api.c:7232 net/netfilter/nf_tables_api.c:7232
 nf_tables_newflowtable+0x2022/0x2cf0 net/netfilter/nf_tables_api.c:7430 net/netfilter/nf_tables_api.c:7430
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline] net/netfilter/nfnetlink.c:652
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline] net/netfilter/nfnetlink.c:652
 nfnetlink_rcv+0x10e6/0x2550 net/netfilter/nfnetlink.c:652 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline] net/netlink/af_netlink.c:1345
 netlink_unicast+0x814/0x9f0 net/netlink/af_netlink.c:1345 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0xaea/0xe60 net/netlink/af_netlink.c:1921 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:2409
 sock_sendmsg net/socket.c:724 [inline] net/socket.c:2409
 ____sys_sendmsg+0x5b9/0x910 net/socket.c:2409 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 ___sys_sendmsg net/socket.c:2463 [inline] net/socket.c:2492
 __sys_sendmsg+0x280/0x370 net/socket.c:2492 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_x64 arch/x86/entry/common.c:50 [inline] arch/x86/entry/common.c:80
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f81c06487f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffed6924de8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f81c06487f9
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 000000000000000d R11: 0000000000000246 R12: 00007ffed6924e00
R13: 00000000000f4240 R14: 000000000000dbd2 R15: 00007ffed6924df4
 </TASK>

Allocated by task 3665:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 kasan_save_stack mm/kasan/common.c:38 [inline] mm/kasan/common.c:513
 kasan_set_track mm/kasan/common.c:46 [inline] mm/kasan/common.c:513
 set_alloc_info mm/kasan/common.c:434 [inline] mm/kasan/common.c:513
 ____kasan_kmalloc+0xdc/0x110 mm/kasan/common.c:513 mm/kasan/common.c:513
 kasan_kmalloc include/linux/kasan.h:269 [inline]
 kasan_kmalloc include/linux/kasan.h:269 [inline] mm/slub.c:3261
 kmem_cache_alloc_trace+0x9d/0x330 mm/slub.c:3261 mm/slub.c:3261
 kmalloc include/linux/slab.h:590 [inline]
 nft_netdev_hook_alloc net/netfilter/nf_tables_api.c:1806 [inline]
 kmalloc include/linux/slab.h:590 [inline] net/netfilter/nf_tables_api.c:1860
 nft_netdev_hook_alloc net/netfilter/nf_tables_api.c:1806 [inline] net/netfilter/nf_tables_api.c:1860
 nf_tables_parse_netdev_hooks+0x195/0x730 net/netfilter/nf_tables_api.c:1860 net/netfilter/nf_tables_api.c:1860
 nft_flowtable_parse_hook+0x45a/0x880 net/netfilter/nf_tables_api.c:7136 net/netfilter/nf_tables_api.c:7136
 nf_tables_newflowtable+0x1c56/0x2cf0 net/netfilter/nf_tables_api.c:7421 net/netfilter/nf_tables_api.c:7421
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline] net/netfilter/nfnetlink.c:652
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline] net/netfilter/nfnetlink.c:652
 nfnetlink_rcv+0x10e6/0x2550 net/netfilter/nfnetlink.c:652 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline] net/netlink/af_netlink.c:1345
 netlink_unicast+0x814/0x9f0 net/netlink/af_netlink.c:1345 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0xaea/0xe60 net/netlink/af_netlink.c:1921 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:2409
 sock_sendmsg net/socket.c:724 [inline] net/socket.c:2409
 ____sys_sendmsg+0x5b9/0x910 net/socket.c:2409 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 ___sys_sendmsg net/socket.c:2463 [inline] net/socket.c:2492
 __sys_sendmsg+0x280/0x370 net/socket.c:2492 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_x64 arch/x86/entry/common.c:50 [inline] arch/x86/entry/common.c:80
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 3665:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_save_stack mm/kasan/common.c:38 [inline] mm/kasan/common.c:46
 kasan_set_track+0x4c/0x80 mm/kasan/common.c:46 mm/kasan/common.c:46
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370 mm/kasan/generic.c:370
 ____kasan_slab_free+0x10d/0x150 mm/kasan/common.c:366 mm/kasan/common.c:366
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1723 [inline]
 kasan_slab_free include/linux/kasan.h:235 [inline] mm/slub.c:1749
 slab_free_hook mm/slub.c:1723 [inline] mm/slub.c:1749
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1749 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 slab_free mm/slub.c:3513 [inline] mm/slub.c:4561
 kfree+0xe1/0x330 mm/slub.c:4561 mm/slub.c:4561
 nf_tables_flowtable_destroy+0x1fd/0x2a0 net/netfilter/nf_tables_api.c:7818 net/netfilter/nf_tables_api.c:7818
 __nft_release_table+0x516/0xe70 net/netfilter/nf_tables_api.c:9621 net/netfilter/nf_tables_api.c:9621
 nft_rcv_nl_event+0x497/0x570 net/netfilter/nf_tables_api.c:9688 net/netfilter/nf_tables_api.c:9688
 notifier_call_chain kernel/notifier.c:83 [inline]
 notifier_call_chain kernel/notifier.c:83 [inline] kernel/notifier.c:318
 blocking_notifier_call_chain+0x108/0x1b0 kernel/notifier.c:318 kernel/notifier.c:318
 netlink_release+0xf57/0x1790 net/netlink/af_netlink.c:788 net/netlink/af_netlink.c:788
 __sock_release net/socket.c:649 [inline]
 __sock_release net/socket.c:649 [inline] net/socket.c:1314
 sock_close+0xd8/0x260 net/socket.c:1314 net/socket.c:1314
 __fput+0x3fc/0x870 fs/file_table.c:280 fs/file_table.c:280
 task_work_run+0x146/0x1c0 kernel/task_work.c:164 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 tracehook_notify_resume include/linux/tracehook.h:189 [inline] kernel/entry/common.c:207
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline] kernel/entry/common.c:207
 exit_to_user_mode_prepare+0x209/0x220 kernel/entry/common.c:207 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline] kernel/entry/common.c:300
 syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300 kernel/entry/common.c:300
 do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff8880736f7400
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 56 bytes inside of
 96-byte region [ffff8880736f7400, ffff8880736f7460)
The buggy address belongs to the page:
page:ffffea0001cdbdc0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x736f7
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 0000000000000000 dead000000000122 ffff888011441780
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY), pid 3650, ts 56297137738, free_ts 56284356945
 prep_new_page mm/page_alloc.c:2418 [inline]
 prep_new_page mm/page_alloc.c:2418 [inline] mm/page_alloc.c:4149
 get_page_from_freelist+0x729/0x9e0 mm/page_alloc.c:4149 mm/page_alloc.c:4149
 __alloc_pages+0x255/0x580 mm/page_alloc.c:5369 mm/page_alloc.c:5369
 alloc_slab_page mm/slub.c:1793 [inline]
 alloc_slab_page mm/slub.c:1793 [inline] mm/slub.c:1930
 allocate_slab+0xcc/0x4d0 mm/slub.c:1930 mm/slub.c:1930
 new_slab mm/slub.c:1993 [inline]
 new_slab mm/slub.c:1993 [inline] mm/slub.c:3022
 ___slab_alloc+0x41e/0xc40 mm/slub.c:3022 mm/slub.c:3022
 __slab_alloc mm/slub.c:3109 [inline]
 slab_alloc_node mm/slub.c:3200 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 __slab_alloc mm/slub.c:3109 [inline] mm/slub.c:3259
 slab_alloc_node mm/slub.c:3200 [inline] mm/slub.c:3259
 slab_alloc mm/slub.c:3242 [inline] mm/slub.c:3259
 kmem_cache_alloc_trace+0x28c/0x330 mm/slub.c:3259 mm/slub.c:3259
 kmalloc include/linux/slab.h:590 [inline]
 kmalloc include/linux/slab.h:590 [inline] net/core/dst.c:199
 dst_cow_metrics_generic+0x52/0x1c0 net/core/dst.c:199 net/core/dst.c:199
 dst_metrics_write_ptr include/net/dst.h:118 [inline]
 dst_metric_set include/net/dst.h:179 [inline]
 dst_metrics_write_ptr include/net/dst.h:118 [inline] net/ipv6/route.c:3284
 dst_metric_set include/net/dst.h:179 [inline] net/ipv6/route.c:3284
 icmp6_dst_alloc+0x335/0x510 net/ipv6/route.c:3284 net/ipv6/route.c:3284
 mld_sendpack+0x537/0xc10 net/ipv6/mcast.c:1815 net/ipv6/mcast.c:1815
 mld_send_cr net/ipv6/mcast.c:2127 [inline]
 mld_send_cr net/ipv6/mcast.c:2127 [inline] net/ipv6/mcast.c:2659
 mld_ifc_work+0x857/0xc70 net/ipv6/mcast.c:2659 net/ipv6/mcast.c:2659
 process_one_work+0x853/0x1140 kernel/workqueue.c:2298 kernel/workqueue.c:2298
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2445 kernel/workqueue.c:2445
 kthread+0x468/0x490 kernel/kthread.c:327 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 reset_page_owner include/linux/page_owner.h:24 [inline] mm/page_alloc.c:1389
 free_pages_prepare mm/page_alloc.c:1338 [inline] mm/page_alloc.c:1389
 free_pcp_prepare+0xd1c/0xe00 mm/page_alloc.c:1389 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page_prepare mm/page_alloc.c:3309 [inline] mm/page_alloc.c:3388
 free_unref_page+0x7d/0x580 mm/page_alloc.c:3388 mm/page_alloc.c:3388
 do_slab_free mm/slub.c:3501 [inline]
 do_slab_free mm/slub.c:3501 [inline] mm/slub.c:3520
 ___cache_free+0xe6/0x120 mm/slub.c:3520 mm/slub.c:3520
 qlist_free_all mm/kasan/quarantine.c:165 [inline]
 qlist_free_all mm/kasan/quarantine.c:165 [inline] mm/kasan/quarantine.c:272
 kasan_quarantine_reduce+0x151/0x1c0 mm/kasan/quarantine.c:272 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x2f/0xf0 mm/kasan/common.c:444 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:259 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:3234 [inline]
 kasan_slab_alloc include/linux/kasan.h:259 [inline] mm/slub.c:3270
 slab_post_alloc_hook mm/slab.h:519 [inline] mm/slub.c:3270
 slab_alloc_node mm/slub.c:3234 [inline] mm/slub.c:3270
 kmem_cache_alloc_node+0x201/0x370 mm/slub.c:3270 mm/slub.c:3270
 __alloc_skb+0xd8/0x5a0 net/core/skbuff.c:414 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1126 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 alloc_skb include/linux/skbuff.h:1126 [inline] net/netlink/af_netlink.c:2431
 nlmsg_new include/net/netlink.h:953 [inline] net/netlink/af_netlink.c:2431
 netlink_ack+0x379/0xb70 net/netlink/af_netlink.c:2431 net/netlink/af_netlink.c:2431
 netlink_rcv_skb+0x299/0x470 net/netlink/af_netlink.c:2502 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline] net/netlink/af_netlink.c:1345
 netlink_unicast+0x814/0x9f0 net/netlink/af_netlink.c:1345 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0xaea/0xe60 net/netlink/af_netlink.c:1921 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:2036
 sock_sendmsg net/socket.c:724 [inline] net/socket.c:2036
 __sys_sendto+0x42e/0x5b0 net/socket.c:2036 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __do_sys_sendto net/socket.c:2048 [inline] net/socket.c:2044
 __se_sys_sendto net/socket.c:2044 [inline] net/socket.c:2044
 __x64_sys_sendto+0xda/0xf0 net/socket.c:2044 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_x64 arch/x86/entry/common.c:50 [inline] arch/x86/entry/common.c:80
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff8880736f7300: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880736f7380: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff8880736f7400: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                        ^
 ffff8880736f7480: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
 ffff8880736f7500: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
