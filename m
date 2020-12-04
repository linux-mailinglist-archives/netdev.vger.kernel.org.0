Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FCE2CF452
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgLDSuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:50:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59844 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgLDSu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:50:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Id5qq099390;
        Fri, 4 Dec 2020 18:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=/93N649h23mFPKdE9O8nGlSxlC3KmuSOrZrM93ncRgk=;
 b=lTLbUAcn004c7Aw/JvIbnaKTaJKaimdgYMxppp2j7O9jEILmNcgGS/ZI/W8ZbPsscpo7
 +kXa1ZtjDKh+NW9vYwV89Jt8SxFTHO/wafKti0AUKiuK+PaWEMkqF8BeubI1b4wgwMKo
 lrvda/I1NTCXf+roG96Df38F7gdlMgL55d7PHRLAK1lXsUFfJQRktJ4Z6esC6sCeWgSx
 QTX3zAs1G10bXZS5DsSghQqdv6T6qkAfXviSgBKeydmO1Dn75f6WcvS8+gx3O9IHxwn7
 rlpWo4ViGdAkIz1AHiGRoq2/vzKs0sH4HD30bsZCg5SYC60loF8UeAbXekIHiI1Et9Am Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egm4ktq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 18:49:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4IYROo082082;
        Fri, 4 Dec 2020 18:49:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540ayfr5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 18:49:01 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B4In02C006822;
        Fri, 4 Dec 2020 18:49:00 GMT
Received: from localhost.uk.oracle.com (/10.175.205.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 10:49:00 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, yhs@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, haoluo@google.com,
        jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, shuah@kernel.org, lmb@cloudflare.com,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 2/3] bpf: add module support to btf display helpers
Date:   Fri,  4 Dec 2020 18:48:35 +0000
Message-Id: <1607107716-14135-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
References: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=2
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_snprintf_btf and bpf_seq_printf_btf use a "struct btf_ptr *"
argument that specifies type information about the type to
be displayed.  Augment this information to include an object
id.  If this id is 0, the assumption is that it refers
to a core kernel type from vmlinux; otherwise the object id
specifies the module the type is in, or if no such id is
found in the module list, we fall back to vmlinux.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h            | 12 ++++++++++++
 include/uapi/linux/bpf.h       | 13 +++++++------
 kernel/bpf/btf.c               | 18 +++++++++++++++++
 kernel/trace/bpf_trace.c       | 44 +++++++++++++++++++++++++++++++-----------
 tools/include/uapi/linux/bpf.h | 13 +++++++------
 5 files changed, 77 insertions(+), 23 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 4c200f5..688786a 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -214,6 +214,14 @@ static inline const struct btf_var_secinfo *btf_type_var_secinfo(
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
 struct btf *btf_parse_vmlinux(void);
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+struct btf *bpf_get_btf_module(__u32 obj_id);
+#else
+static inline struct btf *bpf_get_btf_module(__u32 obj_id)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+#endif
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
 						    u32 type_id)
@@ -225,6 +233,10 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 {
 	return NULL;
 }
+static inline struct btf *bpf_get_btf_module(__u32 obj_id)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
 #endif
 
 #endif
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1233f14..ccb75299 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3641,7 +3641,9 @@ struct bpf_stack_build_id {
  *		the pointer data is carried out to avoid kernel crashes during
  *		operation.  Smaller types can use string space on the stack;
  *		larger programs can use map data to store the string
- *		representation.
+ *		representation.  Module-specific data structures can be
+ *		displayed if the module BTF object id is supplied in the
+ *		*ptr*->obj_id field.
  *
  *		The string can be subsequently shared with userspace via
  *		bpf_perf_event_output() or ring buffer interfaces.
@@ -5115,15 +5117,14 @@ struct bpf_sk_lookup {
 /*
  * struct btf_ptr is used for typed pointer representation; the
  * type id is used to render the pointer data as the appropriate type
- * via the bpf_snprintf_btf() helper described above.  A flags field -
- * potentially to specify additional details about the BTF pointer
- * (rather than its mode of display) - is included for future use.
- * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
+ * via the bpf_snprintf_btf() helper described above.  The obj_id
+ * is used to specify an object id (such as a module); if unset
+ * a core vmlinux type id is assumed.
  */
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
-	__u32 flags;		/* BTF ptr flags; unused at present. */
+	__u32 obj_id;		/* BTF object; vmlinux if 0 */
 };
 
 /*
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 333f41c..8ee691e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5777,6 +5777,24 @@ struct btf_module {
 	return len;
 }
 
+struct btf *bpf_get_btf_module(__u32 obj_id)
+{
+	struct btf *btf = ERR_PTR(-ENOENT);
+	struct btf_module *btf_mod;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(btf_mod, &btf_modules, list) {
+		if (!btf_mod->btf || obj_id != btf_mod->btf->id)
+			continue;
+
+		refcount_inc(&btf_mod->btf->refcnt);
+		btf = btf_mod->btf;
+		break;
+	}
+	rcu_read_unlock();
+	return btf;
+}
+
 static void btf_module_free(struct rcu_head *rcu)
 {
 	struct btf_module *btf_mod = container_of(rcu, struct btf_module, rcu);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 23a390a..66d4120 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -75,8 +75,8 @@ static struct bpf_raw_event_map *bpf_get_raw_tracepoint_module(const char *name)
 u64 bpf_get_stack(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
 static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
-				  u64 flags, const struct btf **btf,
-				  s32 *btf_id);
+				  u64 flags, struct btf **btf,
+				  bool *btf_is_vmlinux, s32 *btf_id);
 
 /**
  * trace_call_bpf - invoke BPF program
@@ -786,15 +786,22 @@ struct bpf_seq_printf_buf {
 BPF_CALL_4(bpf_seq_printf_btf, struct seq_file *, m, struct btf_ptr *, ptr,
 	   u32, btf_ptr_size, u64, flags)
 {
-	const struct btf *btf;
+	bool btf_is_vmlinux;
+	struct btf *btf;
 	s32 btf_id;
 	int ret;
 
-	ret = bpf_btf_printf_prepare(ptr, btf_ptr_size, flags, &btf, &btf_id);
+	ret = bpf_btf_printf_prepare(ptr, btf_ptr_size, flags, &btf,
+				     &btf_is_vmlinux, &btf_id);
 	if (ret)
 		return ret;
 
-	return btf_type_seq_show_flags(btf, btf_id, ptr->ptr, m, flags);
+	ret = btf_type_seq_show_flags(btf, btf_id, ptr->ptr, m, flags);
+	/* modules refcount their BTF */
+	if (!btf_is_vmlinux)
+		btf_put(btf);
+
+	return ret;
 }
 
 static const struct bpf_func_proto bpf_seq_printf_btf_proto = {
@@ -1205,7 +1212,8 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 			 BTF_F_PTR_RAW | BTF_F_ZERO)
 
 static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
