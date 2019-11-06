Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED22DF1C70
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbfKFR0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:26:12 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:41967 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbfKFR0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 12:26:12 -0500
Received: by mail-pf1-f201.google.com with SMTP id j2so19491502pfa.8
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 09:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=V+W/TS+dW/3aCiZZzwxLm7K8L/4Hjris1CcKPH0o+sY=;
        b=slRW4WYhBMW8rfA5sruS9+Kit7Sx3Y4D/3TFT/+VVP4eVidtIGcSX/iPUiZRGhdYUO
         JRbqvwEmgwSemlNsuAHSLr1wUcn3U7AOIx3reBsLVqal4holkudctn36l19MsJP+joG/
         V6DLutjRGL3p+9CfeRLFFS8KlJ9WCATAig7UFPjy/cGdAAdtRrF3DY+nFotoQshJE97m
         MOAcFvZzRz6PZ/pq/F0lVAd0yYCw0Kg1yXP38cmZ9hM/tpd4P7tsXgD3x6UbELn6O7m4
         4JpgAgLlkYMPB0EzqBXLhcLZtt4rOKeB6V6HyZVSkcIYrlltufAZmOhlviUGFOERvi/R
         xnzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=V+W/TS+dW/3aCiZZzwxLm7K8L/4Hjris1CcKPH0o+sY=;
        b=EVjOqICKvvQKrYeQ1F9axdvHSY2m+Tam6iQ1D6igGYTK7o0VTVEfLQrojmWUoZ4cdI
         kKEq9XHFGlwojBmnZA4uNrwtDMhb5TGQagH5oU2DMSwof7Wq2bUf5uZlmkbpF5xppreT
         BDIJUePvMVy1IgoOT5n5VeYUxjBIHTk/gRz9oT0DdJPEjF9AJ7ZIE6H1uMakiweroS88
         w1Ds1hpU8zEhdNxb0sLWXS67LWiMWhpDBsjGgY+WvFGsikOkOdNb6HI79GS2fmLQf7hi
         BJWl9GnZDLFQ6McvNLICCDPi7XsuA0dtu07zBqsXve1DSgkwZL6HkIfZDN8JukaecnqL
         ebRw==
X-Gm-Message-State: APjAAAU/38SxU3otgizeX3uJZqATrtTGZDOgRR8IQCZsTiRE9bDgKDkb
        id4xxyXp4jp0k5KTKyXWjUDdT6vSD7vpqA==
X-Google-Smtp-Source: APXvYqzM51IO1MSUX6PaIyc1yFNQJi/kfd9cQ4MvxjlLPfQyZ7Qs91XCoXTK0xgrUivys/VfVDyShkaMUqvcYg==
X-Received: by 2002:a65:57ce:: with SMTP id q14mr4253315pgr.218.1573061170908;
 Wed, 06 Nov 2019 09:26:10 -0800 (PST)
Date:   Wed,  6 Nov 2019 09:25:58 -0800
Message-Id: <20191106172558.231622-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4.14-stable] net/flow_dissector: switch to siphash
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
Cc: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---

Backport notes : Please take attention to flow_keys_hash_length() that I had to rewrite
(I might also push this change in net-next in the future)

 include/linux/skbuff.h       |  3 ++-
 include/net/flow_dissector.h |  3 ++-
 include/net/fq.h             |  2 +-
 include/net/fq_impl.h        |  4 +--
 net/core/flow_dissector.c    | 48 +++++++++++++++---------------------
 net/sched/sch_hhf.c          |  8 +++---
 net/sched/sch_sfb.c          | 13 +++++-----
 net/sched/sch_sfq.c          | 14 ++++++-----
 8 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fdb0cd0699b685d6d2023c3e0081d431c3926e16..abafaba901469cc4929630a6d503409781b80c65 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1228,7 +1228,8 @@ static inline __u32 skb_get_hash_flowi6(struct sk_buff *skb, const struct flowi6
 	return skb->hash;
 }
 
