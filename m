Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6157F64526D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLGDJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiLGDJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:09:18 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5094C45A2F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 19:09:17 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id t2-20020a6b6402000000b006dea34ad528so12836352iog.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 19:09:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=39D9kO1luapGbdQ+JySvhthEWlKCKyecIdW50r+tanU=;
        b=Lxaz/2x+KB7wKRZOI5+Tzty43jEIuPzbMFRUGBvX2y0IooeNop6p7xMTR7eAU+tF+W
         FCcNq+tcEAVC7MSRyVYlXZCFanrDP0A+7Ctm0uYPG311SXqekaH0RkRl4q7gklJ0BcoA
         1R1Y6OiBGw0RW54dKfh/3sDMzNEsWEwXrmABxlRFPkS67wTdet4oMbdpyQtv87oWgciC
         DWOnvcoPdMztFU56d/B8e3L43o6tcyMMtZiBgTf+iNBMkOhpVvIDLk/XqPxJqEcSH+do
         X+GWr9MltHoNJT3EGn3wdLsvzLn1om2ofDxEKAeohZ/EgJiMoWdTlibjXFaRkC+YyLjZ
         IZ6w==
X-Gm-Message-State: ANoB5plUExDNkUP4nTIbd3fTZD1oZzFOqgsc838bn630kbLtIq2+t4Uo
        ahB3EqVFEXy86d4r+t5OLMSsETvv3Mfj2gGQ6CQWH4h22ut2
X-Google-Smtp-Source: AA0mqf7y7q1IqV+VvX1rV5gyZI05cNzrwEqFKBpDWQXX6y30iMRKGnxQvRWCnxyYBXOrJVGFzf3FBBFz6c9sUP64f+NfDODo+6WF
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:66d:b0:303:1196:96c7 with SMTP id
 l13-20020a056e02066d00b00303119696c7mr20755335ilt.133.1670382556696; Tue, 06
 Dec 2022 19:09:16 -0800 (PST)
Date:   Tue, 06 Dec 2022 19:09:16 -0800
In-Reply-To: <1265526.1670360970@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ee5c1205ef343ea1@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rxrpc_lookup_local
From:   syzbot <syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
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

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: use-after-free Read in rxrpc_lookup_local

==================================================================
BUG: KASAN: use-after-free in rxrpc_local_cmp_key net/rxrpc/local_object.c:53 [inline]
BUG: KASAN: use-after-free in rxrpc_lookup_local+0xdcf/0xfb0 net/rxrpc/local_object.c:224
Read of size 2 at addr ffff88807652021c by task syz-executor.0/4166

CPU: 0 PID: 4166 Comm: syz-executor.0 Not tainted 6.1.0-rc7-syzkaller-01816-gb93884eea26f-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 rxrpc_local_cmp_key net/rxrpc/local_object.c:53 [inline]
 rxrpc_lookup_local+0xdcf/0xfb0 net/rxrpc/local_object.c:224
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 __sys_bind+0x1ed/0x260 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x73/0xb0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7809a8c0d9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f780a709168 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007f7809babf80 RCX: 00007f7809a8c0d9
RDX: 0000000000000024 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00007f7809ae7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff714ad7bf R14: 00007f780a709300 R15: 0000000000022000
 </TASK>

Allocated by task 4161:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:553 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 rxrpc_alloc_local net/rxrpc/local_object.c:93 [inline]
 rxrpc_lookup_local+0x4d9/0xfb0 net/rxrpc/local_object.c:249
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 __sys_bind+0x1ed/0x260 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x73/0xb0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 21:
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
 rcu_do_batch kernel/rcu/tree.c:2250 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2510
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 call_rcu+0x9d/0x820 kernel/rcu/tree.c:2798
 rxrpc_put_local.part.0+0x128/0x170 net/rxrpc/local_object.c:332
 rxrpc_put_local+0x25/0x30 net/rxrpc/local_object.c:324
 rxrpc_release_sock net/rxrpc/af_rxrpc.c:888 [inline]
 rxrpc_release+0x237/0x550 net/rxrpc/af_rxrpc.c:914
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

The buggy address belongs to the object at ffff888076520000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 540 bytes inside of
 1024-byte region [ffff888076520000, ffff888076520400)

The buggy address belongs to the physical page:
page:ffffea0001d94800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x76520
head:ffffea0001d94800 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888012041dc0
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 4161, tgid 4160 (syz-executor.0), ts 79477960432, free_ts 79222719756
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
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1045
 kmalloc include/linux/slab.h:553 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 rxrpc_alloc_local net/rxrpc/local_object.c:93 [inline]
 rxrpc_lookup_local+0x4d9/0xfb0 net/rxrpc/local_object.c:249
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 __sys_bind+0x1ed/0x260 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x73/0xb0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
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
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1045
 kmalloc include/linux/slab.h:553 [inline]
 netdevice_queue_work drivers/infiniband/core/roce_gid_mgmt.c:643 [inline]
 netdevice_event+0x368/0x8f0 drivers/infiniband/core/roce_gid_mgmt.c:802
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 dev_set_mac_address+0x2d7/0x3e0 net/core/dev.c:8791
 dev_set_mac_address_user+0x31/0x50 net/core/dev.c:8805
 do_setlink+0x18c4/0x3bb0 net/core/rtnetlink.c:2775
 __rtnl_newlink+0xd69/0x1840 net/core/rtnetlink.c:3590
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3637

Memory state around the buggy address:
 ffff888076520100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888076520180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888076520200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff888076520280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888076520300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         b93884ee net/ncsi: Silence runtime memcpy() false posi..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=144320db880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c608c21151db14f2
dashboard link: https://syzkaller.appspot.com/bug?extid=3538a6a72efa8b059c38
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=145e216b880000

