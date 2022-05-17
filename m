Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA44152AA39
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351993AbiEQSMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348858AbiEQSM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:12:28 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B012150E3F
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:12:22 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id n2-20020a056e021ba200b002d12462a1d1so3241218ili.15
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5ppQlwk8u7qC0aWa6YrUMjnYu32mb9/qPC0qvwwLNCo=;
        b=48y3uyR43OeotjkGbwYBpzt0EqrdeMlJjcljVLFD5UwGOHoizzdP+X5/yGZifEZnrW
         WnBMedbVOzZwtHhn8vNrw4kuu/6dbW800FkgCGk8D3PoG3yl3871yhJlP+wTKhxHI7bS
         ZlLVfprU5LX06swISo2cOpDxWTmue3nQpOQUswRaRK6NW+xl6HiRl6nJ4psI6hbrE5e3
         VvXrUrha0WZ0e+LQ/k7zE/mDS6Kb78l2/kmY+w15l4U2k0RDgBgrddHCmZaVfm2fgcEM
         VbzQWxAfzaX8ZYNwIYnYQ/HlOcWCHsb147xiese377uFwsZBpt99ofvkLPQm+KoeX32+
         ixZw==
X-Gm-Message-State: AOAM530/a6li29GwMWg9jVHKkJUDOS1zR1HuPgubzUYiyixWdSZegyMx
        9rhCVc/v7pfWIr6e2F+9FKkXudUH3AgIU8r79hIS+BtHlzVX
X-Google-Smtp-Source: ABdhPJwd5KWe/1UpT0Wnw8AQfQeazgc1rcQklk7IQaDaQfKqOuDsBtKX4sX8UK9rh92jm+odsMgD+a/FPZ4dClJDHz+Y6rQG4dea
MIME-Version: 1.0
X-Received: by 2002:a05:6638:33a1:b0:32b:8e2b:f9ba with SMTP id
 h33-20020a05663833a100b0032b8e2bf9bamr12592121jav.93.1652811141693; Tue, 17
 May 2022 11:12:21 -0700 (PDT)
Date:   Tue, 17 May 2022 11:12:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fb4af305df391431@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nf_confirm
From:   syzbot <syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com>
To:     ali.abdallah@suse.com, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        ozsh@nvidia.com, pabeni@redhat.com, pablo@netfilter.org,
        paulb@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d887ae3247e0 octeontx2-pf: Remove unnecessary synchronize_..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17f2b659f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1aab282dc5dd920
dashboard link: https://syzkaller.appspot.com/bug?extid=793a590957d9c1b96620
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1313dce6f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=169eb59ef00000

The issue was bisected to:

commit 1397af5bfd7d32b0cf2adb70a78c9a9e8f11d912
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Apr 11 11:01:18 2022 +0000

    netfilter: conntrack: remove the percpu dying list

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13a8d006f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1068d006f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17a8d006f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com
Fixes: 1397af5bfd7d ("netfilter: conntrack: remove the percpu dying list")

==================================================================
BUG: KASAN: use-after-free in __nf_ct_ext_exist include/net/netfilter/nf_conntrack_extend.h:47 [inline]
BUG: KASAN: use-after-free in nf_ct_ext_exist include/net/netfilter/nf_conntrack_extend.h:52 [inline]
BUG: KASAN: use-after-free in nf_ct_ecache_exist include/net/netfilter/nf_conntrack_ecache.h:42 [inline]
BUG: KASAN: use-after-free in nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:63 [inline]
BUG: KASAN: use-after-free in nf_confirm+0x575/0x5b0 net/netfilter/nf_conntrack_proto.c:154
Read of size 1 at addr ffff88801b035304 by task kworker/1:0/22