-__u32 skb_get_hash_perturb(const struct sk_buff *skb, u32 perturb);
+__u32 skb_get_hash_perturb(const struct sk_buff *skb,
+			   const siphash_key_t *perturb);
 
 static inline __u32 skb_get_hash_raw(const struct sk_buff *skb)
 {
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 22aba321282dec4d04b678a2cfea252f1e0f058e..227dc0a841728e3298ca50b2d15b0569817934f3 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/in6.h>
+#include <linux/siphash.h>
 #include <uapi/linux/if_ether.h>
 
 /**
@@ -229,7 +230,7 @@ struct flow_dissector {
 struct flow_keys {
 	struct flow_dissector_key_control control;
 #define FLOW_KEYS_HASH_START_FIELD basic
-	struct flow_dissector_key_basic basic;
+	struct flow_dissector_key_basic basic __aligned(SIPHASH_ALIGNMENT);
 	struct flow_dissector_key_tags tags;
 	struct flow_dissector_key_vlan vlan;
 	struct flow_dissector_key_keyid keyid;
diff --git a/include/net/fq.h b/include/net/fq.h
index 6d8521a30c5cf3951a868aea9b7817ffda749de4..2c76879027895f49154ae1a5c2eba3ac6019b184 100644
--- a/include/net/fq.h
+++ b/include/net/fq.h
@@ -70,7 +70,7 @@ struct fq {
 	struct list_head backlogs;
 	spinlock_t lock;
 	u32 flows_cnt;
-	u32 perturbation;
+	siphash_key_t	perturbation;
 	u32 limit;
 	u32 memory_limit;
 	u32 memory_usage;
diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
index ac1a2317941e7186abd01d3df0bf9ebc055be38b..46903e23eab9bad0c83eb781662eb129baf78d48 100644
--- a/include/net/fq_impl.h
+++ b/include/net/fq_impl.h
@@ -105,7 +105,7 @@ static struct fq_flow *fq_flow_classify(struct fq *fq,
 
 	lockdep_assert_held(&fq->lock);
 
-	hash = skb_get_hash_perturb(skb, fq->perturbation);
+	hash = skb_get_hash_perturb(skb, &fq->perturbation);
 	idx = reciprocal_scale(hash, fq->flows_cnt);
 	flow = &fq->flows[idx];
 
@@ -255,7 +255,7 @@ static int fq_init(struct fq *fq, int flows_cnt)
 	INIT_LIST_HEAD(&fq->backlogs);
 	spin_lock_init(&fq->lock);
 	fq->flows_cnt = max_t(u32, flows_cnt, 1);
-	fq->perturbation = prandom_u32();
+	get_random_bytes(&fq->perturbation, sizeof(fq->perturbation));
 	fq->quantum = 300;
 	fq->limit = 8192;
 	fq->memory_limit = 16 << 20; /* 16 MBytes */
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index e2e716003ede769e8250571f6ece862c842a649a..7be5c20a93a5bc348caf7f4808cdd21f80cb1307 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -889,45 +889,34 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
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
@@ -993,14 +982,15 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
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
 
@@ -1010,12 +1000,13 @@ static inline u32 __flow_hash_from_keys(struct flow_keys *keys, u32 keyval)
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
@@ -1063,7 +1054,7 @@ u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
 			   NULL, 0, 0, 0,
 			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
 
-	return __flow_hash_from_keys(&keys, hashrnd);
+	return __flow_hash_from_keys(&keys, &hashrnd);
 }
 EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
 
@@ -1083,13 +1074,14 @@ void __skb_get_hash(struct sk_buff *skb)
 
 	__flow_hash_secret_init();
 
-	hash = ___skb_get_hash(skb, &keys, hashrnd);
+	hash = ___skb_get_hash(skb, &keys, &hashrnd);
 
 	__skb_set_sw_hash(skb, hash, flow_keys_have_l4(&keys));
 }
 EXPORT_SYMBOL(__skb_get_hash);
 
