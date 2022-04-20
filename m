Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F485092A6
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356132AbiDTW2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 18:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355396AbiDTW2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 18:28:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC2F40A00;
        Wed, 20 Apr 2022 15:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650493516; x=1682029516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7JGsPMfEIizl3uiYOkvij3X2qHRKl3rpmk92jGiEIgA=;
  b=lj3LOF+Grbbd4asy2dZxYczEopn1qC+NzFGx59xyFws/tSwqY9tzwCfM
   9cHSK24zsEYuIKXLfPrd3c+AkidKGI1rhNY9FfFy7ekXDWWVICZIKpoTP
   yppA7KFZyiJK5d4kcYCuo+jAyT49A6qZE0Ywa/0xGkn38LEf/6+Pr7xJL
   x3Bd8bc4OrxN/AiOq1QIa4M65lNFuN+jFjsALVWcRmf2Upyv25bT7g5mt
   U0tpvDR0xoQipTBJ4/+5N1+70Y9Az5OGW9S9ncihVt1qfXx+kLwXd7+Ba
   g4OIvwWloOYKK+6s8e6CQ3Z/feK0yxKfkRtdVo91lo29L9rbDBr4VaaD5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289277585"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="289277585"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="555422587"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.100.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next 2/7] bpf: add bpf_skc_to_mptcp_sock_proto
Date:   Wed, 20 Apr 2022 15:24:54 -0700
Message-Id: <20220420222459.307649-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
References: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

Co-developed-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/btf_ids.h        |  3 ++-
 include/net/mptcp.h            |  6 ++++++
 include/uapi/linux/bpf.h       |  7 +++++++
 net/core/filter.c              | 17 +++++++++++++++++
 net/mptcp/Makefile             |  4 ++++
 net/mptcp/bpf.c                | 22 ++++++++++++++++++++++
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 8 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100644 net/mptcp/bpf.c

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
index 0a3b0fb04a3b..5b3a6f783182 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -283,4 +283,10 @@ static inline int mptcpv6_init(void) { return 0; }
 static inline void mptcpv6_handle_mapped(struct sock *sk, bool mapped) { }
 #endif
 
+#if defined(CONFIG_MPTCP) && defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
+struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk);
+#else
+static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk) { return NULL; }
+#endif
+
 #endif /* __NET_MPTCP_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 9ef1f3e1c22f..785f2cb15495 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5143,6 +5143,12 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * struct mptcp_sock *bpf_skc_to_mptcp_sock(void *sk)
+ *	Description
+ *		Dynamically cast a *sk* pointer to a *mptcp_sock* pointer.
+ *	Return
+ *		*sk* if casting is valid, or **NULL** otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5339,6 +5345,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(skc_to_mptcp_sock),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 7b1867f1f422..4081c55f6f78 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -78,6 +78,7 @@
 #include <linux/btf_ids.h>
 #include <net/tls.h>
 #include <net/xdp.h>
+#include <net/mptcp.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -11279,6 +11280,19 @@ const struct bpf_func_proto bpf_skc_to_unix_sock_proto = {
 	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_UNIX],
 };
 
+BPF_CALL_1(bpf_skc_to_mptcp_sock, struct sock *, sk)
+{
+	return (unsigned long)bpf_mptcp_sock_from_subflow(sk);
+}
+
+static const struct bpf_func_proto bpf_skc_to_mptcp_sock_proto = {
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
@@ -11321,6 +11335,9 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
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
index e54daceac58b..168c55d1c917 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -10,3 +10,7 @@ obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
 mptcp_crypto_test-objs := crypto_test.o
 mptcp_token_test-objs := token_test.o
 obj-$(CONFIG_MPTCP_KUNIT_TEST) += mptcp_crypto_test.o mptcp_token_test.o
+
+ifeq ($(CONFIG_BPF_JIT),y)
+obj-$(CONFIG_BPF_SYSCALL) += bpf.o
+endif
diff --git a/net/mptcp/bpf.c b/net/mptcp/bpf.c
new file mode 100644
index 000000000000..535602ba2582
--- /dev/null
+++ b/net/mptcp/bpf.c
@@ -0,0 +1,22 @@
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
+EXPORT_SYMBOL(bpf_mptcp_sock_from_subflow);
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
index 9ef1f3e1c22f..785f2cb15495 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5143,6 +5143,12 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * struct mptcp_sock *bpf_skc_to_mptcp_sock(void *sk)
+ *	Description
+ *		Dynamically cast a *sk* pointer to a *mptcp_sock* pointer.
+ *	Return
+ *		*sk* if casting is valid, or **NULL** otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5339,6 +5345,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(skc_to_mptcp_sock),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.36.0