CPU: 1 PID: 22 Comm: kworker/1:0 Not tainted 5.18.0-rc6-syzkaller-01525-gd887ae3247e0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: krxrpcd rxrpc_peer_keepalive_worker
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 __nf_ct_ext_exist include/net/netfilter/nf_conntrack_extend.h:47 [inline]
 nf_ct_ext_exist include/net/netfilter/nf_conntrack_extend.h:52 [inline]
 nf_ct_ecache_exist include/net/netfilter/nf_conntrack_ecache.h:42 [inline]
 nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:63 [inline]
 nf_confirm+0x575/0x5b0 net/netfilter/nf_conntrack_proto.c:154
 ipv4_confirm+0x17a/0x390 net/netfilter/nf_conntrack_proto.c:182
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0xc5/0x1f0 net/netfilter/core.c:620
 nf_hook+0x1cb/0x5b0 include/linux/netfilter.h:262
 NF_HOOK_COND include/linux/netfilter.h:295 [inline]
 ip_output+0x21f/0x310 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 ip_send_skb+0xd4/0x260 net/ipv4/ip_output.c:1571
 udp_send_skb+0x6c8/0x11a0 net/ipv4/udp.c:967
 udp_sendmsg+0x1bee/0x2760 net/ipv4/udp.c:1254
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 rxrpc_send_keepalive+0x1f6/0x370 net/rxrpc/output.c:665
 rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:332 [inline]
 rxrpc_peer_keepalive_worker+0x7cf/0xc20 net/rxrpc/peer_event.c:396
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Allocated by task 2972:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:581 [inline]
 kernfs_get_open_node fs/kernfs/file.c:547 [inline]
 kernfs_fop_open+0xa3f/0xe00 fs/kernfs/file.c:693
 do_dentry_open+0x4a1/0x11e0 fs/open.c:824
 do_open fs/namei.c:3476 [inline]
 path_openat+0x1c71/0x2910 fs/namei.c:3609
 do_filp_open+0x1aa/0x400 fs/namei.c:3636
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1213
 do_sys_open fs/open.c:1229 [inline]
 __do_sys_openat fs/open.c:1245 [inline]
 __se_sys_openat fs/open.c:1240 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1240
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 22:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3510 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4552
 nf_conntrack_free+0x100/0x630 net/netfilter/nf_conntrack_core.c:1680
 nf_ct_destroy+0x1be/0x320 net/netfilter/nf_conntrack_core.c:610
 nf_ct_put include/net/netfilter/nf_conntrack.h:184 [inline]
 nf_ct_put include/net/netfilter/nf_conntrack.h:181 [inline]
 __nf_ct_resolve_clash+0x624/0x785 net/netfilter/nf_conntrack_core.c:1013
 nf_ct_resolve_clash+0x14a/0xa23 net/netfilter/nf_conntrack_core.c:1136
 __nf_conntrack_confirm.cold+0x16/0x23e net/netfilter/nf_conntrack_core.c:1284
 nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:62 [inline]
 nf_confirm+0x4ce/0x5b0 net/netfilter/nf_conntrack_proto.c:154
 ipv4_confirm+0x17a/0x390 net/netfilter/nf_conntrack_proto.c:182
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0xc5/0x1f0 net/netfilter/core.c:620
 nf_hook+0x1cb/0x5b0 include/linux/netfilter.h:262
 NF_HOOK_COND include/linux/netfilter.h:295 [inline]
 ip_output+0x21f/0x310 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 ip_send_skb+0xd4/0x260 net/ipv4/ip_output.c:1571
 udp_send_skb+0x6c8/0x11a0 net/ipv4/udp.c:967
 udp_sendmsg+0x1bee/0x2760 net/ipv4/udp.c:1254
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 rxrpc_send_keepalive+0x1f6/0x370 net/rxrpc/output.c:665
 rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:332 [inline]
 rxrpc_peer_keepalive_worker+0x7cf/0xc20 net/rxrpc/peer_event.c:396
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

The buggy address belongs to the object at ffff88801b035300
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 4 bytes inside of
 128-byte region [ffff88801b035300, ffff88801b035380)

The buggy address belongs to the physical page:
page:ffffea00006c0d40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1b035
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0000664000 dead000000000005 ffff888010c418c0
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 2967, tgid 2967 (udevd), ts 23818493455, free_ts 23818009574
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 slab_alloc mm/slub.c:3225 [inline]
 kmem_cache_alloc_trace+0x310/0x3f0 mm/slub.c:3256
 kmalloc include/linux/slab.h:581 [inline]
 kernfs_get_open_node fs/kernfs/file.c:547 [inline]
 kernfs_fop_open+0xa3f/0xe00 fs/kernfs/file.c:693
 do_dentry_open+0x4a1/0x11e0 fs/open.c:824
 do_open fs/namei.c:3476 [inline]
 path_openat+0x1c71/0x2910 fs/namei.c:3609
 do_filp_open+0x1aa/0x400 fs/namei.c:3636
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1213
 do_sys_open fs/open.c:1229 [inline]
 __do_sys_openat fs/open.c:1245 [inline]
 __se_sys_openat fs/open.c:1240 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1240
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2523
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:749 [inline]
 slab_alloc_node mm/slub.c:3217 [inline]
 kmem_cache_alloc_node+0x255/0x3f0 mm/slub.c:3267
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1426 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1191 [inline]
 netlink_sendmsg+0x9a2/0xe10 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2460
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2514
 __sys_sendmsg net/socket.c:2543 [inline]
 __do_sys_sendmsg net/socket.c:2552 [inline]
 __se_sys_sendmsg net/socket.c:2550 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2550
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88801b035200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88801b035280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801b035300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88801b035380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801b035400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
