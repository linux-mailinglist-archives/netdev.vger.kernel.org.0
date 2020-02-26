Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59BD16F8B8
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgBZHqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:46:54 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:4688 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbgBZHqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:46:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582703214; x=1614239214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=HIXyNmOJ8/d4F3iwP8yU6z0U8CCnk4bMqrJAD3qAXLM=;
  b=Hkjqrhvhycf0S4O7jQaUeLjAtSdayVYIzp47v1Th8qU77UNTkJX+eOpB
   MSAM6Xe+u0lHFAhD8oRyvrtcqjGysxUDUSbuES4L/uT3co+q0fTep8TCh
   wwc+c3lsFoAla3hXhw7YbYInv4siHwp2QW0RwdoLGSm1DDoroQCiKKjc4
   4=;
IronPort-SDR: NNr/b2Mq0WJI/a9TV0YeJLIVhAvHB0INYFTH/sDcualwj3VlWlgR3RAWon9UebrL4Rua08K8Vp
 7HYNuoVO8bxA==
X-IronPort-AV: E=Sophos;i="5.70,487,1574121600"; 
   d="scan'208";a="27550311"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 Feb 2020 07:46:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id AD014A312F;
        Wed, 26 Feb 2020 07:46:50 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Feb 2020 07:46:48 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.160.8) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Feb 2020 07:46:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v2 net-next 2/3] tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.
Date:   Wed, 26 Feb 2020 16:46:30 +0900
Message-ID: <20200226074631.67688-3-kuniyu@amazon.co.jp>
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

