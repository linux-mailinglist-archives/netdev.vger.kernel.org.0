Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1367E558BDC
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiFWXo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiFWXo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:44:58 -0400
Received: from 69-171-232-181.mail-mxout.facebook.com (69-171-232-181.mail-mxout.facebook.com [69.171.232.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B2050013
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:44:55 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 99922E0E7026; Thu, 23 Jun 2022 16:44:41 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v1 1/3] net: Add a bhash2 table hashed by port + address
Date:   Thu, 23 Jun 2022 16:42:40 -0700
Message-Id: <20220623234242.2083895-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220623234242.2083895-1-joannelkoong@gmail.com>
References: <20220623234242.2083895-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current bind hashtable (bhash) is hashed by port only.
In the socket bind path, we have to check for bind conflicts by
traversing the specified port's inet_bind_bucket while holding the
hashbucket's spinlock (see inet_csk_get_port() and
inet_csk_bind_conflict()). In instances where there are tons of
sockets hashed to the same port at different addresses, the bind
conflict check is time-intensive and can cause softirq cpu lockups,
as well as stops new tcp connections since __inet_inherit_port()
also contests for the spinlock.

This patch adds a second bind table, bhash2, that hashes by
port and sk->sk_rcv_saddr (ipv4) and sk->sk_v6_rcv_saddr (ipv6).
Searching the bhash2 table leads to significantly faster conflict
resolution and less time holding the hashbucket spinlock.

Please note a few things:
* There can be the case where the a socket's address changes after it
has been bound. There are two cases where this happens:

  1) The case where there is a bind() call on INADDR_ANY (ipv4) or
  IPV6_ADDR_ANY (ipv6) and then a connect() call. The kernel will
  assign the socket an address when it handles the connect()

  2) In inet_sk_reselect_saddr(), which is called when rebuilding the
  sk header and a few pre-conditions are met (eg rerouting fails).

In these two cases, we need to update the bhash2 table by removing the
entry for the old address, and add a new entry reflecting the updated
address.

* The bhash2 table must have its own lock, even though concurrent
accesses on the same port are protected by the bhash lock. Bhash2 must
have its own lock to protect against cases where sockets on different
ports hash to different bhash hashbuckets but to the same bhash2
hashbucket.

This brings up a few stipulations:
  1) When acquiring both the bhash and the bhash2 lock, the bhash2 lock
  will always be acquired after the bhash lock and released before the
  bhash lock is released.

  2) There are no nested bhash2 hashbucket locks. A bhash2 lock is always
  acquired+released before another bhash2 lock is acquired+released.

* The bhash table cannot be superseded by the bhash2 table because for
bind requests on INADDR_ANY (ipv4) or IPV6_ADDR_ANY (ipv6), every socket
bound to that port must be checked for a potential conflict. The bhash
table is the only source of port->socket associations.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/net/inet_connection_sock.h |   3 +
 include/net/inet_hashtables.h      |  80 ++++++++-
 include/net/sock.h                 |  17 +-
 net/dccp/ipv4.c                    |  24 ++-
 net/dccp/ipv6.c                    |  12 ++
 net/dccp/proto.c                   |  34 +++-
 net/ipv4/af_inet.c                 |  31 +++-
 net/ipv4/inet_connection_sock.c    | 279 ++++++++++++++++++++++-------
 net/ipv4/inet_hashtables.c         | 277 ++++++++++++++++++++++++++--
 net/ipv4/tcp.c                     |  11 +-
 net/ipv4/tcp_ipv4.c                |  21 ++-
 net/ipv6/tcp_ipv6.c                |  12 ++
 12 files changed, 696 insertions(+), 105 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connec=
tion_sock.h
index 85cd695e7fd1..077cd730ce2f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -25,6 +25,7 @@
 #undef INET_CSK_CLEAR_TIMERS
=20
 struct inet_bind_bucket;
+struct inet_bind2_bucket;
 struct tcp_congestion_ops;
=20
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
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.=
h
index ebfa3df6f8dc..1e8a6ca5a988 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -23,6 +23,7 @@
=20
 #include <net/inet_connection_sock.h>
 #include <net/inet_sock.h>
+#include <net/ip.h>
 #include <net/sock.h>
 #include <net/route.h>
 #include <net/tcp_states.h>
@@ -90,7 +91,28 @@ struct inet_bind_bucket {
 	struct hlist_head	owners;
 };
=20
-static inline struct net *ib_net(struct inet_bind_bucket *ib)
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
+	/* Node in the bhash2 inet_bind_hashbucket chain */
+	struct hlist_node	node;
+	/* List of sockets hashed to this bucket */
+	struct hlist_head	owners;
+};
+
+static inline struct net *ib_net(const struct inet_bind_bucket *ib)
+{
+	return read_pnet(&ib->ib_net);
+}
+
+static inline struct net *ib2_net(const struct inet_bind2_bucket *ib)
 {
 	return read_pnet(&ib->ib_net);
 }
@@ -133,7 +155,14 @@ struct inet_hashinfo {
 	 * TCP hash as well as the others for fast bind/connect.
 	 */
 	struct kmem_cache		*bind_bucket_cachep;
+	/* This bind table is hashed by local port */
 	struct inet_bind_hashbucket	*bhash;
+	struct kmem_cache		*bind2_bucket_cachep;
+	/* This bind table is hashed by local port and sk->sk_rcv_saddr (ipv4)
+	 * or sk->sk_v6_rcv_saddr (ipv6). This 2nd bind table is used
+	 * primarily for expediting bind conflict resolution.
+	 */
+	struct inet_bind_hashbucket	*bhash2;
 	unsigned int			bhash_size;
=20
 	/* The 2nd listener table hashed by local port and address */
@@ -193,14 +222,61 @@ inet_bind_bucket_create(struct kmem_cache *cachep, =
struct net *net,
 void inet_bind_bucket_destroy(struct kmem_cache *cachep,
 			      struct inet_bind_bucket *tb);
=20
+bool inet_bind_bucket_match(const struct inet_bind_bucket *tb,
+			    const struct net *net, unsigned short port,
+			    int l3mdev);
+
+struct inet_bind2_bucket *
+inet_bind2_bucket_create(struct kmem_cache *cachep, struct net *net,
+			 struct inet_bind_hashbucket *head,
+			 unsigned short port, int l3mdev,
+			 const struct sock *sk);
+
+void inet_bind2_bucket_destroy(struct kmem_cache *cachep,
+			       struct inet_bind2_bucket *tb);
+
+struct inet_bind2_bucket *
+inet_bind2_bucket_find(const struct inet_bind_hashbucket *head,
+		       const struct net *net,
+		       unsigned short port, int l3mdev,
+		       const struct sock *sk);
+
+bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb=
,
+				      const struct net *net, unsigned short port,
+				      int l3mdev, const struct sock *sk);
+
 static inline u32 inet_bhashfn(const struct net *net, const __u16 lport,
 			       const u32 bhash_size)
 {
 	return (lport + net_hash_mix(net)) & (bhash_size - 1);
 }
=20
+static inline struct inet_bind_hashbucket *
+inet_bhashfn_portaddr(const struct inet_hashinfo *hinfo, const struct so=
ck *sk,
+		      const struct net *net, unsigned short port)
+{
+	u32 hash;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family =3D=3D AF_INET6)
+		hash =3D ipv6_portaddr_hash(net, &sk->sk_v6_rcv_saddr, port);
+	else
+#endif
+		hash =3D ipv4_portaddr_hash(net, sk->sk_rcv_saddr, port);
+	return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
+}
+
+struct inet_bind_hashbucket *
+inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net =
*net, int port);
+
+/* This should be called whenever a socket's sk_rcv_saddr (ipv4) or
+ * sk_v6_rcv_saddr (ipv6) changes after it has been binded. The socket's
+ * rcv_saddr field should already have been updated when this is called.
+ */
+int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, st=
ruct sock *sk);
+
 void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
