Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1712D11ED
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgLGN1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:27:12 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:5055 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgLGN1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:27:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347631; x=1638883631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Mn37ssPc5fLpkPkbvi2B7Yse7CJP+fPNOo1utZBK/SA=;
  b=VOgq0R5IKg9Pud0KwUs6mWzBV9/UxK52YqEklWmZVdE970oWtCrPRQ2k
   MvLq2Daa3WbLopjrUZmda41z98S1tJO38Q3kRNvcB9Rj5O1ZHnoJSm718
   AI/w+6x+nzdqIhQr28gayi+IhadOwnRFNGRksj9IbD+xVoSAL18x9JfMS
   8=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="102282574"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 07 Dec 2020 13:26:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 23FD2A17C5;
        Mon,  7 Dec 2020 13:26:26 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:26:26 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:26:15 +0000
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
Subject: [PATCH v2 bpf-next 04/13] tcp: Introduce inet_csk_reqsk_queue_migrate().
Date:   Mon, 7 Dec 2020 22:24:47 +0900
Message-ID: <20201207132456.65472-5-kuniyu@amazon.co.jp>
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

This patch defines a new function to migrate ESTABLISHED/SYN_RECV sockets.

Listening sockets hold incoming connections as a linked list of struct
request_sock in the accept queue, and each request has reference to its
full socket and listener. In inet_csk_reqsk_queue_migrate(), we only unlink
the requests from the closing listener's queue and relink them to the head
of the new listener's queue. We do not process each request and its
reference to the listener, so the migration completes in O(1) time
complexity.

Moreover, if TFO requests caused RST before 3WHS has completed, they are
held in the listener's TFO queue to prevent DDoS attack. Thus, we also
migrate the requests in the TFO queue in the same way.

After 3WHS has completed, there are three access patterns to incoming
sockets:

  (1) access to the full socket instead of request_sock
  (2) access to request_sock from access queue
  (3) access to request_sock from TFO queue

In the first case, the full socket does not have a reference to its request
socket and listener, so we do not need the correct listener set in the
request socket. In the second case, we always have the correct listener and
currently do not use req->rsk_listener. However, in the third case of
TCP_SYN_RECV sockets, we take special care in the next commit.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/inet_connection_sock.h |  1 +
 net/ipv4/inet_connection_sock.c    | 68 ++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

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
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1451aa9712b0..5da38a756e4c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -992,6 +992,74 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
 }
 EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
 
+void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
+{
+	struct request_sock_queue *old_accept_queue, *new_accept_queue;
+	struct fastopen_queue *old_fastopenq, *new_fastopenq;
+	spinlock_t *l1, *l2, *l3, *l4;
+
+	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
+	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
+	old_fastopenq = &old_accept_queue->fastopenq;
+	new_fastopenq = &new_accept_queue->fastopenq;
+
+	l1 = &old_accept_queue->rskq_lock;
+	l2 = &new_accept_queue->rskq_lock;
+	l3 = &old_fastopenq->lock;
+	l4 = &new_fastopenq->lock;
+
+	/* sk is never selected as the new listener from reuse->socks[],
+	 * so inversion deadlock does not happen here,
+	 * but change the order to avoid the warning of lockdep.
+	 */
+	if (sk < nsk) {
+		swap(l1, l2);
+		swap(l3, l4);
+	}
+
+	spin_lock(l1);
+	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
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
+	spin_unlock(l2);
+	spin_unlock(l1);
+
+	spin_lock_bh(l3);
+	spin_lock_bh_nested(l4, SINGLE_DEPTH_NESTING);
+
+	new_fastopenq->qlen += old_fastopenq->qlen;
+	old_fastopenq->qlen = 0;
+
+	if (old_fastopenq->rskq_rst_head) {
+		if (new_fastopenq->rskq_rst_head)
+			old_fastopenq->rskq_rst_tail->dl_next = new_fastopenq->rskq_rst_head;
+		else
+			old_fastopenq->rskq_rst_tail = new_fastopenq->rskq_rst_tail;
+
+		new_fastopenq->rskq_rst_head = old_fastopenq->rskq_rst_head;
+		old_fastopenq->rskq_rst_head = NULL;
+		old_fastopenq->rskq_rst_tail = NULL;
+	}
+
+	spin_unlock_bh(l4);
+	spin_unlock_bh(l3);
+}
+EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
+
 struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
 					 struct request_sock *req, bool own_req)
 {
-- 
2.17.2 (Apple Git-113)

