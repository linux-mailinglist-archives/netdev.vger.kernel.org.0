Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D60327ACD7
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 13:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgI1Ldu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 07:33:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgI1Lds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 07:33:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBTZ0d167490;
        Mon, 28 Sep 2020 11:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=+RxVkIDSbwp5epzQOAM5m4o94jSRSOx8SW33RnSDOEA=;
 b=RQNBqIw4Pux9X9cPrKwAzuzlNDly4UpBcd3vekzFtCwdTbKratdY/NHq7XE6+gCV+Z8t
 WPf8ZzZTaCRw9s9On5ZLomhJWme6cDp8ekOQh5OfU82qjn6aP46p8M4HCIkl8Sv0hBsD
 FG7ydg8CbYCtGU4oKFm9dKF7M5apoXQzLcvpMuRusTK0iuo2WlIuOtvOX4tanUX7nAJo
 BzBoYS5gyaGgQVyzxDAelYXiMX+p1kllyvUKsKRVgPq1Z3FvcgbMcrpHZ+4Lalu8OQmp
 JrbqaSUIRwkMd6kb/BUeRKXWST9svDjFCWoDduKqOJxec9+TpWsNcWB+eEhXs6PVM62l +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkkmeqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 11:32:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBUkTL094650;
        Mon, 28 Sep 2020 11:32:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33tf7k7bjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 11:32:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08SBWqHB029611;
        Mon, 28 Sep 2020 11:32:52 GMT
Received: from localhost.uk.oracle.com (/10.175.167.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 04:32:51 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, acme@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v7 bpf-next 3/8] bpf: add bpf_snprintf_btf helper
Date:   Mon, 28 Sep 2020 12:31:05 +0100
Message-Id: <1601292670-1616-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
References: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper is added to support tracing kernel type information in BPF
using the BPF Type Format (BTF).  Its signature is

long bpf_snprintf_btf(char *str, u32 str_size, struct btf_ptr *ptr,
		      u32 btf_ptr_size, u64 flags);

struct btf_ptr * specifies

- a pointer to the data to be traced
- the BTF id of the type of data pointed to
- a flags field is provided for future use; these flags
  are not to be confused with the BTF_F_* flags
  below that control how the btf_ptr is displayed; the
  flags member of the struct btf_ptr may be used to
  disambiguate types in kernel versus module BTF, etc;
  the main distinction is the flags relate to the type
  and information needed in identifying it; not how it
  is displayed.

For example a BPF program with a struct sk_buff *skb
could do the following:

	static struct btf_ptr b = { };

	b.ptr = skb;
	b.type_id = __builtin_btf_type_id(struct sk_buff, 1);
	bpf_snprintf_btf(str, sizeof(str), &b, sizeof(b), 0, 0);

Default output looks like this:

(struct sk_buff){
 .transport_header = (__u16)65535,
 .mac_header = (__u16)65535,
 .end = (sk_buff_data_t)192,
 .head = (unsigned char *)0x000000007524fd8b,
 .data = (unsigned char *)0x000000007524fd8b,
 .truesize = (unsigned int)768,
 .users = (refcount_t){
  .refs = (atomic_t){
   .counter = (int)1,
  },
 },
}

Flags modifying display are as follows:

- BTF_F_COMPACT:	no formatting around type information
- BTF_F_NONAME:		no struct/union member names/types
- BTF_F_PTR_RAW:	show raw (unobfuscated) pointer values;
			equivalent to %px.
