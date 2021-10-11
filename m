Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1523E4295DF
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhJKRk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:40:28 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:37598 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbhJKRk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 13:40:26 -0400
Received: by mail-io1-f71.google.com with SMTP id w8-20020a0566022c0800b005dc06acea8dso14186646iov.4
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 10:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ACc/28EaszY0SCGtGrjPQhT4Qy68dCsQ1xhYur0CyIo=;
        b=5P9Qo9PDkuFI0AXwEylYyww0/W3Z0YU50rAUeyRqBHypwiiMWwm8uVNv5sezFQkIO3
         9Fjafv33XHyeK8C1F+cEroj8RX3mOc42S54tar52fGJNCPn0BCsBUuJszgeRfQbz4mqY
         2RwCQJSdtFG7bYB29cg28ce6kBE/J58MFFianrMg5zR9z92Nnb40hkmTjWK6J8m/7Ewv
         9DEX7gkVdZbiKPFBbBCjmj1cU8GEBAP9LLWGDo8E1TyRDhwZCMZl9Ze6jYS9v/NGAKIK
         237ZWBRKgrastP1GfWPEbL4eUO7LPosCBWOEw20GEYZ3DOURF6fo2izD7G90s0iU0eqP
         W1OQ==
X-Gm-Message-State: AOAM53162wD17PDbCxyE64RxfKGT8v267ORqk094fVZXZ7ckqpuevsGa
        aR81EiPT9Gc4iuLJ6t89Ib1TmLdSvpZzNykgengyl8Z0X62X
X-Google-Smtp-Source: ABdhPJwhAWCGcxnvgQTGii8bwHa9Jzs6MZfJTj020URKGckFy0XzsN74czfm2ltbfaf0/41S9OaYg2Dls9e/94J6DXwtBu6uPavJ
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2dc8:: with SMTP id l8mr11419072iow.151.1633973905607;
 Mon, 11 Oct 2021 10:38:25 -0700 (PDT)
Date:   Mon, 11 Oct 2021 10:38:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000374f8905ce173204@google.com>
Subject: [syzbot] KASAN: use-after-free Read in vlan_dev_real_dev (2)
From:   syzbot <syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com>
To:     alobakin@pm.me, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    732b74d64704 virtio-net: fix for skb_over_panic inside big..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1751d798b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2ffb281e6323643
dashboard link: https://syzkaller.appspot.com/bug?extid=e4df4e1389e28972e955
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103828fb300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14613277300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in is_vlan_dev include/linux/if_vlan.h:74 [inline]
BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120 net/8021q/vlan_core.c:106
Read of size 4 at addr ffff8880781120c4 by task kworker/u4:1/10

CPU: 1 PID: 10 Comm: kworker/u4:1 Not tainted 5.15.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: gid-cache-wq netdevice_event_work_handler
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 is_vlan_dev include/linux/if_vlan.h:74 [inline]
 vlan_dev_real_dev+0xf9/0x120 net/8021q/vlan_core.c:106
 rdma_vlan_dev_real_dev include/rdma/ib_addr.h:267 [inline]
 is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0 drivers/infiniband/core/roce_gid_mgmt.c:157
 is_eth_port_of_netdev_filter+0x28/0x40 drivers/infiniband/core/roce_gid_mgmt.c:153
 ib_enum_roce_netdev+0x177/0x2f0 drivers/infiniband/core/device.c:2302
 ib_enum_all_roce_netdevs+0xbd/0x130 drivers/infiniband/core/device.c:2331
 netdevice_event_work_handler+0x9c/0x230 drivers/infiniband/core/roce_gid_mgmt.c:627
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 6877:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 kmalloc_node include/linux/slab.h:614 [inline]
 kvmalloc_node+0x61/0x120 mm/util.c:587
 kvmalloc include/linux/mm.h:805 [inline]
 kvzalloc include/linux/mm.h:813 [inline]
 alloc_netdev_mqs+0x98/0xe80 net/core/dev.c:10794
 rtnl_create_link+0x95a/0xb80 net/core/rtnetlink.c:3183
 __rtnl_newlink+0xf73/0x1750 net/core/rtnetlink.c:3448
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2510
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1935
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 6874:
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
 kvfree+0x42/0x50 mm/util.c:620
 device_release+0x9f/0x240 drivers/base/core.c:2231
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 put_device+0x1b/0x30 drivers/base/core.c:3502
 free_netdev+0x3e0/0x5b0 net/core/dev.c:10934
 ppp_destroy_interface+0x2ab/0x340 drivers/net/ppp/ppp_generic.c:3397
 ppp_release+0x1bf/0x240 drivers/net/ppp/ppp_generic.c:410
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888078112000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 196 bytes inside of
 4096-byte region [ffff888078112000, ffff888078113000)
The buggy address belongs to the page:
page:ffffea0001e04400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x78110
head:ffffea0001e04400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010c4c280
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6880, ts 73160788272, free_ts 73155121785
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4153
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5375
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2197
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab mm/slub.c:1900 [inline]
 new_slab+0x319/0x490 mm/slub.c:1963
 ___slab_alloc+0x921/0xfe0 mm/slub.c:2994
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3081
 slab_alloc_node mm/slub.c:3172 [inline]
 __kmalloc_node+0x2d2/0x370 mm/slub.c:4435
 kmalloc_node include/linux/slab.h:614 [inline]
 kvmalloc_node+0x61/0x120 mm/util.c:587
 kvmalloc include/linux/mm.h:805 [inline]
 seq_buf_alloc fs/seq_file.c:38 [inline]
 seq_read_iter+0x7e7/0x1240 fs/seq_file.c:210
 kernfs_fop_read_iter+0x44f/0x5f0 fs/kernfs/file.c:241
 call_read_iter include/linux/fs.h:2157 [inline]
 new_sync_read+0x421/0x6e0 fs/read_write.c:404
 vfs_read+0x35c/0x600 fs/read_write.c:485
 ksys_read+0x12d/0x250 fs/read_write.c:623
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3394
 __unfreeze_partials+0x340/0x360 mm/slub.c:2495
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x95/0xb0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:3206 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 kmem_cache_alloc+0x142/0x390 mm/slub.c:3219
 anon_vma_alloc mm/rmap.c:90 [inline]
 anon_vma_fork+0xed/0x630 mm/rmap.c:355
 dup_mmap kernel/fork.c:569 [inline]
 dup_mm+0xa07/0x13e0 kernel/fork.c:1453
 copy_mm kernel/fork.c:1505 [inline]
 copy_process+0x6fcf/0x7580 kernel/fork.c:2194
 kernel_clone+0xe7/0xac0 kernel/fork.c:2584
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2701
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888078111f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888078112000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888078112080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff888078112100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888078112180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
