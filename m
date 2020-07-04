Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A212146E5
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 17:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgGDP3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 11:29:15 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:3646 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgGDP3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 11:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1593876554; x=1625412554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NPkJrX3EyQ85JM0NHEfDtr3sIhJQksmAt1JCMZB2Vjo=;
  b=gQFt9lzvHYvUR4tqrMSjdQNJt22donBg53Adx2AvmLr4RKhIN59Ptc/o
   MsztpPyp4ntkr1F5mvPmukYMJFy7aAitDC/ghJ4LaSR/2PiLLl5+o3PBh
   m9gxduu6JAk/PeW748IIpDlRZ2hF/K1sK33/G+zZj/yULTF4E5G/FEeUs
   Y=;
IronPort-SDR: GzDRlpLyYrbLomBtArFger5FhWJgW7lMxgYzOwym3Xupt0XhuCFp3eMJYyY0Ujzhvsy5EMcl09
 Y4OKl0nsqnJA==
X-IronPort-AV: E=Sophos;i="5.75,312,1589241600"; 
   d="scan'208";a="56013162"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Jul 2020 15:29:14 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 369D9A222A;
        Sat,  4 Jul 2020 15:29:13 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 15:29:12 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.140) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 15:29:08 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <osa-contribution-log@amazon.com>, Julian Anastasov <ja@ssi.bg>
Subject: [PATCH v2 net-next] inet: Remove an unnecessary argument of syn_ack_recalc().
Date:   Sun, 5 Jul 2020 00:28:52 +0900
Message-ID: <20200704152852.39935-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200704081158.83489-1-kuniyu@amazon.co.jp>
References: <20200704081158.83489-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D13UWA002.ant.amazon.com (10.43.160.172) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0c3d79bce48034018e840468ac5a642894a521a3 ("tcp: reduce SYN-ACK
retrans for TCP_DEFER_ACCEPT") introduces syn_ack_recalc() which decides
if a minisock is held and a SYN+ACK is retransmitted or not.

If rskq_defer_accept is not zero in syn_ack_recalc(), max_retries always
has the same value because max_retries is overwritten by rskq_defer_accept
in reqsk_timer_handler().

This commit adds two changes:
- remove max_retries from the arguments of syn_ack_recalc() and use
   rskq_defer_accept instead.
- rename thresh to max_retries for readability.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
CC: Julian Anastasov <ja@ssi.bg>
---
 net/ipv4/inet_connection_sock.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index afaf582a5aa9..323cdb8ce901 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -648,20 +648,22 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
 EXPORT_SYMBOL_GPL(inet_csk_route_child_sock);
 
 /* Decide when to expire the request and when to resend SYN-ACK */
-static inline void syn_ack_recalc(struct request_sock *req, const int thresh,
-				  const int max_retries,
+static inline void syn_ack_recalc(struct request_sock *req, const int max_retries,
 				  const u8 rskq_defer_accept,
 				  int *expire, int *resend)
 {
 	if (!rskq_defer_accept) {
-		*expire = req->num_timeout >= thresh;
+		*expire = req->num_timeout >= max_retries;
 		*resend = 1;
 		return;
 	}
-	*expire = req->num_timeout >= thresh &&
-		  (!inet_rsk(req)->acked || req->num_timeout >= max_retries);
-	/*
-	 * Do not resend while waiting for data after ACK,
+	/* If a bare ACK has already been dropped, the client is alive, so
+	 * do not free the request_sock to drop a bare ACK at most
+	 * rskq_defer_accept times and wait for data.
+	 */
+	*expire = req->num_timeout >= max_retries &&
+		  (!inet_rsk(req)->acked || req->num_timeout >= rskq_defer_accept);
+	/* Do not resend while waiting for data after ACK,
 	 * start to resend on end of deferring period to give
 	 * last chance for data or ACK to create established socket.
 	 */
@@ -720,15 +722,12 @@ static void reqsk_timer_handler(struct timer_list *t)
 	struct net *net = sock_net(sk_listener);
 	struct inet_connection_sock *icsk = inet_csk(sk_listener);
 	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
-	int qlen, expire = 0, resend = 0;
-	int max_retries, thresh;
-	u8 defer_accept;
+	int max_retries, qlen, expire = 0, resend = 0;
 
 	if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
 		goto drop;
 
 	max_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
-	thresh = max_retries;
 	/* Normally all the openreqs are young and become mature
 	 * (i.e. converted to established socket) for first timeout.
 	 * If synack was not acknowledged for 1 second, it means
@@ -750,17 +749,14 @@ static void reqsk_timer_handler(struct timer_list *t)
 	if ((qlen << 1) > max(8U, READ_ONCE(sk_listener->sk_max_ack_backlog))) {
 		int young = reqsk_queue_len_young(queue) << 1;
 
-		while (thresh > 2) {
+		while (max_retries > 2) {
 			if (qlen < young)
 				break;
-			thresh--;
+			max_retries--;
 			young <<= 1;
 		}
 	}
-	defer_accept = READ_ONCE(queue->rskq_defer_accept);
-	if (defer_accept)
-		max_retries = defer_accept;
-	syn_ack_recalc(req, thresh, max_retries, defer_accept,
+	syn_ack_recalc(req, max_retries, READ_ONCE(queue->rskq_defer_accept),
 		       &expire, &resend);
 	req->rsk_ops->syn_ack_timeout(req);
 	if (!expire &&
-- 
2.17.2 (Apple Git-113)

