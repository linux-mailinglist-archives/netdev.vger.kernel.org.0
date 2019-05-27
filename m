Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76B42BC6B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 01:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfE0X5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 19:57:05 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:43954 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0X5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 19:57:05 -0400
Received: by mail-qk1-f201.google.com with SMTP id v4so1656884qkj.10
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 16:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CB3BITMlWhl1NSoZAeMb6VinHqOft+4tw9iJt5j1tLw=;
        b=FFlDcsJ/Q9nabr9kWnZlCnt92B7kAdONAK24eNY+bQbvTmKnaiY9wcDn+HUev2uGF8
         vSAc3Ea6Q1+Jje5N5P9FiMusC4Kn7lXADUQ3yVho8abvKpkMm0We5r6TB9q6IivC7/l8
         Ivf6S7vxFHQwtgPbUI8auPnZjcetQXT3esHnmWUisBG1dDCAhdokyLduYhKCe4n82WHF
         oOpVhkJvBPQD9GqrDdwauRrYdnP1NKjOf9/lsPjM/K1hYJLz5iIdH3JEU6ry+Ap1VYp1
         wJO71xAm8KWRBugMRLKJgC3Gs0FfLcXuPvZI01pHzhKgWWcsf84no8KaplBKc6PH5ydY
         o8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CB3BITMlWhl1NSoZAeMb6VinHqOft+4tw9iJt5j1tLw=;
        b=MIecWl5w7kViHBbmANUzhr1co9c0DSxYKOWK/AN9srcYZc2KVsQmjI+eU0cNVOgPZq
         vg9h6ZBXI8Fn20FFPD1BXRi4fd5j4dMEeUh7eMOS11H/iUO6lpFxsS7Edy9dCE8SS2Wx
         Y+m71Syw9e4eoW92MiUAMaYr5l+oKULL3z2vrBcjlWVuzX0SE4jnXT1ZFFO7P7pz9SCj
         gd6jbi4vTFq/+Lowl7PqvXE8Z33blcEGNB9dsN/hZ6GOW5PQx7QMnyGhdSDGNpTYO2Zy
         UqlTVLW2L/U/G//mkFtD+eIAio2GtgU7L/yDtTi1nPOLjqxagb/n54POIZNh4CAlitil
         E/Pg==
X-Gm-Message-State: APjAAAWM+bXoNodz23/kanIXxW8svUCQbDZemUu1Xj+b+wgTpz0d0ELE
        f2lwpD5xPuogn0B8ZLl6pmj0ExUdYDnE+A==
X-Google-Smtp-Source: APXvYqyRpJ6g6X8yh698d6pf58fS8deVO8K0gSl6NN3bIgtSXgBJKOwlZJONw97Q3sP/deDmfxAM8x/9mByFlw==
X-Received: by 2002:a37:9107:: with SMTP id t7mr29083208qkd.135.1559001423839;
 Mon, 27 May 2019 16:57:03 -0700 (PDT)
Date:   Mon, 27 May 2019 16:56:49 -0700
In-Reply-To: <20190527235649.45274-1-edumazet@google.com>
Message-Id: <20190527235649.45274-4-edumazet@google.com>
Mime-Version: 1.0
References: <20190527235649.45274-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 3/3] inet: frags: fix use-after-free read in inet_frag_destroy_rcu
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As caught by syzbot [1], the rcu grace period that is respected
before fqdir_rwork_fn() proceeds and frees fqdir is not enough
to prevent inet_frag_destroy_rcu() being run after the freeing.

We need a proper rcu_barrier() synchronization to replace
the one we had in inet_frags_fini()

We also have to fix a potential problem at module removal :
inet_frags_fini() needs to make sure that all queued work queues
(fqdir_rwork_fn) have completed, otherwise we might
call kmem_cache_destroy() too soon and get another use-after-free.

[1]
BUG: KASAN: use-after-free in inet_frag_destroy_rcu+0xd9/0xe0 net/ipv4/inet_fragment.c:201
Read of size 8 at addr ffff88806ed47a18 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.2.0-rc1+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
 __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 inet_frag_destroy_rcu+0xd9/0xe0 net/ipv4/inet_fragment.c:201
 __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
 rcu_do_batch kernel/rcu/tree.c:2092 [inline]
 invoke_rcu_callbacks kernel/rcu/tree.c:2310 [inline]
 rcu_core+0xba5/0x1500 kernel/rcu/tree.c:2291
 __do_softirq+0x25c/0x94c kernel/softirq.c:293
 invoke_softirq kernel/softirq.c:374 [inline]
 irq_exit+0x180/0x1d0 kernel/softirq.c:414
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x13b/0x550 arch/x86/kernel/apic/apic.c:1068
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
 </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: ff ff 48 89 df e8 f2 95 8c fa eb 82 e9 07 00 00 00 0f 00 2d e4 45 4b 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d d4 45 4b 00 fb f4 <c3> 90 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 8e 18 42 fa e8 99
