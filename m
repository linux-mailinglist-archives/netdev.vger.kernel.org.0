Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DCE2D11F9
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgLGN2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:28:05 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:54916 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgLGN2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:28:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347683; x=1638883683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=p8tI0mz+kTb3nu8UCKLc2FJ3zfZDXGquaaAz/e5hCQs=;
  b=Gl/IeySQROMNp3i1M0wsdAaoEsbZ2Wy61NIk6Ywk2LO8DtgA94fjhnbB
   h2hyg5LzL4eP7m6rK+wYtKSsC7lH/qUPVBiHq9YjeSFH0GUO/ntLl37Vh
   t/e/0NJC7FKStbWC/OYcCChh+jrfTUKxKzAYOuJtPh79d7hzV3lIK1xbk
   A=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="901122042"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 07 Dec 2020 13:27:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 91DCBA1E53;
        Mon,  7 Dec 2020 13:27:19 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:27:18 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:27:14 +0000
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
Subject: [PATCH v2 bpf-next 07/13] tcp: Migrate TCP_NEW_SYN_RECV requests.
Date:   Mon, 7 Dec 2020 22:24:50 +0900
Message-ID: <20201207132456.65472-8-kuniyu@amazon.co.jp>
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

Link: https://lore.kernel.org/bpf/202012020136.bF0Z4Guu-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/inet_connection_sock.h | 11 ++++++++
 include/net/request_sock.h         | 13 ++++++++++
 include/net/sock_reuseport.h       |  8 +++---
 net/core/sock_reuseport.c          | 40 ++++++++++++++++++++++++------
 net/ipv4/inet_connection_sock.c    | 13 ++++++++--
 net/ipv4/tcp_ipv4.c                |  9 +++++--
 net/ipv6/tcp_ipv6.c                |  9 +++++--
 7 files changed, 86 insertions(+), 17 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 2ea2d743f8fc..d8c3be31e987 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -272,6 +272,17 @@ static inline void inet_csk_reqsk_queue_added(struct sock *sk)
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
index 2de42f8103ea..1011c3756c92 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -170,7 +170,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 	}
 
 	reuse->socks[reuse->num_socks] = sk;
-	/* paired with smp_rmb() in reuseport_select_sock() */
+	/* paired with smp_rmb() in __reuseport_select_sock() */
 	smp_wmb();
 	reuse->num_socks++;
 	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
@@ -277,12 +277,13 @@ static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
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
+static struct sock *__reuseport_select_sock(struct sock *sk, u32 hash,
+					    struct sk_buff *skb, int hdr_len,
+					    u8 migration)
 {
 	struct sock_reuseport *reuse;
 	struct bpf_prog *prog;
@@ -296,13 +297,19 @@ struct sock *reuseport_select_sock(struct sock *sk,
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
@@ -331,8 +338,27 @@ struct sock *reuseport_select_sock(struct sock *sk,
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
+	struct sock *nsk;
+
+	nsk = __reuseport_select_sock(sk, hash, skb, 0, BPF_SK_REUSEPORT_MIGRATE_REQUEST);
+	if (nsk && likely(refcount_inc_not_zero(&nsk->sk_refcnt)))
+		return nsk;
+
+	return NULL;
+}
+EXPORT_SYMBOL(reuseport_select_migrated_sock);
+
 int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
 {
 	struct sock_reuseport *reuse;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 143590858c2e..f042e9122074 100644
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
index af2338294598..a4eea6b36795 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1978,8 +1978,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
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
index 1a1510513739..61b8c5855735 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1640,8 +1640,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
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

