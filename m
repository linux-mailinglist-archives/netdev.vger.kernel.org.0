Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633BC1CECB6
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgELF7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:59:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39664 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgELF7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:59:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5v3fq113246;
        Tue, 12 May 2020 05:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=DMhSaCGReUmWpbKbsku8OFU0N82h3DvrcVPxMEW9AtE=;
 b=jHS8LOHedHvaISBKRSeqAv92yWNfDwtAhy39F1qDSaD1eh6y+i6oA5ReVxXKReG3WJBY
 soOmT5M2T/PbRkNsxV5AG4w5RZ4ozKAIGJpaBPLXACKVOguiLIKwQQIV4O+ni8wb2hwo
 pymhYZZKmZtPsiT1EeMeeXO6l0m8ZelZ1mEK/W/wg8D53RajoxL7rmHHhYJNjIYXG0kE
 CqbgW/xj/xCZiyxrd1s5eXAoZ5XKJ+f45RjPqHEDJpTZ1XQJxvil8BZg0h7qi8qm6X+z
 gKEt/mWP+40+Q+6PyUaWtwSp1cgjue8QfgS2T0HgCtSyi/HJkahlcq5UvwmsyRxHTUc9 dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30x3mbrv9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 05:59:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5seoq191785;
        Tue, 12 May 2020 05:57:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30xbgh7tjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 05:57:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C5v9iu013752;
        Tue, 12 May 2020 05:57:09 GMT
Received: from localhost.uk.oracle.com (/10.175.210.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 22:57:09 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     joe@perches.com, linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com,
        yhs@fb.com, kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 2/7] bpf: move to generic BTF show support, apply it to seq files/strings
Date:   Tue, 12 May 2020 06:56:40 +0100
Message-Id: <1589263005-7887-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120052
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

generalize the "seq_show" seq file support in btf.c to support
a generic show callback of which we support two instances; the
current seq file show, and a show with snprintf() behaviour which
instead writes the type data to a supplied string.

Both classes of show function call btf_type_show() with different
targets; the seq file or the string to be written.  In the string
case we need to track additional data - length left in string to write
and length to return that we would have written (a la snprintf).

By default show will display type information, field members and
their types and values etc, and the information is indented
based upon structure depth.

Show however supports flags which modify its behaviour:

BTF_SHOW_COMPACT - suppress newline/indent.
BTF_SHOW_NONAME - suppress show of type and member names.
BTF_SHOW_PTR_RAW - do not obfuscate pointer values.
BTF_SHOW_ZERO - show zeroed values (by default they are not shown).

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h |  33 +++
 kernel/bpf/btf.c    | 759 +++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 690 insertions(+), 102 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 5c1ea99..d571125 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -13,6 +13,7 @@
 struct btf_member;
 struct btf_type;
 union bpf_attr;
+struct btf_show;
 
 extern const struct file_operations btf_fops;
 
@@ -46,8 +47,40 @@ int btf_get_info_by_fd(const struct btf *btf,
 const struct btf_type *btf_type_id_size(const struct btf *btf,
 					u32 *type_id,
 					u32 *ret_size);
+
+/*
+ * Options to control show behaviour.
+ *	- BTF_SHOW_COMPACT: no formatting around type information
+ *	- BTF_SHOW_NONAME: no struct/union member names/types
+ *	- BTF_SHOW_PTR_RAW: show raw (unobfuscated) pointer values;
+ *	  equivalent to %px.
+ *	- BTF_SHOW_ZERO: show zero-valued struct/union members; they
+ *	  are not displayed by default
+ */
+#define BTF_SHOW_COMPACT	(1ULL << 0)
+#define BTF_SHOW_NONAME		(1ULL << 1)
+#define BTF_SHOW_PTR_RAW	(1ULL << 2)
+#define BTF_SHOW_ZERO		(1ULL << 3)
+
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m);
+
+/*
+ * Copy len bytes of string representation of obj of BTF type_id into buf.
+ *
+ * @btf: struct btf object
+ * @type_id: type id of type obj points to
+ * @obj: pointer to typed data
+ * @buf: buffer to write to
+ * @len: maximum length to write to buf
+ * @flags: show options (see above)
+ *
+ * Return: length that would have been/was copied as per snprintf, or
+ *	   negative error.
+ */
+int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
+			   char *buf, int len, u64 flags);
+
 int btf_get_fd_by_id(u32 id);
 u32 btf_id(const struct btf *btf);
 bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dcd2331..edf6455 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -281,6 +281,32 @@ static const char *btf_type_str(const struct btf_type *t)
 	return btf_kind_str[BTF_INFO_KIND(t->info)];
 }
 
