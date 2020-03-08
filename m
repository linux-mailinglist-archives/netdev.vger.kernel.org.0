Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0637117D571
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 19:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgCHSRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 14:17:17 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:31932 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgCHSRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 14:17:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583691435; x=1615227435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OMEnmSSZnmM2u7GXwZalQVshE+wRsrbBLaq/oSO6ttg=;
  b=EGEX93fCzAFvmCy9n9fUhFuKvqUM4f+L9VLEfuRHzjHkrmA6zT5eofpm
   uIUQI45F4aVBU2N34NhsLTiFLHWNUGWYwyux6lL65TpcgHMzKTXimR9DS
   +MXcJ+1ievqvbB4rb8AIGP2x6scpmEY3WfTGbyfPV5reAkVxxv6XYLh9I
   I=;
IronPort-SDR: XamU0VKYoQYnYNRFF4AFfYRDau4edstCPcgl/H++D6M22Xf9xkKp8rojg8dZFRhmpcgbVbzbQS
 lDORHoHCiCYw==
X-IronPort-AV: E=Sophos;i="5.70,530,1574121600"; 
   d="scan'208";a="29901658"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 08 Mar 2020 18:17:14 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 5FEC7A2753;
        Sun,  8 Mar 2020 18:17:12 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 8 Mar 2020 18:17:11 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.100) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 8 Mar 2020 18:17:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v4 net-next 4/5] net: Add net.ipv4.ip_autobind_reuse option.
Date:   Mon, 9 Mar 2020 03:16:14 +0900
Message-ID: <20200308181615.90135-5-kuniyu@amazon.co.jp>
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

The two commits("tcp: bind(addr, 0) remove the SO_REUSEADDR restriction
when ephemeral ports are exhausted" and "tcp: Forbid to automatically bind
more than one sockets haveing SO_REUSEADDR and SO_REUSEPORT per EUID")
introduced the new feature to reuse ports with SO_REUSEADDR when all
ephemeral pors are exhausted. They allow connect() and listen() to share
ports in the following way.

  1. setsockopt(sk1, SO_REUSEADDR)
  2. setsockopt(sk2, SO_REUSEADDR)
  3. bind(sk1, saddr, 0)
  4. bind(sk2, saddr, 0)
  5. connect(sk1, daddr)
  6. listen(sk2)

In this situation, new socket cannot be bound to the port, but sharing
port between connect() and listen() may break some applications. The
ip_autobind_reuse option is false (0) by default and disables the feature.
If it is set true, we can fully utilize the 4-tuples.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 Documentation/networking/ip-sysctl.txt | 7 +++++++
 include/net/netns/ipv4.h               | 1 +
 net/ipv4/inet_connection_sock.c        | 2 +-
 net/ipv4/sysctl_net_ipv4.c             | 7 +++++++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 5f53faff4e25..9506a67a33c4 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -958,6 +958,13 @@ ip_nonlocal_bind - BOOLEAN
 	which can be quite useful - but may break some applications.
 	Default: 0
 
+ip_autobind_reuse - BOOLEAN
+	By default, bind() does not select the ports automatically even if
+	the new socket and all sockets bound to the port have SO_REUSEADDR.
+	ip_autobind_reuse allows bind() to reuse the port and this is useful
+	when you use bind()+connect(), but may break some applications.
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
index d27ed5fe7147..3b4f81790e3e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -246,7 +246,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 		goto other_half_scan;
 	}
 
-	if (!relax) {
+	if (net->ipv4.sysctl_ip_autobind_reuse && !relax) {
 		/* We still have a chance to connect to different destinations */
 		relax = true;
 		goto ports_exhausted;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 9684af02e0a5..3b191764718b 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -775,6 +775,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "ip_autobind_reuse",
+		.data		= &init_net.ipv4.sysctl_ip_autobind_reuse,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{
 		.procname	= "fwmark_reflect",
 		.data		= &init_net.ipv4.sysctl_fwmark_reflect,
-- 
2.17.2 (Apple Git-113)

