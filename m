Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF98C410131
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 00:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344721AbhIQWR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 18:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhIQWRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 18:17:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E9DC061574;
        Fri, 17 Sep 2021 15:16:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y8so10438374pfa.7;
        Fri, 17 Sep 2021 15:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qB9gJ6LNbJjwyd6/m+iiQwIKkd0igjwIb4JH05gm3Vs=;
        b=d/VvFGzsHdCWU/0XpH64A3w89kbjUsqDGAGKDGERZeYRH6D2EvAYl0EuC87KxYcaRR
         tc1yVRBQm3Qcygvve/W+KDpIr4aSgUXslB+0ziunCp5jGV1kt8JNradv4pDhvYnazEsj
         OoXRO/w1GspYS7jzPjJKlJsRVScChZs3pIytTbfg8Mu/Npn5uTFT22Ueyk+nuqqP5CKE
         t7w+TWubkzfFw9X3UpqrU914BKfeTuhBEtouxRiT8SEBcLKYbENyhjfgQBSZqqWQMFdc
         KTQkDdOlZccKRAv2wpM07zPsw372HDevQyssZ9n+MNsGwHXAC3xcbH94F/LwOWbXAQBk
         f1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qB9gJ6LNbJjwyd6/m+iiQwIKkd0igjwIb4JH05gm3Vs=;
        b=A6UGtQbAMUjBjmcjUzx3NRuTYJ8oxmx9lhmFZ31G9E/Qzm2hNyPVs4bpPADGBVTBg5
         1xzerysdvHnQKrobhRm+jeWTs27w4T3Ltt4xSxEi17gVXOxqQDEE+hNeI8rPsSLfp4xz
         uE7gEd8CgmAmmfc8ISxVydKZ2Ut1iLNQeENM1PrAlOd+FUvwhZ7f9Gncz17xMEOWOrqH
         NbUExWZM2AogoJuGIWMHglZSt9jw4ZMcXHP+1Z/lQmcYy5ywCep3ZecSDmvYRylzNupC
         SxWb6gB+WwXIOk1lqUkn4EnQNjGnvDR1N02wZyHw1aanU38qt4n0KQnrkGl1O/+Vknbd
         JrbA==
X-Gm-Message-State: AOAM531BjZN7c/7S9A/pURBzdYcYnMYRyZpf7vLXF0wLe1juj0h3gZ6v
        KP6gSsaiUXPtTURw2t3SZiW8nCTXMj4=
X-Google-Smtp-Source: ABdhPJxGjNxtUg4POeOVlgPc4fLWPI7WZY5e7fKH2VcwjX6duSugQA0qEA1jWYE4AYX3dVdD8cQThg==
X-Received: by 2002:a65:5845:: with SMTP id s5mr11608474pgr.227.1631916960800;
        Fri, 17 Sep 2021 15:16:00 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6927:c6c9:5f0d:cd5])
        by smtp.gmail.com with ESMTPSA id j20sm7367041pgb.2.2021.09.17.15.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 15:16:00 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH nf] netfilter: conntrack: serialize hash resizes and cleanups
Date:   Fri, 17 Sep 2021 15:15:56 -0700
Message-Id: <20210917221556.1162846-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Syzbot was able to trigger the following warning [1]

No repro found by syzbot yet but I was able to trigger similar issue
by having 2 scripts running in parallel, changing conntrack hash sizes,
and:

for j in `seq 1 1000` ; do unshare -n /bin/true >/dev/null ; done

It would take more than 5 minutes for net_namespace structures
to be cleaned up.

This is because nf_ct_iterate_cleanup() has to restart everytime
a resize happened.

By adding a mutex, we can serialize hash resizes and cleanups
and also make get_next_corpse() faster by skipping over empty
buckets.

Even without resizes in the picture, this patch considerably
speeds up network namespace dismantles.

[1]
INFO: task syz-executor.0:8312 can't die for more than 144 seconds.
task:syz-executor.0  state:R  running task     stack:25672 pid: 8312 ppid:  6573 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4955 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6236
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:6408
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 __local_bh_enable_ip+0x109/0x120 kernel/softirq.c:390
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 get_next_corpse net/netfilter/nf_conntrack_core.c:2252 [inline]
 nf_ct_iterate_cleanup+0x15a/0x450 net/netfilter/nf_conntrack_core.c:2275
 nf_conntrack_cleanup_net_list+0x14c/0x4f0 net/netfilter/nf_conntrack_core.c:2469
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:171
 setup_net+0x639/0xa30 net/core/net_namespace.c:349
 copy_net_ns+0x319/0x760 net/core/net_namespace.c:470
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3128
 __do_sys_unshare kernel/fork.c:3202 [inline]
 __se_sys_unshare kernel/fork.c:3200 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3200
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f63da68e739
RSP: 002b:00007f63d7c05188 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007f63da792f80 RCX: 00007f63da68e739
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000000
RBP: 00007f63da6e8cc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f63da792f80
R13: 00007fff50b75d3f R14: 00007f63d7c05300 R15: 0000000000022000

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8b980020 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
2 locks held by kworker/u4:2/153:
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2268
 #1: ffffc9000140fdb0 ((kfence_timer).work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2272
