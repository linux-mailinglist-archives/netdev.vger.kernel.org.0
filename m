Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029282D11DF
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgLGN0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:26:11 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:36461 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgLGN0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:26:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347570; x=1638883570;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=HKjIsmqmU/4GV4rzTHMtQpJccy4bICOTjf5HS8mC/Ik=;
  b=TKG0SRe8m9AkZMK5hQJmowRCbcgX40nS4KKyaCI8ZgdrBBNQPv0fVAX6
   aTGNwLdU6HjW/PaBY/Cp3XCHAIMJRZGIE+h1r3zb+CVZiNUdoqn9oQ3JE
   T17kAnhb8Bxt+CilrvujV9M5lBFduiQ8rckpbtIi68CuJrMBmtPz7oSmA
   4=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="67699485"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 07 Dec 2020 13:25:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id C5A93A1DD7;
        Mon,  7 Dec 2020 13:25:34 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:25:33 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:25:29 +0000
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
Subject: [PATCH v2 bpf-next 01/13] tcp: Allow TCP_CLOSE sockets to hold the reuseport group.
Date:   Mon, 7 Dec 2020 22:24:44 +0900
Message-ID: <20201207132456.65472-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201207132456.65472-1-kuniyu@amazon.co.jp>
References: <20201207132456.65472-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D37UWC002.ant.amazon.com (10.43.162.123) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a preparation patch to migrate incoming connections in the
later commits and adds a field (num_closed_socks) to the struct
sock_reuseport to allow TCP_CLOSE sockets to access to the reuseport group.

When we close a listening socket, to migrate its connections to another
listener in the same reuseport group, we have to handle two kinds of child
sockets. One is that a listening socket has a reference to, and the other
is not.

The former is the TCP_ESTABLISHED/TCP_SYN_RECV sockets, and they are in the
accept queue of their listening socket. So, we can pop them out and push
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

This patch allows TCP_CLOSE sockets to hold sk_reuseport_cb while any child
socket references to them. The point is that reuseport_detach_sock() is
called twice from inet_unhash() and sk_destruct(). At first, it decrements
num_socks and increments num_closed_socks. Later, when all migrated
connections are accepted, it decrements num_closed_socks and sets NULL to
sk_reuseport_cb.

By this change, closed sockets can keep sk_reuseport_cb until all child
requests have been freed or accepted. Consequently calling listen() after
shutdown() can cause EADDRINUSE or EBUSY in reuseport_add_sock() or
inet_csk_bind_conflict() which expect that such sockets should not have the
reuseport group. Therefore, this patch also loosens such validation rules
so that the socket can listen again if it has the same reuseport group with
other listening sockets.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/sock_reuseport.h    |  5 +++--
 net/core/sock_reuseport.c       | 39 +++++++++++++++++++++++----------
 net/ipv4/inet_connection_sock.c |  7 ++++--
 3 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 505f1e18e9bf..0e558ca7afbf 100644
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
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index bbdd3c7b6cb5..c26f4256ff41 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -98,14 +98,15 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 		return NULL;
 
 	more_reuse->num_socks = reuse->num_socks;
+	more_reuse->num_closed_socks = reuse->num_closed_socks;
 	more_reuse->prog = reuse->prog;
 	more_reuse->reuseport_id = reuse->reuseport_id;
 	more_reuse->bind_inany = reuse->bind_inany;
 	more_reuse->has_conns = reuse->has_conns;
+	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
 
 	memcpy(more_reuse->socks, reuse->socks,
 	       reuse->num_socks * sizeof(struct sock *));
-	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
 
 	for (i = 0; i < reuse->num_socks; ++i)
 		rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
@@ -152,8 +153,10 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 	reuse = rcu_dereference_protected(sk2->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
 	old_reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
-					     lockdep_is_held(&reuseport_lock));
-	if (old_reuse && old_reuse->num_socks != 1) {
+					      lockdep_is_held(&reuseport_lock));
+	if (old_reuse == reuse) {
+		reuse->num_closed_socks--;
+	} else if (old_reuse && old_reuse->num_socks != 1) {
 		spin_unlock_bh(&reuseport_lock);
 		return -EBUSY;
 	}
@@ -174,8 +177,9 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 
 	spin_unlock_bh(&reuseport_lock);
 
-	if (old_reuse)
+	if (old_reuse && old_reuse != reuse)
 		call_rcu(&old_reuse->rcu, reuseport_free_rcu);
+
 	return 0;
 }
 EXPORT_SYMBOL(reuseport_add_sock);
@@ -199,17 +203,28 @@ void reuseport_detach_sock(struct sock *sk)
 	 */
 	bpf_sk_reuseport_detach(sk);
 
-	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
-
-	for (i = 0; i < reuse->num_socks; i++) {
-		if (reuse->socks[i] == sk) {
-			reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
-			reuse->num_socks--;
-			if (reuse->num_socks == 0)
-				call_rcu(&reuse->rcu, reuseport_free_rcu);
+	if (sk->sk_protocol == IPPROTO_TCP && sk->sk_state == TCP_CLOSE) {
+		reuse->num_closed_socks--;
+		rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
+	} else {
+		for (i = 0; i < reuse->num_socks; i++) {
+			if (reuse->socks[i] != sk)
+				continue;
 			break;
 		}
+
+		reuse->num_socks--;
+		reuse->socks[i] = reuse->socks[reuse->num_socks];
+
+		if (sk->sk_protocol == IPPROTO_TCP)
+			reuse->num_closed_socks++;
+		else
+			rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
 	}
+
+	if (reuse->num_socks + reuse->num_closed_socks == 0)
+		call_rcu(&reuse->rcu, reuseport_free_rcu);
+
 	spin_unlock_bh(&reuseport_lock);
 }
 EXPORT_SYMBOL(reuseport_detach_sock);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f60869acbef0..1451aa9712b0 100644
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

