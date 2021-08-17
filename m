Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8579D3EE14D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbhHQAiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236538AbhHQAgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D32A60FDA;
        Tue, 17 Aug 2021 00:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160572;
        bh=gGxucNnX8pzMdaQ2XCm4bfo08ff5RT7RD/vCPls0mXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBhfIWF8bporl2gU9VdxVM6kxIsY3jZCCmjuxWlP/7ww42ZDqbLL8h7WnGKFSH04H
         ZibcjDrTou0mFQWDy+pyNMiRO8AirQcUTeEbkfFMJaTqqIyehy3e26dnQpzieHmzc5
         p3ewvmISG5clYtv163U6k64GhXpyCK3iiOt4FXS6DLOv3fS6GQ4thJ9gEEEyGjqWKK
         EyE4tEJRIJ4O0QLF1QBz/lVqO6D8qrAf3tursJbtxh483wP9v2MkPQUP9+iz3WH2VK
         UCZF248wBEno4RDibn2r4I+eip37k+TcxxXnyHOS0QLPZDGQExyvoqs1IyuSHdlTxM
         zjpuFxp/PU9YQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/5] netfilter: conntrack: collect all entries in one cycle
Date:   Mon, 16 Aug 2021 20:36:05 -0400
Message-Id: <20210817003607.83340-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003607.83340-1-sashal@kernel.org>
References: <20210817003607.83340-1-sashal@kernel.org>
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
index 4a988ce4264c..4bcc36e4b2ef 100644
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
 
@@ -1226,17 +1221,13 @@ static void nf_ct_offload_timeout(struct nf_conn *ct)
 
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
 
@@ -1244,22 +1235,21 @@ static void gc_worker(struct work_struct *work)
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
@@ -1267,7 +1257,6 @@ static void gc_worker(struct work_struct *work)
 
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
-				expired_count++;
 				continue;
 			}
 
@@ -1299,7 +1288,14 @@ static void gc_worker(struct work_struct *work)
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
@@ -1310,40 +1306,17 @@ static void gc_worker(struct work_struct *work)
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

