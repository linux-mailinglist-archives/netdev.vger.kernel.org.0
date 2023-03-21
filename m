Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0976C28FE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCUEHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCUEGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:06:23 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219F43D0B0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:02:37 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-544539a729cso140267547b3.5
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679371280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WmWKSzA63CN7LT+BTBdYXjGrN+wJ3dRogHGFV2jVHZg=;
        b=VtjaQVTF8NG3ehhuBNFf6BZlh3FFwu+Off+lfPp9OqW2HAD8AOvAl8wG6oTuRyW0bl
         uBo/5Ht1T61j+YwJXynWNjWoNaV3lA47Vj2cAN3WcNJe1l/D3/fuWxutiYN9A7z26qL5
         yU4hUSIyuSg5Q7uYoTZQkW0KVifDvZrGGV3B2xdNiUBDxicar7UP8eo3ltkwHWZadtQS
         Q5s9EPT8vVFzrPbsDNZ5OaSA6/zhJ9ZcBy1tTZiIs6Jb3PP1oCxldyRdMbhLPnR4053D
         fb1vIi3LkWtxdbHZJQOp0PKe1URVA0D5auGKedBYkCx3/9O4XI5L9JTLlGZh+x+zw1pN
         Es4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679371280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WmWKSzA63CN7LT+BTBdYXjGrN+wJ3dRogHGFV2jVHZg=;
        b=syAanLC18OCH0oBWsdJdhIqg16VsX1sOgjNpJmpC0ZEp8TrL8wfzJP0tRH4vbcdfNz
         4GzT5Km1s3hYxmpPu34NnGl5S+fHrO6fjA4f9QmfEBbx2K/G2DQRIGP/WeoNQBrooPb6
         6Jcno53jfVFmq/+TLrZt7LkJu8uuR1WM2aJ6QU2xeCZVOKJfO9zJC2Zr7MbhlhosuN5G
         68c/gKyMrAlxSiZWdVhldTjPR3yTKw9tspWFb9YjOXxVE1Gvnd04ZF3QerQ0ONWP7Gw9
         ohRLQ6ycqF5YaOu6IUnqYHGqdj6nI4ALY19Br5h+cYFqpJCeW0PflfuZrul587VqxOHh
         84fA==
X-Gm-Message-State: AAQBX9cMK0iiyLHVsh3zinCt+KiYPY6h65nW+cKPflr9NwhcqYwIKZ+a
        RzXFaN+9UnVMIK4tw2FmRpwOQGXP6+rpxw==
X-Google-Smtp-Source: AKy350bTnIz/qzRAcsefbQ6Z8Wj8CobJ920xZfw2zKRrfqWEp0Wi2VS4tqJdrWOJsuhV1OrPBkbz4fPFU1WK3Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:703:b0:b6a:2590:6c63 with SMTP
 id k3-20020a056902070300b00b6a25906c63mr534498ybt.2.1679371280843; Mon, 20
 Mar 2023 21:01:20 -0700 (PDT)
Date:   Tue, 21 Mar 2023 04:01:14 +0000
In-Reply-To: <20230321040115.787497-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230321040115.787497-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321040115.787497-3-edumazet@google.com>
Subject: [PATCH net-next 2/3] neighbour: switch to standard rcu, instead of rcu_bh
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rcu_bh is no longer a win, especially for objects freed
with standard call_rcu().

