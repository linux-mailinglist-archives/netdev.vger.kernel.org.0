Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD27D1F5F
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbfJJEP3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 00:15:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55342 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732816AbfJJEP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:15:28 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A4EoUG025412
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 21:15:26 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhm0ua7rd-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:15:26 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 21:15:25 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9BA4B760CF9; Wed,  9 Oct 2019 21:15:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 10/12] bpf: check types of arguments passed into helpers
Date:   Wed, 9 Oct 2019 21:15:01 -0700
Message-ID: <20191010041503.2526303-11-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010041503.2526303-1-ast@kernel.org>
References: <20191010041503.2526303-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_02:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new helper that reuses existing skb perf_event output
implementation, but can be called from raw_tracepoint programs
that receive 'struct sk_buff *' as tracepoint argument or
can walk other kernel data structures to skb pointer.

In order to do that teach verifier to resolve true C types
of bpf helpers into in-kernel BTF ids.
The type of kernel pointer passed by raw tracepoint into bpf
program will be tracked by the verifier all the way until
it's passed into helper function.
For example:
kfree_skb() kernel function calls trace_kfree_skb(skb, loc);
bpf programs receives that skb pointer and may eventually
pass it into bpf_skb_output() bpf helper which in-kernel is
implemented via bpf_skb_event_output() kernel function.
Its first argument in the kernel is 'struct sk_buff *'.
The verifier makes sure that types match all the way.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h            | 18 ++++++---
 include/uapi/linux/bpf.h       | 27 +++++++++++++-
 kernel/bpf/btf.c               | 68 ++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          | 44 ++++++++++++++--------
 kernel/trace/bpf_trace.c       |  4 ++
 net/core/filter.c              | 15 +++++++-
 tools/include/uapi/linux/bpf.h | 27 +++++++++++++-
 7 files changed, 180 insertions(+), 23 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6edfe50f1c2c..d3df073f374a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -213,6 +213,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_INT,		/* pointer to int */
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
+	ARG_PTR_TO_BTF_ID,	/* pointer to in-kernel struct */
 };
 
 /* type of values returned from helper functions */
@@ -235,11 +236,17 @@ struct bpf_func_proto {
 	bool gpl_only;
 	bool pkt_access;
 	enum bpf_return_type ret_type;
-	enum bpf_arg_type arg1_type;
-	enum bpf_arg_type arg2_type;
-	enum bpf_arg_type arg3_type;
-	enum bpf_arg_type arg4_type;
-	enum bpf_arg_type arg5_type;
+	union {
+		struct {
+			enum bpf_arg_type arg1_type;
+			enum bpf_arg_type arg2_type;
+			enum bpf_arg_type arg3_type;
+			enum bpf_arg_type arg4_type;
+			enum bpf_arg_type arg5_type;
+		};
+		enum bpf_arg_type arg_type[5];
+	};
+	u32 *btf_id; /* BTF ids of arguments */
 };
 
 /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
