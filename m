Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0976C12EB64
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 22:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgABV25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 16:28:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:36636 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgABV25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 16:28:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68B71AEAC;
        Thu,  2 Jan 2020 21:28:54 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 19072E0095; Thu,  2 Jan 2020 22:28:54 +0100 (CET)
In-Reply-To: <CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com>
References: <CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH stable-4.9] tcp/dccp: fix possible race
 __inet_lookup_established()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Firo Yang <firo.yang@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        lkft-triage@lists.linaro.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Message-Id: <20200102212854.19072E0095@unicorn.suse.cz>
Date:   Thu,  2 Jan 2020 22:28:54 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8dbd76e79a16b45b2ccb01d2f2e08dbf64e71e40 ]

Michal Kubecek and Firo Yang did a very nice analysis of crashes
happening in __inet_lookup_established().

Since a TCP socket can go from TCP_ESTABLISH to TCP_LISTEN
(via a close()/socket()/listen() cycle) without a RCU grace period,
I should not have changed listeners linkage in their hash table.

They must use the nulls protocol (Documentation/RCU/rculist_nulls.txt),
so that a lookup can detect a socket in a hash list was moved in
another one.

Since we added code in commit d296ba60d8e2 ("soreuseport: Resolve
merge conflict for v4/v6 ordering fix"), we have to add
hlist_nulls_add_tail_rcu() helper.

stable-4.9: we also need to update code in __inet_lookup_listener() and
inet6_lookup_listener() which has been removed in 5.0-rc1.

Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under synflood")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Reported-by: Firo Yang <firo.yang@suse.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Link: https://lore.kernel.org/netdev/20191120083919.GH27852@unicorn.suse.cz/
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/rculist_nulls.h | 37 +++++++++++++++++++++++++++++++++++
 include/net/inet_hashtables.h | 12 +++++++++---
 include/net/sock.h            |  5 +++++
 net/ipv4/inet_diag.c          |  3 ++-
 net/ipv4/inet_hashtables.c    | 18 ++++++++---------
 net/ipv4/tcp_ipv4.c           |  7 ++++---
 net/ipv6/inet6_hashtables.c   |  3 ++-
 7 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 2720b2fbfb86..106f4e0d7bd3 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -99,6 +99,43 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 		first->pprev = &n->next;
 }
 
+/**
+ * hlist_nulls_add_tail_rcu
+ * @n: the element to add to the hash list.
+ * @h: the list to add to.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist_nulls,
+ * while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_nulls_add_head_rcu()
+ * or hlist_nulls_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_nulls_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_nulls_add_tail_rcu(struct hlist_nulls_node *n,
+					    struct hlist_nulls_head *h)
+{
+	struct hlist_nulls_node *i, *last = NULL;
+
+	/* Note: write side code, so rcu accessors are not needed. */
+	for (i = h->first; !is_a_nulls(i); i = i->next)
+		last = i;
+
+	if (last) {
+		n->next = last->next;
+		n->pprev = &last->next;
+		rcu_assign_pointer(hlist_next_rcu(last), n);
+	} else {
+		hlist_nulls_add_head_rcu(n, h);
+	}
+}
+
 /**
  * hlist_nulls_for_each_entry_rcu - iterate over rcu list of given type
  * @tpos:	the type * to use as a loop cursor.
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 0574493e3899..fc445e7ccadf 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -98,12 +98,18 @@ struct inet_bind_hashbucket {
 	struct hlist_head	chain;
 };
 
-/*
- * Sockets can be hashed in established or listening table
+/* Sockets can be hashed in established or listening table.
+ * We must use different 'nulls' end-of-chain value for all hash buckets :
+ * A socket might transition from ESTABLISH to LISTEN state without
+ * RCU grace period. A lookup in ehash table needs to handle this case.
  */
+#define LISTENING_NULLS_BASE (1U << 29)
 struct inet_listen_hashbucket {
 	spinlock_t		lock;
-	struct hlist_head	head;
+	union {
+		struct hlist_head	head;
+		struct hlist_nulls_head	nulls_head;
+	};
 };
 
 /* This is for listening sockets, thus all sockets which possess wildcards. */
diff --git a/include/net/sock.h b/include/net/sock.h
index aed436567d70..d6bce19ca261 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -661,6 +661,11 @@ static inline void __sk_nulls_add_node_rcu(struct sock *sk, struct hlist_nulls_h
 	hlist_nulls_add_head_rcu(&sk->sk_nulls_node, list);
 }
 
