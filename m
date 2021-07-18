Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4903F3CCA00
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 19:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhGRRSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 13:18:34 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48115 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhGRRST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 13:18:19 -0400
Received: by mail-io1-f71.google.com with SMTP id d9-20020a0566023289b02904f58bb90366so10604886ioz.14
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 10:15:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0ylX+Fe4kBK9AMfx44Fug+G4y6kYYOntkMQmyvCQt2g=;
        b=kUjIx4qhQtkW2iISjei2UTso2b8NoNNOwkelIxpFRRCbTNN6dKToan4FNmW7LOcmF/
         j/1WfeyVo0+SseMuTje6IlS+c6Oud7UnKAOvD8G2nFOE+/MrKd8jsEmetKanD31Xl+JZ
         +7qtVXPJv9+leGbEUscWPwN5d0+/bUoLoDIdlwWrXrJKg75aViz6HvnoBLyXzNbZDVR/
         O3DaeL1Ibr/Sj3cgkkjpXUzT5SmISDoigmf0oalyBCWur8jpOaExmwx877JOdtkxBjSJ
         2rwdTuz2xgt9XMqsyHclpzLghwNFFJd5OuGFpA58tCJqFY9b0o7eWhouwDZHw9RI8S1Y
         l6Vg==
X-Gm-Message-State: AOAM53024iaWNzAucW4OenQH1njmxun6NT1txyXiquKTXzf0L7ssyVKc
        xc5OrfDGEq+GaaUAWqgqXwHyfpe3mXerNwd6ajZc0oH82YK2
X-Google-Smtp-Source: ABdhPJzO3QFIE/clYv4wLziyOWDV43j1iALxW88gigAyDWYgVAtoFx9yxKP3k0KJwDJw2c8XDs7PqVQzS4OF1Mv02/6bkKTyLbtP
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d10:: with SMTP id c16mr15605791iow.40.1626628519616;
 Sun, 18 Jul 2021 10:15:19 -0700 (PDT)
Date:   Sun, 18 Jul 2021 10:15:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017e9a105c768f7a0@google.com>
Subject: [syzbot] KASAN: use-after-free Read in tipc_recvmsg
From:   syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, devicetree@vger.kernel.org,
        frowand.list@gmail.com, gregkh@linuxfoundation.org,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, robh+dt@kernel.org,
        robh@kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ab0441b4a920 Merge branch 'vmxnet3-version-6'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1744ac6a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
dashboard link: https://syzkaller.appspot.com/bug?extid=e6741b97d5552f97c24d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13973a74300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ffc902300000

The issue was bisected to:

commit 67a3156453859ceb40dc4448b7a6a99ea0ad27c7
Author: Rob Herring <robh@kernel.org>
Date:   Thu May 27 19:45:47 2021 +0000

    of: Merge of_address_to_resource() and of_pci_address_to_resource() implementations

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129b0438300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=119b0438300000
console output: https://syzkaller.appspot.com/x/log.txt?x=169b0438300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com
Fixes: 67a315645385 ("of: Merge of_address_to_resource() and of_pci_address_to_resource() implementations")

==================================================================
BUG: KASAN: use-after-free in tipc_recvmsg+0xf77/0xf90 net/tipc/socket.c:1979
Read of size 4 at addr ffff8880328cf1c0 by task kworker/u4:0/8

CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: tipc_rcv tipc_conn_recv_work
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 tipc_recvmsg+0xf77/0xf90 net/tipc/socket.c:1979
 sock_recvmsg_nosec net/socket.c:943 [inline]
 sock_recvmsg net/socket.c:961 [inline]
 sock_recvmsg+0xca/0x110 net/socket.c:957
 tipc_conn_rcv_from_sock+0x162/0x2f0 net/tipc/topsrv.c:398
 tipc_conn_recv_work+0xeb/0x190 net/tipc/topsrv.c:421
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 8446:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2981 [inline]
 kmem_cache_alloc_node+0x266/0x3e0 mm/slub.c:3017
 __alloc_skb+0x20b/0x340 net/core/skbuff.c:414
 alloc_skb_fclone include/linux/skbuff.h:1162 [inline]
 tipc_buf_acquire+0x25/0xe0 net/tipc/msg.c:72
 tipc_msg_build+0xf7/0x10a0 net/tipc/msg.c:386
 __tipc_sendstream+0x6d0/0x1150 net/tipc/socket.c:1610
 tipc_sendstream+0x4c/0x70 net/tipc/socket.c:1541
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 sock_write_iter+0x289/0x3c0 net/socket.c:1056
 call_write_iter include/linux/fs.h:2114 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x75a/0xa40 fs/read_write.c:605
 ksys_write+0x1ee/0x250 fs/read_write.c:658
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 8:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:229 [inline]
 slab_free_hook mm/slub.c:1650 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1675
 slab_free mm/slub.c:3235 [inline]
 kmem_cache_free+0x8e/0x5a0 mm/slub.c:3251
 kfree_skbmem+0x166/0x1b0 net/core/skbuff.c:709
 __kfree_skb net/core/skbuff.c:745 [inline]
 kfree_skb net/core/skbuff.c:762 [inline]
 kfree_skb+0x140/0x3f0 net/core/skbuff.c:756
 tipc_recvmsg+0x70d/0xf90 net/tipc/socket.c:1977
 sock_recvmsg_nosec net/socket.c:943 [inline]
 sock_recvmsg net/socket.c:961 [inline]
 sock_recvmsg+0xca/0x110 net/socket.c:957
 tipc_conn_rcv_from_sock+0x162/0x2f0 net/tipc/topsrv.c:398
 tipc_conn_recv_work+0xeb/0x190 net/tipc/topsrv.c:421
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff8880328cf180
 which belongs to the cache skbuff_fclone_cache of size 472
The buggy address is located 64 bytes inside of
 472-byte region [ffff8880328cf180, ffff8880328cf358)
The buggy address belongs to the page:
page:ffffea0000ca3380 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x328ce
head:ffffea0000ca3380 order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0000811500 0000000300000003 ffff8881400ee280
raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 8424, ts 65082628156, free_ts 64879784131
 prep_new_page mm/page_alloc.c:2433 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4166
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5374
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1713 [inline]
 allocate_slab+0x32b/0x4c0 mm/slub.c:1853
 new_slab mm/slub.c:1916 [inline]
 new_slab_objects mm/slub.c:2662 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2825
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2865
 slab_alloc_node mm/slub.c:2947 [inline]
 kmem_cache_alloc_node+0x12c/0x3e0 mm/slub.c:3017
 __alloc_skb+0x20b/0x340 net/core/skbuff.c:414
 alloc_skb_fclone include/linux/skbuff.h:1162 [inline]
 sk_stream_alloc_skb+0x109/0xc30 net/ipv4/tcp.c:887
 tcp_sendmsg_locked+0xc78/0x2f10 net/ipv4/tcp.c:1309
 tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1461
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 sock_write_iter+0x289/0x3c0 net/socket.c:1056
 call_write_iter include/linux/fs.h:2114 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x75a/0xa40 fs/read_write.c:605
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1343 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1394
 free_unref_page_prepare mm/page_alloc.c:3329 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3408
 unfreeze_partials+0x17c/0x1d0 mm/slub.c:2443
 put_cpu_partial+0x13d/0x230 mm/slub.c:2479
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8e/0xa0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2981 [inline]
 slab_alloc mm/slub.c:2989 [inline]
 kmem_cache_alloc+0x216/0x3a0 mm/slub.c:2994
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
 ffff8880328cf080: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
 ffff8880328cf100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880328cf180: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff8880328cf200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880328cf280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
