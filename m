Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44490647DC0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 07:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLIG2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 01:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLIG2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 01:28:42 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AFB31ECD
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 22:28:41 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id h9-20020a92c269000000b00303494c4f3eso3155299ild.15
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 22:28:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p8I01iF6fK7P+Y0hROsTsUpSWcysS+l/B8KHOsUgNWI=;
        b=EWhXJLUOWbCZkkHrn1nNW9Glmen4jGCPPhZ+Ov3avtPHh803a3MVyftdi0ks7zXnly
         Yn2h+YoeXG/1OM1Zceh+Hgr8UnXmMCAMFwUi5NB3L/PGGeZA6lRNcANqFZtCWlADsZr3
         ppnYd98+Pi2ADTgyzuwNPCQzCdHVVOGw52wL83/8qLvLBGoCiFeoHVAWTG2jVjN+QUsQ
         i+3LdTstQ6WANDUYeGBCezf2BZrcEbNRQ/+eXOTNzVO+XoEptyZD5oEp32SdvTEX9e6A
         cA622+iBUiyhgWWoxAclehMtDG7UkwMjWJeLby9z4N0emjU2iVtB2Ox+9loBK6hhZFih
         cWcw==
X-Gm-Message-State: ANoB5pmDkBj75hl8mouBAJ/nSLK1AcddX+Y8R2WlLotl5TI44vhxJWhY
        n2YUruGX0TRFq/QeZEHX04xQLLBxQzMT5gkvIXVQPEelkoiz
X-Google-Smtp-Source: AA0mqf7G0BdWc/F922mhaD447+vTgnFR6ukyq2q8uxFKKJrNkCF/2Mk2f8M7c0AR8oZIkUZkOm0JEMtNlajxBRWip+DzNsqdrqSV
MIME-Version: 1.0
X-Received: by 2002:a92:cc08:0:b0:303:824b:25e5 with SMTP id
 s8-20020a92cc08000000b00303824b25e5mr2504301ilp.44.1670567321180; Thu, 08 Dec
 2022 22:28:41 -0800 (PST)
Date:   Thu, 08 Dec 2022 22:28:41 -0800
In-Reply-To: <00000000000017ace905ef2b739d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0a98a05ef5f436b@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rxrpc_destroy_all_locals
From:   syzbot <syzbot+1eb4232fca28c0a6d1c2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        hdanton@sina.com, kuba@kernel.org, linux-afs@lists.infradead.org,
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    591cd61541b9 Add linux-next specific files for 20221207
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1391f17d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b2d3e63e054c24f
dashboard link: https://syzkaller.appspot.com/bug?extid=1eb4232fca28c0a6d1c2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b597bd880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1008851d880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bc862c01ec56/disk-591cd615.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8f9b93f8ed2f/vmlinux-591cd615.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9d5cb636d548/bzImage-591cd615.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1eb4232fca28c0a6d1c2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:72 [inline]
BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: use-after-free in rxrpc_destroy_all_locals+0x10a/0x180 net/rxrpc/local_object.c:434
Read of size 4 at addr ffff888078ad0014 by task kworker/u4:2/31

CPU: 0 PID: 31 Comm: kworker/u4:2 Not tainted 6.1.0-rc8-next-20221207-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:72 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 rxrpc_destroy_all_locals+0x10a/0x180 net/rxrpc/local_object.c:434
 rxrpc_exit_net+0x174/0x300 net/rxrpc/net_ns.c:128
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:169
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:606
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Allocated by task 5248:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 rxrpc_alloc_local net/rxrpc/local_object.c:93 [inline]
 rxrpc_lookup_local+0x4d9/0xfb0 net/rxrpc/local_object.c:249
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 afs_open_socket+0x1b4/0x360 fs/afs/rxrpc.c:64
 afs_net_init+0xa79/0xed0 fs/afs/main.c:126
 ops_init+0xb9/0x680 net/core/net_namespace.c:135
 setup_net+0x793/0xe60 net/core/net_namespace.c:333
 copy_net_ns+0x31b/0x6b0 net/core/net_namespace.c:483
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x3b3/0x4a0 kernel/nsproxy.c:179
 copy_process+0x30d3/0x75c0 kernel/fork.c:2269
 kernel_clone+0xeb/0xa40 kernel/fork.c:2681
 __do_sys_clone3+0x1d1/0x370 kernel/fork.c:2980
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 5069:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3800
 rcu_do_batch kernel/rcu/tree.c:2244 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2504
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 __call_rcu_common.constprop.0+0x99/0x820 kernel/rcu/tree.c:2753
 rxrpc_put_local.part.0+0x128/0x170 net/rxrpc/local_object.c:332
 rxrpc_put_local+0x25/0x30 net/rxrpc/local_object.c:324
 rxrpc_release_sock net/rxrpc/af_rxrpc.c:888 [inline]
 rxrpc_release+0x237/0x550 net/rxrpc/af_rxrpc.c:914
 __sock_release net/socket.c:650 [inline]
 sock_release+0x8b/0x1b0 net/socket.c:678
 afs_close_socket+0x1ce/0x330 fs/afs/rxrpc.c:125
 afs_net_exit+0x179/0x320 fs/afs/main.c:158
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:169
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:606
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

The buggy address belongs to the object at ffff888078ad0000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 20 bytes inside of
 1024-byte region [ffff888078ad0000, ffff888078ad0400)

The buggy address belongs to the physical page:
page:ffffea0001e2b400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x78ad0
head:ffffea0001e2b400 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5248, tgid 5245 (syz-executor423), ts 105105032247, free_ts 45157750006
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1062
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 rxrpc_alloc_local net/rxrpc/local_object.c:93 [inline]
 rxrpc_lookup_local+0x4d9/0xfb0 net/rxrpc/local_object.c:249
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 afs_open_socket+0x1b4/0x360 fs/afs/rxrpc.c:64
 afs_net_init+0xa79/0xed0 fs/afs/main.c:126
 ops_init+0xb9/0x680 net/core/net_namespace.c:135
 setup_net+0x793/0xe60 net/core/net_namespace.c:333
 copy_net_ns+0x31b/0x6b0 net/core/net_namespace.c:483
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1446 [inline]
 free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1496
 free_unref_page_prepare mm/page_alloc.c:3369 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2637
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:761 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 slab_alloc mm/slub.c:3460 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3467 [inline]
 kmem_cache_alloc+0x1e4/0x430 mm/slub.c:3476
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:139
 getname_flags+0x9e/0xe0 include/linux/audit.h:320
 vfs_fstatat+0x77/0xb0 fs/stat.c:275
 __do_sys_newfstatat+0x8a/0x110 fs/stat.c:446
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff888078acff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888078acff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888078ad0000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff888078ad0080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888078ad0100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

