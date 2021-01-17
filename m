Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2762F95F0
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbhAQWYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:24:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33114 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbhAQWXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:23:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMKvwv188383;
        Sun, 17 Jan 2021 22:22:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=oefBKqRlbuFOIjFPyxlyMZVmfjGhuaTtOUyoMW0nk7o=;
 b=Q3XoIUHpLEpc18tBf+ouGp6draxT/UjeNuXEOskz0Sv/5TOgi6Uz+aaRuAuAQLILRB93
 ACrJWt+S1ZXOLZKfEUdjBURZpYgPV9EKZnUTiixsp1hwOZjh9n9THj9SCpRczzW70I7o
 MUpOVDKBwH1p7UQL6VnW82mexoxtopiFbFNGvcNtrvELQQ4f2niRS6BdvqV6dyDVnJQF
 9qRw5YYt1oLWtoKvWw9sGXwZmkmsA+LnusH8ue0m4BBQHGhccNaPz8QXbZx839o+GFi6
 DPghoL/uUuCiOIdSAA4G8lBYCyvoRnKo+6f0HBkIrwhvz2smBON+zzrgOp3v+uZt5KEz uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 363xyhj8g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:22:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMBJwm092369;
        Sun, 17 Jan 2021 22:20:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 364a2u5yur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:20:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10HMKcqr014928;
        Sun, 17 Jan 2021 22:20:39 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Jan 2021 14:20:38 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 3/4] libbpf: BTF dumper support for typed data
Date:   Sun, 17 Jan 2021 22:16:03 +0000
Message-Id: <1610921764-7526-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a BTF dumper for typed data, so that the user can dump a typed
version of the data provided.

The API is

int btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
                             const struct btf_dump_emit_type_data_opts *opts,
                             void *data);

...where the id is the BTF id of the data pointed to by the "void *"
argument; for example the BTF id of "struct sk_buff" for a
"struct skb *" data pointer.  Options supported are

 - a starting indent level (indent_lvl)
 - a set of boolean options to control dump display, similar to those
   used for BPF helper bpf_snprintf_btf().  Options are
        - compact : omit newlines and other indentation
        - noname: omit member names
        - zero: show zero-value members

Default output format is identical to that dumped by bpf_snprintf_btf(),
for example a "struct sk_buff" representation would look like this:

struct sk_buff){
 (union){
  (struct){
   .next = (struct sk_buff *)0xffffffffffffffff,
   .prev = (struct sk_buff *)0xffffffffffffffff,
   (union){
    .dev = (struct net_device *)0xffffffffffffffff,
    .dev_scratch = (long unsigned int)18446744073709551615,
   },
  },
...

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf.h      |  17 +
 tools/lib/bpf/btf_dump.c | 974 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map |   5 +
 3 files changed, 996 insertions(+)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 0c48f2e..7937124 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -180,6 +180,23 @@ struct btf_dump_emit_type_decl_opts {
 btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 			 const struct btf_dump_emit_type_decl_opts *opts);
 
+
+struct btf_dump_emit_type_data_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	int indent_level;
+	/* below match "show" flags for bpf_show_snprintf() */
+	bool compact;
+	bool noname;
+	bool zero;
+};
+#define btf_dump_emit_type_data_opts__last_field zero
+
+LIBBPF_API int
+btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
+			 const struct btf_dump_emit_type_data_opts *opts,
+			 void *data);
+
 /*
  * A set of helpers for easier BTF types handling
  */
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 2f9d685..04d604f 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -10,6 +10,8 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <string.h>
+#include <ctype.h>
+#include <endian.h>
 #include <errno.h>
 #include <linux/err.h>
 #include <linux/btf.h>
@@ -19,14 +21,31 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 
+#define BITS_PER_BYTE			8
+#define BITS_PER_U128			(sizeof(__u64) * BITS_PER_BYTE * 2)
+#define BITS_PER_BYTE_MASK		(BITS_PER_BYTE - 1)
+#define BITS_PER_BYTE_MASKED(bits)	((bits) & BITS_PER_BYTE_MASK)
+#define BITS_ROUNDDOWN_BYTES(bits)	((bits) >> 3)
+#define BITS_ROUNDUP_BYTES(bits) \
+	(BITS_ROUNDDOWN_BYTES(bits) + !!BITS_PER_BYTE_MASKED(bits))
+
 static const char PREFIXES[] = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
 static const size_t PREFIX_CNT = sizeof(PREFIXES) - 1;
 
+
 static const char *pfx(int lvl)
 {
 	return lvl >= PREFIX_CNT ? PREFIXES : &PREFIXES[PREFIX_CNT - lvl];
 }
 
