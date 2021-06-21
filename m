Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93D33AF46A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbhFUSLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbhFUSJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 14:09:02 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7E1C035468
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:54:54 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i4so5297495plt.12
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cYAjdVZbjFpVegPoCRcWFjhiLaZIbR4AhvOVxjkwrvc=;
        b=C91nWzLJQcdXeQ0mptAb2OlEIWDYrj/Sg6gI1BJcD5I08TGS6yRHW69ntC4LNE2p9I
         80IQs7+7a6HRxHT4UXd3wuRx/XVZm4xQL9p6K3lny+7bKb0n8WkKGTtRxBVX/gVUBwIo
         M0k5CTXFptJXWYRT4rbsWzEgJCi4y/eX4R1jvE3Vu+9qEMQHvVWs8qLvhZFGk22Pmjtf
         AhqbINWOvOPyVN4hcD28yw3EpVGsFU/iF/GtYOUnOKX3vOEMYEHDzXLn3o/uvyP4MRRB
         o6yLJx+9jqm0Ke10BOOi3dAaFhRqazWvlPJokos5aaLwN3nQwH13zha7An/UuZQwY1lu
         pDDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cYAjdVZbjFpVegPoCRcWFjhiLaZIbR4AhvOVxjkwrvc=;
        b=T5FEK+Ufgtz08pDZE/oUXsT0irS9uJsnyAOlwjtPa5a7f/xDIqlGItKJzsQibLtsYH
         tikWxl6A0rFF7poCowO+wYBMXq2xJm6LI/iX9LYWC9q4+6xM15udLkLwXIzPfJdzskvc
         hb5xid8/xzAZrqVx8xk9/rBSNYmU713tt4lzMGSScg/uoGsNUY9cCMcfWB+vMHIDx2+J
         l1oiT5wesOIJNUBTCIZRRmt6p9cG0sqLDjW8rBbGq3YlqtTU5G7BgiYQYSeSCYLu5Z00
         wFETTa7e0kRHUOAdGnpq72Hs8c9TNdJ9G3gqLndQ18KTx4jaXC4jIeZvDQqMN2DLYVZQ
         tHlA==
X-Gm-Message-State: AOAM531sxVXKeFi56KYVJgCoYZShUHFMxyQZ3KAU50SXInMlAgLwZJ+G
        cEleB/IuIa5W6k5ggxgGiI4=
X-Google-Smtp-Source: ABdhPJytr8CFlZ7eQULeeEQrv//l2MvVIWQ33cVeiOK2PBjVwMIBxaZVhQmxyavRcyWVRJB5ZJ+qVg==
X-Received: by 2002:a17:902:9a8c:b029:113:d891:2eaf with SMTP id w12-20020a1709029a8cb0290113d8912eafmr18959460plp.61.1624298093966;
        Mon, 21 Jun 2021 10:54:53 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:21de:f864:55d7:2d0])
        by smtp.gmail.com with ESMTPSA id o14sm16845852pgk.82.2021.06.21.10.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 10:54:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] pkt_sched: sch_qfq: fix qfq_change_class() error path
Date:   Mon, 21 Jun 2021 10:54:49 -0700
Message-Id: <20210621175449.880248-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

If qfq_change_class() is unable to allocate memory for qfq_aggregate,
it frees the class that has been inserted in the class hash table,
but does not unhash it.

Defer the insertion after the problematic allocation.

BUG: KASAN: use-after-free in hlist_add_head include/linux/list.h:884 [inline]
BUG: KASAN: use-after-free in qdisc_class_hash_insert+0x200/0x210 net/sched/sch_api.c:731
Write of size 8 at addr ffff88814a534f10 by task syz-executor.4/31478

CPU: 0 PID: 31478 Comm: syz-executor.4 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 hlist_add_head include/linux/list.h:884 [inline]
 qdisc_class_hash_insert+0x200/0x210 net/sched/sch_api.c:731
 qfq_change_class+0x96c/0x1990 net/sched/sch_qfq.c:489
 tc_ctl_tclass+0x514/0xe50 net/sched/sch_api.c:2113
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdc7b5f0188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00007fdc7b5f01d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007ffcf7310b3f R14: 00007fdc7b5f0300 R15: 0000000000022000

