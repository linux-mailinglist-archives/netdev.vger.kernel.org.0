Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF8347024C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239243AbhLJOFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:05:14 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29179 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbhLJOFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:05:13 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J9XZm5hxXz8vlC;
        Fri, 10 Dec 2021 21:59:28 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 10 Dec
 2021 22:01:36 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 1/4] bpf: add bpf_strncmp helper
Date:   Fri, 10 Dec 2021 22:16:49 +0800
Message-ID: <20211210141652.877186-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211210141652.877186-1-houtao1@huawei.com>
References: <20211210141652.877186-1-houtao1@huawei.com>
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
read-only string, and another string has const max storage size
but doesn't need to be null-terminated. It can be used to compare
file name in tracing or LSM program.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 11 +++++++++++
 kernel/bpf/helpers.c           | 16 ++++++++++++++++
 tools/include/uapi/linux/bpf.h | 11 +++++++++++
 4 files changed, 39 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8bbf08fbab66..6b7c533ba249 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2173,6 +2173,7 @@ extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
 extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
 extern const struct bpf_func_proto bpf_find_vma_proto;
 extern const struct bpf_func_proto bpf_loop_proto;
+extern const struct bpf_func_proto bpf_strncmp_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c26871263f1f..2820c77e4846 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4983,6 +4983,16 @@ union bpf_attr {
  *	Return
  *		The number of loops performed, **-EINVAL** for invalid **flags**,
  *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
+ *
+ * long bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
+ *	Description
+ *		Do strncmp() between **s1** and **s2**. **s1** doesn't need
+ *		to be null-terminated and **s1_sz** is the maximum storage
+ *		size of **s1**. **s2** must be a read-only string.
+ *	Return
+ *		An integer less than, equal to, or greater than zero
+ *		if the first **s1_sz** bytes of **s1** is found to be
+ *		less than, to match, or be greater than **s2**.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5167,6 +5177,7 @@ union bpf_attr {
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
 	FN(loop),			\
+	FN(strncmp),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 52188004a9c3..2b035c03624f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -565,6 +565,20 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 };
 #endif
 
+BPF_CALL_3(bpf_strncmp, const char *, s1, u32, s1_sz, const char *, s2)
+{
+	return strncmp(s1, s2, s1_sz);
+}
+
+const struct bpf_func_proto bpf_strncmp_proto = {
+	.func		= bpf_strncmp,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_PTR_TO_CONST_STR,
+};
+
 BPF_CALL_4(bpf_get_ns_current_pid_tgid, u64, dev, u64, ino,
 	   struct bpf_pidns_info *, nsdata, u32, size)
 {
@@ -1380,6 +1394,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_for_each_map_elem_proto;
 	case BPF_FUNC_loop:
 		return &bpf_loop_proto;
+	case BPF_FUNC_strncmp:
+		return &bpf_strncmp_proto;
 	default:
 		break;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c26871263f1f..2820c77e4846 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4983,6 +4983,16 @@ union bpf_attr {
  *	Return
  *		The number of loops performed, **-EINVAL** for invalid **flags**,
  *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
+ *
+ * long bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
+ *	Description
+ *		Do strncmp() between **s1** and **s2**. **s1** doesn't need
+ *		to be null-terminated and **s1_sz** is the maximum storage
+ *		size of **s1**. **s2** must be a read-only string.
+ *	Return
+ *		An integer less than, equal to, or greater than zero
+ *		if the first **s1_sz** bytes of **s1** is found to be
+ *		less than, to match, or be greater than **s2**.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5167,6 +5177,7 @@ union bpf_attr {
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
 	FN(loop),			\
+	FN(strncmp),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.29.2

