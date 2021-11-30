Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBBA463615
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbhK3OKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:10:21 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16326 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbhK3OKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:10:20 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J3PCR2dvqz91PG;
        Tue, 30 Nov 2021 22:06:27 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 30 Nov
 2021 22:06:58 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 1/5] bpf: add bpf_strncmp helper
Date:   Tue, 30 Nov 2021 22:22:11 +0800
Message-ID: <20211130142215.1237217-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211130142215.1237217-1-houtao1@huawei.com>
References: <20211130142215.1237217-1-houtao1@huawei.com>
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
index a7cbc29b0994..685c8fe5c0be 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2165,6 +2165,7 @@ extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
 extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
 extern const struct bpf_func_proto bpf_find_vma_proto;
+extern const struct bpf_func_proto bpf_strncmp_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a69e4b04ffeb..afdc52efa4a1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4957,6 +4957,16 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
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
@@ -5140,6 +5150,7 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(strncmp),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1ffd469c217f..a7d3a8d48e00 100644
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
@@ -1378,6 +1392,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ringbuf_query_proto;
 	case BPF_FUNC_for_each_map_elem:
 		return &bpf_for_each_map_elem_proto;
+	case BPF_FUNC_strncmp:
+		return &bpf_strncmp_proto;
 	default:
 		break;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a69e4b04ffeb..afdc52efa4a1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4957,6 +4957,16 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
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
@@ -5140,6 +5150,7 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(strncmp),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.29.2

