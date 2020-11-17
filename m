Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3044C2B5BEE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgKQJld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:41:33 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:35108 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQJlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:41:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605606090; x=1637142090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=t9UMtEM+NwbJ05gHATdIGVFgiZ8G6C5NenHPztMgsX0=;
  b=UG3TcgUtfgoEgPwiGZcZOiE36n+b94DuGIzFpWnAp/mOfNhmpoJ2Hze3
   cjWM+T1Obq1ElrqlYBr+tbOUTB+/sK8XiXC37Qr7cAPPn5BBJ6CvXmFvX
   tPO2VtTdPRuEAeHb3A8bS7PSbdwDgc3YLeu4pycZHErrPYp4XnJn98Kn7
   w=;
X-IronPort-AV: E=Sophos;i="5.77,485,1596499200"; 
   d="scan'208";a="96088317"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 17 Nov 2020 09:41:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id E77A1C077D;
        Tue, 17 Nov 2020 09:41:27 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:41:27 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.237) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:41:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH bpf-next 2/8] tcp: Keep TCP_CLOSE sockets in the reuseport group.
Date:   Tue, 17 Nov 2020 18:40:17 +0900
Message-ID: <20201117094023.3685-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201117094023.3685-1-kuniyu@amazon.co.jp>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a preparation patch to migrate incoming connections in the
later commits and adds two fields (migrate_req and num_closed_socks) to the
struct sock_reuseport to keep TCP_CLOSE sockets in the reuseport group.

If migrate_req is 1, and then we close a listening socket, we can migrate
its connections to another listener in the same reuseport group. Then we
have to handle two kinds of child sockets. One is that a listening socket
has a reference to, and the other is not.

The former is the TCP_ESTABLISHED/TCP_SYN_RECV sockets, and they are in the
accept queue of their listening socket. So we can pop them out and push
them into another listener's queue at close() or shutdown() syscalls. On
the other hand, the latter, the TCP_NEW_SYN_RECV socket is during the
three-way handshake and not in the accept queue. Thus, we cannot access
such sockets at close() or shutdown() syscalls. Accordingly, we have to
migrate immature sockets after their listening socket has been closed.

Currently, if their listening socket has been closed, TCP_NEW_SYN_RECV
sockets are freed at receiving the final ACK or retransmitting SYN+ACKs. At
that time, if we could select a new listener from the same reuseport group,
no connection would be aborted. However, it is impossible because
reuseport_detach_sock() sets NULL to sk_reuseport_cb and forbids access to
the reuseport group from closed sockets.

This patch allows TCP_CLOSE sockets to remain in the reuseport group and to
have access to it while any child socket references to them. The point is
that reuseport_detach_sock() is called twice from inet_unhash() and
sk_destruct(). At first, it moves the socket backwards in socks[] and
increments num_closed_socks. Later, when all migrated connections are
accepted, it removes the socket from socks[], decrements num_closed_socks,
and sets NULL to sk_reuseport_cb.

