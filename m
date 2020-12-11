Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DE32D7197
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436833AbgLKIVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:21:49 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:5456 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392265AbgLKIVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:21:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607674908; x=1639210908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MQ0QITdgdNQMHZpDm4bLT+Ctn1747V5BItdI9+PnQvs=;
  b=MjkrIq5MsZfNCowEQ4Yv/aFa77jgOJ49tAYSDJKcChTcqUwN1ukLsjJn
   F7Fa1PwLasq5or0zN4zS5qHySBT/eSUFfUjK/ZSJs9vdLpNrheeTMWXol
   cgk5+VhNNFCynup5pY47p/ooEc+l1AOPlXpiovoWv2vfi8BbO/zckWEd1
   0=;
X-IronPort-AV: E=Sophos;i="5.78,410,1599523200"; 
   d="scan'208";a="95126821"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 11 Dec 2020 08:21:02 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id D4DD0C2832;
        Fri, 11 Dec 2020 08:21:00 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.144) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 08:20:55 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     SeongJae Park <sjpark@amazon.de>, <kuba@kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <edumazet@google.com>, <fw@strlen.de>,
        <paulmck@kernel.org>, <netdev@vger.kernel.org>,
        <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/1] net/ipv4/inet_fragment: Batch fqdir destroy works
Date:   Fri, 11 Dec 2020 09:20:32 +0100
Message-ID: <20201211082032.26965-2-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201211082032.26965-1-sjpark@amazon.com>
References: <20201211082032.26965-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D47UWC004.ant.amazon.com (10.43.162.74) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

For each 'fqdir_exit()' call, a work for destroy of the 'fqdir' is
enqueued.  The work function, 'fqdir_work_fn()', internally calls
'rcu_barrier()'.  In case of intensive 'fqdir_exit()' (e.g., frequent
'unshare()' systemcalls), this increased contention could result in
unacceptably high latency of 'rcu_barrier()'.  This commit avoids such
contention by doing the 'rcu_barrier()' and subsequent lightweight works
in a batched manner using a dedicated singlethread worker, as similar to
that of 'cleanup_net()'.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 include/net/inet_frag.h  |  1 +
 net/ipv4/inet_fragment.c | 45 +++++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 7 deletions(-)

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
index 10d31733297d..a6fc4afcc323 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -145,12 +145,17 @@ static void inet_frags_free_cb(void *ptr, void *arg)
 		inet_frag_destroy(fq);
 }
 
-static void fqdir_work_fn(struct work_struct *work)
+static struct workqueue_struct *fqdir_wq;
+static LLIST_HEAD(free_list);
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
+	kill_list = llist_del_all(&free_list);
 
 	/* We need to make sure all ongoing call_rcu(..., inet_frag_destroy_rcu)
 	 * have completed, since they need to dereference fqdir.
@@ -158,12 +163,38 @@ static void fqdir_work_fn(struct work_struct *work)
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
 }
 
+static DECLARE_WORK(fqdir_free_work, fqdir_free_fn);
+
+static void fqdir_work_fn(struct work_struct *work)
+{
+	struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
+
+	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
+
+	if (llist_add(&fqdir->free_list, &free_list))
+		queue_work(fqdir_wq, &fqdir_free_work);
+}
+
+static int __init fqdir_wq_init(void)
+{
+	fqdir_wq = create_singlethread_workqueue("fqdir");
+	if (!fqdir_wq)
+		panic("Could not create fqdir workq");
+	return 0;
+}
+
+pure_initcall(fqdir_wq_init);
+
+
 int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
 {
 	struct fqdir *fqdir = kzalloc(sizeof(*fqdir), GFP_KERNEL);
-- 
2.17.1

