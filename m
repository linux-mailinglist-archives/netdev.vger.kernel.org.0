Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301572CA640
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404023AbgLAOr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:47:59 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:51548 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391677AbgLAOr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:47:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606834078; x=1638370078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NUzw8SbA3vX4dvNrDqnZIUBmoUk7I8Pv3AQv8zbmeyA=;
  b=MY3HlCgPnVO7uCNWjKoMDZVRNDV6H93CNQ4OtQQwUK7EA/RTVSV6zEcq
   +Ss4owcWpdw9OrT6L6gvuGo9Mxkbgno6i1GrR1OrhDe9fu0IwBwr0HHTL
   dZv1Xiyo7OsTUzPmlPYRmKze8/pgzW+MwnguIek1isyt2rNOdA+/KA3ui
   w=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="92542631"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 14:47:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 05C32A1960;
        Tue,  1 Dec 2020 14:47:18 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:47:18 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:47:08 +0000
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
Subject: [PATCH v1 bpf-next 09/11] bpf: Support bpf_get_socket_cookie_sock() for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Tue, 1 Dec 2020 23:44:16 +0900
Message-ID: <20201201144418.35045-10-kuniyu@amazon.co.jp>
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
 net/core/filter.c              | 12 +++++++++++-
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index efe342bf3dbc..3e9b8bd42b4e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1650,6 +1650,13 @@ union bpf_attr {
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
@@ -4420,6 +4427,7 @@ struct sk_reuseport_md {
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
 	__u8 migration;		/* Migration type */
+	__bpf_md_ptr(struct bpf_sock *, sk); /* current listening socket */
 };
 
 #define BPF_TAG_SIZE	8
diff --git a/net/core/filter.c b/net/core/filter.c
index 0a0634787bb4..1059d31847ef 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4628,7 +4628,7 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_proto = {
 	.func		= bpf_get_socket_cookie_sock,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg1_type	= ARG_PTR_TO_SOCKET,
 };
 
 BPF_CALL_1(bpf_get_socket_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
@@ -9982,6 +9982,8 @@ sk_reuseport_func_proto(enum bpf_func_id func_id,
 		return &sk_reuseport_load_bytes_proto;
 	case BPF_FUNC_skb_load_bytes_relative:
 		return &sk_reuseport_load_bytes_relative_proto;
+	case BPF_FUNC_get_socket_cookie:
+		return &bpf_get_socket_cookie_sock_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -10015,6 +10017,10 @@ sk_reuseport_is_valid_access(int off, int size,
 		return prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE &&
 			size == sizeof(__u8);
 
+	case offsetof(struct sk_reuseport_md, sk):
+		info->reg_type = PTR_TO_SOCKET;
+		return size == sizeof(__u64);
+
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
 		if (size < sizeof_field(struct sk_buff, protocol))
@@ -10091,6 +10097,10 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
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
index efe342bf3dbc..3e9b8bd42b4e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1650,6 +1650,13 @@ union bpf_attr {
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
@@ -4420,6 +4427,7 @@ struct sk_reuseport_md {
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
 	__u8 migration;		/* Migration type */
+	__bpf_md_ptr(struct bpf_sock *, sk); /* current listening socket */
 };
 
 #define BPF_TAG_SIZE	8
-- 
2.17.2 (Apple Git-113)

