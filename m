Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AEF2D1205
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgLGN3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:29:11 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:36988 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgLGN3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347749; x=1638883749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=7XiD9aIMDu4mgLkRDGGRXRcyA0AIujxpHFHP5MzN3Ls=;
  b=iXT7U4Ia/WVxfMxGp4P83ymnCf06ELcH9Pj9A9OpyYel09aJqIzevZGH
   Gz9+2aGgmgukohbuj6nOdQ23h9YNi02gZoCDw/9nTrVL8iCnE2GZ2ZXc0
   N7ZcnBXAraNsAEObgwaV8l3B5EbC+XtywaJzZXqV247vRBE4Higfs85/1
   0=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="69561866"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Dec 2020 13:28:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 51446A1E93;
        Mon,  7 Dec 2020 13:28:25 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:28:24 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:28:15 +0000
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
Subject: [PATCH v2 bpf-next 11/13] bpf: Support BPF_FUNC_get_socket_cookie() for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Mon, 7 Dec 2020 22:24:54 +0900
Message-ID: <20201207132456.65472-12-kuniyu@amazon.co.jp>
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

We will call sock_reuseport.prog for socket migration in the next commit,
so the eBPF program has to know which listener is closing in order to
select the new listener.

Currently, we can get a unique ID for each listener in the userspace by
calling bpf_map_lookup_elem() for BPF_MAP_TYPE_REUSEPORT_SOCKARRAY map.

This patch makes the sk pointer available in sk_reuseport_md so that we can
get the ID by BPF_FUNC_get_socket_cookie() in the eBPF program.

Link: https://lore.kernel.org/netdev/20201119001154.kapwihc2plp4f7zc@kafai-mbp.dhcp.thefacebook.com/
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/uapi/linux/bpf.h       |  8 ++++++++
 net/core/filter.c              | 22 ++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 3 files changed, 38 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index cf518e83df5c..a688a7a4fe85 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1655,6 +1655,13 @@ union bpf_attr {
  * 		A 8-byte long non-decreasing number on success, or 0 if the
  * 		socket field is missing inside *skb*.
  *
+ * u64 bpf_get_socket_cookie(struct bpf_sock *sk)
+ * 	Description
+ * 		Equivalent to bpf_get_socket_cookie() helper that accepts
+ * 		*skb*, but gets socket from **struct bpf_sock** context.
+ * 	Return
+ * 		A 8-byte long non-decreasing number.
+ *
  * u64 bpf_get_socket_cookie(struct bpf_sock_addr *ctx)
  * 	Description
  * 		Equivalent to bpf_get_socket_cookie() helper that accepts
@@ -4463,6 +4470,7 @@ struct sk_reuseport_md {
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
 	__u8 migration;		/* Migration type */
+	__bpf_md_ptr(struct bpf_sock *, sk); /* Current listening socket */
 };
 
 #define BPF_TAG_SIZE	8
diff --git a/net/core/filter.c b/net/core/filter.c
index 7bdf62f24044..9f7018e3f545 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4631,6 +4631,18 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_1(bpf_get_socket_pointer_cookie, struct sock *, sk)
+{
+	return __sock_gen_cookie(sk);
+}
+
+static const struct bpf_func_proto bpf_get_socket_pointer_cookie_proto = {
+	.func		= bpf_get_socket_pointer_cookie,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_SOCKET,
+};
+
 BPF_CALL_1(bpf_get_socket_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
 {
 	return __sock_gen_cookie(ctx->sk);
@@ -9989,6 +10001,8 @@ sk_reuseport_func_proto(enum bpf_func_id func_id,
 		return &sk_reuseport_load_bytes_proto;
 	case BPF_FUNC_skb_load_bytes_relative:
 		return &sk_reuseport_load_bytes_relative_proto;
+	case BPF_FUNC_get_socket_cookie:
+		return &bpf_get_socket_pointer_cookie_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -10022,6 +10036,10 @@ sk_reuseport_is_valid_access(int off, int size,
 		return prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE &&
 			size == sizeof(__u8);
 
+	case offsetof(struct sk_reuseport_md, sk):
+		info->reg_type = PTR_TO_SOCKET;
+		return size == sizeof(__u64);
+
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
 		if (size < sizeof_field(struct sk_buff, protocol))
@@ -10098,6 +10116,10 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct sk_reuseport_md, migration):
 		SK_REUSEPORT_LOAD_FIELD(migration);
 		break;
+
+	case offsetof(struct sk_reuseport_md, sk):
+		SK_REUSEPORT_LOAD_FIELD(sk);
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index cf518e83df5c..a688a7a4fe85 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1655,6 +1655,13 @@ union bpf_attr {
  * 		A 8-byte long non-decreasing number on success, or 0 if the
  * 		socket field is missing inside *skb*.
  *
+ * u64 bpf_get_socket_cookie(struct bpf_sock *sk)
+ * 	Description
+ * 		Equivalent to bpf_get_socket_cookie() helper that accepts
+ * 		*skb*, but gets socket from **struct bpf_sock** context.
+ * 	Return
+ * 		A 8-byte long non-decreasing number.
+ *
  * u64 bpf_get_socket_cookie(struct bpf_sock_addr *ctx)
  * 	Description
  * 		Equivalent to bpf_get_socket_cookie() helper that accepts
@@ -4463,6 +4470,7 @@ struct sk_reuseport_md {
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
 	__u8 migration;		/* Migration type */
+	__bpf_md_ptr(struct bpf_sock *, sk); /* Current listening socket */
 };
 
 #define BPF_TAG_SIZE	8
-- 
2.17.2 (Apple Git-113)