Switch neighbour code to no longer disable BH when not necessary.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/arp.h        |  8 ++---
 include/net/ndisc.h      | 12 ++++----
 include/net/neighbour.h  |  6 ++--
 include/net/nexthop.h    |  6 ++--
 net/core/filter.c        | 16 ++++++----
 net/core/neighbour.c     | 64 ++++++++++++++++++++--------------------
 net/ipv4/fib_semantics.c |  4 +--
 net/ipv4/ip_output.c     |  6 ++--
 net/ipv4/nexthop.c       |  8 ++---
 net/ipv4/route.c         |  4 +--
 net/ipv6/addrconf.c      | 14 ++++-----
 net/ipv6/ip6_output.c    | 10 +++----
 net/ipv6/route.c         | 12 ++++----
 13 files changed, 87 insertions(+), 83 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index d7ef4ec71dfebac562f3ecf965c36547375de78c..e8747e0713c79f6f4934bb8474498f59cc5b189c 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -38,11 +38,11 @@ static inline struct neighbour *__ipv4_neigh_lookup(struct net_device *dev, u32
 {
 	struct neighbour *n;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	n = __ipv4_neigh_lookup_noref(dev, key);
 	if (n && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	return n;
 }
@@ -51,10 +51,10 @@ static inline void __ipv4_confirm_neigh(struct net_device *dev, u32 key)
 {
 	struct neighbour *n;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	n = __ipv4_neigh_lookup_noref(dev, key);
 	neigh_confirm(n);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 }
 
 void arp_init(void);
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 07e5168cdaf9a5a5a180a2d97c646552655982ce..52eae09434335dae0d9602d5027f45100bb47253 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -395,11 +395,11 @@ static inline struct neighbour *__ipv6_neigh_lookup(struct net_device *dev, cons
 {
 	struct neighbour *n;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	n = __ipv6_neigh_lookup_noref(dev, pkey);
 	if (n && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	return n;
 }
@@ -409,10 +409,10 @@ static inline void __ipv6_confirm_neigh(struct net_device *dev,
 {
 	struct neighbour *n;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	n = __ipv6_neigh_lookup_noref(dev, pkey);
 	neigh_confirm(n);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 }
 
 static inline void __ipv6_confirm_neigh_stub(struct net_device *dev,
@@ -420,10 +420,10 @@ static inline void __ipv6_confirm_neigh_stub(struct net_device *dev,
 {
 	struct neighbour *n;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	n = __ipv6_neigh_lookup_noref_stub(dev, pkey);
 	neigh_confirm(n);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 }
 
 /* uses ipv6_stub and is meant for use outside of IPv6 core */
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index c8d39bba2a0de1a6203fef9216212c409e1aec4c..3fa5774bddac3171c74d5b0595b82bff17d7dcaa 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -299,14 +299,14 @@ static inline struct neighbour *___neigh_lookup_noref(
 	const void *pkey,
 	struct net_device *dev)
 {
-	struct neigh_hash_table *nht = rcu_dereference_bh(tbl->nht);
+	struct neigh_hash_table *nht = rcu_dereference(tbl->nht);
 	struct neighbour *n;
 	u32 hash_val;
 
 	hash_val = hash(pkey, dev, nht->hash_rnd) >> (32 - nht->hash_shift);
-	for (n = rcu_dereference_bh(nht->hash_buckets[hash_val]);
+	for (n = rcu_dereference(nht->hash_buckets[hash_val]);
 	     n != NULL;
-	     n = rcu_dereference_bh(n->next)) {
+	     n = rcu_dereference(n->next)) {
 		if (n->dev == dev && key_eq(n, pkey))
 			return n;
 	}
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 28085b995ddcfe2269f1f8524ea747a881d835a4..9fa291a046211e4fc1c7ae56094a124c4ce0a516 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -498,7 +498,7 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 }
 
 /* Variant of nexthop_fib6_nh().
- * Caller should either hold rcu_read_lock_bh(), or RTNL.
+ * Caller should either hold rcu_read_lock(), or RTNL.
  */
 static inline struct fib6_nh *nexthop_fib6_nh_bh(struct nexthop *nh)
 {
@@ -507,13 +507,13 @@ static inline struct fib6_nh *nexthop_fib6_nh_bh(struct nexthop *nh)
 	if (nh->is_group) {
 		struct nh_group *nh_grp;
 
-		nh_grp = rcu_dereference_bh_rtnl(nh->nh_grp);
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
 		nh = nexthop_mpath_select(nh_grp, 0);
 		if (!nh)
 			return NULL;
 	}
 
-	nhi = rcu_dereference_bh_rtnl(nh->nh_info);
+	nhi = rcu_dereference_rtnl(nh->nh_info);
 	if (nhi->family == AF_INET6)
 		return &nhi->fib6_nh;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index d052fac28d02e79d83720c9001af40c53b5024fd..a8c8fd96c82234305990183c6f253e412d311b07 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2204,7 +2204,7 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
 			return -ENOMEM;
 	}
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	if (!nh) {
 		dst = skb_dst(skb);
 		nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
@@ -2217,10 +2217,12 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
 		int ret;
 
 		sock_confirm_neigh(skb, neigh);
+		local_bh_disable();
 		dev_xmit_recursion_inc();
 		ret = neigh_output(neigh, skb, false);
 		dev_xmit_recursion_dec();
-		rcu_read_unlock_bh();
+		local_bh_enable();
+		rcu_read_unlock();
 		return ret;
 	}
 	rcu_read_unlock_bh();
@@ -2302,7 +2304,7 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
 			return -ENOMEM;
 	}
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	if (!nh) {
 		struct dst_entry *dst = skb_dst(skb);
 		struct rtable *rt = container_of(dst, struct rtable, dst);
@@ -2314,7 +2316,7 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
 	} else if (nh->nh_family == AF_INET) {
 		neigh = ip_neigh_gw4(dev, nh->ipv4_nh);
 	} else {
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 		goto out_drop;
 	}
 
@@ -2322,13 +2324,15 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
 		int ret;
 
 		sock_confirm_neigh(skb, neigh);
+		local_bh_disable();
 		dev_xmit_recursion_inc();
 		ret = neigh_output(neigh, skb, is_v6gw);
 		dev_xmit_recursion_dec();
-		rcu_read_unlock_bh();
+		local_bh_enable();
+		rcu_read_unlock();
 		return ret;
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 out_drop:
 	kfree_skb(skb);
 	return -ENETDOWN;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 90d399b3f9800e574d65aa795fb5a96e5bc96919..ddd0f32de20effd0c571976fac33b343ac4ef7b7 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -614,7 +614,7 @@ struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
 
 	NEIGH_CACHE_STAT_INC(tbl, lookups);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	n = __neigh_lookup_noref(tbl, pkey, dev);
 	if (n) {
 		if (!refcount_inc_not_zero(&n->refcnt))
@@ -622,7 +622,7 @@ struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
 		NEIGH_CACHE_STAT_INC(tbl, hits);
 	}
 
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	return n;
 }
 EXPORT_SYMBOL(neigh_lookup);
@@ -2184,11 +2184,11 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
 			.ndtc_proxy_qlen	= tbl->proxy_queue.qlen,
 		};
 
-		rcu_read_lock_bh();
-		nht = rcu_dereference_bh(tbl->nht);
+		rcu_read_lock();
+		nht = rcu_dereference(tbl->nht);
 		ndc.ndtc_hash_rnd = nht->hash_rnd[0];
 		ndc.ndtc_hash_mask = ((1 << nht->hash_shift) - 1);
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 
 		if (nla_put(skb, NDTA_CONFIG, sizeof(ndc), &ndc))
 			goto nla_put_failure;
@@ -2703,15 +2703,15 @@ static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
 	if (filter->dev_idx || filter->master_idx)
 		flags |= NLM_F_DUMP_FILTERED;
 
-	rcu_read_lock_bh();
-	nht = rcu_dereference_bh(tbl->nht);
+	rcu_read_lock();
+	nht = rcu_dereference(tbl->nht);
 
 	for (h = s_h; h < (1 << nht->hash_shift); h++) {
 		if (h > s_h)
 			s_idx = 0;
-		for (n = rcu_dereference_bh(nht->hash_buckets[h]), idx = 0;
+		for (n = rcu_dereference(nht->hash_buckets[h]), idx = 0;
 		     n != NULL;
-		     n = rcu_dereference_bh(n->next)) {
+		     n = rcu_dereference(n->next)) {
 			if (idx < s_idx || !net_eq(dev_net(n->dev), net))
 				goto next;
 			if (neigh_ifindex_filtered(n->dev, filter->dev_idx) ||
@@ -2730,7 +2730,7 @@ static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
 	}
 	rc = skb->len;
 out:
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	cb->args[1] = h;
 	cb->args[2] = idx;
 	return rc;
@@ -3075,20 +3075,20 @@ void neigh_for_each(struct neigh_table *tbl, void (*cb)(struct neighbour *, void
 	int chain;
 	struct neigh_hash_table *nht;
 
-	rcu_read_lock_bh();
-	nht = rcu_dereference_bh(tbl->nht);
+	rcu_read_lock();
+	nht = rcu_dereference(tbl->nht);
 
-	read_lock(&tbl->lock); /* avoid resizes */
+	read_lock_bh(&tbl->lock); /* avoid resizes */
 	for (chain = 0; chain < (1 << nht->hash_shift); chain++) {
 		struct neighbour *n;
 
-		for (n = rcu_dereference_bh(nht->hash_buckets[chain]);
+		for (n = rcu_dereference(nht->hash_buckets[chain]);
 		     n != NULL;
-		     n = rcu_dereference_bh(n->next))
+		     n = rcu_dereference(n->next))
 			cb(n, cookie);
 	}
-	read_unlock(&tbl->lock);
-	rcu_read_unlock_bh();
+	read_unlock_bh(&tbl->lock);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(neigh_for_each);
 
@@ -3138,7 +3138,7 @@ int neigh_xmit(int index, struct net_device *dev,
 		tbl = neigh_tables[index];
 		if (!tbl)
 			goto out;
-		rcu_read_lock_bh();
+		rcu_read_lock();
 		if (index == NEIGH_ARP_TABLE) {
 			u32 key = *((u32 *)addr);
 
@@ -3150,11 +3150,11 @@ int neigh_xmit(int index, struct net_device *dev,
 			neigh = __neigh_create(tbl, addr, dev, false);
 		err = PTR_ERR(neigh);
 		if (IS_ERR(neigh)) {
-			rcu_read_unlock_bh();
+			rcu_read_unlock();
 			goto out_kfree_skb;
 		}
 		err = neigh->output(neigh, skb);
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 	}
 	else if (index == NEIGH_LINK_TABLE) {
 		err = dev_hard_header(skb, dev, ntohs(skb->protocol),
@@ -3183,7 +3183,7 @@ static struct neighbour *neigh_get_first(struct seq_file *seq)
 
 	state->flags &= ~NEIGH_SEQ_IS_PNEIGH;
 	for (bucket = 0; bucket < (1 << nht->hash_shift); bucket++) {
-		n = rcu_dereference_bh(nht->hash_buckets[bucket]);
+		n = rcu_dereference(nht->hash_buckets[bucket]);
 
 		while (n) {
 			if (!net_eq(dev_net(n->dev), net))
@@ -3201,7 +3201,7 @@ static struct neighbour *neigh_get_first(struct seq_file *seq)
 			if (READ_ONCE(n->nud_state) & ~NUD_NOARP)
 				break;
 next:
-			n = rcu_dereference_bh(n->next);
+			n = rcu_dereference(n->next);
 		}
 
 		if (n)
@@ -3225,7 +3225,7 @@ static struct neighbour *neigh_get_next(struct seq_file *seq,
 		if (v)
 			return n;
 	}
-	n = rcu_dereference_bh(n->next);
+	n = rcu_dereference(n->next);
 
 	while (1) {
 		while (n) {
@@ -3243,7 +3243,7 @@ static struct neighbour *neigh_get_next(struct seq_file *seq,
 			if (READ_ONCE(n->nud_state) & ~NUD_NOARP)
 				break;
 next:
-			n = rcu_dereference_bh(n->next);
+			n = rcu_dereference(n->next);
 		}
 
 		if (n)
@@ -3252,7 +3252,7 @@ static struct neighbour *neigh_get_next(struct seq_file *seq,
 		if (++state->bucket >= (1 << nht->hash_shift))
 			break;
 
-		n = rcu_dereference_bh(nht->hash_buckets[state->bucket]);
+		n = rcu_dereference(nht->hash_buckets[state->bucket]);
 	}
 
 	if (n && pos)
@@ -3354,7 +3354,7 @@ static void *neigh_get_idx_any(struct seq_file *seq, loff_t *pos)
 
 void *neigh_seq_start(struct seq_file *seq, loff_t *pos, struct neigh_table *tbl, unsigned int neigh_seq_flags)
 	__acquires(tbl->lock)
-	__acquires(rcu_bh)
+	__acquires(rcu)
 {
 	struct neigh_seq_state *state = seq->private;
 
@@ -3362,9 +3362,9 @@ void *neigh_seq_start(struct seq_file *seq, loff_t *pos, struct neigh_table *tbl
 	state->bucket = 0;
 	state->flags = (neigh_seq_flags & ~NEIGH_SEQ_IS_PNEIGH);
 
-	rcu_read_lock_bh();
-	state->nht = rcu_dereference_bh(tbl->nht);
-	read_lock(&tbl->lock);
+	rcu_read_lock();
+	state->nht = rcu_dereference(tbl->nht);
+	read_lock_bh(&tbl->lock);
 
 	return *pos ? neigh_get_idx_any(seq, pos) : SEQ_START_TOKEN;
 }
@@ -3399,13 +3399,13 @@ EXPORT_SYMBOL(neigh_seq_next);
 
 void neigh_seq_stop(struct seq_file *seq, void *v)
 	__releases(tbl->lock)
-	__releases(rcu_bh)
+	__releases(rcu)
 {
 	struct neigh_seq_state *state = seq->private;
 	struct neigh_table *tbl = state->tbl;
 
-	read_unlock(&tbl->lock);
-	rcu_read_unlock_bh();
+	read_unlock_bh(&tbl->lock);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(neigh_seq_stop);
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 574ff450c4d234f806b2cc96352800b3e2ce256d..65ba18a91865ae9a9bd850052811509b8fb3a79b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2191,7 +2191,7 @@ static bool fib_good_nh(const struct fib_nh *nh)
 	if (nh->fib_nh_scope == RT_SCOPE_LINK) {
 		struct neighbour *n;
 
-		rcu_read_lock_bh();
+		rcu_read_lock();
 
 		if (likely(nh->fib_nh_gw_family == AF_INET))
 			n = __ipv4_neigh_lookup_noref(nh->fib_nh_dev,
@@ -2204,7 +2204,7 @@ static bool fib_good_nh(const struct fib_nh *nh)
 		if (n)
 			state = READ_ONCE(n->nud_state);
 
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 	}
 
 	return !!(state & NUD_VALID);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index cb04dbad9ea474fcaa4b5ba31c4a37299c4e1a8d..22a90a9392ebb3f7cb4a28a2ea3a9bfecaf05633 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -219,7 +219,7 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 			return res;
 	}
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
 	if (!IS_ERR(neigh)) {
 		int res;
@@ -227,10 +227,10 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 		sock_confirm_neigh(skb, neigh);
 		/* if crossing protocols, can not use the cached header */
 		res = neigh_output(neigh, skb, is_v6gw);
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 		return res;
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	net_dbg_ratelimited("%s: No header cache and no neighbour!\n",
 			    __func__);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index e28a99f1996b74b72dc938a3a6239069a0925f94..f95142e56da057179bbccc48c65928abf28aef28 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1124,13 +1124,13 @@ static bool ipv6_good_nh(const struct fib6_nh *nh)
 	int state = NUD_REACHABLE;
 	struct neighbour *n;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 
 	n = __ipv6_neigh_lookup_noref_stub(nh->fib_nh_dev, &nh->fib_nh_gw6);
 	if (n)
 		state = READ_ONCE(n->nud_state);
 
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	return !!(state & NUD_VALID);
 }
@@ -1140,14 +1140,14 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	int state = NUD_REACHABLE;
 	struct neighbour *n;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 
 	n = __ipv4_neigh_lookup_noref(nh->fib_nh_dev,
 				      (__force u32)nh->fib_nh_gw4);
 	if (n)
 		state = READ_ONCE(n->nud_state);
 
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	return !!(state & NUD_VALID);
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 232009d216c4e34558077efe80371ecc6d0b532c..6a0a0bb452e9a412f63db99ad2736924cb320e30 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -408,7 +408,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 	struct net_device *dev = dst->dev;
 	struct neighbour *n;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 
 	if (likely(rt->rt_gw_family == AF_INET)) {
 		n = ip_neigh_gw4(dev, rt->rt_gw4);
@@ -424,7 +424,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 	if (!IS_ERR(n) && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
 
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	return n;
 }
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index faa47f9ea73a68cc6fd0b38bd6f78510f0558101..31e0097878c527dc3b29afa3ab8b376449284891 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1034,7 +1034,7 @@ static int ipv6_add_addr_hash(struct net_device *dev, struct inet6_ifaddr *ifa)
 	unsigned int hash = inet6_addr_hash(net, &ifa->addr);
 	int err = 0;
 
-	spin_lock(&net->ipv6.addrconf_hash_lock);
+	spin_lock_bh(&net->ipv6.addrconf_hash_lock);
 
 	/* Ignore adding duplicate addresses on an interface */
 	if (ipv6_chk_same_addr(net, &ifa->addr, dev, hash)) {
@@ -1044,7 +1044,7 @@ static int ipv6_add_addr_hash(struct net_device *dev, struct inet6_ifaddr *ifa)
 		hlist_add_head_rcu(&ifa->addr_lst, &net->ipv6.inet6_addr_lst[hash]);
 	}
 
-	spin_unlock(&net->ipv6.addrconf_hash_lock);
+	spin_unlock_bh(&net->ipv6.addrconf_hash_lock);
 
 	return err;
 }
@@ -1139,15 +1139,15 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	/* For caller */
 	refcount_set(&ifa->refcnt, 1);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 
 	err = ipv6_add_addr_hash(idev->dev, ifa);
 	if (err < 0) {
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 		goto out;
 	}
 
-	write_lock(&idev->lock);
+	write_lock_bh(&idev->lock);
 
 	/* Add to inet6_dev unicast addr list. */
 	ipv6_link_dev_addr(idev, ifa);
@@ -1158,9 +1158,9 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	}
 
 	in6_ifa_hold(ifa);
-	write_unlock(&idev->lock);
+	write_unlock_bh(&idev->lock);
 
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	inet6addr_notifier_call_chain(NETDEV_UP, ifa);
 out:
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e5ed39a3c65f83d211dabb3c02a1d44b116257ed..0b6140f0179dd9b77dfb26e094c4da61cb783c3f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -116,7 +116,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 			return res;
 	}
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	nexthop = rt6_nexthop((struct rt6_info *)dst, daddr);
 	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
 
@@ -124,7 +124,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 		if (unlikely(!neigh))
 			neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
 		if (IS_ERR(neigh)) {
-			rcu_read_unlock_bh();
+			rcu_read_unlock();
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
 			kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
 			return -EINVAL;
@@ -132,7 +132,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	}
 	sock_confirm_neigh(skb, neigh);
 	ret = neigh_output(neigh, skb, false);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1150,11 +1150,11 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 	 * dst entry of the nexthop router
 	 */
 	rt = (struct rt6_info *) *dst;
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	n = __ipv6_neigh_lookup_noref(rt->dst.dev,
 				      rt6_nexthop(rt, &fl6->daddr));
 	err = n && !(READ_ONCE(n->nud_state) & NUD_VALID) ? -EINVAL : 0;
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	if (err) {
 		struct inet6_ifaddr *ifp;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e829bd880384077027dc79fcae1a62eb0073f7c8..244df77fac8782e043e57fe45b7bb3c6c72b32c5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -633,7 +633,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 
 	nh_gw = &fib6_nh->fib_nh_gw6;
 	dev = fib6_nh->fib_nh_dev;
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	last_probe = READ_ONCE(fib6_nh->last_probe);
 	idev = __in6_dev_get(dev);
 	neigh = __ipv6_neigh_lookup_noref(dev, nh_gw);
@@ -641,7 +641,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 		if (READ_ONCE(neigh->nud_state) & NUD_VALID)
 			goto out;
 
-		write_lock(&neigh->lock);
+		write_lock_bh(&neigh->lock);
 		if (!(neigh->nud_state & NUD_VALID) &&
 		    time_after(jiffies,
 			       neigh->updated + idev->cnf.rtr_probe_interval)) {
@@ -649,7 +649,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 			if (work)
 				__neigh_set_probe_once(neigh);
 		}
-		write_unlock(&neigh->lock);
+		write_unlock_bh(&neigh->lock);
 	} else if (time_after(jiffies, last_probe +
 				       idev->cnf.rtr_probe_interval)) {
 		work = kmalloc(sizeof(*work), GFP_ATOMIC);
@@ -667,7 +667,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	}
 
 out:
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 }
 #else
 static inline void rt6_probe(struct fib6_nh *fib6_nh)
@@ -683,7 +683,7 @@ static enum rt6_nud_state rt6_check_neigh(const struct fib6_nh *fib6_nh)
 	enum rt6_nud_state ret = RT6_NUD_FAIL_HARD;
 	struct neighbour *neigh;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	neigh = __ipv6_neigh_lookup_noref(fib6_nh->fib_nh_dev,
 					  &fib6_nh->fib_nh_gw6);
 	if (neigh) {
@@ -701,7 +701,7 @@ static enum rt6_nud_state rt6_check_neigh(const struct fib6_nh *fib6_nh)
 		ret = IS_ENABLED(CONFIG_IPV6_ROUTER_PREF) ?
 		      RT6_NUD_SUCCEED : RT6_NUD_FAIL_DO_RR;
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	return ret;
 }
-- 
2.40.0.rc2.332.ga46443480c-goog

