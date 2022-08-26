Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738EC5A1D84
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244370AbiHZAHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244258AbiHZAHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:07:10 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B89C8758;
        Thu, 25 Aug 2022 17:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472428; x=1693008428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ExxTcEOovOLbdm9ksRNZF0KUpVQPopwrCz4poYm3Kdo=;
  b=ftTp6tQmfi17PkdwxJHt6yViYyG+CQVVgnebjHnbCs9xw5s+vX0W2zTM
   h1izofMz0Rb86Sqe7lyYMXHF74pHK73qYcMGlwywcbpAH+yUq2gWR4pSG
   y/p6c09qxod3QJVjt7tJUmeSJXY07Jlmy4uskbbOdlfv1PV2r5RgGXoRQ
   s=;
X-IronPort-AV: E=Sophos;i="5.93,264,1654560000"; 
   d="scan'208";a="123539198"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:07:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 54F854541F;
        Fri, 26 Aug 2022 00:07:07 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:07:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:07:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 net-next 06/13] tcp: Set NULL to sk->sk_prot->h.hashinfo.
Date:   Thu, 25 Aug 2022 17:04:38 -0700
Message-ID: <20220826000445.46552-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will soon introduce an optional per-netns ehash.

This means we cannot use the global sk->sk_prot->h.hashinfo
to fetch a TCP hashinfo.

Instead, set NULL to sk->sk_prot->h.hashinfo for TCP and get
a proper hashinfo from net->ipv4.tcp_death_row->hashinfo.

Note that we need not use sk->sk_prot->h.hashinfo if DCCP is
disabled.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/inet_hashtables.h   | 10 ++++++++++
 net/ipv4/af_inet.c              |  2 +-
 net/ipv4/inet_connection_sock.c |  6 +++---
 net/ipv4/inet_hashtables.c      | 14 +++++++-------
 net/ipv4/tcp_ipv4.c             |  2 +-
 net/ipv6/tcp_ipv6.c             |  2 +-
 6 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 44a419b9e3d5..2c866112433e 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -170,6 +170,16 @@ struct inet_hashinfo {
 	struct inet_listen_hashbucket	*lhash2;
 };
 
+static inline struct inet_hashinfo *inet_get_hashinfo(const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IP_DCCP)
+	return sk->sk_prot->h.hashinfo ? :
+		sock_net(sk)->ipv4.tcp_death_row->hashinfo;
+#else
+	return sock_net(sk)->ipv4.tcp_death_row->hashinfo;
+#endif
+}
+
 static inline struct inet_listen_hashbucket *
 inet_lhash2_bucket(struct inet_hashinfo *h, u32 hash)
 {
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d3ab1ae32ef5..6d81d98a34ca 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1250,7 +1250,7 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	}
 
 	prev_addr_hashbucket =
-		inet_bhashfn_portaddr(sk->sk_prot->h.hashinfo, sk,
+		inet_bhashfn_portaddr(inet_get_hashinfo(sk), sk,
 				      sock_net(sk), inet->inet_num);
 
 	inet->inet_saddr = inet->inet_rcv_saddr = new_saddr;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 8e71d65cfad4..9e3613da3e57 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -285,7 +285,7 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
 			struct inet_bind2_bucket **tb2_ret,
 			struct inet_bind_hashbucket **head2_ret, int *port_ret)
 {
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hinfo = inet_get_hashinfo(sk);
 	int i, low, high, attempt_half, port, l3mdev;
 	struct inet_bind_hashbucket *head, *head2;
 	struct net *net = sock_net(sk);
@@ -468,7 +468,7 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
 int inet_csk_get_port(struct sock *sk, unsigned short snum)
 {
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hinfo = inet_get_hashinfo(sk);
 	bool found_port = false, check_bind_conflict = true;
 	bool bhash_created = false, bhash2_created = false;
 	struct inet_bind_hashbucket *head, *head2;
@@ -910,7 +910,7 @@ static bool reqsk_queue_unlink(struct request_sock *req)
 	bool found = false;
 
 	if (sk_hashed(sk)) {
-		struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+		struct inet_hashinfo *hashinfo = inet_get_hashinfo(sk);
 		spinlock_t *lock;
 
 		lock = inet_ehash_lockp(hashinfo, req->rsk_hash);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 29dce78de179..23bfff989be6 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -168,7 +168,7 @@ void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
  */
 static void __inet_put_port(struct sock *sk)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hashinfo = inet_get_hashinfo(sk);
 	struct inet_bind_hashbucket *head, *head2;
 	struct net *net = sock_net(sk);
 	struct inet_bind_bucket *tb;
@@ -208,7 +208,7 @@ EXPORT_SYMBOL(inet_put_port);
 
 int __inet_inherit_port(const struct sock *sk, struct sock *child)
 {
-	struct inet_hashinfo *table = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *table = inet_get_hashinfo(sk);
 	unsigned short port = inet_sk(child)->inet_num;
 	struct inet_bind_hashbucket *head, *head2;
 	bool created_inet_bind_bucket = false;
@@ -629,7 +629,7 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
  */
 bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hashinfo = inet_get_hashinfo(sk);
 	struct inet_ehash_bucket *head;
 	struct hlist_nulls_head *list;
 	spinlock_t *lock;
@@ -701,7 +701,7 @@ static int inet_reuseport_add_sock(struct sock *sk,
 
 int __inet_hash(struct sock *sk, struct sock *osk)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hashinfo = inet_get_hashinfo(sk);
 	struct inet_listen_hashbucket *ilb2;
 	int err = 0;
 
@@ -747,7 +747,7 @@ EXPORT_SYMBOL_GPL(inet_hash);
 
 void inet_unhash(struct sock *sk)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hashinfo = inet_get_hashinfo(sk);
 
 	if (sk_unhashed(sk))
 		return;
@@ -834,7 +834,7 @@ inet_bind2_bucket_find(const struct inet_bind_hashbucket *head, const struct net
 struct inet_bind_hashbucket *
 inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, int port)
 {
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hinfo = inet_get_hashinfo(sk);
 	u32 hash;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr addr_any = {};
@@ -850,7 +850,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
 
 int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
 {
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hinfo = inet_get_hashinfo(sk);
 	struct inet_bind2_bucket *tb2, *new_tb2;
 	int l3mdev = inet_sk_bound_l3mdev(sk);
 	struct inet_bind_hashbucket *head2;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 61a9bf661814..7c3b3ce85a5e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3083,7 +3083,7 @@ struct proto tcp_prot = {
 	.slab_flags		= SLAB_TYPESAFE_BY_RCU,
 	.twsk_prot		= &tcp_timewait_sock_ops,
 	.rsk_prot		= &tcp_request_sock_ops,
-	.h.hashinfo		= &tcp_hashinfo,
+	.h.hashinfo		= NULL,
 	.no_autobind		= true,
 	.diag_destroy		= tcp_abort,
 };
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index ff5c4fc135fc..791f24da9212 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2193,7 +2193,7 @@ struct proto tcpv6_prot = {
 	.slab_flags		= SLAB_TYPESAFE_BY_RCU,
 	.twsk_prot		= &tcp6_timewait_sock_ops,
 	.rsk_prot		= &tcp6_request_sock_ops,
-	.h.hashinfo		= &tcp_hashinfo,
+	.h.hashinfo		= NULL,
 	.no_autobind		= true,
 	.diag_destroy		= tcp_abort,
 };
-- 
2.30.2

