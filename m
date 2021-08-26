Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69873F8C2F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 18:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243086AbhHZQaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 12:30:23 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:34725 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbhHZQaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 12:30:12 -0400
Received: by mail-io1-f69.google.com with SMTP id a9-20020a5ec309000000b005baa3f77016so2078346iok.1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 09:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=N2vgdsfbhgM7eLzC4BavDkwW+JvSo1HliyapiML1pzY=;
        b=m69y6gnn1jjqV6KY4+/uhO4agpTZpQUzuXYOvODjpNOj4L57itP3b+pCjBdqFdiY0P
         +L05s+e8Q51S9G0n+r+6yXqw+fRdQv44mw4+57amu4ruFawgIXbzIJKZJd+IYc2hjWTc
         jiUyAIjZqIIWvRVL74endgXhTYXGezUPeytxM6S5PaOkFPJ1h7eAoWf9ROL+QuQbxIWx
         zE9jIzPlzCIx/+hG/rExtYQCbdAbhqQWz+mOn+e6mdPG25np3MjkoT4Wh/xnmZl7qs6/
         9NMC6rjRj2XNkztG3zRP/jXC4VG1L10KYgUEraxBqJz3QxGb0gewriVV7aWOJQ+4G6dM
         A5pA==
X-Gm-Message-State: AOAM530PKXpzGqJuJgsRRSezX61Ea+8KGOVv4fQI8otJU31ijPe+oRIF
        tLAMeHRsgAVxhXuA5N9KGtxYRBIGpIzfEcW12tz04d7O6tU+
X-Google-Smtp-Source: ABdhPJwUPoThwQRmeVHpcixCb86LNka984tu8GIV2jaUr523ndpwtxxcfEQ3mApIssKnCxbH6WOdUBkY7VaWN9eiptBbNyXFhwYR
MIME-Version: 1.0
X-Received: by 2002:a6b:c8c7:: with SMTP id y190mr3775072iof.210.1629995364674;
 Thu, 26 Aug 2021 09:29:24 -0700 (PDT)
Date:   Thu, 26 Aug 2021 09:29:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b2725705ca78de29@google.com>
Subject: [syzbot] KASAN: use-after-free Write in sco_sock_timeout
From:   syzbot <syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, desmondcheongzx@gmail.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, luiz.von.dentz@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e3f30ab28ac8 Merge branch 'pktgen-samples-next'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13249c96300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ef482942966bf763
dashboard link: https://syzkaller.appspot.com/bug?extid=2bef95d3ab4daa10155b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a29ea9300000

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
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:111 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:702 [inline]
BUG: KASAN: use-after-free in sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:88
Write of size 4 at addr ffff888034b46080 by task kworker/1:0/20

CPU: 1 PID: 20 Comm: kworker/1:0 Not tainted 5.14.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events sco_sock_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:111 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:702 [inline]
 sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:88
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 4872:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:596 [inline]
 sk_prot_alloc+0x110/0x290 net/core/sock.c:1822
 sk_alloc+0x32/0xbc0 net/core/sock.c:1875
 __netlink_create+0x63/0x2f0 net/netlink/af_netlink.c:640
 netlink_create+0x3ad/0x5e0 net/netlink/af_netlink.c:703
 __sock_create+0x353/0x790 net/socket.c:1461
 sock_create net/socket.c:1512 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1554
 __do_sys_socket net/socket.c:1563 [inline]
 __se_sys_socket net/socket.c:1561 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1561
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 0:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1628 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1653
 slab_free mm/slub.c:3213 [inline]
 kfree+0xe4/0x540 mm/slub.c:4267
 sk_prot_free net/core/sock.c:1858 [inline]
 __sk_destruct+0x6a8/0x900 net/core/sock.c:1943
 sk_destruct+0xbd/0xe0 net/core/sock.c:1958
 __sk_free+0xef/0x3d0 net/core/sock.c:1969
 sk_free+0x78/0xa0 net/core/sock.c:1980
 deferred_put_nlk_sk+0x151/0x2f0 net/netlink/af_netlink.c:740
 rcu_do_batch kernel/rcu/tree.c:2550 [inline]
 rcu_core+0x7ab/0x1380 kernel/rcu/tree.c:2785
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3029 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3109
 netlink_release+0xdd4/0x1dd0 net/netlink/af_netlink.c:812
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1311
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbd4/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3029 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3109
 netlink_release+0xdd4/0x1dd0 net/netlink/af_netlink.c:812
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1311
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbd4/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888034b46000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff888034b46000, ffff888034b46800)
The buggy address belongs to the page:
page:ffffea0000d2d000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x34b40
head:ffffea0000d2d000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0000c37a00 0000000200000002 ffff888010c42000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 8634, ts 417197903424, free_ts 417180376519
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1691 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1831
 new_slab mm/slub.c:1894 [inline]
 new_slab_objects mm/slub.c:2640 [inline]
 ___slab_alloc+0x473/0x7b0 mm/slub.c:2803
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2843
 slab_alloc_node mm/slub.c:2925 [inline]
 __kmalloc_node_track_caller+0x2e3/0x360 mm/slub.c:4653
 kmalloc_reserve net/core/skbuff.c:355 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1116 [inline]
 alloc_skb_with_frags+0x93/0x620 net/core/skbuff.c:6073
 sock_alloc_send_pskb+0x783/0x910 net/core/sock.c:2475
 mld_newpack+0x1df/0x770 net/ipv6/mcast.c:1756
 add_grhead+0x265/0x330 net/ipv6/mcast.c:1859
 add_grec+0x1053/0x14e0 net/ipv6/mcast.c:1997
 mld_send_initial_cr.part.0+0xf6/0x230 net/ipv6/mcast.c:2244
 mld_send_initial_cr net/ipv6/mcast.c:1232 [inline]
 ipv6_mc_dad_complete+0x1d0/0x690 net/ipv6/mcast.c:2255
 addrconf_dad_completed+0xa20/0xd60 net/ipv6/addrconf.c:4181
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1346 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1397
 free_unref_page_prepare mm/page_alloc.c:3332 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3411
 unfreeze_partials+0x16c/0x1b0 mm/slub.c:2421
 put_cpu_partial+0x13d/0x230 mm/slub.c:2457
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8e/0xa0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:2959 [inline]
 slab_alloc mm/slub.c:2967 [inline]
 kmem_cache_alloc+0x285/0x4a0 mm/slub.c:2972
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags fs/namei.c:2747 [inline]
 user_path_at_empty+0xa1/0x100 fs/namei.c:2747
 user_path_at include/linux/namei.h:57 [inline]
 vfs_statx+0x142/0x390 fs/stat.c:203
 vfs_fstatat fs/stat.c:225 [inline]
 vfs_lstat include/linux/fs.h:3386 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:380
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888034b45f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888034b46000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888034b46080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888034b46100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888034b46180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
