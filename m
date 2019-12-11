Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A3411B9AB
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbfLKRJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:09:48 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:41850 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730812AbfLKRJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:09:48 -0500
Received: by mail-pf1-f201.google.com with SMTP id x6so2467166pfx.8
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TzHKHevXeSDGKyCcjKY8dknPYY2WiS6q5wvYmQPrNec=;
        b=EtHUOFRUj1XOy3qnysaFD0rGWcyYDvteyGOxvI8/LfF4K0Gip24hSlvHL9rJNTvF9B
         +oL1kGTgMpol2scsmlmgUY/rd066fMPCo1GW+bZ16ixRRLd8cUhKfBtfGi6CozC9RQnf
         Qu4ysemllkVBKZwLkQyiyqxhJNVVWdN6iI++U/7AbRcAvlKDNmLvXKhbZJ+CTWKmyHDy
         yMsZOkkQeDKlNS1RqnK3NjfC12QYOhA+BeQS7u9wrdl8o+CsNLKxfGP0r6OIFOgOai4S
         Ip9Ea0EUiww0K8U1RtUhviiD1BCJncm5HBRbX4ga5Lrt6CSRPM7UeBLU4s9qGVjr6qr4
         jI/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TzHKHevXeSDGKyCcjKY8dknPYY2WiS6q5wvYmQPrNec=;
        b=LboPkwDWx/e1UH6ZyA0LOFa6dsxCqs+gyGLLbtIZPGqAdeJXFVQTajT92kVw8z1EBl
         9FxQw3mJczBKpIL0aTG9W0lerGTz1sUS7UXgwfKPVtxfEzQzg9OeMOxcLOgX78ynocpN
         qwI+0AZv1txzAiiWcwD3emg7INmCFfO59WLFYROsCqbeiQZG8wznYEcCsr29M/ASDoNp
         AH62AYA+JG1IfdoCqZWbQ1k69EQMbVuAxXI1zXwaAYiwNSC1MQbZJ7xv/tl+MwtdQNt8
         2eBrMIKO6Z9A9g/Xlg8yVZkOB9u5JlZh26GrRWk5Pz006S9D4YbVGdIqw21UnSbMBGTX
         HUVg==
X-Gm-Message-State: APjAAAUSXWtF/VLBz1VBdwzTiH7eLTvI+5CCT3WUxIYlbhmMrctUroXc
        e7BzegLVIkkcv7RJyaO3A2E8Tl0D+GO/mA==
X-Google-Smtp-Source: APXvYqwaF7tsFuMIGSBxXIjahMJrZDWqsOIlkp8e0YuqgcMCdOzq71/MR1cBNOCPk1I4LvSkioDjUjLdnwCnMw==
X-Received: by 2002:a65:66c8:: with SMTP id c8mr5471476pgw.161.1576084187488;
 Wed, 11 Dec 2019 09:09:47 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:09:43 -0800
