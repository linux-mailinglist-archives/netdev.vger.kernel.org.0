Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B831838223B
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 02:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhEQA0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 20:26:13 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:28308 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbhEQA0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 20:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621211096; x=1652747096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3BamnI44Y/t+2s4wsqQbqGjv+Lcoj+RZrIhsf/JebJ4=;
  b=e73hllTTy/8P/2VFe2E1EmjIB6mZWHLXUegwsMhfS9BwQgHgqifAF498
   O3zz7wERjXWcC9cLPrhgrVRys3VlBMk9k9l5iNxROUpsJl1tJFhAICbBd
   SrzEL/KBV6oIHqS1QrZzsNBu6ENB8y6YLH/QeVfbl/sOR30npTvsSD1qH
   0=;
X-IronPort-AV: E=Sophos;i="5.82,306,1613433600"; 
   d="scan'208";a="125970494"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 17 May 2021 00:24:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 50AD6A1AE7;
        Mon, 17 May 2021 00:24:52 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 17 May 2021 00:24:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.28) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 17 May 2021 00:24:46 +0000
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
Subject: [PATCH v6 bpf-next 06/11] tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.
Date:   Mon, 17 May 2021 09:22:53 +0900
Message-ID: <20210517002258.75019-7-kuniyu@amazon.co.jp>
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

As with the preceding patch, this patch changes reqsk_timer_handler() to
call reuseport_migrate_sock() and reqsk_clone() to migrate in-flight
requests at retransmitting SYN+ACKs. If we can select a new listener and
clone the request, we resume setting the SYN+ACK timer for the new req. If
we can set the timer, we call inet_ehash_insert() to unhash the old req and
put the new req into ehash.

The noteworthy point here is that by unhashing the old req, another CPU
processing it may lose the "own_req" race in tcp_v[46]_syn_recv_sock() and
drop the final ACK packet. However, the new timer will recover this
situation.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 75 ++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 07e97b2f3635..c1f068464363 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -735,10 +735,20 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
 	return nreq;
 }
 
+static void reqsk_queue_migrated(struct request_sock_queue *queue,
+				 const struct request_sock *req)
+{
+	if (req->num_timeout == 0)
+		atomic_inc(&queue->young);
+	atomic_inc(&queue->qlen);
+}
+
 static void reqsk_migrate_reset(struct request_sock *req)
 {
+	req->saved_syn = NULL;
+	inet_rsk(req)->ireq_opt = NULL;
 #if IS_ENABLED(CONFIG_IPV6)
-	inet_rsk(req)->ipv6_opt = NULL;
+	inet_rsk(req)->pktopts = NULL;
 #endif
 }
 
@@ -782,15 +792,39 @@ EXPORT_SYMBOL(inet_csk_reqsk_queue_drop_and_put);
 static void reqsk_timer_handler(struct timer_list *t)
 {
 	struct request_sock *req = from_timer(req, t, rsk_timer);
+	struct request_sock *nreq = NULL, *oreq = req;
 	struct sock *sk_listener = req->rsk_listener;
-	struct net *net = sock_net(sk_listener);
-	struct inet_connection_sock *icsk = inet_csk(sk_listener);
-	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
+	struct inet_connection_sock *icsk;
+	struct request_sock_queue *queue;
+	struct net *net;
 	int max_syn_ack_retries, qlen, expire = 0, resend = 0;
 
-	if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
-		goto drop;
+	if (inet_sk_state_load(sk_listener) != TCP_LISTEN) {
+		struct sock *nsk;
+
+		nsk = reuseport_migrate_sock(sk_listener, req_to_sk(req), NULL);
+		if (!nsk)
+			goto drop;
+
+		nreq = inet_reqsk_clone(req, nsk);
+		if (!nreq)
+			goto drop;
+
+		/* The new timer for the cloned req can decrease the 2
+		 * by calling inet_csk_reqsk_queue_drop_and_put(), so
+		 * hold another count to prevent use-after-free and
+		 * call reqsk_put() just before return.
+		 */
+		refcount_set(&nreq->rsk_refcnt, 2 + 1);
+		timer_setup(&nreq->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
+		reqsk_queue_migrated(&inet_csk(nsk)->icsk_accept_queue, req);
+
+		req = nreq;
+		sk_listener = nsk;
+	}
 
+	icsk = inet_csk(sk_listener);
+	net = sock_net(sk_listener);
 	max_syn_ack_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
 	/* Normally all the openreqs are young and become mature
 	 * (i.e. converted to established socket) for first timeout.
@@ -809,6 +843,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	 * embrions; and abort old ones without pity, if old
 	 * ones are about to clog our table.
 	 */
+	queue = &icsk->icsk_accept_queue;
 	qlen = reqsk_queue_len(queue);
 	if ((qlen << 1) > max(8U, READ_ONCE(sk_listener->sk_max_ack_backlog))) {
 		int young = reqsk_queue_len_young(queue) << 1;
@@ -833,10 +868,36 @@ static void reqsk_timer_handler(struct timer_list *t)
 			atomic_dec(&queue->young);
 		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
 		mod_timer(&req->rsk_timer, jiffies + timeo);
+
+		if (!nreq)
+			return;
+
+		if (!inet_ehash_insert(req_to_sk(nreq), req_to_sk(oreq), NULL)) {
+			/* delete timer */
+			inet_csk_reqsk_queue_drop(sk_listener, nreq);
+			goto drop;
+		}
+
+		reqsk_migrate_reset(oreq);
+		reqsk_queue_removed(&inet_csk(oreq->rsk_listener)->icsk_accept_queue, oreq);
+		reqsk_put(oreq);
+
+		reqsk_put(nreq);
 		return;
 	}
+
 drop:
-	inet_csk_reqsk_queue_drop_and_put(sk_listener, req);
+	/* Even if we can clone the req, we may need not retransmit any more
+	 * SYN+ACKs (nreq->num_timeout > max_syn_ack_retries, etc), or another
+	 * CPU may win the "own_req" race so that inet_ehash_insert() fails.
+	 */
+	if (nreq) {
+		reqsk_migrate_reset(nreq);
+		reqsk_queue_removed(queue, nreq);
+		__reqsk_free(nreq);
+	}
+
+	inet_csk_reqsk_queue_drop_and_put(oreq->rsk_listener, oreq);
 }
 
 static void reqsk_queue_hash_req(struct request_sock *req,
-- 
2.30.2

