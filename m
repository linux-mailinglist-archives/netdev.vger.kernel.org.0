Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD79C2CA627
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403965AbgLAOqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:46:43 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:51228 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389033AbgLAOqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:46:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606834002; x=1638370002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=uyJ//ZGcPRgBO7Ln6GyuNrk95n/KiRMWJ9SsDfr+V+U=;
  b=Qt6rUKEy0tbmlAkaTMJzDpcg6ErA7P8Awa4E9UGGWlfZrlp1DpqWDHUh
   qzoEx0ILVJcili2xppDn24JwlhPFLRJbJj5o+/2DWSqqY1d+5wSMSYnwM
   6y7KobekHNLwRDXg5SCbB43jT3tbMhtKfoA4o17IRo+4sBJzFQF4XREm8
   U=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="92542266"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 14:45:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id ECBBCA20D1;
        Tue,  1 Dec 2020 14:45:57 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:45:57 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:45:52 +0000
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
Subject: [PATCH v1 bpf-next 04/11] tcp: Migrate TFO requests causing RST during TCP_SYN_RECV.
Date:   Tue, 1 Dec 2020 23:44:11 +0900
Message-ID: <20201201144418.35045-5-kuniyu@amazon.co.jp>
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

A TFO request socket is only freed after BOTH 3WHS has completed (or
aborted) and the child socket has been accepted (or its listener has been
closed). Hence, depending on the order, there can be two kinds of request
sockets in the accept queue.

  3WHS -> accept : TCP_ESTABLISHED
  accept -> 3WHS : TCP_SYN_RECV

Unlike TCP_ESTABLISHED socket, accept() does not free the request socket
for TCP_SYN_RECV socket. It is freed later at reqsk_fastopen_remove().
Also, it accesses request_sock.rsk_listener. So, in order to complete TFO
socket migration, we have to set the current listener to it at accept()
before reqsk_fastopen_remove().

Moreover, if TFO request caused RST before 3WHS has completed, it is held
in the listener's TFO queue to prevent DDoS attack. Thus, we also have to
migrate the requests in TFO queue.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 35 ++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index b27241ea96bd..361efe55b1ad 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -500,6 +500,16 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 	    tcp_rsk(req)->tfo_listener) {
 		spin_lock_bh(&queue->fastopenq.lock);
 		if (tcp_rsk(req)->tfo_listener) {
+			if (req->rsk_listener != sk) {
+				/* TFO request was migrated to another listener so
+				 * the new listener must be used in reqsk_fastopen_remove()
+				 * to hold requests which cause RST.
+				 */
+				sock_put(req->rsk_listener);
+				sock_hold(sk);
+				req->rsk_listener = sk;
+			}
+
 			/* We are still waiting for the final ACK from 3WHS
 			 * so can't free req now. Instead, we set req->sk to
 			 * NULL to signify that the child socket is taken
@@ -954,7 +964,6 @@ static void inet_child_forget(struct sock *sk, struct request_sock *req,
 
 	if (sk->sk_protocol == IPPROTO_TCP && tcp_rsk(req)->tfo_listener) {
 		BUG_ON(rcu_access_pointer(tcp_sk(child)->fastopen_rsk) != req);
-		BUG_ON(sk != req->rsk_listener);
 
 		/* Paranoid, to prevent race condition if
 		 * an inbound pkt destined for child is
@@ -995,6 +1004,7 @@ EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
 void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
 {
 	struct request_sock_queue *old_accept_queue, *new_accept_queue;
+	struct fastopen_queue *old_fastopenq, *new_fastopenq;
 
 	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
 	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
@@ -1019,6 +1029,29 @@ void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
 
 	spin_unlock(&new_accept_queue->rskq_lock);
 	spin_unlock(&old_accept_queue->rskq_lock);
+
+	old_fastopenq = &old_accept_queue->fastopenq;
+	new_fastopenq = &new_accept_queue->fastopenq;
+
+	spin_lock_bh(&old_fastopenq->lock);
+	spin_lock_bh(&new_fastopenq->lock);
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
+	spin_unlock_bh(&new_fastopenq->lock);
+	spin_unlock_bh(&old_fastopenq->lock);
 }
 EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
 
-- 
2.17.2 (Apple Git-113)

