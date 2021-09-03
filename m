Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582DA400356
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350028AbhICQbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:31:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58766 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbhICQbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:31:31 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D98ED600AB;
        Fri,  3 Sep 2021 18:29:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/5] netfilter: conntrack: switch to siphash
Date:   Fri,  3 Sep 2021 18:30:18 +0200
Message-Id: <20210903163020.13741-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210903163020.13741-1-pablo@netfilter.org>
References: <20210903163020.13741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Replace jhash in conntrack and nat core with siphash.

While at it, use the netns mix value as part of the input key
rather than abuse the seed value.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c   | 31 +++++++++++++++++------------
 net/netfilter/nf_conntrack_expect.c | 25 ++++++++++++++++-------
 net/netfilter/nf_nat_core.c         | 18 +++++++++++++----
 3 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index cdd8a1dc2275..da2650f872e1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -21,7 +21,6 @@
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/random.h>
-#include <linux/jhash.h>
 #include <linux/siphash.h>
 #include <linux/err.h>
 #include <linux/percpu.h>
@@ -184,25 +183,31 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 unsigned int nf_conntrack_max __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_max);
 seqcount_spinlock_t nf_conntrack_generation __read_mostly;
-static unsigned int nf_conntrack_hash_rnd __read_mostly;
+static siphash_key_t nf_conntrack_hash_rnd __read_mostly;
 
 static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
 			      const struct net *net)
 {
-	unsigned int n;
-	u32 seed;
+	struct {
+		struct nf_conntrack_man src;
+		union nf_inet_addr dst_addr;
+		u32 net_mix;
+		u16 dport;
+		u16 proto;
+	} __aligned(SIPHASH_ALIGNMENT) combined;
 
 	get_random_once(&nf_conntrack_hash_rnd, sizeof(nf_conntrack_hash_rnd));
 
-	/* The direction must be ignored, so we hash everything up to the
-	 * destination ports (which is a multiple of 4) and treat the last
-	 * three bytes manually.
-	 */
-	seed = nf_conntrack_hash_rnd ^ net_hash_mix(net);
-	n = (sizeof(tuple->src) + sizeof(tuple->dst.u3)) / sizeof(u32);
-	return jhash2((u32 *)tuple, n, seed ^
-		      (((__force __u16)tuple->dst.u.all << 16) |
-		      tuple->dst.protonum));
+	memset(&combined, 0, sizeof(combined));
+
+	/* The direction must be ignored, so handle usable members manually. */
+	combined.src = tuple->src;
+	combined.dst_addr = tuple->dst.u3;
+	combined.net_mix = net_hash_mix(net);
+	combined.dport = (__force __u16)tuple->dst.u.all;
+	combined.proto = tuple->dst.protonum;
+
+	return (u32)siphash(&combined, sizeof(combined), &nf_conntrack_hash_rnd);
 }
 
 static u32 scale_hash(u32 hash)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 1e851bc2e61a..f562eeef4234 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -17,7 +17,7 @@
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/kernel.h>
-#include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/moduleparam.h>
 #include <linux/export.h>
 #include <net/net_namespace.h>
@@ -41,7 +41,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_hash);
 unsigned int nf_ct_expect_max __read_mostly;
 
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
-static unsigned int nf_ct_expect_hashrnd __read_mostly;
+static siphash_key_t nf_ct_expect_hashrnd __read_mostly;
 
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
@@ -81,15 +81,26 @@ static void nf_ct_expectation_timed_out(struct timer_list *t)
 
 static unsigned int nf_ct_expect_dst_hash(const struct net *n, const struct nf_conntrack_tuple *tuple)
 {
-	unsigned int hash, seed;
+	struct {
+		union nf_inet_addr dst_addr;
+		u32 net_mix;
+		u16 dport;
+		u8 l3num;
+		u8 protonum;
+	} __aligned(SIPHASH_ALIGNMENT) combined;
+	u32 hash;
 
 	get_random_once(&nf_ct_expect_hashrnd, sizeof(nf_ct_expect_hashrnd));
 
-	seed = nf_ct_expect_hashrnd ^ net_hash_mix(n);
+	memset(&combined, 0, sizeof(combined));
 
-	hash = jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
-		      (((tuple->dst.protonum ^ tuple->src.l3num) << 16) |
-		       (__force __u16)tuple->dst.u.all) ^ seed);
+	combined.dst_addr = tuple->dst.u3;
+	combined.net_mix = net_hash_mix(n);
+	combined.dport = (__force __u16)tuple->dst.u.all;
+	combined.l3num = tuple->src.l3num;
+	combined.protonum = tuple->dst.protonum;
+
+	hash = siphash(&combined, sizeof(combined), &nf_ct_expect_hashrnd);
 
 	return reciprocal_scale(hash, nf_ct_expect_hsize);
 }
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 7de595ead06a..7008961f5cb0 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -13,7 +13,7 @@
 #include <linux/skbuff.h>
 #include <linux/gfp.h>
 #include <net/xfrm.h>
-#include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/rtnetlink.h>
 
 #include <net/netfilter/nf_conntrack.h>
@@ -34,7 +34,7 @@ static unsigned int nat_net_id __read_mostly;
 
 static struct hlist_head *nf_nat_bysource __read_mostly;
 static unsigned int nf_nat_htable_size __read_mostly;
-static unsigned int nf_nat_hash_rnd __read_mostly;
+static siphash_key_t nf_nat_hash_rnd __read_mostly;
 
 struct nf_nat_lookup_hook_priv {
 	struct nf_hook_entries __rcu *entries;
@@ -153,12 +153,22 @@ static unsigned int
 hash_by_src(const struct net *n, const struct nf_conntrack_tuple *tuple)
 {
 	unsigned int hash;
+	struct {
+		struct nf_conntrack_man src;
+		u32 net_mix;
+		u32 protonum;
+	} __aligned(SIPHASH_ALIGNMENT) combined;
 
 	get_random_once(&nf_nat_hash_rnd, sizeof(nf_nat_hash_rnd));
 
+	memset(&combined, 0, sizeof(combined));
+
 	/* Original src, to ensure we map it consistently if poss. */
-	hash = jhash2((u32 *)&tuple->src, sizeof(tuple->src) / sizeof(u32),
-		      tuple->dst.protonum ^ nf_nat_hash_rnd ^ net_hash_mix(n));
+	combined.src = tuple->src;
+	combined.net_mix = net_hash_mix(n);
+	combined.protonum = tuple->dst.protonum;
+
+	hash = siphash(&combined, sizeof(combined), &nf_nat_hash_rnd);
 
 	return reciprocal_scale(hash, nf_nat_htable_size);
 }
-- 
2.20.1

