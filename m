Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98DF2D11E5
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgLGN02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:26:28 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:36461 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgLGN02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:26:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347586; x=1638883586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GUF0obSd4VoBjnotD58UAfe+GcsZfRAHuRtUll6vREE=;
  b=e1jAaR+Z4b4eRoATrelGpp+Q1AbpjCIMiSxp9SAbqxOZqBecH1wWZA2B
   rEaR4vKqJn1bN7g6290EtqwQMGlENYjgtfYPv303s1SaUPYryEb28RGgI
   6ZSp3BA+HjFoHTTbn69tIKrN+vcNj4GIOs16zpv4saqYARb56EqLmVKlT
   s=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="67699577"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 07 Dec 2020 13:25:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id B8C93A2040;
        Mon,  7 Dec 2020 13:25:56 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:25:55 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:25:45 +0000
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
Subject: [PATCH v2 bpf-next 02/13] bpf: Define migration types for SO_REUSEPORT.
Date:   Mon, 7 Dec 2020 22:24:45 +0900
Message-ID: <20201207132456.65472-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201207132456.65472-1-kuniyu@amazon.co.jp>
References: <20201207132456.65472-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D37UWC002.ant.amazon.com (10.43.162.123) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the preceding commit, there are two migration types. In
addition to that, the kernel will run the same eBPF program to select a
listener for SYN packets.

This patch defines three types to signal the kernel and the eBPF program if
it is receiving a new request or migrating ESTABLISHED/SYN_RECV sockets in
the accept queue or NEW_SYN_RECV socket during 3WHS.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/uapi/linux/bpf.h       | 14 ++++++++++++++
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1233f14f659f..7a48e0055500 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4423,6 +4423,20 @@ struct sk_msg_md {
 	__bpf_md_ptr(struct bpf_sock *, sk); /* current socket */
 };
 
+/* Migration type for SO_REUSEPORT enabled TCP sockets.
+ *
+ * BPF_SK_REUSEPORT_MIGRATE_NO      : Select a listener for SYN packets.
+ * BPF_SK_REUSEPORT_MIGRATE_QUEUE   : Migrate ESTABLISHED and SYN_RECV sockets in
+ *                                    the accept queue at close() or shutdown().
+ * BPF_SK_REUSEPORT_MIGRATE_REQUEST : Migrate NEW_SYN_RECV socket at receiving the
+ *                                    final ACK of 3WHS or retransmitting SYN+ACKs.
+ */
+enum {
+	BPF_SK_REUSEPORT_MIGRATE_NO,
+	BPF_SK_REUSEPORT_MIGRATE_QUEUE,
+	BPF_SK_REUSEPORT_MIGRATE_REQUEST,
+};
+
 struct sk_reuseport_md {
 	/*
 	 * Start of directly accessible data. It begins from
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1233f14f659f..7a48e0055500 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4423,6 +4423,20 @@ struct sk_msg_md {
 	__bpf_md_ptr(struct bpf_sock *, sk); /* current socket */
 };
 
+/* Migration type for SO_REUSEPORT enabled TCP sockets.
+ *
+ * BPF_SK_REUSEPORT_MIGRATE_NO      : Select a listener for SYN packets.
+ * BPF_SK_REUSEPORT_MIGRATE_QUEUE   : Migrate ESTABLISHED and SYN_RECV sockets in
+ *                                    the accept queue at close() or shutdown().
+ * BPF_SK_REUSEPORT_MIGRATE_REQUEST : Migrate NEW_SYN_RECV socket at receiving the
+ *                                    final ACK of 3WHS or retransmitting SYN+ACKs.
+ */
+enum {
+	BPF_SK_REUSEPORT_MIGRATE_NO,
+	BPF_SK_REUSEPORT_MIGRATE_QUEUE,
+	BPF_SK_REUSEPORT_MIGRATE_REQUEST,
+};
+
 struct sk_reuseport_md {
 	/*
 	 * Start of directly accessible data. It begins from
-- 
2.17.2 (Apple Git-113)

