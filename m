Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2C64C184A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbiBWQPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242482AbiBWQPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:15:50 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17C8C4280
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:15:20 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id 8-20020a921808000000b002c242893628so6811300ily.13
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:15:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aOQP8BUUPlscKCqHV6TxT+nUewPzhKOOpHdoICYm2tI=;
        b=WCk1YXyJ8229RdhH0IwoLhh8lmaEt8HqJ861lmd/7mDD8N1wupukWNOTHPJlY8j5ef
         +Z4XRAM4hVGIbyGe6AaNdOY3N66Ujo2pVaSqF1OwG4PVtm8nWfuxV+NAcE2G2jFjUcnO
         fkpnMsmQahzYEK/KmqXU8ZtypAOOWjAyRseSikapzLbeKtaIlbMbjpxnsg/zR9MsmCqx
         BMj9N9+W/extYShqOjVpOjYlvZl/Jb1QbOdd3isKg2PlqhsaM88mbGQSg33NleLv/qOR
         ILYnhKm4+58jRiK7w+DLkk40QbCzEwQ25P/PRtIvCXLenzRO8EQZIwfUuU09bY3+hUXX
         LY2A==
X-Gm-Message-State: AOAM532Gzqg596sJeMJC5XHs5391MBBBP3+nfo1n43CL7nPRRPahdGJF
        UoXzl1MfRuCDcHTa5vPdlCViWws9IjKwGaukQKMvw8/r5WTG
X-Google-Smtp-Source: ABdhPJzdFqXWEnwTrLKCxzgquEqOaTAvvM3QcRZKYS6EFQNI5aoxENdQd99Hji0Sqkn3+r8BHpEYxkuuar7Mz8Yt+0NzcvwlBXPb
MIME-Version: 1.0
X-Received: by 2002:a92:c148:0:b0:2c2:615a:49e9 with SMTP id
 b8-20020a92c148000000b002c2615a49e9mr376249ilh.98.1645632919847; Wed, 23 Feb
 2022 08:15:19 -0800 (PST)
Date:   Wed, 23 Feb 2022 08:15:19 -0800
In-Reply-To: <000000000000b2725705ca78de29@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009e48a605d8b1c555@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in sco_sock_timeout
From:   syzbot <syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, desmondcheongzx@gmail.com,
        gregkh@linuxfoundation.org, hdanton@sina.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        netdev@vger.kernel.org, skhan@linuxfoundation.org,
        syzkaller-bugs@googlegroups.com
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    922ea87ff6f2 ionic: use vmalloc include
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=177984ea700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d63ad23bb09039e8
dashboard link: https://syzkaller.appspot.com/bug?extid=2bef95d3ab4daa10155b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16678596700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152b93e8700000

The issue was bisected to:

commit e1dee2c1de2b4dd00eb44004a4bda6326ed07b59
Author: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Date:   Tue Aug 10 04:14:10 2021 +0000

    Bluetooth: fix repeated calls to sco_sock_kill

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15030c91300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17030c91300000
console output: https://syzkaller.appspot.com/x/log.txt?x=13030c91300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com
Fixes: e1dee2c1de2b ("Bluetooth: fix repeated calls to sco_sock_kill")

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:726 [inline]
BUG: KASAN: use-after-free in sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:89
Write of size 4 at addr ffff88801e1f5080 by task kworker/0:0/6

CPU: 0 PID: 6 Comm: kworker/0:0 Not tainted 5.17.0-rc4-syzkaller-01424-g922ea87ff6f2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events sco_sock_timeout
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:726 [inline]
 sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:89
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 3621:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:586 [inline]
 sk_prot_alloc+0x110/0x290 net/core/sock.c:1936
 sk_alloc+0x32/0xa80 net/core/sock.c:1989
 sco_sock_alloc.constprop.0+0x31/0x330 net/bluetooth/sco.c:483
 sco_sock_create+0xd5/0x1b0 net/bluetooth/sco.c:522
 bt_sock_create+0x17c/0x340 net/bluetooth/af_bluetooth.c:130
 __sock_create+0x353/0x790 net/socket.c:1468
 sock_create net/socket.c:1519 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1561
 __do_sys_socket net/socket.c:1570 [inline]
 __se_sys_socket net/socket.c:1568 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 3622:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x126/0x160 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kfree+0xd0/0x390 mm/slub.c:4562
 sk_prot_free net/core/sock.c:1972 [inline]
 __sk_destruct+0x6c0/0x920 net/core/sock.c:2058
 sk_destruct+0x131/0x180 net/core/sock.c:2076
 __sk_free+0xef/0x3d0 net/core/sock.c:2087
 sk_free+0x78/0xa0 net/core/sock.c:2098
 sock_put include/net/sock.h:1926 [inline]
 sco_sock_kill+0x18d/0x1b0 net/bluetooth/sco.c:403
 sco_sock_release+0x155/0x2c0 net/bluetooth/sco.c:1259
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1318
 __fput+0x286/0x9f0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 get_signal+0x1de2/0x2490 kernel/signal.c:2631
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801e1f5000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff88801e1f5000, ffff88801e1f5800)
The buggy address belongs to the page:
page:ffffea0000787c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1e1f0
head:ffffea0000787c00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010c42000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3614, ts 122880165805, free_ts 122869063806
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x27f/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0xbe1/0x12b0 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc_trace+0x2f8/0x3d0 mm/slub.c:3255
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:715 [inline]
 ipv6_add_dev+0xfe/0x12a0 net/ipv6/addrconf.c:378
 addrconf_notify+0x614/0x1ba0 net/ipv6/addrconf.c:3521
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1939
 call_netdevice_notifiers_extack net/core/dev.c:1951 [inline]
 call_netdevice_notifiers net/core/dev.c:1965 [inline]
 register_netdevice+0x1102/0x15a0 net/core/dev.c:9696
 register_netdev+0x2d/0x50 net/core/dev.c:9789
 ip6gre_init_net+0x3cd/0x630 net/ipv6/ip6_gre.c:1610
 ops_init+0xaf/0x470 net/core/net_namespace.c:134
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 __unfreeze_partials+0x320/0x340 mm/slub.c:2536
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6d/0x160 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc_trace+0x258/0x3d0 mm/slub.c:3255
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:715 [inline]
 ref_tracker_alloc+0x14c/0x550 lib/ref_tracker.c:85
 __netdev_tracker_alloc include/linux/netdevice.h:3860 [inline]
 dev_hold_track include/linux/netdevice.h:3889 [inline]
 dev_hold_track include/linux/netdevice.h:3884 [inline]
 netdev_queue_add_kobject net/core/net-sysfs.c:1650 [inline]
 netdev_queue_update_kobjects+0x1a7/0x4e0 net/core/net-sysfs.c:1705
 register_queue_kobjects net/core/net-sysfs.c:1766 [inline]
 netdev_register_kobject+0x35a/0x430 net/core/net-sysfs.c:2012
 register_netdevice+0xd9d/0x15a0 net/core/dev.c:9663
 __ip_tunnel_create+0x398/0x5c0 net/ipv4/ip_tunnel.c:267
 ip_tunnel_init_net+0x2e4/0x9d0 net/ipv4/ip_tunnel.c:1070
 ops_init+0xaf/0x470 net/core/net_namespace.c:134
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:471

Memory state around the buggy address:
 ffff88801e1f4f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801e1f5000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801e1f5080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88801e1f5100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801e1f5180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

