Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5911552415D
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349549AbiELAGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349559AbiELAGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:06:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFA822BCB
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:13 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24BMwkCm018306
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TSLukTM+2LcD6hx2Xds1wAKOpnsPm27FJ7/OEdBpWXs=;
 b=BA0EuI6h0ooGcF0HXLJjp19nhzLMBSDEAyXXAZAK3Rq2YTshpV2MNpbXqbyP0h7suoZK
 Kg9KOnQ1ZhERsMOu7MZ+wImab0CVOR7Uvu8oihSQTJ4h3fRnw3wNZ0tKGIK23sSox32W
 QQ4hvbjj4SsFojxvbfc7iq9xH1pMBc4z98Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fyx1h9n53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:13 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 17:06:11 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 6AF4F4AD24AA; Wed, 11 May 2022 17:06:05 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 3/4] net: inet: Retire port only listening_hash
Date:   Wed, 11 May 2022 17:06:05 -0700
Message-ID: <20220512000605.190838-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220512000546.188616-1-kafai@fb.com>
References: <20220512000546.188616-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 71-QKqx1h36qTNoSrXEi0p9p5_ZwNYcp
X-Proofpoint-ORIG-GUID: 71-QKqx1h36qTNoSrXEi0p9p5_ZwNYcp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The listen sk is currently stored in two hash tables,
listening_hash (hashed by port) and lhash2 (hashed by port and address).

