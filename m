Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E35B52E10C
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343925AbiETASp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343922AbiETASo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E273E6D38F
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 17:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59BB6617FF
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 00:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3C9C34116;
        Fri, 20 May 2022 00:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653005920;
        bh=VlOk+bjF328z0fhEwLLjxQuqxLcFTVoRht+kgVcJpEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgPkmVkqwVIryjNvfwrfXeMZgpxzizq9p6U6gb8yhDiinfxmNyd7TyWmY3DUHt++w
         vmR85X8nt178BXWlE5zn5Bhdoj4B6lbVO8bMQaOSQdONZ93e4NiHB7rE2gl+Muim1A
         k95ej2DovSl0mKderB1RG7zrCyoVN/gsvTY0sj+t3Ea2Imvw9IJm6n8vtIqWPDNtEA
         9dTS0Hya1XQ/IiKTROk5SQzpaBvKbFeeE2+qtqMWPw93lwsluzZDAqEpax48HQrZct
         vlmxnYcE0QXsxVTuYwvGbKmB8/EJL1Y6bX8jJu/6A4RPxBVkOtqsMtkYxoPIoGBQ9Q
         cSCA8odPX4nEA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Joanne Koong <joannelkoong@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v5 resend 1/2] net: Add a second bind table hashed by port and address
Date:   Thu, 19 May 2022 17:18:33 -0700
Message-Id: <20220520001834.2247810-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520001834.2247810-1-kuba@kernel.org>
References: <20220520001834.2247810-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joanne Koong <joannelkoong@gmail.com>

We currently have one tcp bind table (bhash) which hashes by port
number only. In the socket bind path, we check for bind conflicts by
traversing the specified port's inet_bind2_bucket while holding the
bucket's spinlock (see inet_csk_get_port() and inet_csk_bind_conflict()).

In instances where there are tons of sockets hashed to the same port
at different addresses, checking for a bind conflict is time-intensive
and can cause softirq cpu lockups, as well as stops new tcp connections
since __inet_inherit_port() also contests for the spinlock.

This patch proposes adding a second bind table, bhash2, that hashes by
port and ip address. Searching the bhash2 table leads to significantly
faster conflict resolution and less time holding the spinlock.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/inet_connection_sock.h |   3 +
 include/net/inet_hashtables.h      |  68 +++++++-
 include/net/sock.h                 |  14 ++
 net/dccp/proto.c                   |  33 +++-
 net/ipv4/inet_connection_sock.c    | 247 +++++++++++++++++++++--------
 net/ipv4/inet_hashtables.c         | 193 ++++++++++++++++++++--
 net/ipv4/tcp.c                     |  14 +-
 7 files changed, 489 insertions(+), 83 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 85cd695e7fd1..077cd730ce2f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -25,6 +25,7 @@
 #undef INET_CSK_CLEAR_TIMERS
 
 struct inet_bind_bucket;
+struct inet_bind2_bucket;
 struct tcp_congestion_ops;
 
 /*
@@ -57,6 +58,7 @@ struct inet_connection_sock_af_ops {
  *
  * @icsk_accept_queue:	   FIFO of established children
  * @icsk_bind_hash:	   Bind node
+ * @icsk_bind2_hash:	   Bind node in the bhash2 table
  * @icsk_timeout:	   Timeout
  * @icsk_retransmit_timer: Resend (no ack)
  * @icsk_rto:		   Retransmit timeout
@@ -83,6 +85,7 @@ struct inet_connection_sock {
 	struct inet_sock	  icsk_inet;
 	struct request_sock_queue icsk_accept_queue;
 	struct inet_bind_bucket	  *icsk_bind_hash;
+	struct inet_bind2_bucket  *icsk_bind2_hash;
 	unsigned long		  icsk_timeout;
  	struct timer_list	  icsk_retransmit_timer;
  	struct timer_list	  icsk_delack_timer;
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index ebfa3df6f8dc..a0887b70967b 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -90,11 +90,32 @@ struct inet_bind_bucket {
 	struct hlist_head	owners;
 };
 
+struct inet_bind2_bucket {
+	possible_net_t		ib_net;
+	int			l3mdev;
+	unsigned short		port;
+	union {
+#if IS_ENABLED(CONFIG_IPV6)
+		struct in6_addr		v6_rcv_saddr;
+#endif
+		__be32			rcv_saddr;
+	};
+	/* Node in the inet2_bind_hashbucket chain */
+	struct hlist_node	node;
+	/* List of sockets hashed to this bucket */
+	struct hlist_head	owners;
+};
+
 static inline struct net *ib_net(struct inet_bind_bucket *ib)
 {
 	return read_pnet(&ib->ib_net);
 }
 
+static inline struct net *ib2_net(struct inet_bind2_bucket *ib)
+{
+	return read_pnet(&ib->ib_net);
+}
+
 #define inet_bind_bucket_for_each(tb, head) \
 	hlist_for_each_entry(tb, head, node)
 
@@ -103,6 +124,15 @@ struct inet_bind_hashbucket {
 	struct hlist_head	chain;
 };
 
