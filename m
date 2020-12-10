Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068D82D5524
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbgLJIKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:10:11 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:61287 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbgLJIKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 03:10:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607587805; x=1639123805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=RaitfIFfdpp6jtfUPGRbEOUja/qNHha6jb1uqJ7pyaU=;
  b=X/hhDI4R06IYr22SqJWXE9JvBlwWHN+poYZOOaHORuCF0b/h1LOHJ00w
   +uEfP4kTkpfbN5JS+KRS6WfX1RCTSqVnBx5CC9Va+ENxHl0zKh+Zf5RAo
   03Cl8ZidrhP151mtOOHeEohKDYq3dES9scny5nqgqIJXG21USwu+4lwtT
   8=;
X-IronPort-AV: E=Sophos;i="5.78,407,1599523200"; 
   d="scan'208";a="103145938"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Dec 2020 08:09:16 +0000
Received: from EX13D31EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 609FF240BFB;
        Thu, 10 Dec 2020 08:09:14 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.161.102) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 08:09:09 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     SeongJae Park <sjpark@amazon.de>, <kuba@kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <edumazet@google.com>, <fw@strlen.de>,
        <paulmck@kernel.org>, <netdev@vger.kernel.org>,
        <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] net/ipv4/inet_fragment: Batch fqdir destroy works
Date:   Thu, 10 Dec 2020 09:08:44 +0100
Message-ID: <20201210080844.23741-2-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210080844.23741-1-sjpark@amazon.com>
References: <20201210080844.23741-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D16UWB004.ant.amazon.com (10.43.161.170) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

In 'fqdir_exit()', a work for destroy of the 'fqdir' is enqueued.  The
work function, 'fqdir_work_fn()', calls 'rcu_barrier()'.  In case of
intensive 'fqdir_exit()' (e.g., frequent 'unshare()' systemcalls), this
increased contention could result in unacceptably high latency of
'rcu_barrier()'.  This commit avoids such contention by doing the
destroy work in batched manner, as similar to that of 'cleanup_net()'.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 include/net/inet_frag.h  |  2 +-
 net/ipv4/inet_fragment.c | 28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index bac79e817776..558893d8810c 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -20,7 +20,7 @@ struct fqdir {
 
 	/* Keep atomic mem on separate cachelines in structs that include it */
 	atomic_long_t		mem ____cacheline_aligned_in_smp;
-	struct work_struct	destroy_work;
+	struct llist_node	destroy_list;
 };
 
 /**
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 10d31733297d..d5c40386a764 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -145,12 +145,19 @@ static void inet_frags_free_cb(void *ptr, void *arg)
 		inet_frag_destroy(fq);
 }
 
+static LLIST_HEAD(destroy_list);
+
 static void fqdir_work_fn(struct work_struct *work)
 {
-	struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
-	struct inet_frags *f = fqdir->f;
+	struct llist_node *kill_list;
+	struct fqdir *fqdir, *tmp;
+	struct inet_frags *f;
 
-	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
+	/* Atomically snapshot the list of fqdirs to destroy */
+	kill_list = llist_del_all(&destroy_list);
+
+	llist_for_each_entry(fqdir, kill_list, destroy_list)
+		rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
 
 	/* We need to make sure all ongoing call_rcu(..., inet_frag_destroy_rcu)
 	 * have completed, since they need to dereference fqdir.
@@ -158,10 +165,13 @@ static void fqdir_work_fn(struct work_struct *work)
 	 */
 	rcu_barrier();
 
-	if (refcount_dec_and_test(&f->refcnt))
-		complete(&f->completion);
+	llist_for_each_entry_safe(fqdir, tmp, kill_list, destroy_list) {
+		f = fqdir->f;
+		if (refcount_dec_and_test(&f->refcnt))
+			complete(&f->completion);
 
-	kfree(fqdir);
+		kfree(fqdir);
+	}
 }
 
 int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
@@ -184,10 +194,12 @@ int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
 }
 EXPORT_SYMBOL(fqdir_init);
 
+static DECLARE_WORK(fqdir_destroy_work, fqdir_work_fn);
+
 void fqdir_exit(struct fqdir *fqdir)
 {
-	INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
-	queue_work(system_wq, &fqdir->destroy_work);
+	if (llist_add(&fqdir->destroy_list, &destroy_list))
+		queue_work(system_wq, &fqdir_destroy_work);
 }
 EXPORT_SYMBOL(fqdir_exit);
 
-- 
2.17.1

