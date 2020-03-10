Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835E917F16B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 09:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCJIFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 04:05:52 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11531 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgCJIFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 04:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583827552; x=1615363552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NDL7Y5QfL6R3BNF4LFwU01epelfSlp5iae0i4eSC7iU=;
  b=Y9TmdTIjKUgckWNBG3NFY/MWNPxyn9K08lKNKEd/11VepEA4ja8SmCaN
   qm3EpmMrP9z5owSnGTWs49ZbgMZ0RIheQAytxB1oD9pprPLKIK/nCbOK0
   MWUYn2Z6LjWrdsD3qmURm3kOpray0WOWeXLwef+HLb091OOcQY7NkuYXX
   c=;
IronPort-SDR: 7OjCZYy2cL/W3hN5KE4CKaUvTD7IV1+7UUZQ/qblUIFq5AXjsscCbZXMpieAl9fVN6F8rAf7Sw
 wg/c7DJeDJRQ==
X-IronPort-AV: E=Sophos;i="5.70,535,1574121600"; 
   d="scan'208";a="21802750"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Mar 2020 08:05:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id DF95EA2945;
        Tue, 10 Mar 2020 08:05:48 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Mar 2020 08:05:48 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.160.16) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 10 Mar 2020 08:05:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v5 net-next 1/4] tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
Date:   Tue, 10 Mar 2020 17:05:24 +0900
Message-ID: <20200310080527.70180-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200310080527.70180-1-kuniyu@amazon.co.jp>
References: <20200310080527.70180-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.16]
X-ClientProxiedBy: EX13D34UWA003.ant.amazon.com (10.43.160.69) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we get an ephemeral port, the relax is false, so the SO_REUSEADDR
conditions may be evaluated twice. We do not need to check the conditions
again.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a4db79b1b643..2e9549f49a82 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -146,17 +146,15 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 		    (!sk->sk_bound_dev_if ||
 		     !sk2->sk_bound_dev_if ||
 		     sk->sk_bound_dev_if == sk2->sk_bound_dev_if)) {
-			if ((!reuse || !sk2->sk_reuse ||
-			    sk2->sk_state == TCP_LISTEN) &&
-			    (!reuseport || !sk2->sk_reuseport ||
-			     rcu_access_pointer(sk->sk_reuseport_cb) ||
-			     (sk2->sk_state != TCP_TIME_WAIT &&
-			     !uid_eq(uid, sock_i_uid(sk2))))) {
-				if (inet_rcv_saddr_equal(sk, sk2, true))
-					break;
-			}
-			if (!relax && reuse && sk2->sk_reuse &&
+			if (reuse && sk2->sk_reuse &&
 			    sk2->sk_state != TCP_LISTEN) {
+				if (!relax &&
+				    inet_rcv_saddr_equal(sk, sk2, true))
+					break;
+			} else if (!reuseport || !sk2->sk_reuseport ||
+				   rcu_access_pointer(sk->sk_reuseport_cb) ||
+				   (sk2->sk_state != TCP_TIME_WAIT &&
+				    !uid_eq(uid, sock_i_uid(sk2)))) {
 				if (inet_rcv_saddr_equal(sk, sk2, true))
 					break;
 			}
-- 
2.17.2 (Apple Git-113)