+/* This is synchronized using the inet_bind_hashbucket's spinlock.
+ * Instead of having separate spinlocks, the inet_bind2_hashbucket can share
+ * the inet_bind_hashbucket's given that in every case where the bhash2 table
+ * is useful, a lookup in the bhash table also occurs.
+ */
+struct inet_bind2_hashbucket {
+	struct hlist_head	chain;
+};
+
 /* Sockets can be hashed in established or listening table.
  * We must use different 'nulls' end-of-chain value for all hash buckets :
  * A socket might transition from ESTABLISH to LISTEN state without
@@ -134,6 +164,12 @@ struct inet_hashinfo {
 	 */
 	struct kmem_cache		*bind_bucket_cachep;
 	struct inet_bind_hashbucket	*bhash;
+	/* The 2nd binding table hashed by port and address.
+	 * This is used primarily for expediting the resolution of bind
+	 * conflicts.
+	 */
+	struct kmem_cache		*bind2_bucket_cachep;
+	struct inet_bind2_hashbucket	*bhash2;
 	unsigned int			bhash_size;
 
 	/* The 2nd listener table hashed by local port and address */
@@ -193,6 +229,36 @@ inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
 void inet_bind_bucket_destroy(struct kmem_cache *cachep,
 			      struct inet_bind_bucket *tb);
 
+static inline bool check_bind_bucket_match(struct inet_bind_bucket *tb,
+					   struct net *net,
+					   const unsigned short port,
+					   int l3mdev)
+{
+	return net_eq(ib_net(tb), net) && tb->port == port &&
+		tb->l3mdev == l3mdev;
+}
+
+struct inet_bind2_bucket *
+inet_bind2_bucket_create(struct kmem_cache *cachep, struct net *net,
+			 struct inet_bind2_hashbucket *head,
+			 const unsigned short port, int l3mdev,
+			 const struct sock *sk);
+
+void inet_bind2_bucket_destroy(struct kmem_cache *cachep,
+			       struct inet_bind2_bucket *tb);
+
+struct inet_bind2_bucket *
+inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
+		       const unsigned short port, int l3mdev,
+		       struct sock *sk,
+		       struct inet_bind2_hashbucket **head);
+
+bool check_bind2_bucket_match_nulladdr(struct inet_bind2_bucket *tb,
+				       struct net *net,
+				       const unsigned short port,
+				       int l3mdev,
+				       const struct sock *sk);
+
 static inline u32 inet_bhashfn(const struct net *net, const __u16 lport,
 			       const u32 bhash_size)
 {
@@ -200,7 +266,7 @@ static inline u32 inet_bhashfn(const struct net *net, const __u16 lport,
 }
 
 void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
-		    const unsigned short snum);
+		    struct inet_bind2_bucket *tb2, const unsigned short snum);
 
 /* Caller must disable local BH processing. */
 int __inet_inherit_port(const struct sock *sk, struct sock *child);
diff --git a/include/net/sock.h b/include/net/sock.h
index 72ca97ccb460..c585ef6565d9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -348,6 +348,7 @@ struct sk_filter;
   *	@sk_txtime_report_errors: set report errors mode for SO_TXTIME
   *	@sk_txtime_unused: unused txtime flags
   *	@ns_tracker: tracker for netns reference
