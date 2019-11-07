Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C4F2641
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 05:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733175AbfKGEKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 23:10:13 -0500
Received: from mail-qv1-f74.google.com ([209.85.219.74]:41871 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733170AbfKGEKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 23:10:13 -0500
Received: by mail-qv1-f74.google.com with SMTP id m12so68659qvv.8
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 20:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cN/4lcAijvIZQQfWNZaiaf90DQFWhQ0mYjQsU5zLhmY=;
        b=ArgFFJ47wmvISeAr7P8lavQZGDm2s5hVeK1GFZ3Q2FYBV916Pk34VWtz8SxMt8MBo3
         dq8WtUXJ4qNrDiMPS4oH1sRK+SG1+YRyuXMD9kyjBVSfaGPu2Q6Wfa2oMJKE/6H9DIjL
         XkEfqyiUt0jOtLX0zCG7I6jaZH9MfsCBfmWJ+qQqSxcu2dhUWkahK/DFo9cidXSZ7Tum
         PKjgFz1/4beu4nw2/12zj+a75VAPZKYS8VYdMcj9LJNAt9zLuON2qr3/TytaZRYToYp5
         kgWZc3ygy7D2ggaEmkFmSpnHd+zSQl0mAAnuE6wjK3SGdP6gkxQHTM3JjQNa5g4ACr2U
         G0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cN/4lcAijvIZQQfWNZaiaf90DQFWhQ0mYjQsU5zLhmY=;
        b=XUu5tptIu767M945EBea5dp5P/j+k/9Q+PAEG0d3GXFMaElNCFt7YmFXIgK4gnJeyq
         ZxvxyOGNCkJHwVC+JdVdMPb/7WHE2+m4P88nuuYl6sCyP8/R8eNkTp1PQvEShVFM8AEJ
         E/fafE5BbgLgZu/nCsI+ZZ4+A8SOuZgAUF7966x/zXe6rmJtKx37zX+8vozA1TV1ZPAj
         H07gGXt9Q50vrDzKjpFPTgKpS6EjnO3XdNFBRtqpcfsFX141A/ipYVfptMJphaEuPMy5
         XPyEeMsc4liVq47btWVLKI4GPyqEEetvGBuYrtQ3u9ZXvwHKByoNTikIqxpcI5AKb06B
         aNUQ==
X-Gm-Message-State: APjAAAWaauj5ljmA+d51dwJHJOs0+h3I+PcH1EVQ1p+3WRz7GNjkgQlP
        SIDUmCJAL9m6hkGjGwvE8LUat9mxosD6
X-Google-Smtp-Source: APXvYqwu5oj2vUt85S8pQLdk8HeQYPStKWHIo9+Fb1RBf4IQeEU5DKmCOuyHuIstNKIMySV59jMdgGEJ33Oe
X-Received: by 2002:ac8:605a:: with SMTP id k26mr1578967qtm.212.1573099811546;
 Wed, 06 Nov 2019 20:10:11 -0800 (PST)
Date:   Wed,  6 Nov 2019 20:10:06 -0800
Message-Id: <20191107041006.33145-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4.4-stable] net/flow_dissector: switch to siphash
From:   Mahesh Bandewar <maheshb@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Jonathan Berger <jonathann1@walla.com>,
        Amit Klein <aksecurity@gmail.com>,
        Benny Pinkas <benny@pinkas.net>,
        Tom Herbert <tom@herbertland.com>, stable@vger.kernel.org,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 55667441c84fa5e0911a0aac44fb059c15ba6da2 ]

UDP IPv6 packets auto flowlabels are using a 32bit secret
(static u32 hashrnd in net/core/flow_dissector.c) and
apply jhash() over fields known by the receivers.

Attackers can easily infer the 32bit secret and use this information
to identify a device and/or user, since this 32bit secret is only
set at boot time.

Really, using jhash() to generate cookies sent on the wire
is a serious security concern.

