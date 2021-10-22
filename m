Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7894372F8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 09:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhJVHm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 03:42:29 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14843 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhJVHm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 03:42:29 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HbGMz5khjz90M9;
        Fri, 22 Oct 2021 15:35:11 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 22 Oct 2021 15:39:53 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 22 Oct
 2021 15:39:53 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v3 2/4] bpf: factor out helpers to check ctx access for BTF function
Date:   Fri, 22 Oct 2021 15:55:09 +0800
Message-ID: <20211022075511.1682588-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211022075511.1682588-1-houtao1@huawei.com>
References: <20211022075511.1682588-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out two helpers to check the read access of ctx for BTF
function. bpf_tracing_ctx_access() is used to check the
read access to argument is valid, and bpf_tracing_btf_ctx_access()
checks whether the btf type of argument is valid besides
the checking of argument read. bpf_tracing_btf_ctx_access()
will be used by the following patch.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf.h      | 27 +++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c | 16 ++--------------
 net/ipv4/bpf_tcp_ca.c    |  9 +--------
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3d2cf94a72ce..0dd2de9eeed3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1649,6 +1649,33 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
+
+/*
+ * The maximum number of BTF function arguments is MAX_BPF_FUNC_ARGS.
+ * And only aligned read is allowed.
+ */
+static inline bool bpf_tracing_ctx_access(int off, int size,
+					  enum bpf_access_type type)
+{
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+		return false;
+	if (type != BPF_READ)
+		return false;
+	if (off % size != 0)
+		return false;
+	return true;
+}
+
+static inline bool bpf_tracing_btf_ctx_access(int off, int size,
+					      enum bpf_access_type type,
+					      const struct bpf_prog *prog,
+					      struct bpf_insn_access_aux *info)
+{
+	if (!bpf_tracing_ctx_access(off, size, type))
+		return false;
+	return btf_ctx_access(off, size, type, prog, info);
+}
+
 int btf_struct_access(struct bpf_verifier_log *log, const struct btf *btf,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index cbcd0d6fca7c..7396488793ff 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1646,13 +1646,7 @@ static bool raw_tp_prog_is_valid_access(int off, int size,
 					const struct bpf_prog *prog,
 					struct bpf_insn_access_aux *info)
 {
-	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
-		return false;
-	if (type != BPF_READ)
-		return false;
-	if (off % size != 0)
-		return false;
-	return true;
+	return bpf_tracing_ctx_access(off, size, type);
 }
 
 static bool tracing_prog_is_valid_access(int off, int size,
@@ -1660,13 +1654,7 @@ static bool tracing_prog_is_valid_access(int off, int size,
 					 const struct bpf_prog *prog,
 					 struct bpf_insn_access_aux *info)
 {
-	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
-		return false;
-	if (type != BPF_READ)
-		return false;
-	if (off % size != 0)
-		return false;
-	return btf_ctx_access(off, size, type, prog, info);
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
 }
 
 int __weak bpf_prog_test_run_tracing(struct bpf_prog *prog,
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 57709ac09fb2..2cf02b4d77fb 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -81,14 +81,7 @@ static bool bpf_tcp_ca_is_valid_access(int off, int size,
 				       const struct bpf_prog *prog,
 				       struct bpf_insn_access_aux *info)
 {
-	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
-		return false;
-	if (type != BPF_READ)
-		return false;
-	if (off % size != 0)
-		return false;
-
-	if (!btf_ctx_access(off, size, type, prog, info))
+	if (!bpf_tracing_btf_ctx_access(off, size, type, prog, info))
 		return false;
 
 	if (info->reg_type == PTR_TO_BTF_ID && info->btf_id == sock_id)
-- 
2.29.2

