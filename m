Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1CE116F8B9
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgBZHq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:46:57 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:28442 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbgBZHq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582703215; x=1614239215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3vezOoOWgsJ4V4lu7//7IhJSKybYYvn/FqtnOEQJJu4=;
  b=GYzxMqItv8A7I327L0YZwOC6OKNZje1b9K7/XdeTE1pcJ2HfBUwejhfS
   z5UIzRYbSajxw7oElnbqL0k+zwtvyLVyRWUOlADTIqdgJY1fwRgQeaD0w
   eOO8tY1N4nYgMn3lfnnj26V/lnmaXC2rLy8jun+lRJZLASH2EEzID9kEa
   o=;
IronPort-SDR: TQDXEotAWUWS2EpePcbZNyUxHOYKUu6E91LJodW5HVM5UZ2Eb48LgobhqXu/n8152Y/s8iFsSU
 Mx0dYRzgqBVw==
X-IronPort-AV: E=Sophos;i="5.70,487,1574121600"; 
   d="scan'208";a="19712359"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 26 Feb 2020 07:46:54 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id B3A09A1CAB;
        Wed, 26 Feb 2020 07:46:52 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Feb 2020 07:46:51 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.160.8) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Feb 2020 07:46:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v2 net-next 3/3] tcp: Prevent port hijacking when ports are exhausted.
Date:   Wed, 26 Feb 2020 16:46:31 +0900
Message-ID: <20200226074631.67688-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200226074631.67688-1-kuniyu@amazon.co.jp>
References: <20200226074631.67688-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D21UWA003.ant.amazon.com (10.43.160.184) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If all of the sockets bound to the same port have SO_REUSEADDR and
SO_REUSEPORT enabled, any other user can hijack the port by exhausting all
ephemeral ports, binding sockets to (addr, 0) and calling listen().

If both of SO_REUSEADDR and SO_REUSEPORT are enabled, the restriction of
SO_REUSEPORT should be taken into account so that can only one socket be in
TCP_LISTEN.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index cddeab240ea6..d27ed5fe7147 100644
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
+				      (sk2->sk_state == TCP_TIME_WAIT ||
+				       uid_eq(uid, sock_i_uid(sk2))))) &&
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

