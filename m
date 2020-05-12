Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA961CECA7
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgELF5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:57:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgELF5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:57:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5v2Mg113133;
        Tue, 12 May 2020 05:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=rwzHChZRWZsWlLCx9irESYeGjGjDDjunYm5sfuxAcZA=;
 b=nllyyVbVzbckAmRuTuEimhjh8ScaLTJNMNawwFdnRE0RQN2VLfu4/9Lpr/kzUanrTdNc
 /am+xHBUex6BkKHIKou7ZdfMejDIhNtSjS7sLdCdt7zWxrlPGIif9CNPzDorpTaeZY4a
 mvSa2aTaZxgIAZh+JXvxBC9Cft3uksiG0P73mwQ0nlY7rJD1G1gUreqqh8GGey3Z2e8V
 y8X6CwesshDb++8DH5KbYPVbIrKUxocbm8HxFkmRVKn0Z/6qhU5xsrF2POQXPbRFsIuz
 4QxV5s1oVFSTzXWYQYKrMHQ4PRH+CFvVWNGQ2/GAqu4/49QZ0wIlGbR1Sl/cjyPbzu+v 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30x3mbrv2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 05:57:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5rfbR060465;
        Tue, 12 May 2020 05:57:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30x63p3pe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 05:57:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04C5vGUB018008;
        Tue, 12 May 2020 05:57:16 GMT
Received: from localhost.uk.oracle.com (/10.175.210.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 22:57:16 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     joe@perches.com, linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com,
        yhs@fb.com, kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 4/7] printk: add type-printing %pT format specifier which uses BTF
Date:   Tue, 12 May 2020 06:56:42 +0100
Message-Id: <1589263005-7887-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120052
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
 .head = (unsigned char *)000000006b71155a,
 .data = (unsigned char *)000000006b71155a,
 .truesize = (unsigned int)768,
 .users = (refcount_t){
  .refs = (atomic_t){
   .counter = (int)1,
  },
 },
 .extensions = (struct skb_ext *)00000000f486a130,
}

printk output is truncated at 1024 bytes.  For cases where overflow
is likely, the compact/no type names display modes may be used.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 Documentation/core-api/printk-formats.rst |  15 ++++
 include/linux/btf.h                       |   3 +-
 include/linux/printk.h                    |  16 +++++
 lib/Kconfig                               |  16 +++++
 lib/vsprintf.c                            | 113 ++++++++++++++++++++++++++++++
 5 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 8ebe46b1..5c66097 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -545,6 +545,21 @@ For printing netdev_features_t.
 
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
+ 'x' show raw pointers (no obfuscation)
+ '0' show zero-valued data (it is not shown by default)
+
 Thanks
 ======
 
diff --git a/include/linux/btf.h b/include/linux/btf.h
index d571125..7b585ab 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -169,10 +169,11 @@ static inline const struct btf_member *btf_type_member(const struct btf_type *t)
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
index fcde0772..3c3ea53 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -528,4 +528,20 @@ static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,
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
diff --git a/lib/Kconfig b/lib/Kconfig
index 5d53f96..ac3a513 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -6,6 +6,22 @@
 config BINARY_PRINTF
 	def_bool n
 
+config BTF_PRINTF
+	bool "print type information using BPF type format"
+	depends on DEBUG_INFO_BTF
+	default n
+	help
+	  Print structures, unions etc pointed to by pointer argument using
+	  printk() family of functions (vsnprintf, printk, trace_printk, etc).
+	  For example, we can specify
+	  printk(KERN_INFO, "%pT<struct sk_buff>", skb); to print the skb
+	  data structure content, including all nested type data.
+	  Pointers within data structures displayed are not followed, and
+	  are obfuscated where specified in line with normal pointer display.
+	  via printk.
+
+	  Depends on availability of vmlinux BTF information.
+
 menu "Library routines"
 
 config RAID6_PQ
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7c488a1..f9276f8 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -43,6 +43,7 @@
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
 #endif
+#include <linux/btf.h>
 
 #include "../mm/internal.h"	/* For the trace_print_flags arrays */
 
@@ -2059,6 +2060,103 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+#if IS_ENABLED(CONFIG_BTF_PRINTF)
+#define btf_modifier_flag(c)	(c == 'c' ? BTF_SHOW_COMPACT :	\
+				 c == 'N' ? BTF_SHOW_NONAME :	\
+				 c == 'x' ? BTF_SHOW_PTR_RAW :	\
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
+#else
+static noinline_for_stack
+char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
+	const char *fmt)
+{
+	struct btf_ptr *bp = (struct btf_ptr *)ptr;
+
+	if (check_pointer(&buf, end, ptr, spec))
+		return buf;
+
+	if (check_pointer(&buf, end, bp->ptr, spec))
+		return buf;
+
+	return ptr_to_id(buf, end, bp->ptr, spec);
+}
+#endif /* IS_ENABLED(CONFIG_BTF_PRINTF) */
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -2169,6 +2267,19 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
  *		P node name, including a possible unit address
  * - 'x' For printing the address. Equivalent to "%lx".
  *
+ * - 'T[cNx0]' For printing struct btf_ptr * data using BPF Type Format (BTF).
+ *
+ *			Optional arguments are
+ *			c		compact (no indentation/newlines)
+ *			N		do not print type and member names
+ *			x		do not obfuscate pointers
+ *			0		show 0-valued data
+ *
+ *    BPF_PTR_TYPE(ptr, type) can be used to place pointer and type string
+ *    in the "struct btf_ptr *" expected; for example:
+ *
+ *	printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
+ *
  * ** When making changes please also update:
  *	Documentation/core-api/printk-formats.rst
  *
@@ -2251,6 +2362,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		if (!IS_ERR(ptr))
 			break;
 		return err_ptr(buf, end, ptr, spec);
+	case 'T':
+		return btf_string(buf, end, ptr, spec, fmt + 1);
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */
-- 
1.8.3.1

