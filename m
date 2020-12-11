Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7F2D748F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 12:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394382AbgLKLZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 06:25:22 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:22843 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393663AbgLKLZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 06:25:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607685915; x=1639221915;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=2f3dn1hwKCkqns8Fdr3/RSg8UuzWOBEWtTcr6IUp4ok=;
  b=uW0+wS+jdFTY45Kof4Ng0uAUm3pJg0xGUPIDjdxmCmykYgB9un9p1OF+
   +UFtMiGIvSlDx+1llQL0W/GtiZOCHYKnkudQ9hJZhXwkd1+0wVgVmzg6I
   MsL2Mw0uupm+GPS34DphPN1OhUvsqbCLUiU6V+YAx6meJcXRJxbNp5vHy
   s=;
X-IronPort-AV: E=Sophos;i="5.78,411,1599523200"; 
   d="scan'208";a="68514954"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 11 Dec 2020 11:24:28 +0000
Received: from EX13D31EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id DB17114152C;
        Fri, 11 Dec 2020 11:24:24 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.144) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 11:24:19 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     SeongJae Park <sjpark@amazon.de>, <kuba@kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <edumazet@google.com>, <fw@strlen.de>,
        <paulmck@kernel.org>, <netdev@vger.kernel.org>,
        <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] net/ipv4/inet_fragment: Batch fqdir destroy works
Date:   Fri, 11 Dec 2020 12:24:05 +0100
Message-ID: <20201211112405.31158-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D16UWC004.ant.amazon.com (10.43.162.72) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

On a few of our systems, I found frequent 'unshare(CLONE_NEWNET)' calls
make the number of active slab objects including 'sock_inode_cache' type
rapidly and continuously increase.  As a result, memory pressure occurs.

In more detail, I made an artificial reproducer that resembles the
workload that we found the problem and reproduce the problem faster.  It
merely repeats 'unshare(CLONE_NEWNET)' 50,000 times in a loop.  It takes
about 2 minutes.  On 40 CPU cores / 70GB DRAM machine, the available
memory continuously reduced in a fast speed (about 120MB per second,
15GB in total within the 2 minutes).  Note that the issue don't
reproduce on every machine.  On my 6 CPU cores machine, the problem
didn't reproduce.

'cleanup_net()' and 'fqdir_work_fn()' are functions that deallocate the
relevant memory objects.  They are asynchronously invoked by the work
queues and internally use 'rcu_barrier()' to ensure safe destructions.
'cleanup_net()' works in a batched maneer in a single thread worker,
while 'fqdir_work_fn()' works for each 'fqdir_exit()' call in the
'system_wq'.  Therefore, 'fqdir_work_fn()' called frequently under the
workload and made the contention for 'rcu_barrier()' high.  In more
detail, the global mutex, 'rcu_state.barrier_mutex' became the
bottleneck.

This commit avoids such contention by doing the 'rcu_barrier()' and
subsequent lightweight works in a batched manner, as similar to that of
'cleanup_net()'.  The fqdir hashtable destruction, which is done before
the 'rcu_barrier()', is still allowed to run in parallel for fast
processing, but this commit makes it to use a dedicated work queue
instead of the 'system_wq', to make sure that the number of threads is
bounded.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
---

Changes from v3
(https://lore.kernel.org/lkml/20201211082032.26965-1-sjpark@amazon.com/)
- Use system_wq for the batched works and a dedicated non-ordered work
  queue for rhashtable destruction (Eric Dumazet)

Changes from v2
(https://lore.kernel.org/lkml/20201210080844.23741-1-sjpark@amazon.com/)
- Add numbers after the patch (Eric Dumazet)
- Make only 'rcu_barrier()' and subsequent lightweight works serialized
  (Eric Dumazet)

Changes from v1
(https://lore.kernel.org/netdev/20201208094529.23266-1-sjpark@amazon.com/)
- Keep xmas tree variable ordering (Jakub Kicinski)
- Add more numbers (Eric Dumazet)
- Use 'llist_for_each_entry_safe()' (Eric Dumazet)

---
 include/net/inet_frag.h  |  1 +
 net/ipv4/inet_fragment.c | 47 +++++++++++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index bac79e817776..48cc5795ceda 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -21,6 +21,7 @@ struct fqdir {
 	/* Keep atomic mem on separate cachelines in structs that include it */
 	atomic_long_t		mem ____cacheline_aligned_in_smp;
 	struct work_struct	destroy_work;
+	struct llist_node	free_list;
 };
 
 /**
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 10d31733297d..05cd198d7a6b 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -145,12 +145,16 @@ static void inet_frags_free_cb(void *ptr, void *arg)
 		inet_frag_destroy(fq);
 }
 
-static void fqdir_work_fn(struct work_struct *work)
+static LLIST_HEAD(fqdir_free_list);
+
+static void fqdir_free_fn(struct work_struct *work)
 {
-	struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
-	struct inet_frags *f = fqdir->f;
+	struct llist_node *kill_list;
+	struct fqdir *fqdir, *tmp;
+	struct inet_frags *f;
 
-	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
+	/* Atomically snapshot the list of fqdirs to free */
+	kill_list = llist_del_all(&fqdir_free_list);
 
 	/* We need to make sure all ongoing call_rcu(..., inet_frag_destroy_rcu)
 	 * have completed, since they need to dereference fqdir.
@@ -158,10 +162,25 @@ static void fqdir_work_fn(struct work_struct *work)
 	 */
 	rcu_barrier();
 
-	if (refcount_dec_and_test(&f->refcnt))
-		complete(&f->completion);
+	llist_for_each_entry_safe(fqdir, tmp, kill_list, free_list) {
+		f = fqdir->f;
+		if (refcount_dec_and_test(&f->refcnt))
+			complete(&f->completion);
 
-	kfree(fqdir);
+		kfree(fqdir);
+	}
+}
+
+static DECLARE_WORK(fqdir_free_work, fqdir_free_fn);
+
+static void fqdir_work_fn(struct work_struct *work)
+{
+	struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
+
+	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
+
+	if (llist_add(&fqdir->free_list, &fqdir_free_list))
+		queue_work(system_wq, &fqdir_free_work);
 }
 
 int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
@@ -184,10 +203,22 @@ int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
 }
 EXPORT_SYMBOL(fqdir_init);
 
+static struct workqueue_struct *inet_frag_wq;
+
+static int __init inet_frag_wq_init(void)
+{
+	inet_frag_wq = create_workqueue("inet_frag_wq");
+	if (!inet_frag_wq)
+		panic("Could not create inet frag workq");
+	return 0;
+}
+
+pure_initcall(inet_frag_wq_init);
+
 void fqdir_exit(struct fqdir *fqdir)
 {
 	INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
-	queue_work(system_wq, &fqdir->destroy_work);
+	queue_work(inet_frag_wq, &fqdir->destroy_work);
 }
 EXPORT_SYMBOL(fqdir_exit);
 
-- 
2.17.1

