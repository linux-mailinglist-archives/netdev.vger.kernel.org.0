Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56E1660D0
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgBTPVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:21:01 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46799 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgBTPVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:21:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582212060; x=1613748060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Dx0lKYkEiqMqemPmfn1Bf0IFhfhnzUzlYTFePw/t/OQ=;
  b=Dbv7d6A/fsaSxir567fPhfTVZs/vVyrYKCJKBh8tBVpmrFWhIeH0XI6O
   sZLHpo0CF8o+qGo9OwOkk3LzEfxBJyp0BjTsclt5qqdYPHJ1oMLW6r9o1
   OQveayLp1xYxnpwo4TtCADS7TIcYfo7YiEGCVWn3U1S9oLiQAUPdxz6Fe
   c=;
IronPort-SDR: PcHABNTIMG4xJ8FDOESt9yHXaxQxeJRF9xVg1grjuS7X83cPZKADKJY5eYffkxp9tL7RiQIwTD
 Vf3gY4dCydhQ==
X-IronPort-AV: E=Sophos;i="5.70,464,1574121600"; 
   d="scan'208";a="18780862"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 20 Feb 2020 15:21:00 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 96F69A33EA;
        Thu, 20 Feb 2020 15:20:57 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 20 Feb 2020 15:20:56 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.50) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Feb 2020 15:20:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH net-next 3/3] tcp: Prevent port hijacking when ports are exhausted.
Date:   Fri, 21 Feb 2020 00:20:20 +0900
Message-ID: <20200220152020.13056-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200220152020.13056-1-kuniyu@amazon.co.jp>
References: <20200220152020.13056-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13P01UWA001.ant.amazon.com (10.43.160.213) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If all of the sockets bound to the same port have SO_REUSEADDR and
SO_REUSEPORT enabled, any other user can hijack the port by exhausting all
ephemeral ports, binding sockets to (addr, 0) and calling listen().

In this case, we should be able to bind sockets to the same port only if
the user has the first listening socket on the port or if the existing
socket is in TIME_WAIT.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index cddeab240ea6..a6d9ee19baeb 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -131,7 +131,7 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 {
 	struct sock *sk2;
 	bool reuse = sk->sk_reuse;
-	bool reuseport = !!sk->sk_reuseport && reuseport_ok;
+	bool reuseport = !!sk->sk_reuseport;
 	kuid_t uid = sock_i_uid((struct sock *)sk);
 
 	/*
@@ -148,10 +148,16 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 		     sk->sk_bound_dev_if == sk2->sk_bound_dev_if)) {
 			if (reuse && sk2->sk_reuse &&
 			    sk2->sk_state != TCP_LISTEN) {
-				if (!relax &&
+				if ((!relax ||
+				     (!reuseport_ok &&
+				      reuseport && sk2->sk_reuseport &&
+				      !rcu_access_pointer(sk->sk_reuseport_cb) &&
+				      (sk2->sk_state != TCP_TIME_WAIT &&
+				       !uid_eq(uid, sock_i_uid(sk2))))) &&
 				    inet_rcv_saddr_equal(sk, sk2, true))
 					break;
-			} else if (!reuseport || !sk2->sk_reuseport ||
+			} else if (!reuseport_ok ||
+				   !reuseport || !sk2->sk_reuseport ||
 				   rcu_access_pointer(sk->sk_reuseport_cb) ||
 				   (sk2->sk_state != TCP_TIME_WAIT &&
 				    !uid_eq(uid, sock_i_uid(sk2)))) {
-- 
2.17.2 (Apple Git-113)

