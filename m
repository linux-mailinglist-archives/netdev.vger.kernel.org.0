Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3A029BC2
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390662AbfEXQET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:04:19 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:40877 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389962AbfEXQES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:04:18 -0400
Received: by mail-pg1-f202.google.com with SMTP id e69so6571202pgc.7
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/dkw9rVsaCZxi3LyN03EKSzo2eiCyA5tfllpkyFHyAE=;
        b=AYcZPTetzoZw7iX6qa9YxQELwbFyKnLASuWt9rvQ5a628QjbakDaUds4mQUQ336bFP
         XztHqc58zGNJ9POkemql4dnZSWw9fmNs+azBukl8Aue03YUuDOtJ4zXf535DGbagRj4m
         DJykulsvkfi+cyCoG8GbNIJsvQ/I6744hsLec0/HPmiZBoZGjCZ/QY0Qqkv14U6UuLam
         kpHYDwZekvV7ST7cvGvkC2UN09WLMsQpFvP4mYcHco4U3EdHcOtfQD5w2/1KWPBZD7Xn
         MDkWiDHWe/JhVW5KydfOPMuTOoctbclTSsMn9TBGjyv/SH6om0KsPOw6VzWLSE6rycHU
         K+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/dkw9rVsaCZxi3LyN03EKSzo2eiCyA5tfllpkyFHyAE=;
        b=a/TaGQsQAqGE/zg+y+5jouVz6kLYDJvY6Y+oLknt7LUYDJnQNfg1kgOFsWl3ANrX4m
         10vnlzYjpouaWFCETsENXHM9tNWbaqlXnVFcun9nCnNS0aO15BIjY8V0LQxd9nGumQEu
         75CaK24Q1SOTxtUXF2Xmw3WlFkOR8tiGXL9oydosr+4/UdA/lAj3o0o1hCazAI+a9JVX
         TbWC9hoX6vxQf0qxSGSvSCesCMTDIw5E+Lti3GdYKFNCv5cX/rf/qc4/KeyP7xoQNsqz
         7apC6dfkBBW3jfn14RnRJ04iOSEnZF9tA9ND35QBCdTON7xwin5X0OBPsVx39jOzPs83
         xd4w==
X-Gm-Message-State: APjAAAVRAA90++7mRcEFPTeL81nchDboI7CvGXxqFEIt6zcyRwNtYky2
        Zy3WATKyvyYXckQcMJYOOm/wmejtsxr4RQ==
X-Google-Smtp-Source: APXvYqxNlbBohQ0yyLHxfTEYUyddLJG/M9U8OJQ3jwTDsG6qsDaZT6qEYEWu36F8UpZZ2yIZtm9kNAYxZAd2IQ==
X-Received: by 2002:a63:4d0b:: with SMTP id a11mr18757079pgb.74.1558713857642;
 Fri, 24 May 2019 09:04:17 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:40 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-12-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 11/11] inet: frags: rework rhashtable dismantle
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

syszbot found an interesting use-after-free [1] happening
while IPv4 fragment rhashtable was destroyed at netns dismantle.

While no insertions can possibly happen at the time a dismantling
netns is destroying this rhashtable, timers can still fire and
attempt to remove elements from this rhashtable.

This is forbidden, since rhashtable_free_and_destroy() has
no synchronization against concurrent inserts and deletes.

Add a new fqdir->dead flag so that timers do not attempt
a rhashtable_remove_fast() operation.

We also have to respect an RCU grace period before starting
the rhashtable_free_and_destroy() from process context,
thus we use rcu_work infrastructure.

This is a refinement of a prior rough attempt to fix this bug :
https://marc.info/?l=linux-netdev&m=153845936820900&w=2

Since the rhashtable cleanup is now deferred to a work queue,
netns dismantles should be slightly faster.

[1]
BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:194 [inline]
BUG: KASAN: use-after-free in rhashtable_last_table+0x162/0x180 lib/rhashtable.c:212
Read of size 8 at addr ffff8880a6497b70 by task kworker/0:0/5

CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.2.0-rc1+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events rht_deferred_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
 __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 __read_once_size include/linux/compiler.h:194 [inline]
 rhashtable_last_table+0x162/0x180 lib/rhashtable.c:212
 rht_deferred_worker+0x111/0x2030 lib/rhashtable.c:411
 process_one_work+0x989/0x1790 kernel/workqueue.c:2269
 worker_thread+0x98/0xe40 kernel/workqueue.c:2415
 kthread+0x354/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 32687:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_kmalloc mm/kasan/common.c:489 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
 __do_kmalloc_node mm/slab.c:3620 [inline]
 __kmalloc_node+0x4e/0x70 mm/slab.c:3627
 kmalloc_node include/linux/slab.h:590 [inline]
 kvmalloc_node+0x68/0x100 mm/util.c:431
 kvmalloc include/linux/mm.h:637 [inline]
 kvzalloc include/linux/mm.h:645 [inline]
 bucket_table_alloc+0x90/0x480 lib/rhashtable.c:178
 rhashtable_init+0x3f4/0x7b0 lib/rhashtable.c:1057
 inet_frags_init_net include/net/inet_frag.h:109 [inline]
 ipv4_frags_init_net+0x182/0x410 net/ipv4/ip_fragment.c:683
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

