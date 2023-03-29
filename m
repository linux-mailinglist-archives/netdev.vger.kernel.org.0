Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDF46CD0C1
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 05:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjC2DiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 23:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjC2DiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 23:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0C9272A;
        Tue, 28 Mar 2023 20:38:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D85A561A47;
        Wed, 29 Mar 2023 03:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0140C433EF;
        Wed, 29 Mar 2023 03:37:59 +0000 (UTC)
Date:   Tue, 28 Mar 2023 22:37:57 -0500
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Message-ID: <ZCOylfbhuk0LeVff@do-x1extreme>
References: <0000000000006cf87705f79acf1a@google.com>
 <20230328184733.6707ef73@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328184733.6707ef73@kernel.org>
X-Spam-Status: No, score=-4.8 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 06:47:33PM -0700, Jakub Kicinski wrote:
> Seth, does this looks related to commit 267463823adb ("net: sch:
> eliminate unnecessary RCU waits in mini_qdisc_pair_swap()")
> by any chance?

I don't see how it could be. The memory being written is part of the
qdisc private memory, and tc_new_tfilter() takes a reference to the
qdisc. If that memory has been freed doesn't it mean that something has
done an unbalanced qdisc_put()?

> On Thu, 23 Mar 2023 17:52:40 -0700 syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    fff5a5e7f528 Merge tag 'for-linus' of git://git.armlinux.o..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11884731c80000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=aaa4b45720ca0519
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b53a9c0d1ea4ad62da8b
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d1497ac80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11eed636c80000
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/33a184f98b9d/disk-fff5a5e7.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/3d75f967571e/vmlinux-fff5a5e7.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/4eeb8edbdc7e/bzImage-fff5a5e7.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> > 
> > ==================================================================
> > BUG: KASAN: slab-use-after-free in mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
> > Write of size 8 at addr ffff888045b31308 by task syz-executor690/14901
> > 
> > CPU: 0 PID: 14901 Comm: syz-executor690 Not tainted 6.3.0-rc3-syzkaller-00026-gfff5a5e7f528 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
> >  print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:319
> >  print_report mm/kasan/report.c:430 [inline]
> >  kasan_report+0x11c/0x130 mm/kasan/report.c:536
> >  mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
> >  tcf_chain_head_change_item net/sched/cls_api.c:495 [inline]
> >  tcf_chain0_head_change.isra.0+0xb9/0x120 net/sched/cls_api.c:509
> >  tcf_chain_tp_insert net/sched/cls_api.c:1826 [inline]
> >  tcf_chain_tp_insert_unique net/sched/cls_api.c:1875 [inline]
> >  tc_new_tfilter+0x1de6/0x2290 net/sched/cls_api.c:2266
> >  rtnetlink_rcv_msg+0x996/0xd50 net/core/rtnetlink.c:6165
> >  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> >  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> >  netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
> >  sock_sendmsg_nosec net/socket.c:724 [inline]
> >  sock_sendmsg+0xde/0x190 net/socket.c:747
> >  ____sys_sendmsg+0x334/0x900 net/socket.c:2501
> >  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
> >  __sys_sendmmsg+0x18f/0x460 net/socket.c:2641
> >  __do_sys_sendmmsg net/socket.c:2670 [inline]
> >  __se_sys_sendmmsg net/socket.c:2667 [inline]
> >  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2667
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f4f11222579
> > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f4f11184208 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> > RAX: ffffffffffffffda RBX: 00007f4f112ab2a8 RCX: 00007f4f11222579
> > RDX: 040000000000009f RSI: 00000000200002c0 RDI: 0000000000000007
> > RBP: 00007f4f112ab2a0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4f112ab2ac
> > R13: 00007fffc8e5214f R14: 00007f4f11184300 R15: 0000000000022000
> >  </TASK>
> > 
> > Allocated by task 14898:
> >  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
> >  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
> >  ____kasan_kmalloc mm/kasan/common.c:374 [inline]
> >  ____kasan_kmalloc mm/kasan/common.c:333 [inline]
> >  __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
> >  kasan_kmalloc include/linux/kasan.h:196 [inline]
> >  __do_kmalloc_node mm/slab_common.c:967 [inline]
> >  __kmalloc_node+0x61/0x1a0 mm/slab_common.c:974
> >  kmalloc_node include/linux/slab.h:610 [inline]
> >  kzalloc_node include/linux/slab.h:731 [inline]
> >  qdisc_alloc+0xb0/0xb30 net/sched/sch_generic.c:938
> >  qdisc_create+0xce/0x1040 net/sched/sch_api.c:1244
> >  tc_modify_qdisc+0x488/0x1a40 net/sched/sch_api.c:1680
> >  rtnetlink_rcv_msg+0x43d/0xd50 net/core/rtnetlink.c:6174
> >  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> >  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> >  netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
> >  sock_sendmsg_nosec net/socket.c:724 [inline]
> >  sock_sendmsg+0xde/0x190 net/socket.c:747
> >  ____sys_sendmsg+0x334/0x900 net/socket.c:2501
> >  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
> >  __sys_sendmmsg+0x18f/0x460 net/socket.c:2641
> >  __do_sys_sendmmsg net/socket.c:2670 [inline]
> >  __se_sys_sendmmsg net/socket.c:2667 [inline]
> >  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2667
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > 
> > Freed by task 21:
> >  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
> >  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
> >  kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:521
> >  ____kasan_slab_free mm/kasan/common.c:236 [inline]
> >  ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
> >  kasan_slab_free include/linux/kasan.h:162 [inline]
> >  slab_free_hook mm/slub.c:1781 [inline]
> >  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
> >  slab_free mm/slub.c:3787 [inline]
> >  __kmem_cache_free+0xaf/0x2d0 mm/slub.c:3800
> >  rcu_do_batch kernel/rcu/tree.c:2112 [inline]
> >  rcu_core+0x814/0x1960 kernel/rcu/tree.c:2372
> >  __do_softirq+0x1d4/0x905 kernel/softirq.c:571
> > 
> > Last potentially related work creation:
> >  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
> >  __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
> >  __call_rcu_common.constprop.0+0x99/0x7e0 kernel/rcu/tree.c:2622
> >  qdisc_put_unlocked+0x73/0x90 net/sched/sch_generic.c:1097
> >  tcf_block_release+0x86/0x90 net/sched/cls_api.c:1362
> >  tc_new_tfilter+0xa35/0x2290 net/sched/cls_api.c:2331
> >  rtnetlink_rcv_msg+0x996/0xd50 net/core/rtnetlink.c:6165
> >  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> >  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> >  netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
> >  sock_sendmsg_nosec net/socket.c:724 [inline]
> >  sock_sendmsg+0xde/0x190 net/socket.c:747
> >  ____sys_sendmsg+0x334/0x900 net/socket.c:2501
> >  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
> >  __sys_sendmmsg+0x18f/0x460 net/socket.c:2641
> >  __do_sys_sendmmsg net/socket.c:2670 [inline]
> >  __se_sys_sendmmsg net/socket.c:2667 [inline]
> >  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2667
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > 
> > The buggy address belongs to the object at ffff888045b31000
> >  which belongs to the cache kmalloc-1k of size 1024
> > The buggy address is located 776 bytes inside of
> >  freed 1024-byte region [ffff888045b31000, ffff888045b31400)
> > 
> > The buggy address belongs to the physical page:
> > page:ffffea000116cc00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888045b37000 pfn:0x45b30
> > head:ffffea000116cc00 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> > anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> > raw: 00fff00000010200 ffff888012441dc0 0000000000000000 dead000000000001
> > raw: ffff888045b37000 000000008010000d 00000001ffffffff 0000000000000000
> > page dumped because: kasan: bad access detected
> > page_owner tracks the page as allocated
> > page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 14184, tgid 14168 (syz-executor690), ts 420322459064, free_ts 15493742100
> >  prep_new_page mm/page_alloc.c:2552 [inline]
> >  get_page_from_freelist+0x1190/0x2e20 mm/page_alloc.c:4325
> >  __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:5591
> >  alloc_pages+0x1aa/0x270 mm/mempolicy.c:2283
> >  alloc_slab_page mm/slub.c:1851 [inline]
> >  allocate_slab+0x25f/0x390 mm/slub.c:1998
> >  new_slab mm/slub.c:2051 [inline]
> >  ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
> >  __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
> >  __slab_alloc_node mm/slub.c:3345 [inline]
> >  slab_alloc_node mm/slub.c:3442 [inline]
> >  __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3491
> >  kmalloc_trace+0x26/0xe0 mm/slab_common.c:1061
> >  kmalloc include/linux/slab.h:580 [inline]
> >  kmalloc_array include/linux/slab.h:635 [inline]
> >  kcalloc include/linux/slab.h:667 [inline]
> >  fl_change+0x1cf/0x4ac0 net/sched/cls_flower.c:2175
> >  tc_new_tfilter+0x97c/0x2290 net/sched/cls_api.c:2310
> >  rtnetlink_rcv_msg+0x996/0xd50 net/core/rtnetlink.c:6165
> >  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> >  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> >  netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
> >  sock_sendmsg_nosec net/socket.c:724 [inline]
> >  sock_sendmsg+0xde/0x190 net/socket.c:747
> >  ____sys_sendmsg+0x334/0x900 net/socket.c:2501
> > page last free stack trace:
> >  reset_page_owner include/linux/page_owner.h:24 [inline]
> >  free_pages_prepare mm/page_alloc.c:1453 [inline]
> >  free_pcp_prepare+0x5d5/0xa50 mm/page_alloc.c:1503
> >  free_unref_page_prepare mm/page_alloc.c:3387 [inline]
> >  free_unref_page+0x1d/0x490 mm/page_alloc.c:3482
> >  free_contig_range+0xb5/0x180 mm/page_alloc.c:9531
> >  destroy_args+0x6c4/0x920 mm/debug_vm_pgtable.c:1023
> >  debug_vm_pgtable+0x242a/0x4640 mm/debug_vm_pgtable.c:1403
> >  do_one_initcall+0x102/0x540 init/main.c:1310
> >  do_initcall_level init/main.c:1383 [inline]
> >  do_initcalls init/main.c:1399 [inline]
> >  do_basic_setup init/main.c:1418 [inline]
> >  kernel_init_freeable+0x696/0xc00 init/main.c:1638
> >  kernel_init+0x1e/0x2c0 init/main.c:1526
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> > 
> > Memory state around the buggy address:
> >  ffff888045b31200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >  ffff888045b31280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >ffff888045b31300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb  
> >                       ^
> >  ffff888045b31380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >  ffff888045b31400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > ==================================================================
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> 
