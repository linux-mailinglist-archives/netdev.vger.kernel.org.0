Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C06174685
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 12:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgB2LgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 06:36:11 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:9830 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgB2LgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 06:36:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582976171; x=1614512171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NDL7Y5QfL6R3BNF4LFwU01epelfSlp5iae0i4eSC7iU=;
  b=brs7hQ+NAy14AHuBdHpAign1nt+gl9KS9qodhP3tezRO8xP7BVzqLHKZ
   DFG8Idd4JMkoZkkwFDuS46FFnXv2LqooCqU6+bBD+kw5ptcOAgelunfg3
   Vgz/2Wbcf0zFOJBM7lHGPfLC4azIkgpRKYdNM4JryPIg5AXZ1OibAYQsu
   Q=;
IronPort-SDR: vme8oqba1mCmUTHFbHOoPpC/OtHog9abH+onQ6OX2yxOwg3aw4FIVgKsGRFFZQ+Hnmd9gnelka
 GoX754k1TFWQ==
X-IronPort-AV: E=Sophos;i="5.70,499,1574121600"; 
   d="scan'208";a="19914943"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 29 Feb 2020 11:36:10 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 4C109A1D19;
        Sat, 29 Feb 2020 11:36:09 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 11:36:08 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.171) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 29 Feb 2020 11:36:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v3 net-next 1/4] tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
Date:   Sat, 29 Feb 2020 20:35:51 +0900
Message-ID: <20200229113554.78338-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200229113554.78338-1-kuniyu@amazon.co.jp>
References: <20200229113554.78338-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.171]
X-ClientProxiedBy: EX13D23UWA003.ant.amazon.com (10.43.160.194) To
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

