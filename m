Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7E2D11EF
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgLGN1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:27:31 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:36694 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLGN1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347650; x=1638883650;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Vonv/Q6hCNxXl/Pnwc4Bge1XzPa1igFZTKnOjMRgcwA=;
  b=QeEghicxIcu1iQIlOViankC8PG6bWG7rldwwU3Q/lFsPymngP529tYf6
   tu4Hh3OcdH0fn7Ymd5HC3Va4IbxwCEYwImMBNmN0h3pNErGslIpScjMYA
   O64s91Ubkhj+QFHlMkrzTixWJi5iCGzLHFii3CgyZ4A7DwqBIdtzwXZYX
   A=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="69561666"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Dec 2020 13:26:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 2DEAD28481E;
        Mon,  7 Dec 2020 13:26:45 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:26:45 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:26:40 +0000
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
Subject: [PATCH v2 bpf-next 05/13] tcp: Set the new listener to migrated TFO requests.
Date:   Mon, 7 Dec 2020 22:24:48 +0900
Message-ID: <20201207132456.65472-6-kuniyu@amazon.co.jp>
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

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 5da38a756e4c..143590858c2e 100644
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
-- 
2.17.2 (Apple Git-113)

