Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4036562DA
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 14:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiLZN2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 08:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLZN2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 08:28:48 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E328A25D4
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 05:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672061328; x=1703597328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kV9ZfTBSkPzZJ32py1ywik3ucxnNi/O0O50oNKFVFxw=;
  b=YbrGlpvl24hlALF2j5mEAa4qFdnDp+O0qnTKYcS27vOrJ2iq8soll2g9
   8tx7cQGgNDdt/eZGgQLxRyjtqPCdrWcQ7b2pk+PGAOeqXIo88/Fcq5c2f
   m/gw5gL1g6bu8e+V4+t5BNY7J3jTA9/bwpvK7isAQq7VYulDFixE7ChHF
   I=;
X-IronPort-AV: E=Sophos;i="5.96,275,1665446400"; 
   d="scan'208";a="250963960"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 13:28:47 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id 5B3E9E295A;
        Mon, 26 Dec 2022 13:28:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 26 Dec 2022 13:28:42 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.83) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 26 Dec 2022 13:28:39 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Slaby <jirislaby@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 1/2] tcp: Add TIME_WAIT sockets in bhash2.
Date:   Mon, 26 Dec 2022 22:27:52 +0900
Message-ID: <20221226132753.44175-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221226132753.44175-1-kuniyu@amazon.com>
References: <20221226132753.44175-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.83]
X-ClientProxiedBy: EX13D29UWC003.ant.amazon.com (10.43.162.80) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Slaby reported regression of bind() with a simple repro. [0]