-		    const unsigned short snum);
+		    struct inet_bind2_bucket *tb2, unsigned short port);
=20
 /* Caller must disable local BH processing. */
 int __inet_inherit_port(const struct sock *sk, struct sock *child);
diff --git a/include/net/sock.h b/include/net/sock.h
index 5bed1ea7a722..3932e3e96281 100644
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
=20
 enum sk_pacing {
@@ -811,12 +813,21 @@ static inline void __sk_del_bind_node(struct sock *=
sk)
 	__hlist_del(&sk->sk_bind_node);
 }
=20
-static inline void sk_add_bind_node(struct sock *sk,
-					struct hlist_head *list)
+static inline void sk_add_bind_node(struct sock *sk, struct hlist_head *=
list)
 {
 	hlist_add_head(&sk->sk_bind_node, list);
 }
=20
+static inline void __sk_del_bind2_node(struct sock *sk)
+{
+	__hlist_del(&sk->sk_bind2_node);
+}
+
+static inline void sk_add_bind2_node(struct sock *sk, struct hlist_head =
*list)
+{
+	hlist_add_head(&sk->sk_bind2_node, list);
+}
+
 #define sk_for_each(__sk, list) \
 	hlist_for_each_entry(__sk, list, sk_node)
 #define sk_for_each_rcu(__sk, list) \
