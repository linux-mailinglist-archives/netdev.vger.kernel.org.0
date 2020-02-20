Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA7D1660CD
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgBTPUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:20:52 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46778 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgBTPUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582212053; x=1613748053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NDL7Y5QfL6R3BNF4LFwU01epelfSlp5iae0i4eSC7iU=;
  b=mM43F2z5ycMeXU8g5PDS+6rmtCcE82XTyfKWY/gWGqJSzSYROGXn8wyn
   PntuKIGmebc9tsgdkneBH3yfXzC2/BWpfYmcaC4XlJsdC69vPcGId72/X
   N2hz0uFcUZZJInvJ4FNkTQi/wEFgkE36siSNqwKpmXYNRPfe4ZNeLK3KF
   M=;
IronPort-SDR: 5v9EPc6Y/t1BliH1+dp38NhIEI8S/MkjzY6C2AeCVx/tGNBTp+d2q6e48MwwAUuP/n4gGQvdxJ
 3RdYyN3EDPjw==
X-IronPort-AV: E=Sophos;i="5.70,464,1574121600"; 
   d="scan'208";a="18780837"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 20 Feb 2020 15:20:52 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 52420A2571;
        Thu, 20 Feb 2020 15:20:48 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 20 Feb 2020 15:20:48 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.50) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Feb 2020 15:20:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH net-next 1/3] tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
Date:   Fri, 21 Feb 2020 00:20:18 +0900
Message-ID: <20200220152020.13056-2-kuniyu@amazon.co.jp>
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

