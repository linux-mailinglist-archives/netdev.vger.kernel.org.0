Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55D84302A0
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 14:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240444AbhJPMfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 08:35:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14359 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240426AbhJPMfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 08:35:21 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HWj8y1d3zz8x35;
        Sat, 16 Oct 2021 20:28:18 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 16 Oct 2021 20:33:08 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 16 Oct
 2021 20:33:07 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 2/5] bpf: factor out helpers to check ctx access for BTF function
Date:   Sat, 16 Oct 2021 20:48:03 +0800
Message-ID: <20211016124806.1547989-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211016124806.1547989-1-houtao1@huawei.com>
References: <20211016124806.1547989-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out two helpers to check the read access of ctx for BTF
function. bpf_check_btf_func_arg_access() is used to check the
read access to argument is valid, and bpf_check_btf_func_ctx_access()
also checks whether the btf type of argument is valid besides
the checking of arguments read. bpf_check_btf_func_ctx_access()
will be used by the following patch.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf.h      | 27 +++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c | 16 ++--------------
 net/ipv4/bpf_tcp_ca.c    |  9 +--------
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b7c1e2bc93f7..b503306da2ab 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1648,6 +1648,33 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
+
+/*
+ * The maximum number of BTF function arguments is MAX_BPF_FUNC_ARGS.
+ * And only aligned read is allowed.
+ */
+static inline bool bpf_check_btf_func_arg_access(int off, int size,
+						 enum bpf_access_type type)
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
+static inline bool bpf_check_btf_func_ctx_access(int off, int size,
+						 enum bpf_access_type type,
+						 const struct bpf_prog *prog,
+						 struct bpf_insn_access_aux *info)
+{
+	if (!bpf_check_btf_func_arg_access(off, size, type))
+		return false;
+	return btf_ctx_access(off, size, type, prog, info);
+}
+
 int btf_struct_access(struct bpf_verifier_log *log, const struct btf *btf,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6b3153841a33..f2858ef32e16 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1644,13 +1644,7 @@ static bool raw_tp_prog_is_valid_access(int off, int size,
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
+	return bpf_check_btf_func_arg_access(off, size, type);
 }
 
 static bool tracing_prog_is_valid_access(int off, int size,
@@ -1658,13 +1652,7 @@ static bool tracing_prog_is_valid_access(int off, int size,
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
+	return bpf_check_btf_func_ctx_access(off, size, type, prog, info);
 }
 
 int __weak bpf_prog_test_run_tracing(struct bpf_prog *prog,
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 57709ac09fb2..1eccc4974382 100644
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
+	if (!bpf_check_btf_func_ctx_access(off, size, type, prog, info))
 		return false;
 
 	if (info->reg_type == PTR_TO_BTF_ID && info->btf_id == sock_id)
-- 
2.29.2