The repro creates a TIME_WAIT socket and tries to bind() a new socket
with the same local address and port.  Before commit 28044fc1d495 ("net:
Add a bhash2 table hashed by port and address"), the bind() failed with
-EADDRINUSE, but now it succeeds.

The cited commit should have put TIME_WAIT sockets into bhash2; otherwise,
inet_bhash2_conflict() misses TIME_WAIT sockets when validating bind()
requests if the address is not a wildcard one.

The straight option is to move sk_bind2_node from struct sock to struct
sock_common to add twsk to bhash2 as implemented as RFC. [1]  However, the
binary layout change in the struct sock could affect performances moving
hot fields on different cachelines.

To avoid that, we add another TIME_WAIT list in inet_bind2_bucket and check
it while validating bind().

[0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
[1]: https://lore.kernel.org/netdev/20221221151258.25748-2-kuniyu@amazon.com/

Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/inet_hashtables.h    |  4 ++++
 include/net/inet_timewait_sock.h |  5 +++++
 net/ipv4/inet_connection_sock.c  | 26 ++++++++++++++++++++++----
 net/ipv4/inet_hashtables.c       |  8 +++++---
 net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
 5 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 69174093078f..99bd823e97f6 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -108,6 +108,10 @@ struct inet_bind2_bucket {
 	struct hlist_node	node;
 	/* List of sockets hashed to this bucket */
 	struct hlist_head	owners;
+	/* bhash has twsk in owners, but bhash2 has twsk in
+	 * deathrow not to add a member in struct sock_common.
+	 */
+	struct hlist_head	deathrow;
 };
 
 static inline struct net *ib_net(const struct inet_bind_bucket *ib)
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 5b47545f22d3..4a8e578405cb 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -73,9 +73,14 @@ struct inet_timewait_sock {
 	u32			tw_priority;
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
+	struct inet_bind2_bucket	*tw_tb2;
+	struct hlist_node		tw_bind2_node;
 };
 #define tw_tclass tw_tos
 
+#define twsk_for_each_bound_bhash2(__tw, list) \
+	hlist_for_each_entry(__tw, list, tw_bind2_node)
+
 static inline struct inet_timewait_sock *inet_twsk(const struct sock *sk)
 {
 	return (struct inet_timewait_sock *)sk;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index b366ab9148f2..848ffc3e0239 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -173,22 +173,40 @@ static bool inet_bind_conflict(const struct sock *sk, struct sock *sk2,
 	return false;
 }
 
+static bool __inet_bhash2_conflict(const struct sock *sk, struct sock *sk2,
+				   kuid_t sk_uid, bool relax,
+				   bool reuseport_cb_ok, bool reuseport_ok)
+{
+	if (sk->sk_family == AF_INET && ipv6_only_sock(sk2))
+		return false;
+
+	return inet_bind_conflict(sk, sk2, sk_uid, relax,
+				  reuseport_cb_ok, reuseport_ok);
+}
+
 static bool inet_bhash2_conflict(const struct sock *sk,
 				 const struct inet_bind2_bucket *tb2,
 				 kuid_t sk_uid,
 				 bool relax, bool reuseport_cb_ok,
 				 bool reuseport_ok)
 {
+	struct inet_timewait_sock *tw2;
 	struct sock *sk2;
 
 	sk_for_each_bound_bhash2(sk2, &tb2->owners) {
-		if (sk->sk_family == AF_INET && ipv6_only_sock(sk2))
-			continue;
+		if (__inet_bhash2_conflict(sk, sk2, sk_uid, relax,
+					   reuseport_cb_ok, reuseport_ok))
+			return true;
+	}
 
-		if (inet_bind_conflict(sk, sk2, sk_uid, relax,
-				       reuseport_cb_ok, reuseport_ok))
+	twsk_for_each_bound_bhash2(tw2, &tb2->deathrow) {
+		sk2 = (struct sock *)tw2;
+
+		if (__inet_bhash2_conflict(sk, sk2, sk_uid, relax,
+					   reuseport_cb_ok, reuseport_ok))
 			return true;
 	}
+
 	return false;
 }
 
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index d039b4e732a3..24a38b56fab9 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -116,6 +116,7 @@ static void inet_bind2_bucket_init(struct inet_bind2_bucket *tb,
 #endif
 		tb->rcv_saddr = sk->sk_rcv_saddr;
 	INIT_HLIST_HEAD(&tb->owners);
+	INIT_HLIST_HEAD(&tb->deathrow);
 	hlist_add_head(&tb->node, &head->chain);
 }
 
@@ -137,7 +138,7 @@ struct inet_bind2_bucket *inet_bind2_bucket_create(struct kmem_cache *cachep,
 /* Caller must hold hashbucket lock for this tb with local BH disabled */
 void inet_bind2_bucket_destroy(struct kmem_cache *cachep, struct inet_bind2_bucket *tb)
 {
-	if (hlist_empty(&tb->owners)) {
+	if (hlist_empty(&tb->owners) && hlist_empty(&tb->deathrow)) {
 		__hlist_del(&tb->node);
 		kmem_cache_free(cachep, tb);
 	}
@@ -1103,15 +1104,16 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, tb2, port);
 
-	spin_unlock(&head2->lock);
-
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
 		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
 	}
 	if (tw)
 		inet_twsk_bind_unhash(tw, hinfo);
+
+	spin_unlock(&head2->lock);
 	spin_unlock(&head->lock);
+
 	if (tw)
 		inet_twsk_deschedule_put(tw);
 	local_bh_enable();
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 66fc940f9521..1d77d992e6e7 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -29,6 +29,7 @@
 void inet_twsk_bind_unhash(struct inet_timewait_sock *tw,
 			  struct inet_hashinfo *hashinfo)
 {
+	struct inet_bind2_bucket *tb2 = tw->tw_tb2;
 	struct inet_bind_bucket *tb = tw->tw_tb;
 
 	if (!tb)
@@ -37,6 +38,11 @@ void inet_twsk_bind_unhash(struct inet_timewait_sock *tw,
 	__hlist_del(&tw->tw_bind_node);
 	tw->tw_tb = NULL;
 	inet_bind_bucket_destroy(hashinfo->bind_bucket_cachep, tb);
+
+	__hlist_del(&tw->tw_bind2_node);
+	tw->tw_tb2 = NULL;
+	inet_bind2_bucket_destroy(hashinfo->bind2_bucket_cachep, tb2);
+
 	__sock_put((struct sock *)tw);
 }
 
@@ -45,7 +51,7 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 {
 	struct inet_hashinfo *hashinfo = tw->tw_dr->hashinfo;
 	spinlock_t *lock = inet_ehash_lockp(hashinfo, tw->tw_hash);
-	struct inet_bind_hashbucket *bhead;
+	struct inet_bind_hashbucket *bhead, *bhead2;
 
 	spin_lock(lock);
 	sk_nulls_del_node_init_rcu((struct sock *)tw);
@@ -54,9 +60,13 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 	/* Disassociate with bind bucket. */
 	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), tw->tw_num,
 			hashinfo->bhash_size)];
+	bhead2 = inet_bhashfn_portaddr(hashinfo, (struct sock *)tw,
+				       twsk_net(tw), tw->tw_num);
 
 	spin_lock(&bhead->lock);
+	spin_lock(&bhead2->lock);
 	inet_twsk_bind_unhash(tw, hashinfo);
+	spin_unlock(&bhead2->lock);
 	spin_unlock(&bhead->lock);
 
 	refcount_dec(&tw->tw_dr->tw_refcount);
@@ -93,6 +103,12 @@ static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
 	hlist_add_head(&tw->tw_bind_node, list);
 }
 
+static void inet_twsk_add_bind2_node(struct inet_timewait_sock *tw,
+				     struct hlist_head *list)
+{
+	hlist_add_head(&tw->tw_bind2_node, list);
+}
+
 /*
  * Enter the time wait state. This is called with locally disabled BH.
  * Essentially we whip up a timewait bucket, copy the relevant info into it
@@ -105,17 +121,28 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_ehash_bucket *ehead = inet_ehash_bucket(hashinfo, sk->sk_hash);
 	spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
-	struct inet_bind_hashbucket *bhead;
+	struct inet_bind_hashbucket *bhead, *bhead2;
+
 	/* Step 1: Put TW into bind hash. Original socket stays there too.
 	   Note, that any socket with inet->num != 0 MUST be bound in
 	   binding cache, even if it is closed.
 	 */
 	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), inet->inet_num,
 			hashinfo->bhash_size)];
+	bhead2 = inet_bhashfn_portaddr(hashinfo, sk, twsk_net(tw), inet->inet_num);
+
 	spin_lock(&bhead->lock);
+	spin_lock(&bhead2->lock);
+
 	tw->tw_tb = icsk->icsk_bind_hash;
 	WARN_ON(!icsk->icsk_bind_hash);
 	inet_twsk_add_bind_node(tw, &tw->tw_tb->owners);
+
+	tw->tw_tb2 = icsk->icsk_bind2_hash;
+	WARN_ON(!icsk->icsk_bind2_hash);
+	inet_twsk_add_bind2_node(tw, &tw->tw_tb2->deathrow);
+
+	spin_unlock(&bhead2->lock);
 	spin_unlock(&bhead->lock);
 
 	spin_lock(lock);
-- 
2.30.2

