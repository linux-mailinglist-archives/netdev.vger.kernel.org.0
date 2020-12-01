Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56DF2CA629
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391584AbgLAOq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:46:56 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:51364 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389033AbgLAOqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:46:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606834014; x=1638370014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=sbHECF02s6Bqq1okkw9Zu8kr/lAkSusVFYHxoYY5tRk=;
  b=bVsFVuX0dZ2PdNLys5uFwn54J/SOK6QQMbRXB1cAMZJXG7rQbfuiXtlK
   OKdcQiyzxRiZs0fjd/GNgAN1y8/E7Y2K+Sxi7EtUdAulXy9YrK7ZAA6Qa
   OdELC8TDW4D0Nel0sQdw7yK2ni4ITVecOjw1AZwICgtbWBd7PC9dZdGPk
   k=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="92542374"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 14:46:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id E8F0AA188D;
        Tue,  1 Dec 2020 14:46:12 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:46:12 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:46:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 bpf-next 05/11] tcp: Migrate TCP_NEW_SYN_RECV requests.
Date:   Tue, 1 Dec 2020 23:44:12 +0900
Message-ID: <20201201144418.35045-6-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201201144418.35045-1-kuniyu@amazon.co.jp>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D36UWA004.ant.amazon.com (10.43.160.175) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renames reuseport_select_sock() to __reuseport_select_sock() and
adds two wrapper function of it to pass the migration type defined in the
previous commit.

  reuseport_select_sock          : BPF_SK_REUSEPORT_MIGRATE_NO
  reuseport_select_migrated_sock : BPF_SK_REUSEPORT_MIGRATE_REQUEST

As mentioned before, we have to select a new listener for TCP_NEW_SYN_RECV
requests at receiving the final ACK or sending a SYN+ACK. Therefore, this
patch also changes the code to call reuseport_select_migrated_sock() even
if the listening socket is TCP_CLOSE. If we can pick out a listening socket
from the reuseport group, we rewrite request_sock.rsk_listener and resume
processing the request.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/inet_connection_sock.h | 12 +++++++++++
 include/net/request_sock.h         | 13 ++++++++++++
 include/net/sock_reuseport.h       |  8 +++----
 net/core/sock_reuseport.c          | 34 ++++++++++++++++++++++++------
 net/ipv4/inet_connection_sock.c    | 13 ++++++++++--
 net/ipv4/tcp_ipv4.c                |  9 ++++++--
 net/ipv6/tcp_ipv6.c                |  9 ++++++--
 7 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 2ea2d743f8fc..1e0958f5eb21 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -272,6 +272,18 @@ static inline void inet_csk_reqsk_queue_added(struct sock *sk)
 	reqsk_queue_added(&inet_csk(sk)->icsk_accept_queue);
 }
 
+static inline void inet_csk_reqsk_queue_migrated(struct sock *sk,
+						 struct sock *nsk,
+						 struct request_sock *req)
+{
+	reqsk_queue_migrated(&inet_csk(sk)->icsk_accept_queue,
+			     &inet_csk(nsk)->icsk_accept_queue,
+			     req);
+	sock_put(sk);
+	sock_hold(nsk);
+	req->rsk_listener = nsk;
+}
+
 static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 {
 	return reqsk_queue_len(&inet_csk(sk)->icsk_accept_queue);
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 29e41ff3ec93..d18ba0b857cc 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -226,6 +226,19 @@ static inline void reqsk_queue_added(struct request_sock_queue *queue)
 	atomic_inc(&queue->qlen);
 }
 
+static inline void reqsk_queue_migrated(struct request_sock_queue *old_accept_queue,
+					struct request_sock_queue *new_accept_queue,
+					const struct request_sock *req)
+{
+	atomic_dec(&old_accept_queue->qlen);
+	atomic_inc(&new_accept_queue->qlen);
+
+	if (req->num_timeout == 0) {
+		atomic_dec(&old_accept_queue->young);
+		atomic_inc(&new_accept_queue->young);
+	}
+}
+
 static inline int reqsk_queue_len(const struct request_sock_queue *queue)
 {
 	return atomic_read(&queue->qlen);
diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 09a1b1539d4c..a48259a974be 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -32,10 +32,10 @@ extern int reuseport_alloc(struct sock *sk, bool bind_inany);
 extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
 			      bool bind_inany);
 extern struct sock *reuseport_detach_sock(struct sock *sk);
-extern struct sock *reuseport_select_sock(struct sock *sk,
-					  u32 hash,
-					  struct sk_buff *skb,
-					  int hdr_len);
+extern struct sock *reuseport_select_sock(struct sock *sk, u32 hash,
+					  struct sk_buff *skb, int hdr_len);
+extern struct sock *reuseport_select_migrated_sock(struct sock *sk, u32 hash,
+						   struct sk_buff *skb);
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);
 
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 60d7c1f28809..b4fe0829c9ab 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -202,7 +202,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 	}
 
 	reuse->socks[reuse->num_socks] = sk;
