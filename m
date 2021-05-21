Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3BA38CD38
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbhEUSXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:23:42 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:55176 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbhEUSXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621621338; x=1653157338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ug1PvBmaEwWLHASPZCH0Ao2XFktgvGM7adhuNrDGJ5E=;
  b=fXgOqyGaAoCxLcfwMBruqV3FF8E6ELn6afU91b4b3jAX7h67kQXy4a74
   Ebduzrml53dzfsPrXPq+QgCbH21vesf/6rrAnGiG02qTPjmH0Ezt9NL1u
   L39qmm3nL0eTDNuwQa8lQ+JtoLVZBbHRnssffQ06sTBE28vPvLMdtsjq4
   A=;
X-IronPort-AV: E=Sophos;i="5.82,319,1613433600"; 
   d="scan'208";a="934449459"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 21 May 2021 18:22:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 08936A11A1;
        Fri, 21 May 2021 18:22:16 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 18:22:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.224) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 18:22:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the reuseport group.
Date:   Sat, 22 May 2021 03:20:56 +0900
Message-ID: <20210521182104.18273-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521182104.18273-1-kuniyu@amazon.co.jp>
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.224]
X-ClientProxiedBy: EX13D17UWB003.ant.amazon.com (10.43.161.42) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we close a listening socket, to migrate its connections to another
listener in the same reuseport group, we have to handle two kinds of child
sockets. One is that a listening socket has a reference to, and the other
is not.

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
no connection would be aborted. However, we cannot do that because
reuseport_detach_sock() sets NULL to sk_reuseport_cb and forbids access to
the reuseport group from closed sockets.

This patch allows TCP_CLOSE sockets to remain in the reuseport group and
access it while any child socket references them. The point is that
reuseport_detach_sock() was called twice from inet_unhash() and
sk_destruct(). This patch replaces the first reuseport_detach_sock() with
reuseport_stop_listen_sock(), which checks if the reuseport group is
capable of migration. If capable, it decrements num_socks, moves the socket
backwards in socks[] and increments num_closed_socks. When all connections
are migrated, sk_destruct() calls reuseport_detach_sock() to remove the
socket from socks[], decrement num_closed_socks, and set NULL to
sk_reuseport_cb.

By this change, closed or shutdowned sockets can keep sk_reuseport_cb.
Consequently, calling listen() after shutdown() can cause EADDRINUSE or
EBUSY in inet_csk_bind_conflict() or reuseport_add_sock() which expects
such sockets not to have the reuseport group. Therefore, this patch also
loosens such validation rules so that a socket can listen again if it has a
reuseport group with num_closed_socks more than 0.

When such sockets listen again, we handle them in reuseport_resurrect(). If
there is an existing reuseport group (reuseport_add_sock() path), we move
the socket from the old group to the new one and free the old one if
necessary. If there is no existing group (reuseport_alloc() path), we
allocate a new reuseport group, detach sk from the old one, and free it if
necessary, not to break the current shutdown behaviour:

  - we cannot carry over the eBPF prog of shutdowned sockets
  - we cannot attach/detach an eBPF prog to/from listening sockets via
    shutdowned sockets

Note that when the number of sockets gets over U16_MAX, we try to detach a
closed socket randomly to make room for the new listening socket in
reuseport_grow().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/sock_reuseport.h    |   1 +
 net/core/sock_reuseport.c       | 184 ++++++++++++++++++++++++++++++--
 net/ipv4/inet_connection_sock.c |  12 ++-
 net/ipv4/inet_hashtables.c      |   2 +-
 4 files changed, 188 insertions(+), 11 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 0e558ca7afbf..1333d0cddfbc 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -32,6 +32,7 @@ extern int reuseport_alloc(struct sock *sk, bool bind_inany);
 extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
 			      bool bind_inany);
 extern void reuseport_detach_sock(struct sock *sk);
