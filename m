Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B0F23E319
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 22:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgHFUXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 16:23:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58814 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFUXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 16:23:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076EgMwu175543;
        Thu, 6 Aug 2020 14:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=CE7KtxbAGcL4nukGr7Cv8FBVnQwbG/h67RsKKvAelw8=;
 b=AR3Lnf7IRgptw12PagVhc1EX9A61V1QZtfonFuw67Y/F53MZKl7/c5Fc4GLSHGgjPhWm
 tUSKYr7MMxe2a56JSB0zQ/unSB5juWhh0o68XKU+sfYCeKcx7qToT1jLvf6ii6a3x8J4
 fWHQhRKk8s0LM8RQ0DaxTIysEiazT7evfcXd/yv5j5iwL6hgAB+SgcP6tSlXSViY3ays
 t/N7+/rNKRZka+1MimQaiB3vnD8mSJFuuR0CYZ8lLO8H5+odIvFeI+ALL9Vt3+REgwBV
 DkDkfqU/w2AiDXki4Gai/jvu6VODfbkUZFTtoX2XICqxp171uYsYvaaMS+BUs1jC+O1X XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32r6fxkcm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 14:43:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076Eh994185641;
        Thu, 6 Aug 2020 14:43:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32qy8ngctr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 14:43:11 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 076Egx6d006066;
        Thu, 6 Aug 2020 14:42:59 GMT
Received: from localhost.uk.oracle.com (/10.175.182.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 07:42:59 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 3/4] bpf: add bpf_trace_btf helper
Date:   Thu,  6 Aug 2020 15:42:24 +0100
Message-Id: <1596724945-22859-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com>
References: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper is added to support tracing kernel type information in BPF
using the BPF Type Format (BTF).  Its signature is

long bpf_trace_btf(struct btf_ptr *ptr, u32 btf_ptr_size, u32 trace_id,
                   u64 flags);

struct btf_ptr * specifies

- a pointer to the data to be traced;
- the BTF id of the type of data pointed to; or
- a string representation of the type of data pointed to
- a flags field is provided for future use; these flags
  are not to be confused with the BTF_TRACE_F_* flags
  below that control how the btf_ptr is displayed; the
  flags member of the struct btf_ptr may be used to
  disambiguate types in kernel versus module BTF, etc;
  the main distinction is the flags relate to the type
  and information needed in identifying it; not how it
  is displayed.

The helper also specifies a trace id which is set for the
bpf_trace_printk tracepoint; this allows BPF programs
to filter on specific trace ids, ensuring output does
not become mixed between different traced events and
hard to read.

For example a BPF program with a struct sk_buff *skb
could do the following:

        static const char *skb_type = "struct sk_buff";
        static struct btf_ptr b = { };

        b.ptr = skb;
        b.type = skb_type;
        bpf_trace_btf(&b, sizeof(b), 0, 0);