+/*
+ * Common data to all BTF show operations. Private show functions can add
+ * their own data to a structure containing a struct btf_show and consult it
+ * in the show callback.  See btf_type_show() below.
+ */
+struct btf_show {
+	u64 flags;
+	void *target;	/* target of show operation (seq file, buffer) */
+	void (*showfn)(struct btf_show *show, const char *fmt, ...);
+	const struct btf *btf;
+	/* below are used during iteration */
+	struct {
+		u8 depth;
+		u8 depth_shown;
+		u8 depth_check;
+		u8 array_member:1,
+		   array_terminated:1;
+		u16 array_encoding;
+		u32 type_id;
+		const struct btf_type *type;
+		const struct btf_member *member;
+		char name[KSYM_NAME_LEN];	/* scratch space for name */
+		char type_name[KSYM_NAME_LEN];	/* scratch space for type */
+	} state;
+};
+
 struct btf_kind_operations {
 	s32 (*check_meta)(struct btf_verifier_env *env,
 			  const struct btf_type *t,
@@ -297,9 +323,9 @@ struct btf_kind_operations {
 				  const struct btf_type *member_type);
 	void (*log_details)(struct btf_verifier_env *env,
 			    const struct btf_type *t);
-	void (*seq_show)(const struct btf *btf, const struct btf_type *t,
+	void (*show)(const struct btf *btf, const struct btf_type *t,
 			 u32 type_id, void *data, u8 bits_offsets,
-			 struct seq_file *m);
+			 struct btf_show *show);
 };
 
 static const struct btf_kind_operations * const kind_ops[NR_BTF_KINDS];
@@ -676,6 +702,340 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 	return true;
 }
 
