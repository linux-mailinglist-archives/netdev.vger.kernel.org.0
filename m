Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA53174687
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 12:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgB2LgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 06:36:15 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:9976 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgB2LgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 06:36:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582976175; x=1614512175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=HIXyNmOJ8/d4F3iwP8yU6z0U8CCnk4bMqrJAD3qAXLM=;
  b=TMc0KPAQweaQLEXTE2sv4NwwIpjkoE8H2KU41XmHK4JxZtrrFfEMQ0Ek
   XL//FFsQJdWh8x6ykg5JC+qsdBzUVP3Y10+5kHzBt8jrv7IPgeFj4J6FG
   R+1Zm91ao9SYLuM7n61wnhZHTbYYTZRXkfg4reySg0ZDQV2g7S6/P5r+p
   s=;
IronPort-SDR: 2SFHWefm5IBliCy6PxdBVpdMPJLRAuth5PuSXFbxWimi6lCVMjMbn1flA2bCVFBYbNVtKY0pZ0
 0YnGiIw1Hndg==
X-IronPort-AV: E=Sophos;i="5.70,499,1574121600"; 
   d="scan'208";a="19405126"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 29 Feb 2020 11:36:13 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 0EE69A22FA;
        Sat, 29 Feb 2020 11:36:12 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 11:36:11 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.171) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 29 Feb 2020 11:36:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v3 net-next 2/4] tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.
Date:   Sat, 29 Feb 2020 20:35:52 +0900
Message-ID: <20200229113554.78338-3-kuniyu@amazon.co.jp>
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

Commit aacd9289af8b82f5fb01bcdd53d0e3406d1333c7 ("tcp: bind() use stronger
condition for bind_conflict") introduced a restriction to forbid to bind
SO_REUSEADDR enabled sockets to the same (addr, port) tuple in order to
assign ports dispersedly so that we can connect to the same remote host.

The change results in accelerating port depletion so that we fail to bind
sockets to the same local port even if we want to connect to the different
remote hosts.

You can reproduce this issue by following instructions below.
  1. # sysctl -w net.ipv4.ip_local_port_range="32768 32768"
  2. set SO_REUSEADDR to two sockets.
  3. bind two sockets to (address, 0) and the latter fails.

Therefore, when ephemeral ports are exhausted, bind(addr, 0) should
fallback to the legacy behaviour to enable the SO_REUSEADDR option and make
it possible to connect to different remote (addr, port) tuples.

This patch allows us to bind SO_REUSEADDR enabled sockets to the same
(addr, port) only when all ephemeral ports are exhausted.

The only notable thing is that if all sockets bound to the same port have
both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
ephemeral port and also do listen().

Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 2e9549f49a82..cddeab240ea6 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -174,12 +174,14 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 	int port = 0;
 	struct inet_bind_hashbucket *head;
 	struct net *net = sock_net(sk);
+	bool relax = false;
 	int i, low, high, attempt_half;
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int l3mdev;
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
+ports_exhausted:
 	attempt_half = (sk->sk_reuse == SK_CAN_REUSE) ? 1 : 0;
 other_half_scan:
 	inet_get_local_port_range(net, &low, &high);
@@ -217,7 +219,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 		inet_bind_bucket_for_each(tb, &head->chain)
 			if (net_eq(ib_net(tb), net) && tb->l3mdev == l3mdev &&
 			    tb->port == port) {
-				if (!inet_csk_bind_conflict(sk, tb, false, false))
+				if (!inet_csk_bind_conflict(sk, tb, relax, false))
 					goto success;
 				goto next_port;
 			}
@@ -237,6 +239,12 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 		attempt_half = 2;
 		goto other_half_scan;
 	}
+
+	if (!relax) {
+		/* We still have a chance to connect to different destinations */
+		relax = true;
+		goto ports_exhausted;
+	}
 	return NULL;
 success:
 	*port_ret = port;
-- 
2.17.2 (Apple Git-113)