1 lock held by systemd-udevd/2970:
1 lock held by in:imklog/6258:
 #0: ffff88807f970ff0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990
3 locks held by kworker/1:6/8158:
1 lock held by syz-executor.0/8312:
2 locks held by kworker/u4:13/9320:
1 lock held by syz-executor.5/10178:
1 lock held by syz-executor.4/10217:

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/nf_conntrack_core.c | 70 ++++++++++++++++---------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 94e18fb9690dd44a32829894ed286be66b561d16..abc0fabe1396a7cc9cc1b1c3fd50c7f489c43b5e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -74,6 +74,9 @@ static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
+/* serialize hash resizes and nf_ct_iterate_cleanup */
+static DEFINE_MUTEX(nf_conntrack_mutex);
+
 #define GC_SCAN_INTERVAL	(120u * HZ)
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
@@ -2225,28 +2228,31 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 	spinlock_t *lockp;
 
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
+		struct hlist_nulls_head *hslot = &nf_conntrack_hash[*bucket];
+
+		if (hlist_nulls_empty(hslot))
+			continue;
+
 		lockp = &nf_conntrack_locks[*bucket % CONNTRACK_LOCKS];
 		local_bh_disable();
 		nf_conntrack_lock(lockp);
-		if (*bucket < nf_conntrack_htable_size) {
-			hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {
-				if (NF_CT_DIRECTION(h) != IP_CT_DIR_REPLY)
-					continue;
-				/* All nf_conn objects are added to hash table twice, one
-				 * for original direction tuple, once for the reply tuple.
-				 *
-				 * Exception: In the IPS_NAT_CLASH case, only the reply
-				 * tuple is added (the original tuple already existed for
-				 * a different object).
-				 *
-				 * We only need to call the iterator once for each
-				 * conntrack, so we just use the 'reply' direction
-				 * tuple while iterating.
-				 */
-				ct = nf_ct_tuplehash_to_ctrack(h);
-				if (iter(ct, data))
-					goto found;
-			}
+		hlist_nulls_for_each_entry(h, n, hslot, hnnode) {
+			if (NF_CT_DIRECTION(h) != IP_CT_DIR_REPLY)
+				continue;
+			/* All nf_conn objects are added to hash table twice, one
+			 * for original direction tuple, once for the reply tuple.
+			 *
+			 * Exception: In the IPS_NAT_CLASH case, only the reply
+			 * tuple is added (the original tuple already existed for
+			 * a different object).
+			 *
+			 * We only need to call the iterator once for each
+			 * conntrack, so we just use the 'reply' direction
+			 * tuple while iterating.
+			 */
+			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (iter(ct, data))
+				goto found;
 		}
 		spin_unlock(lockp);
 		local_bh_enable();
@@ -2264,26 +2270,20 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 				  void *data, u32 portid, int report)
 {
-	unsigned int bucket = 0, sequence;
+	unsigned int bucket = 0;
 	struct nf_conn *ct;
 
 	might_sleep();
 
-	for (;;) {
-		sequence = read_seqcount_begin(&nf_conntrack_generation);
+	mutex_lock(&nf_conntrack_mutex);
+	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
+		/* Time to push up daises... */
 
-		while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
-			/* Time to push up daises... */
-
-			nf_ct_delete(ct, portid, report);
-			nf_ct_put(ct);
-			cond_resched();
-		}
-
-		if (!read_seqcount_retry(&nf_conntrack_generation, sequence))
-			break;
-		bucket = 0;
+		nf_ct_delete(ct, portid, report);
+		nf_ct_put(ct);
+		cond_resched();
 	}
+	mutex_unlock(&nf_conntrack_mutex);
 }
 
 struct iter_data {
@@ -2519,8 +2519,10 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 	if (!hash)
 		return -ENOMEM;
 
+	mutex_lock(&nf_conntrack_mutex);
 	old_size = nf_conntrack_htable_size;
 	if (old_size == hashsize) {
+		mutex_unlock(&nf_conntrack_mutex);
 		kvfree(hash);
 		return 0;
 	}
@@ -2556,6 +2558,8 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 	nf_conntrack_all_unlock();
 	local_bh_enable();
 
+	mutex_unlock(&nf_conntrack_mutex);
+
 	synchronize_net();
 	kvfree(old_hash);
 	return 0;
-- 
2.33.0.464.g1972c5931b-goog

