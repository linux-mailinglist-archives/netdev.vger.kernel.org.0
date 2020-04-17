Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5F71ADB57
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgDQKnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:43:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbgDQKnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:43:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAfvOJ009384;
        Fri, 17 Apr 2020 10:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=7gNsh+Etcmy8+lgrd8UBN9CoiQmRiigght8TkFcRuo4=;
 b=E2bEFwt0J2WMXjhdGeF6DohlT5w9vOknYPtbIZvJimy7dTP7lXl+o2obUtTDlkwGIKmA
 5MEsyfUPG3GT+FPeTmad4o1iZjwI71FpgkzMkZOtD5GEn1Knqh6R/GxxrIAV4eRjm8fS
 Ge+ITn5yW7OOcFTkNYiHpA0IHHMI1U47yzbY6WK7BxykeIJIffq3hPr98M5WyGuVWpNu
 YMm56vLKaJxnKVDpM/yExedeqlgaDR4fp8OAtvc/g6Iaq4bGMvtNxUUkRn2P/lEGm6+z
 gmzBm0YQ3CR9PEyvmZkUCBgIWUEdM3RVWknMuhSWbm5WwOkEYGYMl1F+UC+No9JlOlTk 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30e0aaby1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:43:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAc4GV019030;
        Fri, 17 Apr 2020 10:43:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30dyp28bbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:43:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03HAh0Yo008242;
        Fri, 17 Apr 2020 10:43:00 GMT
Received: from localhost.uk.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 03:42:59 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 3/6] bpf: move to generic BTF show support, apply it to seq files/strings
Date:   Fri, 17 Apr 2020 11:42:37 +0100
Message-Id: <1587120160-3030-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170084
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

Also support flag to emit field information BTF_SHOW_NAME.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h |  22 +++
 kernel/bpf/btf.c    | 426 ++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 353 insertions(+), 95 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 5c1ea99..2f78dc8 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -13,6 +13,7 @@
 struct btf_member;
 struct btf_type;
 union bpf_attr;
+struct btf_show;
 
 extern const struct file_operations btf_fops;
 