By this change, closed sockets can keep sk_reuseport_cb until all child
requests have been freed or accepted. Consequently calling listen() after
shutdown() can cause EADDRINUSE or EBUSY in reuseport_add_sock() or
inet_csk_bind_conflict() which expect that such sockets should not have the
reuseport group. Therefore, this patch loosens such validation rules so
that the socket can listen again if it has the same reuseport group with
other listening sockets.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/sock_reuseport.h    |  6 ++-
 net/core/sock_reuseport.c       | 83 +++++++++++++++++++++++++++------
 net/ipv4/inet_connection_sock.c |  7 ++-
 3 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 505f1e18e9bf..ade3af55c91f 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -13,8 +13,9 @@ extern spinlock_t reuseport_lock;
 struct sock_reuseport {
 	struct rcu_head		rcu;
 
-	u16			max_socks;	/* length of socks */
-	u16			num_socks;	/* elements in socks */
+	u16			max_socks;		/* length of socks */
+	u16			num_socks;		/* elements in socks */
+	u16			num_closed_socks;	/* closed elements in socks */
 	/* The last synq overflow event timestamp of this
 	 * reuse->socks[] group.
 	 */
@@ -23,6 +24,7 @@ struct sock_reuseport {
 	unsigned int		reuseport_id;
 	unsigned int		bind_inany:1;
 	unsigned int		has_conns:1;
+	unsigned int		migrate_req:1;
 	struct bpf_prog __rcu	*prog;		/* optional BPF sock selector */
 	struct sock		*socks[];	/* array of sock pointers */
 };
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index bbdd3c7b6cb5..01a8b4ba39d7 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -36,6 +36,7 @@ static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
 int reuseport_alloc(struct sock *sk, bool bind_inany)
 {
 	struct sock_reuseport *reuse;
+	struct net *net = sock_net(sk);
 	int id, ret = 0;
 
 	/* bh lock used since this function call may precede hlist lock in
@@ -75,6 +76,8 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
 	reuse->socks[0] = sk;
 	reuse->num_socks = 1;
 	reuse->bind_inany = bind_inany;
+	reuse->migrate_req = sk->sk_protocol == IPPROTO_TCP ?
+		net->ipv4.sysctl_tcp_migrate_req : 0;
 	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
 
 out:
@@ -98,16 +101,22 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 		return NULL;
 
 	more_reuse->num_socks = reuse->num_socks;
+	more_reuse->num_closed_socks = reuse->num_closed_socks;
 	more_reuse->prog = reuse->prog;
 	more_reuse->reuseport_id = reuse->reuseport_id;
 	more_reuse->bind_inany = reuse->bind_inany;
 	more_reuse->has_conns = reuse->has_conns;
+	more_reuse->migrate_req = reuse->migrate_req;
+	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
 
 	memcpy(more_reuse->socks, reuse->socks,
 	       reuse->num_socks * sizeof(struct sock *));
-	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
+	memcpy(more_reuse->socks +
+	       (more_reuse->max_socks - more_reuse->num_closed_socks),
+	       reuse->socks + reuse->num_socks,
+	       reuse->num_closed_socks * sizeof(struct sock *));
 
-	for (i = 0; i < reuse->num_socks; ++i)
+	for (i = 0; i < reuse->max_socks; ++i)
 		rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
 				   more_reuse);
 
@@ -129,6 +138,25 @@ static void reuseport_free_rcu(struct rcu_head *head)
 	kfree(reuse);
 }
 
+static int reuseport_sock_index(struct sock_reuseport *reuse, struct sock *sk,
+				bool closed)
+{
+	int left, right;
+
+	if (!closed) {
+		left = 0;
+		right = reuse->num_socks;
+	} else {
+		left = reuse->max_socks - reuse->num_closed_socks;
+		right = reuse->max_socks;
+	}
+
+	for (; left < right; left++)
+		if (reuse->socks[left] == sk)
+			return left;
+	return -1;
+}
+
 /**
  *  reuseport_add_sock - Add a socket to the reuseport group of another.
  *  @sk:  New socket to add to the group.
@@ -153,12 +181,23 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 					  lockdep_is_held(&reuseport_lock));
 	old_reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 					     lockdep_is_held(&reuseport_lock));
-	if (old_reuse && old_reuse->num_socks != 1) {
+
+	if (old_reuse == reuse) {
+		int i = reuseport_sock_index(reuse, sk, true);
+
+		if (i == -1) {
+			spin_unlock_bh(&reuseport_lock);
+			return -EBUSY;
+		}
+
+		reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
+		reuse->num_closed_socks--;
+	} else if (old_reuse && old_reuse->num_socks != 1) {
 		spin_unlock_bh(&reuseport_lock);
 		return -EBUSY;
 	}
 
-	if (reuse->num_socks == reuse->max_socks) {
+	if (reuse->num_socks + reuse->num_closed_socks == reuse->max_socks) {
 		reuse = reuseport_grow(reuse);
 		if (!reuse) {
 			spin_unlock_bh(&reuseport_lock);
@@ -174,8 +213,9 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 
 	spin_unlock_bh(&reuseport_lock);
 
-	if (old_reuse)
+	if (old_reuse && old_reuse != reuse)
 		call_rcu(&old_reuse->rcu, reuseport_free_rcu);
+
 	return 0;
 }
 EXPORT_SYMBOL(reuseport_add_sock);
@@ -199,17 +239,34 @@ void reuseport_detach_sock(struct sock *sk)
 	 */
 	bpf_sk_reuseport_detach(sk);
 
-	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
+	if (!reuse->migrate_req || sk->sk_state == TCP_LISTEN) {
+		i = reuseport_sock_index(reuse, sk, false);
+		if (i == -1)
+			goto out;
+
+		reuse->num_socks--;
+		reuse->socks[i] = reuse->socks[reuse->num_socks];
 
-	for (i = 0; i < reuse->num_socks; i++) {
-		if (reuse->socks[i] == sk) {
-			reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
-			reuse->num_socks--;
-			if (reuse->num_socks == 0)
-				call_rcu(&reuse->rcu, reuseport_free_rcu);
-			break;
+		if (reuse->migrate_req) {
+			reuse->num_closed_socks++;
+			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
+		} else {
+			rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
 		}
+	} else {
+		i = reuseport_sock_index(reuse, sk, true);
+		if (i == -1)
+			goto out;
+
+		reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
+		reuse->num_closed_socks--;
+
+		rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
 	}
+
+	if (reuse->num_socks + reuse->num_closed_socks == 0)
+		call_rcu(&reuse->rcu, reuseport_free_rcu);
+out:
 	spin_unlock_bh(&reuseport_lock);
 }
 EXPORT_SYMBOL(reuseport_detach_sock);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 4148f5f78f31..be8cda5b664f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -138,6 +138,7 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 	bool reuse = sk->sk_reuse;
 	bool reuseport = !!sk->sk_reuseport;
 	kuid_t uid = sock_i_uid((struct sock *)sk);
+	struct sock_reuseport *reuseport_cb = rcu_access_pointer(sk->sk_reuseport_cb);
 
 	/*
 	 * Unlike other sk lookup places we do not check
@@ -156,14 +157,16 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 				if ((!relax ||
 				     (!reuseport_ok &&
 				      reuseport && sk2->sk_reuseport &&
-				      !rcu_access_pointer(sk->sk_reuseport_cb) &&
+				      (!reuseport_cb ||
+				       reuseport_cb == rcu_access_pointer(sk2->sk_reuseport_cb)) &&
 				      (sk2->sk_state == TCP_TIME_WAIT ||
 				       uid_eq(uid, sock_i_uid(sk2))))) &&
 				    inet_rcv_saddr_equal(sk, sk2, true))
 					break;
 			} else if (!reuseport_ok ||
 				   !reuseport || !sk2->sk_reuseport ||
-				   rcu_access_pointer(sk->sk_reuseport_cb) ||
+				   (reuseport_cb &&
+				    reuseport_cb != rcu_access_pointer(sk2->sk_reuseport_cb)) ||
 				   (sk2->sk_state != TCP_TIME_WAIT &&
 				    !uid_eq(uid, sock_i_uid(sk2)))) {
 				if (inet_rcv_saddr_equal(sk, sk2, true))
-- 
2.17.2 (Apple Git-113)

