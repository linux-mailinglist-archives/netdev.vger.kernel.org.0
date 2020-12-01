Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA682CA62E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403975AbgLAOrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:47:12 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:64982 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389033AbgLAOrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:47:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606834030; x=1638370030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=1djFn+jagjiayQ5HBXRcUZo+k3FTO2zB5G1LxznygzM=;
  b=BebrghwcFbLcs8l7zp8gK+OwTT8RQ9OijlVHh3PeFJyEjJBo4/ypR4+0
   MVqbr7mGN6WbhxOg7M3cRZJDqIAKURcGM6/ulm7ewrzXRT3OJBVYxufIO
   N0fK2F/L0EzHdqHkPQ7nOarHAsglbAO1llXPO3ve7hF7aynxs7glCHVR2
   k=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="99547297"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 01 Dec 2020 14:46:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 3DF29A1BB0;
        Tue,  1 Dec 2020 14:46:28 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:46:27 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:46:23 +0000
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
Subject: [PATCH v1 bpf-next 06/11] bpf: Introduce two attach types for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Tue, 1 Dec 2020 23:44:13 +0900
Message-ID: <20201201144418.35045-7-kuniyu@amazon.co.jp>
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

This commit adds new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT to
check if the attached eBPF program is capable of migrating sockets.

When the eBPF program is attached, the kernel runs it for socket migration
only if the expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
The kernel will change the behaviour depending on the returned value:

  - SK_PASS with selected_sk, select it as a new listener
  - SK_PASS with selected_sk NULL, fall back to the random selection
  - SK_DROP, cancel the migration

Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/uapi/linux/bpf.h       | 2 ++
 kernel/bpf/syscall.c           | 8 ++++++++
 tools/include/uapi/linux/bpf.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 85278deff439..cfc207ae7782 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -241,6 +241,8 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_SK_REUSEPORT_SELECT,
+	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f3fe9f53f93c..a0796a8de5ea 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2036,6 +2036,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		if (expected_attach_type == BPF_SK_LOOKUP)
 			return 0;
 		return -EINVAL;
+	case BPF_PROG_TYPE_SK_REUSEPORT:
+		switch (expected_attach_type) {
+		case BPF_SK_REUSEPORT_SELECT:
+		case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE:
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
 			return -EINVAL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 85278deff439..cfc207ae7782 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -241,6 +241,8 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_SK_REUSEPORT_SELECT,
+	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.17.2 (Apple Git-113)