Message-Id: <20191211170943.134769-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH net] tcp/dccp: fix possible race __inet_lookup_established()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Firo Yang <firo.yang@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under synflood")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Reported-by: Firo Yang <firo.yang@suse.com>
Link: https://lore.kernel.org/netdev/20191120083919.GH27852@unicorn.suse.cz/
---
 include/linux/rculist_nulls.h | 37 +++++++++++++++++++++++++++++++++++
 include/net/inet_hashtables.h | 11 +++++++++--
 include/net/sock.h            |  5 +++++
 net/ipv4/inet_diag.c          |  3 ++-
 net/ipv4/inet_hashtables.c    | 16 +++++++--------
 net/ipv4/tcp_ipv4.c           |  7 ++++---
 6 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index bc8206a8f30e6b0c2172e3bc3da3a85cab536cdd..61974c4c566be44af05531ce5b53040d586153a0 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -100,6 +100,43 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
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
index af2b4c065a042e36135fe6fdcee9833b6b353364..29ef5b7f4005a8e67fd358c136ee6532974efcab 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -105,11 +105,18 @@ struct inet_bind_hashbucket {
 
 /*
  * Sockets can be hashed in established or listening table
- */
+ * We must use different 'nulls' end-of-chain value for listening
+ * hash table, or we might find a socket that was closed and
+ * reallocated/inserted into established hash table
+  */
+#define LISTENING_NULLS_BASE (1U << 29)
 struct inet_listen_hashbucket {
 	spinlock_t		lock;
 	unsigned int		count;
-	struct hlist_head	head;
+	union {
+		struct hlist_head	head;
+		struct hlist_nulls_head	nulls_head;
+	};
 };
 
 /* This is for listening sockets, thus all sockets which possess wildcards. */
diff --git a/include/net/sock.h b/include/net/sock.h
index 87d54ef57f0040fd7bbd4344db0d3af7e6f6d992..04c274a20620b8d6a9d2118060ef0090f768bd60 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -722,6 +722,11 @@ static inline void __sk_nulls_add_node_rcu(struct sock *sk, struct hlist_nulls_h
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
index af154977904c0c249e77e425990a09c62cca4251..f11e997e517b6652479acd892ffea6cdeb940e33 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -911,11 +911,12 @@ void inet_diag_dump_icsk(struct inet_hashinfo *hashinfo, struct sk_buff *skb,
 
 		for (i = s_i; i < INET_LHTABLE_SIZE; i++) {
 			struct inet_listen_hashbucket *ilb;
+			struct hlist_nulls_node *node;
 
 			num = 0;
 			ilb = &hashinfo->listening_hash[i];
 			spin_lock(&ilb->lock);
-			sk_for_each(sk, &ilb->head) {
+			sk_nulls_for_each(sk, node, &ilb->nulls_head) {
 				struct inet_sock *inet = inet_sk(sk);
 
 				if (!net_eq(sock_net(sk), net))
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 83fb00153018f16678e71695134f7ae4d30ee0a3..2bbaaf0c717634502aa64098d1f4581b3eb1207d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -516,10 +516,11 @@ static int inet_reuseport_add_sock(struct sock *sk,
 				   struct inet_listen_hashbucket *ilb)
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
@@ -555,9 +556,9 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	}
 	if (IS_ENABLED(CONFIG_IPV6) && sk->sk_reuseport &&
 		sk->sk_family == AF_INET6)
-		hlist_add_tail_rcu(&sk->sk_node, &ilb->head);
+		__sk_nulls_add_node_tail_rcu(sk, &ilb->nulls_head);
 	else
-		hlist_add_head_rcu(&sk->sk_node, &ilb->head);
+		__sk_nulls_add_node_rcu(sk, &ilb->nulls_head);
 	inet_hash2(hashinfo, sk);
 	ilb->count++;
 	sock_set_flag(sk, SOCK_RCU_FREE);
@@ -606,11 +607,9 @@ void inet_unhash(struct sock *sk)
 		reuseport_detach_sock(sk);
 	if (ilb) {
 		inet_unhash2(hashinfo, sk);
-		 __sk_del_node_init(sk);
-		 ilb->count--;
-	} else {
-		__sk_nulls_del_node_init_rcu(sk);
+		ilb->count--;
 	}
+	__sk_nulls_del_node_init_rcu(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 unlock:
 	spin_unlock_bh(lock);
@@ -750,7 +749,8 @@ void inet_hashinfo_init(struct inet_hashinfo *h)
 
 	for (i = 0; i < INET_LHTABLE_SIZE; i++) {
 		spin_lock_init(&h->listening_hash[i].lock);
-		INIT_HLIST_HEAD(&h->listening_hash[i].head);
+		INIT_HLIST_NULLS_HEAD(&h->listening_hash[i].nulls_head,
+				      i + LISTENING_NULLS_BASE);
 		h->listening_hash[i].count = 0;
 	}
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 92282f98dc82290bfaf53acc050182e4cc3be1eb..1c7326e04f9bee463500e17ea7c6eb840a31d89f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2147,13 +2147,14 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 	struct tcp_iter_state *st = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct inet_listen_hashbucket *ilb;
+	struct hlist_nulls_node *node;
 	struct sock *sk = cur;
 
 	if (!sk) {
 get_head:
 		ilb = &tcp_hashinfo.listening_hash[st->bucket];
 		spin_lock(&ilb->lock);
-		sk = sk_head(&ilb->head);
+		sk = sk_nulls_head(&ilb->nulls_head);
 		st->offset = 0;
 		goto get_sk;
 	}
@@ -2161,9 +2162,9 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 	++st->num;
 	++st->offset;
 
-	sk = sk_next(sk);
+	sk = sk_nulls_next(sk);
 get_sk:
-	sk_for_each_from(sk) {
+	sk_nulls_for_each_from(sk, node) {
 		if (!net_eq(sock_net(sk), net))
 			continue;
 		if (sk->sk_family == afinfo->family)
-- 
2.24.0.525.g8f36a354ae-goog