@@ -834,6 +845,8 @@ static inline void sk_add_bind_node(struct sock *sk,
 	hlist_for_each_entry_safe(__sk, tmp, list, sk_node)
 #define sk_for_each_bound(__sk, list) \
 	hlist_for_each_entry(__sk, list, sk_bind_node)
+#define sk_for_each_bound_bhash2(__sk, list) \
+	hlist_for_each_entry(__sk, list, sk_bind2_node)
=20
 /**
  * sk_for_each_entry_offset_rcu - iterate over a list at a given struct =
offset
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index da6e3b20cd75..7958f5d355f3 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -45,14 +45,15 @@ static unsigned int dccp_v4_pernet_id __read_mostly;
 int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_le=
n)
 {
 	const struct sockaddr_in *usin =3D (struct sockaddr_in *)uaddr;
+	struct inet_bind_hashbucket *prev_addr_hashbucket =3D NULL;
+	__be32 daddr, nexthop, prev_sk_rcv_saddr;
 	struct inet_sock *inet =3D inet_sk(sk);
 	struct dccp_sock *dp =3D dccp_sk(sk);
+	struct ip_options_rcu *inet_opt;
 	__be16 orig_sport, orig_dport;
-	__be32 daddr, nexthop;
 	struct flowi4 *fl4;
 	struct rtable *rt;
 	int err;
-	struct ip_options_rcu *inet_opt;
=20
 	dp->dccps_role =3D DCCP_ROLE_CLIENT;
=20
@@ -89,9 +90,26 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *=
uaddr, int addr_len)
 	if (inet_opt =3D=3D NULL || !inet_opt->opt.srr)
 		daddr =3D fl4->daddr;
=20
-	if (inet->inet_saddr =3D=3D 0)
+	if (inet->inet_saddr =3D=3D 0) {
+		prev_addr_hashbucket =3D inet_bhashfn_portaddr(&dccp_hashinfo,
+							     sk, sock_net(sk),
+							     inet->inet_num);
+		prev_sk_rcv_saddr =3D sk->sk_rcv_saddr;
 		inet->inet_saddr =3D fl4->saddr;
+	}
+
 	sk_rcv_saddr_set(sk, inet->inet_saddr);
+
+	if (prev_addr_hashbucket) {
+		err =3D inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
+		if (err) {
+			inet->inet_saddr =3D 0;
+			sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
+			ip_rt_put(rt);
+			return err;
+		}
+	}
+
 	inet->inet_dport =3D usin->sin_port;
 	sk_daddr_set(sk, daddr);
=20
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fd44638ec16b..83843aea173c 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -934,8 +934,20 @@ static int dccp_v6_connect(struct sock *sk, struct s=
ockaddr *uaddr,
 	}
=20
 	if (saddr =3D=3D NULL) {
+		struct in6_addr prev_v6_rcv_saddr =3D sk->sk_v6_rcv_saddr;
+		struct inet_bind_hashbucket *prev_addr_hashbucket;
+
+		prev_addr_hashbucket =3D inet_bhashfn_portaddr(&dccp_hashinfo,
+							     sk, sock_net(sk),
+							     inet->inet_num);
 		saddr =3D &fl6.saddr;
 		sk->sk_v6_rcv_saddr =3D *saddr;
+
+		err =3D inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
+		if (err) {
+			sk->sk_v6_rcv_saddr =3D prev_v6_rcv_saddr;
+			goto failure;
+		}
 	}
=20
 	/* set the source address */
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index eb8e128e43e8..f4f2ad5f9c08 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1120,6 +1120,12 @@ static int __init dccp_init(void)
 				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
 	if (!dccp_hashinfo.bind_bucket_cachep)
 		goto out_free_hashinfo2;
+	dccp_hashinfo.bind2_bucket_cachep =3D
+		kmem_cache_create("dccp_bind2_bucket",
+				  sizeof(struct inet_bind2_bucket), 0,
+				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
+	if (!dccp_hashinfo.bind2_bucket_cachep)
+		goto out_free_bind_bucket_cachep;
=20
 	/*
 	 * Size and allocate the main established and bind bucket
@@ -1150,7 +1156,7 @@ static int __init dccp_init(void)
=20
 	if (!dccp_hashinfo.ehash) {
 		DCCP_CRIT("Failed to allocate DCCP established hash table");
-		goto out_free_bind_bucket_cachep;
+		goto out_free_bind2_bucket_cachep;
 	}
=20
 	for (i =3D 0; i <=3D dccp_hashinfo.ehash_mask; i++)
@@ -1176,14 +1182,24 @@ static int __init dccp_init(void)
 		goto out_free_dccp_locks;
 	}
=20
+	dccp_hashinfo.bhash2 =3D (struct inet_bind_hashbucket *)
+		__get_free_pages(GFP_ATOMIC | __GFP_NOWARN, bhash_order);
+
+	if (!dccp_hashinfo.bhash2) {
+		DCCP_CRIT("Failed to allocate DCCP bind2 hash table");
+		goto out_free_dccp_bhash;
+	}
+
 	for (i =3D 0; i < dccp_hashinfo.bhash_size; i++) {
 		spin_lock_init(&dccp_hashinfo.bhash[i].lock);
 		INIT_HLIST_HEAD(&dccp_hashinfo.bhash[i].chain);
+		spin_lock_init(&dccp_hashinfo.bhash2[i].lock);
+		INIT_HLIST_HEAD(&dccp_hashinfo.bhash2[i].chain);
 	}
=20
 	rc =3D dccp_mib_init();
 	if (rc)
-		goto out_free_dccp_bhash;
+		goto out_free_dccp_bhash2;
=20
 	rc =3D dccp_ackvec_init();
 	if (rc)
@@ -1207,30 +1223,38 @@ static int __init dccp_init(void)
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
 	dccp_hashinfo.bhash =3D NULL;
+	dccp_hashinfo.bhash2 =3D NULL;
 	dccp_hashinfo.ehash =3D NULL;
 	dccp_hashinfo.bind_bucket_cachep =3D NULL;
+	dccp_hashinfo.bind2_bucket_cachep =3D NULL;
 	return rc;
 }
=20
 static void __exit dccp_fini(void)
 {
+	int bhash_order =3D get_order(dccp_hashinfo.bhash_size *
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
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index da81f56fdd1c..47b5fa4f8c24 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1218,13 +1218,15 @@ EXPORT_SYMBOL(inet_unregister_protosw);
=20
 static int inet_sk_reselect_saddr(struct sock *sk)
 {
+	struct inet_bind_hashbucket *prev_addr_hashbucket;
 	struct inet_sock *inet =3D inet_sk(sk);
 	__be32 old_saddr =3D inet->inet_saddr;
 	__be32 daddr =3D inet->inet_daddr;
+	struct ip_options_rcu *inet_opt;
 	struct flowi4 *fl4;
 	struct rtable *rt;
 	__be32 new_saddr;
-	struct ip_options_rcu *inet_opt;
+	int err;
=20
 	inet_opt =3D rcu_dereference_protected(inet->inet_opt,
 					     lockdep_sock_is_held(sk));
@@ -1239,20 +1241,33 @@ static int inet_sk_reselect_saddr(struct sock *sk=
)
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
=20
-	sk_setup_caps(sk, &rt->dst);
-
 	new_saddr =3D fl4->saddr;
=20
-	if (new_saddr =3D=3D old_saddr)
+	if (new_saddr =3D=3D old_saddr) {
+		sk_setup_caps(sk, &rt->dst);
 		return 0;
-
-	if (sock_net(sk)->ipv4.sysctl_ip_dynaddr > 1) {
-		pr_info("%s(): shifting inet->saddr from %pI4 to %pI4\n",
-			__func__, &old_saddr, &new_saddr);
 	}
=20
+	prev_addr_hashbucket =3D inet_bhashfn_portaddr(sk->sk_prot->h.hashinfo,
+						     sk, sock_net(sk),
+						     inet->inet_num);
+
 	inet->inet_saddr =3D inet->inet_rcv_saddr =3D new_saddr;
=20
+	err =3D inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
+	if (err) {
+		inet->inet_saddr =3D old_saddr;
+		inet->inet_rcv_saddr =3D old_saddr;
+		ip_rt_put(rt);
+		return err;
+	}
+
+	sk_setup_caps(sk, &rt->dst);
+
+	if (sock_net(sk)->ipv4.sysctl_ip_dynaddr > 1)
+		pr_info("%s(): shifting inet->saddr from %pI4 to %pI4\n",
+			__func__, &old_saddr, &new_saddr);
+
 	/*
 	 * XXX The only one ugly spot where we need to
 	 * XXX really change the sockets identity after
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_s=
ock.c
index 53f5f956d948..182b4059d0b6 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -130,14 +130,75 @@ void inet_get_local_port_range(struct net *net, int=
 *low, int *high)
 }
 EXPORT_SYMBOL(inet_get_local_port_range);
=20
+static bool inet_use_bhash2_on_bind(const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family =3D=3D AF_INET6) {
+		int addr_type =3D ipv6_addr_type(&sk->sk_v6_rcv_saddr);
+
+		return addr_type !=3D IPV6_ADDR_ANY &&
+			addr_type !=3D IPV6_ADDR_MAPPED;
+	}
+#endif
+	return sk->sk_rcv_saddr !=3D htonl(INADDR_ANY);
+}
+
+static bool inet_bind_conflict(const struct sock *sk, struct sock *sk2,
+			       kuid_t sk_uid, bool relax,
+			       bool reuseport_cb_ok, bool reuseport_ok)
+{
+	int bound_dev_if2;
+
+	if (sk =3D=3D sk2)
+		return false;
+
+	bound_dev_if2 =3D READ_ONCE(sk2->sk_bound_dev_if);
+
+	if (!sk->sk_bound_dev_if || !bound_dev_if2 ||
+	    sk->sk_bound_dev_if =3D=3D bound_dev_if2) {
+		if (sk->sk_reuse && sk2->sk_reuse &&
+		    sk2->sk_state !=3D TCP_LISTEN) {
+			if (!relax || (!reuseport_ok && sk->sk_reuseport &&
+				       sk2->sk_reuseport && reuseport_cb_ok &&
+				       (sk2->sk_state =3D=3D TCP_TIME_WAIT ||
+					uid_eq(sk_uid, sock_i_uid(sk2)))))
+				return true;
+		} else if (!reuseport_ok || !sk->sk_reuseport ||
+			   !sk2->sk_reuseport || !reuseport_cb_ok ||
+			   (sk2->sk_state !=3D TCP_TIME_WAIT &&
+			    !uid_eq(sk_uid, sock_i_uid(sk2)))) {
+			return true;
+		}
+	}
+	return false;
+}
+
+static bool inet_bhash2_conflict(const struct sock *sk,
+				 const struct inet_bind2_bucket *tb2,
+				 kuid_t sk_uid,
+				 bool relax, bool reuseport_cb_ok,
+				 bool reuseport_ok)
+{
+	struct sock *sk2;
+
+	sk_for_each_bound_bhash2(sk2, &tb2->owners) {
+		if (sk->sk_family =3D=3D AF_INET && ipv6_only_sock(sk2))
+			continue;
+
+		if (inet_bind_conflict(sk, sk2, sk_uid, relax,
+				       reuseport_cb_ok, reuseport_ok))
+			return true;
+	}
+	return false;
+}
+
+/* This should be called only when the tb and tb2 hashbuckets' locks are=
 held */
 static int inet_csk_bind_conflict(const struct sock *sk,
 				  const struct inet_bind_bucket *tb,
+				  const struct inet_bind2_bucket *tb2, /* may be null */
 				  bool relax, bool reuseport_ok)
 {
-	struct sock *sk2;
 	bool reuseport_cb_ok;
-	bool reuse =3D sk->sk_reuse;
-	bool reuseport =3D !!sk->sk_reuseport;
 	struct sock_reuseport *reuseport_cb;
 	kuid_t uid =3D sock_i_uid((struct sock *)sk);
=20
@@ -150,55 +211,87 @@ static int inet_csk_bind_conflict(const struct sock=
 *sk,
 	/*
 	 * Unlike other sk lookup places we do not check
 	 * for sk_net here, since _all_ the socks listed
-	 * in tb->owners list belong to the same net - the
-	 * one this bucket belongs to.
+	 * in tb->owners and tb2->owners list belong
+	 * to the same net - the one this bucket belongs to.
 	 */
=20
-	sk_for_each_bound(sk2, &tb->owners) {
-		int bound_dev_if2;
+	if (!inet_use_bhash2_on_bind(sk)) {
+		struct sock *sk2;
=20
-		if (sk =3D=3D sk2)
-			continue;
-		bound_dev_if2 =3D READ_ONCE(sk2->sk_bound_dev_if);
-		if ((!sk->sk_bound_dev_if ||
-		     !bound_dev_if2 ||
-		     sk->sk_bound_dev_if =3D=3D bound_dev_if2)) {
-			if (reuse && sk2->sk_reuse &&
-			    sk2->sk_state !=3D TCP_LISTEN) {
-				if ((!relax ||
-				     (!reuseport_ok &&
-				      reuseport && sk2->sk_reuseport &&
-				      reuseport_cb_ok &&
-				      (sk2->sk_state =3D=3D TCP_TIME_WAIT ||
-				       uid_eq(uid, sock_i_uid(sk2))))) &&
-				    inet_rcv_saddr_equal(sk, sk2, true))
-					break;
-			} else if (!reuseport_ok ||
-				   !reuseport || !sk2->sk_reuseport ||
-				   !reuseport_cb_ok ||
-				   (sk2->sk_state !=3D TCP_TIME_WAIT &&
-				    !uid_eq(uid, sock_i_uid(sk2)))) {
-				if (inet_rcv_saddr_equal(sk, sk2, true))
-					break;
-			}
-		}
+		sk_for_each_bound(sk2, &tb->owners)
+			if (inet_bind_conflict(sk, sk2, uid, relax,
+					       reuseport_cb_ok, reuseport_ok) &&
+			    inet_rcv_saddr_equal(sk, sk2, true))
+				return true;
+
+		return false;
+	}
+
+	/* Conflicts with an existing IPV6_ADDR_ANY (if ipv6) or INADDR_ANY (if
+	 * ipv4) should have been checked already. We need to do these two
+	 * checks separately because their spinlocks have to be acquired/releas=
ed
+	 * independently of each other, to prevent possible deadlocks
+	 */
+	return tb2 && inet_bhash2_conflict(sk, tb2, uid, relax, reuseport_cb_ok=
,
+					   reuseport_ok);
+}
+
+/* Determine if there is a bind conflict with an existing IPV6_ADDR_ANY =
(if ipv6) or
+ * INADDR_ANY (if ipv4) socket.
+ *
+ * Caller must hold bhash hashbucket lock with local bh disabled, to pro=
tect
+ * against concurrent binds on the port for addr any
+ */
+static bool inet_bhash2_addr_any_conflict(const struct sock *sk, int por=
t, int l3mdev,
+					  bool relax, bool reuseport_ok)
+{
+	kuid_t uid =3D sock_i_uid((struct sock *)sk);
+	const struct net *net =3D sock_net(sk);
+	struct sock_reuseport *reuseport_cb;
+	struct inet_bind_hashbucket *head2;
+	struct inet_bind2_bucket *tb2;
+	bool reuseport_cb_ok;
+
+	rcu_read_lock();
+	reuseport_cb =3D rcu_dereference(sk->sk_reuseport_cb);
+	/* paired with WRITE_ONCE() in __reuseport_(add|detach)_closed_sock */
+	reuseport_cb_ok =3D !reuseport_cb || READ_ONCE(reuseport_cb->num_closed=
_socks);
+	rcu_read_unlock();
+
+	head2 =3D inet_bhash2_addr_any_hashbucket(sk, net, port);
+
+	spin_lock(&head2->lock);
+
+	inet_bind_bucket_for_each(tb2, &head2->chain)
+		if (inet_bind2_bucket_match_addr_any(tb2, net, port, l3mdev, sk))
+			break;
+
+	if (tb2 && inet_bhash2_conflict(sk, tb2, uid, relax, reuseport_cb_ok,
+					reuseport_ok)) {
+		spin_unlock(&head2->lock);
+		return true;
 	}
-	return sk2 !=3D NULL;
+
+	spin_unlock(&head2->lock);
+	return false;
 }
=20
 /*
- * Find an open port number for the socket.  Returns with the
- * inet_bind_hashbucket lock held.
+ * Find an open port number for the socket. Returns with the
+ * inet_bind_hashbucket locks held if successful.
  */
 static struct inet_bind_hashbucket *
-inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_re=
t, int *port_ret)
+inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket *=
*tb_ret,
+			struct inet_bind2_bucket **tb2_ret,
+			struct inet_bind_hashbucket **head2_ret, int *port_ret)
 {
 	struct inet_hashinfo *hinfo =3D sk->sk_prot->h.hashinfo;
 	int port =3D 0;
-	struct inet_bind_hashbucket *head;
+	struct inet_bind_hashbucket *head, *head2;
 	struct net *net =3D sock_net(sk);
 	bool relax =3D false;
 	int i, low, high, attempt_half;
+	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int l3mdev;
@@ -238,12 +331,23 @@ inet_csk_find_open_port(struct sock *sk, struct ine=
t_bind_bucket **tb_ret, int *
 			continue;
 		head =3D &hinfo->bhash[inet_bhashfn(net, port,
 						  hinfo->bhash_size)];
+		head2 =3D inet_bhashfn_portaddr(hinfo, sk, net, port);
+
 		spin_lock_bh(&head->lock);
+
+		if (inet_use_bhash2_on_bind(sk)) {
+			if (inet_bhash2_addr_any_conflict(sk, port, l3mdev, relax, false))
+				goto next_port;
+		}
+
+		spin_lock(&head2->lock);
+		tb2 =3D inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
 		inet_bind_bucket_for_each(tb, &head->chain)
-			if (net_eq(ib_net(tb), net) && tb->l3mdev =3D=3D l3mdev &&
-			    tb->port =3D=3D port) {
-				if (!inet_csk_bind_conflict(sk, tb, relax, false))
+			if (inet_bind_bucket_match(tb, net, port, l3mdev)) {
+				if (!inet_csk_bind_conflict(sk, tb, tb2,
+							    relax, false))
 					goto success;
+				spin_unlock(&head2->lock);
 				goto next_port;
 			}
 		tb =3D NULL;
@@ -272,6 +376,8 @@ inet_csk_find_open_port(struct sock *sk, struct inet_=
bind_bucket **tb_ret, int *
 success:
 	*port_ret =3D port;
 	*tb_ret =3D tb;
+	*tb2_ret =3D tb2;
+	*head2_ret =3D head2;
 	return head;
 }
=20
@@ -368,53 +474,95 @@ int inet_csk_get_port(struct sock *sk, unsigned sho=
rt snum)
 	bool reuse =3D sk->sk_reuse && sk->sk_state !=3D TCP_LISTEN;
 	struct inet_hashinfo *hinfo =3D sk->sk_prot->h.hashinfo;
 	int ret =3D 1, port =3D snum;
-	struct inet_bind_hashbucket *head;
 	struct net *net =3D sock_net(sk);
+	bool found_port =3D false, check_bind_conflict =3D true;
+	bool bhash_created =3D false, bhash2_created =3D false;
+	struct inet_bind_hashbucket *head, *head2;
+	struct inet_bind2_bucket *tb2 =3D NULL;
 	struct inet_bind_bucket *tb =3D NULL;
+	bool head2_lock_acquired =3D false;
 	int l3mdev;
=20
 	l3mdev =3D inet_sk_bound_l3mdev(sk);
=20
 	if (!port) {
-		head =3D inet_csk_find_open_port(sk, &tb, &port);
+		head =3D inet_csk_find_open_port(sk, &tb, &tb2, &head2, &port);
 		if (!head)
 			return ret;
+
+		head2_lock_acquired =3D true;
+
+		if (tb && tb2)
+			goto success;
+		found_port =3D true;
+	} else {
+		head =3D &hinfo->bhash[inet_bhashfn(net, port,
+						  hinfo->bhash_size)];
+		spin_lock_bh(&head->lock);
+		inet_bind_bucket_for_each(tb, &head->chain)
+			if (inet_bind_bucket_match(tb, net, port, l3mdev))
+				break;
+	}
+
+	if (!tb) {
+		tb =3D inet_bind_bucket_create(hinfo->bind_bucket_cachep, net,
+					     head, port, l3mdev);
 		if (!tb)
-			goto tb_not_found;
-		goto success;
+			goto fail_unlock;
+		bhash_created =3D true;
 	}
-	head =3D &hinfo->bhash[inet_bhashfn(net, port,
-					  hinfo->bhash_size)];
-	spin_lock_bh(&head->lock);
-	inet_bind_bucket_for_each(tb, &head->chain)
-		if (net_eq(ib_net(tb), net) && tb->l3mdev =3D=3D l3mdev &&
-		    tb->port =3D=3D port)
-			goto tb_found;
-tb_not_found:
-	tb =3D inet_bind_bucket_create(hinfo->bind_bucket_cachep,
-				     net, head, port, l3mdev);
-	if (!tb)
-		goto fail_unlock;
-tb_found:
-	if (!hlist_empty(&tb->owners)) {
-		if (sk->sk_reuse =3D=3D SK_FORCE_REUSE)
-			goto success;
=20
-		if ((tb->fastreuse > 0 && reuse) ||
-		    sk_reuseport_match(tb, sk))
-			goto success;
-		if (inet_csk_bind_conflict(sk, tb, true, true))
+	if (!found_port) {
+		if (!hlist_empty(&tb->owners)) {
+			if (sk->sk_reuse =3D=3D SK_FORCE_REUSE ||
+			    (tb->fastreuse > 0 && reuse) ||
+			    sk_reuseport_match(tb, sk))
+				check_bind_conflict =3D false;
+		}
+
+		if (check_bind_conflict && inet_use_bhash2_on_bind(sk)) {
+			if (inet_bhash2_addr_any_conflict(sk, port, l3mdev, true, true))
+				goto fail_unlock;
+		}
+
+		head2 =3D inet_bhashfn_portaddr(hinfo, sk, net, port);
+		spin_lock(&head2->lock);
+		head2_lock_acquired =3D true;
+		tb2 =3D inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
+	}
+
+	if (!tb2) {
+		tb2 =3D inet_bind2_bucket_create(hinfo->bind2_bucket_cachep,
+					       net, head2, port, l3mdev, sk);
+		if (!tb2)
 			goto fail_unlock;
+		bhash2_created =3D true;
 	}
+
+	if (!found_port && check_bind_conflict) {
+		if (inet_csk_bind_conflict(sk, tb, tb2, true, true))
+			goto fail_unlock;
+	}
+
 success:
 	inet_csk_update_fastreuse(tb, sk);
=20
 	if (!inet_csk(sk)->icsk_bind_hash)
-		inet_bind_hash(sk, tb, port);
+		inet_bind_hash(sk, tb, tb2, port);
 	WARN_ON(inet_csk(sk)->icsk_bind_hash !=3D tb);
+	WARN_ON(inet_csk(sk)->icsk_bind2_hash !=3D tb2);
 	ret =3D 0;
=20
 fail_unlock:
+	if (ret) {
+		if (bhash_created)
+			inet_bind_bucket_destroy(hinfo->bind_bucket_cachep, tb);
+		if (bhash2_created)
+			inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep,
+						  tb2);
+	}
+	if (head2_lock_acquired)
+		spin_unlock(&head2->lock);
 	spin_unlock_bh(&head->lock);
 	return ret;
 }
@@ -961,6 +1109,7 @@ struct sock *inet_csk_clone_lock(const struct sock *=
sk,
=20
 		inet_sk_set_state(newsk, TCP_SYN_RECV);
 		newicsk->icsk_bind_hash =3D NULL;
+		newicsk->icsk_bind2_hash =3D NULL;
=20
 		inet_sk(newsk)->inet_dport =3D inet_rsk(req)->ir_rmt_port;
 		inet_sk(newsk)->inet_num =3D inet_rsk(req)->ir_num;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index b9d995b5ce24..d9780f4f3ca2 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -92,12 +92,75 @@ void inet_bind_bucket_destroy(struct kmem_cache *cach=
ep, struct inet_bind_bucket
 	}
 }
=20
+bool inet_bind_bucket_match(const struct inet_bind_bucket *tb, const str=
uct net *net,
+			    unsigned short port, int l3mdev)
+{
+	return net_eq(ib_net(tb), net) && tb->port =3D=3D port &&
+		tb->l3mdev =3D=3D l3mdev;
+}
+
+static void inet_bind2_bucket_init(struct inet_bind2_bucket *tb,
+				   struct net *net,
+				   struct inet_bind_hashbucket *head,
+				   unsigned short port, int l3mdev,
+				   const struct sock *sk)
+{
+	write_pnet(&tb->ib_net, net);
+	tb->l3mdev    =3D l3mdev;
+	tb->port      =3D port;
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family =3D=3D AF_INET6)
+		tb->v6_rcv_saddr =3D sk->sk_v6_rcv_saddr;
+	else
+#endif
+		tb->rcv_saddr =3D sk->sk_rcv_saddr;
+	INIT_HLIST_HEAD(&tb->owners);
+	hlist_add_head(&tb->node, &head->chain);
+}
+
+struct inet_bind2_bucket *inet_bind2_bucket_create(struct kmem_cache *ca=
chep,
+						   struct net *net,
+						   struct inet_bind_hashbucket *head,
+						   unsigned short port,
+						   int l3mdev,
+						   const struct sock *sk)
+{
+	struct inet_bind2_bucket *tb =3D kmem_cache_alloc(cachep, GFP_ATOMIC);
+
+	if (tb)
+		inet_bind2_bucket_init(tb, net, head, port, l3mdev, sk);
+
+	return tb;
+}
+
+/* Caller must hold hashbucket lock for this tb with local BH disabled *=
/
+void inet_bind2_bucket_destroy(struct kmem_cache *cachep, struct inet_bi=
nd2_bucket *tb)
+{
+	if (hlist_empty(&tb->owners)) {
+		__hlist_del(&tb->node);
+		kmem_cache_free(cachep, tb);
+	}
+}
+
+static bool inet_bind2_bucket_addr_match(const struct inet_bind2_bucket =
*tb2,
+					 const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family =3D=3D AF_INET6)
+		return ipv6_addr_equal(&tb2->v6_rcv_saddr,
+				       &sk->sk_v6_rcv_saddr);
+#endif
+	return tb2->rcv_saddr =3D=3D sk->sk_rcv_saddr;
+}
+
 void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
-		    const unsigned short snum)
+		    struct inet_bind2_bucket *tb2, unsigned short port)
 {
-	inet_sk(sk)->inet_num =3D snum;
+	inet_sk(sk)->inet_num =3D port;
 	sk_add_bind_node(sk, &tb->owners);
 	inet_csk(sk)->icsk_bind_hash =3D tb;
+	sk_add_bind2_node(sk, &tb2->owners);
+	inet_csk(sk)->icsk_bind2_hash =3D tb2;
 }
=20
 /*
@@ -109,6 +172,10 @@ static void __inet_put_port(struct sock *sk)
 	const int bhash =3D inet_bhashfn(sock_net(sk), inet_sk(sk)->inet_num,
 			hashinfo->bhash_size);
 	struct inet_bind_hashbucket *head =3D &hashinfo->bhash[bhash];
+	struct inet_bind_hashbucket *head2 =3D
+		inet_bhashfn_portaddr(hashinfo, sk, sock_net(sk),
+				      inet_sk(sk)->inet_num);
+	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
=20
 	spin_lock(&head->lock);
@@ -117,6 +184,16 @@ static void __inet_put_port(struct sock *sk)
 	inet_csk(sk)->icsk_bind_hash =3D NULL;
 	inet_sk(sk)->inet_num =3D 0;
 	inet_bind_bucket_destroy(hashinfo->bind_bucket_cachep, tb);
+
+	spin_lock(&head2->lock);
+	if (inet_csk(sk)->icsk_bind2_hash) {
+		tb2 =3D inet_csk(sk)->icsk_bind2_hash;
+		__sk_del_bind2_node(sk);
+		inet_csk(sk)->icsk_bind2_hash =3D NULL;
+		inet_bind2_bucket_destroy(hashinfo->bind2_bucket_cachep, tb2);
+	}
+	spin_unlock(&head2->lock);
+
 	spin_unlock(&head->lock);
 }
=20
@@ -133,14 +210,23 @@ int __inet_inherit_port(const struct sock *sk, stru=
ct sock *child)
 	struct inet_hashinfo *table =3D sk->sk_prot->h.hashinfo;
 	unsigned short port =3D inet_sk(child)->inet_num;
 	const int bhash =3D inet_bhashfn(sock_net(sk), port,
-			table->bhash_size);
+				       table->bhash_size);
 	struct inet_bind_hashbucket *head =3D &table->bhash[bhash];
+	struct inet_bind_hashbucket *head2 =3D
+		inet_bhashfn_portaddr(table, child, sock_net(sk), port);
+	bool created_inet_bind_bucket =3D false;
+	bool update_fastreuse =3D false;
+	struct net *net =3D sock_net(sk);
+	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
 	int l3mdev;
=20
 	spin_lock(&head->lock);
+	spin_lock(&head2->lock);
 	tb =3D inet_csk(sk)->icsk_bind_hash;
-	if (unlikely(!tb)) {
+	tb2 =3D inet_csk(sk)->icsk_bind2_hash;
+	if (unlikely(!tb || !tb2)) {
+		spin_unlock(&head2->lock);
 		spin_unlock(&head->lock);
 		return -ENOENT;
 	}
@@ -153,25 +239,49 @@ int __inet_inherit_port(const struct sock *sk, stru=
ct sock *child)
 		 * as that of the child socket. We have to look up or
 		 * create a new bind bucket for the child here. */
 		inet_bind_bucket_for_each(tb, &head->chain) {
-			if (net_eq(ib_net(tb), sock_net(sk)) &&
-			    tb->l3mdev =3D=3D l3mdev && tb->port =3D=3D port)
+			if (inet_bind_bucket_match(tb, net, port, l3mdev))
 				break;
 		}
 		if (!tb) {
 			tb =3D inet_bind_bucket_create(table->bind_bucket_cachep,
-						     sock_net(sk), head, port,
-						     l3mdev);
+						     net, head, port, l3mdev);
 			if (!tb) {
+				spin_unlock(&head2->lock);
 				spin_unlock(&head->lock);
 				return -ENOMEM;
 			}
+			created_inet_bind_bucket =3D true;
+		}
+		update_fastreuse =3D true;
+
+		goto bhash2_find;
+	} else if (!inet_bind2_bucket_addr_match(tb2, child)) {
+		l3mdev =3D inet_sk_bound_l3mdev(sk);
+
+bhash2_find:
+		tb2 =3D inet_bind2_bucket_find(head2, net, port, l3mdev, child);
+		if (!tb2) {
+			tb2 =3D inet_bind2_bucket_create(table->bind2_bucket_cachep,
+						       net, head2, port,
+						       l3mdev, child);
+			if (!tb2)
+				goto error;
 		}
-		inet_csk_update_fastreuse(tb, child);
 	}
-	inet_bind_hash(child, tb, port);
+	if (update_fastreuse)
+		inet_csk_update_fastreuse(tb, child);
+	inet_bind_hash(child, tb, tb2, port);
+	spin_unlock(&head2->lock);
 	spin_unlock(&head->lock);
=20
 	return 0;
+
+error:
+	if (created_inet_bind_bucket)
+		inet_bind_bucket_destroy(table->bind_bucket_cachep, tb);
+	spin_unlock(&head2->lock);
+	spin_unlock(&head->lock);
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(__inet_inherit_port);
=20
@@ -675,6 +785,112 @@ void inet_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
=20
+static bool inet_bind2_bucket_match(const struct inet_bind2_bucket *tb,
+				    const struct net *net, unsigned short port,
+				    int l3mdev, const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family =3D=3D AF_INET6)
+		return net_eq(ib2_net(tb), net) && tb->port =3D=3D port &&
+			tb->l3mdev =3D=3D l3mdev &&
+			ipv6_addr_equal(&tb->v6_rcv_saddr, &sk->sk_v6_rcv_saddr);
+	else
+#endif
+		return net_eq(ib2_net(tb), net) && tb->port =3D=3D port &&
+			tb->l3mdev =3D=3D l3mdev && tb->rcv_saddr =3D=3D sk->sk_rcv_saddr;
+}
+
+bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb=
, const struct net *net,
+				      unsigned short port, int l3mdev, const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr addr_any =3D {};
+
+	if (sk->sk_family =3D=3D AF_INET6)
+		return net_eq(ib2_net(tb), net) && tb->port =3D=3D port &&
+			tb->l3mdev =3D=3D l3mdev &&
+			ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
+	else
+#endif
+		return net_eq(ib2_net(tb), net) && tb->port =3D=3D port &&
+			tb->l3mdev =3D=3D l3mdev && tb->rcv_saddr =3D=3D 0;
+}
+
+/* The socket's bhash2 hashbucket spinlock must be held when this is cal=
led */
+struct inet_bind2_bucket *
+inet_bind2_bucket_find(const struct inet_bind_hashbucket *head, const st=
ruct net *net,
+		       unsigned short port, int l3mdev, const struct sock *sk)
+{
+	struct inet_bind2_bucket *bhash2 =3D NULL;
+
+	inet_bind_bucket_for_each(bhash2, &head->chain)
+		if (inet_bind2_bucket_match(bhash2, net, port, l3mdev, sk))
+			break;
+
+	return bhash2;
+}
+
+struct inet_bind_hashbucket *
+inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net =
*net, int port)
+{
+	struct inet_hashinfo *hinfo =3D sk->sk_prot->h.hashinfo;
+	u32 hash;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr addr_any =3D {};
+
+	if (sk->sk_family =3D=3D AF_INET6)
+		hash =3D ipv6_portaddr_hash(net, &addr_any, port);
+	else
+#endif
+		hash =3D ipv4_portaddr_hash(net, 0, port);
+
+	return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
+}
+
+int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, st=
ruct sock *sk)
+{
+	struct inet_hashinfo *hinfo =3D sk->sk_prot->h.hashinfo;
+	struct inet_bind_hashbucket *head, *head2;
+	struct inet_bind2_bucket *tb2, *new_tb2;
+	int l3mdev =3D inet_sk_bound_l3mdev(sk);
+	int port =3D inet_sk(sk)->inet_num;
+	struct net *net =3D sock_net(sk);
+
+	/* Allocate a bind2 bucket ahead of time to avoid permanently putting
+	 * the bhash2 table in an inconsistent state if a new tb2 bucket
+	 * allocation fails.
+	 */
+	new_tb2 =3D kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
+	if (!new_tb2)
+		return -ENOMEM;
+
+	head =3D &hinfo->bhash[inet_bhashfn(net, port,
+					  hinfo->bhash_size)];
+	head2 =3D inet_bhashfn_portaddr(hinfo, sk, net, port);
+
+	spin_lock_bh(&prev_saddr->lock);
+	__sk_del_bind2_node(sk);
+	inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep,
+				  inet_csk(sk)->icsk_bind2_hash);
+	spin_unlock_bh(&prev_saddr->lock);
+
+	spin_lock_bh(&head2->lock);
+	tb2 =3D inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
+	if (!tb2) {
+		tb2 =3D new_tb2;
+		inet_bind2_bucket_init(tb2, net, head2, port, l3mdev, sk);
+	}
+	sk_add_bind2_node(sk, &tb2->owners);
+	inet_csk(sk)->icsk_bind2_hash =3D tb2;
+	spin_unlock_bh(&head2->lock);
+
+	if (tb2 !=3D new_tb2)
+		kmem_cache_free(hinfo->bind2_bucket_cachep, new_tb2);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
+
 /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
