Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0296448B8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiLFQG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiLFQGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:06:05 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC1714015
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:02:47 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id i7-20020a056e021b0700b003033a763270so13381311ilv.19
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:02:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fpFotMkvHUVOI4iy3aVJBOL4QDLLx4cdeq6GKRxE+SQ=;
        b=JeI+jbaPL/Wp7/dQj4ZLMwKVzbVmKakrdvltWht5aLc+yf6h2UT1Ts+wrb6vE7iR9T
         zNC/PYSCTRbBrFkuDoU5vs8vPswIc+V5vel6wU1FcV6+SsQzfqQJ8e1OuQsRTOAvgriU
         R1tRhVxsMPDfCWTQIqAVMNAxP2C4/Oijn8x+C7VlfE48S/ihnkTXrUrmj0u0Q/6NZHM5
         2jMmFHSvvdxmNPItfnRySVfEFCQWDjRrZW/xfe52KzrDtsQZBSdVN+oMMrj59FSgK1sT
         ArrWUPHIuHLxWvrlk3oCj2lDqudohy4CUcemQhIQSZEEA1s6DiRtLPZL5ut/ZGlGSV2+
         PuLg==
X-Gm-Message-State: ANoB5pkzSVh6sSyW4nODDCj2N0pi2q4imDLpNKuuZEfR+Psw+IHytNtM
        SRDGm9/vby2pmMUaplWM/7xa+ta/z/bop932TmD7snrar74V
X-Google-Smtp-Source: AA0mqf51roHdKNBnA77R2gLacbwrpdzEJZmazB6BhTrS9aqftT58BaAsMWrFL6LT/rNWdXwnqIvcIPRSUiSYK7y8WWC7gozAjCZv
MIME-Version: 1.0
X-Received: by 2002:a5d:9604:0:b0:6df:a070:78e1 with SMTP id
 w4-20020a5d9604000000b006dfa07078e1mr16197197iol.19.1670342555177; Tue, 06
 Dec 2022 08:02:35 -0800 (PST)
Date:   Tue, 06 Dec 2022 08:02:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a798f305ef2aeed9@google.com>
Subject: [syzbot] KASAN: use-after-free Write in l2tp_tunnel_del_work (2)
From:   syzbot <syzbot+57d48d64daabde805330@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jakub@cloudflare.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    355479c70a48 Merge tag 'efi-fixes-for-v6.1-4' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f65c47880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cc4b2e0a8e8a8366
dashboard link: https://syzkaller.appspot.com/bug?extid=57d48d64daabde805330
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1731caf3880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cc9435668c09/disk-355479c7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/efa65db8752c/vmlinux-355479c7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/819f2fe5b542/bzImage-355479c7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+57d48d64daabde805330@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:102 [inline]
BUG: KASAN: use-after-free in test_and_set_bit include/asm-generic/bitops/instrumented-atomic.h:71 [inline]
BUG: KASAN: use-after-free in l2tp_session_delete net/l2tp/l2tp_core.c:1555 [inline]
BUG: KASAN: use-after-free in l2tp_tunnel_closeall net/l2tp/l2tp_core.c:1207 [inline]
BUG: KASAN: use-after-free in l2tp_tunnel_del_work+0x1e8/0x780 net/l2tp/l2tp_core.c:1239
Write of size 8 at addr ffff888079457808 by task kworker/u4:4/102

