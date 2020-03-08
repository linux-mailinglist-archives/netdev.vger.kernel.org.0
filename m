Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C315517D56C
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 19:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgCHSQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 14:16:44 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:50861 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgCHSQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 14:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583691403; x=1615227403;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NDL7Y5QfL6R3BNF4LFwU01epelfSlp5iae0i4eSC7iU=;
  b=Bvm8pbdrGeCEwlPFK+ZQEJ2He3iMTE4IQY7O53NSlXKYd9LeVNmJ/LjC
   qfvLcalnAAEFiQizzGb4XpJkDvnZUgUkRDxFA6GDyZB5X83J2cY4SyEWz
   bIcRjp4BrvVJOlu5we8p2cSJz1WxaGyYei1IhWLul0dodZpwfsF4i3p3q
   8=;
IronPort-SDR: A262cuuT62V4dIjbFt8iFeihU75DswyVGMfP+DYUWq/Z9OMuAWJe8/K7rig5QmyLBUnV7wgYlt
 nmNGDvzARgIA==
X-IronPort-AV: E=Sophos;i="5.70,530,1574121600"; 
   d="scan'208";a="31289413"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 08 Mar 2020 18:16:42 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 09096A25EB;
        Sun,  8 Mar 2020 18:16:41 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 8 Mar 2020 18:16:41 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.100) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 8 Mar 2020 18:16:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v4 net-next 1/5] tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
Date:   Mon, 9 Mar 2020 03:16:11 +0900
Message-ID: <20200308181615.90135-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200308181615.90135-1-kuniyu@amazon.co.jp>
References: <20200308181615.90135-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D22UWC001.ant.amazon.com (10.43.162.192) To
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