Default output in the trace_pipe looks like this:

          <idle>-0     [023] d.s.  1825.778400: bpf_trace_printk: (struct sk_buff){
          <idle>-0     [023] d.s.  1825.778409: bpf_trace_printk:  (union){
          <idle>-0     [023] d.s.  1825.778410: bpf_trace_printk:   (struct){
          <idle>-0     [023] d.s.  1825.778412: bpf_trace_printk:    .prev = (struct sk_buff *)0x00000000b2a3df7e,
          <idle>-0     [023] d.s.  1825.778413: bpf_trace_printk:    (union){
          <idle>-0     [023] d.s.  1825.778414: bpf_trace_printk:     .dev = (struct net_device *)0x000000001658808b,
          <idle>-0     [023] d.s.  1825.778416: bpf_trace_printk:     .dev_scratch = (long unsigned int)18446628460391432192,
          <idle>-0     [023] d.s.  1825.778417: bpf_trace_printk:    },
          <idle>-0     [023] d.s.  1825.778417: bpf_trace_printk:   },
          <idle>-0     [023] d.s.  1825.778418: bpf_trace_printk:   .rbnode = (struct rb_node){
          <idle>-0     [023] d.s.  1825.778419: bpf_trace_printk:    .rb_right = (struct rb_node *)0x00000000b2a3df7e,
          <idle>-0     [023] d.s.  1825.778420: bpf_trace_printk:    .rb_left = (struct rb_node *)0x000000001658808b,
          <idle>-0     [023] d.s.  1825.778420: bpf_trace_printk:   },
          <idle>-0     [023] d.s.  1825.778421: bpf_trace_printk:   .list = (struct list_head){
          <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:    .prev = (struct list_head *)0x00000000b2a3df7e,
          <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:   },
          <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:  },
          <idle>-0     [023] d.s.  1825.778426: bpf_trace_printk:  .len = (unsigned int)168,
          <idle>-0     [023] d.s.  1825.778427: bpf_trace_printk:  .mac_len = (__u16)14,
          <idle>-0     [023] d.s.  1825.778428: bpf_trace_printk:  .queue_mapping = (__u16)17,
          <idle>-0     [023] d.s.  1825.778430: bpf_trace_printk:  .head_frag = (__u8)0x1,
          <idle>-0     [023] d.s.  1825.778431: bpf_trace_printk:  .ip_summed = (__u8)0x1,
          <idle>-0     [023] d.s.  1825.778432: bpf_trace_printk:  .l4_hash = (__u8)0x1,
          <idle>-0     [023] d.s.  1825.778433: bpf_trace_printk:  .hash = (__u32)1873247608,
          <idle>-0     [023] d.s.  1825.778434: bpf_trace_printk:  (union){
          <idle>-0     [023] d.s.  1825.778435: bpf_trace_printk:   .napi_id = (unsigned int)8209,
          <idle>-0     [023] d.s.  1825.778436: bpf_trace_printk:   .sender_cpu = (unsigned int)8209,
          <idle>-0     [023] d.s.  1825.778436: bpf_trace_printk:  },
          <idle>-0     [023] d.s.  1825.778437: bpf_trace_printk:  .protocol = (__be16)8,
          <idle>-0     [023] d.s.  1825.778438: bpf_trace_printk:  .transport_header = (__u16)226,
          <idle>-0     [023] d.s.  1825.778439: bpf_trace_printk:  .network_header = (__u16)206,
          <idle>-0     [023] d.s.  1825.778440: bpf_trace_printk:  .mac_header = (__u16)192,
          <idle>-0     [023] d.s.  1825.778440: bpf_trace_printk:  .tail = (sk_buff_data_t)374,
          <idle>-0     [023] d.s.  1825.778441: bpf_trace_printk:  .end = (sk_buff_data_t)1728,
          <idle>-0     [023] d.s.  1825.778442: bpf_trace_printk:  .head = (unsigned char *)0x000000009798cb6b,
          <idle>-0     [023] d.s.  1825.778443: bpf_trace_printk:  .data = (unsigned char *)0x0000000064823282,
          <idle>-0     [023] d.s.  1825.778444: bpf_trace_printk:  .truesize = (unsigned int)2304,
          <idle>-0     [023] d.s.  1825.778445: bpf_trace_printk:  .users = (refcount_t){
          <idle>-0     [023] d.s.  1825.778445: bpf_trace_printk:   .refs = (atomic_t){
          <idle>-0     [023] d.s.  1825.778447: bpf_trace_printk:    .counter = (int)1,
          <idle>-0     [023] d.s.  1825.778447: bpf_trace_printk:   },
          <idle>-0     [023] d.s.  1825.778447: bpf_trace_printk:  },
          <idle>-0     [023] d.s.  1825.778448: bpf_trace_printk: }

Flags modifying display are as follows:

- BTF_TRACE_F_COMPACT:	no formatting around type information
- BTF_TRACE_F_NONAME:	no struct/union member names/types
- BTF_TRACE_F_PTR_RAW:	show raw (unobfuscated) pointer values;
			equivalent to %px.
