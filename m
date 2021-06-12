Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9A3A4EC0
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhFLMga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:36:30 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:4097 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhFLMg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623501268; x=1655037268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F7OVG+H+PSg0ydZ5+QuzxoJpb0B28zekxN3YnBZ46KE=;
  b=Fx2p5ehjhX8eo1dBO+SC87G+oujvrbBdjT4BVpH7seN6cTh9mSb5pZJZ
   gfNWShkWc/ObIi6kTa4EFaBmMaDgxIt3PbZ5rfjcFOrJLl01U1+Tmzop3
   JW7WKyM+OORpreaG55fCBpdlRQV74aI9SLKVAbPCLSTFc/HAqQMYze2uB
   c=;
X-IronPort-AV: E=Sophos;i="5.83,268,1616457600"; 
   d="scan'208";a="115428336"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 12 Jun 2021 12:34:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 23A3BA20CB;
        Sat, 12 Jun 2021 12:34:25 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:34:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:34:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 bpf-next 07/11] tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
Date:   Sat, 12 Jun 2021 21:32:20 +0900
Message-ID: <20210612123224.12525-8-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210612123224.12525-1-kuniyu@amazon.co.jp>
References: <20210612123224.12525-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch also changes the code to call reuseport_migrate_sock() and
inet_reqsk_clone(), but unlike the other cases, we do not call
inet_reqsk_clone() right after reuseport_migrate_sock().

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
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/inet_connection_sock.c | 34 ++++++++++++++++++++++++++++++---
 net/ipv4/tcp_ipv4.c             | 20 +++++++++++++------
 net/ipv4/tcp_minisocks.c        |  4 ++--
 net/ipv6/tcp_ipv6.c             | 14 +++++++++++---
 4 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f4b771e45ac1..0eea878edc30 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1114,12 +1114,40 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
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
+			 * which is assigned in inet_reqsk_clone()
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

