Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9595952E08A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343594AbiESXa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343547AbiESXaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:30:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C806610788E;
        Thu, 19 May 2022 16:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653003022; x=1684539022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kE9fd53xn9fCor2XbVfB6M/J0Fibpx2PlFNL0D/30Q8=;
  b=PK/8lcnRdz71NyaGnoCzQK6bKwSUqJZIhyxZqFkC1UjrPumuePDiPXuJ
   MutaW8o0SMDIlVAWyUOQ7WOLlN63SklPxkLX50mcYR1DlZmQl3tnFQ193
   XTGVFqYtkL5oBY1sxc6MvzsFoLokhiznGgsH/fSfd38K+86ZHUQdASM2C
   m8h3pKbt1ukZAQyk/39STu65KhW8lH8fE/nXYhfCKRltPR1jOfSvANaXJ
   c3AR+KHvRs2oaEq3EElg/r2xpUlawWeIHM8goCn3/5U70f6YUojC1dIGi
   DFQysQ0CubfHHryZHiS7B0Ufhi3+4gqGwa2PpLvxGl4VtYOgVK0Z3uEfF
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272547197"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272547197"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570491192"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.132.179])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v5 1/7] bpf: add bpf_skc_to_mptcp_sock_proto
Date:   Thu, 19 May 2022 16:30:10 -0700
Message-Id: <20220519233016.105670-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
References: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch implements a new struct bpf_func_proto, named
bpf_skc_to_mptcp_sock_proto. Define a new bpf_id BTF_SOCK_TYPE_MPTCP,
and a new helper bpf_skc_to_mptcp_sock(), which invokes another new
helper bpf_mptcp_sock_from_subflow() in net/mptcp/bpf.c to get struct
mptcp_sock from a given subflow socket.

v2: Emit BTF type, add func_id checks in verifier.c and bpf_trace.c,
remove build check for CONFIG_BPF_JIT
v5: Drop EXPORT_SYMBOL (Martin)

Co-developed-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/bpf.h            |  1 +
 include/linux/btf_ids.h        |  3 ++-
 include/net/mptcp.h            |  6 ++++++
 include/uapi/linux/bpf.h       |  7 +++++++
 kernel/bpf/verifier.c          |  1 +
 kernel/trace/bpf_trace.c       |  2 ++
 net/core/filter.c              | 18 ++++++++++++++++++
 net/mptcp/Makefile             |  2 ++
 net/mptcp/bpf.c                | 21 +++++++++++++++++++++
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 11 files changed, 69 insertions(+), 1 deletion(-)
 create mode 100644 net/mptcp/bpf.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c107392b0ba7..a3ef078401cf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2231,6 +2231,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_unix_sock_proto;
+extern const struct bpf_func_proto bpf_skc_to_mptcp_sock_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_proto;
 extern const struct bpf_func_proto bpf_snprintf_btf_proto;
 extern const struct bpf_func_proto bpf_snprintf_proto;
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index bc5d9cc34e4c..335a19092368 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -178,7 +178,8 @@ extern struct btf_id_set name;
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_MPTCP, mptcp_sock)
 
 enum {
 #define BTF_SOCK_TYPE(name, str) name,
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 8b1afd6f5cc4..2ba09de955c7 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -284,4 +284,10 @@ static inline int mptcpv6_init(void) { return 0; }
 static inline void mptcpv6_handle_mapped(struct sock *sk, bool mapped) { }
 #endif
 
+#if defined(CONFIG_MPTCP) && defined(CONFIG_BPF_SYSCALL)
+struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk);
+#else
+static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk) { return NULL; }
+#endif
+
 #endif /* __NET_MPTCP_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0210f85131b3..56688bee20d9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5172,6 +5172,12 @@ union bpf_attr {
  * 	Return
  * 		Map value associated to *key* on *cpu*, or **NULL** if no entry
  * 		was found or *cpu* is invalid.
+ *
+ * struct mptcp_sock *bpf_skc_to_mptcp_sock(void *sk)
+ *	Description
+ *		Dynamically cast a *sk* pointer to a *mptcp_sock* pointer.
+ *	Return
+ *		*sk* if casting is valid, or **NULL** otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5370,6 +5376,7 @@ union bpf_attr {
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
 	FN(map_lookup_percpu_elem),     \
+	FN(skc_to_mptcp_sock),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9b59581026f8..14e8c17d3d8d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -509,6 +509,7 @@ static bool is_ptr_cast_function(enum bpf_func_id func_id)
 		func_id == BPF_FUNC_skc_to_tcp_sock ||
 		func_id == BPF_FUNC_skc_to_tcp6_sock ||
 		func_id == BPF_FUNC_skc_to_udp6_sock ||
+		func_id == BPF_FUNC_skc_to_mptcp_sock ||
 		func_id == BPF_FUNC_skc_to_tcp_timewait_sock ||
 		func_id == BPF_FUNC_skc_to_tcp_request_sock;
 }
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7141ca8a1c2d..10b157a6d73e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1705,6 +1705,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skc_to_udp6_sock_proto;
 	case BPF_FUNC_skc_to_unix_sock:
 		return &bpf_skc_to_unix_sock_proto;
