Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3338223E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 02:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbhEQA03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 20:26:29 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:46106 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbhEQA01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 20:26:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621211112; x=1652747112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TrQCj5uRTN8PEM6tPLT/wPEPhW65gxaxlrsswxXZ7K0=;
  b=fRcRt9TqrjqPgRl36Pf8nN9ECvahPxWXPeuUUdTT3Ra6hUtjEn2fA87u
   uAL2xh57dajCs5jOxYCJlXCBEwGhV6XTHRUS5Bi8EEx0uNK4m5KQt2Gj7
   yPd1hMQIKVey1pEyEACpK4VzMuxkg3v8Vyr2v7Q9T8KInD1QjKOTyUnQk
   E=;
X-IronPort-AV: E=Sophos;i="5.82,306,1613433600"; 
   d="scan'208";a="933377985"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 17 May 2021 00:25:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 7B7B1A1E1F;
        Mon, 17 May 2021 00:25:08 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 17 May 2021 00:25:07 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.28) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 17 May 2021 00:25:02 +0000
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
Subject: [PATCH v6 bpf-next 07/11] tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
Date:   Mon, 17 May 2021 09:22:54 +0900
Message-ID: <20210517002258.75019-8-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210517002258.75019-1-kuniyu@amazon.co.jp>
References: <20210517002258.75019-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.28]
X-ClientProxiedBy: EX13D21UWA004.ant.amazon.com (10.43.160.252) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch also changes the code to call reuseport_migrate_sock() and
reqsk_clone(), but unlike the other cases, we do not call reqsk_clone()
right after reuseport_migrate_sock().

Currently, in the receive path for TCP_NEW_SYN_RECV sockets, its listener
has three kinds of refcnt:

  (A) for listener itself
  (B) carried by reuqest_sock
  (C) sock_hold() in tcp_v[46]_rcv()

While processing the req, (A) may disappear by close(listener). Also, (B)
can disappear by accept(listener) once we put the req into the accept
queue. So, we have to hold another refcnt (C) for the listener to prevent
use-after-free.

For socket migration, we call reuseport_migrate_sock() to select a listener
with (A) and to increment the new listener's refcnt in tcp_v[46]_rcv().
This refcnt corresponds to (C) and is cleaned up later in tcp_v[46]_rcv().
Thus we have to take another refcnt (B) for the newly cloned request_sock.

In inet_csk_complete_hashdance(), we hold the count (B), clone the req, and
try to put the new req into the accept queue. By migrating req after
winning the "own_req" race, we can avoid such a worst situation:

  CPU 1 looks up req1
  CPU 2 looks up req1, unhashes it, then CPU 1 loses the race
  CPU 3 looks up req2, unhashes it, then CPU 2 loses the race
  ...

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 34 ++++++++++++++++++++++++++++++---
 net/ipv4/tcp_ipv4.c             | 20 +++++++++++++------
 net/ipv4/tcp_minisocks.c        |  4 ++--
 net/ipv6/tcp_ipv6.c             | 14 +++++++++++---
 4 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index c1f068464363..83115c9f6d19 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1113,12 +1113,40 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
 					 struct request_sock *req, bool own_req)
 {
 	if (own_req) {
-		inet_csk_reqsk_queue_drop(sk, req);
-		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
-		if (inet_csk_reqsk_queue_add(sk, req, child))
+		inet_csk_reqsk_queue_drop(req->rsk_listener, req);
+		reqsk_queue_removed(&inet_csk(req->rsk_listener)->icsk_accept_queue, req);
+
+		if (sk != req->rsk_listener) {
+			/* another listening sk has been selected,
+			 * migrate the req to it.
+			 */
+			struct request_sock *nreq;
+
+			/* hold a refcnt for the nreq->rsk_listener
+			 * which is assigned in reqsk_clone()
+			 */
+			sock_hold(sk);
+			nreq = inet_reqsk_clone(req, sk);
+			if (!nreq) {
+				inet_child_forget(sk, req, child);
+				goto child_put;
+			}
+
+			refcount_set(&nreq->rsk_refcnt, 1);
+			if (inet_csk_reqsk_queue_add(sk, nreq, child)) {
+				reqsk_migrate_reset(req);
+				reqsk_put(req);
+				return child;
+			}
+
+			reqsk_migrate_reset(nreq);
+			__reqsk_free(nreq);
+		} else if (inet_csk_reqsk_queue_add(sk, req, child)) {
 			return child;
+		}
 	}
 	/* Too bad, another child took ownership of the request, undo. */
+child_put:
 	bh_unlock_sock(child);
 	sock_put(child);
 	return NULL;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 4f5b68a90be9..6cb8e269f1ab 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2002,13 +2002,21 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			goto csum_error;
 		}
 		if (unlikely(sk->sk_state != TCP_LISTEN)) {
-			inet_csk_reqsk_queue_drop_and_put(sk, req);
-			goto lookup;
+			nsk = reuseport_migrate_sock(sk, req_to_sk(req), skb);
+			if (!nsk) {
+				inet_csk_reqsk_queue_drop_and_put(sk, req);
+				goto lookup;
+			}
+			sk = nsk;
+			/* reuseport_migrate_sock() has already held one sk_refcnt
+			 * before returning.
+			 */
+		} else {
+			/* We own a reference on the listener, increase it again
+			 * as we might lose it too soon.
+			 */
+			sock_hold(sk);
 		}
-		/* We own a reference on the listener, increase it again
-		 * as we might lose it too soon.
-		 */
-		sock_hold(sk);
 		refcounted = true;
 		nsk = NULL;
 		if (!tcp_filter(sk, skb)) {
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7513ba45553d..f258a4c0da71 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -775,8 +775,8 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		goto listen_overflow;
 
 	if (own_req && rsk_drop_req(req)) {
-		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
-		inet_csk_reqsk_queue_drop_and_put(sk, req);
+		reqsk_queue_removed(&inet_csk(req->rsk_listener)->icsk_accept_queue, req);
+		inet_csk_reqsk_queue_drop_and_put(req->rsk_listener, req);
 		return child;
 	}
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4435fa342e7a..4d71464094b3 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1664,10 +1664,18 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			goto csum_error;
 		}
 		if (unlikely(sk->sk_state != TCP_LISTEN)) {
-			inet_csk_reqsk_queue_drop_and_put(sk, req);
-			goto lookup;
+			nsk = reuseport_migrate_sock(sk, req_to_sk(req), skb);
+			if (!nsk) {
+				inet_csk_reqsk_queue_drop_and_put(sk, req);
+				goto lookup;
+			}
+			sk = nsk;
+			/* reuseport_migrate_sock() has already held one sk_refcnt
+			 * before returning.
+			 */
+		} else {
+			sock_hold(sk);
 		}
-		sock_hold(sk);
 		refcounted = true;
 		nsk = NULL;
 		if (!tcp_filter(sk, skb)) {
-- 
2.30.2

