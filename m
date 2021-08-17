Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80743EE122
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhHQAgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236020AbhHQAge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C025B60F58;
        Tue, 17 Aug 2021 00:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160561;
        bh=GUuUlJd+bkg2MUpnqwFsnl2vXaURQF0D8zHYepadehE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOFZPEe8Avm2tIVRleHLI5URIIwU+CyogyPpWX4IYSvINsPB9d9gTNCtQlz19x3EQ
         +0Qxxl4x44guZF243szanMaYagT0Eqccq8bpceP5nbsDhWNBYlGnBLWT/32OyTj7Es
         1pFJfAvLagFh33+aF2cx78wNLrAz1LAuUdkxoxS0q29a+vsfkHaEmB70zu4VhSWiPP
         n5ZF79Hx+oRCe6nD047CjQG/Hqec/Pb6e0YhRXxfUXE/W2SikSYxIEP5Nphbnt9tK8
         Ncx1Nx24aa++9+yw5z3AnwUQ5ADECvYJuel3jcgrO/x0ICfwvAlZZM1Qp1YfIoK5Iq
         1o96T7HQbN1RQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 5/9] netfilter: conntrack: collect all entries in one cycle
Date:   Mon, 16 Aug 2021 20:35:50 -0400
Message-Id: <20210817003554.83213-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003554.83213-1-sashal@kernel.org>
References: <20210817003554.83213-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4608fdfc07e116f9fc0895beb40abad7cdb5ee3d ]

Michal Kubecek reports that conntrack gc is responsible for frequent
wakeups (every 125ms) on idle systems.

On busy systems, timed out entries are evicted during lookup.
The gc worker is only needed to remove entries after system becomes idle
after a busy period.

To resolve this, always scan the entire table.
If the scan is taking too long, reschedule so other work_structs can run
and resume from next bucket.

After a completed scan, wait for 2 minutes before the next cycle.
Heuristics for faster re-schedule are removed.

GC_SCAN_INTERVAL could be exposed as a sysctl in the future to allow
tuning this as-needed or even turn the gc worker off.

Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 71 ++++++++++---------------------
 1 file changed, 22 insertions(+), 49 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f9f2af26ccb3..54430a34d2f6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -66,22 +66,17 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
-	u32			last_bucket;
+	u32			next_bucket;
 	bool			exiting;
 	bool			early_drop;
-	long			next_gc_run;
 };
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
-/* every gc cycle scans at most 1/GC_MAX_BUCKETS_DIV part of table */
-#define GC_MAX_BUCKETS_DIV	128u
-/* upper bound of full table scan */
-#define GC_MAX_SCAN_JIFFIES	(16u * HZ)
-/* desired ratio of entries found to be expired */
-#define GC_EVICT_RATIO	50u
+#define GC_SCAN_INTERVAL	(120u * HZ)
+#define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
@@ -1352,17 +1347,13 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned int min_interval = max(HZ / GC_MAX_BUCKETS_DIV, 1u);
-	unsigned int i, goal, buckets = 0, expired_count = 0;
-	unsigned int nf_conntrack_max95 = 0;
+	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
+	unsigned int i, hashsz, nf_conntrack_max95 = 0;
+	unsigned long next_run = GC_SCAN_INTERVAL;
 	struct conntrack_gc_work *gc_work;
-	unsigned int ratio, scanned = 0;
-	unsigned long next_run;
-
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
-	goal = nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV;
-	i = gc_work->last_bucket;
+	i = gc_work->next_bucket;
 	if (gc_work->early_drop)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
@@ -1370,22 +1361,21 @@ static void gc_worker(struct work_struct *work)
 		struct nf_conntrack_tuple_hash *h;
 		struct hlist_nulls_head *ct_hash;
 		struct hlist_nulls_node *n;
-		unsigned int hashsz;
 		struct nf_conn *tmp;
 
-		i++;
 		rcu_read_lock();
 
 		nf_conntrack_get_ht(&ct_hash, &hashsz);
-		if (i >= hashsz)
-			i = 0;
+		if (i >= hashsz) {
+			rcu_read_unlock();
+			break;
+		}
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct net *net;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
-			scanned++;
 			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
 				nf_ct_offload_timeout(tmp);
 				continue;
@@ -1393,7 +1383,6 @@ static void gc_worker(struct work_struct *work)
 
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
-				expired_count++;
 				continue;
 			}
 
@@ -1425,7 +1414,14 @@ static void gc_worker(struct work_struct *work)
 		 */
 		rcu_read_unlock();
 		cond_resched();
-	} while (++buckets < goal);
+		i++;
+
+		if (time_after(jiffies, end_time) && i < hashsz) {
+			gc_work->next_bucket = i;
+			next_run = 0;
+			break;
+		}
+	} while (i < hashsz);
 
 	if (gc_work->exiting)
 		return;
@@ -1436,40 +1432,17 @@ static void gc_worker(struct work_struct *work)
 	 *
 	 * This worker is only here to reap expired entries when system went
 	 * idle after a busy period.
-	 *
-	 * The heuristics below are supposed to balance conflicting goals:
-	 *
-	 * 1. Minimize time until we notice a stale entry
-	 * 2. Maximize scan intervals to not waste cycles
-	 *
-	 * Normally, expire ratio will be close to 0.
-	 *
-	 * As soon as a sizeable fraction of the entries have expired
-	 * increase scan frequency.
 	 */
-	ratio = scanned ? expired_count * 100 / scanned : 0;
-	if (ratio > GC_EVICT_RATIO) {
-		gc_work->next_gc_run = min_interval;
-	} else {
-		unsigned int max = GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV;
-
-		BUILD_BUG_ON((GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV) == 0);
-
-		gc_work->next_gc_run += min_interval;
-		if (gc_work->next_gc_run > max)
-			gc_work->next_gc_run = max;
+	if (next_run) {
+		gc_work->early_drop = false;
+		gc_work->next_bucket = 0;
 	}
-
-	next_run = gc_work->next_gc_run;
-	gc_work->last_bucket = i;
-	gc_work->early_drop = false;
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
 	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
-	gc_work->next_gc_run = HZ;
 	gc_work->exiting = false;
 }
 
-- 
2.30.2

