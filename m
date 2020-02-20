Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520871660CE
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgBTPUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:20:55 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:55805 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgBTPUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:20:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582212055; x=1613748055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Reb3kP6mg6Ca69fwfDfJSeSo7uhldlEQT/uEeEhFpoo=;
  b=veORWsocXIVWxrVmYK1xHS9Pwom9QYveHBPzfCB2tMKL9F5ZOgXlvs+x
   HyLtlf+74hxYGzZ3SCXyKrfZxi6/ifR0JbbLpfNrl7d+1rDw7Ge5PAJF9
   IoOaQW2+/aGpAAOwL2IxbDbkete1q64BTechB4qg0nKe4U/CzN1cN0iQY
   I=;
IronPort-SDR: 4rivI3l1mTIzb1NhxJEWFOttFeptKVEHyyn89eCDzx9+SfWE4OSjhoHsPy7x9gtYSany4aWTpR
 UjvFycSgtMCA==
X-IronPort-AV: E=Sophos;i="5.70,464,1574121600"; 
   d="scan'208";a="17966616"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 Feb 2020 15:20:54 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 39D12A2865;
        Thu, 20 Feb 2020 15:20:53 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 20 Feb 2020 15:20:52 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.50) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Feb 2020 15:20:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH net-next 2/3] tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.
Date:   Fri, 21 Feb 2020 00:20:19 +0900
Message-ID: <20200220152020.13056-3-kuniyu@amazon.co.jp>
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
  3. bind two sockets to (localhost, 0) and the latter fails.

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