+static inline void __sk_nulls_add_node_tail_rcu(struct sock *sk, struct hlist_nulls_head *list)
+{
+	hlist_nulls_add_tail_rcu(&sk->sk_nulls_node, list);
+}
+
 static inline void sk_nulls_add_node_rcu(struct sock *sk, struct hlist_nulls_head *list)
 {
 	sock_hold(sk);
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index e4d16fc5bbb3..4273576e1475 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -868,12 +868,13 @@ void inet_diag_dump_icsk(struct inet_hashinfo *hashinfo, struct sk_buff *skb,
 
 		for (i = s_i; i < INET_LHTABLE_SIZE; i++) {
 			struct inet_listen_hashbucket *ilb;
+			struct hlist_nulls_node *node;
 			struct sock *sk;
 
 			num = 0;
 			ilb = &hashinfo->listening_hash[i];
 			spin_lock_bh(&ilb->lock);
-			sk_for_each(sk, &ilb->head) {
+			sk_nulls_for_each(sk, node, &ilb->nulls_head) {
 				struct inet_sock *inet = inet_sk(sk);
 
 				if (!net_eq(sock_net(sk), net))
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index b9bcf3db3af9..4bf542f4d980 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -218,9 +218,10 @@ struct sock *__inet_lookup_listener(struct net *net,
 	int score, hiscore = 0, matches = 0, reuseport = 0;
 	bool exact_dif = inet_exact_dif_match(net, skb);
 	struct sock *sk, *result = NULL;
+	struct hlist_nulls_node *node;
 	u32 phash = 0;
 
-	sk_for_each_rcu(sk, &ilb->head) {
+	sk_nulls_for_each_rcu(sk, node, &ilb->nulls_head) {
 		score = compute_score(sk, net, hnum, daddr, dif, exact_dif);
 		if (score > hiscore) {
 			reuseport = sk->sk_reuseport;
@@ -441,10 +442,11 @@ static int inet_reuseport_add_sock(struct sock *sk,
 						     bool match_wildcard))
 {
 	struct inet_bind_bucket *tb = inet_csk(sk)->icsk_bind_hash;
+	const struct hlist_nulls_node *node;
 	struct sock *sk2;
 	kuid_t uid = sock_i_uid(sk);
 
-	sk_for_each_rcu(sk2, &ilb->head) {
+	sk_nulls_for_each_rcu(sk2, node, &ilb->nulls_head) {
 		if (sk2 != sk &&
 		    sk2->sk_family == sk->sk_family &&
 		    ipv6_only_sock(sk2) == ipv6_only_sock(sk) &&
@@ -482,9 +484,9 @@ int __inet_hash(struct sock *sk, struct sock *osk,
 	}
 	if (IS_ENABLED(CONFIG_IPV6) && sk->sk_reuseport &&
 		sk->sk_family == AF_INET6)
-		hlist_add_tail_rcu(&sk->sk_node, &ilb->head);
+		__sk_nulls_add_node_tail_rcu(sk, &ilb->nulls_head);
 	else
-		hlist_add_head_rcu(&sk->sk_node, &ilb->head);
+		__sk_nulls_add_node_rcu(sk, &ilb->nulls_head);
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 unlock:
@@ -527,10 +529,7 @@ void inet_unhash(struct sock *sk)
 	spin_lock_bh(lock);
 	if (rcu_access_pointer(sk->sk_reuseport_cb))
 		reuseport_detach_sock(sk);
-	if (listener)
-		done = __sk_del_node_init(sk);
-	else
-		done = __sk_nulls_del_node_init_rcu(sk);
+	done = __sk_nulls_del_node_init_rcu(sk);
 	if (done)
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	spin_unlock_bh(lock);
@@ -666,7 +665,8 @@ void inet_hashinfo_init(struct inet_hashinfo *h)
 
 	for (i = 0; i < INET_LHTABLE_SIZE; i++) {
 		spin_lock_init(&h->listening_hash[i].lock);
-		INIT_HLIST_HEAD(&h->listening_hash[i].head);
+		INIT_HLIST_NULLS_HEAD(&h->listening_hash[i].nulls_head,
+				      i + LISTENING_NULLS_BASE);
 	}
 }
 EXPORT_SYMBOL_GPL(inet_hashinfo_init);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index cced424e1176..e1cf810140b0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1917,13 +1917,14 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 	struct tcp_iter_state *st = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct inet_listen_hashbucket *ilb;
+	struct hlist_nulls_node *node;
 	struct sock *sk = cur;
 
 	if (!sk) {
 get_head:
 		ilb = &tcp_hashinfo.listening_hash[st->bucket];
 		spin_lock_bh(&ilb->lock);
-		sk = sk_head(&ilb->head);
+		sk = sk_nulls_head(&ilb->nulls_head);
 		st->offset = 0;
 		goto get_sk;
 	}
@@ -1931,9 +1932,9 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 	++st->num;
 	++st->offset;
 
-	sk = sk_next(sk);
+	sk = sk_nulls_next(sk);
 get_sk:
-	sk_for_each_from(sk) {
+	sk_nulls_for_each_from(sk, node) {
 		if (!net_eq(sock_net(sk), net))
 			continue;
 		if (sk->sk_family == st->family)
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 02761c9fe43e..d47cab6d7c6d 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -133,9 +133,10 @@ struct sock *inet6_lookup_listener(struct net *net,
 	int score, hiscore = 0, matches = 0, reuseport = 0;
 	bool exact_dif = inet6_exact_dif_match(net, skb);
 	struct sock *sk, *result = NULL;
+	struct hlist_nulls_node *node;
 	u32 phash = 0;
 
-	sk_for_each(sk, &ilb->head) {
+	sk_nulls_for_each(sk, node, &ilb->nulls_head) {
 		score = compute_score(sk, net, hnum, daddr, dif, exact_dif);
 		if (score > hiscore) {
 			reuseport = sk->sk_reuseport;
-- 
2.24.1

