Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE313F7C5A
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbhHYSnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:43:12 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:52858 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241233AbhHYSnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 14:43:10 -0400
Received: by mail-il1-f199.google.com with SMTP id b13-20020a92dccd0000b0290223ea53d878so273815ilr.19
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 11:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0iR0x36PIhMNa4vPrWpjmbWk3iifild/tLPmjWFMZOk=;
        b=DJiR2n8slfcNT/vVqy0KAhEkFsvVXnjYEIhFxbvT6FLjl7THB/y70+/hHFvZt0Fm7f
         goGuOKGYyQMKyaVu/vD72ZOKUEUOJhg62VWS+yN3sLrYNT8xud9b7ydHtwP37Hef3sMP
         R/bfiVmrfof1COGD4MzdoshW9jLpKoArIon+gPk51b75AQyWIS0clnMN+EixGPVMe5/m
         yNHYKIiTQb4ewJOOLN5nGMPEQLCh0w+j60dqS5PRlK/pQJeqqrJSLJDW3Ne0OXm3TaSZ
         PPHZrz5KqHfKFoaQTWCe7G1oZpqbJmrOCOQdHE0dCaAdCGjQ6Qs0lEyX8K7NIiCvOgWX
         uktA==
X-Gm-Message-State: AOAM531lUh1iu2GqtuosRhhuRRkfH9p8BrOUFVBmhegzCT7Y5+Q7mCWW
        YDauZDB8R6u1dFwDZ6WlCn4jxZzxmvY9rPNZMyf/AQ39pa6Y
X-Google-Smtp-Source: ABdhPJzZe3aq/4R0fzdFo5QulDm2aQZn78HeA3wJDtqy6tiKPtEwTIqc+17emFafMDN9gf2MUnukCp0MjfsiPqUnql6vmheWJnXz
MIME-Version: 1.0
X-Received: by 2002:a5d:8f91:: with SMTP id l17mr6167962iol.121.1629916944002;
 Wed, 25 Aug 2021 11:42:24 -0700 (PDT)
Date:   Wed, 25 Aug 2021 11:42:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000075f76e05ca669c9c@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in sk_psock_get
From:   syzbot <syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, aviadye@mellanox.com,
        borisp@mellanox.com, borisp@nvidia.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    12d125b4574b stmmac: Revert "stmmac: align RX buffers"
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17c6e38d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=96f0602203250753
dashboard link: https://syzkaller.appspot.com/bug?extid=1fa91bcd05206ff8cbb5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12618c05300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e60d05300000

The issue was bisected to:

commit 130b392c6cd6b2aed1b7eb32253d4920babb4891
Author: Dave Watson <davejwatson@fb.com>
Date:   Wed Jan 30 21:58:31 2019 +0000

    net: tls: Add tls 1.3 support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13694355300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10e94355300000
console output: https://syzkaller.appspot.com/x/log.txt?x=17694355300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")

==================================================================
BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: slab-out-of-bounds in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
BUG: KASAN: slab-out-of-bounds in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: slab-out-of-bounds in __refcount_add_not_zero include/linux/refcount.h:152 [inline]
BUG: KASAN: slab-out-of-bounds in __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
BUG: KASAN: slab-out-of-bounds in refcount_inc_not_zero include/linux/refcount.h:245 [inline]
BUG: KASAN: slab-out-of-bounds in sk_psock_get+0x123/0x410 include/linux/skmsg.h:449
Read of size 4 at addr ffff888011d9c2b8 by task syz-executor654/8452

CPU: 0 PID: 8452 Comm: syz-executor654 Not tainted 5.14.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 __refcount_add_not_zero include/linux/refcount.h:152 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 sk_psock_get+0x123/0x410 include/linux/skmsg.h:449
 tls_sw_recvmsg+0x19e/0x1670 net/tls/tls_sw.c:1761
 inet_recvmsg+0x11b/0x5e0 net/ipv4/af_inet.c:852
 sock_recvmsg_nosec net/socket.c:943 [inline]
 sock_recvmsg net/socket.c:961 [inline]
 sock_recvmsg net/socket.c:957 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2611
 ___sys_recvmsg+0x127/0x200 net/socket.c:2653
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2747
 __sys_recvmmsg net/socket.c:2826 [inline]
 __do_sys_recvmmsg net/socket.c:2849 [inline]
 __se_sys_recvmmsg net/socket.c:2842 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2842
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f4f9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd2e991cd8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f4f9
RDX: 000000000000000a RSI: 00000000200030c0 RDI: 0000000000000005
RBP: 00000000004034e0 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000010000 R11: 0000000000000246 R12: 0000000000403570
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488