-				  u64 flags, const struct btf **btf,
+				  u64 flags, struct btf **btf,
+				  bool *btf_is_vmlinux,
 				  s32 *btf_id)
 {
 	const struct btf_type *t;
@@ -1216,7 +1224,14 @@ static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
 	if (btf_ptr_size != sizeof(struct btf_ptr))
 		return -EINVAL;
 
-	*btf = bpf_get_btf_vmlinux();
+	*btf_is_vmlinux = false;
+
+	if (ptr->obj_id > 0)
+		*btf = bpf_get_btf_module(ptr->obj_id);
+	if (ptr->obj_id == 0 || IS_ERR(*btf)) {
+		*btf = bpf_get_btf_vmlinux();
+		*btf_is_vmlinux = true;
+	}
 
 	if (IS_ERR_OR_NULL(*btf))
 		return PTR_ERR(*btf);
@@ -1237,16 +1252,23 @@ static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
 BPF_CALL_5(bpf_snprintf_btf, char *, str, u32, str_size, struct btf_ptr *, ptr,
 	   u32, btf_ptr_size, u64, flags)
 {
-	const struct btf *btf;
+	bool btf_is_vmlinux;
+	struct btf *btf;
 	s32 btf_id;
 	int ret;
 
-	ret = bpf_btf_printf_prepare(ptr, btf_ptr_size, flags, &btf, &btf_id);
+	ret = bpf_btf_printf_prepare(ptr, btf_ptr_size, flags, &btf,
+				     &btf_is_vmlinux, &btf_id);
 	if (ret)
 		return ret;
 
-	return btf_type_snprintf_show(btf, btf_id, ptr->ptr, str, str_size,
-				      flags);
+	ret = btf_type_snprintf_show(btf, btf_id, ptr->ptr, str, str_size,
+				     flags);
+	/* modules refcount their BTF */
+	if (!btf_is_vmlinux)
+		btf_put(btf);
+
+	return ret;
 }
 
 const struct bpf_func_proto bpf_snprintf_btf_proto = {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1233f14..ccb75299 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3641,7 +3641,9 @@ struct bpf_stack_build_id {
  *		the pointer data is carried out to avoid kernel crashes during
  *		operation.  Smaller types can use string space on the stack;
  *		larger programs can use map data to store the string
- *		representation.
+ *		representation.  Module-specific data structures can be
+ *		displayed if the module BTF object id is supplied in the
+ *		*ptr*->obj_id field.
  *
  *		The string can be subsequently shared with userspace via
  *		bpf_perf_event_output() or ring buffer interfaces.
@@ -5115,15 +5117,14 @@ struct bpf_sk_lookup {
 /*
  * struct btf_ptr is used for typed pointer representation; the
  * type id is used to render the pointer data as the appropriate type
- * via the bpf_snprintf_btf() helper described above.  A flags field -
- * potentially to specify additional details about the BTF pointer
- * (rather than its mode of display) - is included for future use.
- * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
+ * via the bpf_snprintf_btf() helper described above.  The obj_id
+ * is used to specify an object id (such as a module); if unset
+ * a core vmlinux type id is assumed.
  */
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
-	__u32 flags;		/* BTF ptr flags; unused at present. */
+	__u32 obj_id;		/* BTF object; vmlinux if 0 */
 };
 
 /*
-- 
1.8.3.1

