Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84585FC9A9
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJLRAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiJLRAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:00:01 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E0C1BEBA
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:59:52 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id d6-20020a056e02214600b002fa23a188ebso13722924ilv.6
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tHsLy2vIvdihf3zLe794mWxF8fnafIxOGMiyAaMZJPo=;
        b=UTCBeWPiojS+xQMvEznSY69hKV9+393LxbsyMLMkSYAw8PM5eQF190/dSjqH8XWXaH
         mKLtkzdWOupyfcD5ZQh69g7I6wjO2O5zZzywPLECDAAVllYBcbXxy1bDuVN9qr7SBMjU
         T4ATkPx0Ho3t87B9l/cyq5F3H84b2gKGcmf0fdUzx5LTbqx2AMue8Vv3+n42jZQS0pMT
         daZAS7A8I/It4hE2svZpKVu/Z66QQIOPowiKegbZ/7W2wRBteeHgNdSbIjXspn1TtRg2
         kRlk/GQVMOXfJ5GXoBfC/bsmj4kMehiNzOzMDkRi4XtE9FNoSrbuELg1AAruH6ZqCLgA
         8r2g==
X-Gm-Message-State: ACrzQf0oJfnwtXerXlmPG4bNX5gcDyvgmHoZhlx8cU0Sn19ueRVig1CC
        YTTtq47VJjmdrIl161P+zgS7EYXkL09mO2s6izEcT0NvvPhC
X-Google-Smtp-Source: AMsMyM59bQVxt0KUM9pIrw2JvkbaAeoGZO5JoA/fq30cp2uHzGVRv74nqwD9CpBecDF2YEQ2+QYhLPmJnasaXWt02WUrxN72o8tH
MIME-Version: 1.0
X-Received: by 2002:a05:6602:134f:b0:6a4:cd04:7842 with SMTP id
 i15-20020a056602134f00b006a4cd047842mr14620148iov.172.1665593992173; Wed, 12
 Oct 2022 09:59:52 -0700 (PDT)
Date:   Wed, 12 Oct 2022 09:59:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003e640c05ead952cc@google.com>
Subject: [syzbot] KASAN: use-after-free Read in cfusbl_device_notify
From:   syzbot <syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, roman.gushchin@linux.dev,
        songmuchun@bytedance.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org
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

HEAD commit:    3e732ebf7316 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1179e860f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28c55132a1961e10
dashboard link: https://syzkaller.appspot.com/bug?extid=b563d33852b893653a9e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b36b5f700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c50018f00000

The issue was bisected to:

commit da0efe30944476275c902c52fbac812db0541d87
Author: Muchun Song <songmuchun@bytedance.com>
Date:   Tue Mar 22 21:41:15 2022 +0000

    mm: memcontrol: move memcg_online_kmem() to mem_cgroup_css_online()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14f62690f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16f62690f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12f62690f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
Fixes: da0efe309444 ("mm: memcontrol: move memcg_online_kmem() to mem_cgroup_css_online()")

==================================================================
BUG: KASAN: use-after-free in cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
Read of size 8 at addr ffff88806f06c6f0 by task kworker/u4:0/8

CPU: 0 PID: 8 Comm: kworker/u4:0 Not tainted 5.18.0-rc1-syzkaller-00016-g3e732ebf7316 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1938
 call_netdevice_notifiers_extack net/core/dev.c:1976 [inline]
 call_netdevice_notifiers net/core/dev.c:1990 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10141 [inline]
 netdev_run_todo+0xb90/0x10b0 net/core/dev.c:10253
 default_device_exit_batch+0x44e/0x590 net/core/dev.c:11246
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Allocated by task 3622:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc_node include/linux/slab.h:604 [inline]
 kvmalloc_node+0x3e/0x130 mm/util.c:580
 kvmalloc include/linux/slab.h:731 [inline]
 kvzalloc include/linux/slab.h:739 [inline]
 alloc_netdev_mqs+0x98/0x1100 net/core/dev.c:10495
 rtnl_create_link+0x9d7/0xc00 net/core/rtnetlink.c:3204
 veth_newlink+0x20e/0xa90 drivers/net/veth.c:1748
 __rtnl_newlink+0x107f/0x1760 net/core/rtnetlink.c:3483
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3531
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5990
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 __sys_sendto+0x216/0x310 net/socket.c:2040
 __do_sys_sendto net/socket.c:2052 [inline]
 __se_sys_sendto net/socket.c:2048 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 8:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3510 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4552
 kvfree+0x42/0x50 mm/util.c:615
 device_release+0x9f/0x240 drivers/base/core.c:2229
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 netdev_run_todo+0x72e/0x10b0 net/core/dev.c:10274
 default_device_exit_batch+0x44e/0x590 net/core/dev.c:11246
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

The buggy address belongs to the object at ffff88806f06c000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 1776 bytes inside of
 4096-byte region [ffff88806f06c000, ffff88806f06d000)

The buggy address belongs to the physical page:
page:ffffea0001bc1a00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88806f06e000 pfn:0x6f068
head:ffffea0001bc1a00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001f2b208 ffffea00007afe08 ffff888010c4c280
raw: ffff88806f06e000 0000000000040003 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd60c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3621, tgid 3621 (syz-executor592), ts 165436873089, free_ts 9690486452
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3df0 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2262
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 __kmalloc_node+0x2cb/0x390 mm/slub.c:4458
 kmalloc_node include/linux/slab.h:604 [inline]
 kvmalloc_node+0x3e/0x130 mm/util.c:580
 kvmalloc include/linux/slab.h:731 [inline]
 kvzalloc include/linux/slab.h:739 [inline]
 alloc_netdev_mqs+0x98/0x1100 net/core/dev.c:10495
 rtnl_create_link+0x9d7/0xc00 net/core/rtnetlink.c:3204
 veth_newlink+0x20e/0xa90 drivers/net/veth.c:1748
 __rtnl_newlink+0x107f/0x1760 net/core/rtnetlink.c:3483
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3531
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5990
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3423
 free_contig_range+0xb1/0x180 mm/page_alloc.c:9418
 destroy_args+0xa8/0x646 mm/debug_vm_pgtable.c:1018
 debug_vm_pgtable+0x2a50/0x2ae2 mm/debug_vm_pgtable.c:1332
 do_one_initcall+0x103/0x650 init/main.c:1298
 do_initcall_level init/main.c:1371 [inline]
 do_initcalls init/main.c:1387 [inline]
 do_basic_setup init/main.c:1406 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1613
 kernel_init+0x1a/0x1d0 init/main.c:1502
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Memory state around the buggy address:
 ffff88806f06c580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88806f06c600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88806f06c680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88806f06c700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88806f06c780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