@@ -689,16 +905,19 @@ EXPORT_SYMBOL_GPL(inet_unhash);
 static u32 *table_perturb;
=20
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u64 port_offset,
-		int (*check_established)(struct inet_timewait_death_row *,
-			struct sock *, __u16, struct inet_timewait_sock **))
+			struct sock *sk, u64 port_offset,
+			int (*check_established)(struct inet_timewait_death_row *,
+						 struct sock *, __u16,
+						 struct inet_timewait_sock **))
 {
 	struct inet_hashinfo *hinfo =3D death_row->hashinfo;
+	struct inet_bind_hashbucket *head, *head2;
 	struct inet_timewait_sock *tw =3D NULL;
-	struct inet_bind_hashbucket *head;
 	int port =3D inet_sk(sk)->inet_num;
 	struct net *net =3D sock_net(sk);
+	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
+	bool tb_created =3D false;
 	u32 remaining, offset;
 	int ret, i, low, high;
 	int l3mdev;
@@ -755,8 +974,7 @@ int __inet_hash_connect(struct inet_timewait_death_ro=
w *death_row,
 		 * the established check is already unique enough.
 		 */
 		inet_bind_bucket_for_each(tb, &head->chain) {
-			if (net_eq(ib_net(tb), net) && tb->l3mdev =3D=3D l3mdev &&
-			    tb->port =3D=3D port) {
+			if (inet_bind_bucket_match(tb, net, port, l3mdev)) {
 				if (tb->fastreuse >=3D 0 ||
 				    tb->fastreuseport >=3D 0)
 					goto next_port;
@@ -774,6 +992,7 @@ int __inet_hash_connect(struct inet_timewait_death_ro=
w *death_row,
 			spin_unlock_bh(&head->lock);
 			return -ENOMEM;
 		}
+		tb_created =3D true;
 		tb->fastreuse =3D -1;
 		tb->fastreuseport =3D -1;
 		goto ok;
@@ -789,6 +1008,20 @@ int __inet_hash_connect(struct inet_timewait_death_=
row *death_row,
 	return -EADDRNOTAVAIL;
=20
 ok:
+	/* Find the corresponding tb2 bucket since we need to
+	 * add the socket to the bhash2 table as well
+	 */
+	head2 =3D inet_bhashfn_portaddr(hinfo, sk, net, port);
+	spin_lock(&head2->lock);
+
+	tb2 =3D inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
+	if (!tb2) {
+		tb2 =3D inet_bind2_bucket_create(hinfo->bind2_bucket_cachep, net,
+					       head2, port, l3mdev, sk);
+		if (!tb2)
+			goto error;
+	}
+
 	/* Here we want to add a little bit of randomness to the next source
 	 * port that will be chosen. We use a max() with a random here so that
 	 * on low contention the randomness is maximal and on high contention
@@ -798,7 +1031,10 @@ int __inet_hash_connect(struct inet_timewait_death_=
row *death_row,
 	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + =
2);
=20
 	/* Head lock still held and bh's disabled */
-	inet_bind_hash(sk, tb, port);
+	inet_bind_hash(sk, tb, tb2, port);
+
+	spin_unlock(&head2->lock);
+
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport =3D htons(port);
 		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
@@ -810,6 +1046,13 @@ int __inet_hash_connect(struct inet_timewait_death_=
row *death_row,
 		inet_twsk_deschedule_put(tw);
 	local_bh_enable();
 	return 0;
+
+error:
+	spin_unlock(&head2->lock);
+	if (tb_created)
+		inet_bind_bucket_destroy(hinfo->bind_bucket_cachep, tb);
+	spin_unlock_bh(&head->lock);
+	return -ENOMEM;
 }
=20
 /*
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f7309452bdce..445713a7b1f6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4625,6 +4625,12 @@ void __init tcp_init(void)
 				  SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				  SLAB_ACCOUNT,
 				  NULL);
+	tcp_hashinfo.bind2_bucket_cachep =3D
+		kmem_cache_create("tcp_bind2_bucket",
+				  sizeof(struct inet_bind2_bucket), 0,
+				  SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				  SLAB_ACCOUNT,
+				  NULL);
=20
 	/* Size and allocate the main established and bind bucket
 	 * hash tables.
@@ -4648,7 +4654,7 @@ void __init tcp_init(void)
 		panic("TCP: failed to alloc ehash_locks");
 	tcp_hashinfo.bhash =3D
 		alloc_large_system_hash("TCP bind",
-					sizeof(struct inet_bind_hashbucket),
+					2 * sizeof(struct inet_bind_hashbucket),
 					tcp_hashinfo.ehash_mask + 1,
 					17, /* one slot per 128 KB of memory */
 					0,
@@ -4657,9 +4663,12 @@ void __init tcp_init(void)
 					0,
 					64 * 1024);
 	tcp_hashinfo.bhash_size =3D 1U << tcp_hashinfo.bhash_size;
+	tcp_hashinfo.bhash2 =3D tcp_hashinfo.bhash + tcp_hashinfo.bhash_size;
 	for (i =3D 0; i < tcp_hashinfo.bhash_size; i++) {
 		spin_lock_init(&tcp_hashinfo.bhash[i].lock);
 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash[i].chain);
+		spin_lock_init(&tcp_hashinfo.bhash2[i].lock);
+		INIT_HLIST_HEAD(&tcp_hashinfo.bhash2[i].chain);
 	}
=20
=20
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fda811a5251f..ce090f8b1ff1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -200,10 +200,11 @@ static int tcp_v4_pre_connect(struct sock *sk, stru=
ct sockaddr *uaddr,
 int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len=
)
 {
 	struct sockaddr_in *usin =3D (struct sockaddr_in *)uaddr;
+	struct inet_bind_hashbucket *prev_addr_hashbucket =3D NULL;
+	__be32 daddr, nexthop, prev_sk_rcv_saddr;
 	struct inet_sock *inet =3D inet_sk(sk);
 	struct tcp_sock *tp =3D tcp_sk(sk);
 	__be16 orig_sport, orig_dport;
-	__be32 daddr, nexthop;
 	struct flowi4 *fl4;
 	struct rtable *rt;
 	int err;
@@ -246,10 +247,26 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr=
 *uaddr, int addr_len)
 	if (!inet_opt || !inet_opt->opt.srr)
 		daddr =3D fl4->daddr;
=20
-	if (!inet->inet_saddr)
+	if (!inet->inet_saddr) {
+		prev_addr_hashbucket =3D inet_bhashfn_portaddr(&tcp_hashinfo,
+							     sk, sock_net(sk),
+							     inet->inet_num);
+		prev_sk_rcv_saddr =3D sk->sk_rcv_saddr;
 		inet->inet_saddr =3D fl4->saddr;
+	}
+
 	sk_rcv_saddr_set(sk, inet->inet_saddr);
=20
+	if (prev_addr_hashbucket) {
+		err =3D inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
+		if (err) {
+			inet->inet_saddr =3D 0;
+			sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
+			ip_rt_put(rt);
+			return err;
+		}
+	}
+
 	if (tp->rx_opt.ts_recent_stamp && inet->inet_daddr !=3D daddr) {
 		/* Reset inherited state */
 		tp->rx_opt.ts_recent	   =3D 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c72448ba6dc9..7bae85070f89 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -287,8 +287,20 @@ static int tcp_v6_connect(struct sock *sk, struct so=
ckaddr *uaddr,
 	}
=20
 	if (!saddr) {
+		struct in6_addr prev_v6_rcv_saddr =3D sk->sk_v6_rcv_saddr;
+		struct inet_bind_hashbucket *prev_addr_hashbucket;
+
+		prev_addr_hashbucket =3D inet_bhashfn_portaddr(&tcp_hashinfo,
+							     sk, sock_net(sk),
+							     inet->inet_num);
 		saddr =3D &fl6.saddr;
 		sk->sk_v6_rcv_saddr =3D *saddr;
+
+		err =3D inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
+		if (err) {
+			sk->sk_v6_rcv_saddr =3D prev_v6_rcv_saddr;
+			goto failure;
+		}
 	}
=20
 	/* set the source address */
--=20
2.30.2