Allocated by task 8452:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:2959 [inline]
 slab_alloc mm/slub.c:2967 [inline]
 kmem_cache_alloc+0x285/0x4a0 mm/slub.c:2972
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 kcm_attach net/kcm/kcmsock.c:1404 [inline]
 kcm_attach_ioctl net/kcm/kcmsock.c:1489 [inline]
 kcm_ioctl+0x7f1/0x1180 net/kcm/kcmsock.c:1695
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
 sock_ioctl+0x477/0x6a0 net/socket.c:1221
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1332
 __queue_work+0x5c1/0xed0 kernel/workqueue.c:1498
 queue_work_on+0xee/0x110 kernel/workqueue.c:1525
 kcm_attach net/kcm/kcmsock.c:1465 [inline]
 kcm_attach_ioctl net/kcm/kcmsock.c:1489 [inline]
 kcm_ioctl+0xede/0x1180 net/kcm/kcmsock.c:1695
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
 sock_ioctl+0x477/0x6a0 net/socket.c:1221
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888011d9c000
 which belongs to the cache kcm_psock_cache of size 568
The buggy address is located 128 bytes to the right of
 568-byte region [ffff888011d9c000, ffff888011d9c238)
The buggy address belongs to the page:
page:ffffea0000476700 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11d9c
head:ffffea0000476700 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff8881478543c0
raw: 0000000000000000 0000000080170017 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 8452, ts 72409999814, free_ts 72272935271
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1691 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1831
 new_slab mm/slub.c:1894 [inline]
 new_slab_objects mm/slub.c:2640 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2803
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2843
 slab_alloc_node mm/slub.c:2925 [inline]
 slab_alloc mm/slub.c:2967 [inline]
 kmem_cache_alloc+0x3e1/0x4a0 mm/slub.c:2972
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 kcm_attach net/kcm/kcmsock.c:1404 [inline]
 kcm_attach_ioctl net/kcm/kcmsock.c:1489 [inline]
 kcm_ioctl+0x7f1/0x1180 net/kcm/kcmsock.c:1695
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
 sock_ioctl+0x477/0x6a0 net/socket.c:1221
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1346 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1397
 free_unref_page_prepare mm/page_alloc.c:3332 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3411
 __put_page+0xf9/0x3f0 mm/swap.c:127
 put_page include/linux/mm.h:1246 [inline]
 __skb_frag_unref include/linux/skbuff.h:3102 [inline]
 skb_release_data+0x49d/0x790 net/core/skbuff.c:671
 skb_release_all net/core/skbuff.c:741 [inline]
 __kfree_skb net/core/skbuff.c:755 [inline]
 consume_skb net/core/skbuff.c:911 [inline]
 consume_skb+0xc2/0x160 net/core/skbuff.c:905
 unix_stream_read_generic+0x15a2/0x19e0 net/unix/af_unix.c:2460
 unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2518
 sock_recvmsg_nosec net/socket.c:943 [inline]
 sock_recvmsg net/socket.c:961 [inline]
 sock_recvmsg net/socket.c:957 [inline]
 sock_read_iter+0x33c/0x470 net/socket.c:1034
 call_read_iter include/linux/fs.h:2108 [inline]
 new_sync_read+0x5b7/0x6e0 fs/read_write.c:415
 vfs_read+0x35c/0x570 fs/read_write.c:496
 ksys_read+0x1ee/0x250 fs/read_write.c:634
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888011d9c180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888011d9c200: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
>ffff888011d9c280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                        ^
 ffff888011d9c300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888011d9c380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
