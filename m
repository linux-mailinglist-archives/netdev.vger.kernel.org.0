Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEB717F16E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 09:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgCJIGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 04:06:02 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11648 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgCJIGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 04:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583827561; x=1615363561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=iaL8j9franJsEqc0cTMVR9W9Kc1xOdcaMEA8U/4aANY=;
  b=SMyC2263WQ0rrI4ClB9K2eyiIPBzOObmZrjGhHFr3P3f1RO5xLOOh3N7
   rgtpB2PNBXL+2JtzSunu3rkb6Ptd+LV8Rki/dLNZ8fhEaMwynzrG/GFhF
   FvnqvrQOmnx2hzgjFKNNHEtM2E8pZ4ynw7oA9Nr6oRz+JeCaiMFKk7Qs4
   w=;
IronPort-SDR: HfLt0b4vHvsgMXYe2UcfUnhn5nR4QY4zV06md4mcmi5BPKvGN45GASEWx4NWGj4YtmnOnOWZfA
 3iCW+JE5mw+Q==
X-IronPort-AV: E=Sophos;i="5.70,535,1574121600"; 
   d="scan'208";a="21802786"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Mar 2020 08:06:00 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 97069A211D;
        Tue, 10 Mar 2020 08:05:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Mar 2020 08:05:57 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.160.16) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 10 Mar 2020 08:05:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v5 net-next 2/4] tcp: bind(0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.
Date:   Tue, 10 Mar 2020 17:05:25 +0900
Message-ID: <20200310080527.70180-3-kuniyu@amazon.co.jp>
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

Therefore, when ephemeral ports are exhausted, bind(0) should fallback to
the legacy behaviour to enable the SO_REUSEADDR option and make it possible
to connect to different remote (addr, port) tuples.

This patch allows us to bind SO_REUSEADDR enabled sockets to the same
(addr, port) only when net.ipv4.ip_autobind_reuse is set 1 and all
ephemeral ports are exhausted. This also allows connect() and listen() to
share ports in the following way and may break some applications. So the
ip_autobind_reuse is 0 by default and disables the feature.

  1. setsockopt(sk1, SO_REUSEADDR)
  2. setsockopt(sk2, SO_REUSEADDR)
  3. bind(sk1, saddr, 0)
  4. bind(sk2, saddr, 0)
  5. connect(sk1, daddr)
  6. listen(sk2)

If it is set 1, we can fully utilize the 4-tuples, but we should use
IP_BIND_ADDRESS_NO_PORT for bind()+connect() as possible.

The notable thing is that if all sockets bound to the same port have
both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
ephemeral port and also do listen().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 Documentation/networking/ip-sysctl.txt |  9 +++++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/inet_connection_sock.c        | 10 +++++++++-
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 5f53faff4e25..ee961d322d93 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -958,6 +958,15 @@ ip_nonlocal_bind - BOOLEAN
 	which can be quite useful - but may break some applications.
 	Default: 0
 
+ip_autobind_reuse - BOOLEAN
+	By default, bind() does not select the ports automatically even if
+	the new socket and all sockets bound to the port have SO_REUSEADDR.
+	ip_autobind_reuse allows bind() to reuse the port and this is useful
+	when you use bind()+connect(), but may break some applications.
+	The preferred solution is to use IP_BIND_ADDRESS_NO_PORT and this
+	option should only be set by experts.
+	Default: 0
+
 ip_dynaddr - BOOLEAN
 	If set non-zero, enables support for dynamic addresses.
 	If set to a non-zero value larger than 1, a kernel log
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 08b98414d94e..154b8f01499b 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -101,6 +101,7 @@ struct netns_ipv4 {
 	int sysctl_ip_fwd_use_pmtu;
 	int sysctl_ip_fwd_update_priority;
 	int sysctl_ip_nonlocal_bind;
+	int sysctl_ip_autobind_reuse;
 	/* Shall we try to damage output packets if routing dev changes? */
 	int sysctl_ip_dynaddr;
 	int sysctl_ip_early_demux;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 2e9549f49a82..497366b631f3 100644
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
+	if (net->ipv4.sysctl_ip_autobind_reuse && !relax) {
+		/* We still have a chance to connect to different destinations */
+		relax = true;
+		goto ports_exhausted;
+	}
 	return NULL;
 success:
 	*port_ret = port;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 9684af02e0a5..1166cef57121 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -775,6 +775,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "ip_autobind_reuse",
+		.data		= &init_net.ipv4.sysctl_ip_autobind_reuse,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
 	{
 		.procname	= "fwmark_reflect",
 		.data		= &init_net.ipv4.sysctl_fwmark_reflect,
-- 
2.17.2 (Apple Git-113)