Trying to change the rol32(hash, 16) in ip6_make_flowlabel() would be
a dead end. Trying to periodically change the secret (like in sch_sfq.c)
could change paths taken in the network for long lived flows.

Let's switch to siphash, as we did in commit df453700e8d8
("inet: switch IP ID generator to siphash")

Using a cryptographically strong pseudo random function will solve this
privacy issue and more generally remove other weak points in the stack.

Packet schedulers using skb_get_hash_perturb() benefit from this change.

Fixes: b56774163f99 ("ipv6: Enable auto flow labels by default")
Fixes: 42240901f7c4 ("ipv6: Implement different admin modes for automatic flow labels")
Fixes: 67800f9b1f4e ("ipv6: Call skb_get_hash_flowi6 to get skb->hash in ip6_make_flowlabel")
Fixes: cb1ce2ef387b ("ipv6: Implement automatic flow label generation on transmit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jonathan Berger <jonathann1@walla.com>
Reported-by: Amit Klein <aksecurity@gmail.com>
Reported-by: Benny Pinkas <benny@pinkas.net>
Cc: Tom Herbert <tom@herbertland.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 include/linux/skbuff.h       |  3 ++-
 include/net/flow_dissector.h |  3 ++-
 net/core/flow_dissector.c    | 48 +++++++++++++++---------------------
 net/sched/sch_fq_codel.c     |  6 ++---
 net/sched/sch_hhf.c          |  8 +++---
 net/sched/sch_sfb.c          | 13 +++++-----
 net/sched/sch_sfq.c          | 14 ++++++-----
 7 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a2f12d377d23..735ff1525f48 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1073,7 +1073,8 @@ static inline __u32 skb_get_hash_flowi4(struct sk_buff *skb, const struct flowi4
 	return skb->hash;
 }
 
-__u32 skb_get_hash_perturb(const struct sk_buff *skb, u32 perturb);
+__u32 skb_get_hash_perturb(const struct sk_buff *skb,
+			   const siphash_key_t *perturb);
 
 static inline __u32 skb_get_hash_raw(const struct sk_buff *skb)
 {
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 8c8548cf5888..62a462413081 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/in6.h>
+#include <linux/siphash.h>
 #include <uapi/linux/if_ether.h>
 
 /**
@@ -146,7 +147,7 @@ struct flow_dissector {
 struct flow_keys {
 	struct flow_dissector_key_control control;
 #define FLOW_KEYS_HASH_START_FIELD basic
-	struct flow_dissector_key_basic basic;
+	struct flow_dissector_key_basic basic __aligned(SIPHASH_ALIGNMENT);
 	struct flow_dissector_key_tags tags;
 	struct flow_dissector_key_keyid keyid;
 	struct flow_dissector_key_ports ports;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 697c4212129a..496bfcb787e7 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -505,45 +505,34 @@ out_bad:
 }
 EXPORT_SYMBOL(__skb_flow_dissect);
 
-static u32 hashrnd __read_mostly;
+static siphash_key_t hashrnd __read_mostly;
 static __always_inline void __flow_hash_secret_init(void)
 {
 	net_get_random_once(&hashrnd, sizeof(hashrnd));
 }
 
-static __always_inline u32 __flow_hash_words(const u32 *words, u32 length,
-					     u32 keyval)
+static const void *flow_keys_hash_start(const struct flow_keys *flow)
 {
-	return jhash2(words, length, keyval);
-}
-
-static inline const u32 *flow_keys_hash_start(const struct flow_keys *flow)
-{
-	const void *p = flow;
-
-	BUILD_BUG_ON(FLOW_KEYS_HASH_OFFSET % sizeof(u32));
-	return (const u32 *)(p + FLOW_KEYS_HASH_OFFSET);
+	BUILD_BUG_ON(FLOW_KEYS_HASH_OFFSET % SIPHASH_ALIGNMENT);
+	return &flow->FLOW_KEYS_HASH_START_FIELD;
 }
 
 static inline size_t flow_keys_hash_length(const struct flow_keys *flow)
 {
-	size_t diff = FLOW_KEYS_HASH_OFFSET + sizeof(flow->addrs);
-	BUILD_BUG_ON((sizeof(*flow) - FLOW_KEYS_HASH_OFFSET) % sizeof(u32));
-	BUILD_BUG_ON(offsetof(typeof(*flow), addrs) !=
-		     sizeof(*flow) - sizeof(flow->addrs));
+	size_t len = offsetof(typeof(*flow), addrs) - FLOW_KEYS_HASH_OFFSET;
 
 	switch (flow->control.addr_type) {
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
-		diff -= sizeof(flow->addrs.v4addrs);
+		len += sizeof(flow->addrs.v4addrs);
 		break;
 	case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
-		diff -= sizeof(flow->addrs.v6addrs);
+		len += sizeof(flow->addrs.v6addrs);
 		break;
 	case FLOW_DISSECTOR_KEY_TIPC_ADDRS:
-		diff -= sizeof(flow->addrs.tipcaddrs);
+		len += sizeof(flow->addrs.tipcaddrs);
 		break;
 	}
-	return (sizeof(*flow) - diff) / sizeof(u32);
+	return len;
 }
 
 __be32 flow_get_u32_src(const struct flow_keys *flow)
@@ -609,14 +598,15 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
 	}
 }
 
-static inline u32 __flow_hash_from_keys(struct flow_keys *keys, u32 keyval)
+static inline u32 __flow_hash_from_keys(struct flow_keys *keys,
+					const siphash_key_t *keyval)
 {
 	u32 hash;
 
 	__flow_hash_consistentify(keys);
 
-	hash = __flow_hash_words(flow_keys_hash_start(keys),
-				 flow_keys_hash_length(keys), keyval);
+	hash = siphash(flow_keys_hash_start(keys),
+		       flow_keys_hash_length(keys), keyval);
 	if (!hash)
 		hash = 1;
 
@@ -626,12 +616,13 @@ static inline u32 __flow_hash_from_keys(struct flow_keys *keys, u32 keyval)
 u32 flow_hash_from_keys(struct flow_keys *keys)
 {
 	__flow_hash_secret_init();
-	return __flow_hash_from_keys(keys, hashrnd);
+	return __flow_hash_from_keys(keys, &hashrnd);
 }
 EXPORT_SYMBOL(flow_hash_from_keys);
 
 static inline u32 ___skb_get_hash(const struct sk_buff *skb,
-				  struct flow_keys *keys, u32 keyval)
+				  struct flow_keys *keys,
+				  const siphash_key_t *keyval)
 {
 	skb_flow_dissect_flow_keys(skb, keys,
 				   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
@@ -679,7 +670,7 @@ u32 __skb_get_hash_symmetric(struct sk_buff *skb)
 			   NULL, 0, 0, 0,
 			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
 
-	return __flow_hash_from_keys(&keys, hashrnd);
+	return __flow_hash_from_keys(&keys, &hashrnd);
 }
 EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
 
@@ -698,12 +689,13 @@ void __skb_get_hash(struct sk_buff *skb)
 
 	__flow_hash_secret_init();
 
-	__skb_set_sw_hash(skb, ___skb_get_hash(skb, &keys, hashrnd),
+	__skb_set_sw_hash(skb, ___skb_get_hash(skb, &keys, &hashrnd),
 			  flow_keys_have_l4(&keys));
 }
 EXPORT_SYMBOL(__skb_get_hash);
 
-__u32 skb_get_hash_perturb(const struct sk_buff *skb, u32 perturb)
+__u32 skb_get_hash_perturb(const struct sk_buff *skb,
+			   const siphash_key_t *perturb)
 {
 	struct flow_keys keys;
 
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index d3fc8f9dd3d4..1800f7977595 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -55,7 +55,7 @@ struct fq_codel_sched_data {
 	struct fq_codel_flow *flows;	/* Flows table [flows_cnt] */
 	u32		*backlogs;	/* backlog table [flows_cnt] */
 	u32		flows_cnt;	/* number of flows */
-	u32		perturbation;	/* hash perturbation */
+	siphash_key_t	perturbation;	/* hash perturbation */
 	u32		quantum;	/* psched_mtu(qdisc_dev(sch)); */
 	struct codel_params cparams;
 	struct codel_stats cstats;
@@ -69,7 +69,7 @@ struct fq_codel_sched_data {
 static unsigned int fq_codel_hash(const struct fq_codel_sched_data *q,
 				  struct sk_buff *skb)
 {
-	u32 hash = skb_get_hash_perturb(skb, q->perturbation);
+	u32 hash = skb_get_hash_perturb(skb, &q->perturbation);
 
 	return reciprocal_scale(hash, q->flows_cnt);
 }
@@ -420,7 +420,7 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt)
 	sch->limit = 10*1024;
 	q->flows_cnt = 1024;
 	q->quantum = psched_mtu(qdisc_dev(sch));
-	q->perturbation = prandom_u32();
+	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	INIT_LIST_HEAD(&q->new_flows);
 	INIT_LIST_HEAD(&q->old_flows);
 	codel_params_init(&q->cparams, sch);
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index dc68dccc6b0c..40ec5b280eb6 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -4,11 +4,11 @@
  * Copyright (C) 2013 Nandita Dukkipati <nanditad@google.com>
  */
 
-#include <linux/jhash.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/vmalloc.h>
+#include <linux/siphash.h>
 #include <net/pkt_sched.h>
 #include <net/sock.h>
 
@@ -125,7 +125,7 @@ struct wdrr_bucket {
 
 struct hhf_sched_data {
 	struct wdrr_bucket buckets[WDRR_BUCKET_CNT];
-	u32		   perturbation;   /* hash perturbation */
+	siphash_key_t	   perturbation;   /* hash perturbation */
 	u32		   quantum;        /* psched_mtu(qdisc_dev(sch)); */
 	u32		   drop_overlimit; /* number of times max qdisc packet
 					    * limit was hit
@@ -263,7 +263,7 @@ static enum wdrr_bucket_idx hhf_classify(struct sk_buff *skb, struct Qdisc *sch)
 	}
 
 	/* Get hashed flow-id of the skb. */
-	hash = skb_get_hash_perturb(skb, q->perturbation);
+	hash = skb_get_hash_perturb(skb, &q->perturbation);
 
 	/* Check if this packet belongs to an already established HH flow. */
 	flow_pos = hash & HHF_BIT_MASK;
@@ -602,7 +602,7 @@ static int hhf_init(struct Qdisc *sch, struct nlattr *opt)
 
 	sch->limit = 1000;
 	q->quantum = psched_mtu(qdisc_dev(sch));
-	q->perturbation = prandom_u32();
+	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	INIT_LIST_HEAD(&q->new_buckets);
 	INIT_LIST_HEAD(&q->old_buckets);
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index c69611640fa5..10c0b184cdbe 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -22,7 +22,7 @@
 #include <linux/errno.h>
 #include <linux/skbuff.h>
 #include <linux/random.h>
-#include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <net/ip.h>
 #include <net/pkt_sched.h>
 #include <net/inet_ecn.h>
@@ -48,7 +48,7 @@ struct sfb_bucket {
  * (Section 4.4 of SFB reference : moving hash functions)
  */
 struct sfb_bins {
-	u32		  perturbation; /* jhash perturbation */
+	siphash_key_t	  perturbation; /* siphash key */
 	struct sfb_bucket bins[SFB_LEVELS][SFB_NUMBUCKETS];
 };
 
@@ -219,7 +219,8 @@ static u32 sfb_compute_qlen(u32 *prob_r, u32 *avgpm_r, const struct sfb_sched_da
 
 static void sfb_init_perturbation(u32 slot, struct sfb_sched_data *q)
 {
-	q->bins[slot].perturbation = prandom_u32();
+	get_random_bytes(&q->bins[slot].perturbation,
+			 sizeof(q->bins[slot].perturbation));
 }
 
 static void sfb_swap_slot(struct sfb_sched_data *q)
@@ -313,9 +314,9 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 		/* If using external classifiers, get result and record it. */
 		if (!sfb_classify(skb, fl, &ret, &salt))
 			goto other_drop;
-		sfbhash = jhash_1word(salt, q->bins[slot].perturbation);
+		sfbhash = siphash_1u32(salt, &q->bins[slot].perturbation);
 	} else {
-		sfbhash = skb_get_hash_perturb(skb, q->bins[slot].perturbation);
+		sfbhash = skb_get_hash_perturb(skb, &q->bins[slot].perturbation);
 	}
 
 
@@ -351,7 +352,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 		/* Inelastic flow */
 		if (q->double_buffering) {
 			sfbhash = skb_get_hash_perturb(skb,
-			    q->bins[slot].perturbation);
+			    &q->bins[slot].perturbation);
 			if (!sfbhash)
 				sfbhash = 1;
 			sfb_skb_cb(skb)->hashes[slot] = sfbhash;
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 8b8c084b32cd..e2e4ebc0c4c3 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -18,7 +18,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
-#include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <net/netlink.h>
@@ -120,7 +120,7 @@ struct sfq_sched_data {
 	u8		headdrop;
 	u8		maxdepth;	/* limit of packets per flow */
 
-	u32		perturbation;
+	siphash_key_t 	perturbation;
 	u8		cur_depth;	/* depth of longest slot */
 	u8		flags;
 	unsigned short  scaled_quantum; /* SFQ_ALLOT_SIZE(quantum) */
@@ -158,7 +158,7 @@ static inline struct sfq_head *sfq_dep_head(struct sfq_sched_data *q, sfq_index
 static unsigned int sfq_hash(const struct sfq_sched_data *q,
 			     const struct sk_buff *skb)
 {
-	return skb_get_hash_perturb(skb, q->perturbation) & (q->divisor - 1);
+	return skb_get_hash_perturb(skb, &q->perturbation) & (q->divisor - 1);
 }
 
 static unsigned int sfq_classify(struct sk_buff *skb, struct Qdisc *sch,
@@ -607,9 +607,11 @@ static void sfq_perturbation(unsigned long arg)
 	struct Qdisc *sch = (struct Qdisc *)arg;
 	struct sfq_sched_data *q = qdisc_priv(sch);
 	spinlock_t *root_lock = qdisc_lock(qdisc_root_sleeping(sch));
+	siphash_key_t nkey;
 
+	get_random_bytes(&nkey, sizeof(nkey));
 	spin_lock(root_lock);
-	q->perturbation = prandom_u32();
+	q->perturbation = nkey;
 	if (!q->filter_list && q->tail)
 		sfq_rehash(sch);
 	spin_unlock(root_lock);
@@ -681,7 +683,7 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
 	del_timer(&q->perturb_timer);
 	if (q->perturb_period) {
 		mod_timer(&q->perturb_timer, jiffies + q->perturb_period);
-		q->perturbation = prandom_u32();
+		get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	}
 	sch_tree_unlock(sch);
 	kfree(p);
@@ -737,7 +739,7 @@ static int sfq_init(struct Qdisc *sch, struct nlattr *opt)
 	q->quantum = psched_mtu(qdisc_dev(sch));
 	q->scaled_quantum = SFQ_ALLOT_SIZE(q->quantum);
 	q->perturb_period = 0;
-	q->perturbation = prandom_u32();
+	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 
 	if (opt) {
 		int err = sfq_change(sch, opt);
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

