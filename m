Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FBD2CA63D
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404012AbgLAOrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:47:43 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:51548 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388491AbgLAOrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606834062; x=1638370062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=vaoGiMEYdHqZuIObsn8FiWWZW4pERkBSeGbRWDs9t6A=;
  b=knXeO2CQ4ICS2zr7ufDTOLDpm6SML1jsEfT5gMBXqHMq5PQY9FpXQk9r
   YnYTrVMbST3J56MWvgGxcS2icTz4I/vUIT/NbJXHcOc4QQ2F7IsgE002T
   raFser05ZAV6btOLwvHcL8CLmqNF9eNesSA40v4j7p3blKt3yWZr5jLcH
   E=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="92542548"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 14:47:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 653DCA244D;
        Tue,  1 Dec 2020 14:46:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:46:57 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:46:53 +0000
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
Subject: [PATCH v1 bpf-next 08/11] bpf: Add migration to sk_reuseport_(kern|md).
Date:   Tue, 1 Dec 2020 23:44:15 +0900
Message-ID: <20201201144418.35045-9-kuniyu@amazon.co.jp>
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

This patch adds u8 migration field to sk_reuseport_kern and sk_reuseport_md
to signal the eBPF program if the kernel calls it for selecting a listener
for SYN or migrating sockets in the accept queue or an immature socket
during 3WHS.

Note that this field is accessible only if the attached type is
BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.

Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/linux/bpf.h            |  1 +
 include/linux/filter.h         |  4 ++--
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              | 15 ++++++++++++---
 net/core/sock_reuseport.c      |  2 +-
 tools/include/uapi/linux/bpf.h |  1 +
 6 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 581b2a2e78eb..244f823f1f84 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1897,6 +1897,7 @@ struct sk_reuseport_kern {
 	u32 hash;
 	u32 reuseport_id;
 	bool bind_inany;
+	u8 migration;
 };
 bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1b62397bd124..15d5bf13a905 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -967,12 +967,12 @@ void bpf_warn_invalid_xdp_action(u32 act);
 #ifdef CONFIG_INET
 struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 				  struct bpf_prog *prog, struct sk_buff *skb,
-				  u32 hash);
+				  u32 hash, u8 migration);
 #else
 static inline struct sock *
 bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 		     struct bpf_prog *prog, struct sk_buff *skb,
-		     u32 hash)
+		     u32 hash, u8 migration)
 {
 	return NULL;
 }
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index cfc207ae7782..efe342bf3dbc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4419,6 +4419,7 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	__u8 migration;		/* Migration type */
 };
 
 #define BPF_TAG_SIZE	8
diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..0a0634787bb4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9853,7 +9853,7 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
 static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 				    struct sock_reuseport *reuse,
 				    struct sock *sk, struct sk_buff *skb,
-				    u32 hash)
+				    u32 hash, u8 migration)
 {
 	reuse_kern->skb = skb;
 	reuse_kern->sk = sk;
@@ -9862,16 +9862,17 @@ static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 	reuse_kern->hash = hash;
 	reuse_kern->reuseport_id = reuse->reuseport_id;
 	reuse_kern->bind_inany = reuse->bind_inany;
+	reuse_kern->migration = migration;
 }
 
 struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 				  struct bpf_prog *prog, struct sk_buff *skb,
-				  u32 hash)
+				  u32 hash, u8 migration)
 {
 	struct sk_reuseport_kern reuse_kern;
 	enum sk_action action;
 
-	bpf_init_reuseport_kern(&reuse_kern, reuse, sk, skb, hash);
+	bpf_init_reuseport_kern(&reuse_kern, reuse, sk, skb, hash, migration);
 	action = BPF_PROG_RUN(prog, &reuse_kern);
 
 	if (action == SK_PASS)
@@ -10010,6 +10011,10 @@ sk_reuseport_is_valid_access(int off, int size,
 	case offsetof(struct sk_reuseport_md, hash):
 		return size == size_default;
 
+	case bpf_ctx_range(struct sk_reuseport_md, migration):
+		return prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE &&
+			size == sizeof(__u8);
+
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
 		if (size < sizeof_field(struct sk_buff, protocol))
@@ -10082,6 +10087,10 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct sk_reuseport_md, bind_inany):
 		SK_REUSEPORT_LOAD_FIELD(bind_inany);
 		break;
+
+	case offsetof(struct sk_reuseport_md, migration):
+		SK_REUSEPORT_LOAD_FIELD(migration);
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index b4fe0829c9ab..96d65b4c6974 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -349,7 +349,7 @@ struct sock *__reuseport_select_sock(struct sock *sk, u32 hash,
 			goto select_by_hash;
 
 		if (prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
-			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash);
+			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash, migration);
 		else
 			sk2 = run_bpf_filter(reuse, socks, prog, skb, hdr_len);
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index cfc207ae7782..efe342bf3dbc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4419,6 +4419,7 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	__u8 migration;		/* Migration type */
 };
 
 #define BPF_TAG_SIZE	8
-- 
2.17.2 (Apple Git-113)

