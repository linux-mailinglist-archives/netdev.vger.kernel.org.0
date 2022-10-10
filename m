Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8A55FA268
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiJJRFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJJRFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:05:40 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5059FBE21
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 10:05:37 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id l5-20020a056e0212e500b002fa8ea32922so8902489iln.15
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 10:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bdnBwyWQNP6LwV2QZq+nL6iBtHxQVOhYTlMsIZyqo8o=;
        b=1L7WATt3hqn4adDPQQLKkSIQiTApZF0p9XuTo0fjkO2I7La0x2GBREyzkZzuxnZ2MP
         IOWMu/qQd2L8W0naHMYEycRuJbLQ8deYWydBWSNsZtK8eW8/qVa586X+7ZyXuwiC6H8j
         kEY/cmIpbVGhN7UKq+SfhsTRwnS7yrqSmYszggIkGlDTZQC16tzsk2XjKSC+aFR8uddG
         ytiLa+DWPzFNHb3aTELvPD85chbCXMzxPjYumtMRXabqfKBKVGyn9H/yPn1yExvAfOIB
         +6np/O38kSzCb1nc/wZ/fvRoswPRPjwC//JyUkzMnDtoLhUUc0DJJyXJW7+n6zmdBjSm
         1Ijw==
X-Gm-Message-State: ACrzQf3X8KRXqkGUL6wPehXRBqD82OZeo9/LQM/U29m9FeAUM9YpfHbF
        rqjjHKZp3nCx8I3z7uGPK/cFoQyVmT1iU/kSdHTfJlKyD6ij
X-Google-Smtp-Source: AMsMyM4Q9wilIK+lq8xuSlNEIpudZRQVKQOzBZsH0BadeiUSLrP3A73IoQOPNxwC1Jl0+m4DDnXLc6TfdNLgkpOjFaMY7UE5R1Vr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1583:b0:2d7:a75d:888f with SMTP id
 m3-20020a056e02158300b002d7a75d888fmr9284881ilu.13.1665421536670; Mon, 10 Oct
 2022 10:05:36 -0700 (PDT)
Date:   Mon, 10 Oct 2022 10:05:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000183b8605eab12bc7@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nf_tables_trans_destroy_work
From:   syzbot <syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
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

HEAD commit:    e8bc52cb8df8 Merge tag 'driver-core-6.1-rc1' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12bfa5cc880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7579993da6496f03
dashboard link: https://syzkaller.appspot.com/bug?extid=8f747f62763bc6c32916
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a9431c880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1338e2dc880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4dc25a89bfbd/disk-e8bc52cb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/16c9ca5fd754/vmlinux-e8bc52cb.xz

The issue was bisected to:

commit 9dd732e0bdf538b1b76dc7c157e2b5e560ff30d3
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jun 6 15:15:57 2022 +0000

    netfilter: nf_tables: memleak flow rule from commit path

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12e6a51c880000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11e6a51c880000
console output: https://syzkaller.appspot.com/x/log.txt?x=16e6a51c880000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com
Fixes: 9dd732e0bdf5 ("netfilter: nf_tables: memleak flow rule from commit path")

==================================================================
BUG: KASAN: use-after-free in nft_commit_release net/netfilter/nf_tables_api.c:8467 [inline]
BUG: KASAN: use-after-free in nf_tables_trans_destroy_work+0xeb5/0xf40 net/netfilter/nf_tables_api.c:8513
Read of size 1 at addr ffff88807706d154 by task kworker/1:2/2554