-	/* paired with smp_rmb() in reuseport_select_sock() */
+	/* paired with smp_rmb() in __reuseport_select_sock() */
 	smp_wmb();
 	reuse->num_socks++;
 	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
@@ -313,12 +313,13 @@ static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
  *  @hdr_len: BPF filter expects skb data pointer at payload data.  If
  *    the skb does not yet point at the payload, this parameter represents
  *    how far the pointer needs to advance to reach the payload.
+ *  @migration: represents if it is selecting a listener for SYN or
+ *    migrating ESTABLISHED/SYN_RECV sockets or NEW_SYN_RECV socket.
  *  Returns a socket that should receive the packet (or NULL on error).
  */
-struct sock *reuseport_select_sock(struct sock *sk,
-				   u32 hash,
-				   struct sk_buff *skb,
-				   int hdr_len)
+struct sock *__reuseport_select_sock(struct sock *sk, u32 hash,
+				     struct sk_buff *skb, int hdr_len,
+				     u8 migration)
 {
 	struct sock_reuseport *reuse;
 	struct bpf_prog *prog;
@@ -332,13 +333,19 @@ struct sock *reuseport_select_sock(struct sock *sk,
 	if (!reuse)
 		goto out;
 
-	prog = rcu_dereference(reuse->prog);
 	socks = READ_ONCE(reuse->num_socks);
 	if (likely(socks)) {
 		/* paired with smp_wmb() in reuseport_add_sock() */
 		smp_rmb();
 
-		if (!prog || !skb)
+		prog = rcu_dereference(reuse->prog);
+		if (!prog)
+			goto select_by_hash;
+
+		if (migration)
+			goto out;
+
+		if (!skb)
 			goto select_by_hash;
 
 		if (prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
@@ -367,8 +374,21 @@ struct sock *reuseport_select_sock(struct sock *sk,
 	rcu_read_unlock();
 	return sk2;
 }
+
+struct sock *reuseport_select_sock(struct sock *sk, u32 hash,
+				   struct sk_buff *skb, int hdr_len)
+{
+	return __reuseport_select_sock(sk, hash, skb, hdr_len, BPF_SK_REUSEPORT_MIGRATE_NO);
+}
 EXPORT_SYMBOL(reuseport_select_sock);
 
+struct sock *reuseport_select_migrated_sock(struct sock *sk, u32 hash,
+					    struct sk_buff *skb)
+{
+	return __reuseport_select_sock(sk, hash, skb, 0, BPF_SK_REUSEPORT_MIGRATE_REQUEST);
+}
+EXPORT_SYMBOL(reuseport_select_migrated_sock);
+
 int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
 {
 	struct sock_reuseport *reuse;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 361efe55b1ad..e71653c6eae2 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -743,8 +743,17 @@ static void reqsk_timer_handler(struct timer_list *t)
 	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
 	int max_syn_ack_retries, qlen, expire = 0, resend = 0;
 
-	if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
-		goto drop;
+	if (inet_sk_state_load(sk_listener) != TCP_LISTEN) {
+		sk_listener = reuseport_select_migrated_sock(sk_listener,
+							     req_to_sk(req)->sk_hash, NULL);
+		if (!sk_listener) {
+			sk_listener = req->rsk_listener;
+			goto drop;
+		}
+		inet_csk_reqsk_queue_migrated(req->rsk_listener, sk_listener, req);
+		icsk = inet_csk(sk_listener);
+		queue = &icsk->icsk_accept_queue;
+	}
 
 	max_syn_ack_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
 	/* Normally all the openreqs are young and become mature
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e4b31e70bd30..9a9aa27c6069 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1973,8 +1973,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			goto csum_error;
 		}
 		if (unlikely(sk->sk_state != TCP_LISTEN)) {
-			inet_csk_reqsk_queue_drop_and_put(sk, req);
-			goto lookup;
+			nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, skb);
+			if (!nsk) {
+				inet_csk_reqsk_queue_drop_and_put(sk, req);
+				goto lookup;
+			}
+			inet_csk_reqsk_queue_migrated(sk, nsk, req);
+			sk = nsk;
 		}
 		/* We own a reference on the listener, increase it again
 		 * as we might lose it too soon.
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 992cbf3eb9e3..ff11f3c0cb96 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1635,8 +1635,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			goto csum_error;
 		}
 		if (unlikely(sk->sk_state != TCP_LISTEN)) {
-			inet_csk_reqsk_queue_drop_and_put(sk, req);
-			goto lookup;
+			nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, skb);
+			if (!nsk) {
+				inet_csk_reqsk_queue_drop_and_put(sk, req);
+				goto lookup;
+			}
+			inet_csk_reqsk_queue_migrated(sk, nsk, req);
+			sk = nsk;
 		}
 		sock_hold(sk);
 		refcounted = true;
-- 
2.17.2 (Apple Git-113)

