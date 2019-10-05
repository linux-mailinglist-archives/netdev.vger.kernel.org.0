Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E06CC807
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 07:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfJEFDf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Oct 2019 01:03:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbfJEFDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 01:03:34 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9550Hif002620
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 22:03:34 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vegdf8v84-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 22:03:34 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 4 Oct 2019 22:03:31 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 3AB4976091D; Fri,  4 Oct 2019 22:03:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 08/10] bpf: check types of arguments passed into helpers
Date:   Fri, 4 Oct 2019 22:03:12 -0700
Message-ID: <20191005050314.1114330-9-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191005050314.1114330-1-ast@kernel.org>
References: <20191005050314.1114330-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_02:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 adultscore=0 spamscore=0 clxscore=1034 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 phishscore=0 suspectscore=1
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910050044
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
 include/linux/bpf.h                       |  3 +
 include/uapi/linux/bpf.h                  |  3 +-
 kernel/bpf/btf.c                          | 73 +++++++++++++++++++++++
 kernel/bpf/verifier.c                     | 29 +++++++++
 kernel/trace/bpf_trace.c                  |  4 ++
 net/core/filter.c                         | 15 ++++-
 tools/include/uapi/linux/bpf.h            |  3 +-
 tools/testing/selftests/bpf/bpf_helpers.h |  4 ++
 8 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0bd9e12150ac..f1690e233e51 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -212,6 +212,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_INT,		/* pointer to int */
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
+	ARG_PTR_TO_BTF_ID,	/* pointer to in-kernel struct */
 };
 
 /* type of values returned from helper functions */
@@ -239,6 +240,7 @@ struct bpf_func_proto {
 	enum bpf_arg_type arg3_type;
 	enum bpf_arg_type arg4_type;
 	enum bpf_arg_type arg5_type;
+	u32 *btf_id; /* BTF ids of arguments */
 };
 
 /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
@@ -762,6 +764,7 @@ int btf_struct_access(struct bpf_verifier_env *env,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
+u32 btf_resolve_helper_id(struct bpf_verifier_env *env, void *, int);
 
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77c6be96d676..3752de7ae50e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2862,7 +2862,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(skb_output),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 61ff8a54ca22..5d516a817d1c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3612,6 +3612,79 @@ int btf_struct_access(struct bpf_verifier_env *env,
 	return -EINVAL;
 }
 
+u32 btf_resolve_helper_id(struct bpf_verifier_env *env, void *fn, int arg)
+{
+	char fnname[KSYM_SYMBOL_LEN + 4] = "btf_";
+	const struct btf_param *args;
+	const struct btf_type *t;
+	const char *tname, *sym;
+	u32 btf_id, i;
+
+	if (IS_ERR(btf_vmlinux)) {
+		bpf_verifier_log_write(env, "btf_vmlinux is malformed\n");
+		return -EINVAL;
+	}
+
+	sym = kallsyms_lookup((long)fn, NULL, NULL, NULL, fnname + 4);
+	if (!sym) {
+		bpf_verifier_log_write(env, "kernel doesn't have kallsyms\n");
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
+		bpf_verifier_log_write(env,
+				       "helper %s type is not found\n",
+				       fnname);
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
+		bpf_verifier_log_write(env,
+				       "bpf helper '%s' doesn't have %d-th argument\n",
+				       fnname, arg);
+		return -EINVAL;
+	}
+
+	t = btf_type_by_id(btf_vmlinux, args[arg].type);
+	if (!btf_type_is_ptr(t) || !t->type) {
+		/* anything but the pointer to struct is a helper config bug */
+		bpf_verifier_log_write(env,
+				       "ARG_PTR_TO_BTF is misconfigured\n");
+
+		return -EFAULT;
+	}
+	btf_id = t->type;
+
+	t = btf_type_by_id(btf_vmlinux, t->type);
+	if (!btf_type_is_struct(t)) {
+		bpf_verifier_log_write(env,
+				       "ARG_PTR_TO_BTF is not a struct\n");
+
+		return -EFAULT;
+	}
+	bpf_verifier_log_write(env,
+			       "helper '%s' arg%d has btf_id %d struct '%s'\n",
+			       fnname + 4, arg, btf_id,
+			       __btf_name_by_offset(btf_vmlinux, t->name_off));
+	return btf_id;
+}
+
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 957ee442f2b4..0717aacb7801 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -205,6 +205,7 @@ struct bpf_call_arg_meta {
 	u64 msize_umax_value;
 	int ref_obj_id;
 	int func_id;
+	u32 btf_id;
 };
 
 struct btf *btf_vmlinux;
@@ -3367,6 +3368,27 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		expected_type = PTR_TO_SOCKET;
 		if (type != expected_type)
 			goto err_type;
+	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
+		expected_type = PTR_TO_BTF_ID;
+		if (type != expected_type)
+			goto err_type;
+		if (reg->btf_id != meta->btf_id) {
+			verbose(env, "Helper has type %s got %s in R%d\n",
+				btf_name_by_offset(btf_vmlinux,
+						   btf_type_by_id(btf_vmlinux,
+								  meta->btf_id)->name_off),
+				btf_name_by_offset(btf_vmlinux,
+						   btf_type_by_id(btf_vmlinux,
+								  reg->btf_id)->name_off),
+				regno);
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
@@ -3514,6 +3536,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_PERF_EVENT_ARRAY:
 		if (func_id != BPF_FUNC_perf_event_read &&
 		    func_id != BPF_FUNC_perf_event_output &&
+		    func_id != BPF_FUNC_skb_output &&
 		    func_id != BPF_FUNC_perf_event_read_value)
 			goto error;
 		break;
@@ -3601,6 +3624,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_FUNC_perf_event_read:
 	case BPF_FUNC_perf_event_output:
 	case BPF_FUNC_perf_event_read_value:
+	case BPF_FUNC_skb_output:
 		if (map->map_type != BPF_MAP_TYPE_PERF_EVENT_ARRAY)
 			goto error;
 		break;
@@ -4053,6 +4077,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		return err;
 	}
 
+	if (fn->arg1_type == ARG_PTR_TO_BTF_ID) {
+		if (!fn->btf_id[0])
+			fn->btf_id[0] = btf_resolve_helper_id(env, fn->func, 0);
+		meta.btf_id = fn->btf_id[0];
+	}
 	meta.func_id = func_id;
 	/* check args */
 	err = check_func_arg(env, BPF_REG_1, fn->arg1_type, &meta);
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
index 77c6be96d676..3752de7ae50e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2862,7 +2862,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(skb_output),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 54a50699bbfd..c5e05d1a806f 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -65,6 +65,10 @@ static int (*bpf_perf_event_output)(void *ctx, void *map,
 				    unsigned long long flags, void *data,
 				    int size) =
 	(void *) BPF_FUNC_perf_event_output;
+static int (*bpf_skb_output)(void *ctx, void *map,
+			     unsigned long long flags, void *data,
+			     int size) =
+	(void *) BPF_FUNC_skb_output;
 static int (*bpf_get_stackid)(void *ctx, void *map, int flags) =
 	(void *) BPF_FUNC_get_stackid;
 static int (*bpf_probe_write_user)(void *dst, const void *src, int size) =
-- 
2.20.0