+/* Similar to btf_type_skip_modifiers() but does not skip typedefs. */
+static inline
+const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf, u32 id)
+{
+	const struct btf_type *t = btf_type_by_id(btf, id);
+
+	while (btf_type_is_modifier(t) &&
+	       BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
+		id = t->type;
+		t = btf_type_by_id(btf, t->type);
+	}
+
+	return t;
+}
+
+#define BTF_SHOW_MAX_ITER	10
+
+#define BTF_KIND_BIT(kind)	(1ULL << kind)
+
+static inline const char *btf_show_type_name(struct btf_show *show,
+					     const struct btf_type *t)
+{
+	const char *array_suffixes = "[][][][][][][][][][]";
+	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
+	const char *ptr_suffixes = "**********";
+	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
+	const char *type_name = NULL, *prefix = "", *parens = "";
+	const struct btf_array *array;
+	u32 id = show->state.type_id;
+	bool allow_anon = true;
+	u64 kinds = 0;
+	int i;
+
+	show->state.type_name[0] = '\0';
+
+	/*
+	 * Start with type_id, as we have have resolved the struct btf_type *
+	 * via btf_modifier_show() past the parent typedef to the child
+	 * struct, int etc it is defined as.  In such cases, the type_id
+	 * still represents the starting type while the the struct btf_type *
+	 * in our show->state points at the resolved type of the typedef.
+	 */
+	t = btf_type_by_id(show->btf, id);
+	if (!t)
+		return show->state.type_name;
+
+	/*
+	 * The goal here is to build up the right number of pointer and
+	 * array suffixes while ensuring the type name for a typedef
+	 * is represented.  Along the way we accumulate a list of
+	 * BTF kinds we have encountered, since these will inform later
+	 * display; for example, pointer types will not require an
+	 * opening "{" for struct, we will just display the pointer value.
+	 *
+	 * We also want to accumulate the right number of pointer or array
+	 * indices in the format string while iterating until we get to
+	 * the typedef/pointee/array member target type.
+	 *
+	 * We start by pointing at the end of pointer and array suffix
+	 * strings; as we accumulate pointers and arrays we move the pointer
+	 * or array string backwards so it will show the expected number of
+	 * '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
+	 * and/or arrays and typedefs are supported as a precaution.
+	 *
+	 * We also want to get typedef name while proceeding to resolve
+	 * type it points to so that we can add parentheses if it is a
+	 * "typedef struct" etc.
+	 */
+	for (i = 0; i < BTF_SHOW_MAX_ITER; i++) {
+
+		switch (BTF_INFO_KIND(t->info)) {
+		case BTF_KIND_TYPEDEF:
+			if (!type_name)
+				type_name = btf_name_by_offset(show->btf,
+							       t->name_off);
+			kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
+			id = t->type;
+			break;
+		case BTF_KIND_ARRAY:
+			kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
+			parens = "[";
+			array = btf_type_array(t);
+			if (!array)
+				return show->state.type_name;
+			if (!t)
+				return show->state.type_name;
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
+		t = btf_type_skip_qualifiers(show->btf, id);
+		if (!t)
+			return show->state.type_name;
+	}
+	/* We may not be able to represent this type; bail to be safe */
+	if (i == BTF_SHOW_MAX_ITER)
+		return show->state.type_name;
+
+	if (!type_name)
+		type_name = btf_name_by_offset(show->btf, t->name_off);
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
+			 "struct" : "union";
+		/* if it's an array of struct/union, parens is already set */
+		if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
+			parens = "{";
+		break;
+	case BTF_KIND_ENUM:
+		prefix = "enum";
+		break;
+	default:
+		allow_anon = false;
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
+	if (!type_name || strlen(type_name) == 0) {
+		if (allow_anon)
+			type_name = "";
+		else
+			return show->state.type_name;
+	}
+
+	/* Even if we don't want type name info, we want parentheses etc */
+	if (show->flags & BTF_SHOW_NONAME)
+		snprintf(show->state.type_name, sizeof(show->state.type_name),
+			 "%s", parens);
+	else
+		snprintf(show->state.type_name, sizeof(show->state.type_name),
+			 "(%s%s%s%s%s%s)%s",
+			 prefix,
+			 strlen(prefix) > 0 && strlen(type_name) > 0 ? " " : "",
+			 type_name,
+			 strlen(ptr_suffix) > 0 ? " " : "", ptr_suffix,
+			 array_suffix, parens);
+
+	return show->state.type_name;
+}
+
+static inline const char *btf_show_name(struct btf_show *show)
+{
+	const struct btf_type *t = show->state.type;
+	const struct btf_member *m = show->state.member;
+	const char *member = NULL;
+	const char *type = "";
+
+	show->state.name[0] = '\0';
+
+	if ((!m && !t) || show->state.array_member)
+		return show->state.name;
+
+	if (m)
+		t = btf_type_skip_qualifiers(show->btf, m->type);
+
+	if (t) {
+		type = btf_show_type_name(show, t);
+		if (!type)
+			return show->state.name;
+	}
+
+	if (m && !(show->flags & BTF_SHOW_NONAME)) {
+		member = btf_name_by_offset(show->btf, m->name_off);
+		if (member && strlen(member) > 0) {
+			snprintf(show->state.name, sizeof(show->state.name),
+				 ".%s = %s", member, type);
+			return show->state.name;
+		}
+	}
+
+	snprintf(show->state.name, sizeof(show->state.name), "%s", type);
+
+	return show->state.name;
+}
+
+#define btf_show(show, ...)						      \
+	do {								      \
+		if (!show->state.depth_check)				      \
+			show->showfn(show, __VA_ARGS__);		      \
+	} while (0)
+
+static inline const char *__btf_show_indent(struct btf_show *show)
+{
+	const char *indents = "                                ";
+	const char *indent = &indents[strlen(indents)];
+
+	if ((indent - show->state.depth) >= indents)
+		return indent - show->state.depth;
+	return indents;
+}
+
+#define btf_show_indent(show)						       \
+	((show->flags & BTF_SHOW_COMPACT) ? "" : __btf_show_indent(show))
+
+#define btf_show_newline(show)						       \
+	((show->flags & BTF_SHOW_COMPACT) ? "" : "\n")
+
+#define btf_show_delim(show)						       \
+	(show->state.depth == 0 ? "" :					       \
+	 ((show->flags & BTF_SHOW_COMPACT) && show->state.type &&	       \
+	  BTF_INFO_KIND(show->state.type->info) == BTF_KIND_UNION) ? "|" : ",")
+
+#define btf_show_type_value(show, fmt, value)				       \
+	do {								       \
+		if ((value) != 0 || (show->flags & BTF_SHOW_ZERO) ||	       \
+		    show->state.depth == 0) {				       \
+			btf_show(show, "%s%s" fmt "%s%s",		       \
+				 btf_show_indent(show),			       \
+				 btf_show_name(show),			       \
+				 value, btf_show_delim(show),		       \
+				 btf_show_newline(show));		       \
+			if (show->state.depth > show->state.depth_shown)       \
+				show->state.depth_shown = show->state.depth;   \
+		}							       \
+	} while (0)
+
+#define btf_show_type_values(show, fmt, ...)				       \
+	do {								       \
+		btf_show(show, "%s%s" fmt "%s%s", btf_show_indent(show),       \
+			 btf_show_name(show),				       \
+			 __VA_ARGS__, btf_show_delim(show),		       \
+			 btf_show_newline(show));			       \
+		if (show->state.depth > show->state.depth_shown)	       \
+			show->state.depth_shown = show->state.depth;	       \
+	} while (0)
+
+static inline void btf_show_start_type(struct btf_show *show,
+				       const struct btf_type *t,
+				       u32 type_id)
+{
+	show->state.type = t;
+	show->state.type_id = type_id;
+	show->state.name[0] = '\0';
+}
+
+static inline void btf_show_end_type(struct btf_show *show)
+{
+	show->state.type = NULL;
+	show->state.type_id = 0;
+	show->state.name[0] = '\0';
+}
+
+static inline void btf_show_start_aggr_type(struct btf_show *show,
+					    const struct btf_type *t,
+					    u32 type_id)
+{
+	btf_show_start_type(show, t, type_id);
+	btf_show(show, "%s%s%s", btf_show_indent(show),
+		 btf_show_name(show),
+		 btf_show_newline(show));
+	show->state.depth++;
+}
+
+static inline void btf_show_end_aggr_type(struct btf_show *show,
+					  const char *suffix)
+{
+	show->state.depth--;
+	btf_show(show, "%s%s%s%s", btf_show_indent(show), suffix,
+		 btf_show_delim(show), btf_show_newline(show));
+	btf_show_end_type(show);
+}
+
+static inline void btf_show_start_member(struct btf_show *show,
+					 const struct btf_member *m)
+{
+	show->state.member = m;
+}
+
+static inline void btf_show_start_array_member(struct btf_show *show)
+{
+	show->state.array_member = 1;
+	btf_show_start_member(show, NULL);
+}
+
+static inline void btf_show_end_member(struct btf_show *show)
+{
+	show->state.member = NULL;
+}
+
+static inline void btf_show_end_array_member(struct btf_show *show)
+{
+	show->state.array_member = 0;
+	btf_show_end_member(show);
+}
+
+static inline void btf_show_start_array_type(struct btf_show *show,
+					     const struct btf_type *t,
+					     u32 type_id,
+					     u16 array_encoding)
+{
+	show->state.array_encoding = array_encoding;
+	show->state.array_terminated = 0;
+	btf_show_start_aggr_type(show, t, type_id);
+}
+
+static inline void btf_show_end_array_type(struct btf_show *show)
+{
+	show->state.array_encoding = 0;
+	show->state.array_terminated = 0;
+	btf_show_end_aggr_type(show, "]");
+}
+
+static inline void btf_show_start_struct_type(struct btf_show *show,
+					      const struct btf_type *t,
+					      u32 type_id)
+{
+	btf_show_start_aggr_type(show, t, type_id);
+}
+
+static inline void btf_show_end_struct_type(struct btf_show *show)
+{
+	btf_show_end_aggr_type(show, "}");
+}
+
 __printf(2, 3) static void __btf_verifier_log(struct bpf_verifier_log *log,
 					      const char *fmt, ...)
 {
@@ -1249,11 +1609,11 @@ static int btf_df_resolve(struct btf_verifier_env *env,
 	return -EINVAL;
 }
 
-static void btf_df_seq_show(const struct btf *btf, const struct btf_type *t,
-			    u32 type_id, void *data, u8 bits_offsets,
-			    struct seq_file *m)
+static void btf_df_show(const struct btf *btf, const struct btf_type *t,
+			u32 type_id, void *data, u8 bits_offsets,
+			struct btf_show *show)
 {
-	seq_printf(m, "<unsupported kind:%u>", BTF_INFO_KIND(t->info));
+	btf_show(show, "<unsupported kind:%u>", BTF_INFO_KIND(t->info));
 }
 
 static int btf_int_check_member(struct btf_verifier_env *env,
@@ -1426,7 +1786,7 @@ static void btf_int_log(struct btf_verifier_env *env,
 			 btf_int_encoding_str(BTF_INT_ENCODING(int_data)));
 }
 
-static void btf_int128_print(struct seq_file *m, void *data)
+static void btf_int128_print(struct btf_show *show, void *data)
 {
 	/* data points to a __int128 number.
 	 * Suppose
@@ -1445,9 +1805,10 @@ static void btf_int128_print(struct seq_file *m, void *data)
 	lower_num = *(u64 *)data;
 #endif
 	if (upper_num == 0)
-		seq_printf(m, "0x%llx", lower_num);
+		btf_show_type_value(show, "0x%llx", lower_num);
 	else
-		seq_printf(m, "0x%llx%016llx", upper_num, lower_num);
+		btf_show_type_values(show, "0x%llx%016llx", upper_num,
+				     lower_num);
 }
 
 static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
@@ -1491,8 +1852,8 @@ static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
 #endif
 }
 
-static void btf_bitfield_seq_show(void *data, u8 bits_offset,
-				  u8 nr_bits, struct seq_file *m)
+static void btf_bitfield_show(void *data, u8 bits_offset,
+			      u8 nr_bits, struct btf_show *show)
 {
 	u16 left_shift_bits, right_shift_bits;
 	u8 nr_copy_bytes;
@@ -1512,14 +1873,14 @@ static void btf_bitfield_seq_show(void *data, u8 bits_offset,
 	right_shift_bits = BITS_PER_U128 - nr_bits;
 
 	btf_int128_shift(print_num, left_shift_bits, right_shift_bits);
-	btf_int128_print(m, print_num);
+	btf_int128_print(show, print_num);
 }
 
 
-static void btf_int_bits_seq_show(const struct btf *btf,
-				  const struct btf_type *t,
-				  void *data, u8 bits_offset,
-				  struct seq_file *m)
+static void btf_int_bits_show(const struct btf *btf,
+			      const struct btf_type *t,
+			      void *data, u8 bits_offset,
+			      struct btf_show *show)
 {
 	u32 int_data = btf_type_int(t);
 	u8 nr_bits = BTF_INT_BITS(int_data);
@@ -1532,55 +1893,74 @@ static void btf_int_bits_seq_show(const struct btf *btf,
 	total_bits_offset = bits_offset + BTF_INT_OFFSET(int_data);
 	data += BITS_ROUNDDOWN_BYTES(total_bits_offset);
 	bits_offset = BITS_PER_BYTE_MASKED(total_bits_offset);
-	btf_bitfield_seq_show(data, bits_offset, nr_bits, m);
+	btf_bitfield_show(data, bits_offset, nr_bits, show);
 }
 
-static void btf_int_seq_show(const struct btf *btf, const struct btf_type *t,
-			     u32 type_id, void *data, u8 bits_offset,
-			     struct seq_file *m)
+static void btf_int_show(const struct btf *btf, const struct btf_type *t,
+			 u32 type_id, void *data, u8 bits_offset,
+			 struct btf_show *show)
 {
 	u32 int_data = btf_type_int(t);
 	u8 encoding = BTF_INT_ENCODING(int_data);
 	bool sign = encoding & BTF_INT_SIGNED;
 	u8 nr_bits = BTF_INT_BITS(int_data);
 
+	btf_show_start_type(show, t, type_id);
+
 	if (bits_offset || BTF_INT_OFFSET(int_data) ||
 	    BITS_PER_BYTE_MASKED(nr_bits)) {
-		btf_int_bits_seq_show(btf, t, data, bits_offset, m);
-		return;
+		btf_int_bits_show(btf, t, data, bits_offset, show);
+		goto out;
 	}
 
 	switch (nr_bits) {
 	case 128:
-		btf_int128_print(m, data);
+		btf_int128_print(show, data);
 		break;
 	case 64:
 		if (sign)
-			seq_printf(m, "%lld", *(s64 *)data);
+			btf_show_type_value(show, "%lld", *(s64 *)data);
 		else
-			seq_printf(m, "%llu", *(u64 *)data);
+			btf_show_type_value(show, "%llu", *(u64 *)data);
 		break;
 	case 32:
 		if (sign)
-			seq_printf(m, "%d", *(s32 *)data);
+			btf_show_type_value(show, "%d", *(s32 *)data);
 		else
-			seq_printf(m, "%u", *(u32 *)data);
+			btf_show_type_value(show, "%u", *(u32 *)data);
 		break;
 	case 16:
 		if (sign)
-			seq_printf(m, "%d", *(s16 *)data);
+			btf_show_type_value(show, "%d", *(s16 *)data);
 		else
-			seq_printf(m, "%u", *(u16 *)data);
+			btf_show_type_value(show, "%u", *(u16 *)data);
 		break;
 	case 8:
+		if (show->state.array_encoding == BTF_INT_CHAR) {
+			/* check for null terminator */
+			if (show->state.array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				show->state.array_terminated = 1;
+				break;
+			}
+			if (isprint(*(char *)data)) {
+				btf_show_type_value(show, "'%c'",
+						    *(char *)data);
+				break;
+			}
+		}
 		if (sign)
-			seq_printf(m, "%d", *(s8 *)data);
+			btf_show_type_value(show, "%d", *(s8 *)data);
 		else
-			seq_printf(m, "%u", *(u8 *)data);
+			btf_show_type_value(show, "%u", *(u8 *)data);
 		break;
 	default:
-		btf_int_bits_seq_show(btf, t, data, bits_offset, m);
+		btf_int_bits_show(btf, t, data, bits_offset, show);
+		break;
 	}
+out:
+	btf_show_end_type(show);
 }
 
 static const struct btf_kind_operations int_ops = {
@@ -1589,7 +1969,7 @@ static void btf_int_seq_show(const struct btf *btf, const struct btf_type *t,
 	.check_member = btf_int_check_member,
 	.check_kflag_member = btf_int_check_kflag_member,
 	.log_details = btf_int_log,
-	.seq_show = btf_int_seq_show,
+	.show = btf_int_show,
 };
 
 static int btf_modifier_check_member(struct btf_verifier_env *env,
@@ -1853,34 +2233,39 @@ static int btf_ptr_resolve(struct btf_verifier_env *env,
 	return 0;
 }
 
-static void btf_modifier_seq_show(const struct btf *btf,
-				  const struct btf_type *t,
-				  u32 type_id, void *data,
-				  u8 bits_offset, struct seq_file *m)
+static void btf_modifier_show(const struct btf *btf,
+			      const struct btf_type *t,
+			      u32 type_id, void *data,
+			      u8 bits_offset, struct btf_show *show)
 {
 	if (btf->resolved_ids)
 		t = btf_type_id_resolve(btf, &type_id);
 	else
 		t = btf_type_skip_modifiers(btf, type_id, NULL);
 
-	btf_type_ops(t)->seq_show(btf, t, type_id, data, bits_offset, m);
+	btf_type_ops(t)->show(btf, t, type_id, data, bits_offset, show);
 }
 
-static void btf_var_seq_show(const struct btf *btf, const struct btf_type *t,
-			     u32 type_id, void *data, u8 bits_offset,
-			     struct seq_file *m)
+static void btf_var_show(const struct btf *btf, const struct btf_type *t,
+			 u32 type_id, void *data, u8 bits_offset,
+			 struct btf_show *show)
 {
 	t = btf_type_id_resolve(btf, &type_id);
 
-	btf_type_ops(t)->seq_show(btf, t, type_id, data, bits_offset, m);
+	btf_type_ops(t)->show(btf, t, type_id, data, bits_offset, show);
 }
 
-static void btf_ptr_seq_show(const struct btf *btf, const struct btf_type *t,
-			     u32 type_id, void *data, u8 bits_offset,
-			     struct seq_file *m)
+static void btf_ptr_show(const struct btf *btf, const struct btf_type *t,
+			 u32 type_id, void *data, u8 bits_offset,
+			 struct btf_show *show)
 {
-	/* It is a hashed value */
-	seq_printf(m, "%p", *(void **)data);
+	btf_show_start_type(show, t, type_id);
+	/* It is a hashed value unless BTF_SHOW_PTR_RAW is specified */
+	if (show->flags & BTF_SHOW_PTR_RAW)
+		btf_show_type_value(show, "%px", *(void **)data);
+	else
+		btf_show_type_value(show, "%p", *(void **)data);
+	btf_show_end_type(show);
 }
 
 static void btf_ref_type_log(struct btf_verifier_env *env,
@@ -1895,7 +2280,7 @@ static void btf_ref_type_log(struct btf_verifier_env *env,
 	.check_member = btf_modifier_check_member,
 	.check_kflag_member = btf_modifier_check_kflag_member,
 	.log_details = btf_ref_type_log,
-	.seq_show = btf_modifier_seq_show,
+	.show = btf_modifier_show,
 };
 
 static struct btf_kind_operations ptr_ops = {
@@ -1904,7 +2289,7 @@ static void btf_ref_type_log(struct btf_verifier_env *env,
 	.check_member = btf_ptr_check_member,
 	.check_kflag_member = btf_generic_check_kflag_member,
 	.log_details = btf_ref_type_log,
-	.seq_show = btf_ptr_seq_show,
+	.show = btf_ptr_show,
 };
 
 static s32 btf_fwd_check_meta(struct btf_verifier_env *env,
@@ -1945,7 +2330,7 @@ static void btf_fwd_type_log(struct btf_verifier_env *env,
 	.check_member = btf_df_check_member,
 	.check_kflag_member = btf_df_check_kflag_member,
 	.log_details = btf_fwd_type_log,
-	.seq_show = btf_df_seq_show,
+	.show = btf_df_show,
 };
 
 static int btf_array_check_member(struct btf_verifier_env *env,
@@ -2104,28 +2489,87 @@ static void btf_array_log(struct btf_verifier_env *env,
 			 array->type, array->index_type, array->nelems);
 }
 
-static void btf_array_seq_show(const struct btf *btf, const struct btf_type *t,
-			       u32 type_id, void *data, u8 bits_offset,
-			       struct seq_file *m)
+static void __btf_array_show(const struct btf *btf, const struct btf_type *t,
+			     u32 type_id, void *data, u8 bits_offset,
+			     struct btf_show *show)
 {
 	const struct btf_array *array = btf_type_array(t);
 	const struct btf_kind_operations *elem_ops;
 	const struct btf_type *elem_type;
-	u32 i, elem_size, elem_type_id;
+	u32 i, elem_size = 0, elem_type_id;
+	u16 encoding = 0;
 
 	elem_type_id = array->type;
-	elem_type = btf_type_id_size(btf, &elem_type_id, &elem_size);
+	elem_type = btf_type_skip_modifiers(btf, elem_type_id, NULL);
+	if (elem_type && btf_type_has_size(elem_type))
+		elem_size = elem_type->size;
+
+	if (elem_type && btf_type_is_int(elem_type)) {
+		u32 int_type = btf_type_int(elem_type);
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
+	btf_show_start_array_type(show, t, type_id, encoding);
+
+	if (!elem_type)
+		goto out;
 	elem_ops = btf_type_ops(elem_type);
-	seq_puts(m, "[");
+
 	for (i = 0; i < array->nelems; i++) {
-		if (i)
-			seq_puts(m, ",");
 
-		elem_ops->seq_show(btf, elem_type, elem_type_id, data,
-				   bits_offset, m);
+		btf_show_start_array_member(show);
+
+		elem_ops->show(btf, elem_type, elem_type_id, data,
+			       bits_offset, show);
 		data += elem_size;
+
+		btf_show_end_array_member(show);
+
+		if (show->state.array_terminated)
+			break;
 	}
-	seq_puts(m, "]");
+out:
+	btf_show_end_array_type(show);
+}
+
+static void btf_array_show(const struct btf *btf, const struct btf_type *t,
+			   u32 type_id, void *data, u8 bits_offset,
+			   struct btf_show *show)
+{
+	const struct btf_member *m = show->state.member;
+
+	/*
+	 * First check if any members would be shown (are non-zero).
+	 */
+	if (show->state.depth > 0 && !(show->flags & BTF_SHOW_ZERO)) {
+		if (!show->state.depth_check) {
+			show->state.depth_check = show->state.depth + 1;
+			show->state.depth_shown = 0;
+		}
+		__btf_array_show(btf, t, type_id, data, bits_offset, show);
+		show->state.member = m;
+
+		if (show->state.depth_check != show->state.depth + 1)
+			return;
+		show->state.depth_check = 0;
+
+		if (show->state.depth_shown <= show->state.depth)
+			return;
+		/*
+		 * Reaching here indicates we have recursed and found
+		 * non-zero array member(s).
+		 */
+	}
+	__btf_array_show(btf, t, type_id, data, bits_offset, show);
 }
 
 static struct btf_kind_operations array_ops = {
@@ -2134,7 +2578,7 @@ static void btf_array_seq_show(const struct btf *btf, const struct btf_type *t,
 	.check_member = btf_array_check_member,
 	.check_kflag_member = btf_generic_check_kflag_member,
 	.log_details = btf_array_log,
-	.seq_show = btf_array_seq_show,
+	.show = btf_array_show,
 };
 
 static int btf_struct_check_member(struct btf_verifier_env *env,
@@ -2357,15 +2801,15 @@ int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t)
 	return off;
 }
 
-static void btf_struct_seq_show(const struct btf *btf, const struct btf_type *t,
-				u32 type_id, void *data, u8 bits_offset,
-				struct seq_file *m)
+static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
+			      u32 type_id, void *data, u8 bits_offset,
+			      struct btf_show *show)
 {
-	const char *seq = BTF_INFO_KIND(t->info) == BTF_KIND_UNION ? "|" : ",";
 	const struct btf_member *member;
 	u32 i;
 
-	seq_puts(m, "{");
+	btf_show_start_struct_type(show, t, type_id);
+
 	for_each_member(i, t, member) {
 		const struct btf_type *member_type = btf_type_by_id(btf,
 								member->type);
@@ -2374,23 +2818,55 @@ static void btf_struct_seq_show(const struct btf *btf, const struct btf_type *t,
 		u32 bytes_offset;
 		u8 bits8_offset;
 
-		if (i)
-			seq_puts(m, seq);
+		btf_show_start_member(show, member);
 
 		member_offset = btf_member_bit_offset(t, member);
 		bitfield_size = btf_member_bitfield_size(t, member);
 		bytes_offset = BITS_ROUNDDOWN_BYTES(member_offset);
 		bits8_offset = BITS_PER_BYTE_MASKED(member_offset);
 		if (bitfield_size) {
-			btf_bitfield_seq_show(data + bytes_offset, bits8_offset,
-					      bitfield_size, m);
+			btf_bitfield_show(data + bytes_offset, bits8_offset,
+					  bitfield_size, show);
 		} else {
 			ops = btf_type_ops(member_type);
-			ops->seq_show(btf, member_type, member->type,
-				      data + bytes_offset, bits8_offset, m);
+			ops->show(btf, member_type, member->type,
+				  data + bytes_offset, bits8_offset, show);
 		}
+
+		btf_show_end_member(show);
 	}
-	seq_puts(m, "}");
+
+	btf_show_end_struct_type(show);
+}
+
+static void btf_struct_show(const struct btf *btf, const struct btf_type *t,
+			    u32 type_id, void *data, u8 bits_offset,
+			    struct btf_show *show)
+{
+	const struct btf_member *m = show->state.member;
+
+	/* First check if any members would be shown (are non-zero) */
+	if (show->state.depth > 0 && !(show->flags & BTF_SHOW_ZERO)) {
+		if (!show->state.depth_check) {
+			show->state.depth_check = show->state.depth + 1;
+			show->state.depth_shown = 0;
+		}
+		__btf_struct_show(btf, t, type_id, data, bits_offset, show);
+		/* Restore saved member data here */
+		show->state.member = m;
+		if (show->state.depth_check != show->state.depth + 1)
+			return;
+		show->state.depth_check = 0;
+
+		if (show->state.depth_shown <= show->state.depth)
+			return;
+		/*
+		 * Reaching here indicates we have recursed and found
+		 * non-zero child values.
+		 */
+	}
+
+	__btf_struct_show(btf, t, type_id, data, bits_offset, show);
 }
 
 static struct btf_kind_operations struct_ops = {
@@ -2399,7 +2875,7 @@ static void btf_struct_seq_show(const struct btf *btf, const struct btf_type *t,
 	.check_member = btf_struct_check_member,
 	.check_kflag_member = btf_generic_check_kflag_member,
 	.log_details = btf_struct_log,
-	.seq_show = btf_struct_seq_show,
+	.show = btf_struct_show,
 };
 
 static int btf_enum_check_member(struct btf_verifier_env *env,
@@ -2530,24 +3006,30 @@ static void btf_enum_log(struct btf_verifier_env *env,
 	btf_verifier_log(env, "size=%u vlen=%u", t->size, btf_type_vlen(t));
 }
 
-static void btf_enum_seq_show(const struct btf *btf, const struct btf_type *t,
-			      u32 type_id, void *data, u8 bits_offset,
-			      struct seq_file *m)
+static void btf_enum_show(const struct btf *btf, const struct btf_type *t,
+			  u32 type_id, void *data, u8 bits_offset,
+			  struct btf_show *show)
 {
 	const struct btf_enum *enums = btf_type_enum(t);
 	u32 i, nr_enums = btf_type_vlen(t);
 	int v = *(int *)data;
 
+	btf_show_start_type(show, t, type_id);
+
 	for (i = 0; i < nr_enums; i++) {
-		if (v == enums[i].val) {
-			seq_printf(m, "%s",
-				   __btf_name_by_offset(btf,
-							enums[i].name_off));
-			return;
-		}
+		if (v != enums[i].val)
+			continue;
+
+		btf_show_type_value(show, "%s",
+				    __btf_name_by_offset(btf,
+							 enums[i].name_off));
+
+		btf_show_end_type(show);
+		return;
 	}
 
-	seq_printf(m, "%d", v);
+	btf_show_type_value(show, "%d", v);
+	btf_show_end_type(show);
 }
 
 static struct btf_kind_operations enum_ops = {
@@ -2556,7 +3038,7 @@ static void btf_enum_seq_show(const struct btf *btf, const struct btf_type *t,
 	.check_member = btf_enum_check_member,
 	.check_kflag_member = btf_enum_check_kflag_member,
 	.log_details = btf_enum_log,
-	.seq_show = btf_enum_seq_show,
+	.show = btf_enum_show,
 };
 
 static s32 btf_func_proto_check_meta(struct btf_verifier_env *env,
@@ -2643,7 +3125,7 @@ static void btf_func_proto_log(struct btf_verifier_env *env,
 	.check_member = btf_df_check_member,
 	.check_kflag_member = btf_df_check_kflag_member,
 	.log_details = btf_func_proto_log,
-	.seq_show = btf_df_seq_show,
+	.show = btf_df_show,
 };
 
 static s32 btf_func_check_meta(struct btf_verifier_env *env,
@@ -2677,7 +3159,7 @@ static s32 btf_func_check_meta(struct btf_verifier_env *env,
 	.check_member = btf_df_check_member,
 	.check_kflag_member = btf_df_check_kflag_member,
 	.log_details = btf_ref_type_log,
-	.seq_show = btf_df_seq_show,
+	.show = btf_df_show,
 };
 
 static s32 btf_var_check_meta(struct btf_verifier_env *env,
@@ -2741,7 +3223,7 @@ static void btf_var_log(struct btf_verifier_env *env, const struct btf_type *t)
 	.check_member		= btf_df_check_member,
 	.check_kflag_member	= btf_df_check_kflag_member,
 	.log_details		= btf_var_log,
-	.seq_show		= btf_var_seq_show,
+	.show			= btf_var_show,
 };
 
 static s32 btf_datasec_check_meta(struct btf_verifier_env *env,
@@ -2867,24 +3349,26 @@ static void btf_datasec_log(struct btf_verifier_env *env,
 	btf_verifier_log(env, "size=%u vlen=%u", t->size, btf_type_vlen(t));
 }
 
-static void btf_datasec_seq_show(const struct btf *btf,
-				 const struct btf_type *t, u32 type_id,
-				 void *data, u8 bits_offset,
-				 struct seq_file *m)
+static void btf_datasec_show(const struct btf *btf,
+			     const struct btf_type *t, u32 type_id,
+			     void *data, u8 bits_offset,
+			     struct btf_show *show)
 {
 	const struct btf_var_secinfo *vsi;
 	const struct btf_type *var;
 	u32 i;
 
-	seq_printf(m, "section (\"%s\") = {", __btf_name_by_offset(btf, t->name_off));
+	btf_show_start_type(show, t, type_id);
+	btf_show_type_value(show, "section (\"%s\") = {",
+			    __btf_name_by_offset(btf, t->name_off));
 	for_each_vsi(i, t, vsi) {
 		var = btf_type_by_id(btf, vsi->type);
 		if (i)
-			seq_puts(m, ",");
-		btf_type_ops(var)->seq_show(btf, var, vsi->type,
-					    data + vsi->offset, bits_offset, m);
+			btf_show(show, ",");
+		btf_type_ops(var)->show(btf, var, vsi->type,
+					data + vsi->offset, bits_offset, show);
 	}
-	seq_puts(m, "}");
+	btf_show_end_type(show);
 }
 
 static const struct btf_kind_operations datasec_ops = {
@@ -2893,7 +3377,7 @@ static void btf_datasec_seq_show(const struct btf *btf,
 	.check_member		= btf_df_check_member,
 	.check_kflag_member	= btf_df_check_kflag_member,
 	.log_details		= btf_datasec_log,
-	.seq_show		= btf_datasec_seq_show,
+	.show			= btf_datasec_show,
 };
 
 static int btf_func_proto_check(struct btf_verifier_env *env,
@@ -4549,12 +5033,83 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 	return 0;
 }
 
-void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
-		       struct seq_file *m)
+void btf_type_show(const struct btf *btf, u32 type_id, void *obj,
+		   struct btf_show *show)
 {
 	const struct btf_type *t = btf_type_by_id(btf, type_id);
 
-	btf_type_ops(t)->seq_show(btf, t, type_id, obj, 0, m);
+	show->btf = btf;
+	memset(&show->state, 0, sizeof(show->state));
+
+	btf_type_ops(t)->show(btf, t, type_id, obj, 0, show);
+}
+
+static void btf_seq_show(struct btf_show *show, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	seq_vprintf((struct seq_file *)show->target, fmt, args);
+	va_end(args);
+}
+
+void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
+			struct seq_file *m)
+{
+	struct btf_show sseq;
+
+	sseq.target = m;
+	sseq.showfn = btf_seq_show;
+	sseq.flags = BTF_SHOW_NONAME | BTF_SHOW_COMPACT | BTF_SHOW_ZERO;
+
+	btf_type_show(btf, type_id, obj, &sseq);
+}
+
+struct btf_show_snprintf {
+	struct btf_show show;
+	int len_left;		/* space left in string */
+	int len;		/* length we would have written */
+};
+
+static void btf_snprintf_show(struct btf_show *show, const char *fmt, ...)
+{
+	struct btf_show_snprintf *ssnprintf = (struct btf_show_snprintf *)show;
+	va_list args;
+	int len;
+
+	va_start(args, fmt);
+	len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
+	va_end(args);
+
+	if (len < 0) {
+		ssnprintf->len_left = 0;
+		ssnprintf->len = len;
+	} else if (len > ssnprintf->len_left) {
+		/* no space, drive on to get length we would have written */
+		ssnprintf->len_left = 0;
+		ssnprintf->len += len;
+	} else {
+		ssnprintf->len_left -= len;
+		ssnprintf->len += len;
+		show->target += len;
+	}
+}
+
+int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
+			   char *buf, int len, u64 flags)
+{
+	struct btf_show_snprintf ssnprintf;
+
+	ssnprintf.show.target = buf;
+	ssnprintf.show.flags = flags;
+	ssnprintf.show.showfn = btf_snprintf_show;
+	ssnprintf.len_left = len;
+	ssnprintf.len = 0;
+
+	btf_type_show(btf, type_id, obj, (struct btf_show *)&ssnprintf);
+
+	/* Return length we would have written */
+	return ssnprintf.len;
 }
 
 #ifdef CONFIG_PROC_FS
-- 
1.8.3.1

