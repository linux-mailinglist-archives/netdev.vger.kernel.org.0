Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2E72B5BF9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgKQJmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:42:13 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8845 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgKQJmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605606132; x=1637142132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=6AQ/lwoNdq7Ec+hf7LIe46G27QpR4QjgzjOBsKqGnbI=;
  b=RyjwacqK+uHLmkLiptNzYt2l8W1IHYegLa3xI7vhYpns2Q5nlKmsYptx
   kNuIWmtFsX5qnqJu8yKzGV5VDjobKwN7Ndt9oErO5Wnke7cpwKfdjiXwT
   Dji74t9upmNxLcRzjXGAXKmMY9bxY2Qh2ru9+4VxaFqLtYxqmM9TpGSVE
   Y=;
X-IronPort-AV: E=Sophos;i="5.77,485,1596499200"; 
   d="scan'208";a="65440629"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 17 Nov 2020 09:42:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 01FFDA1F93;
        Tue, 17 Nov 2020 09:42:07 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:42:07 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.237) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:42:03 +0000
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
Subject: [RFC PATCH bpf-next 5/8] tcp: Migrate TCP_NEW_SYN_RECV requests.
Date:   Tue, 17 Nov 2020 18:40:20 +0900
Message-ID: <20201117094023.3685-6-kuniyu@amazon.co.jp>
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

As mentioned before, we have to select a new listener for TCP_NEW_SYN_RECV
requests at receiving the final ACK or sending a SYN+ACK. Therefore, this
patch changes the code to call reuseport_select_sock() even if the
listening socket is TCP_CLOSE. If we can pick out a listening socket from
the reuseport group, we rewrite request_sock.rsk_listener and resume
processing the request.

Note that we call reuseport_select_sock() with skb NULL so that it selects
a listener randomly by hash. There are two reasons to do so. First, we do
not remember from which listener to which listener we have migrated sockets
at close() or shutdown() syscalls, so we redistribute the requests evenly.
As regards the second, we will cover in a later commit.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/inet_connection_sock.h | 12 ++++++++++++
 include/net/request_sock.h         | 13 +++++++++++++
 net/ipv4/inet_connection_sock.c    | 12 ++++++++++--
 net/ipv4/tcp_ipv4.c                |  9 +++++++--
 net/ipv6/tcp_ipv6.c                |  9 +++++++--
 5 files changed, 49 insertions(+), 6 deletions(-)

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
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 398c5c708bc5..8be20e3fff4f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -743,8 +743,16 @@ static void reqsk_timer_handler(struct timer_list *t)
 	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
 	int max_syn_ack_retries, qlen, expire = 0, resend = 0;
 
-	if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
-		goto drop;
+	if (inet_sk_state_load(sk_listener) != TCP_LISTEN) {
+		sk_listener = reuseport_select_sock(sk_listener, sk_listener->sk_hash, NULL, 0);
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
index c2d5132c523c..7219984584ae 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1957,8 +1957,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			goto csum_error;
 		}
 		if (unlikely(sk->sk_state != TCP_LISTEN)) {
-			inet_csk_reqsk_queue_drop_and_put(sk, req);
-			goto lookup;
+			nsk = reuseport_select_sock(sk, sk->sk_hash, NULL, 0);
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
index 8db59f4e5f13..9a068b69a26e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1619,8 +1619,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			goto csum_error;
 		}
 		if (unlikely(sk->sk_state != TCP_LISTEN)) {
-			inet_csk_reqsk_queue_drop_and_put(sk, req);
-			goto lookup;
+			nsk = reuseport_select_sock(sk, sk->sk_hash, NULL, 0);
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