+  *	@sk_bind2_node: bind node in the bhash2 table
   */
 struct sock {
 	/*
@@ -537,6 +538,7 @@ struct sock {
 #endif
 	struct rcu_head		sk_rcu;
 	netns_tracker		ns_tracker;
+	struct hlist_node	sk_bind2_node;
 };
 
 enum sk_pacing {
@@ -817,6 +819,16 @@ static inline void sk_add_bind_node(struct sock *sk,
 	hlist_add_head(&sk->sk_bind_node, list);
 }
 
+static inline void __sk_del_bind2_node(struct sock *sk)
+{
+	__hlist_del(&sk->sk_bind2_node);
+}
+
+static inline void sk_add_bind2_node(struct sock *sk, struct hlist_head *list)
+{
+	hlist_add_head(&sk->sk_bind2_node, list);
+}
+
 #define sk_for_each(__sk, list) \
 	hlist_for_each_entry(__sk, list, sk_node)
 #define sk_for_each_rcu(__sk, list) \
@@ -834,6 +846,8 @@ static inline void sk_add_bind_node(struct sock *sk,
 	hlist_for_each_entry_safe(__sk, tmp, list, sk_node)
 #define sk_for_each_bound(__sk, list) \
 	hlist_for_each_entry(__sk, list, sk_bind_node)
+#define sk_for_each_bound_bhash2(__sk, list) \
+	hlist_for_each_entry(__sk, list, sk_bind2_node)
 
 /**
  * sk_for_each_entry_offset_rcu - iterate over a list at a given struct offset
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index eb8e128e43e8..2e78458900f2 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1120,6 +1120,12 @@ static int __init dccp_init(void)
 				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
 	if (!dccp_hashinfo.bind_bucket_cachep)
 		goto out_free_hashinfo2;
+	dccp_hashinfo.bind2_bucket_cachep =
+		kmem_cache_create("dccp_bind2_bucket",
+				  sizeof(struct inet_bind2_bucket), 0,
+				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
+	if (!dccp_hashinfo.bind2_bucket_cachep)
+		goto out_free_bind_bucket_cachep;
 
 	/*
 	 * Size and allocate the main established and bind bucket
@@ -1150,7 +1156,7 @@ static int __init dccp_init(void)
 
 	if (!dccp_hashinfo.ehash) {
 		DCCP_CRIT("Failed to allocate DCCP established hash table");
-		goto out_free_bind_bucket_cachep;
+		goto out_free_bind2_bucket_cachep;
 	}
 
 	for (i = 0; i <= dccp_hashinfo.ehash_mask; i++)
@@ -1176,14 +1182,23 @@ static int __init dccp_init(void)
 		goto out_free_dccp_locks;
 	}
 
+	dccp_hashinfo.bhash2 = (struct inet_bind2_hashbucket *)
+		__get_free_pages(GFP_ATOMIC | __GFP_NOWARN, bhash_order);
+
+	if (!dccp_hashinfo.bhash2) {
+		DCCP_CRIT("Failed to allocate DCCP bind2 hash table");
+		goto out_free_dccp_bhash;
+	}
+
 	for (i = 0; i < dccp_hashinfo.bhash_size; i++) {
 		spin_lock_init(&dccp_hashinfo.bhash[i].lock);
 		INIT_HLIST_HEAD(&dccp_hashinfo.bhash[i].chain);
+		INIT_HLIST_HEAD(&dccp_hashinfo.bhash2[i].chain);
 	}
 
 	rc = dccp_mib_init();
 	if (rc)
-		goto out_free_dccp_bhash;
+		goto out_free_dccp_bhash2;
 
 	rc = dccp_ackvec_init();
 	if (rc)
@@ -1207,30 +1222,38 @@ static int __init dccp_init(void)
 	dccp_ackvec_exit();
 out_free_dccp_mib:
 	dccp_mib_exit();
+out_free_dccp_bhash2:
+	free_pages((unsigned long)dccp_hashinfo.bhash2, bhash_order);
 out_free_dccp_bhash:
 	free_pages((unsigned long)dccp_hashinfo.bhash, bhash_order);
 out_free_dccp_locks:
 	inet_ehash_locks_free(&dccp_hashinfo);
 out_free_dccp_ehash:
 	free_pages((unsigned long)dccp_hashinfo.ehash, ehash_order);
+out_free_bind2_bucket_cachep:
+	kmem_cache_destroy(dccp_hashinfo.bind2_bucket_cachep);
 out_free_bind_bucket_cachep:
 	kmem_cache_destroy(dccp_hashinfo.bind_bucket_cachep);
 out_free_hashinfo2:
 	inet_hashinfo2_free_mod(&dccp_hashinfo);
 out_fail:
 	dccp_hashinfo.bhash = NULL;
+	dccp_hashinfo.bhash2 = NULL;
 	dccp_hashinfo.ehash = NULL;
 	dccp_hashinfo.bind_bucket_cachep = NULL;
+	dccp_hashinfo.bind2_bucket_cachep = NULL;
 	return rc;
 }
 
 static void __exit dccp_fini(void)
 {
+	int bhash_order = get_order(dccp_hashinfo.bhash_size *
+				    sizeof(struct inet_bind_hashbucket));
+
 	ccid_cleanup_builtins();
 	dccp_mib_exit();
-	free_pages((unsigned long)dccp_hashinfo.bhash,
-		   get_order(dccp_hashinfo.bhash_size *
-			     sizeof(struct inet_bind_hashbucket)));
+	free_pages((unsigned long)dccp_hashinfo.bhash, bhash_order);
+	free_pages((unsigned long)dccp_hashinfo.bhash2, bhash_order);
 	free_pages((unsigned long)dccp_hashinfo.ehash,
 		   get_order((dccp_hashinfo.ehash_mask + 1) *
 			     sizeof(struct inet_ehash_bucket)));
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 53f5f956d948..c0b7e6c21360 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -117,6 +117,32 @@ bool inet_rcv_saddr_any(const struct sock *sk)
 	return !sk->sk_rcv_saddr;
 }
 
+static bool use_bhash2_on_bind(const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	int addr_type;
+
+	if (sk->sk_family == AF_INET6) {
+		addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
+		return addr_type != IPV6_ADDR_ANY &&
+			addr_type != IPV6_ADDR_MAPPED;
+	}
+#endif
+	return sk->sk_rcv_saddr != htonl(INADDR_ANY);
+}
+
+static u32 get_bhash2_nulladdr_hash(const struct sock *sk, struct net *net,
+				    int port)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr nulladdr = {};
+
+	if (sk->sk_family == AF_INET6)
+		return ipv6_portaddr_hash(net, &nulladdr, port);
+#endif
+	return ipv4_portaddr_hash(net, 0, port);
+}
+
 void inet_get_local_port_range(struct net *net, int *low, int *high)
 {
 	unsigned int seq;
@@ -130,16 +156,71 @@ void inet_get_local_port_range(struct net *net, int *low, int *high)
 }
 EXPORT_SYMBOL(inet_get_local_port_range);
 
-static int inet_csk_bind_conflict(const struct sock *sk,
-				  const struct inet_bind_bucket *tb,
-				  bool relax, bool reuseport_ok)
+static bool bind_conflict_exist(const struct sock *sk, struct sock *sk2,
+				kuid_t sk_uid, bool relax,
+				bool reuseport_cb_ok, bool reuseport_ok)
+{
+	int bound_dev_if2;
+
+	if (sk == sk2)
+		return false;
+
+	bound_dev_if2 = READ_ONCE(sk2->sk_bound_dev_if);
+
+	if (!sk->sk_bound_dev_if || !bound_dev_if2 ||
+	    sk->sk_bound_dev_if == bound_dev_if2) {
+		if (sk->sk_reuse && sk2->sk_reuse &&
+		    sk2->sk_state != TCP_LISTEN) {
+			if (!relax || (!reuseport_ok && sk->sk_reuseport &&
+				       sk2->sk_reuseport && reuseport_cb_ok &&
+				       (sk2->sk_state == TCP_TIME_WAIT ||
+					uid_eq(sk_uid, sock_i_uid(sk2)))))
+				return true;
+		} else if (!reuseport_ok || !sk->sk_reuseport ||
+			   !sk2->sk_reuseport || !reuseport_cb_ok ||
+			   (sk2->sk_state != TCP_TIME_WAIT &&
+			    !uid_eq(sk_uid, sock_i_uid(sk2)))) {
+			return true;
+		}
+	}
+	return false;
+}
+
+static bool check_bhash2_conflict(const struct sock *sk,
+				  struct inet_bind2_bucket *tb2, kuid_t sk_uid,
+				  bool relax, bool reuseport_cb_ok,
+				  bool reuseport_ok)
 {
 	struct sock *sk2;
-	bool reuseport_cb_ok;
-	bool reuse = sk->sk_reuse;
-	bool reuseport = !!sk->sk_reuseport;
-	struct sock_reuseport *reuseport_cb;
+
+	sk_for_each_bound_bhash2(sk2, &tb2->owners) {
+		if (sk->sk_family == AF_INET && ipv6_only_sock(sk2))
+			continue;
+
+		if (bind_conflict_exist(sk, sk2, sk_uid, relax,
+					reuseport_cb_ok, reuseport_ok))
+			return true;
+	}
+	return false;
+}
+
+/* This should be called only when the corresponding inet_bind_bucket spinlock
+ * is held
+ */
+static int inet_csk_bind_conflict(const struct sock *sk, int port,
+				  struct inet_bind_bucket *tb,
+				  struct inet_bind2_bucket *tb2, /* may be null */
+				  bool relax, bool reuseport_ok)
+{
+	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
 	kuid_t uid = sock_i_uid((struct sock *)sk);
+	struct sock_reuseport *reuseport_cb;
+	struct inet_bind2_hashbucket *head2;
+	bool reuseport_cb_ok;
+	struct sock *sk2;
+	struct net *net;
+	int l3mdev;
+	u32 hash;
 
 	rcu_read_lock();
 	reuseport_cb = rcu_dereference(sk->sk_reuseport_cb);
@@ -150,40 +231,42 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 	/*
 	 * Unlike other sk lookup places we do not check
 	 * for sk_net here, since _all_ the socks listed
-	 * in tb->owners list belong to the same net - the
-	 * one this bucket belongs to.
+	 * in tb->owners and tb2->owners list belong
+	 * to the same net
 	 */
 
-	sk_for_each_bound(sk2, &tb->owners) {
-		int bound_dev_if2;
+	if (!use_bhash2_on_bind(sk)) {
+		sk_for_each_bound(sk2, &tb->owners)
+			if (bind_conflict_exist(sk, sk2, uid, relax,
+						reuseport_cb_ok, reuseport_ok) &&
+			    inet_rcv_saddr_equal(sk, sk2, true))
+				return true;
 
-		if (sk == sk2)
-			continue;
-		bound_dev_if2 = READ_ONCE(sk2->sk_bound_dev_if);
-		if ((!sk->sk_bound_dev_if ||
-		     !bound_dev_if2 ||
-		     sk->sk_bound_dev_if == bound_dev_if2)) {
-			if (reuse && sk2->sk_reuse &&
-			    sk2->sk_state != TCP_LISTEN) {
-				if ((!relax ||
-				     (!reuseport_ok &&
-				      reuseport && sk2->sk_reuseport &&
-				      reuseport_cb_ok &&
-				      (sk2->sk_state == TCP_TIME_WAIT ||
-				       uid_eq(uid, sock_i_uid(sk2))))) &&
-				    inet_rcv_saddr_equal(sk, sk2, true))
-					break;
-			} else if (!reuseport_ok ||
-				   !reuseport || !sk2->sk_reuseport ||
-				   !reuseport_cb_ok ||
-				   (sk2->sk_state != TCP_TIME_WAIT &&
-				    !uid_eq(uid, sock_i_uid(sk2)))) {
-				if (inet_rcv_saddr_equal(sk, sk2, true))
-					break;
-			}
-		}
+		return false;
 	}
-	return sk2 != NULL;
+
+	if (tb2 && check_bhash2_conflict(sk, tb2, uid, relax, reuseport_cb_ok,
+					 reuseport_ok))
+		return true;
+
+	net = sock_net(sk);
+
+	/* check there's no conflict with an existing IPV6_ADDR_ANY (if ipv6) or
+	 * INADDR_ANY (if ipv4) socket.
+	 */
+	hash = get_bhash2_nulladdr_hash(sk, net, port);
+	head2 = &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
+
+	l3mdev = inet_sk_bound_l3mdev(sk);
+	inet_bind_bucket_for_each(tb2, &head2->chain)
+		if (check_bind2_bucket_match_nulladdr(tb2, net, port, l3mdev, sk))
+			break;
+
+	if (tb2 && check_bhash2_conflict(sk, tb2, uid, relax, reuseport_cb_ok,
+					 reuseport_ok))
+		return true;
+
+	return false;
 }
 
 /*
@@ -191,16 +274,20 @@ static int inet_csk_bind_conflict(const struct sock *sk,
  * inet_bind_hashbucket lock held.
  */
 static struct inet_bind_hashbucket *
-inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *port_ret)
+inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret,
+			struct inet_bind2_bucket **tb2_ret,
+			struct inet_bind2_hashbucket **head2_ret, int *port_ret)
 {
 	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
-	int port = 0;
+	struct inet_bind2_hashbucket *head2;
 	struct inet_bind_hashbucket *head;
 	struct net *net = sock_net(sk);
-	bool relax = false;
 	int i, low, high, attempt_half;
+	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
+	bool relax = false;
+	int port = 0;
 	int l3mdev;
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
@@ -239,10 +326,12 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 		head = &hinfo->bhash[inet_bhashfn(net, port,
 						  hinfo->bhash_size)];
 		spin_lock_bh(&head->lock);
+		tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk,
+					     &head2);
 		inet_bind_bucket_for_each(tb, &head->chain)