- BTF_TRACE_F_ZERO:	show zero-valued struct/union members;
			they are not displayed by default

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/bpf.h            |   1 +
 include/linux/btf.h            |   9 ++--
 include/uapi/linux/bpf.h       |  63 +++++++++++++++++++++++++
 kernel/bpf/core.c              |   5 ++
 kernel/bpf/helpers.c           |   4 ++
 kernel/trace/bpf_trace.c       | 102 ++++++++++++++++++++++++++++++++++++++++-
 scripts/bpf_helpers_doc.py     |   2 +
 tools/include/uapi/linux/bpf.h |  63 +++++++++++++++++++++++++
 8 files changed, 243 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6143b6e..f67819d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -934,6 +934,7 @@ struct bpf_event_entry {
 const char *kernel_type_name(u32 btf_type_id);
 
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
+const struct bpf_func_proto *bpf_get_trace_btf_proto(void);
 
 typedef unsigned long (*bpf_ctx_copy_t)(void *dst, const void *src,
 					unsigned long off, unsigned long len);
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 46bf9f4..3d31e28 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 #include <uapi/linux/btf.h>
+#include <uapi/linux/bpf.h>
 
 #define BTF_TYPE_EMIT(type) ((void)(type *)0)
 
@@ -61,10 +62,10 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
  *	- BTF_SHOW_UNSAFE: skip use of bpf_probe_read() to safely read
  *	  data before displaying it.
  */
-#define BTF_SHOW_COMPACT	(1ULL << 0)
-#define BTF_SHOW_NONAME		(1ULL << 1)
-#define BTF_SHOW_PTR_RAW	(1ULL << 2)
-#define BTF_SHOW_ZERO		(1ULL << 3)
+#define BTF_SHOW_COMPACT	BTF_TRACE_F_COMPACT
+#define BTF_SHOW_NONAME		BTF_TRACE_F_NONAME
+#define BTF_SHOW_PTR_RAW	BTF_TRACE_F_PTR_RAW
+#define BTF_SHOW_ZERO		BTF_TRACE_F_ZERO
 #define BTF_SHOW_NONEWLINE	(1ULL << 32)
 #define BTF_SHOW_UNSAFE		(1ULL << 33)
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b134e67..726fee4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3394,6 +3394,36 @@ struct bpf_stack_build_id {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * long bpf_trace_btf(struct btf_ptr *ptr, u32 btf_ptr_size, u32 trace_id, u64 flags)
+ *	Description
+ *		Utilize BTF to trace a representation of *ptr*->ptr, using
+ *		*ptr*->type name or *ptr*->type_id.  *ptr*->type_name
+ *		should specify the type *ptr*->ptr points to. Traversing that
+ *		data structure using BTF, the type information and values are
+ *		bpf_trace_printk()ed.  Safe copy of the pointer data is
+ *		carried out to avoid kernel crashes during data display.
+ *		Tracing specifies *trace_id* as the id associated with the
+ *		trace event; this can be used to filter trace events
+ *		to show a subset of all traced output, helping to avoid
+ *		the situation where BTF output is intermixed with other
+ *		output.
+ *
+ *		*flags* is a combination of
+ *
+ *		**BTF_TRACE_F_COMPACT**
+ *			no formatting around type information
+ *		**BTF_TRACE_F_NONAME**
+ *			no struct/union member names/types
+ *		**BTF_TRACE_F_PTR_RAW**
+ *			show raw (unobfuscated) pointer values;
+ *			equivalent to printk specifier %px.
+ *		**BTF_TRACE_F_ZERO**
+ *			show zero-valued struct/union members; they
+ *			are not displayed by default
+ *
+ *	Return
+ *		The number of bytes traced, or a negative error in cases of
+ *		failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3538,6 +3568,7 @@ struct bpf_stack_build_id {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(trace_btf),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4446,4 +4477,36 @@ struct bpf_sk_lookup {
 	__u32 local_port;	/* Host byte order */
 };
 
+/*
+ * struct btf_ptr is used for typed pointer display; the
+ * additional type string/BTF type id are used to render the pointer
+ * data as the appropriate type via the bpf_trace_btf() helper
+ * above.  A flags field - potentially to specify additional details
+ * about the BTF pointer (rather than its mode of display) - is
+ * present for future use.  Display flags - BTF_TRACE_F_* - are
+ * passed to display functions separately.
+ */
+struct btf_ptr {
+	void *ptr;
+	const char *type;
+	__u32 type_id;
+	__u32 flags;		/* BTF ptr flags; unused at present. */
+};
+
+/*
+ * Flags to control bpf_trace_btf() behaviour.
+ *	- BTF_TRACE_F_COMPACT: no formatting around type information
+ *	- BTF_TRACE_F_NONAME: no struct/union member names/types
+ *	- BTF_TRACE_F_PTR_RAW: show raw (unobfuscated) pointer values;
+ *	  equivalent to %px.
+ *	- BTF_TRACE_F_ZERO: show zero-valued struct/union members; they
+ *	  are not displayed by default
+ */
+enum {
+	BTF_TRACE_F_COMPACT	=	(1ULL << 0),
+	BTF_TRACE_F_NONAME	=	(1ULL << 1),
+	BTF_TRACE_F_PTR_RAW	=	(1ULL << 2),
+	BTF_TRACE_F_ZERO	=	(1ULL << 3),
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index bde9334..82b3a98 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2214,6 +2214,11 @@ const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 	return NULL;
 }
 
+const struct bpf_func_proto * __weak bpf_get_trace_btf_proto(void)
+{
+	return NULL;
+}
+
 u64 __weak
 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 		 void *ctx, u64 ctx_size, bpf_ctx_copy_t ctx_copy)
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index be43ab3..b9a842b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -661,6 +661,10 @@ static int __bpf_strtoll(const char *buf, size_t buf_len, u64 flags,
 		if (!perfmon_capable())
 			return NULL;
 		return bpf_get_trace_printk_proto();
+	case BPF_FUNC_trace_btf:
+		if (!perfmon_capable())
+			return NULL;
+		return bpf_get_trace_btf_proto();
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
 	default:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6453a75..92212a1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -14,8 +14,12 @@
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
 #include <linux/error-injection.h>
+#include <linux/btf.h>
 #include <linux/btf_ids.h>
 
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/btf.h>
+
 #include <asm/tlb.h>
 
 #include "trace_probe.h"
@@ -555,10 +559,91 @@ static __printf(1, 0) int bpf_do_trace_printk(const char *fmt, ...)
 	.arg2_type	= ARG_CONST_SIZE,
 };
 
-const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
+#define BTF_TRACE_F_ALL	(BTF_TRACE_F_COMPACT | BTF_TRACE_F_NONAME | \
+			 BTF_TRACE_F_PTR_RAW | BTF_TRACE_F_ZERO)
+
+BPF_CALL_4(bpf_trace_btf, struct btf_ptr *, ptr, u32, btf_ptr_size,
+	   u32, trace_id, u64, flags)
+{
+	u8 btf_kind = BTF_KIND_TYPEDEF;
+	char type_name[KSYM_NAME_LEN];
+	const struct btf_type *t;
+	const struct btf *btf;
+	const char *btf_type;
+	s32 btf_id;
+	int ret;
+
+	if (unlikely(flags & ~(BTF_TRACE_F_ALL)))
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
+		/*
+		 * Assume type specified is a typedef as there's not much
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
+	return btf_type_trace_show(btf, btf_id, ptr->ptr, trace_id, flags);
+}
+
+static const struct bpf_func_proto bpf_trace_btf_proto = {
+	.func		= bpf_trace_btf,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_ANYTHING,
+};
+
+static void bpf_trace_printk_enable(void)
 {
 	/*
-	 * This program might be calling bpf_trace_printk,
+	 * This program might be calling bpf_trace_[printk|btf],
 	 * so enable the associated bpf_trace/bpf_trace_printk event.
 	 * Repeat this each time as it is possible a user has
 	 * disabled bpf_trace_printk events.  By loading a program
@@ -567,10 +652,21 @@ const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
 	 */
 	if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
 		pr_warn_ratelimited("could not enable bpf_trace_printk events");
+}
+const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
+{
+	bpf_trace_printk_enable();
 
 	return &bpf_trace_printk_proto;
 }
 
+const struct bpf_func_proto *bpf_get_trace_btf_proto(void)
+{
+	bpf_trace_printk_enable();
+
+	return &bpf_trace_btf_proto;
+}
+
 #define MAX_SEQ_PRINTF_VARARGS		12
 #define MAX_SEQ_PRINTF_MAX_MEMCPY	6
 #define MAX_SEQ_PRINTF_STR_LEN		128
@@ -1139,6 +1235,8 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		return &bpf_get_current_comm_proto;
 	case BPF_FUNC_trace_printk:
 		return bpf_get_trace_printk_proto();
+	case BPF_FUNC_trace_btf:
+		return bpf_get_trace_btf_proto();
 	case BPF_FUNC_get_smp_processor_id:
 		return &bpf_get_smp_processor_id_proto;
 	case BPF_FUNC_get_numa_node_id:
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 5bfa448..7c7384b 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -432,6 +432,7 @@ class PrinterHelpers(Printer):
             'struct __sk_buff',
             'struct sk_msg_md',
             'struct xdp_md',
+            'struct btf_ptr',
     ]
     known_types = {
             '...',
@@ -472,6 +473,7 @@ class PrinterHelpers(Printer):
             'struct tcp_request_sock',
             'struct udp6_sock',
             'struct task_struct',
+            'struct btf_ptr',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b134e67..726fee4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3394,6 +3394,36 @@ struct bpf_stack_build_id {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * long bpf_trace_btf(struct btf_ptr *ptr, u32 btf_ptr_size, u32 trace_id, u64 flags)
+ *	Description
+ *		Utilize BTF to trace a representation of *ptr*->ptr, using
+ *		*ptr*->type name or *ptr*->type_id.  *ptr*->type_name
+ *		should specify the type *ptr*->ptr points to. Traversing that
+ *		data structure using BTF, the type information and values are
+ *		bpf_trace_printk()ed.  Safe copy of the pointer data is
+ *		carried out to avoid kernel crashes during data display.
+ *		Tracing specifies *trace_id* as the id associated with the
+ *		trace event; this can be used to filter trace events
+ *		to show a subset of all traced output, helping to avoid
+ *		the situation where BTF output is intermixed with other
+ *		output.
+ *
+ *		*flags* is a combination of
+ *
+ *		**BTF_TRACE_F_COMPACT**
+ *			no formatting around type information
+ *		**BTF_TRACE_F_NONAME**
+ *			no struct/union member names/types
+ *		**BTF_TRACE_F_PTR_RAW**
+ *			show raw (unobfuscated) pointer values;
+ *			equivalent to printk specifier %px.
+ *		**BTF_TRACE_F_ZERO**
+ *			show zero-valued struct/union members; they
+ *			are not displayed by default
+ *
+ *	Return
+ *		The number of bytes traced, or a negative error in cases of
+ *		failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3538,6 +3568,7 @@ struct bpf_stack_build_id {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(trace_btf),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4446,4 +4477,36 @@ struct bpf_sk_lookup {
 	__u32 local_port;	/* Host byte order */
 };
 
+/*
+ * struct btf_ptr is used for typed pointer display; the
+ * additional type string/BTF type id are used to render the pointer
+ * data as the appropriate type via the bpf_trace_btf() helper
+ * above.  A flags field - potentially to specify additional details
+ * about the BTF pointer (rather than its mode of display) - is
+ * present for future use.  Display flags - BTF_TRACE_F_* - are
+ * passed to display functions separately.
+ */
+struct btf_ptr {
+	void *ptr;
+	const char *type;
+	__u32 type_id;
+	__u32 flags;		/* BTF ptr flags; unused at present. */
+};
+
+/*
+ * Flags to control bpf_trace_btf() behaviour.
+ *	- BTF_TRACE_F_COMPACT: no formatting around type information
+ *	- BTF_TRACE_F_NONAME: no struct/union member names/types
+ *	- BTF_TRACE_F_PTR_RAW: show raw (unobfuscated) pointer values;
+ *	  equivalent to %px.
+ *	- BTF_TRACE_F_ZERO: show zero-valued struct/union members; they
+ *	  are not displayed by default
+ */
+enum {
+	BTF_TRACE_F_COMPACT	=	(1ULL << 0),
+	BTF_TRACE_F_NONAME	=	(1ULL << 1),
+	BTF_TRACE_F_PTR_RAW	=	(1ULL << 2),
+	BTF_TRACE_F_ZERO	=	(1ULL << 3),
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
1.8.3.1

