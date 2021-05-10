Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10316377AC3
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 05:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhEJDsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 23:48:10 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:17111 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhEJDsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 23:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1620618425; x=1652154425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LEdx0iXAMe339XzT3Of6SAMIB1IbQ5SjpP/hMEsX5r0=;
  b=Q1rpff8g8L51hMrgRVYvAFA7vMcZ1EQ6yqP4oOhAezJwtCQ2WA3jQu2N
   ISUOcfChWCjrEsqi5r8hfYLQ/eRROGMoIarC2goMkrD3hhyTcF5lUEfrl
   vM8IBa9JzDLe/t4nKDNALlv7eUmZ5Fssj1d8j9gu3SG5O9xxcFsvt6i3e
   o=;
X-IronPort-AV: E=Sophos;i="5.82,286,1613433600"; 
   d="scan'208";a="454403"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 10 May 2021 03:47:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id B2A5CA06CC;
        Mon, 10 May 2021 03:46:54 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 May 2021 03:46:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.17) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 May 2021 03:46:43 +0000
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
Subject: [PATCH v5 bpf-next 07/11] tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
Date:   Mon, 10 May 2021 12:44:29 +0900
Message-ID: <20210510034433.52818-8-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510034433.52818-1-kuniyu@amazon.co.jp>
References: <20210510034433.52818-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.17]
X-ClientProxiedBy: EX13D18UWC001.ant.amazon.com (10.43.162.105) To
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
 net/ipv4/inet_connection_sock.c | 30 +++++++++++++++++++++++++++++-
 net/ipv4/tcp_ipv4.c             | 20 ++++++++++++++------
 net/ipv6/tcp_ipv6.c             | 14 +++++++++++---
 3 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index e690d1cff36e..fe666dc5c621 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1075,10 +1075,38 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
 	if (own_req) {
 		inet_csk_reqsk_queue_drop(sk, req);
 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
-		if (inet_csk_reqsk_queue_add(sk, req, child))
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
+			nreq = reqsk_clone(req, sk);
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
index 312184cead57..214495d02143 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2000,13 +2000,21 @@ int tcp_v4_rcv(struct sk_buff *skb)
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
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5f47c0b6e3de..aea8e75d3fed 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1663,10 +1663,18 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
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