-			if (net_eq(ib_net(tb), net) && tb->l3mdev == l3mdev &&
-			    tb->port == port) {
-				if (!inet_csk_bind_conflict(sk, tb, relax, false))
+			if (check_bind_bucket_match(tb, net, port, l3mdev)) {
+				if (!inet_csk_bind_conflict(sk, port, tb, tb2,
+							    relax, false))
 					goto success;
 				goto next_port;
 			}
@@ -272,6 +361,8 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 success:
 	*port_ret = port;
 	*tb_ret = tb;
+	*tb2_ret = tb2;
+	*head2_ret = head2;
 	return head;
 }
 
@@ -367,54 +458,81 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 {
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
 	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
-	int ret = 1, port = snum;
+	bool bhash_created = false, bhash2_created = false;
+	struct inet_bind2_bucket *tb2 = NULL;
+	struct inet_bind2_hashbucket *head2;
+	struct inet_bind_bucket *tb = NULL;
 	struct inet_bind_hashbucket *head;
 	struct net *net = sock_net(sk);
-	struct inet_bind_bucket *tb = NULL;
+	int ret = 1, port = snum;
+	bool found_port = false;
 	int l3mdev;
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
 
 	if (!port) {
-		head = inet_csk_find_open_port(sk, &tb, &port);
+		head = inet_csk_find_open_port(sk, &tb, &tb2, &head2, &port);
 		if (!head)
 			return ret;
+		if (tb && tb2)
+			goto success;
+		found_port = true;
+	} else {
+		head = &hinfo->bhash[inet_bhashfn(net, port,
+						  hinfo->bhash_size)];
+		spin_lock_bh(&head->lock);
+		inet_bind_bucket_for_each(tb, &head->chain)
+			if (check_bind_bucket_match(tb, net, port, l3mdev))
+				break;
+
+		tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk,
+					     &head2);
+	}
+
+	if (!tb) {
+		tb = inet_bind_bucket_create(hinfo->bind_bucket_cachep, net,
+					     head, port, l3mdev);
 		if (!tb)
-			goto tb_not_found;
-		goto success;
+			goto fail_unlock;
+		bhash_created = true;
 	}
