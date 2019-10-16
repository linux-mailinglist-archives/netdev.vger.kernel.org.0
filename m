Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE752D8665
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390963AbfJPDZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:25:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5464 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388957AbfJPDZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:25:26 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G3KrjA004217
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:23 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnkjd20gq-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:23 -0700
Received: from 2401:db00:2050:5076:face:0:9:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 15 Oct 2019 20:25:21 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id EBB6E760F32; Tue, 15 Oct 2019 20:25:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 06/11] bpf: implement accurate raw_tp context access via BTF
Date:   Tue, 15 Oct 2019 20:25:00 -0700
Message-ID: <20191016032505.2089704-7-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016032505.2089704-1-ast@kernel.org>
References: <20191016032505.2089704-1-ast@kernel.org>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_01:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=1 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1034
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf analyzes bpf C program, searches in-kernel BTF for given type name
and stores it into expected_attach_type.
The kernel verifier expects this btf_id to point to something like:
typedef void (*btf_trace_kfree_skb)(void *, struct sk_buff *skb, void *loc);
which represents signature of raw_tracepoint "kfree_skb".

Then btf_ctx_access() matches ctx+0 access in bpf program with 'skb'
and 'ctx+8' access with 'loc' arguments of "kfree_skb" tracepoint.
In first case it passes btf_id of 'struct sk_buff *' back to the verifier core
and 'void *' in second case.

Then the verifier tracks PTR_TO_BTF_ID as any other pointer type.
Like PTR_TO_SOCKET points to 'struct bpf_sock',
PTR_TO_TCP_SOCK points to 'struct bpf_tcp_sock', and so on.
PTR_TO_BTF_ID points to in-kernel structs.
If 1234 is btf_id of 'struct sk_buff' in vmlinux's BTF
then PTR_TO_BTF_ID#1234 points to one of in kernel skbs.

When PTR_TO_BTF_ID#1234 is dereferenced (like r2 = *(u64 *)r1 + 32)
the btf_struct_access() checks which field of 'struct sk_buff' is
at offset 32. Checks that size of access matches type definition
of the field and continues to track the dereferenced type.
If that field was a pointer to 'struct net_device' the r2's type
will be PTR_TO_BTF_ID#456. Where 456 is btf_id of 'struct net_device'
in vmlinux's BTF.

Such verifier analysis prevents "cheating" in BPF C program.
The program cannot cast arbitrary pointer to 'struct sk_buff *'
and access it. C compiler would allow type cast, of course,
but the verifier will notice type mismatch based on BPF assembly
and in-kernel BTF.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h          |  17 +++-
 include/linux/bpf_verifier.h |   4 +
 kernel/bpf/btf.c             | 190 +++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c        |  88 +++++++++++++++-
 kernel/trace/bpf_trace.c     |   2 +-
 5 files changed, 296 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f916380675dd..028555fcd10d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -16,6 +16,7 @@
 #include <linux/u64_stats_sync.h>
 
 struct bpf_verifier_env;
+struct bpf_verifier_log;
 struct perf_event;
 struct bpf_prog;
 struct bpf_map;