-__u32 skb_get_hash_perturb(const struct sk_buff *skb, u32 perturb)
+__u32 skb_get_hash_perturb(const struct sk_buff *skb,
+			   const siphash_key_t *perturb)
 {
 	struct flow_keys keys;
 
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index fa256f8038afd223d2e3e797ecbc2d7d689965ce..c73475c3a4640d5f3dac30c5e4ca7045b584b910 100644
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
@@ -578,7 +578,7 @@ static int hhf_init(struct Qdisc *sch, struct nlattr *opt)
 
 	sch->limit = 1000;
 	q->quantum = psched_mtu(qdisc_dev(sch));
-	q->perturbation = prandom_u32();
+	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	INIT_LIST_HEAD(&q->new_buckets);
 	INIT_LIST_HEAD(&q->old_buckets);
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index cc39e170b4aa2593177cd9364465a5bffa49839d..04f15e0aeaa8b8902363d8ed77c3cf26f6e422c9 100644
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
 #include <net/pkt_cls.h>
@@ -49,7 +49,7 @@ struct sfb_bucket {
  * (Section 4.4 of SFB reference : moving hash functions)
  */
 struct sfb_bins {
-	u32		  perturbation; /* jhash perturbation */
+	siphash_key_t	  perturbation; /* siphash key */
 	struct sfb_bucket bins[SFB_LEVELS][SFB_NUMBUCKETS];
 };
 
@@ -221,7 +221,8 @@ static u32 sfb_compute_qlen(u32 *prob_r, u32 *avgpm_r, const struct sfb_sched_da
 
 static void sfb_init_perturbation(u32 slot, struct sfb_sched_data *q)
 {
-	q->bins[slot].perturbation = prandom_u32();
+	get_random_bytes(&q->bins[slot].perturbation,
+			 sizeof(q->bins[slot].perturbation));
 }
 
 static void sfb_swap_slot(struct sfb_sched_data *q)
@@ -317,9 +318,9 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		/* If using external classifiers, get result and record it. */
 		if (!sfb_classify(skb, fl, &ret, &salt))
 			goto other_drop;
-		sfbhash = jhash_1word(salt, q->bins[slot].perturbation);
+		sfbhash = siphash_1u32(salt, &q->bins[slot].perturbation);
 	} else {
-		sfbhash = skb_get_hash_perturb(skb, q->bins[slot].perturbation);
+		sfbhash = skb_get_hash_perturb(skb, &q->bins[slot].perturbation);
 	}
 
 
@@ -355,7 +356,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		/* Inelastic flow */
 		if (q->double_buffering) {
 			sfbhash = skb_get_hash_perturb(skb,
-			    q->bins[slot].perturbation);
+			    &q->bins[slot].perturbation);
 			if (!sfbhash)
 				sfbhash = 1;
 			sfb_skb_cb(skb)->hashes[slot] = sfbhash;
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 3fbf20126045197c11c989602dc72a98c829d4b6..cbc54ddfe076a006e7d78fc8569a6e0cd0b8be85 100644
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
@@ -121,7 +121,7 @@ struct sfq_sched_data {
 	u8		headdrop;
 	u8		maxdepth;	/* limit of packets per flow */
 
-	u32		perturbation;
+	siphash_key_t 	perturbation;
 	u8		cur_depth;	/* depth of longest slot */
 	u8		flags;
 	unsigned short  scaled_quantum; /* SFQ_ALLOT_SIZE(quantum) */
@@ -160,7 +160,7 @@ static inline struct sfq_head *sfq_dep_head(struct sfq_sched_data *q, sfq_index
 static unsigned int sfq_hash(const struct sfq_sched_data *q,
 			     const struct sk_buff *skb)
 {
-	return skb_get_hash_perturb(skb, q->perturbation) & (q->divisor - 1);
+	return skb_get_hash_perturb(skb, &q->perturbation) & (q->divisor - 1);
 }
 
 static unsigned int sfq_classify(struct sk_buff *skb, struct Qdisc *sch,
@@ -609,9 +609,11 @@ static void sfq_perturbation(unsigned long arg)
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
@@ -690,7 +692,7 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
 	del_timer(&q->perturb_timer);
 	if (q->perturb_period) {
 		mod_timer(&q->perturb_timer, jiffies + q->perturb_period);
-		q->perturbation = prandom_u32();
+		get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	}
 	sch_tree_unlock(sch);
 	kfree(p);
@@ -746,7 +748,7 @@ static int sfq_init(struct Qdisc *sch, struct nlattr *opt)
 	q->quantum = psched_mtu(qdisc_dev(sch));
 	q->scaled_quantum = SFQ_ALLOT_SIZE(q->quantum);
 	q->perturb_period = 0;
-	q->perturbation = prandom_u32();
+	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 
 	if (opt) {
 		int err = sfq_change(sch, opt);
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