Allocated by task 31445:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 ____kasan_kmalloc mm/kasan/common.c:507 [inline]
 ____kasan_kmalloc mm/kasan/common.c:466 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:516
 kmalloc include/linux/slab.h:556 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 qfq_change_class+0x705/0x1990 net/sched/sch_qfq.c:464
 tc_ctl_tclass+0x514/0xe50 net/sched/sch_api.c:2113
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 31445:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1583 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1608
 slab_free mm/slub.c:3168 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4212
 qfq_change_class+0x10fb/0x1990 net/sched/sch_qfq.c:518
 tc_ctl_tclass+0x514/0xe50 net/sched/sch_api.c:2113
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88814a534f00
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 16 bytes inside of
 128-byte region [ffff88814a534f00, ffff88814a534f80)
The buggy address belongs to the page:
page:ffffea0005294d00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14a534
flags: 0x57ff00000000200(slab|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000200 ffffea00004fee00 0000000600000006 ffff8880110418c0
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 29797, ts 604817765317, free_ts 604810151744
 prep_new_page mm/page_alloc.c:2358 [inline]
 get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1646 [inline]
 allocate_slab+0x2c5/0x4c0 mm/slub.c:1786
 new_slab mm/slub.c:1849 [inline]
 new_slab_objects mm/slub.c:2595 [inline]
 ___slab_alloc+0x4a1/0x810 mm/slub.c:2758
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2798
 slab_alloc_node mm/slub.c:2880 [inline]
 slab_alloc mm/slub.c:2922 [inline]
 __kmalloc+0x315/0x330 mm/slub.c:4050
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 __register_sysctl_table+0x112/0x1090 fs/proc/proc_sysctl.c:1318
 mpls_dev_sysctl_register+0x1b7/0x2d0 net/mpls/af_mpls.c:1421
 mpls_add_dev net/mpls/af_mpls.c:1472 [inline]
 mpls_dev_notify+0x214/0x8b0 net/mpls/af_mpls.c:1588
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 register_netdevice+0x106b/0x1500 net/core/dev.c:10312
 veth_newlink+0x585/0xac0 drivers/net/veth.c:1547
 __rtnl_newlink+0x1062/0x1710 net/core/rtnetlink.c:3452
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1298 [inline]
 free_pcp_prepare+0x223/0x300 mm/page_alloc.c:1342
 free_unref_page_prepare mm/page_alloc.c:3250 [inline]
 free_unref_page+0x12/0x1d0 mm/page_alloc.c:3298
 __vunmap+0x783/0xb60 mm/vmalloc.c:2566
 free_work+0x58/0x70 mm/vmalloc.c:80
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Memory state around the buggy address:
 ffff88814a534e00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88814a534e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88814a534f00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff88814a534f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88814a535000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Fixes: 462dbc9101acd ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_qfq.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 1db9d4a2ef5efcd6ace03fc22d4ea1c69a2847be..b692a0de1ad5e5af8c630d7ddf68be4e62645c5b 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -485,11 +485,6 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 	if (cl->qdisc != &noop_qdisc)
 		qdisc_hash_add(cl->qdisc, true);
-	sch_tree_lock(sch);
-	qdisc_class_hash_insert(&q->clhash, &cl->common);
-	sch_tree_unlock(sch);
-
-	qdisc_class_hash_grow(sch, &q->clhash);
 
 set_change_agg:
 	sch_tree_lock(sch);
@@ -507,8 +502,11 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	}
 	if (existing)
 		qfq_deact_rm_from_agg(q, cl);
+	else
+		qdisc_class_hash_insert(&q->clhash, &cl->common);
 	qfq_add_to_agg(q, new_agg, cl);
 	sch_tree_unlock(sch);
+	qdisc_class_hash_grow(sch, &q->clhash);
 
 	*arg = (unsigned long)cl;
 	return 0;
-- 
2.32.0.288.g62a8d224e6-goog

