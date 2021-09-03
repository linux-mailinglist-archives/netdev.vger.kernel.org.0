Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2D400358
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350048AbhICQbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:31:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58770 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349999AbhICQbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:31:31 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6FA6B600AC;
        Fri,  3 Sep 2021 18:29:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/5] netfilter: refuse insertion if chain has grown too large
Date:   Fri,  3 Sep 2021 18:30:19 +0200
Message-Id: <20210903163020.13741-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210903163020.13741-1-pablo@netfilter.org>
References: <20210903163020.13741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Also add a stat counter for this that gets exported both via old /proc
interface and ctnetlink.

Assuming the old default size of 16536 buckets and max hash occupancy of
64k, this results in 128k insertions (origin+reply), so ~8 entries per
chain on average.

The revised settings in this series will result in about two entries per
bucket on average.

This allows a hard-limit ceiling of 64.

This is not tunable at the moment, but its possible to either increase
nf_conntrack_buckets or decrease nf_conntrack_max to reduce average
lengths.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h |  1 +
 .../linux/netfilter/nfnetlink_conntrack.h     |  1 +
 net/netfilter/nf_conntrack_core.c             | 42 +++++++++++++++----
 net/netfilter/nf_conntrack_netlink.c          |  4 +-
 net/netfilter/nf_conntrack_standalone.c       |  4 +-
 5 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 0c7d8d1e945d..700ea077ce2d 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -18,6 +18,7 @@ struct ip_conntrack_stat {
 	unsigned int expect_create;
 	unsigned int expect_delete;
 	unsigned int search_restart;
+	unsigned int chaintoolong;
 };
 
 #define NFCT_INFOMASK	7UL
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index d8484be72fdc..5ade231f497b 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -257,6 +257,7 @@ enum ctattr_stats_cpu {
 	CTA_STATS_ERROR,
 	CTA_STATS_SEARCH_RESTART,
 	CTA_STATS_CLASH_RESOLVE,
+	CTA_STATS_CHAIN_TOOLONG,
 	__CTA_STATS_MAX,
 };
 #define CTA_STATS_MAX (__CTA_STATS_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index da2650f872e1..94e18fb9690d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -77,6 +77,8 @@ static __read_mostly bool nf_conntrack_locks_all;
 #define GC_SCAN_INTERVAL	(120u * HZ)
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
+#define MAX_CHAINLEN	64u
+
 static struct conntrack_gc_work conntrack_gc_work;
 
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
@@ -840,7 +842,9 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
+	unsigned int chainlen = 0;
 	unsigned int sequence;
+	int err = -EEXIST;
 
 	zone = nf_ct_zone(ct);
 
@@ -854,15 +858,24 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
 	/* See if there's one in the list already, including reverse */
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode)
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
 
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode)
+		if (chainlen++ > MAX_CHAINLEN)
+			goto chaintoolong;
+	}
+
+	chainlen = 0;
+
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
+		if (chainlen++ > MAX_CHAINLEN)
+			goto chaintoolong;
+	}
 
 	smp_wmb();
 	/* The caller holds a reference to this object */
@@ -872,11 +885,13 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	NF_CT_STAT_INC(net, insert);
 	local_bh_enable();
 	return 0;
-
+chaintoolong:
+	NF_CT_STAT_INC(net, chaintoolong);
+	err = -ENOSPC;
 out:
 	nf_conntrack_double_unlock(hash, reply_hash);
 	local_bh_enable();
-	return -EEXIST;
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
 
@@ -1089,6 +1104,7 @@ int
 __nf_conntrack_confirm(struct sk_buff *skb)
 {
 	const struct nf_conntrack_zone *zone;
+	unsigned int chainlen = 0, sequence;
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -1096,7 +1112,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	struct hlist_nulls_node *n;
 	enum ip_conntrack_info ctinfo;
 	struct net *net;
-	unsigned int sequence;
 	int ret = NF_DROP;
 
 	ct = nf_ct_get(skb, &ctinfo);
@@ -1156,15 +1171,28 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode)
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
+		if (chainlen++ > MAX_CHAINLEN)
+			goto chaintoolong;
+	}
 
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode)
+	chainlen = 0;
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
+		if (chainlen++ > MAX_CHAINLEN) {
+chaintoolong:
+			nf_ct_add_to_dying_list(ct);
+			NF_CT_STAT_INC(net, chaintoolong);
+			NF_CT_STAT_INC(net, insert_failed);
+			ret = NF_DROP;
+			goto dying;
+		}
+	}
 
 	/* Timer relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e81af33b233b..3f081ae08266 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2484,7 +2484,9 @@ ctnetlink_ct_stat_cpu_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
 	    nla_put_be32(skb, CTA_STATS_SEARCH_RESTART,
 				htonl(st->search_restart)) ||
 	    nla_put_be32(skb, CTA_STATS_CLASH_RESOLVE,
-				htonl(st->clash_resolve)))
+				htonl(st->clash_resolve)) ||
+	    nla_put_be32(skb, CTA_STATS_CHAIN_TOOLONG,
+			 htonl(st->chaintoolong)))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e84b499b7bfa..f94ebd5194b5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -429,7 +429,7 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 	unsigned int nr_conntracks;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_puts(seq, "entries  clashres found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
+		seq_puts(seq, "entries  clashres found new invalid ignore delete chainlength insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
 		return 0;
 	}
 
@@ -444,7 +444,7 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 		   st->invalid,
 		   0,
 		   0,
-		   0,
+		   st->chaintoolong,
 		   st->insert,
 		   st->insert_failed,
 		   st->drop,
-- 
2.20.1