-	head = &hinfo->bhash[inet_bhashfn(net, port,
-					  hinfo->bhash_size)];
-	spin_lock_bh(&head->lock);
-	inet_bind_bucket_for_each(tb, &head->chain)
-		if (net_eq(ib_net(tb), net) && tb->l3mdev == l3mdev &&
-		    tb->port == port)
-			goto tb_found;
-tb_not_found:
-	tb = inet_bind_bucket_create(hinfo->bind_bucket_cachep,
-				     net, head, port, l3mdev);
-	if (!tb)
-		goto fail_unlock;
-tb_found:
-	if (!hlist_empty(&tb->owners)) {
+
+	if (!tb2) {
+		tb2 = inet_bind2_bucket_create(hinfo->bind2_bucket_cachep,
+					       net, head2, port, l3mdev, sk);
+		if (!tb2)
+			goto fail_unlock;
+		bhash2_created = true;
+	}
+
+	/* If we had to find an open port, we already checked for conflicts */
+	if (!found_port && !hlist_empty(&tb->owners)) {
 		if (sk->sk_reuse == SK_FORCE_REUSE)
 			goto success;
 
 		if ((tb->fastreuse > 0 && reuse) ||
 		    sk_reuseport_match(tb, sk))
 			goto success;
-		if (inet_csk_bind_conflict(sk, tb, true, true))
+		if (inet_csk_bind_conflict(sk, port, tb, tb2, true, true))
 			goto fail_unlock;
 	}
 success:
 	inet_csk_update_fastreuse(tb, sk);
 
 	if (!inet_csk(sk)->icsk_bind_hash)
-		inet_bind_hash(sk, tb, port);
+		inet_bind_hash(sk, tb, tb2, port);
 	WARN_ON(inet_csk(sk)->icsk_bind_hash != tb);
+	WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
 	ret = 0;
 
 fail_unlock:
+	if (ret) {
+		if (bhash_created)
+			inet_bind_bucket_destroy(hinfo->bind_bucket_cachep, tb);
+		if (bhash2_created)
+			inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep,
+						  tb2);
+	}
 	spin_unlock_bh(&head->lock);
 	return ret;
 }