@@ -765,6 +772,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
+u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *, int);
 
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 3bb2cd1de341..b0454440186f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2751,6 +2751,30 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_skb_output(void *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
+ * 	Description
+ * 		Write raw *data* blob into a special BPF perf event held by
+ * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
+ * 		event must have the following attributes: **PERF_SAMPLE_RAW**
+ * 		as **sample_type**, **PERF_TYPE_SOFTWARE** as **type**, and
+ * 		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.
+ *
+ * 		The *flags* are used to indicate the index in *map* for which
+ * 		the value must be put, masked with **BPF_F_INDEX_MASK**.
+ * 		Alternatively, *flags* can be set to **BPF_F_CURRENT_CPU**
+ * 		to indicate that the index of the current CPU core should be
+ * 		used.
+ *
+ * 		The value to write, of *size*, is passed through eBPF stack and
+ * 		pointed by *data*.
+ *
+ * 		*ctx* is a pointer to in-kernel sutrct sk_buff.
+ *
+ * 		This helper is similar to **bpf_perf_event_output**\ () but
+ * 		restricted to raw_tracepoint bpf programs.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2863,7 +2887,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(skb_output),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 01f929566e8d..45b71a73356d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3622,6 +3622,74 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
+u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn, int arg)
+{
+	char fnname[KSYM_SYMBOL_LEN + 4] = "btf_";
+	const struct btf_param *args;
+	const struct btf_type *t;
+	const char *tname, *sym;
+	u32 btf_id, i;
+
+	if (IS_ERR(btf_vmlinux)) {
+		bpf_log(log, "btf_vmlinux is malformed\n");
+		return -EINVAL;
+	}
+
+	sym = kallsyms_lookup((long)fn, NULL, NULL, NULL, fnname + 4);
+	if (!sym) {
+		bpf_log(log, "kernel doesn't have kallsyms\n");
+		return -EFAULT;
+	}
+
+	for (i = 1; i <= btf_vmlinux->nr_types; i++) {
+		t = btf_type_by_id(btf_vmlinux, i);
+		if (BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF)
+			continue;
+		tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
+		if (!strcmp(tname, fnname))
+			break;
+	}
+	if (i > btf_vmlinux->nr_types) {
+		bpf_log(log, "helper %s type is not found\n", fnname);
+		return -ENOENT;
+	}
+
+	t = btf_type_by_id(btf_vmlinux, t->type);
+	if (!btf_type_is_ptr(t))
+		return -EFAULT;
+	t = btf_type_by_id(btf_vmlinux, t->type);
+	if (!btf_type_is_func_proto(t))
+		return -EFAULT;
+
+	args = (const struct btf_param *)(t + 1);
+	if (arg >= btf_type_vlen(t)) {
+		bpf_log(log, "bpf helper %s doesn't have %d-th argument\n",
+			fnname, arg);
+		return -EINVAL;
+	}
+
+	t = btf_type_by_id(btf_vmlinux, args[arg].type);
+	if (!btf_type_is_ptr(t) || !t->type) {
+		/* anything but the pointer to struct is a helper config bug */
+		bpf_log(log, "ARG_PTR_TO_BTF is misconfigured\n");
+		return -EFAULT;
+	}
+	btf_id = t->type;
+	t = btf_type_by_id(btf_vmlinux, t->type);
+	/* skip modifiers */
+	while (btf_type_is_modifier(t)) {
+		btf_id = t->type;
+		t = btf_type_by_id(btf_vmlinux, t->type);
+	}
+	if (!btf_type_is_struct(t)) {
+		bpf_log(log, "ARG_PTR_TO_BTF is not a struct\n");
+		return -EFAULT;
+	}
+	bpf_log(log, "helper %s arg%d has btf_id %d struct %s\n", fnname + 4,
+		arg, btf_id, __btf_name_by_offset(btf_vmlinux, t->name_off));
+	return btf_id;
+}
+
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3404caa2f196..d04eb66b815a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -205,6 +205,7 @@ struct bpf_call_arg_meta {
 	u64 msize_umax_value;
 	int ref_obj_id;
 	int func_id;
+	u32 btf_id;
 };
 
 struct btf *btf_vmlinux;
@@ -3384,6 +3385,22 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		expected_type = PTR_TO_SOCKET;
 		if (type != expected_type)
 			goto err_type;
