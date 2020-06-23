Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C5D2051FE
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732723AbgFWMKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:10:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51566 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732364AbgFWMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:10:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7kBj165372;
        Tue, 23 Jun 2020 12:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Yr077G7HHvjaApviN2UZnD5/PNMj9ClVOffuYqAVEYI=;
 b=zRnlpoCOjn3AZONQ+EfPSxkBX5SJOxmMVsOUrAYz9YDbcUrB4aL6LPCT8fNBs32SjbWM
 D7CUQLyUwLFqspiWf2kaLQyWELpmxO70TZyho50QXcN3A9jfPcu/94KGLclAiRdiOtv8
 EbzbmkTzNvyrLGIAZTBGwi8kZWDj598q+0QdWujHUOTmeRZ9PGxxyyg5p0xlInYnVd5S
 igeoOKCGtapQbBL2ca/+b4Md76hfrf1PHO+TJIImQofUWAMYCql5kUaHJtJGtbTzuMH2
 TkoGKgAlwqz1icdPRiyXU5ybsbwIZwPyu4Ihq4fcwVV8FP5p4nUok/9f/vAmo0TVi6q3 Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31sebbmttt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 12:09:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC9CAF063642;
        Tue, 23 Jun 2020 12:09:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31svcwnjpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 12:09:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05NC9ILm018697;
        Tue, 23 Jun 2020 12:09:18 GMT
Received: from localhost.uk.oracle.com (/10.175.166.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 12:09:18 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com
Cc:     kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux@rasmusvillemoes.dk, joe@perches.com,
        pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 bpf-next 4/8] printk: add type-printing %pT format specifier which uses BTF
Date:   Tue, 23 Jun 2020 13:07:07 +0100
Message-Id: <1592914031-31049-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

printk supports multiple pointer object type specifiers (printing
netdev features etc).  Extend this support using BTF to cover
arbitrary types.  "%pT" specifies the typed format, and the pointer
argument is a "struct btf_ptr *" where struct btf_ptr is as follows:

struct btf_ptr {
        void *ptr;
        const char *type;
        u32 id;
};

Either the "type" string ("struct sk_buff") or the BTF "id" can be
used to identify the type to use in displaying the associated "ptr"
value.  A convenience function to create and point at the struct
is provided:

        printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));

When invoked, BTF information is used to traverse the sk_buff *
and display it.  Support is present for structs, unions, enums,
typedefs and core types (though in the latter case there's not
much value in using this feature of course).

Default output is indented, but compact output can be specified
via the 'c' option.  Type names/member values can be suppressed
using the 'N' option.  Zero values are not displayed by default
but can be using the '0' option.  Pointer values are obfuscated
unless the 'x' option is specified.  As an example:

  struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
  pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));

...gives us:

(struct sk_buff){
 .transport_header = (__u16)65535,
 .mac_header = (__u16)65535,
 .end = (sk_buff_data_t)192,
 .head = (unsigned char *)0x000000006b71155a,
 .data = (unsigned char *)0x000000006b71155a,
 .truesize = (unsigned int)768,
 .users = (refcount_t){
  .refs = (atomic_t){
   .counter = (int)1,
  },
 },
 .extensions = (struct skb_ext *)0x00000000f486a130,
}

printk output is truncated at 1024 bytes.  For cases where overflow
is likely, the compact/no type names display modes may be used.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>

i
---
 Documentation/core-api/printk-formats.rst | 17 ++++++
 include/linux/btf.h                       |  3 +-
 include/linux/printk.h                    | 16 +++++
 lib/vsprintf.c                            | 98 +++++++++++++++++++++++++++++++
 4 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 8c9aba2..8f255d0 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -563,6 +563,23 @@ For printing netdev_features_t.
 
 Passed by reference.
 
+BTF-based printing of pointer data
+----------------------------------
+If '%pT' is specified, use the struct btf_ptr * along with kernel vmlinux
+BPF Type Format (BTF) to show the typed data.  For example, specifying
+
+	printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct_sk_buff));
+
+will utilize BTF information to traverse the struct sk_buff * and display it.
+
+Supported modifers are
+ 'c' compact output (no indentation, newlines etc)
+ 'N' do not show type names
+ 'u' unsafe printing; probe_kernel_read() is not used to copy data safely
+     before use
+ 'x' show raw pointers (no obfuscation)
+ '0' show zero-valued data (it is not shown by default)
+
 Thanks
 ======
 
diff --git a/include/linux/btf.h b/include/linux/btf.h
index a8a4563..e8dbf0c 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -172,10 +172,11 @@ static inline const struct btf_member *btf_type_member(const struct btf_type *t)
 	return (const struct btf_member *)(t + 1);
 }
 
