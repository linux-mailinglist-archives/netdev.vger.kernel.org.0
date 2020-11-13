Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578B32B2364
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgKMSLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:11:25 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54534 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgKMSLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:11:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI4BQ2173242;
        Fri, 13 Nov 2020 18:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=w4vrIDgu6ef0C0/kfn/CL767r+OiJ8KGsKsmWlo+OQQ=;
 b=L7HSXsdGzwUjg+cXGj+45rEZ09XAsIwDHtIOu1cY7y/a1PBdK5dq8Q07PtR2GS414iJK
 SIH5KARz7kcuUbjcGvcwX1yCy8mQZn5INJFGY3H52Vm93Za6Evvxo764iKlfhKiEHlaP
 ZVoUlkrTO5IDiE3e2fIeGUCdS4LUH7QjAohrqZ9TdMFATm9irmX9S0Bjtovb1xMRdr0f
 hf4hA+5YKmkU3+0wlOhN07tg4y3ED6WX0Tssrt/adPebF13Vot0BxNJCClz3JnLe3NLU
 1UzC4SzSt8qhUABBo9rEzLLKsGBNmblW2+m1PBtFej4ohhWqA5odrWGgj6uQDOdIgR0R Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34nh3bbucf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 18:10:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI6JEi117677;
        Fri, 13 Nov 2020 18:10:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34rtku1w95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 18:10:31 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ADIANGO032160;
        Fri, 13 Nov 2020 18:10:25 GMT
Received: from localhost.uk.oracle.com (/10.175.203.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 10:10:22 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, haoluo@google.com,
        jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC bpf-next 1/3] bpf: add module support to btf display helpers