- BTF_F_ZERO:		show zero-valued struct/union members;
			they are not displayed by default

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/bpf.h            |  1 +
 include/linux/btf.h            |  9 +++---
 include/uapi/linux/bpf.h       | 67 ++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           |  4 +++
 kernel/trace/bpf_trace.c       | 65 ++++++++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 ++
 tools/include/uapi/linux/bpf.h | 67 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 212 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2eae3f3..1d020d8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1810,6 +1810,7 @@ static inline int bpf_fd_reuseport_array_update_elem(struct bpf_map *map,
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_proto;
+extern const struct bpf_func_proto bpf_snprintf_btf_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/linux/btf.h b/include/linux/btf.h
index d0f5d3c..3e5cdc2 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 #include <uapi/linux/btf.h>
+#include <uapi/linux/bpf.h>
 
 #define BTF_TYPE_EMIT(type) ((void)(type *)0)
 
@@ -59,10 +60,10 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
  *	- BTF_SHOW_UNSAFE: skip use of bpf_probe_read() to safely read
  *	  data before displaying it.
  */
-#define BTF_SHOW_COMPACT	(1ULL << 0)
-#define BTF_SHOW_NONAME		(1ULL << 1)
-#define BTF_SHOW_PTR_RAW	(1ULL << 2)
-#define BTF_SHOW_ZERO		(1ULL << 3)
+#define BTF_SHOW_COMPACT	BTF_F_COMPACT
+#define BTF_SHOW_NONAME		BTF_F_NONAME
+#define BTF_SHOW_PTR_RAW	BTF_F_PTR_RAW
+#define BTF_SHOW_ZERO		BTF_F_ZERO
 #define BTF_SHOW_UNSAFE		(1ULL << 4)
 
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2d6519a..fcafe80 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3587,6 +3587,42 @@ struct bpf_stack_build_id {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * long bpf_snprintf_btf(char *str, u32 str_size, struct btf_ptr *ptr, u32 btf_ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to store a string representation of *ptr*->ptr in *str*,
+ *		using *ptr*->type_id.  This value should specify the type
+ *		that *ptr*->ptr points to. LLVM __builtin_btf_type_id(type, 1)
+ *		can be used to look up vmlinux BTF type ids. Traversing the
+ *		data structure using BTF, the type information and values are
+ *		stored in the first *str_size* - 1 bytes of *str*.  Safe copy of
+ *		the pointer data is carried out to avoid kernel crashes during
+ *		operation.  Smaller types can use string space on the stack;
+ *		larger programs can use map data to store the string
+ *		representation.
+ *
+ *		The string can be subsequently shared with userspace via
+ *		bpf_perf_event_output() or ring buffer interfaces.
+ *		bpf_trace_printk() is to be avoided as it places too small
+ *		a limit on string size to be useful.
+ *
+ *		*flags* is a combination of
+ *
+ *		**BTF_F_COMPACT**
+ *			no formatting around type information
+ *		**BTF_F_NONAME**
+ *			no struct/union member names/types
+ *		**BTF_F_PTR_RAW**
+ *			show raw (unobfuscated) pointer values;
+ *			equivalent to printk specifier %px.
+ *		**BTF_F_ZERO**
+ *			show zero-valued struct/union members; they
+ *			are not displayed by default
+ *
+ *	Return
+ *		The number of bytes that were written (or would have been
+ *		written if output had to be truncated due to string size),
+ *		or a negative error in cases of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3738,6 +3774,7 @@ struct bpf_stack_build_id {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(snprintf_btf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4846,4 +4883,34 @@ struct bpf_sk_lookup {
 	__u32 local_port;	/* Host byte order */
 };
 
+/*
+ * struct btf_ptr is used for typed pointer representation; the
+ * type id is used to render the pointer data as the appropriate type
+ * via the bpf_snprintf_btf() helper described above.  A flags field -
+ * potentially to specify additional details about the BTF pointer
+ * (rather than its mode of display) - is included for future use.
+ * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
+ */
+struct btf_ptr {
+	void *ptr;
+	__u32 type_id;
+	__u32 flags;		/* BTF ptr flags; unused at present. */
+};
+
+/*
+ * Flags to control bpf_snprintf_btf() behaviour.
+ *     - BTF_F_COMPACT: no formatting around type information
+ *     - BTF_F_NONAME: no struct/union member names/types
+ *     - BTF_F_PTR_RAW: show raw (unobfuscated) pointer values;
+ *       equivalent to %px.
+ *     - BTF_F_ZERO: show zero-valued struct/union members; they
+ *       are not displayed by default
+ */
+enum {
+	BTF_F_COMPACT	=	(1ULL << 0),
+	BTF_F_NONAME	=	(1ULL << 1),
+	BTF_F_PTR_RAW	=	(1ULL << 2),
+	BTF_F_ZERO	=	(1ULL << 3),
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c4811b13..403fb23 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2216,6 +2216,7 @@ void bpf_user_rnd_init_once(void)
 const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
 const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
+const struct bpf_func_proto bpf_snprintf_btf_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5cc7425..e825441 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -683,6 +683,10 @@ static int __bpf_strtoll(const char *buf, size_t buf_len, u64 flags,
 		if (!perfmon_capable())
 			return NULL;
 		return bpf_get_trace_printk_proto();
+	case BPF_FUNC_snprintf_btf:
+		if (!perfmon_capable())
+			return NULL;
+		return &bpf_snprintf_btf_proto;
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
 	default:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 36508f4..983cbd3 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/bpf.h>
 #include <linux/bpf_perf_event.h>
+#include <linux/btf.h>
 #include <linux/filter.h>
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
@@ -16,6 +17,9 @@
 #include <linux/error-injection.h>
 #include <linux/btf_ids.h>
 
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/btf.h>
+
 #include <asm/tlb.h>
 
 #include "trace_probe.h"
@@ -1147,6 +1151,65 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 	.allowed	= bpf_d_path_allowed,
 };
 
+#define BTF_F_ALL	(BTF_F_COMPACT  | BTF_F_NONAME | \
+			 BTF_F_PTR_RAW | BTF_F_ZERO)
+
+static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
+				  u64 flags, const struct btf **btf,
+				  s32 *btf_id)
+{
+	const struct btf_type *t;
+
+	if (unlikely(flags & ~(BTF_F_ALL)))
+		return -EINVAL;
+
+	if (btf_ptr_size != sizeof(struct btf_ptr))
+		return -EINVAL;
+
+	*btf = bpf_get_btf_vmlinux();
+
+	if (IS_ERR_OR_NULL(*btf))
+		return PTR_ERR(*btf);
+
+	if (ptr->type_id > 0)
+		*btf_id = ptr->type_id;
+	else
+		return -EINVAL;
+
+	if (*btf_id > 0)
+		t = btf_type_by_id(*btf, *btf_id);
+	if (*btf_id <= 0 || !t)
+		return -ENOENT;
+
+	return 0;
+}
+
+BPF_CALL_5(bpf_snprintf_btf, char *, str, u32, str_size, struct btf_ptr *, ptr,
+	   u32, btf_ptr_size, u64, flags)
+{
+	const struct btf *btf;
+	s32 btf_id;
+	int ret;
+
+	ret = bpf_btf_printf_prepare(ptr, btf_ptr_size, flags, &btf, &btf_id);
+	if (ret)
+		return ret;
+
+	return btf_type_snprintf_show(btf, btf_id, ptr->ptr, str, str_size,
+				      flags);
+}
+
+const struct bpf_func_proto bpf_snprintf_btf_proto = {
+	.func		= bpf_snprintf_btf,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_CONST_SIZE,
+	.arg5_type	= ARG_ANYTHING,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1233,6 +1296,8 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 		return &bpf_get_task_stack_proto;
 	case BPF_FUNC_copy_from_user:
 		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
+	case BPF_FUNC_snprintf_btf:
+		return &bpf_snprintf_btf_proto;
 	default:
 		return NULL;
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 0838817..7d86fdd 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -433,6 +433,7 @@ class PrinterHelpers(Printer):
             'struct sk_msg_md',
             'struct xdp_md',
             'struct path',
+            'struct btf_ptr',
     ]
     known_types = {
             '...',
@@ -474,6 +475,7 @@ class PrinterHelpers(Printer):
             'struct udp6_sock',
             'struct task_struct',
             'struct path',
+            'struct btf_ptr',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2d6519a..fcafe80 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3587,6 +3587,42 @@ struct bpf_stack_build_id {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * long bpf_snprintf_btf(char *str, u32 str_size, struct btf_ptr *ptr, u32 btf_ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to store a string representation of *ptr*->ptr in *str*,
+ *		using *ptr*->type_id.  This value should specify the type
+ *		that *ptr*->ptr points to. LLVM __builtin_btf_type_id(type, 1)
+ *		can be used to look up vmlinux BTF type ids. Traversing the
+ *		data structure using BTF, the type information and values are
+ *		stored in the first *str_size* - 1 bytes of *str*.  Safe copy of
+ *		the pointer data is carried out to avoid kernel crashes during
+ *		operation.  Smaller types can use string space on the stack;
+ *		larger programs can use map data to store the string
+ *		representation.
+ *
+ *		The string can be subsequently shared with userspace via
+ *		bpf_perf_event_output() or ring buffer interfaces.
+ *		bpf_trace_printk() is to be avoided as it places too small
+ *		a limit on string size to be useful.
+ *
+ *		*flags* is a combination of
+ *
+ *		**BTF_F_COMPACT**
+ *			no formatting around type information
+ *		**BTF_F_NONAME**
+ *			no struct/union member names/types
+ *		**BTF_F_PTR_RAW**
+ *			show raw (unobfuscated) pointer values;
+ *			equivalent to printk specifier %px.
+ *		**BTF_F_ZERO**
+ *			show zero-valued struct/union members; they
+ *			are not displayed by default
+ *
+ *	Return
+ *		The number of bytes that were written (or would have been
+ *		written if output had to be truncated due to string size),
+ *		or a negative error in cases of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3738,6 +3774,7 @@ struct bpf_stack_build_id {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(snprintf_btf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4846,4 +4883,34 @@ struct bpf_sk_lookup {
 	__u32 local_port;	/* Host byte order */
 };
 
+/*
+ * struct btf_ptr is used for typed pointer representation; the
+ * type id is used to render the pointer data as the appropriate type
+ * via the bpf_snprintf_btf() helper described above.  A flags field -
+ * potentially to specify additional details about the BTF pointer
+ * (rather than its mode of display) - is included for future use.
+ * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
+ */
+struct btf_ptr {
+	void *ptr;
+	__u32 type_id;
+	__u32 flags;		/* BTF ptr flags; unused at present. */
+};
+
+/*
+ * Flags to control bpf_snprintf_btf() behaviour.
+ *     - BTF_F_COMPACT: no formatting around type information
+ *     - BTF_F_NONAME: no struct/union member names/types
+ *     - BTF_F_PTR_RAW: show raw (unobfuscated) pointer values;
+ *       equivalent to %px.
+ *     - BTF_F_ZERO: show zero-valued struct/union members; they
+ *       are not displayed by default
+ */
+enum {
+	BTF_F_COMPACT	=	(1ULL << 0),
+	BTF_F_NONAME	=	(1ULL << 1),
+	BTF_F_PTR_RAW	=	(1ULL << 2),
+	BTF_F_ZERO	=	(1ULL << 3),
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
1.8.3.1