Freed by task 7:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
 __cache_free mm/slab.c:3432 [inline]
 kfree+0xcf/0x220 mm/slab.c:3755
 kvfree+0x61/0x70 mm/util.c:460
 bucket_table_free+0x69/0x150 lib/rhashtable.c:108
 rhashtable_free_and_destroy+0x165/0x8b0 lib/rhashtable.c:1155
 inet_frags_exit_net+0x3d/0x50 net/ipv4/inet_fragment.c:152
 ipv4_frags_exit_net+0x73/0x90 net/ipv4/ip_fragment.c:695
 ops_exit_list.isra.0+0xaa/0x150 net/core/net_namespace.c:154
 cleanup_net+0x3fb/0x960 net/core/net_namespace.c:553
 process_one_work+0x989/0x1790 kernel/workqueue.c:2269
 worker_thread+0x98/0xe40 kernel/workqueue.c:2415
 kthread+0x354/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8880a6497b40
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 48 bytes inside of
 1024-byte region [ffff8880a6497b40, ffff8880a6497f40)
The buggy address belongs to the page:
page:ffffea0002992580 refcount:1 mapcount:0 mapping:ffff8880aa400ac0 index:0xffff8880a64964c0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002916e88 ffffea000218fe08 ffff8880aa400ac0
raw: ffff8880a64964c0 ffff8880a6496040 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a6497a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a6497a80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff8880a6497b00: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                             ^
 ffff8880a6497b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a6497c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/inet_frag.h  |  4 ++++
 net/ipv4/inet_fragment.c | 49 ++++++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 5f754c660cfa34898e48d5dbbf17a3508fb8b3ba..002f23c1a1a7126e146f596300aee0e52b6cafc6 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -13,11 +13,13 @@ struct fqdir {
 	int			max_dist;
 	struct inet_frags	*f;
 	struct net		*net;
+	bool			dead;
 
 	struct rhashtable       rhashtable ____cacheline_aligned_in_smp;
 
 	/* Keep atomic mem on separate cachelines in structs that include it */
 	atomic_long_t		mem ____cacheline_aligned_in_smp;
+	struct rcu_work		destroy_rwork;
 };
 
 /**
@@ -26,11 +28,13 @@ struct fqdir {
  * @INET_FRAG_FIRST_IN: first fragment has arrived
  * @INET_FRAG_LAST_IN: final fragment has arrived
  * @INET_FRAG_COMPLETE: frag queue has been processed and is due for destruction
+ * @INET_FRAG_HASH_DEAD: inet_frag_kill() has not removed fq from rhashtable
  */
 enum {
 	INET_FRAG_FIRST_IN	= BIT(0),
 	INET_FRAG_LAST_IN	= BIT(1),
 	INET_FRAG_COMPLETE	= BIT(2),
+	INET_FRAG_HASH_DEAD	= BIT(3),
 };
 
 struct frag_v4_compare_key {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index b4432f209c715dd09b0b201fdae16d5332770c85..6ca9523374dab03737cd073a1aa990130c4a87ca 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -124,34 +124,49 @@ void inet_frags_fini(struct inet_frags *f)
 }
 EXPORT_SYMBOL(inet_frags_fini);
 
+/* called from rhashtable_free_and_destroy() at netns_frags dismantle */
 static void inet_frags_free_cb(void *ptr, void *arg)
 {
 	struct inet_frag_queue *fq = ptr;
+	int count;
 
-	/* If we can not cancel the timer, it means this frag_queue
-	 * is already disappearing, we have nothing to do.
-	 * Otherwise, we own a refcount until the end of this function.
-	 */
-	if (!del_timer(&fq->timer))
-		return;
+	count = del_timer_sync(&fq->timer) ? 1 : 0;
 
 	spin_lock_bh(&fq->lock);
 	if (!(fq->flags & INET_FRAG_COMPLETE)) {
 		fq->flags |= INET_FRAG_COMPLETE;
-		refcount_dec(&fq->refcnt);
+		count++;
+	} else if (fq->flags & INET_FRAG_HASH_DEAD) {
+		count++;
 	}
 	spin_unlock_bh(&fq->lock);
 
-	inet_frag_put(fq);
+	if (refcount_sub_and_test(count, &fq->refcnt))
+		inet_frag_destroy(fq);
 }
 
-void fqdir_exit(struct fqdir *fqdir)
+static void fqdir_rwork_fn(struct work_struct *work)
 {
-	fqdir->high_thresh = 0; /* prevent creation of new frags */
+	struct fqdir *fqdir = container_of(to_rcu_work(work),
+					   struct fqdir, destroy_rwork);
 
 	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
 	kfree(fqdir);
 }
+
+void fqdir_exit(struct fqdir *fqdir)
+{
+	fqdir->high_thresh = 0; /* prevent creation of new frags */
+
+	/* paired with READ_ONCE() in inet_frag_kill() :
+	 * We want to prevent rhashtable_remove_fast() calls
+	 */
+	smp_store_release(&fqdir->dead, true);
+
+	INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
+	queue_rcu_work(system_wq, &fqdir->destroy_rwork);
+
+}
 EXPORT_SYMBOL(fqdir_exit);
 
 void inet_frag_kill(struct inet_frag_queue *fq)
@@ -163,8 +178,18 @@ void inet_frag_kill(struct inet_frag_queue *fq)
 		struct fqdir *fqdir = fq->fqdir;
 
 		fq->flags |= INET_FRAG_COMPLETE;
-		rhashtable_remove_fast(&fqdir->rhashtable, &fq->node, fqdir->f->rhash_params);
-		refcount_dec(&fq->refcnt);
+		rcu_read_lock();
+		/* This READ_ONCE() is paired with smp_store_release()
+		 * in inet_frags_exit_net().
+		 */
+		if (!READ_ONCE(fqdir->dead)) {
+			rhashtable_remove_fast(&fqdir->rhashtable, &fq->node,
+					       fqdir->f->rhash_params);
+			refcount_dec(&fq->refcnt);
+		} else {
+			fq->flags |= INET_FRAG_HASH_DEAD;
+		}
+		rcu_read_unlock();
 	}
 }
 EXPORT_SYMBOL(inet_frag_kill);
-- 
2.22.0.rc1.257.g3120a18244-goog