+void reuseport_stop_listen_sock(struct sock *sk);
 extern struct sock *reuseport_select_sock(struct sock *sk,
 					  u32 hash,
 					  struct sk_buff *skb,
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 079bd1aca0e7..ea0e900d3e97 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -17,6 +17,8 @@
 DEFINE_SPINLOCK(reuseport_lock);
 
 static DEFINE_IDA(reuseport_ida);
+static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
+			       struct sock_reuseport *reuse, bool bind_inany);
 
 static int reuseport_sock_index(struct sock *sk,
 				struct sock_reuseport *reuse,
@@ -61,6 +63,29 @@ static bool __reuseport_detach_sock(struct sock *sk,
 	return true;
 }
 
+static void __reuseport_add_closed_sock(struct sock *sk,
+					struct sock_reuseport *reuse)
+{
+	reuse->socks[reuse->max_socks - reuse->num_closed_socks - 1] = sk;
+	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
+	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks + 1);
+}
+
+static bool __reuseport_detach_closed_sock(struct sock *sk,
+					   struct sock_reuseport *reuse)
+{
+	int i = reuseport_sock_index(sk, reuse, true);
+
+	if (i == -1)
+		return false;
+
+	reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
+	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
+	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks - 1);
+
+	return true;
+}
+
 static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
 {
 	unsigned int size = sizeof(struct sock_reuseport) +
@@ -92,6 +117,14 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
 	if (reuse) {
+		if (reuse->num_closed_socks) {
+			/* sk was shutdown()ed before */
+			int err = reuseport_resurrect(sk, reuse, NULL, bind_inany);
+
+			spin_unlock_bh(&reuseport_lock);
+			return err;
+		}
+
 		/* Only set reuse->bind_inany if the bind_inany is true.
 		 * Otherwise, it will overwrite the reuse->bind_inany
 		 * which was set by the bind/hash path.
@@ -132,8 +165,23 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 	u32 more_socks_size, i;
 
 	more_socks_size = reuse->max_socks * 2U;
-	if (more_socks_size > U16_MAX)
+	if (more_socks_size > U16_MAX) {
+		if (reuse->num_closed_socks) {
+			/* Make room by removing a closed sk.
+			 * The child has already been migrated.
+			 * Only reqsk left at this point.
+			 */
+			struct sock *sk;
+
+			sk = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
+			RCU_INIT_POINTER(sk->sk_reuseport_cb, NULL);
+			__reuseport_detach_closed_sock(sk, reuse);
+
+			return reuse;
+		}
+
 		return NULL;
+	}
 
 	more_reuse = __reuseport_alloc(more_socks_size);
 	if (!more_reuse)
@@ -199,7 +247,15 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 	reuse = rcu_dereference_protected(sk2->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
 	old_reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
-					     lockdep_is_held(&reuseport_lock));
+					      lockdep_is_held(&reuseport_lock));
+	if (old_reuse && old_reuse->num_closed_socks) {
+		/* sk was shutdown()ed before */
+		int err = reuseport_resurrect(sk, old_reuse, reuse, reuse->bind_inany);
+
+		spin_unlock_bh(&reuseport_lock);
+		return err;
+	}
+
 	if (old_reuse && old_reuse->num_socks != 1) {
 		spin_unlock_bh(&reuseport_lock);
 		return -EBUSY;
@@ -224,6 +280,65 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 }
 EXPORT_SYMBOL(reuseport_add_sock);
 
+static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
+			       struct sock_reuseport *reuse, bool bind_inany)
+{
+	if (old_reuse == reuse) {
+		/* If sk was in the same reuseport group, just pop sk out of
+		 * the closed section and push sk into the listening section.
+		 */
+		__reuseport_detach_closed_sock(sk, old_reuse);
+		__reuseport_add_sock(sk, old_reuse);
+		return 0;
+	}
+
+	if (!reuse) {
+		/* In bind()/listen() path, we cannot carry over the eBPF prog
+		 * for the shutdown()ed socket. In setsockopt() path, we should
+		 * not change the eBPF prog of listening sockets by attaching a
+		 * prog to the shutdown()ed socket. Thus, we will allocate a new
+		 * reuseport group and detach sk from the old group.
+		 */
+		int id;
+
+		reuse = __reuseport_alloc(INIT_SOCKS);
+		if (!reuse)
+			return -ENOMEM;
+
+		id = ida_alloc(&reuseport_ida, GFP_ATOMIC);
+		if (id < 0) {
+			kfree(reuse);
+			return id;
+		}
+
+		reuse->reuseport_id = id;
+		reuse->bind_inany = bind_inany;
+	} else {
+		/* Move sk from the old group to the new one if
+		 * - all the other listeners in the old group were close()d or
+		 *   shutdown()ed, and then sk2 has listen()ed on the same port
+		 * OR
+		 * - sk listen()ed without bind() (or with autobind), was
+		 *   shutdown()ed, and then listen()s on another port which
+		 *   sk2 listen()s on.
+		 */
+		if (reuse->num_socks + reuse->num_closed_socks == reuse->max_socks) {
+			reuse = reuseport_grow(reuse);
+			if (!reuse)
+				return -ENOMEM;
+		}
+	}
+
+	__reuseport_detach_closed_sock(sk, old_reuse);
+	__reuseport_add_sock(sk, reuse);
+	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
+
+	if (old_reuse->num_socks + old_reuse->num_closed_socks == 0)
+		call_rcu(&old_reuse->rcu, reuseport_free_rcu);
+
+	return 0;
+}
+
 void reuseport_detach_sock(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
@@ -232,6 +347,10 @@ void reuseport_detach_sock(struct sock *sk)
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
 
+	/* reuseport_grow() has detached a closed sk */
+	if (!reuse)
+		goto out;
+
 	/* Notify the bpf side. The sk may be added to a sockarray
 	 * map. If so, sockarray logic will remove it from the map.
 	 *
@@ -243,15 +362,49 @@ void reuseport_detach_sock(struct sock *sk)
 	bpf_sk_reuseport_detach(sk);
 
 	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
-	__reuseport_detach_sock(sk, reuse);
+
+	if (!__reuseport_detach_closed_sock(sk, reuse))
+		__reuseport_detach_sock(sk, reuse);
 
 	if (reuse->num_socks + reuse->num_closed_socks == 0)
 		call_rcu(&reuse->rcu, reuseport_free_rcu);
 
+out:
 	spin_unlock_bh(&reuseport_lock);
 }
 EXPORT_SYMBOL(reuseport_detach_sock);
 
+void reuseport_stop_listen_sock(struct sock *sk)
+{
+	if (sk->sk_protocol == IPPROTO_TCP) {
+		struct sock_reuseport *reuse;
+
+		spin_lock_bh(&reuseport_lock);
+
+		reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
+						  lockdep_is_held(&reuseport_lock));
+
+		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req) {
+			/* Migration capable, move sk from the listening section
+			 * to the closed section.
+			 */
+			bpf_sk_reuseport_detach(sk);
+
+			__reuseport_detach_sock(sk, reuse);
+			__reuseport_add_closed_sock(sk, reuse);
+
+			spin_unlock_bh(&reuseport_lock);
+			return;
+		}
+
+		spin_unlock_bh(&reuseport_lock);
+	}
+
+	/* Not capable to do migration, detach immediately */
+	reuseport_detach_sock(sk);
+}
+EXPORT_SYMBOL(reuseport_stop_listen_sock);
+
 static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
 				   struct bpf_prog *prog, struct sk_buff *skb,
 				   int hdr_len)