Date:   Fri, 13 Nov 2020 18:10:11 +0000
Message-Id: <1605291013-22575-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_snprintf_btf and bpf_seq_printf_btf use a "struct btf_ptr *"
argument that specifies type information about the type to
be displayed.  Augment this information to include a module
name, allowing such display to support module types.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h            |  8 ++++++++
 include/uapi/linux/bpf.h       |  5 ++++-
 kernel/bpf/btf.c               | 18 ++++++++++++++++++
 kernel/trace/bpf_trace.c       | 42 ++++++++++++++++++++++++++++++++----------
 tools/include/uapi/linux/bpf.h |  5 ++++-
 5 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 2bf6418..d55ca00 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -209,6 +209,14 @@ static inline const struct btf_var_secinfo *btf_type_var_secinfo(
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
 struct btf *btf_parse_vmlinux(void);
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+struct btf *bpf_get_btf_module(const char *name);
+#else
+static inline struct btf *bpf_get_btf_module(const char *name)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+#endif
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 162999b..26978be 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3636,7 +3636,8 @@ struct bpf_stack_build_id {
  *		the pointer data is carried out to avoid kernel crashes during
  *		operation.  Smaller types can use string space on the stack;
  *		larger programs can use map data to store the string
- *		representation.
+ *		representation.  Module-specific data structures can be
+ *		displayed if the module name is supplied.
  *
  *		The string can be subsequently shared with userspace via
  *		bpf_perf_event_output() or ring buffer interfaces.
@@ -5076,11 +5077,13 @@ struct bpf_sk_lookup {
  * potentially to specify additional details about the BTF pointer
  * (rather than its mode of display) - is included for future use.
  * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
+ * A module name can be specified for module-specific data.
  */
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
 	__u32 flags;		/* BTF ptr flags; unused at present. */
+	const char *module;	/* optional module name. */
 };
 
 /*
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6b2d508..3ddd1fd 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5738,6 +5738,24 @@ struct btf_module {
 static LIST_HEAD(btf_modules);
 static DEFINE_MUTEX(btf_module_mutex);
 
+struct btf *bpf_get_btf_module(const char *name)
+{
+	struct btf *btf = ERR_PTR(-ENOENT);
+	struct btf_module *btf_mod, *tmp;
+
+	mutex_lock(&btf_module_mutex);
+	list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
+		if (!btf_mod->btf || strcmp(name, btf_mod->btf->name) != 0)
+			continue;
+
+		refcount_inc(&btf_mod->btf->refcnt);
+		btf = btf_mod->btf;
+		break;
+	}
+	mutex_unlock(&btf_module_mutex);
+	return btf;
+}
+
 static ssize_t
 btf_module_read(struct file *file, struct kobject *kobj,
 		struct bin_attribute *bin_attr,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index cfce60a..a4d5a26 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -73,8 +73,7 @@ static struct bpf_raw_event_map *bpf_get_raw_tracepoint_module(const char *name)
 u64 bpf_get_stack(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
 static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
-				  u64 flags, const struct btf **btf,
-				  s32 *btf_id);
+				  u64 flags, struct btf **btf, s32 *btf_id);
 
 /**
  * trace_call_bpf - invoke BPF program
@@ -784,7 +783,7 @@ struct bpf_seq_printf_buf {
 BPF_CALL_4(bpf_seq_printf_btf, struct seq_file *, m, struct btf_ptr *, ptr,
 	   u32, btf_ptr_size, u64, flags)
 {
-	const struct btf *btf;
+	struct btf *btf;
 	s32 btf_id;
 	int ret;
 
@@ -792,7 +791,11 @@ struct bpf_seq_printf_buf {
 	if (ret)
 		return ret;
 
-	return btf_type_seq_show_flags(btf, btf_id, ptr->ptr, m, flags);
+	ret = btf_type_seq_show_flags(btf, btf_id, ptr->ptr, m, flags);
+	if (btf_ptr_size == sizeof(struct btf_ptr) && ptr->module)
+		btf_put(btf);
+
+	return ret;
 }
 
 static const struct bpf_func_proto bpf_seq_printf_btf_proto = {
@@ -1199,18 +1202,33 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 			 BTF_F_PTR_RAW | BTF_F_ZERO)
 
 static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
-				  u64 flags, const struct btf **btf,
+				  u64 flags, struct btf **btf,
 				  s32 *btf_id)
 {
+	char modname[MODULE_NAME_LEN];
 	const struct btf_type *t;
+	int ret;
 
 	if (unlikely(flags & ~(BTF_F_ALL)))
 		return -EINVAL;
 
-	if (btf_ptr_size != sizeof(struct btf_ptr))
+	/* For backwards compatibility, ensure that we support BPF
+	 * programs compiled with older "struct btf_ptr" definitions
+	 * that lacked the "module" field.
+	 */
+	if (btf_ptr_size != sizeof(struct btf_ptr) &&
+	    btf_ptr_size != sizeof(struct btf_ptr) - sizeof(char *))
 		return -EINVAL;
 
-	*btf = bpf_get_btf_vmlinux();
+	if (btf_ptr_size == sizeof(struct btf_ptr) && ptr->module) {
+		ret = copy_from_kernel_nofault(modname, ptr->module,
+					       sizeof(modname));
+		if (ret)
+			return ret;
+
+		*btf = bpf_get_btf_module(modname);
+	} else
+		*btf = bpf_get_btf_vmlinux();
 
 	if (IS_ERR_OR_NULL(*btf))
 		return PTR_ERR(*btf);
@@ -1231,7 +1249,7 @@ static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
 BPF_CALL_5(bpf_snprintf_btf, char *, str, u32, str_size, struct btf_ptr *, ptr,
 	   u32, btf_ptr_size, u64, flags)
 {
-	const struct btf *btf;
+	struct btf *btf;
 	s32 btf_id;
 	int ret;
 
@@ -1239,8 +1257,12 @@ static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
 	if (ret)
 		return ret;
 
-	return btf_type_snprintf_show(btf, btf_id, ptr->ptr, str, str_size,
-				      flags);
+	ret = btf_type_snprintf_show(btf, btf_id, ptr->ptr, str, str_size,
+				     flags);
+	if (btf_ptr_size == sizeof(struct btf_ptr) && ptr->module)
+		btf_put(btf);
+
+	return ret;
 }
 
 const struct bpf_func_proto bpf_snprintf_btf_proto = {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 162999b..26978be 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3636,7 +3636,8 @@ struct bpf_stack_build_id {
  *		the pointer data is carried out to avoid kernel crashes during
  *		operation.  Smaller types can use string space on the stack;
  *		larger programs can use map data to store the string
- *		representation.
+ *		representation.  Module-specific data structures can be
+ *		displayed if the module name is supplied.
  *
  *		The string can be subsequently shared with userspace via
  *		bpf_perf_event_output() or ring buffer interfaces.
@@ -5076,11 +5077,13 @@ struct bpf_sk_lookup {
  * potentially to specify additional details about the BTF pointer
  * (rather than its mode of display) - is included for future use.
  * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
+ * A module name can be specified for module-specific data.
  */
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
 	__u32 flags;		/* BTF ptr flags; unused at present. */
+	const char *module;	/* optional module name. */
 };
 
 /*
-- 
1.8.3.1

