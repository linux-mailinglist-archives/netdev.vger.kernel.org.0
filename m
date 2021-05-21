Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F5238CD32
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbhEUSXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:23:14 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:3467 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238746AbhEUSXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621621309; x=1653157309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wgV7GHbOPsHtmeZ7J/WyfhQnSFRkvm3dRLDL04oWfek=;
  b=BT9UX2IxaGO3a9E6b9JDJGhqnBHyjFqWI2229PzzVNdaxV8s8d+H5/a1
   FQGcKw46feXhA93Er7ChcX2lJdVgDaVBOteM6BxQjqITxsqYry/EoqmZF
   AHDCRAYokQ7OjehS2IT0Ph5f6tUardGdyFAbRsNED0um9ONZO7M5jwjuY
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,319,1613433600"; 
   d="scan'208";a="127055834"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 21 May 2021 18:21:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 28733A1E41;
        Fri, 21 May 2021 18:21:48 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 18:21:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.224) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 18:21:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 bpf-next 01/11] net: Introduce net.ipv4.tcp_migrate_req.
Date:   Sat, 22 May 2021 03:20:54 +0900
Message-ID: <20210521182104.18273-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521182104.18273-1-kuniyu@amazon.co.jp>
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.224]
X-ClientProxiedBy: EX13D17UWB003.ant.amazon.com (10.43.161.42) To
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