@@ -281,6 +282,7 @@ enum bpf_reg_type {
 	PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
+	PTR_TO_BTF_ID,		 /* reg points to kernel struct */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -288,7 +290,11 @@ enum bpf_reg_type {
  */
 struct bpf_insn_access_aux {
 	enum bpf_reg_type reg_type;
-	int ctx_field_size;
+	union {
+		int ctx_field_size;
+		u32 btf_id;
+	};
+	struct bpf_verifier_log *log; /* for verbose logs */
 };
 
 static inline void
@@ -483,6 +489,7 @@ struct bpf_event_entry {
 
 bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
 int bpf_prog_calc_tag(struct bpf_prog *fp);
+const char *kernel_type_name(u32 btf_type_id);
 
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
 
@@ -748,6 +755,14 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 				     const union bpf_attr *kattr,
 				     union bpf_attr __user *uattr);
+bool btf_ctx_access(int off, int size, enum bpf_access_type type,
+		    const struct bpf_prog *prog,
+		    struct bpf_insn_access_aux *info);
+int btf_struct_access(struct bpf_verifier_log *log,
+		      const struct btf_type *t, int off, int size,
+		      enum bpf_access_type atype,
+		      u32 *next_btf_id);
+
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 713efae62e96..6e7284ea1468 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -52,6 +52,8 @@ struct bpf_reg_state {
 		 */
 		struct bpf_map *map_ptr;
 
+		u32 btf_id; /* for PTR_TO_BTF_ID */
+
 		/* Max size from any of the above. */
 		unsigned long raw;
 	};
@@ -399,6 +401,8 @@ __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
 				      const char *fmt, va_list args);
 __printf(2, 3) void bpf_verifier_log_write(struct bpf_verifier_env *env,
 					   const char *fmt, ...);
+__printf(2, 3) void bpf_log(struct bpf_verifier_log *log,
+			    const char *fmt, ...);
 
 static inline struct bpf_func_state *cur_func(struct bpf_verifier_env *env)
 {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ddeab1e8d21e..271d27cd427f 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3436,6 +3436,196 @@ struct btf *btf_parse_vmlinux(void)
 	return ERR_PTR(err);
 }
 
+extern struct btf *btf_vmlinux;
+
+bool btf_ctx_access(int off, int size, enum bpf_access_type type,
+		    const struct bpf_prog *prog,
+		    struct bpf_insn_access_aux *info)
+{
+	struct bpf_verifier_log *log = info->log;
+	u32 btf_id = prog->aux->attach_btf_id;
+	const struct btf_param *args;
+	const struct btf_type *t;
+	const char prefix[] = "btf_trace_";
+	const char *tname;
+	u32 nr_args, arg;
+
+	if (!btf_id)
+		return true;
+
+	if (IS_ERR(btf_vmlinux)) {
+		bpf_log(log, "btf_vmlinux is malformed\n");
+		return false;
+	}
+
+	t = btf_type_by_id(btf_vmlinux, btf_id);
+	if (!t || BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
+		bpf_log(log, "btf_id is invalid\n");
+		return false;
+	}
+
+	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
+	if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
+		bpf_log(log, "btf_id points to wrong type name %s\n", tname);
+		return false;
+	}
+	tname += sizeof(prefix) - 1;
+
+	t = btf_type_by_id(btf_vmlinux, t->type);
+	if (!btf_type_is_ptr(t))
+		return false;
+	t = btf_type_by_id(btf_vmlinux, t->type);
+	if (!btf_type_is_func_proto(t))
+		return false;
+
+	if (off % 8) {
+		bpf_log(log, "raw_tp '%s' offset %d is not multiple of 8\n",
+			tname, off);
+		return false;
+	}
+	arg = off / 8;
+	args = (const struct btf_param *)(t + 1);
+	/* skip first 'void *__data' argument in btf_trace_##name typedef */
+	args++;
+	nr_args = btf_type_vlen(t) - 1;
+	if (arg >= nr_args) {
+		bpf_log(log, "raw_tp '%s' doesn't have %d-th argument\n",
+			tname, arg);
+		return false;
+	}
+
+	t = btf_type_by_id(btf_vmlinux, args[arg].type);
+	/* skip modifiers */
+	while (btf_type_is_modifier(t))
+		t = btf_type_by_id(btf_vmlinux, t->type);
+	if (btf_type_is_int(t))
+		/* accessing a scalar */
+		return true;
+	if (!btf_type_is_ptr(t)) {
+		bpf_log(log,
+			"raw_tp '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
+			tname, arg,
+			__btf_name_by_offset(btf_vmlinux, t->name_off),
+			btf_kind_str[BTF_INFO_KIND(t->info)]);
+		return false;
+	}
+	if (t->type == 0)
+		/* This is a pointer to void.
+		 * It is the same as scalar from the verifier safety pov.
+		 * No further pointer walking is allowed.
+		 */
+		return true;
+
+	/* this is a pointer to another type */
+	info->reg_type = PTR_TO_BTF_ID;
+	info->btf_id = t->type;
+
+	t = btf_type_by_id(btf_vmlinux, t->type);
+	/* skip modifiers */
+	while (btf_type_is_modifier(t))
+		t = btf_type_by_id(btf_vmlinux, t->type);
+	if (!btf_type_is_struct(t)) {
+		bpf_log(log,
+			"raw_tp '%s' arg%d type %s is not a struct\n",
+			tname, arg, btf_kind_str[BTF_INFO_KIND(t->info)]);
+		return false;
+	}
+	bpf_log(log, "raw_tp '%s' arg%d has btf_id %d type %s '%s'\n",
+		tname, arg, info->btf_id, btf_kind_str[BTF_INFO_KIND(t->info)],
+		__btf_name_by_offset(btf_vmlinux, t->name_off));
+	return true;
+}
+
+int btf_struct_access(struct bpf_verifier_log *log,
+		      const struct btf_type *t, int off, int size,
+		      enum bpf_access_type atype,
+		      u32 *next_btf_id)
+{
+	const struct btf_member *member;
+	const struct btf_type *mtype;
+	const char *tname, *mname;
+	int i, moff = 0, msize;
+
+again:
+	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
+	if (!btf_type_is_struct(t)) {
+		bpf_log(log, "Type '%s' is not a struct", tname);
+		return -EINVAL;
+	}
+
+	for_each_member(i, t, member) {
+		/* offset of the field in bits */
+		moff = btf_member_bit_offset(t, member);
+
+		if (btf_member_bitfield_size(t, member))
+			/* bitfields are not supported yet */
+			continue;
+
+		if (off + size <= moff / 8)
+			/* won't find anything, field is already too far */
+			break;
+
+		/* type of the field */
+		mtype = btf_type_by_id(btf_vmlinux, member->type);
+		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
+
+		/* skip modifiers */
+		while (btf_type_is_modifier(mtype))
+			mtype = btf_type_by_id(btf_vmlinux, mtype->type);
+
+		if (btf_type_is_array(mtype))
+			/* array deref is not supported yet */
+			continue;
+
+		if (!btf_type_has_size(mtype) && !btf_type_is_ptr(mtype)) {
+			bpf_log(log, "field %s doesn't have size\n", mname);
+			return -EFAULT;
+		}
+		if (btf_type_is_ptr(mtype))
+			msize = 8;
+		else
+			msize = mtype->size;
+		if (off >= moff / 8 + msize)
+			/* no overlap with member, keep iterating */
+			continue;
+		/* the 'off' we're looking for is either equal to start
+		 * of this field or inside of this struct
+		 */
+		if (btf_type_is_struct(mtype)) {
+			/* our field must be inside that union or struct */
+			t = mtype;
+
+			/* adjust offset we're looking for */
+			off -= moff / 8;
+			goto again;
+		}
+		if (msize != size) {
+			/* field access size doesn't match */
+			bpf_log(log,
+				"cannot access %d bytes in struct %s field %s that has size %d\n",
+				size, tname, mname, msize);
+			return -EACCES;
+		}
+
+		if (btf_type_is_ptr(mtype)) {
+			const struct btf_type *stype;
+
+			stype = btf_type_by_id(btf_vmlinux, mtype->type);
+			/* skip modifiers */
+			while (btf_type_is_modifier(stype))
+				stype = btf_type_by_id(btf_vmlinux, stype->type);
+			if (btf_type_is_struct(stype)) {
+				*next_btf_id = mtype->type;
+				return PTR_TO_BTF_ID;
+			}
+		}
+		/* all other fields are treated as scalars */
+		return SCALAR_VALUE;
+	}
+	bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
+	return -EINVAL;
+}
+
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 466b3b19de4d..42a463e09761 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -286,6 +286,19 @@ __printf(2, 3) static void verbose(void *private_data, const char *fmt, ...)
 	va_end(args);
 }
 