@@ -46,8 +47,29 @@ int btf_get_info_by_fd(const struct btf *btf,
 const struct btf_type *btf_type_id_size(const struct btf *btf,
 					u32 *type_id,
 					u32 *ret_size);
+
+#define	BTF_SHOW_NAME	(1ULL << 0)
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
+ * @flags: show options
+ *	- BTF_SHOW_NAME: show struct/union member names as well as
+ *	  values
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
index a474839..ae453f0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -281,6 +281,25 @@ static const char *btf_type_str(const struct btf_type *t)
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
+	/* below are used during iteration */
+	u8 parent_kind;
+	u16 array_encoding;
+	u8 array_terminated;
+	const struct btf *btf;
+	const struct btf_type *type;
+	const struct btf_member *member;
+	char name[KSYM_NAME_LEN];	/* scratch space for member name */
+};
+
 struct btf_kind_operations {
 	s32 (*check_meta)(struct btf_verifier_env *env,
 			  const struct btf_type *t,
@@ -297,14 +316,90 @@ struct btf_kind_operations {
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
 static struct btf_type btf_void;
 
+#define btf_show(show, ...)    show->showfn(show, __VA_ARGS__)
+
+static inline void btf_show_start_type(struct btf_show *show,
+				       const struct btf_type *t)
+{
+	show->type = t;
+	show->name[0] = '\0';
+}
+
+static inline void btf_show_end_type(struct btf_show *show,
+				     const char *suffix)
+{
+	if (suffix)
+		btf_show(show, "%s", suffix);
+}
+
+static inline void btf_show_start_array_type(struct btf_show *show,
+					     const struct btf_type *t,
+					     u16 array_encoding)
+{
+	show->array_encoding = array_encoding;
+	show->array_terminated = 0;
+}
+
+static inline void btf_show_end_array_type(struct btf_show *show,
+					   const char *suffix)
+{
+	show->array_encoding = 0;
+	show->array_terminated = 0;
+	btf_show_end_type(show, suffix);
+}
+
+static inline void btf_show_start_member(struct btf_show *show,
+					 const struct btf_member *m)
+{
+	show->member = m;
+}
+
+static inline void btf_show_start_array_member(struct btf_show *show)
+{
+	show->parent_kind = BTF_KIND_ARRAY;
+	btf_show_start_member(show, NULL);
+}
+
+static inline void btf_show_end_member(struct btf_show *show)
+{
+	show->member = NULL;
+	show->parent_kind = BTF_KIND_UNKN;
+}
+
+static inline const char *btf_show_name(struct btf_show *show)
+{
+	const char *member = NULL;
+
+	/*
+	 * Avoid showing member information if we don't have it,
+	 * don't want it or if we're an array member.
+	 */
+	if (!show->member || !(show->flags & BTF_SHOW_NAME) ||
+	    show->parent_kind == BTF_KIND_ARRAY)
+		return "";
+
+	member = btf_name_by_offset(show->btf, show->member->name_off);
+	if (member && strlen(member) > 0)
+		snprintf(show->name, sizeof(show->name), ".%s=",
+			 member);
+
+	return show->name;
+}
+
+#define btf_show_type(show, fmt)				\
+	btf_show(show, "%s" fmt, btf_show_name(show))
+
+#define btf_show_type_value(show, fmt, ...)			\
+	btf_show(show, "%s" fmt, btf_show_name(show), __VA_ARGS__)
+
 static int btf_resolve(struct btf_verifier_env *env,
 		       const struct btf_type *t, u32 type_id);
 
@@ -1252,11 +1347,11 @@ static int btf_df_resolve(struct btf_verifier_env *env,
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
@@ -1429,7 +1524,7 @@ static void btf_int_log(struct btf_verifier_env *env,
 			 btf_int_encoding_str(BTF_INT_ENCODING(int_data)));
 }
 
-static void btf_int128_print(struct seq_file *m, void *data)
+static void btf_int128_print(struct btf_show *show, void *data)
 {
 	/* data points to a __int128 number.
 	 * Suppose
@@ -1448,9 +1543,10 @@ static void btf_int128_print(struct seq_file *m, void *data)
 	lower_num = *(u64 *)data;
 #endif
 	if (upper_num == 0)
-		seq_printf(m, "0x%llx", lower_num);
+		btf_show_type_value(show, "0x%llx", lower_num);
 	else
-		seq_printf(m, "0x%llx%016llx", upper_num, lower_num);
+		btf_show_type_value(show, "0x%llx%016llx", upper_num,
+				    lower_num);
 }
 
 static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
@@ -1494,8 +1590,8 @@ static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
 #endif
 }
 
-static void btf_bitfield_seq_show(void *data, u8 bits_offset,
-				  u8 nr_bits, struct seq_file *m)
+static void btf_bitfield_show(void *data, u8 bits_offset,
+			      u8 nr_bits, struct btf_show *show)
 {
 	u16 left_shift_bits, right_shift_bits;
 	u8 nr_copy_bytes;
@@ -1515,14 +1611,14 @@ static void btf_bitfield_seq_show(void *data, u8 bits_offset,
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
@@ -1535,55 +1631,74 @@ static void btf_int_bits_seq_show(const struct btf *btf,
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
 
+	btf_show_start_type(show, t);
+
 	if (bits_offset || BTF_INT_OFFSET(int_data) ||
 	    BITS_PER_BYTE_MASKED(nr_bits)) {
-		btf_int_bits_seq_show(btf, t, data, bits_offset, m);
+		btf_int_bits_show(btf, t, data, bits_offset, show);
 		return;
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
+		if (show->array_encoding == BTF_INT_CHAR) {
+			/* check for null terminator */
+			if (show->array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				btf_show_type(show, "'\\0'");
+				show->array_terminated = 1;
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
 	}
+
+	btf_show_end_type(show, NULL);
 }
 
 static const struct btf_kind_operations int_ops = {
@@ -1592,7 +1707,7 @@ static void btf_int_seq_show(const struct btf *btf, const struct btf_type *t,
 	.check_member = btf_int_check_member,
 	.check_kflag_member = btf_int_check_kflag_member,
 	.log_details = btf_int_log,
-	.seq_show = btf_int_seq_show,
+	.show = btf_int_show,
 };
 
 static int btf_modifier_check_member(struct btf_verifier_env *env,
@@ -1856,34 +1971,36 @@ static int btf_ptr_resolve(struct btf_verifier_env *env,
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
+	btf_show_start_type(show, t);
 	/* It is a hashed value */
-	seq_printf(m, "%p", *(void **)data);
+	btf_show_type_value(show, "%p", *(void **)data);
+	btf_show_end_type(show, NULL);
 }
 
 static void btf_ref_type_log(struct btf_verifier_env *env,
@@ -1898,7 +2015,7 @@ static void btf_ref_type_log(struct btf_verifier_env *env,
 	.check_member = btf_modifier_check_member,
 	.check_kflag_member = btf_modifier_check_kflag_member,
 	.log_details = btf_ref_type_log,
-	.seq_show = btf_modifier_seq_show,
+	.show = btf_modifier_show,
 };
 
 static struct btf_kind_operations ptr_ops = {
@@ -1907,7 +2024,7 @@ static void btf_ref_type_log(struct btf_verifier_env *env,
 	.check_member = btf_ptr_check_member,
 	.check_kflag_member = btf_generic_check_kflag_member,
 	.log_details = btf_ref_type_log,
-	.seq_show = btf_ptr_seq_show,
+	.show = btf_ptr_show,
 };
 
 static s32 btf_fwd_check_meta(struct btf_verifier_env *env,
@@ -1948,7 +2065,7 @@ static void btf_fwd_type_log(struct btf_verifier_env *env,
 	.check_member = btf_df_check_member,
 	.check_kflag_member = btf_df_check_kflag_member,
 	.log_details = btf_fwd_type_log,
-	.seq_show = btf_df_seq_show,
+	.show = btf_df_show,
 };
 
 static int btf_array_check_member(struct btf_verifier_env *env,
@@ -2107,28 +2224,57 @@ static void btf_array_log(struct btf_verifier_env *env,
 			 array->type, array->index_type, array->nelems);
 }
 
-static void btf_array_seq_show(const struct btf *btf, const struct btf_type *t,
-			       u32 type_id, void *data, u8 bits_offset,
-			       struct seq_file *m)
+static void btf_array_show(const struct btf *btf, const struct btf_type *t,
+			   u32 type_id, void *data, u8 bits_offset,
+			   struct btf_show *show)
 {
 	const struct btf_array *array = btf_type_array(t);
 	const struct btf_kind_operations *elem_ops;
 	const struct btf_type *elem_type;
 	u32 i, elem_size, elem_type_id;
+	u16 encoding = 0;
 
 	elem_type_id = array->type;
 	elem_type = btf_type_id_size(btf, &elem_type_id, &elem_size);
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
+	btf_show_start_array_type(show, t, encoding);
+	btf_show_type(show, "[");
+
+	if (!elem_type)
+		goto out;
 	elem_ops = btf_type_ops(elem_type);
-	seq_puts(m, "[");
+
 	for (i = 0; i < array->nelems; i++) {
 		if (i)
-			seq_puts(m, ",");
+			btf_show(show, ",");
+
+		btf_show_start_array_member(show);
 
-		elem_ops->seq_show(btf, elem_type, elem_type_id, data,
-				   bits_offset, m);
+		elem_ops->show(btf, elem_type, elem_type_id, data,
+			       bits_offset, show);
 		data += elem_size;
+
+		btf_show_end_member(show);
+
+		if (show->array_terminated)
+			break;
 	}
-	seq_puts(m, "]");
+out:
+	btf_show_end_array_type(show, "]");
 }
 
 static struct btf_kind_operations array_ops = {
@@ -2137,7 +2283,7 @@ static void btf_array_seq_show(const struct btf *btf, const struct btf_type *t,
 	.check_member = btf_array_check_member,
 	.check_kflag_member = btf_generic_check_kflag_member,
 	.log_details = btf_array_log,
-	.seq_show = btf_array_seq_show,
+	.show = btf_array_show,
 };
 
 static int btf_struct_check_member(struct btf_verifier_env *env,
@@ -2360,15 +2506,17 @@ int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t)
 	return off;
 }
 
-static void btf_struct_seq_show(const struct btf *btf, const struct btf_type *t,
-				u32 type_id, void *data, u8 bits_offset,
-				struct seq_file *m)
+static void btf_struct_show(const struct btf *btf, const struct btf_type *t,
+			    u32 type_id, void *data, u8 bits_offset,
+			    struct btf_show *show)
 {
 	const char *seq = BTF_INFO_KIND(t->info) == BTF_KIND_UNION ? "|" : ",";
 	const struct btf_member *member;
 	u32 i;
 
-	seq_puts(m, "{");
+	btf_show_start_type(show, t);
+	btf_show_type(show, "{");
+
 	for_each_member(i, t, member) {
 		const struct btf_type *member_type = btf_type_by_id(btf,
 								member->type);
@@ -2378,22 +2526,27 @@ static void btf_struct_seq_show(const struct btf *btf, const struct btf_type *t,
 		u8 bits8_offset;
 
 		if (i)
-			seq_puts(m, seq);
+			btf_show(show, seq);
+
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
+	btf_show_end_type(show, "}");
 }
 
 static struct btf_kind_operations struct_ops = {
@@ -2402,7 +2555,7 @@ static void btf_struct_seq_show(const struct btf *btf, const struct btf_type *t,
 	.check_member = btf_struct_check_member,
 	.check_kflag_member = btf_generic_check_kflag_member,
 	.log_details = btf_struct_log,
-	.seq_show = btf_struct_seq_show,
+	.show = btf_struct_show,
 };
 
 static int btf_enum_check_member(struct btf_verifier_env *env,
@@ -2533,24 +2686,30 @@ static void btf_enum_log(struct btf_verifier_env *env,
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
 
+	btf_show_start_type(show, t);
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
+		btf_show_end_type(show, NULL);
+		return;
 	}
 
-	seq_printf(m, "%d", v);
+	btf_show_type_value(show, "%d", v);
+	btf_show_end_type(show, NULL);
 }
 
 static struct btf_kind_operations enum_ops = {
@@ -2559,7 +2718,7 @@ static void btf_enum_seq_show(const struct btf *btf, const struct btf_type *t,
 	.check_member = btf_enum_check_member,
 	.check_kflag_member = btf_enum_check_kflag_member,
 	.log_details = btf_enum_log,
-	.seq_show = btf_enum_seq_show,
+	.show = btf_enum_show,
 };
 
 static s32 btf_func_proto_check_meta(struct btf_verifier_env *env,
@@ -2646,7 +2805,7 @@ static void btf_func_proto_log(struct btf_verifier_env *env,
 	.check_member = btf_df_check_member,
 	.check_kflag_member = btf_df_check_kflag_member,
 	.log_details = btf_func_proto_log,
-	.seq_show = btf_df_seq_show,
+	.show = btf_df_show,
 };
 
 static s32 btf_func_check_meta(struct btf_verifier_env *env,
@@ -2680,7 +2839,7 @@ static s32 btf_func_check_meta(struct btf_verifier_env *env,
 	.check_member = btf_df_check_member,
 	.check_kflag_member = btf_df_check_kflag_member,
 	.log_details = btf_ref_type_log,
-	.seq_show = btf_df_seq_show,
+	.show = btf_df_show,
 };
 
 static s32 btf_var_check_meta(struct btf_verifier_env *env,
@@ -2744,7 +2903,7 @@ static void btf_var_log(struct btf_verifier_env *env, const struct btf_type *t)
 	.check_member		= btf_df_check_member,
 	.check_kflag_member	= btf_df_check_kflag_member,
 	.log_details		= btf_var_log,
-	.seq_show		= btf_var_seq_show,
+	.show			= btf_var_show,
 };
 
 static s32 btf_datasec_check_meta(struct btf_verifier_env *env,
@@ -2870,24 +3029,26 @@ static void btf_datasec_log(struct btf_verifier_env *env,
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
+	btf_show_start_type(show, t);
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
+	btf_show_end_type(show, "}");
 }
 
 static const struct btf_kind_operations datasec_ops = {
@@ -2896,7 +3057,7 @@ static void btf_datasec_seq_show(const struct btf *btf,
 	.check_member		= btf_df_check_member,
 	.check_kflag_member	= btf_df_check_kflag_member,
 	.log_details		= btf_datasec_log,
-	.seq_show		= btf_datasec_seq_show,
+	.show			= btf_datasec_show,
 };
 
 static int btf_func_proto_check(struct btf_verifier_env *env,
@@ -4487,12 +4648,87 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
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
+	show->type = NULL;
+	show->member = NULL;
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
+	sseq.flags = 0;
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
+	if (ssnprintf->len < 0)
+		return;
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

