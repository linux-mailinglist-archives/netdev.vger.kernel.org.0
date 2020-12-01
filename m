Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA122CA61C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403912AbgLAOpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:45:54 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:50785 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389661AbgLAOpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:45:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606833953; x=1638369953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=fZzd58Z28I00jRpPznhhNdsFg37FRopxhjk7qpzG9hQ=;
  b=A9yvdEQDmYfr8dL1oBC2jzHXQ1E1j8OqYZBL5h0vRhblkjevVO3CYbBZ
   FUwfDWxsviJlGcsYxysepaMxZ8QaOXJqJbMD8Ra6NvsrOkyoDYjG2v0F7
   aZFxhTv/YNDinyIgM390BA04yhIq5ME5wqAlaW82hYhMHk5mHsrC8kIk/
   E=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="92542011"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 14:45:28 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id D1734A206F;
        Tue,  1 Dec 2020 14:45:27 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:45:27 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:45:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 bpf-next 02/11] bpf: Define migration types for SO_REUSEPORT.
Date:   Tue, 1 Dec 2020 23:44:09 +0900
Message-ID: <20201201144418.35045-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201201144418.35045-1-kuniyu@amazon.co.jp>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D36UWA004.ant.amazon.com (10.43.160.175) To
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
index 162999b12790..85278deff439 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4380,6 +4380,20 @@ struct sk_msg_md {
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
index 162999b12790..85278deff439 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4380,6 +4380,20 @@ struct sk_msg_md {
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