+	case BPF_FUNC_skc_to_mptcp_sock:
+		return &bpf_skc_to_mptcp_sock_proto;
 	case BPF_FUNC_sk_storage_get:
 		return &bpf_sk_storage_get_tracing_proto;
 	case BPF_FUNC_sk_storage_delete:
diff --git a/net/core/filter.c b/net/core/filter.c
index fe0da529d00f..5af58eb48587 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -78,6 +78,7 @@
 #include <linux/btf_ids.h>
 #include <net/tls.h>
 #include <net/xdp.h>
+#include <net/mptcp.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -11281,6 +11282,20 @@ const struct bpf_func_proto bpf_skc_to_unix_sock_proto = {
 	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_UNIX],
 };
 
+BPF_CALL_1(bpf_skc_to_mptcp_sock, struct sock *, sk)
+{
+	BTF_TYPE_EMIT(struct mptcp_sock);
+	return (unsigned long)bpf_mptcp_sock_from_subflow(sk);
+}
+
+const struct bpf_func_proto bpf_skc_to_mptcp_sock_proto = {
+	.func		= bpf_skc_to_mptcp_sock,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_BTF_ID_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_SOCK_COMMON,
+	.ret_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_MPTCP],
+};
+
 BPF_CALL_1(bpf_sock_from_file, struct file *, file)
 {
 	return (unsigned long)sock_from_file(file);
@@ -11323,6 +11338,9 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_skc_to_unix_sock:
 		func = &bpf_skc_to_unix_sock_proto;
 		break;
+	case BPF_FUNC_skc_to_mptcp_sock:
+		func = &bpf_skc_to_mptcp_sock_proto;
+		break;
 	case BPF_FUNC_ktime_get_coarse_ns:
 		return &bpf_ktime_get_coarse_ns_proto;
 	default:
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index e54daceac58b..99dddf08ca73 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -10,3 +10,5 @@ obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
 mptcp_crypto_test-objs := crypto_test.o
 mptcp_token_test-objs := token_test.o
 obj-$(CONFIG_MPTCP_KUNIT_TEST) += mptcp_crypto_test.o mptcp_token_test.o
+
+obj-$(CONFIG_BPF_SYSCALL) += bpf.o
diff --git a/net/mptcp/bpf.c b/net/mptcp/bpf.c
new file mode 100644
index 000000000000..5a0a84ad94af
--- /dev/null
+++ b/net/mptcp/bpf.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2020, Tessares SA.
+ * Copyright (c) 2022, SUSE.
+ *
+ * Author: Nicolas Rybowski <nicolas.rybowski@tessares.net>
+ */
+
+#define pr_fmt(fmt) "MPTCP: " fmt
+
+#include <linux/bpf.h>
+#include "protocol.h"
+
+struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk)
+{
+	if (sk && sk_fullsock(sk) && sk->sk_protocol == IPPROTO_TCP && sk_is_mptcp(sk))
+		return mptcp_sk(mptcp_subflow_ctx(sk)->conn);
+
+	return NULL;
+}
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 096625242475..d5452f7eb996 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -633,6 +633,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct mptcp_sock',
     ]
     known_types = {
             '...',
@@ -682,6 +683,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct mptcp_sock',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0210f85131b3..56688bee20d9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5172,6 +5172,12 @@ union bpf_attr {
  * 	Return
  * 		Map value associated to *key* on *cpu*, or **NULL** if no entry
  * 		was found or *cpu* is invalid.
+ *
+ * struct mptcp_sock *bpf_skc_to_mptcp_sock(void *sk)
+ *	Description
+ *		Dynamically cast a *sk* pointer to a *mptcp_sock* pointer.
+ *	Return
+ *		*sk* if casting is valid, or **NULL** otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5370,6 +5376,7 @@ union bpf_attr {
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
 	FN(map_lookup_percpu_elem),     \
+	FN(skc_to_mptcp_sock),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.36.1

