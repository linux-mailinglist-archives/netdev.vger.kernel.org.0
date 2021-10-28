Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A28643E9FD
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 23:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhJ1VKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 17:10:53 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:46626 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhJ1VKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 17:10:52 -0400
Received: by mail-il1-f198.google.com with SMTP id x18-20020a92cc92000000b00259b4330356so4738801ilo.13
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 14:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6NzFce7Pw7qNcB8YmeiaxpMHIy2D+DdavaiwAN7zUoI=;
        b=67f2P3j/kXn8yEtlL9EYvf/Iec8KXMGLJgLPUq1KivS2H8/ULxjcTc5BQL7fTryQPQ
         BVXdEmrbupim4mnXcA58LYP028nihGTJOzmMLLl6RsYzoEnicaasRdtA/BQzq86gHyMp
         cqPXAC/Ps86/VUqwy/t7jRdSyH1tPqHkfO2JOqy/PEuXVapglZB7oG5FDKY9eauucrAf
         t9cxPhJ/aFgFcjWbEG+dfJDKWZ1AFYI5xYMKDNtfs04H8lnlAtR+ND1nom98pMsQpBcM
         bw62S5JsDYHKhP8M+pRHgG2nlbLyxdrhXjSGoD0Bgcs4iQao1tI64D4k+4DI3ZIPMQFW
         2FlQ==
X-Gm-Message-State: AOAM531a+N9lDFO0jMITc06mlcHt6qBLV7X/XMvBgB2UuyLuEgPodzoS
        LjHXzvpNv1jGbwN9SRhnUUHICK4EVg3XFv2jqQ5bCuJM2cJf
X-Google-Smtp-Source: ABdhPJytT+qOgte1XR6jLoRHbg4GeiPHoUuj7P3oaqTpZESucDlQavDApudXGQZqqZUscFUAEzlXTQJs3pflHzEp0CAYkyHLqKsJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c9:: with SMTP id 9mr4872983ilx.166.1635455305054;
 Thu, 28 Oct 2021 14:08:25 -0700 (PDT)
Date:   Thu, 28 Oct 2021 14:08:25 -0700
In-Reply-To: <000000000000c1524005cdeacc5f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000081007a05cf701c86@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in veth_xdp_rcv
From:   syzbot <syzbot+67f89551088ea1a6850e@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, fgheet255t@gmail.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, toke@toke.dk, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    252c765bd764 riscv, bpf: Add BPF exception tables
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=165fc0f4b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f60548b4c38ae4a8
dashboard link: https://syzkaller.appspot.com/bug?extid=67f89551088ea1a6850e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1797fcf2b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e71f9f300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+67f89551088ea1a6850e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __ptr_ring_peek include/linux/ptr_ring.h:172 [inline]
BUG: KASAN: use-after-free in __ptr_ring_consume include/linux/ptr_ring.h:299 [inline]
BUG: KASAN: use-after-free in veth_xdp_rcv+0x70b/0x810 drivers/net/veth.c:856
Read of size 8 at addr ffff88807af6e008 by task ksoftirqd/0/13

CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 __ptr_ring_peek include/linux/ptr_ring.h:172 [inline]
 __ptr_ring_consume include/linux/ptr_ring.h:299 [inline]
 veth_xdp_rcv+0x70b/0x810 drivers/net/veth.c:856
 veth_poll+0x134/0x850 drivers/net/veth.c:913
 __napi_poll+0xaf/0x440 net/core/dev.c:6993
 napi_poll net/core/dev.c:7060 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7147
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:920 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 7543:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 kmalloc_node include/linux/slab.h:614 [inline]
 kvmalloc_node+0x61/0x120 mm/util.c:587
 kvmalloc include/linux/mm.h:805 [inline]
 kvmalloc_array include/linux/mm.h:823 [inline]
 __ptr_ring_init_queue_alloc include/linux/ptr_ring.h:471 [inline]
 ptr_ring_init include/linux/ptr_ring.h:489 [inline]
 __veth_napi_enable_range+0xa2/0x780 drivers/net/veth.c:941
 __veth_napi_enable drivers/net/veth.c:964 [inline]
 veth_enable_xdp+0x30f/0x620 drivers/net/veth.c:1068
 veth_xdp_set drivers/net/veth.c:1483 [inline]
 veth_xdp+0x4d4/0x780 drivers/net/veth.c:1523
 dev_xdp_install+0xd5/0x270 net/core/dev.c:9365
 dev_xdp_attach+0x83d/0x1010 net/core/dev.c:9513
 dev_xdp_attach_link net/core/dev.c:9532 [inline]
 bpf_xdp_link_attach+0x262/0x410 net/core/dev.c:9695
 link_create kernel/bpf/syscall.c:4268 [inline]
 __sys_bpf+0x549c/0x5df0 kernel/bpf/syscall.c:4667
 __do_sys_bpf kernel/bpf/syscall.c:4701 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4699 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4699
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 7542:
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
 ptr_ring_cleanup include/linux/ptr_ring.h:671 [inline]
 veth_napi_del_range+0x3aa/0x560 drivers/net/veth.c:985
 veth_napi_del drivers/net/veth.c:991 [inline]
 veth_disable_xdp+0x2b3/0x430 drivers/net/veth.c:1101
 veth_xdp_set drivers/net/veth.c:1499 [inline]
 veth_xdp+0x698/0x780 drivers/net/veth.c:1523
 dev_xdp_install+0x1ed/0x270 net/core/dev.c:9365
 dev_xdp_detach_link net/core/dev.c:9549 [inline]
 bpf_xdp_link_release+0x242/0x4e0 net/core/dev.c:9564
 bpf_link_free+0xe6/0x1b0 kernel/bpf/syscall.c:2427
 bpf_link_put+0x161/0x1b0 kernel/bpf/syscall.c:2453
 bpf_link_release+0x33/0x40 kernel/bpf/syscall.c:2461
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88807af6e000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 8 bytes inside of
 2048-byte region [ffff88807af6e000, ffff88807af6e800)
The buggy address belongs to the page:
page:ffffea0001ebda00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7af68
head:ffffea0001ebda00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010c42000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd28c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 7536, ts 1019839663090, free_ts 1019749588025
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
 __kmalloc_node_track_caller+0x2d2/0x340 mm/slub.c:4936
 kmalloc_reserve net/core/skbuff.c:352 [inline]
 pskb_expand_head+0x15e/0x1060 net/core/skbuff.c:1699
 netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1296
 netlink_broadcast+0x5b/0xd50 net/netlink/af_netlink.c:1492
 nlmsg_multicast include/net/netlink.h:1033 [inline]
 nlmsg_notify+0x8f/0x280 net/netlink/af_netlink.c:2528
 rtnl_notify net/core/rtnetlink.c:730 [inline]
 rtmsg_ifinfo_send net/core/rtnetlink.c:3833 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3848 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:3836 [inline]
 rtnetlink_event+0x193/0x1d0 net/core/rtnetlink.c:5623
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 netdev_features_change net/core/dev.c:1368 [inline]
 netdev_update_features net/core/dev.c:10035 [inline]
 netdev_update_features+0xc4/0xd0 net/core/dev.c:10032
 veth_xdp_set drivers/net/veth.c:1510 [inline]
 veth_xdp+0x448/0x780 drivers/net/veth.c:1523
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
 kmem_cache_alloc+0x209/0x390 mm/slub.c:3219
 vm_area_dup+0x88/0x2b0 kernel/fork.c:357
 __split_vma+0xa5/0x550 mm/mmap.c:2714
 split_vma+0x95/0xd0 mm/mmap.c:2772
 mprotect_fixup+0x678/0x940 mm/mprotect.c:477
 do_mprotect_pkey+0x558/0x9a0 mm/mprotect.c:636
 __do_sys_mprotect mm/mprotect.c:662 [inline]
 __se_sys_mprotect mm/mprotect.c:659 [inline]
 __x64_sys_mprotect+0x74/0xb0 mm/mprotect.c:659
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88807af6df00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807af6df80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807af6e000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88807af6e080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807af6e100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