+	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
+		expected_type = PTR_TO_BTF_ID;
+		if (type != expected_type)
+			goto err_type;
+		if (reg->btf_id != meta->btf_id) {
+			verbose(env, "Helper has type %s got %s in R%d\n",
+				kernel_type_name(meta->btf_id),
+				kernel_type_name(reg->btf_id), regno);
+
+			return -EACCES;
+		}
+		if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
+			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
+				regno);
+			return -EACCES;
+		}
 	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
 		if (meta->func_id == BPF_FUNC_spin_lock) {
 			if (process_spin_lock(env, regno, true))
@@ -3531,6 +3548,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_PERF_EVENT_ARRAY:
 		if (func_id != BPF_FUNC_perf_event_read &&
 		    func_id != BPF_FUNC_perf_event_output &&
+		    func_id != BPF_FUNC_skb_output &&
 		    func_id != BPF_FUNC_perf_event_read_value)
 			goto error;
 		break;
@@ -3618,6 +3636,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_FUNC_perf_event_read:
 	case BPF_FUNC_perf_event_output:
 	case BPF_FUNC_perf_event_read_value:
+	case BPF_FUNC_skb_output:
 		if (map->map_type != BPF_MAP_TYPE_PERF_EVENT_ARRAY)
 			goto error;
 		break;
@@ -4072,21 +4091,16 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 
 	meta.func_id = func_id;
 	/* check args */
-	err = check_func_arg(env, BPF_REG_1, fn->arg1_type, &meta);
-	if (err)
-		return err;
-	err = check_func_arg(env, BPF_REG_2, fn->arg2_type, &meta);
-	if (err)
-		return err;
-	err = check_func_arg(env, BPF_REG_3, fn->arg3_type, &meta);
-	if (err)
-		return err;
-	err = check_func_arg(env, BPF_REG_4, fn->arg4_type, &meta);
-	if (err)
-		return err;
-	err = check_func_arg(env, BPF_REG_5, fn->arg5_type, &meta);
-	if (err)
-		return err;
+	for (i = 0; i < 5; i++) {
+		if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID) {
+			if (!fn->btf_id[i])
+				fn->btf_id[i] = btf_resolve_helper_id(&env->log, fn->func, 0);
+			meta.btf_id = fn->btf_id[i];
+		}
+		err = check_func_arg(env, BPF_REG_1 + i, fn->arg_type[i], &meta);
+		if (err)
+			return err;
+	}
 
 	err = record_func_map(env, &meta, func_id, insn_idx);
 	if (err)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6221e8c6ecc3..52f7e9d8c29b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -995,6 +995,8 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+extern const struct bpf_func_proto bpf_skb_output_proto;
+
 BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
 	   struct bpf_map *, map, u64, flags)
 {
@@ -1053,6 +1055,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	switch (func_id) {
 	case BPF_FUNC_perf_event_output:
 		return &bpf_perf_event_output_proto_raw_tp;
+	case BPF_FUNC_skb_output:
+		return &bpf_skb_output_proto;
 	case BPF_FUNC_get_stackid:
 		return &bpf_get_stackid_proto_raw_tp;
 	case BPF_FUNC_get_stack:
diff --git a/net/core/filter.c b/net/core/filter.c
index ed6563622ce3..c48fe0971b25 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3798,7 +3798,7 @@ BPF_CALL_5(bpf_skb_event_output, struct sk_buff *, skb, struct bpf_map *, map,
 
 	if (unlikely(flags & ~(BPF_F_CTXLEN_MASK | BPF_F_INDEX_MASK)))
 		return -EINVAL;
-	if (unlikely(skb_size > skb->len))
+	if (unlikely(!skb || skb_size > skb->len))
 		return -EFAULT;
 
 	return bpf_event_output(map, flags, meta, meta_size, skb, skb_size,
@@ -3816,6 +3816,19 @@ static const struct bpf_func_proto bpf_skb_event_output_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+static u32 bpf_skb_output_btf_ids[5];
+const struct bpf_func_proto bpf_skb_output_proto = {
+	.func		= bpf_skb_event_output,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_CONST_MAP_PTR,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
+	.btf_id		= bpf_skb_output_btf_ids,
+};
+
 static unsigned short bpf_tunnel_key_af(u64 flags)
 {
 	return flags & BPF_F_TUNINFO_IPV6 ? AF_INET6 : AF_INET;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3bb2cd1de341..b0454440186f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2751,6 +2751,30 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_skb_output(void *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
+ * 	Description
+ * 		Write raw *data* blob into a special BPF perf event held by
+ * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
+ * 		event must have the following attributes: **PERF_SAMPLE_RAW**
+ * 		as **sample_type**, **PERF_TYPE_SOFTWARE** as **type**, and
+ * 		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.
+ *
+ * 		The *flags* are used to indicate the index in *map* for which
+ * 		the value must be put, masked with **BPF_F_INDEX_MASK**.
+ * 		Alternatively, *flags* can be set to **BPF_F_CURRENT_CPU**
+ * 		to indicate that the index of the current CPU core should be
+ * 		used.
+ *
+ * 		The value to write, of *size*, is passed through eBPF stack and
+ * 		pointed by *data*.
+ *
+ * 		*ctx* is a pointer to in-kernel sutrct sk_buff.
+ *
+ * 		This helper is similar to **bpf_perf_event_output**\ () but
+ * 		restricted to raw_tracepoint bpf programs.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2863,7 +2887,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(skb_output),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.23.0