After commit 0ee58dad5b06 ("net: tcp6: prefer listeners bound to an addre=
ss")
and commit d9fbc7f6431f ("net: tcp: prefer listeners bound to an address"=
),
the TCP-SYN lookup fast path does not use listening_hash.

The commit 05c0b35709c5 ("tcp: seq_file: Replace listening_hash with lhas=
h2")
also moved the seq_file (/proc/net/tcp) iteration usage from
listening_hash to lhash2.

There are still a few listening_hash usages left.
One of them is inet_reuseport_add_sock() which uses the listening_hash
to search a listen sk during the listen() system call.  This turns
out to be very slow on use cases that listen on many different
VIPs at a popular port (e.g. 443).  [ On top of the slowness in
adding to the tail in the IPv6 case ].  The latter patch has a
selftest to demonstrate this case.

This patch takes this chance to move all remaining listening_hash
usages to lhash2 and then retire listening_hash.

Since most changes need to be done together, it is hard to cut
the listening_hash to lhash2 switch into small patches.  The
changes in this patch is highlighted here for the review
purpose.

1. Because of the listening_hash removal, lhash2 can use the
   sk->sk_nulls_node instead of the icsk->icsk_listen_portaddr_node.
   This will also keep the sk_unhashed() check to work as is
   after stop adding sk to listening_hash.

   The union is removed from inet_listen_hashbucket because
   only nulls_head is needed.

2. icsk->icsk_listen_portaddr_node and its helpers are removed.

3. The current lhash2 users needs to iterate with sk_nulls_node
   instead of icsk_listen_portaddr_node.

   One case is in the inet[6]_lhash2_lookup().

   Another case is the seq_file iterator in tcp_ipv4.c.
   One thing to note is sk_nulls_next() is needed
   because the old inet_lhash2_for_each_icsk_continue()
   does a "next" first before iterating.

4. Move the remaining listening_hash usage to lhash2

   inet_reuseport_add_sock() which this series is
   trying to improve.

   inet_diag.c and mptcp_diag.c are the final two
   remaining use cases and is moved to lhash2 now also.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/inet_connection_sock.h |  2 --
 include/net/inet_hashtables.h      | 41 +-------------------------
 net/dccp/proto.c                   |  1 -
 net/ipv4/inet_diag.c               |  5 ++--
 net/ipv4/inet_hashtables.c         | 47 ++++++------------------------
 net/ipv4/tcp.c                     |  1 -
 net/ipv4/tcp_ipv4.c                | 21 ++++++-------
 net/ipv6/inet6_hashtables.c        |  5 ++--
 net/mptcp/mptcp_diag.c             |  4 +--
 9 files changed, 26 insertions(+), 101 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connec=
tion_sock.h
index 3908296d103f..85cd695e7fd1 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -66,7 +66,6 @@ struct inet_connection_sock_af_ops {
  * @icsk_ulp_ops	   Pluggable ULP control hook
  * @icsk_ulp_data	   ULP private data
  * @icsk_clean_acked	   Clean acked data hook
- * @icsk_listen_portaddr_node	hash to the portaddr listener hashtable
  * @icsk_ca_state:	   Congestion control state
  * @icsk_retransmits:	   Number of unrecovered [RTO] timeouts
  * @icsk_pending:	   Scheduled timer event
@@ -96,7 +95,6 @@ struct inet_connection_sock {
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
 	void __rcu		  *icsk_ulp_data;
 	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
-	struct hlist_node         icsk_listen_portaddr_node;
 	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
 	__u8			  icsk_ca_state:5,
 				  icsk_ca_initialized:1,
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.=
h
index 103fc7a30e60..1b8706719d4f 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -111,10 +111,7 @@ struct inet_bind_hashbucket {
 #define LISTENING_NULLS_BASE (1U << 29)
 struct inet_listen_hashbucket {
 	spinlock_t		lock;
-	union {
-		struct hlist_head	head;
-		struct hlist_nulls_head	nulls_head;
-	};
+	struct hlist_nulls_head	nulls_head;
 };
=20
 /* This is for listening sockets, thus all sockets which possess wildcar=
ds. */
@@ -142,32 +139,8 @@ struct inet_hashinfo {
 	/* The 2nd listener table hashed by local port and address */
 	unsigned int			lhash2_mask;
 	struct inet_listen_hashbucket	*lhash2;
-
-	/* All the above members are written once at bootup and
-	 * never written again _or_ are predominantly read-access.
-	 *
-	 * Now align to a new cache line as all the following members
-	 * might be often dirty.
-	 */
-	/* All sockets in TCP_LISTEN state will be in listening_hash.
-	 * This is the only table where wildcard'd TCP sockets can
-	 * exist.  listening_hash is only hashed by local port number.
-	 * If lhash2 is initialized, the same socket will also be hashed
-	 * to lhash2 by port and address.
-	 */
-	struct inet_listen_hashbucket	listening_hash[INET_LHTABLE_SIZE]
-					____cacheline_aligned_in_smp;
 };
=20
-#define inet_lhash2_for_each_icsk_continue(__icsk) \
-	hlist_for_each_entry_continue(__icsk, icsk_listen_portaddr_node)
-
-#define inet_lhash2_for_each_icsk(__icsk, list) \
-	hlist_for_each_entry(__icsk, list, icsk_listen_portaddr_node)
-
-#define inet_lhash2_for_each_icsk_rcu(__icsk, list) \
-	hlist_for_each_entry_rcu(__icsk, list, icsk_listen_portaddr_node)
-
 static inline struct inet_listen_hashbucket *
 inet_lhash2_bucket(struct inet_hashinfo *h, u32 hash)
 {
@@ -229,23 +202,11 @@ static inline u32 inet_bhashfn(const struct net *ne=
t, const __u16 lport,
 void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
 		    const unsigned short snum);
=20
-/* These can have wildcards, don't try too hard. */
-static inline u32 inet_lhashfn(const struct net *net, const unsigned sho=
rt num)
-{
-	return (num + net_hash_mix(net)) & (INET_LHTABLE_SIZE - 1);
-}
-
-static inline int inet_sk_listen_hashfn(const struct sock *sk)
-{
-	return inet_lhashfn(sock_net(sk), inet_sk(sk)->inet_num);
-}
-
 /* Caller must disable local BH processing. */
 int __inet_inherit_port(const struct sock *sk, struct sock *child);
=20
 void inet_put_port(struct sock *sk);
=20
-void inet_hashinfo_init(struct inet_hashinfo *h);
 void inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 			 unsigned long numentries, int scale,
 			 unsigned long low_limit,
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 58421f94427e..eb8e128e43e8 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1110,7 +1110,6 @@ static int __init dccp_init(void)
=20
 	BUILD_BUG_ON(sizeof(struct dccp_skb_cb) >
 		     sizeof_field(struct sk_buff, cb));
-	inet_hashinfo_init(&dccp_hashinfo);
 	rc =3D inet_hashinfo2_init_mod(&dccp_hashinfo);
 	if (rc)
 		goto out_fail;
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 581b5b2d72a5..b812eb36f0e3 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -1028,12 +1028,13 @@ void inet_diag_dump_icsk(struct inet_hashinfo *ha=
shinfo, struct sk_buff *skb,
 		if (!(idiag_states & TCPF_LISTEN) || r->id.idiag_dport)
 			goto skip_listen_ht;
=20
-		for (i =3D s_i; i < INET_LHTABLE_SIZE; i++) {
+		for (i =3D s_i; i <=3D hashinfo->lhash2_mask; i++) {
 			struct inet_listen_hashbucket *ilb;
 			struct hlist_nulls_node *node;
=20
 			num =3D 0;
-			ilb =3D &hashinfo->listening_hash[i];
+			ilb =3D &hashinfo->lhash2[i];
+
 			spin_lock(&ilb->lock);
 			sk_nulls_for_each(sk, node, &ilb->nulls_head) {
 				struct inet_sock *inet =3D inet_sk(sk);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 4b00fcb9088d..0b8235fbd440 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -246,12 +246,11 @@ static struct sock *inet_lhash2_lookup(struct net *=
net,
 				const __be32 daddr, const unsigned short hnum,
 				const int dif, const int sdif)
 {
-	struct inet_connection_sock *icsk;
 	struct sock *sk, *result =3D NULL;
+	struct hlist_nulls_node *node;
 	int score, hiscore =3D 0;
=20
-	inet_lhash2_for_each_icsk_rcu(icsk, &ilb2->head) {
-		sk =3D (struct sock *)icsk;
+	sk_nulls_for_each_rcu(sk, node, &ilb2->nulls_head) {
 		score =3D compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
 			result =3D lookup_reuseport(net, sk, skb, doff,
@@ -598,7 +597,6 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 {
 	struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
 	struct inet_listen_hashbucket *ilb2;
-	struct inet_listen_hashbucket *ilb;
 	int err =3D 0;
=20
 	if (sk->sk_state !=3D TCP_LISTEN) {
@@ -608,31 +606,23 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
-	ilb =3D &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
 	ilb2 =3D inet_lhash2_bucket_sk(hashinfo, sk);
=20
-	spin_lock(&ilb->lock);
 	spin_lock(&ilb2->lock);
 	if (sk->sk_reuseport) {
-		err =3D inet_reuseport_add_sock(sk, ilb);
+		err =3D inet_reuseport_add_sock(sk, ilb2);
 		if (err)
 			goto unlock;
 	}
 	if (IS_ENABLED(CONFIG_IPV6) && sk->sk_reuseport &&
-		sk->sk_family =3D=3D AF_INET6) {
-		hlist_add_tail_rcu(&inet_csk(sk)->icsk_listen_portaddr_node,
-				   &ilb2->head);
-		__sk_nulls_add_node_tail_rcu(sk, &ilb->nulls_head);
-	} else {
-		hlist_add_head_rcu(&inet_csk(sk)->icsk_listen_portaddr_node,
-				   &ilb2->head);
-		__sk_nulls_add_node_rcu(sk, &ilb->nulls_head);
-	}
+		sk->sk_family =3D=3D AF_INET6)
+		__sk_nulls_add_node_tail_rcu(sk, &ilb2->nulls_head);
+	else
+		__sk_nulls_add_node_rcu(sk, &ilb2->nulls_head);
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 unlock:
 	spin_unlock(&ilb2->lock);
-	spin_unlock(&ilb->lock);
=20
 	return err;
 }
@@ -658,29 +648,23 @@ void inet_unhash(struct sock *sk)
=20
 	if (sk->sk_state =3D=3D TCP_LISTEN) {
 		struct inet_listen_hashbucket *ilb2;
-		struct inet_listen_hashbucket *ilb;
=20
-		ilb =3D &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
 		ilb2 =3D inet_lhash2_bucket_sk(hashinfo, sk);
 		/* Don't disable bottom halves while acquiring the lock to
 		 * avoid circular locking dependency on PREEMPT_RT.
 		 */
-		spin_lock(&ilb->lock);
 		spin_lock(&ilb2->lock);
 		if (sk_unhashed(sk)) {
 			spin_unlock(&ilb2->lock);
-			spin_unlock(&ilb->lock);
 			return;
 		}
=20
 		if (rcu_access_pointer(sk->sk_reuseport_cb))
 			reuseport_stop_listen_sock(sk);
=20
-		hlist_del_init_rcu(&inet_csk(sk)->icsk_listen_portaddr_node);
 		__sk_nulls_del_node_init_rcu(sk);
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 		spin_unlock(&ilb2->lock);
-		spin_unlock(&ilb->lock);
 	} else {
 		spinlock_t *lock =3D inet_ehash_lockp(hashinfo, sk->sk_hash);
=20
@@ -848,27 +832,14 @@ int inet_hash_connect(struct inet_timewait_death_ro=
w *death_row,
 }
 EXPORT_SYMBOL_GPL(inet_hash_connect);
=20
-void inet_hashinfo_init(struct inet_hashinfo *h)
-{
-	int i;
-
-	for (i =3D 0; i < INET_LHTABLE_SIZE; i++) {
-		spin_lock_init(&h->listening_hash[i].lock);
-		INIT_HLIST_NULLS_HEAD(&h->listening_hash[i].nulls_head,
-				      i + LISTENING_NULLS_BASE);
-	}
-
-	h->lhash2 =3D NULL;
-}
-EXPORT_SYMBOL_GPL(inet_hashinfo_init);
-
 static void init_hashinfo_lhash2(struct inet_hashinfo *h)
 {
 	int i;
=20
 	for (i =3D 0; i <=3D h->lhash2_mask; i++) {
 		spin_lock_init(&h->lhash2[i].lock);
-		INIT_HLIST_HEAD(&h->lhash2[i].head);
+		INIT_HLIST_NULLS_HEAD(&h->lhash2[i].nulls_head,
+				      i + LISTENING_NULLS_BASE);
 	}
 }
=20
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b44fde435bd1..028513d3e2a2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4595,7 +4595,6 @@ void __init tcp_init(void)
 	timer_setup(&tcp_orphan_timer, tcp_orphan_update, TIMER_DEFERRABLE);
 	mod_timer(&tcp_orphan_timer, jiffies + TCP_ORPHAN_TIMER_PERIOD);
=20
-	inet_hashinfo_init(&tcp_hashinfo);
 	inet_hashinfo2_init(&tcp_hashinfo, "tcp_listen_portaddr_hash",
 			    thash_entries, 21,  /* one slot per 2 MB*/
 			    0, 64 * 1024);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 918816ec5dd4..218ad871c0e4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2283,16 +2283,15 @@ static void *listening_get_first(struct seq_file =
*seq)
 	st->offset =3D 0;
 	for (; st->bucket <=3D tcp_hashinfo.lhash2_mask; st->bucket++) {
 		struct inet_listen_hashbucket *ilb2;
-		struct inet_connection_sock *icsk;
+		struct hlist_nulls_node *node;
 		struct sock *sk;
=20
 		ilb2 =3D &tcp_hashinfo.lhash2[st->bucket];
-		if (hlist_empty(&ilb2->head))
+		if (hlist_nulls_empty(&ilb2->nulls_head))
 			continue;
=20
 		spin_lock(&ilb2->lock);
-		inet_lhash2_for_each_icsk(icsk, &ilb2->head) {
-			sk =3D (struct sock *)icsk;
+		sk_nulls_for_each(sk, node, &ilb2->nulls_head) {
 			if (seq_sk_match(seq, sk))
 				return sk;
 		}
@@ -2311,15 +2310,14 @@ static void *listening_get_next(struct seq_file *=
seq, void *cur)
 {
 	struct tcp_iter_state *st =3D seq->private;
 	struct inet_listen_hashbucket *ilb2;
-	struct inet_connection_sock *icsk;
+	struct hlist_nulls_node *node;
 	struct sock *sk =3D cur;
=20
 	++st->num;
 	++st->offset;
=20
-	icsk =3D inet_csk(sk);
-	inet_lhash2_for_each_icsk_continue(icsk) {
-		sk =3D (struct sock *)icsk;
+	sk =3D sk_nulls_next(sk);
+	sk_nulls_for_each_from(sk, node) {
 		if (seq_sk_match(seq, sk))
 			return sk;
 	}
@@ -2728,16 +2726,15 @@ static unsigned int bpf_iter_tcp_listening_batch(=
struct seq_file *seq,
 {
 	struct bpf_tcp_iter_state *iter =3D seq->private;
 	struct tcp_iter_state *st =3D &iter->state;
-	struct inet_connection_sock *icsk;
+	struct hlist_nulls_node *node;
 	unsigned int expected =3D 1;
 	struct sock *sk;
=20
 	sock_hold(start_sk);
 	iter->batch[iter->end_sk++] =3D start_sk;
=20
-	icsk =3D inet_csk(start_sk);
-	inet_lhash2_for_each_icsk_continue(icsk) {
-		sk =3D (struct sock *)icsk;
+	sk =3D sk_nulls_next(start_sk);
+	sk_nulls_for_each_from(sk, node) {
 		if (seq_sk_match(seq, sk)) {
 			if (iter->end_sk < iter->max_sk) {
 				sock_hold(sk);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 32ccac10bd62..a758f2ab7b51 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -138,12 +138,11 @@ static struct sock *inet6_lhash2_lookup(struct net =
*net,
 		const __be16 sport, const struct in6_addr *daddr,
 		const unsigned short hnum, const int dif, const int sdif)
 {
-	struct inet_connection_sock *icsk;
 	struct sock *sk, *result =3D NULL;
+	struct hlist_nulls_node *node;
 	int score, hiscore =3D 0;
=20
-	inet_lhash2_for_each_icsk_rcu(icsk, &ilb2->head) {
-		sk =3D (struct sock *)icsk;
+	sk_nulls_for_each_rcu(sk, node, &ilb2->nulls_head) {
 		score =3D compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
 			result =3D lookup_reuseport(net, sk, skb, doff,
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index dbb6d876a203..7f9a71780437 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -83,13 +83,13 @@ static void mptcp_diag_dump_listeners(struct sk_buff =
*skb, struct netlink_callba
 	struct net *net =3D sock_net(skb->sk);
 	int i;
=20
-	for (i =3D diag_ctx->l_slot; i < INET_LHTABLE_SIZE; i++) {
+	for (i =3D diag_ctx->l_slot; i <=3D tcp_hashinfo.lhash2_mask; i++) {
 		struct inet_listen_hashbucket *ilb;
 		struct hlist_nulls_node *node;
 		struct sock *sk;
 		int num =3D 0;
=20
-		ilb =3D &tcp_hashinfo.listening_hash[i];
+		ilb =3D &tcp_hashinfo.lhash2[i];
=20
 		rcu_read_lock();
 		spin_lock(&ilb->lock);
--=20
2.30.2

