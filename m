Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007C82D11FC
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgLGN2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:28:21 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:36838 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgLGN2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:28:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347698; x=1638883698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=PB9Ez+y4FD9VGYXw++IaSHiEr4C9tHxS7oGDzn/NXxo=;
  b=iGnVDJpP71Ni0d7zUEtffkJc7NRFkVlT6aQqCJMuQ9P9fXGoxjfCCOg8
   DPeDHBvXkmXLpPGflx55nsHkV0N6RcF/Uj02AP/6nP2zU0cTS3tQhIRhW
   AS37/2GCXvOeUp7FF8vaEq1/couVkbnZXo2JZIT9RBu9PE84/+0PwO+0k
   g=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="69561783"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Dec 2020 13:27:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 9A40FA221B;
        Mon,  7 Dec 2020 13:27:34 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:27:33 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:27:29 +0000
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
Subject: [PATCH v2 bpf-next 08/13] bpf: Introduce two attach types for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Mon, 7 Dec 2020 22:24:51 +0900
Message-ID: <20201207132456.65472-9-kuniyu@amazon.co.jp>
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
 include/uapi/linux/bpf.h       |  2 ++
 kernel/bpf/syscall.c           | 13 +++++++++++++
 tools/include/uapi/linux/bpf.h |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7a48e0055500..c7f6848c0226 100644
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
index 0cd3cc2af9c1..0737673c727c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1920,6 +1920,11 @@ static void bpf_prog_load_fixup_attach_type(union bpf_attr *attr)
 			attr->expected_attach_type =
 				BPF_CGROUP_INET_SOCK_CREATE;
 		break;
+	case BPF_PROG_TYPE_SK_REUSEPORT:
+		if (!attr->expected_attach_type)
+			attr->expected_attach_type =
+				BPF_SK_REUSEPORT_SELECT;
+		break;
 	}
 }
 
@@ -2003,6 +2008,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
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
index 7a48e0055500..c7f6848c0226 100644
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

