Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A5C2B5BF1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgKQJlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:41:42 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:10482 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgKQJll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605606101; x=1637142101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=pqphziyiMnMteRD3/Ub1HhlxTKc6lKBH2L8N47H+TE4=;
  b=uD5un3ij/o6pEn3mwDvieaE3qc8XsHjUTOhXZQhW60IIOKVJk/Ody+oF
   tCFoPAQk65BBZ5CiaDKtHY8wZnZLvLPi6J95NwZXXGULU7c1SEQV8Hjbe
   xup0w+M/OUNtyZJDX8mmWRoqoBo/7YEZe1p3QgHlOaN6yxWvgGI7lkRdt
   k=;
X-IronPort-AV: E=Sophos;i="5.77,485,1596499200"; 
   d="scan'208";a="66876948"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 17 Nov 2020 09:41:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 064B8A1F36;
        Tue, 17 Nov 2020 09:41:37 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:41:37 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.237) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:41:33 +0000
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
Subject: [RFC PATCH bpf-next 3/8] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Tue, 17 Nov 2020 18:40:18 +0900
Message-ID: <20201117094023.3685-4-kuniyu@amazon.co.jp>
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

This patch lets reuseport_detach_sock() return a pointer of struct sock,
which is used only by inet_unhash(). If it is not NULL,
inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
sockets from the closing listener to the selected one.

Listening sockets hold incoming connections as a linked list of struct
request_sock in the accept queue, and each request has reference to a full
socket and its listener. In inet_csk_reqsk_queue_migrate(), we unlink the
requests from the closing listener's queue and relink them to the head of
the new listener's queue. We do not process each request, so the migration
completes in O(1) time complexity. However, in the case of TCP_SYN_RECV
sockets, we will take special care in the next commit.

By default, we select the last element of socks[] as the new listener.
This behaviour is based on how the kernel moves sockets in socks[].

For example, we call listen() for four sockets (A, B, C, D), and close the
first two by turns. The sockets move in socks[] like below. (See also [1])

  socks[0] : A <-.      socks[0] : D          socks[0] : D
  socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
  socks[2] : C   |      socks[2] : C --'
  socks[3] : D --'

Then, if C and D have newer settings than A and B, and each socket has a
request (a, b, c, d) in their accept queue, we can redistribute old
requests evenly to new listeners.

  socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
  socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
  socks[2] : C (c)   |      socks[2] : C (c) --'
  socks[3] : D (d) --'

Here, (A, D), or (B, C) can have different application settings, but they
MUST have the same settings at the socket API level; otherwise, unexpected
error may happen. For instance, if only the new listeners have
TCP_SAVE_SYN, old requests do not have SYN data, so the application will
face inconsistency and cause an error.

Therefore, if there are different kinds of sockets, we must disable this
feature or use an eBPF program described in later commits.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
---
 include/net/inet_connection_sock.h |  1 +
 include/net/sock_reuseport.h       |  2 +-
 net/core/sock_reuseport.c          |  8 +++++++-
 net/ipv4/inet_connection_sock.c    | 30 ++++++++++++++++++++++++++++++
 net/ipv4/inet_hashtables.c         |  9 +++++++--
 5 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 7338b3865a2a..2ea2d743f8fc 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -260,6 +260,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
 struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
 				      struct request_sock *req,
 				      struct sock *child);
+void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk);
 void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
 				   unsigned long timeout);
 struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index ade3af55c91f..ece1c70ca907 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -32,7 +32,7 @@ struct sock_reuseport {
 extern int reuseport_alloc(struct sock *sk, bool bind_inany);
 extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
 			      bool bind_inany);
-extern void reuseport_detach_sock(struct sock *sk);
+extern struct sock *reuseport_detach_sock(struct sock *sk);
 extern struct sock *reuseport_select_sock(struct sock *sk,
 					  u32 hash,
 					  struct sk_buff *skb,
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 01a8b4ba39d7..74a46197854b 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -220,9 +220,10 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 }
 EXPORT_SYMBOL(reuseport_add_sock);
 
-void reuseport_detach_sock(struct sock *sk)
+struct sock *reuseport_detach_sock(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
+	struct sock *nsk = NULL;
 	int i;
 
 	spin_lock_bh(&reuseport_lock);
@@ -248,6 +249,9 @@ void reuseport_detach_sock(struct sock *sk)
 		reuse->socks[i] = reuse->socks[reuse->num_socks];
 
 		if (reuse->migrate_req) {
+			if (reuse->num_socks)
+				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
+
 			reuse->num_closed_socks++;
 			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
 		} else {
@@ -268,6 +272,8 @@ void reuseport_detach_sock(struct sock *sk)
 		call_rcu(&reuse->rcu, reuseport_free_rcu);
 out:
 	spin_unlock_bh(&reuseport_lock);
+
+	return nsk;
 }
 EXPORT_SYMBOL(reuseport_detach_sock);
 
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index be8cda5b664f..583db7e2b1da 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
 }
 EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
 
+void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
+{
+	struct request_sock_queue *old_accept_queue, *new_accept_queue;
+
+	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
+	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
+
+	spin_lock(&old_accept_queue->rskq_lock);
+	spin_lock(&new_accept_queue->rskq_lock);
+
+	if (old_accept_queue->rskq_accept_head) {
+		if (new_accept_queue->rskq_accept_head)
+			old_accept_queue->rskq_accept_tail->dl_next =
+				new_accept_queue->rskq_accept_head;
+		else
+			new_accept_queue->rskq_accept_tail = old_accept_queue->rskq_accept_tail;
+
+		new_accept_queue->rskq_accept_head = old_accept_queue->rskq_accept_head;
+		old_accept_queue->rskq_accept_head = NULL;
+		old_accept_queue->rskq_accept_tail = NULL;
+
+		WRITE_ONCE(nsk->sk_ack_backlog, nsk->sk_ack_backlog + sk->sk_ack_backlog);
+		WRITE_ONCE(sk->sk_ack_backlog, 0);
+	}
+
+	spin_unlock(&new_accept_queue->rskq_lock);
+	spin_unlock(&old_accept_queue->rskq_lock);
+}
+EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
+
 struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
 					 struct request_sock *req, bool own_req)
 {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 8cbe74313f38..f35c76cf3365 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -629,6 +629,7 @@ void inet_unhash(struct sock *sk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct inet_listen_hashbucket *ilb = NULL;
+	struct sock *nsk;
 	spinlock_t *lock;
 
 	if (sk_unhashed(sk))
@@ -644,8 +645,12 @@ void inet_unhash(struct sock *sk)
 	if (sk_unhashed(sk))
 		goto unlock;
 
-	if (rcu_access_pointer(sk->sk_reuseport_cb))
-		reuseport_detach_sock(sk);
+	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
+		nsk = reuseport_detach_sock(sk);
+		if (nsk)
+			inet_csk_reqsk_queue_migrate(sk, nsk);
+	}
+
 	if (ilb) {
 		inet_unhash2(hashinfo, sk);
 		ilb->count--;
-- 
2.17.2 (Apple Git-113)

