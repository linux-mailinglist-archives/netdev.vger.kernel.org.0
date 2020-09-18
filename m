Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A590A26FEBB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgIRNhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:37:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47670 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgIRNg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:36:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IDYSXZ098472;
        Fri, 18 Sep 2020 13:35:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Jwnvdun6nOvSs/xa8REH2cHgb5bDJINQTT5NVPBL0+c=;
 b=vODJpGb6cNhCRnL5qNpLbWIBdABz1y+nZRRIwjtsUj0kOtjyHJDndUQ5Uv2RFY6PJY3I
 nIAqG3h6l/j//e39EDVySzlpOzfRNJq5830nkzkWX/kj8xdXPWfT+Ra+u1y06CFtpvqG
 SV4wwi4uPZdzQy8ve6l6dJ3dHcFhxq0uCutC7zQDva8ltdEJ7NvcDUrxDdJhxueWkYX4
 sLZAxV6xxXvZ2NRyi38UCQt+fvPMLgQYCRHQxz0k3h/YohSNB/i+xrJ8Rav8VDSblxCQ
 ntx4tb3t4HeOj694yEhFP4HxsAiXRS5w4rIqTDDXYPXVlptiaS8wiV2Ux6XmZpJmvFXQ Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91e0uq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 13:35:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IDU4rv044136;
        Fri, 18 Sep 2020 13:35:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33hm36v2hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 13:35:50 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08IDZmVd018436;
        Fri, 18 Sep 2020 13:35:48 GMT
Received: from localhost.uk.oracle.com (/10.175.217.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 13:35:48 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 3/6] bpf: add bpf_btf_snprintf helper
Date:   Fri, 18 Sep 2020 14:34:32 +0100
Message-Id: <1600436075-2961-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600436075-2961-1-git-send-email-alan.maguire@oracle.com>
References: <1600436075-2961-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper is added to support tracing kernel type information in BPF
using the BPF Type Format (BTF).  Its signature is

long bpf_btf_snprintf(char *str, u32 str_size, struct btf_ptr *ptr,
		      u32 btf_ptr_size, u64 flags);

struct btf_ptr * specifies

- a pointer to the data to be traced;
- the BTF id of the type of data pointed to; or
- a string representation of the type of data pointed to
- a flags field is provided for future use; these flags
  are not to be confused with the BTF_SNPRINTF_F_* flags
  below that control how the btf_ptr is displayed; the
  flags member of the struct btf_ptr may be used to
  disambiguate types in kernel versus module BTF, etc;
  the main distinction is the flags relate to the type
  and information needed in identifying it; not how it
  is displayed.