@@ -351,9 +504,13 @@ int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
 	struct sock_reuseport *reuse;
 	struct bpf_prog *old_prog;
 
-	if (sk_unhashed(sk) && sk->sk_reuseport) {
-		int err = reuseport_alloc(sk, false);
+	if (sk_unhashed(sk)) {
+		int err;
+
+		if (!sk->sk_reuseport)
+			return -EINVAL;
 
+		err = reuseport_alloc(sk, false);
 		if (err)
 			return err;
 	} else if (!rcu_access_pointer(sk->sk_reuseport_cb)) {
@@ -379,13 +536,24 @@ int reuseport_detach_prog(struct sock *sk)
 	struct sock_reuseport *reuse;
 	struct bpf_prog *old_prog;
 
-	if (!rcu_access_pointer(sk->sk_reuseport_cb))
-		return sk->sk_reuseport ? -ENOENT : -EINVAL;
-
 	old_prog = NULL;
 	spin_lock_bh(&reuseport_lock);
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
+
+	/* reuse must be checked after acquiring the reuseport_lock
+	 * because reuseport_grow() can detach a closed sk.
+	 */
+	if (!reuse) {
+		spin_unlock_bh(&reuseport_lock);
+		return sk->sk_reuseport ? -ENOENT : -EINVAL;
+	}
+
+	if (sk_unhashed(sk) && reuse->num_closed_socks) {
+		spin_unlock_bh(&reuseport_lock);
+		return -ENOENT;
+	}
+
 	old_prog = rcu_replace_pointer(reuse->prog, old_prog,
 				       lockdep_is_held(&reuseport_lock));
 	spin_unlock_bh(&reuseport_lock);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fd472eae4f5c..fa806e9167ec 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -135,10 +135,18 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 				  bool relax, bool reuseport_ok)
 {
 	struct sock *sk2;
+	bool reuseport_cb_ok;
 	bool reuse = sk->sk_reuse;
 	bool reuseport = !!sk->sk_reuseport;
+	struct sock_reuseport *reuseport_cb;
 	kuid_t uid = sock_i_uid((struct sock *)sk);
 
+	rcu_read_lock();
+	reuseport_cb = rcu_dereference(sk->sk_reuseport_cb);
+	/* paired with WRITE_ONCE() in __reuseport_(add|detach)_closed_sock */
+	reuseport_cb_ok = !reuseport_cb || READ_ONCE(reuseport_cb->num_closed_socks);
+	rcu_read_unlock();
+
 	/*
 	 * Unlike other sk lookup places we do not check
 	 * for sk_net here, since _all_ the socks listed
@@ -156,14 +164,14 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 				if ((!relax ||
 				     (!reuseport_ok &&
 				      reuseport && sk2->sk_reuseport &&
-				      !rcu_access_pointer(sk->sk_reuseport_cb) &&
+				      reuseport_cb_ok &&
 				      (sk2->sk_state == TCP_TIME_WAIT ||
 				       uid_eq(uid, sock_i_uid(sk2))))) &&
 				    inet_rcv_saddr_equal(sk, sk2, true))
 					break;
 			} else if (!reuseport_ok ||
 				   !reuseport || !sk2->sk_reuseport ||
-				   rcu_access_pointer(sk->sk_reuseport_cb) ||
+				   !reuseport_cb_ok ||
 				   (sk2->sk_state != TCP_TIME_WAIT &&
 				    !uid_eq(uid, sock_i_uid(sk2)))) {
 				if (inet_rcv_saddr_equal(sk, sk2, true))
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index c96866a53a66..80aeaf9e6e16 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -697,7 +697,7 @@ void inet_unhash(struct sock *sk)
 		goto unlock;
 
 	if (rcu_access_pointer(sk->sk_reuseport_cb))
-		reuseport_detach_sock(sk);
+		reuseport_stop_listen_sock(sk);
 	if (ilb) {
 		inet_unhash2(hashinfo, sk);
 		ilb->count--;
-- 
2.30.2

