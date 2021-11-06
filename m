Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE2A446E03
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 14:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhKFNP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 09:15:57 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15368 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbhKFNP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 09:15:57 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hmd8p63Qbz90VK;
        Sat,  6 Nov 2021 21:12:58 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 6 Nov 2021 21:13:10 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 6 Nov
 2021 21:13:03 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next 1/2] bpf: add bpf_strncmp helper
Date:   Sat, 6 Nov 2021 21:28:21 +0800
Message-ID: <20211106132822.1396621-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211106132822.1396621-1-houtao1@huawei.com>
References: <20211106132822.1396621-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper compares two strings: one string is a null-terminated
read-only string, and another one has const max storage size. And
it can be used to compare file name in tracing or LSM program.

We don't check whether or not s2 in bpf_strncmp() is null-terminated,
because its content may be changed by malicous program, and we only
ensure the memory accessed is bounded by s2_sz.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 11 +++++++++++
 kernel/bpf/helpers.c           | 14 ++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h | 11 +++++++++++
 5 files changed, 39 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2be6dfd68df9..5e8df7bda6c4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2157,6 +2157,7 @@ extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
 extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
+extern const struct bpf_func_proto bpf_strncmp_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ba5af15e25f5..899274d3906e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4938,6 +4938,16 @@ union bpf_attr {
  *		**-ENOENT** if symbol is not found.
  *
  *		**-EPERM** if caller does not have permission to obtain kernel address.
+ *
+ * long bpf_strncmp(const char *s1, const char *s2, u32 s2_sz)
+ *	Description
+ *		Do strncmp() between **s1** and **s2**. **s1** must be a
+ *		read-only string. **s2_sz** is the maximum storage size	of
+ *		**s2**.
+ *	Return
+ *		Return an integer less than, equal to, or greater than zero
+ *		if the first **s2_sz** bytes of **s2** is found to be
+ *		less than, to match, or be greater than **s1**.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5120,6 +5130,7 @@ union bpf_attr {
 	FN(trace_vprintk),		\
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
+	FN(strncmp),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1ffd469c217f..e73ebd8e2623 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -565,6 +565,20 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 };
 #endif
 
+BPF_CALL_3(bpf_strncmp, const char *, s1, const char *, s2, size_t, s2_sz)
+{
+	return strncmp(s1, s2, s2_sz);
+}
+
+const struct bpf_func_proto bpf_strncmp_proto = {
+	.func		= bpf_strncmp,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CONST_STR,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+};
+
 BPF_CALL_4(bpf_get_ns_current_pid_tgid, u64, dev, u64, ino,
 	   struct bpf_pidns_info *, nsdata, u32, size)
 {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7396488793ff..37d2a52ddcb4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1210,6 +1210,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_branch_snapshot_proto;
 	case BPF_FUNC_trace_vprintk:
 		return bpf_get_trace_vprintk_proto();
+	case BPF_FUNC_strncmp:
+		return &bpf_strncmp_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ba5af15e25f5..899274d3906e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4938,6 +4938,16 @@ union bpf_attr {
  *		**-ENOENT** if symbol is not found.
  *
  *		**-EPERM** if caller does not have permission to obtain kernel address.
+ *
+ * long bpf_strncmp(const char *s1, const char *s2, u32 s2_sz)
+ *	Description
+ *		Do strncmp() between **s1** and **s2**. **s1** must be a
+ *		read-only string. **s2_sz** is the maximum storage size	of
+ *		**s2**.
+ *	Return
+ *		Return an integer less than, equal to, or greater than zero
+ *		if the first **s2_sz** bytes of **s2** is found to be
+ *		less than, to match, or be greater than **s1**.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5120,6 +5130,7 @@ union bpf_attr {
 	FN(trace_vprintk),		\
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
+	FN(strncmp),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.29.2