+struct btf *btf_parse_vmlinux(void);
+
 #ifdef CONFIG_BPF_SYSCALL
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
-struct btf *btf_parse_vmlinux(void);
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
diff --git a/include/linux/printk.h b/include/linux/printk.h
index fc8f03c..8f8f5d2 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -618,4 +618,20 @@ static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,
 #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
 	print_hex_dump_debug(prefix_str, prefix_type, 16, 1, buf, len, true)
 
+/**
+ * struct btf_ptr is used for %pT (typed pointer) display; the
+ * additional type string/BTF id are used to render the pointer
+ * data as the appropriate type.
+ */
+struct btf_ptr {
+	void *ptr;
+	const char *type;
+	u32 id;
+};
+
+#define	BTF_PTR_TYPE(ptrval, typeval) \
+	(&((struct btf_ptr){.ptr = ptrval, .type = #typeval}))
+
+#define BTF_PTR_ID(ptrval, idval) \
+	(&((struct btf_ptr){.ptr = ptrval, .id = idval}))
 #endif
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 259e558..c0d209d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -44,6 +44,7 @@
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
 #endif
+#include <linux/btf.h>
 
 #include "../mm/internal.h"	/* For the trace_print_flags arrays */
 
@@ -2092,6 +2093,87 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+#define btf_modifier_flag(c)	(c == 'c' ? BTF_SHOW_COMPACT :	\
+				 c == 'N' ? BTF_SHOW_NONAME :	\
+				 c == 'x' ? BTF_SHOW_PTR_RAW :	\
+				 c == 'u' ? BTF_SHOW_UNSAFE : \
+				 c == '0' ? BTF_SHOW_ZERO : 0)
+
+static noinline_for_stack
+char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
+		 const char *fmt)
+{
+	struct btf_ptr *bp = (struct btf_ptr *)ptr;
+	u8 btf_kind = BTF_KIND_TYPEDEF;
+	const struct btf_type *t;
+	const struct btf *btf;
+	char *buf_start = buf;
+	const char *btf_type;
+	u64 flags = 0, mod;
+	s32 btf_id;
+
+	if (check_pointer(&buf, end, ptr, spec))
+		return buf;
+
+	if (check_pointer(&buf, end, bp->ptr, spec))
+		return buf;
+
+	while (isalnum(*fmt)) {
+		mod = btf_modifier_flag(*fmt);
+		if (!mod)
+			break;
+		flags |= mod;
+		fmt++;
+	}
+
+	btf = bpf_get_btf_vmlinux();
+	if (IS_ERR_OR_NULL(btf))
+		return ptr_to_id(buf, end, bp->ptr, spec);
+
+	if (bp->type != NULL) {
+		btf_type = bp->type;
+
+		if (strncmp(bp->type, "struct ", strlen("struct ")) == 0) {
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
+			return ptr_to_id(buf, end, bp->ptr, spec);
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
+	} else if (bp->id > 0)
+		btf_id = bp->id;
+	else
+		return ptr_to_id(buf, end, bp->ptr, spec);
+
+	if (btf_id > 0)
+		t = btf_type_by_id(btf, btf_id);
+	if (btf_id <= 0 || !t)
+		return ptr_to_id(buf, end, bp->ptr, spec);
+
+	buf += btf_type_snprintf_show(btf, btf_id, bp->ptr, buf,
+				      end - buf_start, flags);
+
+	return widen_string(buf, buf - buf_start, end, spec);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -2206,6 +2288,20 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
  *           bpf_trace_printk() where [ku] prefix specifies either kernel (k)
  *           or user (u) memory to probe, and:
  *              s a string, equivalent to "%s" on direct vsnprintf() use
+ * - 'T[cNx0]' For printing struct btf_ptr * data using BPF Type Format (BTF).
+ *
+ *			Optional arguments are
+ *			c		compact (no indentation/newlines)
+ *			N		do not print type and member names
+ *			x		do not obfuscate pointers
+ *			u		do not copy data to safe buffer prior
+ *					to display
+ *			0		show 0-valued data
+ *
+ *    BPF_PTR_TYPE(ptr, type) can be used to place pointer and type string
+ *    in the "struct btf_ptr *" expected; for example:
+ *
+ *    printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
  *
  * ** When making changes please also update:
  *	Documentation/core-api/printk-formats.rst
@@ -2297,6 +2393,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		default:
 			return error_string(buf, end, "(einval)", spec);
 		}
+	case 'T':
+		return btf_string(buf, end, ptr, spec, fmt + 1);
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */
-- 
1.8.3.1