+__printf(2, 3) void bpf_log(struct bpf_verifier_log *log,
+			    const char *fmt, ...)
+{
+	va_list args;
+
+	if (!bpf_verifier_log_needed(log))
+		return;
+
+	va_start(args, fmt);
+	bpf_verifier_vlog(log, fmt, args);
+	va_end(args);
+}
+
 static const char *ltrim(const char *s)
 {
 	while (isspace(*s))
@@ -406,6 +419,7 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
+	[PTR_TO_BTF_ID]		= "ptr_",
 };
 
 static char slot_type_char[] = {
@@ -436,6 +450,12 @@ static struct bpf_func_state *func(struct bpf_verifier_env *env,
 	return cur->frame[reg->frameno];
 }
 
+const char *kernel_type_name(u32 id)
+{
+	return btf_name_by_offset(btf_vmlinux,
+				  btf_type_by_id(btf_vmlinux, id)->name_off);
+}
+
 static void print_verifier_state(struct bpf_verifier_env *env,
 				 const struct bpf_func_state *state)
 {
@@ -460,6 +480,8 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 			/* reg->off should be 0 for SCALAR_VALUE */
 			verbose(env, "%lld", reg->var_off.value + reg->off);
 		} else {
+			if (t == PTR_TO_BTF_ID)
+				verbose(env, "%s", kernel_type_name(reg->btf_id));
 			verbose(env, "(id=%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
 				verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
@@ -2337,10 +2359,12 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 
 /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
 static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
-			    enum bpf_access_type t, enum bpf_reg_type *reg_type)
+			    enum bpf_access_type t, enum bpf_reg_type *reg_type,
+			    u32 *btf_id)
 {
 	struct bpf_insn_access_aux info = {
 		.reg_type = *reg_type,
+		.log = &env->log,
 	};
 
 	if (env->ops->is_valid_access &&
@@ -2354,7 +2378,10 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
 		 */
 		*reg_type = info.reg_type;
 
-		env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
+		if (*reg_type == PTR_TO_BTF_ID)
+			*btf_id = info.btf_id;
+		else
+			env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
 		/* remember the offset of last byte accessed in ctx */
 		if (env->prog->aux->max_ctx_offset < off + size)
 			env->prog->aux->max_ctx_offset = off + size;
@@ -2780,6 +2807,53 @@ static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
 	return 0;
 }
 
+static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
+				   struct bpf_reg_state *regs,
+				   int regno, int off, int size,
+				   enum bpf_access_type atype,
+				   int value_regno)
+{
+	struct bpf_reg_state *reg = regs + regno;
+	const struct btf_type *t = btf_type_by_id(btf_vmlinux, reg->btf_id);
+	const char *tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+	u32 btf_id;
+	int ret;
+
+	if (atype != BPF_READ) {
+		verbose(env, "only read is supported\n");
+		return -EACCES;
+	}
+
+	if (off < 0) {
+		verbose(env,
+			"R%d is ptr_%s invalid negative access: off=%d\n",
+			regno, tname, off);
+		return -EACCES;
+	}
+	if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
+		char tn_buf[48];
+
+		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+		verbose(env,
+			"R%d is ptr_%s invalid variable offset: off=%d, var_off=%s\n",
+			regno, tname, off, tn_buf);
+		return -EACCES;
+	}
+
+	ret = btf_struct_access(&env->log, t, off, size, atype, &btf_id);
+	if (ret < 0)
+		return ret;
+
+	if (ret == SCALAR_VALUE) {
+		mark_reg_unknown(env, regs, value_regno);
+		return 0;
+	}
+	mark_reg_known_zero(env, regs, value_regno);
+	regs[value_regno].type = PTR_TO_BTF_ID;
+	regs[value_regno].btf_id = btf_id;
+	return 0;
+}
+
 /* check whether memory at (regno + off) is accessible for t = (read | write)
  * if t==write, value_regno is a register which value is stored into memory
  * if t==read, value_regno is a register which will receive the value from memory
@@ -2840,6 +2914,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		}
 	} else if (reg->type == PTR_TO_CTX) {
 		enum bpf_reg_type reg_type = SCALAR_VALUE;
+		u32 btf_id = 0;
 
 		if (t == BPF_WRITE && value_regno >= 0 &&
 		    is_pointer_value(env, value_regno)) {
@@ -2851,7 +2926,9 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		if (err < 0)
 			return err;
 
-		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type);
+		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf_id);
+		if (err)
+			verbose_linfo(env, insn_idx, "; ");
 		if (!err && t == BPF_READ && value_regno >= 0) {
 			/* ctx access returns either a scalar, or a
 			 * PTR_TO_PACKET[_META,_END]. In the latter
@@ -2870,6 +2947,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 				 * a sub-register.
 				 */
 				regs[value_regno].subreg_def = DEF_NOT_SUBREG;
+				if (reg_type == PTR_TO_BTF_ID)
+					regs[value_regno].btf_id = btf_id;
 			}
 			regs[value_regno].type = reg_type;
 		}
@@ -2929,6 +3008,9 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		err = check_tp_buffer_access(env, reg, regno, off, size);
 		if (!err && t == BPF_READ && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
+	} else if (reg->type == PTR_TO_BTF_ID) {
+		err = check_ptr_to_btf_access(env, regs, regno, off, size, t,
+					      value_regno);
 	} else {
 		verbose(env, "R%d invalid mem access '%s'\n", regno,
 			reg_type_str[reg->type]);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 44bd08f2443b..6221e8c6ecc3 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1074,7 +1074,7 @@ static bool raw_tp_prog_is_valid_access(int off, int size,
 		return false;
 	if (off % size != 0)
 		return false;
-	return true;
+	return btf_ctx_access(off, size, type, prog, info);
 }
 
 const struct bpf_verifier_ops raw_tracepoint_verifier_ops = {
-- 
2.17.1