CPU: 1 PID: 2554 Comm: kworker/1:2 Not tainted 6.0.0-syzkaller-07994-ge8bc52cb8df8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Workqueue: events nf_tables_trans_destroy_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 print_address_description+0x65/0x4b0 mm/kasan/report.c:317
 print_report+0x108/0x220 mm/kasan/report.c:433
 kasan_report+0xfb/0x130 mm/kasan/report.c:495
 nft_commit_release net/netfilter/nf_tables_api.c:8467 [inline]
 nf_tables_trans_destroy_work+0xeb5/0xf40 net/netfilter/nf_tables_api.c:8513
 process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 4635:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc+0xdc/0x110 mm/kasan/common.c:516
 kasan_kmalloc include/linux/kasan.h:234 [inline]
 kmem_cache_alloc_trace+0x97/0x310 mm/slub.c:3289
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 nf_tables_addchain net/netfilter/nf_tables_api.c:2257 [inline]
 nf_tables_newchain+0x1487/0x30b0 net/netfilter/nf_tables_api.c:2595
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:517 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:638 [inline]
 nfnetlink_rcv+0x1231/0x2640 net/netfilter/nfnetlink.c:656
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7e7/0x9c0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x9b3/0xcd0 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x597/0x8e0 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x28e/0x390 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 4635:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4c/0x70 mm/kasan/common.c:45
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
 ____kasan_slab_free+0xd8/0x120 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1759 [inline]
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0xda/0x210 mm/slub.c:4567
 __nft_release_table+0xc88/0xea0 net/netfilter/nf_tables_api.c:9996
 nft_rcv_nl_event+0x48b/0x570 net/netfilter/nf_tables_api.c:10047
 notifier_call_chain kernel/notifier.c:87 [inline]
 blocking_notifier_call_chain+0x108/0x1b0 kernel/notifier.c:382
 netlink_release+0xf0a/0x1720 net/netlink/af_netlink.c:790
 __sock_release net/socket.c:650 [inline]
 sock_close+0xd7/0x260 net/socket.c:1365
 __fput+0x3ba/0x880 fs/file_table.c:320
 task_work_run+0x146/0x1c0 kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop+0x134/0x160 kernel/entry/common.c:169
 exit_to_user_mode_prepare+0xad/0x110 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x2e/0x60 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807706d100
 which belongs to the cache kmalloc-cg-128 of size 128
The buggy address is located 84 bytes inside of
 128-byte region [ffff88807706d100, ffff88807706d180)

The buggy address belongs to the physical page:
page:ffffea0001dc1b40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7706d
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 0000000000000000 dead000000000122 ffff888012042a00
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 4634, tgid 4634 (syz-executor385), ts 38089885211, free_ts 38088010177
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x72b/0x7a0 mm/page_alloc.c:4283
 __alloc_pages+0x259/0x560 mm/page_alloc.c:5549
 alloc_slab_page+0x70/0xf0 mm/slub.c:1829
 allocate_slab+0x5e/0x520 mm/slub.c:1974
 new_slab mm/slub.c:2034 [inline]
 ___slab_alloc+0x42e/0xce0 mm/slub.c:3036
 __slab_alloc mm/slub.c:3123 [inline]
 slab_alloc_node mm/slub.c:3214 [inline]
 slab_alloc mm/slub.c:3256 [inline]
 kmem_cache_alloc_trace+0x25f/0x310 mm/slub.c:3287
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 nf_tables_addchain net/netfilter/nf_tables_api.c:2257 [inline]
 nf_tables_newchain+0x1487/0x30b0 net/netfilter/nf_tables_api.c:2595
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:517 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:638 [inline]
 nfnetlink_rcv+0x1231/0x2640 net/netfilter/nfnetlink.c:656
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7e7/0x9c0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x9b3/0xcd0 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x597/0x8e0 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x28e/0x390 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x812/0x900 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page_list+0xb4/0x7b0 mm/page_alloc.c:3522
 release_pages+0x22c3/0x2540 mm/swap.c:1012
 tlb_batch_pages_flush mm/mmu_gather.c:58 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:255 [inline]
 tlb_flush_mmu+0x850/0xa70 mm/mmu_gather.c:262
 tlb_finish_mmu+0xcb/0x200 mm/mmu_gather.c:353
 exit_mmap+0x1dc/0x530 mm/mmap.c:3118
 __mmput+0x111/0x3a0 kernel/fork.c:1187
 exit_mm+0x211/0x2f0 kernel/exit.c:510
 do_exit+0x4e1/0x20a0 kernel/exit.c:782
 do_group_exit+0x23b/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88807706d000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807706d080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807706d100: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                 ^
 ffff88807706d180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807706d200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
