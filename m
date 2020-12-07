Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B342B2D1202
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgLGN2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:28:51 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:5379 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLGN2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:28:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347730; x=1638883730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=rwwsd+4koA6t9hA5HF4gY60ckOiP8zAYsJKIAgHSb5c=;
  b=mUxqO/Z689jDpfZwwJjkumDZsIRhViJiM++1aueWuReI77rqGJaOT6f6
   AI01b/z/LToI9mGyDM+GW0oPH1DQusji+QbgSmTA1QZkFsZYX+pOLpdk5
   hiSq/Xsxvp/gcTUT/0kpVOe3fRR18NuhvY81FeVWkxi4w/RnykfZnrf2F
   c=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="102282946"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 07 Dec 2020 13:28:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id A71E51010F1;
        Mon,  7 Dec 2020 13:28:05 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:28:04 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:28:00 +0000
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
Subject: [PATCH v2 bpf-next 10/13] bpf: Add migration to sk_reuseport_(kern|md).
Date:   Mon, 7 Dec 2020 22:24:53 +0900
Message-ID: <20201207132456.65472-11-kuniyu@amazon.co.jp>
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
index d05e75ed8c1b..cdeb27f4ad63 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1914,6 +1914,7 @@ struct sk_reuseport_kern {
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
index c7f6848c0226..cf518e83df5c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4462,6 +4462,7 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	__u8 migration;		/* Migration type */
 };
 
 #define BPF_TAG_SIZE	8
diff --git a/net/core/filter.c b/net/core/filter.c
index 77001a35768f..7bdf62f24044 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9860,7 +9860,7 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
 static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 				    struct sock_reuseport *reuse,
 				    struct sock *sk, struct sk_buff *skb,
-				    u32 hash)
+				    u32 hash, u8 migration)
 {
 	reuse_kern->skb = skb;
 	reuse_kern->sk = sk;
@@ -9869,16 +9869,17 @@ static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
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
@@ -10017,6 +10018,10 @@ sk_reuseport_is_valid_access(int off, int size,
 	case offsetof(struct sk_reuseport_md, hash):
 		return size == size_default;
 
+	case bpf_ctx_range(struct sk_reuseport_md, migration):
+		return prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE &&
+			size == sizeof(__u8);
+
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
 		if (size < sizeof_field(struct sk_buff, protocol))
@@ -10089,6 +10094,10 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
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
index 1011c3756c92..b877c8e552d2 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -313,7 +313,7 @@ static struct sock *__reuseport_select_sock(struct sock *sk, u32 hash,
 			goto select_by_hash;
 
 		if (prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
-			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash);
+			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash, migration);
 		else
 			sk2 = run_bpf_filter(reuse, socks, prog, skb, hdr_len);
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c7f6848c0226..cf518e83df5c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4462,6 +4462,7 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	__u8 migration;		/* Migration type */
 };
 
 #define BPF_TAG_SIZE	8
-- 
2.17.2 (Apple Git-113)