@@ -961,6 +1079,7 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 
 		inet_sk_set_state(newsk, TCP_SYN_RECV);
 		newicsk->icsk_bind_hash = NULL;
+		newicsk->icsk_bind2_hash = NULL;
 
 		inet_sk(newsk)->inet_dport = inet_rsk(req)->ir_rmt_port;
 		inet_sk(newsk)->inet_num = inet_rsk(req)->ir_num;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 87354e20009a..e8de5e699b3f 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -81,6 +81,41 @@ struct inet_bind_bucket *inet_bind_bucket_create(struct kmem_cache *cachep,
 	return tb;
 }
 
+struct inet_bind2_bucket *inet_bind2_bucket_create(struct kmem_cache *cachep,
+						   struct net *net,
+						   struct inet_bind2_hashbucket *head,
+						   const unsigned short port,
+						   int l3mdev,
+						   const struct sock *sk)
+{
+	struct inet_bind2_bucket *tb = kmem_cache_alloc(cachep, GFP_ATOMIC);
+
+	if (tb) {
+		write_pnet(&tb->ib_net, net);
+		tb->l3mdev    = l3mdev;
+		tb->port      = port;
+#if IS_ENABLED(CONFIG_IPV6)
+		if (sk->sk_family == AF_INET6)
+			tb->v6_rcv_saddr = sk->sk_v6_rcv_saddr;
+		else
+#endif
+			tb->rcv_saddr = sk->sk_rcv_saddr;
+		INIT_HLIST_HEAD(&tb->owners);
+		hlist_add_head(&tb->node, &head->chain);
+	}
+	return tb;
+}
+
+static bool bind2_bucket_addr_match(struct inet_bind2_bucket *tb2, struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6)
+		return ipv6_addr_equal(&tb2->v6_rcv_saddr,
+				       &sk->sk_v6_rcv_saddr);
+#endif
+	return tb2->rcv_saddr == sk->sk_rcv_saddr;
+}
+
 /*
  * Caller must hold hashbucket lock for this tb with local BH disabled
  */
@@ -92,12 +127,25 @@ void inet_bind_bucket_destroy(struct kmem_cache *cachep, struct inet_bind_bucket
 	}
 }
 
+/* Caller must hold the lock for the corresponding hashbucket in the bhash table
+ * with local BH disabled
+ */
+void inet_bind2_bucket_destroy(struct kmem_cache *cachep, struct inet_bind2_bucket *tb)
+{
+	if (hlist_empty(&tb->owners)) {
+		__hlist_del(&tb->node);
+		kmem_cache_free(cachep, tb);
+	}
+}
+
 void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
