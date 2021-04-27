Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED4A36BDE0
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 05:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhD0DsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 23:48:04 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:32779 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbhD0DsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 23:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1619495240; x=1651031240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oOoI4UGGsXdLUQaM8cAPzanm+pnlwvsAMcQHQ9JQZ5g=;
  b=rKGThUAXPCNkovNkqSzELIk6H3C+Yn6wJchblnBR2+yzq6yOVfIajc8+
   8GKhwfR/BERYZJdd5wq2CYwKQpR3ltP+NDyMGhw5GD/fyCBQ8DjoxbGS9
   kNwRtS6P4hFMA9Vwd4IM9xVTScnmBcBvHlE75TsZK2yIjH+8m7icOl6UB
   U=;
X-IronPort-AV: E=Sophos;i="5.82,254,1613433600"; 
   d="scan'208";a="929261993"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 27 Apr 2021 03:47:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id DB429A07EF;
        Tue, 27 Apr 2021 03:47:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 27 Apr 2021 03:47:17 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.93) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 27 Apr 2021 03:47:12 +0000
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
Subject: [PATCH v4 bpf-next 01/11] net: Introduce net.ipv4.tcp_migrate_req.
Date:   Tue, 27 Apr 2021 12:46:13 +0900
Message-ID: <20210427034623.46528-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427034623.46528-1-kuniyu@amazon.co.jp>
References: <20210427034623.46528-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D18UWC002.ant.amazon.com (10.43.162.88) To
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
---
 Documentation/networking/ip-sysctl.rst | 20 ++++++++++++++++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 3 files changed, 30 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c2ecc9894fd0..8e92f9b28aad 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -732,6 +732,26 @@ tcp_syncookies - INTEGER
 	network connections you can set this knob to 2 to enable
 	unconditionally generation of syncookies.
 
+tcp_migrate_req - INTEGER
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
+	Default: 0
+
+	Note that the source and destination listeners MUST have the same
+	settings at the socket API level. If different applications listen
+	on the same port, disable this option or attach the
+	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE type of eBPF program to select
+	the correct socket by bpf_sk_select_reuseport() or to cancel
+	migration by returning SK_DROP.
+
 tcp_fastopen - INTEGER
 	Enable TCP Fast Open (RFC7413) to send and accept data in the opening
 	SYN packet.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index f6af8d96d3c6..fd63c91addcc 100644
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
index a62934b9f15a..7bb013fcbf5f 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -940,6 +940,15 @@ static struct ctl_table ipv4_net_table[] = {
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

