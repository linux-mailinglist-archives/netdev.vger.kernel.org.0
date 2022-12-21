Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D91653303
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiLUPNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiLUPNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:13:46 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60BF295
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1671635626; x=1703171626;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HzxNxm8ANdbR4tRxjKaZRX4ESnkU3Sla0i3Lck/gWQw=;
  b=tXQMe3hS7UDlL2mqQfwBxWiNw8I4pQk1aRcWK/canFyqbtcn2Mih5WfE
   JmrQUM6md2JZWFeNbb0pApCpfdTC0xpp+ZGmSFi3UyDV7dWMxl2V0h+Fn
   G97xsiKOPHv5x+Mm+N+2bHIxt4m6KAcdQoyJcw7SdSjUp6fFouXNTF5Hb
   o=;
X-IronPort-AV: E=Sophos;i="5.96,262,1665446400"; 
   d="scan'208";a="163975571"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 15:13:42 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id 021A381998;
        Wed, 21 Dec 2022 15:13:38 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 21 Dec 2022 15:13:38 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.83) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 21 Dec 2022 15:13:35 +0000
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
Subject: [PATCH RFC net 1/2] tcp: Add TIME_WAIT sockets in bhash2.
Date:   Thu, 22 Dec 2022 00:12:57 +0900
Message-ID: <20221221151258.25748-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221221151258.25748-1-kuniyu@amazon.com>
References: <20221221151258.25748-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.83]
X-ClientProxiedBy: EX13D27UWA003.ant.amazon.com (10.43.160.56) To
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

[0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/

Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/inet_timewait_sock.h |  2 ++
 include/net/sock.h               |  5 +++--
 net/ipv4/inet_hashtables.c       |  5 +++--
 net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 5b47545f22d3..c46ed239ad9a 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -44,6 +44,7 @@ struct inet_timewait_sock {
 #define tw_bound_dev_if		__tw_common.skc_bound_dev_if
 #define tw_node			__tw_common.skc_nulls_node
 #define tw_bind_node		__tw_common.skc_bind_node
+#define tw_bind2_node		__tw_common.skc_bind2_node
 #define tw_refcnt		__tw_common.skc_refcnt
 #define tw_hash			__tw_common.skc_hash
 #define tw_prot			__tw_common.skc_prot
@@ -73,6 +74,7 @@ struct inet_timewait_sock {
 	u32			tw_priority;
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
+	struct inet_bind2_bucket	*tw_tb2;
 };
 #define tw_tclass tw_tos
 
diff --git a/include/net/sock.h b/include/net/sock.h
index dcd72e6285b2..aaec985c1b5b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -156,6 +156,7 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_tw_rcv_nxt: (aka tw_rcv_nxt) TCP window next expected seq number
  *		[union with @skc_incoming_cpu]
  *	@skc_refcnt: reference count
+ *	@skc_bind2_node: bind node in the bhash2 table
  *
  *	This is the minimal network layer representation of sockets, the header
  *	for struct sock and struct inet_timewait_sock.
@@ -241,6 +242,7 @@ struct sock_common {
 		u32		skc_window_clamp;
 		u32		skc_tw_snd_nxt; /* struct tcp_timewait_sock */
 	};
+	struct hlist_node	skc_bind2_node;
 	/* public: */
 };
 
@@ -351,7 +353,6 @@ struct sk_filter;
   *	@sk_txtime_report_errors: set report errors mode for SO_TXTIME
   *	@sk_txtime_unused: unused txtime flags
   *	@ns_tracker: tracker for netns reference
-  *	@sk_bind2_node: bind node in the bhash2 table
   */
 struct sock {
 	/*
@@ -384,6 +385,7 @@ struct sock {
 #define sk_net_refcnt		__sk_common.skc_net_refcnt
 #define sk_bound_dev_if		__sk_common.skc_bound_dev_if
 #define sk_bind_node		__sk_common.skc_bind_node
+#define sk_bind2_node		__sk_common.skc_bind2_node
 #define sk_prot			__sk_common.skc_prot
 #define sk_net			__sk_common.skc_net
 #define sk_v6_daddr		__sk_common.skc_v6_daddr
@@ -542,7 +544,6 @@ struct sock {
 #endif
 	struct rcu_head		sk_rcu;
 	netns_tracker		ns_tracker;
-	struct hlist_node	sk_bind2_node;
 };
 
 enum sk_pacing {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index d039b4e732a3..1e81dc7c6de4 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -1103,15 +1103,16 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
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
index 66fc940f9521..bec037d9ab8e 100644
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
+	inet_twsk_add_bind2_node(tw, &tw->tw_tb2->owners);
+
+	spin_unlock(&bhead2->lock);
 	spin_unlock(&bhead->lock);
 
 	spin_lock(lock);
-- 
2.30.2

