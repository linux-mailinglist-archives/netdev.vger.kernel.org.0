Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2AEE4082
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 02:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbfJYASR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 20:18:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1980 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732982AbfJYASR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 20:18:17 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9P0HuV9030361
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 17:18:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=NZiG9O33fntUJ/c7gNBy33V3qrchqSEVaLCmusy7340=;
 b=XxI8g7MGyJI8bGqqfpWk+tDappx4n/aGEYCkl5Y5UKhLWp1gweYQafewlaj2xLoQJnWe
 ZPMhziNAIYzYsBT3sE+IKzDLJt0VA1AglWVc96YAtVJjQPh5j0ngHdtwms7KXxaNwO6n
 jPBQB4Fiz+PERqDAH6dT88dbr9erW6zRzoQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vtyd6xak3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 17:18:15 -0700
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 24 Oct 2019 17:18:13 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A3D3B2943218; Thu, 24 Oct 2019 17:18:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] bpf: Prepare btf_ctx_access for non raw_tp use case
Date:   Thu, 24 Oct 2019 17:18:11 -0700
Message-ID: <20191025001811.1718491-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-24_13:2019-10-23,2019-10-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=9
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910250002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes a few changes to btf_ctx_access() to prepare
it for non raw_tp use case where the attach_btf_id is not
necessary a BTF_KIND_TYPEDEF.

It moves the "btf_trace_" prefix check and typedef-follow logic to a new
function "check_attach_btf_id()" which is called only once during
bpf_check().  btf_ctx_access() only operates on a BTF_KIND_FUNC_PROTO
type now. That should also be more efficient since it is done only
one instead of every-time check_ctx_access() is called.

"check_attach_btf_id()" needs to find the func_proto type from
the attach_btf_id.  It needs to store the result into the
newly added prog->aux->attach_func_proto.  func_proto
btf type has no name, so a proper name should be stored into
"attach_func_name" also.

v2:
- Move the "btf_trace_" check to an earlier verifier phase (Alexei)

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h      |  5 +++
 include/linux/btf.h      | 31 +++++++++++++++++
 kernel/bpf/btf.c         | 73 +++++++---------------------------------
 kernel/bpf/syscall.c     |  4 +--
 kernel/bpf/verifier.c    | 52 +++++++++++++++++++++++++++-
 kernel/trace/bpf_trace.c |  2 ++
 6 files changed, 103 insertions(+), 64 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2c2c29b49845..171be30fe0ae 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -392,6 +392,11 @@ struct bpf_prog_aux {
 	u32 attach_btf_id; /* in-kernel BTF type id to attach to */
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
+	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
+	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
+	const struct btf_type *attach_func_proto;
+	/* function name for valid attach_btf_id */
+	const char *attach_func_name;
 	struct bpf_prog **func;
 	void *jit_data; /* JIT specific data. arch dependent */
 	struct latch_tree_node ksym_tnode;
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 55d43bc856be..9dee00859c5f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -5,6 +5,7 @@
 #define _LINUX_BTF_H 1
 
 #include <linux/types.h>
+#include <uapi/linux/btf.h>
 
 struct btf;
 struct btf_member;
@@ -53,6 +54,36 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t);
 bool btf_type_is_void(const struct btf_type *t);
 
+static inline bool btf_type_is_ptr(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_PTR;
+}
+
+static inline bool btf_type_is_int(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
+}
+
+static inline bool btf_type_is_enum(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
+}
+
+static inline bool btf_type_is_typedef(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
+}
+
+static inline bool btf_type_is_func(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC;
+}
+
+static inline bool btf_type_is_func_proto(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
+}
+
 #ifdef CONFIG_BPF_SYSCALL
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f7557af39756..128d89601d73 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -336,16 +336,6 @@ static bool btf_type_is_fwd(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_FWD;
 }
 