-		    const unsigned short snum)
+		    struct inet_bind2_bucket *tb2, const unsigned short snum)
 {
 	inet_sk(sk)->inet_num = snum;
 	sk_add_bind_node(sk, &tb->owners);
 	inet_csk(sk)->icsk_bind_hash = tb;
+	sk_add_bind2_node(sk, &tb2->owners);
+	inet_csk(sk)->icsk_bind2_hash = tb2;
 }
 
 /*
@@ -109,6 +157,7 @@ static void __inet_put_port(struct sock *sk)
 	const int bhash = inet_bhashfn(sock_net(sk), inet_sk(sk)->inet_num,
 			hashinfo->bhash_size);
 	struct inet_bind_hashbucket *head = &hashinfo->bhash[bhash];
+	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
 
 	spin_lock(&head->lock);
@@ -117,6 +166,13 @@ static void __inet_put_port(struct sock *sk)
 	inet_csk(sk)->icsk_bind_hash = NULL;
 	inet_sk(sk)->inet_num = 0;
 	inet_bind_bucket_destroy(hashinfo->bind_bucket_cachep, tb);
+
+	if (inet_csk(sk)->icsk_bind2_hash) {
+		tb2 = inet_csk(sk)->icsk_bind2_hash;
+		__sk_del_bind2_node(sk);
+		inet_csk(sk)->icsk_bind2_hash = NULL;
+		inet_bind2_bucket_destroy(hashinfo->bind2_bucket_cachep, tb2);
+	}
 	spin_unlock(&head->lock);
 }
 
@@ -133,14 +189,19 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
 	struct inet_hashinfo *table = sk->sk_prot->h.hashinfo;
 	unsigned short port = inet_sk(child)->inet_num;
 	const int bhash = inet_bhashfn(sock_net(sk), port,
-			table->bhash_size);
+				       table->bhash_size);
 	struct inet_bind_hashbucket *head = &table->bhash[bhash];
+	struct inet_bind2_hashbucket *head_bhash2;
+	bool created_inet_bind_bucket = false;
+	struct net *net = sock_net(sk);
+	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
 	int l3mdev;
 
 	spin_lock(&head->lock);
 	tb = inet_csk(sk)->icsk_bind_hash;
-	if (unlikely(!tb)) {
+	tb2 = inet_csk(sk)->icsk_bind2_hash;
+	if (unlikely(!tb || !tb2)) {
 		spin_unlock(&head->lock);
 		return -ENOENT;
 	}
@@ -153,25 +214,45 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
 		 * as that of the child socket. We have to look up or
 		 * create a new bind bucket for the child here. */
 		inet_bind_bucket_for_each(tb, &head->chain) {
-			if (net_eq(ib_net(tb), sock_net(sk)) &&
-			    tb->l3mdev == l3mdev && tb->port == port)
+			if (check_bind_bucket_match(tb, net, port, l3mdev))
 				break;
 		}
 		if (!tb) {
 			tb = inet_bind_bucket_create(table->bind_bucket_cachep,
-						     sock_net(sk), head, port,
-						     l3mdev);
+						     net, head, port, l3mdev);
 			if (!tb) {
 				spin_unlock(&head->lock);
 				return -ENOMEM;
 			}
+			created_inet_bind_bucket = true;
 		}
 		inet_csk_update_fastreuse(tb, child);
+
+		goto bhash2_find;
+	} else if (!bind2_bucket_addr_match(tb2, child)) {
+		l3mdev = inet_sk_bound_l3mdev(sk);
+
+bhash2_find:
+		tb2 = inet_bind2_bucket_find(table, net, port, l3mdev, child,
+					     &head_bhash2);
+		if (!tb2) {
+			tb2 = inet_bind2_bucket_create(table->bind2_bucket_cachep,
+						       net, head_bhash2, port,
+						       l3mdev, child);
+			if (!tb2)
+				goto error;
+		}
 	}
-	inet_bind_hash(child, tb, port);
+	inet_bind_hash(child, tb, tb2, port);
 	spin_unlock(&head->lock);
 
 	return 0;
+
+error:
+	if (created_inet_bind_bucket)
+		inet_bind_bucket_destroy(table->bind_bucket_cachep, tb);
+	spin_unlock(&head->lock);
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(__inet_inherit_port);
 
@@ -675,6 +756,76 @@ void inet_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
 
+static bool check_bind2_bucket_match(struct inet_bind2_bucket *tb,
+				     struct net *net, unsigned short port,
+				     int l3mdev, struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6)
+		return net_eq(ib2_net(tb), net) && tb->port == port &&
+			tb->l3mdev == l3mdev &&
+			ipv6_addr_equal(&tb->v6_rcv_saddr, &sk->sk_v6_rcv_saddr);
+	else
+#endif
+		return net_eq(ib2_net(tb), net) && tb->port == port &&
+			tb->l3mdev == l3mdev && tb->rcv_saddr == sk->sk_rcv_saddr;
+}
+
+bool check_bind2_bucket_match_nulladdr(struct inet_bind2_bucket *tb,
+				       struct net *net, const unsigned short port,
+				       int l3mdev, const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr nulladdr = {};
+
+	if (sk->sk_family == AF_INET6)
+		return net_eq(ib2_net(tb), net) && tb->port == port &&
+			tb->l3mdev == l3mdev &&
+			ipv6_addr_equal(&tb->v6_rcv_saddr, &nulladdr);
+	else
+#endif
+		return net_eq(ib2_net(tb), net) && tb->port == port &&
+			tb->l3mdev == l3mdev && tb->rcv_saddr == 0;
+}
+
+static struct inet_bind2_hashbucket *
+inet_bhashfn_portaddr(struct inet_hashinfo *hinfo, const struct sock *sk,
+		      const struct net *net, unsigned short port)
+{
+	u32 hash;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6)
+		hash = ipv6_portaddr_hash(net, &sk->sk_v6_rcv_saddr, port);
+	else
+#endif
+		hash = ipv4_portaddr_hash(net, sk->sk_rcv_saddr, port);
+	return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
+}
+
+/* This should only be called when the spinlock for the socket's corresponding
+ * bind_hashbucket is held
+ */
+struct inet_bind2_bucket *
+inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
+		       const unsigned short port, int l3mdev, struct sock *sk,
+		       struct inet_bind2_hashbucket **head)
+{
+	struct inet_bind2_bucket *bhash2 = NULL;
+	struct inet_bind2_hashbucket *h;
+
+	h = inet_bhashfn_portaddr(hinfo, sk, net, port);
+	inet_bind_bucket_for_each(bhash2, &h->chain) {
+		if (check_bind2_bucket_match(bhash2, net, port, l3mdev, sk))
+			break;
+	}
+
+	if (head)
+		*head = h;
+
+	return bhash2;
+}
+
 /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