For example a BPF program with a struct sk_buff *skb
could do the following:

	static const char skb_type[] = "struct sk_buff";
	static struct btf_ptr b = { };

	b.ptr = skb;
	b.type = skb_type;
	bpf_btf_snprintf(str, sizeof(str), &b, sizeof(b), 0, 0);

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
 include/linux/btf.h            |  9 +++--
 include/uapi/linux/bpf.h       | 68 ++++++++++++++++++++++++++++++++
 kernel/bpf/helpers.c           |  4 ++
 kernel/trace/bpf_trace.c       | 88 ++++++++++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 +
 tools/include/uapi/linux/bpf.h | 68 ++++++++++++++++++++++++++++++++
 7 files changed, 236 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c0ad5d8..9acbd59 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1787,6 +1787,7 @@ static inline int bpf_fd_reuseport_array_update_elem(struct bpf_map *map,
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_proto;
+extern const struct bpf_func_proto bpf_btf_snprintf_proto;
 
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
index 7dd3141..9b89b67 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3579,6 +3579,41 @@ struct bpf_stack_build_id {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * long bpf_btf_snprintf(char *str, u32 str_size, struct btf_ptr *ptr, u32 btf_ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to store a string representation of *ptr*->ptr in *str*,
+ *		using *ptr*->type name or *ptr*->type_id.  These values should
+ *		specify the type *ptr*->ptr points to. Traversing that
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
@@ -3730,6 +3765,7 @@ struct bpf_stack_build_id {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(btf_snprintf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4838,4 +4874,36 @@ struct bpf_sk_lookup {
 	__u32 local_port;	/* Host byte order */
 };
 
+/*
+ * struct btf_ptr is used for typed pointer representation; the
+ * additional type string/BTF type id are used to render the pointer
+ * data as the appropriate type via the bpf_btf_snprintf() helper
+ * above.  A flags field - potentially to specify additional details
+ * about the BTF pointer (rather than its mode of display) - is
+ * present for future use.  Display flags - BTF_F_* - are
+ * passed to bpf_btf_snprintf separately.
+ */
+struct btf_ptr {
+	void *ptr;
+	const char *type;
+	__u32 type_id;
+	__u32 flags;		/* BTF ptr flags; unused at present. */
+};
+
+/*
+ * Flags to control bpf_btf_snprintf() behaviour.
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
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5cc7425..500ff76 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -683,6 +683,10 @@ static int __bpf_strtoll(const char *buf, size_t buf_len, u64 flags,
 		if (!perfmon_capable())
 			return NULL;
 		return bpf_get_trace_printk_proto();
+	case BPF_FUNC_btf_snprintf:
+		if (!perfmon_capable())
+			return NULL;
+		return &bpf_btf_snprintf_proto;
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
 	default:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b2a5380..f171e03 100644
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
@@ -1144,6 +1148,88 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 	.allowed	= bpf_d_path_allowed,
 };
 
+#define BTF_F_ALL	(BTF_F_COMPACT  | BTF_F_NONAME | \
+			 BTF_F_PTR_RAW | BTF_F_ZERO)
+
+BPF_CALL_5(bpf_btf_snprintf, char *, str, u32, str_size, struct btf_ptr *, ptr,
+	   u32, btf_ptr_size, u64, flags)
+{
+	u8 btf_kind = BTF_KIND_TYPEDEF;
+	char type_name[KSYM_NAME_LEN];
+	const struct btf_type *t;
+	const struct btf *btf;
+	const char *btf_type;
+	s32 btf_id;
+	int ret;
+
+	if (unlikely(flags & ~(BTF_F_ALL)))
+		return -EINVAL;
+
+	if (btf_ptr_size != sizeof(struct btf_ptr))
+		return -EINVAL;
+
+	btf = bpf_get_btf_vmlinux();
+
+	if (IS_ERR_OR_NULL(btf))
+		return PTR_ERR(btf);
+
+	if (ptr->type != NULL) {
+		ret = copy_from_kernel_nofault(type_name, ptr->type,
+					       sizeof(type_name));
+		if (ret)
+			return ret;
+
+		btf_type = type_name;
+
+		if (strncmp(btf_type, "struct ", strlen("struct ")) == 0) {
+			btf_kind = BTF_KIND_STRUCT;
+			btf_type += strlen("struct ");
+		} else if (strncmp(btf_type, "union ", strlen("union ")) == 0) {
+			btf_kind = BTF_KIND_UNION;
+			btf_type += strlen("union ");
+		} else if (strncmp(btf_type, "enum ", strlen("enum ")) == 0) {
+			btf_kind = BTF_KIND_ENUM;
+			btf_type += strlen("enum ");
+		}
+
+		if (strlen(btf_type) == 0)
+			return -EINVAL;
+
+		/* Assume type specified is a typedef as there's not much
+		 * benefit in specifying int types other than wasting time
+		 * on BTF lookups; we optimize for the most useful path.
+		 *
+		 * Fall back to BTF_KIND_INT if this fails.
+		 */
+		btf_id = btf_find_by_name_kind(btf, btf_type, btf_kind);
+		if (btf_id < 0)
+			btf_id = btf_find_by_name_kind(btf, btf_type,
+						       BTF_KIND_INT);
+	} else if (ptr->type_id > 0)
+		btf_id = ptr->type_id;
+	else
+		return -EINVAL;
+
+	if (btf_id > 0)
+		t = btf_type_by_id(btf, btf_id);
+	if (btf_id <= 0 || !t)
+		return -ENOENT;
+
+	return btf_type_snprintf_show(btf, btf_id, ptr->ptr, str, str_size,
+				      flags);
+}
+
+const struct bpf_func_proto bpf_btf_snprintf_proto = {
+	.func		= bpf_btf_snprintf,
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
@@ -1230,6 +1316,8 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 		return &bpf_get_task_stack_proto;
 	case BPF_FUNC_copy_from_user:
 		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
+	case BPF_FUNC_btf_snprintf:
+		return &bpf_btf_snprintf_proto;
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
index 7dd3141..9b89b67 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3579,6 +3579,41 @@ struct bpf_stack_build_id {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * long bpf_btf_snprintf(char *str, u32 str_size, struct btf_ptr *ptr, u32 btf_ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to store a string representation of *ptr*->ptr in *str*,
+ *		using *ptr*->type name or *ptr*->type_id.  These values should
+ *		specify the type *ptr*->ptr points to. Traversing that
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
@@ -3730,6 +3765,7 @@ struct bpf_stack_build_id {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(btf_snprintf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4838,4 +4874,36 @@ struct bpf_sk_lookup {
 	__u32 local_port;	/* Host byte order */
 };
 
+/*
+ * struct btf_ptr is used for typed pointer representation; the
+ * additional type string/BTF type id are used to render the pointer
+ * data as the appropriate type via the bpf_btf_snprintf() helper
+ * above.  A flags field - potentially to specify additional details
+ * about the BTF pointer (rather than its mode of display) - is
+ * present for future use.  Display flags - BTF_F_* - are
+ * passed to bpf_btf_snprintf separately.
+ */
+struct btf_ptr {
+	void *ptr;
+	const char *type;
+	__u32 type_id;
+	__u32 flags;		/* BTF ptr flags; unused at present. */
+};
+
+/*
+ * Flags to control bpf_btf_snprintf() behaviour.
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