CPU: 1 PID: 102 Comm: kworker/u4:4 Not tainted 6.1.0-rc7-syzkaller-00122-g355479c70a48 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: l2tp l2tp_tunnel_del_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:102 [inline]
 test_and_set_bit include/asm-generic/bitops/instrumented-atomic.h:71 [inline]
 l2tp_session_delete net/l2tp/l2tp_core.c:1555 [inline]
 l2tp_tunnel_closeall net/l2tp/l2tp_core.c:1207 [inline]
 l2tp_tunnel_del_work+0x1e8/0x780 net/l2tp/l2tp_core.c:1239
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 15805:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slab_common.c:955 [inline]
 __kmalloc+0x5a/0xd0 mm/slab_common.c:968
 kmalloc include/linux/slab.h:558 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 l2tp_session_create+0x3a/0xb70 net/l2tp/l2tp_core.c:1591
 pppol2tp_connect+0xfff/0x1a10 net/l2tp/l2tp_ppp.c:771
 __sys_connect_file+0x153/0x1a0 net/socket.c:1976
 __sys_connect+0x165/0x1a0 net/socket.c:1993
 __do_sys_connect net/socket.c:2003 [inline]
 __se_sys_connect net/socket.c:2000 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2000
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 15:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:511
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1724 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1750
 slab_free mm/slub.c:3661 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3674
 l2tp_session_free net/l2tp/l2tp_core.c:163 [inline]
 l2tp_session_dec_refcount+0x15d/0x3a0 net/l2tp/l2tp_core.c:200
 pppol2tp_session_destruct+0xbe/0x100 net/l2tp/l2tp_ppp.c:418
 __sk_destruct+0x51/0x710 net/core/sock.c:2122
 sk_destruct net/core/sock.c:2167 [inline]
 __sk_free+0x175/0x460 net/core/sock.c:2178
 sk_free+0x7c/0xa0 net/core/sock.c:2189
 sock_put include/net/sock.h:1987 [inline]
 pppol2tp_put_sk+0x9f/0xd0 net/l2tp/l2tp_ppp.c:401
 rcu_do_batch kernel/rcu/tree.c:2250 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2510
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 call_rcu+0x9d/0x820 kernel/rcu/tree.c:2798
 pppol2tp_release+0x315/0x560 net/l2tp/l2tp_ppp.c:457
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x1c/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 call_rcu+0x9d/0x820 kernel/rcu/tree.c:2798
 pppol2tp_release+0x315/0x560 net/l2tp/l2tp_ppp.c:457
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x1c/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888079457800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 8 bytes inside of
 1024-byte region [ffff888079457800, ffff888079457c00)

The buggy address belongs to the physical page:
page:ffffea0001e51400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x79450
head:ffffea0001e51400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888012041dc0
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 3729, tgid 3729 (kworker/0:6), ts 188509457070, free_ts 184865002121
 prep_new_page mm/page_alloc.c:2539 [inline]
 get_page_from_freelist+0x10b5/0x2d50 mm/page_alloc.c:4291
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5558
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1794 [inline]
 allocate_slab+0x213/0x300 mm/slub.c:1939
 new_slab mm/slub.c:1992 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3180
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3279
 slab_alloc_node mm/slub.c:3364 [inline]
 __kmem_cache_alloc_node+0x199/0x3e0 mm/slub.c:3437
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc_node_track_caller+0x4b/0xc0 mm/slab_common.c:975
 kmalloc_reserve net/core/skbuff.c:437 [inline]
 __alloc_skb+0xdd/0x300 net/core/skbuff.c:509
 alloc_skb include/linux/skbuff.h:1267 [inline]
 nlmsg_new include/net/netlink.h:970 [inline]
 inet6_rt_notify+0xf0/0x2b0 net/ipv6/route.c:6172
 fib6_add_rt2node net/ipv6/ip6_fib.c:1252 [inline]
 fib6_add+0x26eb/0x3f20 net/ipv6/ip6_fib.c:1478
 __ip6_ins_rt net/ipv6/route.c:1302 [inline]
 ip6_route_add+0x8f/0x150 net/ipv6/route.c:3847
 addrconf_add_mroute+0x1e1/0x310 net/ipv6/addrconf.c:2489
 addrconf_add_dev+0x156/0x1c0 net/ipv6/addrconf.c:2507
 addrconf_dev_config+0x1ec/0x410 net/ipv6/addrconf.c:3382
 addrconf_notify+0xee0/0x1c80 net/ipv6/addrconf.c:3635
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1459 [inline]
 free_pcp_prepare+0x65c/0xd90 mm/page_alloc.c:1509
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page+0x1d/0x4d0 mm/page_alloc.c:3483
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2586
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x184/0x210 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3398 [inline]
 __kmem_cache_alloc_node+0x2e2/0x3e0 mm/slub.c:3437
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc+0x4a/0xd0 mm/slab_common.c:968
 kmalloc include/linux/slab.h:558 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 fib_create_info+0xdc2/0x4ac0 net/ipv4/fib_semantics.c:1451
 fib_table_insert+0x199/0x1be0 net/ipv4/fib_trie.c:1236
 fib_magic+0x455/0x540 net/ipv4/fib_frontend.c:1098
 fib_add_ifaddr+0x49f/0x540 net/ipv4/fib_frontend.c:1142
 fib_netdev_event+0x36d/0x6a0 net/ipv4/fib_frontend.c:1480
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 __dev_notify_flags+0x114/0x2c0 net/core/dev.c:8581

Memory state around the buggy address:
 ffff888079457700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888079457780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888079457800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff888079457880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888079457900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