-static bool btf_type_is_func(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC;
-}
-
-static bool btf_type_is_func_proto(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
-}
-
 static bool btf_type_nosize(const struct btf_type *t)
 {
 	return btf_type_is_void(t) || btf_type_is_fwd(t) ||
@@ -377,16 +367,6 @@ static bool btf_type_is_array(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_ARRAY;
 }
 
-static bool btf_type_is_ptr(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_PTR;
-}
-
-static bool btf_type_is_int(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
-}
-
 static bool btf_type_is_var(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
@@ -3442,54 +3422,27 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info)
 {
+	const struct btf_type *t = prog->aux->attach_func_proto;
+	const char *tname = prog->aux->attach_func_name;
 	struct bpf_verifier_log *log = info->log;
-	u32 btf_id = prog->aux->attach_btf_id;
 	const struct btf_param *args;
-	const struct btf_type *t;
-	const char prefix[] = "btf_trace_";
-	const char *tname;
 	u32 nr_args, arg;
 
-	if (!btf_id)
-		return true;
-
-	if (IS_ERR(btf_vmlinux)) {
-		bpf_log(log, "btf_vmlinux is malformed\n");
-		return false;
-	}
-
-	t = btf_type_by_id(btf_vmlinux, btf_id);
-	if (!t || BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
-		bpf_log(log, "btf_id is invalid\n");
-		return false;
-	}
-
-	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
-	if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
-		bpf_log(log, "btf_id points to wrong type name %s\n", tname);
-		return false;
-	}
-	tname += sizeof(prefix) - 1;
-
-	t = btf_type_by_id(btf_vmlinux, t->type);
-	if (!btf_type_is_ptr(t))
-		return false;
-	t = btf_type_by_id(btf_vmlinux, t->type);
-	if (!btf_type_is_func_proto(t))
-		return false;
-
 	if (off % 8) {
-		bpf_log(log, "raw_tp '%s' offset %d is not multiple of 8\n",
+		bpf_log(log, "func '%s' offset %d is not multiple of 8\n",
 			tname, off);
 		return false;
 	}
 	arg = off / 8;
 	args = (const struct btf_param *)(t + 1);
-	/* skip first 'void *__data' argument in btf_trace_##name typedef */
-	args++;
-	nr_args = btf_type_vlen(t) - 1;
+	nr_args = btf_type_vlen(t);
+	if (prog->aux->attach_btf_trace) {
+		/* skip first 'void *__data' argument in btf_trace_##name typedef */
+		args++;
+		nr_args--;
+	}
 	if (arg >= nr_args) {
-		bpf_log(log, "raw_tp '%s' doesn't have %d-th argument\n",
+		bpf_log(log, "func '%s' doesn't have %d-th argument\n",
 			tname, arg);
 		return false;
 	}
@@ -3503,7 +3456,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		return true;
 	if (!btf_type_is_ptr(t)) {
 		bpf_log(log,
-			"raw_tp '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
+			"func '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
 			tname, arg,
 			__btf_name_by_offset(btf_vmlinux, t->name_off),
 			btf_kind_str[BTF_INFO_KIND(t->info)]);
@@ -3526,11 +3479,11 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		t = btf_type_by_id(btf_vmlinux, t->type);
 	if (!btf_type_is_struct(t)) {
 		bpf_log(log,
-			"raw_tp '%s' arg%d type %s is not a struct\n",
+			"func '%s' arg%d type %s is not a struct\n",
 			tname, arg, btf_kind_str[BTF_INFO_KIND(t->info)]);
 		return false;
 	}
-	bpf_log(log, "raw_tp '%s' arg%d has btf_id %d type %s '%s'\n",
+	bpf_log(log, "func '%s' arg%d has btf_id %d type %s '%s'\n",
 		tname, arg, info->btf_id, btf_kind_str[BTF_INFO_KIND(t->info)],
 		__btf_name_by_offset(btf_vmlinux, t->name_off));
 	return true;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 16ea3c0db4f6..ff5225759553 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1848,9 +1848,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			goto out_put_prog;
 		}
 		/* raw_tp name is taken from type name instead */
-		tp_name = kernel_type_name(prog->aux->attach_btf_id);
-		/* skip the prefix */
-		tp_name += sizeof("btf_trace_") - 1;
+		tp_name = prog->aux->attach_func_name;
 	} else {
 		if (strncpy_from_user(buf,
 				      u64_to_user_ptr(attr->raw_tracepoint.name),
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 556e82f8869b..c59778c0fc4d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9372,6 +9372,52 @@ static void print_verification_stats(struct bpf_verifier_env *env)
 		env->peak_states, env->longest_mark_read_walk);
 }
 
+static int check_attach_btf_id(struct bpf_verifier_env *env)
+{
+	struct bpf_prog *prog = env->prog;
+	u32 btf_id = prog->aux->attach_btf_id;
+	const struct btf_type *t;
+	const char *tname;
+
+	if (prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT && btf_id) {
+		const char prefix[] = "btf_trace_";
+
+		t = btf_type_by_id(btf_vmlinux, btf_id);
+		if (!t) {
+			verbose(env, "attach_btf_id %u is invalid\n", btf_id);
+			return -EINVAL;
+		}
+		if (!btf_type_is_typedef(t)) {
+			verbose(env, "attach_btf_id %u is not a typedef\n",
+				btf_id);
+			return -EINVAL;
+		}
+		tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+		if (!tname || strncmp(prefix, tname, sizeof(prefix) - 1)) {
+			verbose(env, "attach_btf_id %u points to wrong type name %s\n",
+				btf_id, tname);
+			return -EINVAL;
+		}
+		tname += sizeof(prefix) - 1;
+		t = btf_type_by_id(btf_vmlinux, t->type);
+		if (!btf_type_is_ptr(t))
+			/* should never happen in valid vmlinux build */
+			return -EINVAL;
+		t = btf_type_by_id(btf_vmlinux, t->type);
+		if (!btf_type_is_func_proto(t))
+			/* should never happen in valid vmlinux build */
+			return -EINVAL;
+
+		/* remember two read only pointers that are valid for
+		 * the life time of the kernel
+		 */
+		prog->aux->attach_func_name = tname;
+		prog->aux->attach_func_proto = t;
+		prog->aux->attach_btf_trace = true;
+	}
+	return 0;
+}
+
 int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	      union bpf_attr __user *uattr)
 {
@@ -9435,9 +9481,13 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		/* Either gcc or pahole or kernel are broken. */
 		verbose(env, "in-kernel BTF is malformed\n");
 		ret = PTR_ERR(btf_vmlinux);
-		goto err_unlock;
+		goto skip_full_check;
 	}
 
+	ret = check_attach_btf_id(env);
+	if (ret)
+		goto skip_full_check;
+
 	env->strict_alignment = !!(attr->prog_flags & BPF_F_STRICT_ALIGNMENT);
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		env->strict_alignment = true;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c3240898cc44..571c25d60710 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1080,6 +1080,8 @@ static bool raw_tp_prog_is_valid_access(int off, int size,
 		return false;
 	if (off % size != 0)
 		return false;
+	if (!prog->aux->attach_btf_id)
+		return true;
 	return btf_ctx_access(off, size, type, prog, info);
 }
 
-- 
2.17.1