+static const char SPREFIXES[] = "                         ";
+static const size_t SPREFIX_CNT = sizeof(SPREFIXES) - 1;
+
+static const char *spfx(int lvl)
+{
+	return lvl >= SPREFIX_CNT ? SPREFIXES : &SPREFIXES[SPREFIX_CNT - lvl];
+}
+
 enum btf_dump_type_order_state {
 	NOT_ORDERED,
 	ORDERING,
@@ -53,6 +72,49 @@ struct btf_dump_type_aux_state {
 	__u8 referenced: 1;
 };
 
+#define BTF_DUMP_DATA_MAX_NAME_LEN	256
+
+/*
+ * Common internal data for BTF type data dump operations.
+ *
+ * The implementation here is similar to that in kernel/bpf/btf.c
+ * that supports the bpf_snprintf_btf() helper, so any bugs in
+ * type data dumping here are likely in that code also.
+ *
+ * One challenge with showing nested data is we want to skip 0-valued
+ * data, but in order to figure out whether a nested object is all zeros
+ * we need to walk through it.  As a result, we need to make two passes
+ * when handling structs, unions and arrays; the first path simply looks
+ * for nonzero data, while the second actually does the display.  The first
+ * pass is signalled by state.depth_check being set, and if we
+ * encounter a non-zero value we set state.depth_to_show to the depth
+ * at which we encountered it.  When we have completed the first pass,
+ * we will know if anything needs to be displayed if
+ * state.depth_to_show > state.depth.  See btf_dump_emit_[struct,array]_data()
+ * for the implementation of this.
+ *
+ */
+struct btf_dump_data {
+	bool compact;
+	bool noname;
+	bool zero;
+	__u8 indent_lvl;	/* base indent level */
+	/* below are used during iteration */
+	struct {
+		__u8 depth;
+		__u8 depth_to_show;
+		__u8 depth_check;
+		__u8 array_member:1,
+		     array_terminated:1;
+		__u16 array_encoding;
+		__u32 type_id;
+		const struct btf_type *type;
+		const struct btf_member *member;
+		char name[BTF_DUMP_DATA_MAX_NAME_LEN];
+		int err;
+	} state;
+};
+
 struct btf_dump {
 	const struct btf *btf;
 	const struct btf_ext *btf_ext;
@@ -89,6 +151,10 @@ struct btf_dump {
 	 * name occurrences
 	 */
 	struct hashmap *ident_names;
+	/*
+	 * data for typed display.
+	 */
+	struct btf_dump_data data;
 };
 
 static size_t str_hash_fn(const void *key, void *ctx)
@@ -1438,3 +1504,911 @@ static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id)
 {
 	return btf_dump_resolve_name(d, id, d->ident_names);
 }
+
+static void __btf_dump_emit_type_data(struct btf_dump *d,
+				      const struct btf_type *t,
+				      __u32 id,
+				      void *data,
+				      __u8 bits_offset);
+
+static const struct btf_type *skip_mods(const struct btf *btf,
+					__u32 id, __u32 *res_id)
+{
+	const struct btf_type *t = btf__type_by_id(btf, id);
+
+	while (btf_is_mod(t)) {
+		id = t->type;
+		t = btf__type_by_id(btf, t->type);
+	}
+
+	if (res_id)
+		*res_id = id;
+
+	return t;
+}
+
+#define BTF_MAX_ITER		10
+#define BTF_KIND_BIT(kind)	(1ULL << kind)
+
+/*
+ * Populate dump->data.state.name with type name information.
+ * Format of type name is
+ *
+ *	[.member_name = ] (type_name)
+ */
+static const char *btf_dump_data_name(struct btf_dump *d)
+{
+	/* BTF_MAX_ITER array suffixes "[]" */
+	const char *array_suffixes = "[][][][][][][][][][]";
+	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
+	/* BTF_MAX_ITER pointer suffixes "*" */
+	const char *ptr_suffixes = "**********";
+	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
+	const char *name = NULL, *prefix = "", *parens = "";
+	const struct btf_member *m = d->data.state.member;
+	const struct btf_type *t = d->data.state.type;
+	const struct btf_array *array;
+	__u32 id = d->data.state.type_id;
+	const char *member = NULL;
+	bool show_member = false;
+	__u64 kinds = 0;
+	int i;
+
+	d->data.state.name[0] = '\0';
+
+	/*
+	 * Don't show type name if we're showing an array member;
+	 * in that case we show the array type so don't need to repeat
+	 * ourselves for each member.
+	 */
+	if (d->data.state.array_member)
+		return "";
+
+	/* Retrieve member name, if any. */
+	if (m) {
+		member = btf_name_of(d, m->name_off);
+		show_member = strlen(member) > 0;
+		id = m->type;
+	}
+
+	/*
+	 * Start with type_id, as we have resolved the struct btf_type *
+	 * via btf_dump_emit_modifier_data() past the parent typedef to the
+	 * child struct, int etc it is defined as.  In such cases, the type_id
+	 * still represents the starting type while the struct btf_type *
+	 * in our d->data.state points at the resolved type of the typedef.
+	 */
+	t = btf__type_by_id(d->btf, id);
+	if (!t)
+		return "";
+
+       /*
+	* The goal here is to build up the right number of pointer and
+	* array suffixes while ensuring the type name for a typedef
+	* is represented.  Along the way we accumulate a list of
+	* BTF kinds we have encountered, since these will inform later
+	* display; for example, pointer types will not require an
+	* opening "{" for struct, we will just display the pointer value.
+	*
+	* We also want to accumulate the right number of pointer or array
+	* indices in the format string while iterating until we get to
+	* the typedef/pointee/array member target type.
+	*
+	* We start by pointing at the end of pointer and array suffix
+	* strings; as we accumulate pointers and arrays we move the pointer
+	* or array string backwards so it will show the expected number of
+	* '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
+	* and/or arrays and typedefs are supported as a precaution.
+	*
+	* We also want to get typedef name while proceeding to resolve
+	* type it points to so that we can add parentheses if it is a
+	* "typedef struct" etc.
+	*
+	* Qualifiers ("const", "volatile", "restrict") are simply skipped
+	* as they complicate simple type name display without adding much
+	* in the case of displaying a cast in front of the data to be
+	* displayed.
+	*/
+	for (i = 0; i < BTF_MAX_ITER; i++) {
+
+		switch (BTF_INFO_KIND(t->info)) {
+		case BTF_KIND_TYPEDEF:
+			if (!name)
+				name = btf_name_of(d, t->name_off);
+			kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
+			id = t->type;
+			break;
+		case BTF_KIND_ARRAY:
+			kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
+			parens = "[";
+			if (!t)
+				return "";
+			array = btf_array(t);
+			if (array_suffix > array_suffixes)
+				array_suffix -= 2;
+			id = array->type;
+			break;
+		case BTF_KIND_PTR:
+			kinds |= BTF_KIND_BIT(BTF_KIND_PTR);
+			if (ptr_suffix > ptr_suffixes)
+				ptr_suffix -= 1;
+			id = t->type;
+			break;
+		default:
+			id = 0;
+			break;
+		}
+		if (!id)
+			break;
+		t = skip_mods(d->btf, id, NULL);
+	}
+	/* We may not be able to represent this type; bail to be safe */
+	if (i == BTF_MAX_ITER) {
+		pr_warn("iters %d exceeded %d when displaying type name:[%u]\n",
+			i, BTF_MAX_ITER, id);
+		return "";
+	}
+
+	if (!name)
+		name = btf_name_of(d, t->name_off);
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
+						   "struct" : "union";
+		/* if it's an array of struct/union, parens is already set */
+		if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
+			parens = "{";
+		break;
+	case BTF_KIND_ENUM:
+		prefix = "enum";
+		break;
+	default:
+		break;
+	}
+
+	/* pointer does not require parens */
+	if (kinds & BTF_KIND_BIT(BTF_KIND_PTR))
+		parens = "";
+	/* typedef does not require struct/union/enum prefix */
+	if (kinds & BTF_KIND_BIT(BTF_KIND_TYPEDEF))
+		prefix = "";
+
+	if (!name)
+		name = "";
+
+	/* Even if we don't want type name info, we want parentheses etc */
+	if (d->data.noname)
+		snprintf(d->data.state.name, sizeof(d->data.state.name), "%s",
+			 parens);
+	else
+		snprintf(d->data.state.name, sizeof(d->data.state.name),
+			 "%s%s%s(%s%s%s%s%s%s)%s",
+			 /* first 3 strings comprise ".member = " */
+			 show_member ? "." : "",
+			 show_member ? member : "",
+			 show_member ? " = " : "",
+			 /* ...next is our prefix (struct, enum, etc) */
+			 prefix,
+			 strlen(prefix) > 0 && strlen(name) > 0 ? " " : "",
+			 /* ...this is the type name itself */
+			 name,
+			 /* ...suffixed by the appropriate '*', '[]' suffixes */
+			 strlen(name) > 0 && strlen(ptr_suffix) > 0 ? " " : "",
+			 ptr_suffix,
+			 array_suffix, parens);
+
+	return d->data.state.name;
+}
+
+static const char *btf_dump_data_indent(struct btf_dump *d)
+{
+	if (d->data.compact)
+		return "";
+	return spfx(d->data.indent_lvl + d->data.state.depth);
+}
+
+static const char *btf_dump_data_newline(struct btf_dump *d)
+{
+	return d->data.compact ? "" : "\n";
+}
+
+static const char *btf_dump_data_delim(struct btf_dump *d)
+{
+	if (d->data.state.depth == 0)
+		return "";
+
+	if (d->data.compact &&
+	    d->data.state.type &&
+	    BTF_INFO_KIND(d->data.state.type->info) == BTF_KIND_UNION)
+		return "|";
+
+	return ",";
+}
+
+static void btf_dump_data_printf(struct btf_dump *d,
+				 const char *fmt, ...)
+{
+	va_list args;
+
+	/*
+	 * Just checking if there is non-zero data to display at this depth,
+	 * so nothing is displayed.
+	 */
+	if (d->data.state.depth_check)
+		return;
+	va_start(args, fmt);
+	d->printf_fn(d->opts.ctx, fmt, args);
+	va_end(args);
+}
+
+/* Macros are used here as btf_type_value[s]() prepends and appends
+ * format specifiers to the format specifier passed in; these do the work of
+ * adding indentation, delimiters etc while the caller simply has to specify
+ * the type value(s) in the format specifier + value(s).
+ */
+#define btf_dump_emit_type_value(d, fmt, value)				     \
+	do {								     \
+		if ((value) != 0 || d->data.zero ||			     \
+		    d->data.state.depth == 0) {				     \
+			btf_dump_data_printf(d, "%s%s" fmt "%s%s",	     \
+					     btf_dump_data_indent(d),	     \
+					     btf_dump_data_name(d),          \
+					     value,			     \
+					     btf_dump_data_delim(d),	     \
+					     btf_dump_data_newline(d));      \
+			if (d->data.state.depth >			     \
+			    d->data.state.depth_to_show)		     \
+				d->data.state.depth_to_show =		     \
+					d->data.state.depth;		     \
+		}							     \
+	} while (0)
+
+#define btf_dump_emit_type_values(d, fmt, ...)				\
+	do {								\
+		btf_dump_data_printf(d, "%s%s" fmt "%s%s",		\
+				     btf_dump_data_indent(d),		\
+				     btf_dump_data_name(d),		\
+				     __VA_ARGS__,			\
+				     btf_dump_data_delim(d),		\
+				     btf_dump_data_newline(d));		\
+		if (d->data.state.depth >				\
+		    d->data.state.depth_to_show)			\
+			d->data.state.depth_to_show =			\
+				d->data.state.depth;			\
+	} while (0)
+
+/* Set the type we are starting to show. */
+static void btf_dump_start_type(struct btf_dump *d,
+				const struct btf_type *t,
+				__u32 type_id)
+{
+	d->data.state.type = t;
+	d->data.state.type_id = type_id;
+	d->data.state.name[0] = '\0';
+}
+
+static void btf_dump_end_type(struct btf_dump *d)
+{
+	d->data.state.type = NULL;
+	d->data.state.type_id = 0;
+	d->data.state.name[0] = '\0';
+}
+
+static void btf_dump_start_aggr_type(struct btf_dump *d,
+				     const struct btf_type *t,
+				     __u32 type_id)
+{
+	btf_dump_start_type(d, t, type_id);
+
+	btf_dump_data_printf(d, "%s%s%s",
+			     btf_dump_data_indent(d),
+			     btf_dump_data_name(d),
+			     btf_dump_data_newline(d));
+	d->data.state.depth++;
+}
+
+static void btf_dump_end_aggr_type(struct btf_dump *d,
+				   const char *suffix)
+{
+	d->data.state.depth--;
+	btf_dump_data_printf(d, "%s%s%s%s",
+			     btf_dump_data_indent(d),
+			     suffix,
+			     btf_dump_data_delim(d),
+			     btf_dump_data_newline(d));
+	btf_dump_end_type(d);
+}
+
+static void btf_dump_start_member(struct btf_dump *d,
+				  const struct btf_member *m)
+{
+	d->data.state.member = m;
+}
+
+static void btf_dump_start_array_member(struct btf_dump *d)
+{
+	d->data.state.array_member = 1;
+	btf_dump_start_member(d, NULL);
+}
+
+static void btf_dump_end_member(struct btf_dump *d)
+{
+	d->data.state.member = NULL;
+}
+
+static void btf_dump_end_array_member(struct btf_dump *d)
+{
+	d->data.state.array_member = 0;
+	btf_dump_end_member(d);
+}
+
+static void btf_dump_start_array_type(struct btf_dump *d,
+				      const struct btf_type *t,
+				      __u32 type_id,
+				      __u16 array_encoding)
+{
+	d->data.state.array_encoding = array_encoding;
+	d->data.state.array_terminated = 0;
+	btf_dump_start_aggr_type(d, t, type_id);
+}
+
+static void btf_dump_end_array_type(struct btf_dump *d)
+{
+	d->data.state.array_encoding = 0;
+	d->data.state.array_terminated = 0;
+	btf_dump_end_aggr_type(d, "]");
+}
+
+static void btf_dump_start_struct_type(struct btf_dump *d,
+				       const struct btf_type *t,
+				       __u32 type_id)
+{
+	btf_dump_start_aggr_type(d, t, type_id);
+}
+
+static void btf_dump_end_struct_type(struct btf_dump *d)
+{
+	btf_dump_end_aggr_type(d, "}");
+}
+
+static void btf_dump_emit_df_data(struct btf_dump *d,
+				  const struct btf_type *t,
+				  __u32 id,
+				  void *data,
+				  __u8 bits_offset)
+{
+	btf_dump_data_printf(d, "<unsupported kind:%u>",
+			     BTF_INFO_KIND(t->info));
+}
+
+static void btf_dump_emit_int128(struct btf_dump *d, void *data)
+{
+	/* data points to a __int128 number.
+	 * Suppose
+	 *	int128_num = *(__int128 *)data;
+	 * The below formulas shows what upper_num and lower_num represents:
+	 *     upper_num = int128_num >> 64;
+	 *     lower_num = int128_num & 0xffffffffFFFFFFFFULL;
+	 */
+	__u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = *(__u64 *)data;
+	lower_num = *(__u64 *)(data + 8);
+#else
+	upper_num = *(__u64 *)(data + 8);
+	lower_num = *(__u64 *)data;
+#endif
+	if (upper_num == 0)
+		btf_dump_emit_type_value(d, "0x%llx", lower_num);
+	else
+		btf_dump_emit_type_values(d, "0x%llx%016llx", upper_num,
+					  lower_num);
+}
+
+static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
+			     __u16 right_shift_bits)
+{
+	__u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = print_num[0];
+	lower_num = print_num[1];
+#else
+	upper_num = print_num[1];
+	lower_num = print_num[0];
+#endif
+
+	/* shake out un-needed bits by shift/or operations */
+	if (left_shift_bits >= 64) {
+		upper_num = lower_num << (left_shift_bits - 64);
+		lower_num = 0;
+	} else {
+		upper_num = (upper_num << left_shift_bits) |
+			    (lower_num >> (64 - left_shift_bits));
+		lower_num = lower_num << left_shift_bits;
+	}
+
+	if (right_shift_bits >= 64) {
+		lower_num = upper_num >> (right_shift_bits - 64);
+		upper_num = 0;
+	} else {
+		lower_num = (lower_num >> right_shift_bits) |
+			    (upper_num << (64 - right_shift_bits));
+		upper_num = upper_num >> right_shift_bits;
+	}
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	print_num[0] = upper_num;
+	print_num[1] = lower_num;
+#else
+	print_num[0] = lower_num;
+	print_num[1] = upper_num;
+#endif
+}
+
+static void btf_dump_emit_bitfield_data(struct btf_dump *d,
+					void *data,
+					__u8 bits_offset,
+					__u8 nr_bits)
+{
+	__u16 left_shift_bits, right_shift_bits;
+	__u8 nr_copy_bytes;
+	__u8 nr_copy_bits;
+	__u64 print_num[2] = {};
+
+	nr_copy_bits = nr_bits + bits_offset;
+	nr_copy_bytes = BITS_ROUNDUP_BYTES(nr_copy_bits);
+
+	memcpy(print_num, data, nr_copy_bytes);
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	left_shift_bits = bits_offset;
+#else
+	left_shift_bits = BITS_PER_U128 - nr_copy_bits;
+#endif
+	right_shift_bits = BITS_PER_U128 - nr_bits;
+
+	btf_int128_shift(print_num, left_shift_bits, right_shift_bits);
+	btf_dump_emit_int128(d, print_num);
+}
+
+static void btf_dump_emit_int_bits(struct btf_dump *d,
+				   const struct btf_type *t,
+				   void *data,
+				   __u8 bits_offset)
+{
+	__u32 int_data = btf_int(t);
+	__u8 nr_bits = BTF_INT_BITS(int_data);
+	__u8 total_bits_offset;
+
+	/*
+	 * bits_offset is at most 7.
+	 * BTF_INT_OFFSET() cannot exceed 128 bits.
+	 */
+	total_bits_offset = bits_offset + BTF_INT_OFFSET(int_data);
+	data += BITS_ROUNDDOWN_BYTES(total_bits_offset);
+	bits_offset = BITS_PER_BYTE_MASKED(total_bits_offset);
+	btf_dump_emit_bitfield_data(d, data, bits_offset, nr_bits);
+}
+
+static void btf_dump_emit_int_data(struct btf_dump *d,
+				   const struct btf_type *t,
+				   __u32 type_id,
+				   void *data,
+				   __u8 bits_offset)
+{
+	__u32 int_data = btf_int(t);
+	__u8 encoding = BTF_INT_ENCODING(int_data);
+	bool sign = encoding & BTF_INT_SIGNED;
+	__u8 nr_bits = BTF_INT_BITS(int_data);
+
+	btf_dump_start_type(d, t, type_id);
+
+	if (bits_offset || BTF_INT_OFFSET(int_data) ||
+	    BITS_PER_BYTE_MASKED(nr_bits)) {
+		btf_dump_emit_int_bits(d, t, data, bits_offset);
+		goto out;
+	}
+
+	switch (nr_bits) {
+	case 128:
+		btf_dump_emit_int128(d, data);
+		break;
+	case 64:
+		if (sign)
+			btf_dump_emit_type_value(d, "%lld", *(__s64 *)data);
+		else
+			btf_dump_emit_type_value(d, "%llu", *(__u64 *)data);
+		break;
+	case 32:
+		if (sign)
+			btf_dump_emit_type_value(d, "%d", *(__s32 *)data);
+		else
+			btf_dump_emit_type_value(d, "%u", *(__u32 *)data);
+		break;
+	case 16:
+		if (sign)
+			btf_dump_emit_type_value(d, "%d", *(__s16 *)data);
+		else
+			btf_dump_emit_type_value(d, "%u", *(__u16 *)data);
+		break;
+	case 8:
+		if (d->data.state.array_encoding == BTF_INT_CHAR) {
+			/* check for null terminator */
+			if (d->data.state.array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				d->data.state.array_terminated = 1;
+				break;
+			}
+			if (isprint(*(char *)data)) {
+				btf_dump_emit_type_value(d, "'%c'",
+							 *(char *)data);
+				break;
+			}
+		}
+		if (sign)
+			btf_dump_emit_type_value(d, "%d", *(__s8 *)data);
+		else
+			btf_dump_emit_type_value(d, "%u", *(__u8 *)data);
+		break;
+	default:
+		btf_dump_emit_int_bits(d, t, data, bits_offset);
+		break;
+	}
+out:
+	btf_dump_end_type(d);
+}
+
+static void btf_dump_emit_modifier_data(struct btf_dump *d,
+					const struct btf_type *t,
+					__u32 id,
+					void *data,
+					__u8 bits_offset)
+{
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+	__btf_dump_emit_type_data(d, t, id, data, bits_offset);
+}
+
+static void btf_dump_emit_var_data(struct btf_dump *d,
+				   const struct btf_type *t,
+				   __u32 id,
+				   void *data,
+				   __u8 bits_offset)
+{
+	__u32 linkage = btf_var(t)->linkage;
+
+	btf_dump_data_printf(d, "%s%s =",
+			     linkage ? "" : "static ",
+			     btf_name_of(d, t->name_off));
+	t = btf__type_by_id(d->btf, t->type);
+	__btf_dump_emit_type_data(d, t, t->type, data, bits_offset);
+}
+
+static void __btf_dump_emit_array_data(struct btf_dump *d,
+				       const struct btf_type *t,
+				       __u32 id,
+				       void *data,
+				       __u8 bits_offset)
+{
+	const struct btf_array *array = btf_array(t);
+	const struct btf_type *elem_type;
+	__u32 i, elem_size = 0, elem_type_id;
+	__u16 encoding = 0;
+
+	elem_type_id = array->type;
+	elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
+	if (elem_type && btf_has_size(elem_type))
+		elem_size = elem_type->size;
+
+	if (elem_type && btf_is_int(elem_type)) {
+		__u32 int_type = btf_int(elem_type);
+
+		encoding = BTF_INT_ENCODING(int_type);
+
+		/*
+		 * BTF_INT_CHAR encoding never seems to be set for
+		 * char arrays, so if size is 1 and element is
+		 * printable as a char, we'll do that.
+		 */
+		if (elem_size == 1)
+			encoding = BTF_INT_CHAR;
+	}
+
+	btf_dump_start_array_type(d, t, id, encoding);
+
+	if (!elem_type)
+		goto out;
+
+	for (i = 0; i < array->nelems; i++) {
+
+		btf_dump_start_array_member(d);
+
+		__btf_dump_emit_type_data(d, elem_type, elem_type_id,
+					  data, bits_offset);
+		data += elem_size;
+
+		btf_dump_end_array_member(d);
+
+		if (d->data.state.array_terminated)
+			break;
+	}
+out:
+	btf_dump_end_array_type(d);
+}
+
+static void btf_dump_emit_array_data(struct btf_dump *d,
+				     const struct btf_type *t,
+				     __u32 id,
+				     void *data,
+				     __u8 bits_offset)
+{
+	const struct btf_member *m = d->data.state.member;
+
+	/*
+	 * First check if any members would be shown (are non-zero).
+	 * See comments above "struct btf_dump_data" definition for more
+	 * details on how this works at a high-level.
+	 */
+	if (d->data.state.depth > 0 && !d->data.zero) {
+		if (!d->data.state.depth_check) {
+			d->data.state.depth_check = d->data.state.depth + 1;
+			d->data.state.depth_to_show = 0;
+		}
+		__btf_dump_emit_array_data(d, t, id, data, bits_offset);
+		d->data.state.member = m;
+
+		if (d->data.state.depth_check != d->data.state.depth + 1)
+			return;
+		d->data.state.depth_check = 0;
+
+		if (d->data.state.depth_to_show <= d->data.state.depth)
+			return;
+		/*
+		 * Reaching here indicates we have recursed and found
+		 * non-zero array member(s).
+		 */
+	}
+	__btf_dump_emit_array_data(d, t, id, data, bits_offset);
+}
+
+#define for_each_member(i, struct_type, member)			\
+	for (i = 0, member = btf_members(struct_type);		\
+	     i < btf_vlen(struct_type);				\
+	     i++, member++)
+
+static void __btf_dump_emit_struct_data(struct btf_dump *d,
+					const struct btf_type *t,
+					__u32 id,
+					void *data,
+					__u8 bits_offset)
+{
+	const struct btf_member *member;
+	__u32 i;
+
+	btf_dump_start_struct_type(d, t, id);
+
+	for_each_member(i, t, member) {
+		const struct btf_type *member_type;
+		__u32 member_offset, bitfield_size;
+		__u32 bytes_offset;
+		__u8 bits8_offset;
+
+		member_type = btf__type_by_id(d->btf, member->type);
+		btf_dump_start_member(d, member);
+
+		member_offset = btf_member_bit_offset(t, i);
+		bitfield_size = btf_member_bitfield_size(t, i);
+		bytes_offset = BITS_ROUNDDOWN_BYTES(member_offset);
+		bits8_offset = BITS_PER_BYTE_MASKED(member_offset);
+		if (bitfield_size) {
+			btf_dump_start_type(d, member_type, member->type);
+			btf_dump_emit_bitfield_data(d,
+						    data + bytes_offset,
+						    bits8_offset,
+						    bitfield_size);
+			btf_dump_end_type(d);
+		} else {
+			__btf_dump_emit_type_data(d, member_type, member->type,
+					     data + bytes_offset, bits8_offset);
+		}
+		btf_dump_end_member(d);
+	}
+	btf_dump_end_struct_type(d);
+}
+
+static void btf_dump_emit_struct_data(struct btf_dump *d,
+				      const struct btf_type *t,
+				      __u32 id,
+				      void *data,
+				      __u8 bits_offset)
+{
+	const struct btf_member *m = d->data.state.member;
+
+	/*
+	 * First check if any members would be shown (are non-zero).
+	 * See comments above "struct btf_dump_data" definition for more
+	 * details on how this works at a high-level.
+	 */
+	if (d->data.state.depth > 0 && !d->data.zero) {
+		if (!d->data.state.depth_check) {
+			d->data.state.depth_check = d->data.state.depth + 1;
+			d->data.state.depth_to_show = 0;
+		}
+		__btf_dump_emit_struct_data(d, t, id, data, bits_offset);
+		/* Restore saved member data here */
+		d->data.state.member = m;
+		if (d->data.state.depth_check != d->data.state.depth + 1)
+			return;
+		d->data.state.depth_check = 0;
+
+		if (d->data.state.depth_to_show <= d->data.state.depth)
+			return;
+		/*
+		 * Reaching here indicates we have recursed and found
+		 * non-zero child values.
+		 */
+	}
+
+	__btf_dump_emit_struct_data(d, t, id, data, bits_offset);
+}
+
+static void btf_dump_emit_ptr_data(struct btf_dump *d,
+				   const struct btf_type *t,
+				   __u32 id,
+				   void *data,
+				   __u8 bits_offset)
+{
+	btf_dump_start_type(d, t, id);
+
+	btf_dump_emit_type_value(d, "%p", *(void **)data);
+	btf_dump_end_type(d);
+}
+
+static void btf_dump_emit_enum_data(struct btf_dump *d,
+				    const struct btf_type *t,
+				    __u32 id,
+				    void *data,
+				    __u8 bits_offset)
+{
+	const struct btf_enum *enums = btf_enum(t);
+	__s64 value;
+	__u16 i;
+
+	btf_dump_start_type(d, t, id);
+
+	switch (t->size) {
+	case 8:
+		value = *(__s64 *)data;
+		break;
+	case 4:
+		value = *(__s32 *)data;
+		break;
+	case 2:
+		value = *(__s16 *)data;
+		break;
+	case 1:
+		value = *(__s8 *)data;
+		break;
+	default:
+		pr_warn("unexpected size %d for enum, id:[%u]\n", t->size,
+			id);
+		d->data.state.err = -EINVAL;
+		return;
+	}
+
+	for (i = 0; i < btf_vlen(t); i++) {
+		if (value == enums[i].val) {
+			btf_dump_emit_type_value(d, "%s",
+						 btf_name_of(d,
+							     enums[i].name_off));
+			btf_dump_end_type(d);
+			return;
+		}
+	}
+
+	btf_dump_emit_type_value(d, "%d", value);
+	btf_dump_end_type(d);
+}
+
+#define for_each_vsi(i, struct_type, member)			\
+	for (i = 0, member = btf_var_secinfos(struct_type);	\
+	     i < btf_vlen(struct_type);				\
+	     i++, member++)
+
+static void btf_dump_emit_datasec_data(struct btf_dump *d,
+				       const struct btf_type *t,
+				       __u32 id,
+				       void *data,
+				       __u8 bits_offset)
+{
+	const struct btf_var_secinfo *vsi;
+	const struct btf_type *var;
+	__u32 i;
+
+	btf_dump_start_type(d, t, id);
+
+	btf_dump_emit_type_value(d, "section (\"%s\") = {",
+				 btf_name_of(d, t->name_off));
+	for_each_vsi(i, t, vsi) {
+		var = btf__type_by_id(d->btf, vsi->type);
+		if (i)
+			btf_dump_data_printf(d, ",");
+		__btf_dump_emit_type_data(d, var, vsi->type,
+					  data + vsi->offset,
+					  bits_offset);
+	}
+	btf_dump_end_type(d);
+}
+
+typedef void (*btf_dump_emit_kind_data)(struct btf_dump *d,
+					const struct btf_type *t,
+					__u32 id,
+					void *data,
+					__u8 bits_offset);
+
+static btf_dump_emit_kind_data dump_emit_kind_data[NR_BTF_KINDS] = {
+	&btf_dump_emit_df_data,
+	&btf_dump_emit_int_data,
+	&btf_dump_emit_ptr_data,
+	&btf_dump_emit_array_data,
+	&btf_dump_emit_struct_data,
+	&btf_dump_emit_struct_data,
+	&btf_dump_emit_enum_data,
+	&btf_dump_emit_df_data,
+	&btf_dump_emit_modifier_data,
+	&btf_dump_emit_modifier_data,
+	&btf_dump_emit_modifier_data,
+	&btf_dump_emit_modifier_data,
+	&btf_dump_emit_df_data,
+	&btf_dump_emit_df_data,
+	&btf_dump_emit_var_data,
+	&btf_dump_emit_datasec_data,
+};
+
+static void __btf_dump_emit_type_data(struct btf_dump *d,
+				      const struct btf_type *t,
+				      __u32 id,
+				      void *data,
+				      __u8 bits_offset)
+{
+	dump_emit_kind_data[BTF_INFO_KIND(t->info)](d, t, id, data,
+						    bits_offset);
+}
+
+static void btf_dump_emit_type_data(struct btf_dump *d, __u32 id, void *data)
+{
+	const struct btf_type *t = btf__type_by_id(d->btf, id);
+
+	memset(&d->data.state, 0, sizeof(d->data.state));
+
+	if (!t) {
+		pr_warn("no type info, id [%u]\n", id);
+		d->data.state.err = -EINVAL;
+		return;
+	}
+
+	__btf_dump_emit_type_data(d, t, id, data, 0);
+}
+
+int btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
+			     const struct btf_dump_emit_type_data_opts *opts,
+			     void *data)
+{
+	int err;
+
+	if (!OPTS_VALID(opts, btf_dump_emit_type_data_opts))
+		return -EINVAL;
+
+	d->data.indent_lvl = OPTS_GET(opts, indent_level, 0);
+	d->data.compact = OPTS_GET(opts, compact, false);
+	d->data.noname = OPTS_GET(opts, noname, false);
+	d->data.zero = OPTS_GET(opts, zero, false);
+	btf_dump_emit_type_data(d, id, data);
+	err = d->data.state.err;
+	memset(&d->data, 0, sizeof(d->data));
+	return err;
+}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 1c0fd2d..b81c069 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -350,3 +350,8 @@ LIBBPF_0.3.0 {
 		xsk_setup_xdp_prog;
 		xsk_socket__update_xskmap;
 } LIBBPF_0.2.0;
+
+LIBBPF_0.4.0 {
+	global:
+		btf_dump__emit_type_data;
+} LIBBPF_0.3.0;
-- 
1.8.3.1

