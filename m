Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E3348AC18
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 12:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbiAKLDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 06:03:18 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:51172 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238153AbiAKLDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 06:03:18 -0500
Received: by mail-io1-f71.google.com with SMTP id p129-20020a6b8d87000000b00601b30457cdso13296672iod.17
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 03:03:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SvKZTa68HXu7QD4i2AGs0+tntAMij4q7jyYjSzoxnBw=;
        b=PP0yA1TgbhZWGmD5jpMAkidoomzjTx5Bj5ZA/r4u/jcoUj3F0PvB12Tb9Q19ecDdR2
         SDhPqwFcY5LyHnNIcIXWDUzHOBsJZstCB0a+xG/4ClY/EbWFDdyxLDp/qbCQyD74kS9y
         JvmDdX268DpsZ5FkNkc2Wrdl8Bpi0FOr7kuqPjbNFg2CElJyNnuxwOCNmZlgx8CKcUTo
         Cb9f+qWrHqNlLo5H8QzKq9zk5zhG60nqlivMaIt+oOuLE5ZBc9LgKVZ3jql5LkszjNFG
         d3JtNQpPnuCvySwkEqVBrVDaKOOAxN8LObCy2hGfB2drPgH5LIy2NQKkA33snRLMV7uN
         Wjhg==
X-Gm-Message-State: AOAM532Xfl20g8Ybc7t83SPOcb0rT2RE2jzmz5Z4pcYxq8cvpHmNBP2U
        KxBlbbU4iTEU46j1DDiweSM5nWrIor/ZOBDF/gcAUqb1R3/j
X-Google-Smtp-Source: ABdhPJxuCvuULKufbJcbdPC16proZAKGjsigW5n3Atjpy5M6rvajnc/51odPS1pvc5hso1aQu1y5ER1CFGINgJvGVU6J6Vo/a5KN
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2615:: with SMTP id m21mr2019712jat.271.1641898997559;
 Tue, 11 Jan 2022 03:03:17 -0800 (PST)
Date:   Tue, 11 Jan 2022 03:03:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000081b56205d54c6667@google.com>
Subject: [syzbot] KASAN: use-after-free Read in srcu_invoke_callbacks
From:   syzbot <syzbot+4f789823c1abc5accf13@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3770333b3f8c Add linux-next specific files for 20220106
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=171aa4e3b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9eb40d9f910b474
dashboard link: https://syzkaller.appspot.com/bug?extid=4f789823c1abc5accf13
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b08f53b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4f789823c1abc5accf13@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in rcu_seq_snap kernel/rcu/rcu.h:91 [inline]
BUG: KASAN: use-after-free in srcu_invoke_callbacks+0x391/0x3c0 kernel/rcu/srcutree.c:1283
Read of size 8 at addr ffff8880189b6968 by task kworker/0:1/7

CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.16.0-rc8-next-20220106-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: rcu_gp srcu_invoke_callbacks
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xa5/0x3ed mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 rcu_seq_snap kernel/rcu/rcu.h:91 [inline]
 srcu_invoke_callbacks+0x391/0x3c0 kernel/rcu/srcutree.c:1283
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 19830:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:738 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 kmem_cache_alloc_node+0x255/0x3e0 mm/slub.c:3266
 blk_alloc_queue+0x5ad/0x870 block/blk-core.c:446
 blk_mq_init_queue_data block/blk-mq.c:3878 [inline]
 __blk_mq_alloc_disk+0x8c/0x1c0 block/blk-mq.c:3902
 nbd_dev_add+0x3b2/0xcd0 drivers/block/nbd.c:1765
 nbd_genl_connect+0x11f3/0x1930 drivers/block/nbd.c:1948
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2410
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2464
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2493
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 13:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kmem_cache_free+0xdb/0x3b0 mm/slub.c:3526
 rcu_do_batch kernel/rcu/tree.c:2536 [inline]
 rcu_core+0x7b8/0x1540 kernel/rcu/tree.c:2787
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 call_rcu+0x99/0x730 kernel/rcu/tree.c:3072
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 disk_release+0x19a/0x260 block/genhd.c:1116
 device_release+0x9f/0x240 drivers/base/core.c:2229
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 put_device+0x1b/0x30 drivers/base/core.c:3512
 put_disk block/genhd.c:1368 [inline]
 blk_cleanup_disk+0x6b/0x80 block/genhd.c:1384
 nbd_dev_remove+0x44/0xf0 drivers/block/nbd.c:253
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1368
 __queue_work+0x5ca/0xf30 kernel/workqueue.c:1534
 __queue_delayed_work+0x1c8/0x270 kernel/workqueue.c:1682
 queue_delayed_work_on+0x105/0x120 kernel/workqueue.c:1718
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff8880189b5c70
 which belongs to the cache request_queue_srcu of size 3816
The buggy address is located 3320 bytes inside of
 3816-byte region [ffff8880189b5c70, ffff8880189b6b58)
The buggy address belongs to the page:
page:ffffea0000626c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x189b0
head:ffffea0000626c00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888012787140
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 14963, ts 196854875504, free_ts 196839673140
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f40 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5381
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab mm/slub.c:1944 [inline]
 new_slab+0x28d/0x380 mm/slub.c:2004
 ___slab_alloc+0x6be/0xd60 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 kmem_cache_alloc_node+0x122/0x3e0 mm/slub.c:3266
 blk_alloc_queue+0x5ad/0x870 block/blk-core.c:446
 blk_mq_init_queue_data block/blk-mq.c:3878 [inline]
 __blk_mq_alloc_disk+0x8c/0x1c0 block/blk-mq.c:3902
 nbd_dev_add+0x3b2/0xcd0 drivers/block/nbd.c:1765
 nbd_genl_connect+0x11f3/0x1930 drivers/block/nbd.c:1948
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1343
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x414/0xb60 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2536
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:738 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 __kmalloc+0x1e7/0x340 mm/slub.c:4420
 kmalloc include/linux/slab.h:586 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1326
 vfs_getattr fs/stat.c:157 [inline]
 vfs_statx+0x164/0x390 fs/stat.c:225
 vfs_fstatat fs/stat.c:243 [inline]
 __do_sys_newfstatat+0x96/0x120 fs/stat.c:412
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff8880189b6800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880189b6880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880189b6900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                          ^
 ffff8880189b6980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880189b6a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
