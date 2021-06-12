Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C755C3A4EAD
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFLMfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:35:02 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:9830 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLMfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623501181; x=1655037181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ocE4Kg70/qUMw9SvbaJ0u0BYD7kI1uRzAQmqLNJYlzo=;
  b=v9GysW9LmwLubZD8dOILmGqTRY5DqcmlLOYZv+8gWr5zr2Yyam986YVd
   9EOuR2DDQ2q/cI39GSV92nUcYWmlPgRt2T1erZ4p8qR6tPuHexM6I9NvZ
   27pn8WLgug/73R//SBGcCCcV5EXXgACjRd2dIcRSuzFOWOosFSEei5Fv+
   c=;
X-IronPort-AV: E=Sophos;i="5.83,268,1616457600"; 
   d="scan'208";a="937976433"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 12 Jun 2021 12:32:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 58931A0719;
        Sat, 12 Jun 2021 12:32:56 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:32:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:32:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 bpf-next 01/11] net: Introduce net.ipv4.tcp_migrate_req.
Date:   Sat, 12 Jun 2021 21:32:14 +0900
Message-ID: <20210612123224.12525-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210612123224.12525-1-kuniyu@amazon.co.jp>
References: <20210612123224.12525-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a new sysctl option: net.ipv4.tcp_migrate_req. If this
option is enabled or eBPF program is attached, we will be able to migrate
child sockets from a listener to another in the same reuseport group after
close() or shutdown() syscalls.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/networking/ip-sysctl.rst | 25 +++++++++++++++++++++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index a5c250044500..b0436d3a4f11 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -761,6 +761,31 @@ tcp_syncookies - INTEGER
 	network connections you can set this knob to 2 to enable
 	unconditionally generation of syncookies.
 
+tcp_migrate_req - BOOLEAN
+	The incoming connection is tied to a specific listening socket when
+	the initial SYN packet is received during the three-way handshake.
+	When a listener is closed, in-flight request sockets during the
+	handshake and established sockets in the accept queue are aborted.
+
+	If the listener has SO_REUSEPORT enabled, other listeners on the
+	same port should have been able to accept such connections. This
+	option makes it possible to migrate such child sockets to another
+	listener after close() or shutdown().
+
+	The BPF_SK_REUSEPORT_SELECT_OR_MIGRATE type of eBPF program should
+	usually be used to define the policy to pick an alive listener.
+	Otherwise, the kernel will randomly pick an alive listener only if
+	this option is enabled.
+
+	Note that migration between listeners with different settings may
+	crash applications. Let's say migration happens from listener A to
+	B, and only B has TCP_SAVE_SYN enabled. B cannot read SYN data from
+	the requests migrated from A. To avoid such a situation, cancel
+	migration by returning SK_DROP in the type of eBPF program, or
+	disable this option.
+
+	Default: 0
+
 tcp_fastopen - INTEGER
 	Enable TCP Fast Open (RFC7413) to send and accept data in the opening
 	SYN packet.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 746c80cd4257..b8620519eace 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -126,6 +126,7 @@ struct netns_ipv4 {
 	u8 sysctl_tcp_syn_retries;
 	u8 sysctl_tcp_synack_retries;
 	u8 sysctl_tcp_syncookies;
+	u8 sysctl_tcp_migrate_req;
 	int sysctl_tcp_reordering;
 	u8 sysctl_tcp_retries1;
 	u8 sysctl_tcp_retries2;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 4fa77f182dcb..6f1e64d49232 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -960,6 +960,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.proc_handler	= proc_dou8vec_minmax,
 	},
 #endif
+	{
+		.procname	= "tcp_migrate_req",
+		.data		= &init_net.ipv4.sysctl_tcp_migrate_req,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
+	},
 	{
 		.procname	= "tcp_reordering",
 		.data		= &init_net.ipv4.sysctl_tcp_reordering,
-- 
2.30.2

