Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FC440856E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 09:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhIMHge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 03:36:34 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:42887 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbhIMHgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 03:36:32 -0400
Received: by mail-io1-f72.google.com with SMTP id i78-20020a6b3b51000000b005b8dd0f9e76so13264782ioa.9
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 00:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/3qBOAIb+oaRU7Tdnh7gYqhJUSX0yw+IA0kkRZFt0kc=;
        b=ZBKmzZN9+R0NY6esKiHDZIe2jBEcLPoOgyqIrr1CcFluRFQzpTdgR+fDNnlzOZuqZO
         TPRQ/cTgVJcAlu2x6M3JRUz/qFtDn+aqAF3sZgxayiuJbkcjqkIkABy7oQsHWbzZ71zx
         /CGk9DxaN6v6fYsGHGP+swWeHZWhGzHfAdxXn8QQnOjCFg+FfLMdmxha1/5lh13GhpBP
         FHY4hHlN6FjZl4esUylAUj/9OOour5Pq2NTqKvaVmRPAiDyryFJsbw8W8+Jpdh+W1ueW
         3JMPuy1BGNPlj0YHdgfg1A7/vV+eEilzI8g1T+Z5ygsKIgVHnnvN2Yk6Ik1/kHeUB6pr
         PUTQ==
X-Gm-Message-State: AOAM532sL9L2DFzbAqghQYFZH6i4/Tl+ovlNIJIoQEO6R5RVVuZCtL6Q
        OEhAq+auNFINClYPgVnLooqEeS8U+Efq3SqL+oaI7JhaY29x
X-Google-Smtp-Source: ABdhPJx12rehXBwlP8baN/io1bE9dR/hn6Ey3EZbk81ecOzOD0eXQ2VGJUHfrbqrFsM83KouMFk3H0dh50n+bblShcLX6fCTq3ia
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1909:: with SMTP id p9mr3367647jal.108.1631518516808;
 Mon, 13 Sep 2021 00:35:16 -0700 (PDT)
Date:   Mon, 13 Sep 2021 00:35:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a3958805cbdb8102@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nft_table_lookup (2)
From:   syzbot <syzbot+f31660cf279b0557160c@syzkaller.appspotmail.com>
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

HEAD commit:    0f4b9289bad3 Merge tag 'docs-5.15-2' of git://git.lwn.net/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e95663300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ddf81d5d49fe3452
dashboard link: https://syzkaller.appspot.com/bug?extid=f31660cf279b0557160c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f78feb300000

The issue was bisected to:

commit 6001a930ce0378b62210d4f83583fc88a903d89d
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Feb 15 11:28:07 2021 +0000

    netfilter: nftables: introduce table ownership

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f4170b300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17f4170b300000
console output: https://syzkaller.appspot.com/x/log.txt?x=13f4170b300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f31660cf279b0557160c@syzkaller.appspotmail.com
Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")

==================================================================
BUG: KASAN: use-after-free in memcmp+0x18f/0x1c0 lib/string.c:955
Read of size 1 at addr ffff88806ef7e690 by task syz-executor.0/16206

CPU: 1 PID: 16206 Comm: syz-executor.0 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 memcmp+0x18f/0x1c0 lib/string.c:955
 memcmp include/linux/fortify-string.h:235 [inline]
 nla_strcmp+0xf2/0x130 lib/nlattr.c:836
 nft_table_lookup.part.0+0x1a2/0x460 net/netfilter/nf_tables_api.c:570
 nft_table_lookup net/netfilter/nf_tables_api.c:4064 [inline]
 nf_tables_getset+0x1b3/0x860 net/netfilter/nf_tables_api.c:4064
 nfnetlink_rcv_msg+0x659/0x13f0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f34c684e188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000d80 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffdd7170d4f R14: 00007f34c684e300 R15: 0000000000022000

Allocated by task 16206:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:596 [inline]
 nla_strdup+0xc8/0x150 lib/nlattr.c:769
 nf_tables_newtable+0xe5e/0x1b40 net/netfilter/nf_tables_api.c:1116
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 16205:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x81/0x190 mm/slub.c:1725
 slab_free mm/slub.c:3483 [inline]
 kfree+0xe4/0x530 mm/slub.c:4543
 nf_tables_table_destroy+0xd2/0x1b0 net/netfilter/nf_tables_api.c:1313
 __nft_release_table+0xabc/0xe30 net/netfilter/nf_tables_api.c:9603
 nft_rcv_nl_event+0x4af/0x590 net/netfilter/nf_tables_api.c:9645
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 blocking_notifier_call_chain kernel/notifier.c:318 [inline]
 blocking_notifier_call_chain+0x67/0x90 kernel/notifier.c:306
 netlink_release+0xcb8/0x1dd0 net/netlink/af_netlink.c:785
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88806ef7e690
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes inside of
 8-byte region [ffff88806ef7e690, ffff88806ef7e698)
The buggy address belongs to the page:
page:ffffea0001bbdf80 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88806ef7ee10 pfn:0x6ef7e
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00004deb00 0000000300000003 ffff888010c41280
raw: ffff88806ef7ee10 0000000080660054 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 6577, ts 1160917309588, free_ts 1160767773568
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4151
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5373
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2291
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab mm/slub.c:1900 [inline]
 new_slab+0x319/0x490 mm/slub.c:1963
 ___slab_alloc+0x921/0xfe0 mm/slub.c:2994
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3081
 slab_alloc_node mm/slub.c:3172 [inline]
 __kmalloc_node+0x2d2/0x370 mm/slub.c:4435
 kmalloc_node include/linux/slab.h:614 [inline]
 __vmalloc_area_node mm/vmalloc.c:2903 [inline]
 __vmalloc_node_range+0x5ec/0x9e0 mm/vmalloc.c:3020
 __vmalloc_node mm/vmalloc.c:3069 [inline]
 vzalloc+0x67/0x80 mm/vmalloc.c:3139
 do_arpt_get_ctl+0x5f6/0x8f0 net/ipv4/netfilter/arp_tables.c:659
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1756
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4254
 __sys_getsockopt+0x21f/0x5f0 net/socket.c:2220
 __do_sys_getsockopt net/socket.c:2235 [inline]
 __se_sys_getsockopt net/socket.c:2232 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2232
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page_list+0x1a1/0x1010 mm/page_alloc.c:3431
 release_pages+0x830/0x20b0 mm/swap.c:950
 tlb_batch_pages_flush mm/mmu_gather.c:49 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:242 [inline]
 tlb_flush_mmu mm/mmu_gather.c:249 [inline]
 tlb_finish_mmu+0x165/0x8c0 mm/mmu_gather.c:340
 exit_mmap+0x1ea/0x620 mm/mmap.c:3173
 __mmput+0x122/0x4b0 kernel/fork.c:1114
 mmput+0x58/0x60 kernel/fork.c:1135
 exit_mm kernel/exit.c:501 [inline]
 do_exit+0xabc/0x2a30 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88806ef7e580: fc fc fc fc fb fc fc fc fc fb fc fc fc fc fb fc
 ffff88806ef7e600: fc fc fc fb fc fc fc fc fb fc fc fc fc fb fc fc
>ffff88806ef7e680: fc fc fa fc fc fc fc fa fc fc fc fc fa fc fc fc
                         ^
 ffff88806ef7e700: fc fa fc fc fc fc fa fc fc fc fc fa fc fc fc fc
 ffff88806ef7e780: fa fc fc fc fc fa fc fc fc fc fa fc fc fc fc fa
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