RSP: 0018:ffff8880a98e7d78 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1164e11 RBX: ffff8880a98d4340 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffff8880a98d4bbc
RBP: ffff8880a98e7da8 R08: ffff8880a98d4340 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffffffff88b27078 R14: 0000000000000001 R15: 0000000000000000
 arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
 default_idle_call+0x36/0x90 kernel/sched/idle.c:94
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x377/0x560 kernel/sched/idle.c:263
 cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354
 start_secondary+0x34e/0x4c0 arch/x86/kernel/smpboot.c:267
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243

Allocated by task 8877:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_kmalloc mm/kasan/common.c:489 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
 kmem_cache_alloc_trace+0x151/0x750 mm/slab.c:3555
 kmalloc include/linux/slab.h:547 [inline]
 kzalloc include/linux/slab.h:742 [inline]
 fqdir_init include/net/inet_frag.h:115 [inline]
 ipv6_frags_init_net+0x48/0x460 net/ipv6/reassembly.c:513
 ops_init+0xb3/0x410 net/core/net_namespace.c:130
 setup_net+0x2d3/0x740 net/core/net_namespace.c:316
 copy_net_ns+0x1df/0x340 net/core/net_namespace.c:439
 create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:107
 unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:206
 ksys_unshare+0x440/0x980 kernel/fork.c:2692
 __do_sys_unshare kernel/fork.c:2760 [inline]
 __se_sys_unshare kernel/fork.c:2758 [inline]
 __x64_sys_unshare+0x31/0x40 kernel/fork.c:2758
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 17:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
 __cache_free mm/slab.c:3432 [inline]
 kfree+0xcf/0x220 mm/slab.c:3755
 fqdir_rwork_fn+0x33/0x40 net/ipv4/inet_fragment.c:154
 process_one_work+0x989/0x1790 kernel/workqueue.c:2269
 worker_thread+0x98/0xe40 kernel/workqueue.c:2415
 kthread+0x354/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88806ed47a00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 24 bytes inside of
 512-byte region [ffff88806ed47a00, ffff88806ed47c00)
The buggy address belongs to the page:
page:ffffea0001bb51c0 refcount:1 mapcount:0 mapping:ffff8880aa400940 index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea000282a788 ffffea0001bb53c8 ffff8880aa400940
raw: 0000000000000000 ffff88806ed47000 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88806ed47900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88806ed47980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88806ed47a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88806ed47a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88806ed47b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 3c8fc8782044 ("inet: frags: rework rhashtable dismantle")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/inet_frag.h  |  3 +++
 net/ipv4/inet_fragment.c | 20 ++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 94092b1ef22e9729d99d56323a77faf1ea4c92a6..e91b79ad4e4adfc1dadb9d00a91f2f2c669d732d 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -3,6 +3,7 @@
 #define __NET_FRAG_H__
 
 #include <linux/rhashtable-types.h>
+#include <linux/completion.h>
 
 /* Per netns frag queues directory */
 struct fqdir {
@@ -104,6 +105,8 @@ struct inet_frags {
 	struct kmem_cache	*frags_cachep;
 	const char		*frags_cache_name;
 	struct rhashtable_params rhash_params;
+	refcount_t		refcnt;
+	struct completion	completion;
 };
 
 int inet_frags_init(struct inet_frags *);
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 7c07aae969e6c84d4f0345b5c4852b2e37d088f6..2b816f1ebbb4ad6fc65aaeff7fadcea8a78e5f9f 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -110,14 +110,18 @@ int inet_frags_init(struct inet_frags *f)
 	if (!f->frags_cachep)
 		return -ENOMEM;
 
+	refcount_set(&f->refcnt, 1);
+	init_completion(&f->completion);
 	return 0;
 }
 EXPORT_SYMBOL(inet_frags_init);
 
 void inet_frags_fini(struct inet_frags *f)
 {
-	/* We must wait that all inet_frag_destroy_rcu() have completed. */
-	rcu_barrier();
+	if (refcount_dec_and_test(&f->refcnt))
+		complete(&f->completion);
+
+	wait_for_completion(&f->completion);
 
 	kmem_cache_destroy(f->frags_cachep);
 	f->frags_cachep = NULL;
@@ -149,8 +153,19 @@ static void fqdir_rwork_fn(struct work_struct *work)
 {
 	struct fqdir *fqdir = container_of(to_rcu_work(work),
 					   struct fqdir, destroy_rwork);
+	struct inet_frags *f = fqdir->f;
 
 	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
+
+	/* We need to make sure all ongoing call_rcu(..., inet_frag_destroy_rcu)
+	 * have completed, since they need to dereference fqdir.
+	 * Would it not be nice to have kfree_rcu_barrier() ? :)
+	 */
+	rcu_barrier();
+
+	if (refcount_dec_and_test(&f->refcnt))
+		complete(&f->completion);
+
 	kfree(fqdir);
 }
 
@@ -168,6 +183,7 @@ int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
 		kfree(fqdir);
 		return res;
 	}
+	refcount_inc(&f->refcnt);
 	*fqdirp = fqdir;
 	return 0;
 }
-- 
2.22.0.rc1.257.g3120a18244-goog

