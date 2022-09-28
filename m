Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD075ED9CF
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 12:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiI1KHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 06:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiI1KHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 06:07:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1981B2859;
        Wed, 28 Sep 2022 03:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 273A661DF2;
        Wed, 28 Sep 2022 10:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080A9C433C1;
        Wed, 28 Sep 2022 10:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664359647;
        bh=h0nDlbC/dZHzfRyNu6g+FNQFymHs+yO1wz2etuCjlKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oPg/RbF7j4iXbWJl1PmXufJMaS/veLl2bQ+5cJMIHghLeC/n9IYME8D8bRECWwqHa
         EaLSpEi5MVoVtLtlAAdeNy/Ix0a4OVGTOYHfxFmiYSubKcmJnLcIJhRLkYKaz//plN
         pFeLobPsRuYDjtstFSKTrfiQ3tjyGokdDz6GIPe1dqhK1CDUCEHaUwQvlguckosn8E
         btEDIwOT085sfIvDJLAjrtn97marSMOyArYgAs3Px0tG7gHb2H8FD9cam/r0VoeMY0
         gHBEwer7u/hVKH7d7f35uRkLQAtqjZgjjaKCNnk77d5FvSNAIv/kCSJGnWbm6kcox1
         7O2SxXIqj2U+Q==
Date:   Wed, 28 Sep 2022 13:07:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>
Cc:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
Message-ID: <YzQc2yaDufjp+rHc@unreal>
References: <00000000000015ac7905e97ebaed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 04:29:40AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    483fed3b5dc8 Add linux-next specific files for 20220921
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=11450b0f080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=849cb9f70f15b1ba
> dashboard link: https://syzkaller.appspot.com/bug?extid=67d13108d855f451cafc
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c18ce4880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12046b8c880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/1cb3f4618323/disk-483fed3b.raw.xz
> vmlinux: https://storage.googleapis.com/cc02cb30b495/vmlinux-483fed3b.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in rdma_close+0xaf/0xc0 net/9p/trans_rdma.c:555
> Read of size 8 at addr ffff888016c73408 by task syz-executor151/3608
> 
> CPU: 0 PID: 3608 Comm: syz-executor151 Not tainted 6.0.0-rc6-next-20220921-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:284 [inline]
>  print_report+0x15e/0x45d mm/kasan/report.c:395
>  kasan_report+0xbb/0x1f0 mm/kasan/report.c:495
>  rdma_close+0xaf/0xc0 net/9p/trans_rdma.c:555
>  p9_client_destroy+0xbe/0x370 net/9p/client.c:1040
>  p9_client_create+0x728/0xf20 net/9p/client.c:1027
>  v9fs_session_init+0x1e2/0x1810 fs/9p/v9fs.c:408
>  v9fs_mount+0xba/0xc90 fs/9p/vfs_super.c:126
>  legacy_get_tree+0x105/0x220 fs/fs_context.c:610
>  vfs_get_tree+0x89/0x2f0 fs/super.c:1530
>  do_new_mount fs/namespace.c:3040 [inline]
>  path_mount+0x1326/0x1e20 fs/namespace.c:3370
>  do_mount fs/namespace.c:3383 [inline]
>  __do_sys_mount fs/namespace.c:3591 [inline]
>  __se_sys_mount fs/namespace.c:3568 [inline]
>  __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f9a65969039
> Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffda4b921e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffda4b921f8 RCX: 00007f9a65969039
> RDX: 0000000020000080 RSI: 0000000020000040 RDI: 0000000020000000
> RBP: 00007ffda4b921f0 R08: 00000000200000c0 R09: 00007f9a65927300
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> Allocated by task 3608:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x21/0x30 mm/kasan/common.c:52
>  ____kasan_kmalloc mm/kasan/common.c:371 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:330 [inline]
>  __kasan_kmalloc+0xa1/0xb0 mm/kasan/common.c:380
>  kmalloc include/linux/slab.h:559 [inline]
>  kzalloc include/linux/slab.h:695 [inline]
>  alloc_rdma net/9p/trans_rdma.c:567 [inline]
>  rdma_create_trans+0x24f/0x13d0 net/9p/trans_rdma.c:644
>  p9_client_create+0x7ef/0xf20 net/9p/client.c:992
>  v9fs_session_init+0x1e2/0x1810 fs/9p/v9fs.c:408
>  v9fs_mount+0xba/0xc90 fs/9p/vfs_super.c:126
>  legacy_get_tree+0x105/0x220 fs/fs_context.c:610
>  vfs_get_tree+0x89/0x2f0 fs/super.c:1530
>  do_new_mount fs/namespace.c:3040 [inline]
>  path_mount+0x1326/0x1e20 fs/namespace.c:3370
>  do_mount fs/namespace.c:3383 [inline]
>  __do_sys_mount fs/namespace.c:3591 [inline]
>  __se_sys_mount fs/namespace.c:3568 [inline]
>  __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 3608:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x21/0x30 mm/kasan/common.c:52
>  kasan_save_free_info+0x2a/0x40 mm/kasan/generic.c:511
>  ____kasan_slab_free mm/kasan/common.c:236 [inline]
>  ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>  kasan_slab_free include/linux/kasan.h:177 [inline]
>  slab_free_hook mm/slub.c:1669 [inline]
>  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1695
>  slab_free mm/slub.c:3599 [inline]
>  __kmem_cache_free+0xab/0x3b0 mm/slub.c:3612
>  rdma_destroy_trans+0x196/0x210 net/9p/trans_rdma.c:380
>  rdma_create_trans+0x1076/0x13d0 net/9p/trans_rdma.c:735
>  p9_client_create+0x7ef/0xf20 net/9p/client.c:992
>  v9fs_session_init+0x1e2/0x1810 fs/9p/v9fs.c:408
>  v9fs_mount+0xba/0xc90 fs/9p/vfs_super.c:126
>  legacy_get_tree+0x105/0x220 fs/fs_context.c:610
>  vfs_get_tree+0x89/0x2f0 fs/super.c:1530
>  do_new_mount fs/namespace.c:3040 [inline]
>  path_mount+0x1326/0x1e20 fs/namespace.c:3370
>  do_mount fs/namespace.c:3383 [inline]
>  __do_sys_mount fs/namespace.c:3591 [inline]
>  __se_sys_mount fs/namespace.c:3568 [inline]
>  __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The buggy address belongs to the object at ffff888016c73400
>  which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 8 bytes inside of
>  512-byte region [ffff888016c73400, ffff888016c73600)
> 
> The buggy address belongs to the physical page:
> page:ffffea00005b1c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16c70
> head:ffffea00005b1c00 order:2 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffff888011841c80 dead000080100010 0000000000000000
> raw: 0000000000000000 dead000000000001 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 2303057531, free_ts 0
>  prep_new_page mm/page_alloc.c:2538 [inline]
>  get_page_from_freelist+0x1092/0x2d20 mm/page_alloc.c:4286
>  __alloc_pages+0x1c7/0x5a0 mm/page_alloc.c:5545
>  alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2113
>  alloc_pages+0x22f/0x270 mm/mempolicy.c:2275
>  alloc_slab_page mm/slub.c:1739 [inline]
>  allocate_slab+0x213/0x300 mm/slub.c:1884
>  new_slab mm/slub.c:1937 [inline]
>  ___slab_alloc+0xac1/0x1430 mm/slub.c:3119
>  __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3217
>  slab_alloc_node mm/slub.c:3302 [inline]
>  __kmem_cache_alloc_node+0x18a/0x3d0 mm/slub.c:3375
>  __do_kmalloc_node mm/slab_common.c:933 [inline]
>  __kmalloc+0x44/0xc0 mm/slab_common.c:947
>  kmalloc include/linux/slab.h:564 [inline]
>  kzalloc include/linux/slab.h:695 [inline]
>  alloc_workqueue+0x14b/0x1020 kernel/workqueue.c:4314
>  padata_alloc+0xc8/0x4d0 kernel/padata.c:984
>  pcrypt_init_padata+0x1b/0xf5 crypto/pcrypt.c:323
>  pcrypt_init+0x70/0xef crypto/pcrypt.c:348
>  do_one_initcall+0x13d/0x780 init/main.c:1307
>  do_initcall_level init/main.c:1382 [inline]
>  do_initcalls init/main.c:1398 [inline]
>  do_basic_setup init/main.c:1417 [inline]
>  kernel_init_freeable+0x6ff/0x788 init/main.c:1637
>  kernel_init+0x1a/0x1d0 init/main.c:1525
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
>  ffff888016c73300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888016c73380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888016c73400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                       ^
>  ffff888016c73480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888016c73500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================

The bug is in commit 3ff51294a055 ("9p: p9_client_create: use p9_client_destroy on failure").
It is wrong to call to p9_client_destroy() if clnt->trans_mod->create fails.

Thanks

> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