@@ -695,10 +846,13 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 {
 	struct inet_hashinfo *hinfo = death_row->hashinfo;
 	struct inet_timewait_sock *tw = NULL;
+	struct inet_bind2_hashbucket *head2;
 	struct inet_bind_hashbucket *head;
 	int port = inet_sk(sk)->inet_num;
 	struct net *net = sock_net(sk);
+	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
+	bool tb_created = false;
 	u32 remaining, offset;
 	int ret, i, low, high;
 	int l3mdev;
@@ -755,8 +909,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		 * the established check is already unique enough.
 		 */
 		inet_bind_bucket_for_each(tb, &head->chain) {
-			if (net_eq(ib_net(tb), net) && tb->l3mdev == l3mdev &&
-			    tb->port == port) {
+			if (check_bind_bucket_match(tb, net, port, l3mdev)) {
 				if (tb->fastreuse >= 0 ||
 				    tb->fastreuseport >= 0)
 					goto next_port;
@@ -774,6 +927,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 			spin_unlock_bh(&head->lock);
 			return -ENOMEM;
 		}
+		tb_created = true;
 		tb->fastreuse = -1;
 		tb->fastreuseport = -1;
 		goto ok;
@@ -789,6 +943,17 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
+	/* Find the corresponding tb2 bucket since we need to
+	 * add the socket to the bhash2 table as well
+	 */
+	tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk, &head2);
+	if (!tb2) {
+		tb2 = inet_bind2_bucket_create(hinfo->bind2_bucket_cachep, net,
+					       head2, port, l3mdev, sk);
+		if (!tb2)
+			goto error;
+	}
+
 	/* Here we want to add a little bit of randomness to the next source
 	 * port that will be chosen. We use a max() with a random here so that
 	 * on low contention the randomness is maximal and on high contention
@@ -798,7 +963,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
-	inet_bind_hash(sk, tb, port);
+	inet_bind_hash(sk, tb, tb2, port);
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
 		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
@@ -810,6 +975,12 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		inet_twsk_deschedule_put(tw);
 	local_bh_enable();
 	return 0;
+
+error:
+	if (tb_created)
+		inet_bind_bucket_destroy(hinfo->bind_bucket_cachep, tb);
+	spin_unlock_bh(&head->lock);
+	return -ENOMEM;
 }
 
 /*
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 028513d3e2a2..9984d23a7f3e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4604,6 +4604,12 @@ void __init tcp_init(void)
 				  SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				  SLAB_ACCOUNT,
 				  NULL);
+	tcp_hashinfo.bind2_bucket_cachep =
+		kmem_cache_create("tcp_bind2_bucket",
+				  sizeof(struct inet_bind2_bucket), 0,
+				  SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				  SLAB_ACCOUNT,
+				  NULL);
 
 	/* Size and allocate the main established and bind bucket
 	 * hash tables.
@@ -4626,8 +4632,9 @@ void __init tcp_init(void)
 	if (inet_ehash_locks_alloc(&tcp_hashinfo))
 		panic("TCP: failed to alloc ehash_locks");
 	tcp_hashinfo.bhash =
-		alloc_large_system_hash("TCP bind",
-					sizeof(struct inet_bind_hashbucket),
+		alloc_large_system_hash("TCP bind bhash tables",
+					sizeof(struct inet_bind_hashbucket) +
+					sizeof(struct inet_bind2_hashbucket),
 					tcp_hashinfo.ehash_mask + 1,
 					17, /* one slot per 128 KB of memory */
 					0,
@@ -4636,9 +4643,12 @@ void __init tcp_init(void)
 					0,
 					64 * 1024);
 	tcp_hashinfo.bhash_size = 1U << tcp_hashinfo.bhash_size;
+	tcp_hashinfo.bhash2 =
+		(struct inet_bind2_hashbucket *)(tcp_hashinfo.bhash + tcp_hashinfo.bhash_size);
 	for (i = 0; i < tcp_hashinfo.bhash_size; i++) {
 		spin_lock_init(&tcp_hashinfo.bhash[i].lock);
 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash[i].chain);
+		INIT_HLIST_HEAD(&tcp_hashinfo.bhash2[i].chain);
 	}
 
 
-- 
2.34.3

