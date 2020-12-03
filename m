Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9572CE00E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388356AbgLCUti convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 15:49:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17990 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727289AbgLCUth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:49:37 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KdYra002328
        for <netdev@vger.kernel.org>; Thu, 3 Dec 2020 12:48:51 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 356ajcm3du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:48:51 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 12:48:20 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 13FB92ECA8BF; Thu,  3 Dec 2020 12:48:15 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v6 bpf-next 09/14] bpf: remove hard-coded btf_vmlinux assumption from BPF verifier
Date:   Thu, 3 Dec 2020 12:46:29 -0800
Message-ID: <20201203204634.1325171-10-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203204634.1325171-1-andrii@kernel.org>
References: <20201203204634.1325171-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_12:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=29 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a permeating assumption thoughout BPF verifier of vmlinux BTF. Instead,
wherever BTF type IDs are involved, also track the instance of struct btf that
goes along with the type ID. This allows to gradually add support for kernel
module BTFs and using/tracking module types across BPF helper calls and
registers.

This patch also renames btf_id() function to btf_obj_id() to minimize naming
clash with using btf_id to denote BTF *type* ID, rather than BTF *object*'s ID.

Also, altough btf_vmlinux can't get destructed and thus doesn't need
refcounting, module BTFs need that, so apply BTF refcounting universally when
BPF program is using BTF-powered attachment (tp_btf, fentry/fexit, etc). This
makes for simpler clean up code.

Now that BTF type ID is not enough to uniquely identify a BTF type, extend BPF
trampoline key to include BTF object ID. To differentiate that from target
program BPF ID, set 31st bit of type ID. BTF type IDs (at least currently) are
not allowed to take full 32 bits, so there is no danger of confusing that bit
with a valid BTF type ID.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/bpf.h          | 13 ++++--
 include/linux/bpf_verifier.h | 28 +++++++++----
 include/linux/btf.h          |  5 ++-
 kernel/bpf/btf.c             | 65 ++++++++++++++++++++----------
 kernel/bpf/syscall.c         | 24 +++++++++--
 kernel/bpf/verifier.c        | 77 ++++++++++++++++++++++--------------
 net/ipv4/bpf_tcp_ca.c        |  3 +-
 7 files changed, 148 insertions(+), 67 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a9de5711b23f..d05e75ed8c1b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -421,7 +421,10 @@ struct bpf_insn_access_aux {
 	enum bpf_reg_type reg_type;
 	union {
 		int ctx_field_size;
-		u32 btf_id;
+		struct {
+			struct btf *btf;
+			u32 btf_id;
+		};
 	};
 	struct bpf_verifier_log *log; /* for verbose logs */
 };
@@ -458,6 +461,7 @@ struct bpf_verifier_ops {
 				  struct bpf_insn *dst,
 				  struct bpf_prog *prog, u32 *target_size);
 	int (*btf_struct_access)(struct bpf_verifier_log *log,
+				 const struct btf *btf,
 				 const struct btf_type *t, int off, int size,
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
@@ -771,6 +775,7 @@ struct bpf_prog_aux {
 	u32 ctx_arg_info_size;
 	u32 max_rdonly_access;
 	u32 max_rdwr_access;
+	struct btf *attach_btf;
 	const struct bpf_ctx_arg_aux *ctx_arg_info;
 	struct mutex dst_mutex; /* protects dst_* pointers below, *after* prog becomes visible */
 	struct bpf_prog *dst_prog;
@@ -1005,7 +1010,6 @@ struct bpf_event_entry {
 
 bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
 int bpf_prog_calc_tag(struct bpf_prog *fp);
-const char *kernel_type_name(u32 btf_type_id);
 
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
 
@@ -1450,12 +1454,13 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
-int btf_struct_access(struct bpf_verifier_log *log,
+int btf_struct_access(struct bpf_verifier_log *log, const struct btf *btf,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
 bool btf_struct_ids_match(struct bpf_verifier_log *log,
-			  int off, u32 id, u32 need_type_id);
+			  const struct btf *btf, u32 id, int off,
+			  const struct btf *need_btf, u32 need_type_id);
 
 int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   struct btf *btf,
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 306869d4743b..e941fe1484e5 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -5,6 +5,7 @@
 #define _LINUX_BPF_VERIFIER_H 1
 
 #include <linux/bpf.h> /* for enum bpf_reg_type */
+#include <linux/btf.h> /* for struct btf and btf_id() */
 #include <linux/filter.h> /* for MAX_BPF_STACK */
 #include <linux/tnum.h>
 
@@ -43,6 +44,8 @@ enum bpf_reg_liveness {
 struct bpf_reg_state {
 	/* Ordering of fields matters.  See states_equal() */
 	enum bpf_reg_type type;
+	/* Fixed part of pointer offset, pointer types only */
+	s32 off;
 	union {
 		/* valid when type == PTR_TO_PACKET */
 		int range;
@@ -52,15 +55,20 @@ struct bpf_reg_state {
 		 */
 		struct bpf_map *map_ptr;
 
-		u32 btf_id; /* for PTR_TO_BTF_ID */
+		/* for PTR_TO_BTF_ID */
+		struct {
+			struct btf *btf;
+			u32 btf_id;
+		};
 
 		u32 mem_size; /* for PTR_TO_MEM | PTR_TO_MEM_OR_NULL */
 
 		/* Max size from any of the above. */
-		unsigned long raw;
+		struct {
+			unsigned long raw1;
+			unsigned long raw2;
+		} raw;
 	};
-	/* Fixed part of pointer offset, pointer types only */
-	s32 off;
 	/* For PTR_TO_PACKET, used to find other pointers with the same variable
 	 * offset, so they can share range knowledge.
 	 * For PTR_TO_MAP_VALUE_OR_NULL this is used to share which map value we
@@ -311,7 +319,10 @@ struct bpf_insn_aux_data {
 		struct {
 			enum bpf_reg_type reg_type;	/* type of pseudo_btf_id */
 			union {
-				u32 btf_id;	/* btf_id for struct typed var */
+				struct {
+					struct btf *btf;
+					u32 btf_id;	/* btf_id for struct typed var */
+				};
 				u32 mem_size;	/* mem_size for non-struct typed var */
 			};
 		} btf_var;
@@ -459,9 +470,12 @@ int check_ctx_reg(struct bpf_verifier_env *env,
 
 /* this lives here instead of in bpf.h because it needs to dereference tgt_prog */
 static inline u64 bpf_trampoline_compute_key(const struct bpf_prog *tgt_prog,
-					     u32 btf_id)
+					     struct btf *btf, u32 btf_id)
 {
-        return tgt_prog ? (((u64)tgt_prog->aux->id) << 32 | btf_id) : btf_id;
+	if (tgt_prog)
+		return ((u64)tgt_prog->aux->id << 32) | btf_id;
+	else
+		return ((u64)btf_obj_id(btf) << 32) | 0x80000000 | btf_id;
 }
 
 int bpf_check_attach_target(struct bpf_verifier_log *log,
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 2bf641829664..fb608e4de076 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -18,6 +18,7 @@ struct btf_show;
 
 extern const struct file_operations btf_fops;
 
+void btf_get(struct btf *btf);
 void btf_put(struct btf *btf);
 int btf_new_fd(const union bpf_attr *attr);
 struct btf *btf_get_by_fd(int fd);
@@ -88,7 +89,7 @@ int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
 			   char *buf, int len, u64 flags);
 
 int btf_get_fd_by_id(u32 id);
-u32 btf_id(const struct btf *btf);
+u32 btf_obj_id(const struct btf *btf);
 bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   const struct btf_member *m,
 			   u32 expected_offset, u32 expected_size);
@@ -206,6 +207,8 @@ static inline const struct btf_var_secinfo *btf_type_var_secinfo(
 }
 
 #ifdef CONFIG_BPF_SYSCALL
+struct bpf_prog;
+
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
 struct btf *btf_parse_vmlinux(void);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6b2d508b33d4..7a19bf5bfe97 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1524,6 +1524,11 @@ static void btf_free_rcu(struct rcu_head *rcu)
 	btf_free(btf);
 }
 
+void btf_get(struct btf *btf)
+{
+	refcount_inc(&btf->refcnt);
+}
+
 void btf_put(struct btf *btf)
 {
 	if (btf && refcount_dec_and_test(&btf->refcnt)) {
@@ -4555,11 +4560,10 @@ struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 {
 	struct bpf_prog *tgt_prog = prog->aux->dst_prog;
 
-	if (tgt_prog) {
+	if (tgt_prog)
 		return tgt_prog->aux->btf;
-	} else {
-		return btf_vmlinux;
-	}
+	else
+		return prog->aux->attach_btf;
 }
 
 static bool is_string_ptr(struct btf *btf, const struct btf_type *t)
@@ -4700,6 +4704,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 		if (ctx_arg_info->offset == off) {
 			info->reg_type = ctx_arg_info->reg_type;
+			info->btf = btf_vmlinux;
 			info->btf_id = ctx_arg_info->btf_id;
 			return true;
 		}
@@ -4716,6 +4721,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 		ret = btf_translate_to_vmlinux(log, btf, t, tgt_type, arg);
 		if (ret > 0) {
+			info->btf = btf_vmlinux;
 			info->btf_id = ret;
 			return true;
 		} else {
@@ -4723,6 +4729,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		}
 	}
 
+	info->btf = btf;
 	info->btf_id = t->type;
 	t = btf_type_by_id(btf, t->type);
 	/* skip modifiers */
@@ -4749,7 +4756,7 @@ enum bpf_struct_walk_result {
 	WALK_STRUCT,
 };
 
-static int btf_struct_walk(struct bpf_verifier_log *log,
+static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 			   const struct btf_type *t, int off, int size,
 			   u32 *next_btf_id)
 {
@@ -4760,7 +4767,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log,
 	u32 vlen, elem_id, mid;
 
 again:
-	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
+	tname = __btf_name_by_offset(btf, t->name_off);
 	if (!btf_type_is_struct(t)) {
 		bpf_log(log, "Type '%s' is not a struct\n", tname);
 		return -EINVAL;
@@ -4777,7 +4784,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log,
 			goto error;
 
 		member = btf_type_member(t) + vlen - 1;
-		mtype = btf_type_skip_modifiers(btf_vmlinux, member->type,
+		mtype = btf_type_skip_modifiers(btf, member->type,
 						NULL);
 		if (!btf_type_is_array(mtype))
 			goto error;
@@ -4793,7 +4800,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log,
 		/* Only allow structure for now, can be relaxed for
 		 * other types later.
 		 */
-		t = btf_type_skip_modifiers(btf_vmlinux, array_elem->type,
+		t = btf_type_skip_modifiers(btf, array_elem->type,
 					    NULL);
 		if (!btf_type_is_struct(t))
 			goto error;
@@ -4851,10 +4858,10 @@ static int btf_struct_walk(struct bpf_verifier_log *log,
 
 		/* type of the field */
 		mid = member->type;
-		mtype = btf_type_by_id(btf_vmlinux, member->type);
-		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
+		mtype = btf_type_by_id(btf, member->type);
+		mname = __btf_name_by_offset(btf, member->name_off);
 
-		mtype = __btf_resolve_size(btf_vmlinux, mtype, &msize,
+		mtype = __btf_resolve_size(btf, mtype, &msize,
 					   &elem_type, &elem_id, &total_nelems,
 					   &mid);
 		if (IS_ERR(mtype)) {
@@ -4949,7 +4956,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log,
 					mname, moff, tname, off, size);
 				return -EACCES;
 			}
-			stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
+			stype = btf_type_skip_modifiers(btf, mtype->type, &id);
 			if (btf_type_is_struct(stype)) {
 				*next_btf_id = id;
 				return WALK_PTR;
@@ -4975,7 +4982,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
-int btf_struct_access(struct bpf_verifier_log *log,
+int btf_struct_access(struct bpf_verifier_log *log, const struct btf *btf,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype __maybe_unused,
 		      u32 *next_btf_id)
@@ -4984,7 +4991,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	u32 id;
 
 	do {
-		err = btf_struct_walk(log, t, off, size, &id);
+		err = btf_struct_walk(log, btf, t, off, size, &id);
 
 		switch (err) {
 		case WALK_PTR:
@@ -5000,7 +5007,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			 * by diving in it. At this point the offset is
 			 * aligned with the new type, so set it to 0.
 			 */
-			t = btf_type_by_id(btf_vmlinux, id);
+			t = btf_type_by_id(btf, id);
 			off = 0;
 			break;
 		default:
@@ -5016,21 +5023,37 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
+/* Check that two BTF types, each specified as an BTF object + id, are exactly
+ * the same. Trivial ID check is not enough due to module BTFs, because we can
+ * end up with two different module BTFs, but IDs point to the common type in
+ * vmlinux BTF.
+ */
+static bool btf_types_are_same(const struct btf *btf1, u32 id1,
+			       const struct btf *btf2, u32 id2)
+{
+	if (id1 != id2)
+		return false;
+	if (btf1 == btf2)
+		return true;
+	return btf_type_by_id(btf1, id1) == btf_type_by_id(btf2, id2);
+}
+
 bool btf_struct_ids_match(struct bpf_verifier_log *log,
-			  int off, u32 id, u32 need_type_id)
+			  const struct btf *btf, u32 id, int off,
+			  const struct btf *need_btf, u32 need_type_id)
 {
 	const struct btf_type *type;
 	int err;
 
 	/* Are we already done? */
-	if (need_type_id == id && off == 0)
+	if (off == 0 && btf_types_are_same(btf, id, need_btf, need_type_id))
 		return true;
 
 again:
-	type = btf_type_by_id(btf_vmlinux, id);
+	type = btf_type_by_id(btf, id);
 	if (!type)
 		return false;
-	err = btf_struct_walk(log, type, off, 1, &id);
+	err = btf_struct_walk(log, btf, type, off, 1, &id);
 	if (err != WALK_STRUCT)
 		return false;
 
@@ -5039,7 +5062,7 @@ bool btf_struct_ids_match(struct bpf_verifier_log *log,
 	 * continue the search with offset 0 in the new
 	 * type.
 	 */
-	if (need_type_id != id) {
+	if (!btf_types_are_same(btf, id, need_btf, need_type_id)) {
 		off = 0;
 		goto again;
 	}
@@ -5710,7 +5733,7 @@ int btf_get_fd_by_id(u32 id)
 	return fd;
 }
 
-u32 btf_id(const struct btf *btf)
+u32 btf_obj_id(const struct btf *btf)
 {
 	return btf->id;
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d16dd4945100..184204169949 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1691,6 +1691,8 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 	bpf_prog_kallsyms_del_all(prog);
 	btf_put(prog->aux->btf);
 	bpf_prog_free_linfo(prog);
+	if (prog->aux->attach_btf)
+		btf_put(prog->aux->attach_btf);
 
 	if (deferred) {
 		if (prog->aux->sleepable)
@@ -2113,6 +2115,20 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 
 	prog->expected_attach_type = attr->expected_attach_type;
 	prog->aux->attach_btf_id = attr->attach_btf_id;
+
+	if (attr->attach_btf_id && !attr->attach_prog_fd) {
+		struct btf *btf;
+
+		btf = bpf_get_btf_vmlinux();
+		if (IS_ERR(btf))
+			return PTR_ERR(btf);
+		if (!btf)
+			return -EINVAL;
+
+		btf_get(btf);
+		prog->aux->attach_btf = btf;
+	}
+
 	if (attr->attach_prog_fd) {
 		struct bpf_prog *dst_prog;
 
@@ -2209,6 +2225,8 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	free_uid(prog->aux->user);
 	security_bpf_prog_free(prog->aux);
 free_prog:
+	if (prog->aux->attach_btf)
+		btf_put(prog->aux->attach_btf);
 	bpf_prog_free(prog);
 	return err;
 }
@@ -2566,7 +2584,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 			goto out_put_prog;
 		}
 
-		key = bpf_trampoline_compute_key(tgt_prog, btf_id);
+		key = bpf_trampoline_compute_key(tgt_prog, NULL, btf_id);
 	}
 
 	link = kzalloc(sizeof(*link), GFP_USER);
@@ -3543,7 +3561,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	}
 
 	if (prog->aux->btf)
-		info.btf_id = btf_id(prog->aux->btf);
+		info.btf_id = btf_obj_id(prog->aux->btf);
 
 	ulen = info.nr_func_info;
 	info.nr_func_info = prog->aux->func_info_cnt;
@@ -3646,7 +3664,7 @@ static int bpf_map_get_info_by_fd(struct file *file,
 	memcpy(info.name, map->name, sizeof(map->name));
 
 	if (map->btf) {
-		info.btf_id = btf_id(map->btf);
+		info.btf_id = btf_obj_id(map->btf);
 		info.btf_key_type_id = map->btf_key_type_id;
 		info.btf_value_type_id = map->btf_value_type_id;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e333ce43f281..2f3950839b85 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -238,7 +238,9 @@ struct bpf_call_arg_meta {
 	u64 msize_max_value;
 	int ref_obj_id;
 	int func_id;
+	struct btf *btf;
 	u32 btf_id;
+	struct btf *ret_btf;
 	u32 ret_btf_id;
 };
 
@@ -556,10 +558,9 @@ static struct bpf_func_state *func(struct bpf_verifier_env *env,
 	return cur->frame[reg->frameno];
 }
 
-const char *kernel_type_name(u32 id)
+static const char *kernel_type_name(const struct btf* btf, u32 id)
 {
-	return btf_name_by_offset(btf_vmlinux,
-				  btf_type_by_id(btf_vmlinux, id)->name_off);
+	return btf_name_by_offset(btf, btf_type_by_id(btf, id)->name_off);
 }
 
 static void print_verifier_state(struct bpf_verifier_env *env,
@@ -589,7 +590,7 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 			if (t == PTR_TO_BTF_ID ||
 			    t == PTR_TO_BTF_ID_OR_NULL ||
 			    t == PTR_TO_PERCPU_BTF_ID)
-				verbose(env, "%s", kernel_type_name(reg->btf_id));
+				verbose(env, "%s", kernel_type_name(reg->btf, reg->btf_id));
 			verbose(env, "(id=%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
 				verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
@@ -1383,7 +1384,8 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
 
 static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 			    struct bpf_reg_state *regs, u32 regno,
-			    enum bpf_reg_type reg_type, u32 btf_id)
+			    enum bpf_reg_type reg_type,
+			    struct btf *btf, u32 btf_id)
 {
 	if (reg_type == SCALAR_VALUE) {
 		mark_reg_unknown(env, regs, regno);
@@ -1391,6 +1393,7 @@ static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 	}
 	mark_reg_known_zero(env, regs, regno);
 	regs[regno].type = PTR_TO_BTF_ID;
+	regs[regno].btf = btf;
 	regs[regno].btf_id = btf_id;
 }
 
@@ -2764,7 +2767,7 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
 static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
 			    enum bpf_access_type t, enum bpf_reg_type *reg_type,
-			    u32 *btf_id)
+			    struct btf **btf, u32 *btf_id)
 {
 	struct bpf_insn_access_aux info = {
 		.reg_type = *reg_type,
@@ -2782,10 +2785,12 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
 		 */
 		*reg_type = info.reg_type;
 
-		if (*reg_type == PTR_TO_BTF_ID || *reg_type == PTR_TO_BTF_ID_OR_NULL)
+		if (*reg_type == PTR_TO_BTF_ID || *reg_type == PTR_TO_BTF_ID_OR_NULL) {
+			*btf = info.btf;
 			*btf_id = info.btf_id;
-		else
+		} else {
 			env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
+		}
 		/* remember the offset of last byte accessed in ctx */
 		if (env->prog->aux->max_ctx_offset < off + size)
 			env->prog->aux->max_ctx_offset = off + size;
@@ -3297,8 +3302,8 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 				   int value_regno)
 {
 	struct bpf_reg_state *reg = regs + regno;
-	const struct btf_type *t = btf_type_by_id(btf_vmlinux, reg->btf_id);
-	const char *tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
+	const char *tname = btf_name_by_offset(reg->btf, t->name_off);
 	u32 btf_id;
 	int ret;
 
@@ -3319,23 +3324,23 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	}
 
 	if (env->ops->btf_struct_access) {
-		ret = env->ops->btf_struct_access(&env->log, t, off, size,
-						  atype, &btf_id);
+		ret = env->ops->btf_struct_access(&env->log, reg->btf, t,
+						  off, size, atype, &btf_id);
 	} else {
 		if (atype != BPF_READ) {
 			verbose(env, "only read is supported\n");
 			return -EACCES;
 		}
 
-		ret = btf_struct_access(&env->log, t, off, size, atype,
-					&btf_id);
+		ret = btf_struct_access(&env->log, reg->btf, t, off, size,
+					atype, &btf_id);
 	}
 
 	if (ret < 0)
 		return ret;
 
 	if (atype == BPF_READ && value_regno >= 0)
-		mark_btf_ld_reg(env, regs, value_regno, ret, btf_id);
+		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, btf_id);
 
 	return 0;
 }
@@ -3385,12 +3390,12 @@ static int check_ptr_to_map_access(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	ret = btf_struct_access(&env->log, t, off, size, atype, &btf_id);
+	ret = btf_struct_access(&env->log, btf_vmlinux, t, off, size, atype, &btf_id);
 	if (ret < 0)
 		return ret;
 
 	if (value_regno >= 0)
-		mark_btf_ld_reg(env, regs, value_regno, ret, btf_id);
+		mark_btf_ld_reg(env, regs, value_regno, ret, btf_vmlinux, btf_id);
 
 	return 0;
 }
@@ -3466,6 +3471,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type == PTR_TO_CTX) {
 		enum bpf_reg_type reg_type = SCALAR_VALUE;
+		struct btf *btf = NULL;
 		u32 btf_id = 0;
 
 		if (t == BPF_WRITE && value_regno >= 0 &&
@@ -3478,7 +3484,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		if (err < 0)
 			return err;
 
-		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf_id);
+		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf, &btf_id);
 		if (err)
 			verbose_linfo(env, insn_idx, "; ");
 		if (!err && t == BPF_READ && value_regno >= 0) {
@@ -3500,8 +3506,10 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 				 */
 				regs[value_regno].subreg_def = DEF_NOT_SUBREG;
 				if (reg_type == PTR_TO_BTF_ID ||
-				    reg_type == PTR_TO_BTF_ID_OR_NULL)
+				    reg_type == PTR_TO_BTF_ID_OR_NULL) {
+					regs[value_regno].btf = btf;
 					regs[value_regno].btf_id = btf_id;
+				}
 			}
 			regs[value_regno].type = reg_type;
 		}
@@ -4118,11 +4126,11 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 			arg_btf_id = compatible->btf_id;
 		}
 
-		if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
-					  *arg_btf_id)) {
+		if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
+					  btf_vmlinux, *arg_btf_id)) {
 			verbose(env, "R%d is of type %s but %s is expected\n",
-				regno, kernel_type_name(reg->btf_id),
-				kernel_type_name(*arg_btf_id));
+				regno, kernel_type_name(reg->btf, reg->btf_id),
+				kernel_type_name(btf_vmlinux, *arg_btf_id));
 			return -EACCES;
 		}
 
@@ -4244,6 +4252,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "Helper has invalid btf_id in R%d\n", regno);
 			return -EACCES;
 		}
+		meta->ret_btf = reg->btf;
 		meta->ret_btf_id = reg->btf_id;
 	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
 		if (meta->func_id == BPF_FUNC_spin_lock) {
@@ -5190,16 +5199,16 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		const struct btf_type *t;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		t = btf_type_skip_modifiers(btf_vmlinux, meta.ret_btf_id, NULL);
+		t = btf_type_skip_modifiers(meta.ret_btf, meta.ret_btf_id, NULL);
 		if (!btf_type_is_struct(t)) {
 			u32 tsize;
 			const struct btf_type *ret;
 			const char *tname;
 
 			/* resolve the type size of ksym. */
-			ret = btf_resolve_size(btf_vmlinux, t, &tsize);
+			ret = btf_resolve_size(meta.ret_btf, t, &tsize);
 			if (IS_ERR(ret)) {
-				tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+				tname = btf_name_by_offset(meta.ret_btf, t->name_off);
 				verbose(env, "unable to resolve the size of type '%s': %ld\n",
 					tname, PTR_ERR(ret));
 				return -EINVAL;
@@ -5212,6 +5221,7 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 			regs[BPF_REG_0].type =
 				fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID ?
 				PTR_TO_BTF_ID : PTR_TO_BTF_ID_OR_NULL;
+			regs[BPF_REG_0].btf = meta.ret_btf;
 			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
 		}
 	} else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL ||
@@ -5228,6 +5238,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 				fn->ret_type, func_id_name(func_id), func_id);
 			return -EINVAL;
 		}
+		/* current BPF helper definitions are only coming from
+		 * built-in code with type IDs from  vmlinux BTF
+		 */
+		regs[BPF_REG_0].btf = btf_vmlinux;
 		regs[BPF_REG_0].btf_id = ret_btf_id;
 	} else {
 		verbose(env, "unknown return type %d of func %s#%d\n",
@@ -5627,7 +5641,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		if (reg_is_pkt_pointer(ptr_reg)) {
 			dst_reg->id = ++env->id_gen;
 			/* something was added to pkt_ptr, set range to zero */
-			dst_reg->raw = 0;
+			memset(&dst_reg->raw, 0, sizeof(dst_reg->raw));
 		}
 		break;
 	case BPF_SUB:
@@ -5692,7 +5706,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			dst_reg->id = ++env->id_gen;
 			/* something was added to pkt_ptr, set range to zero */
 			if (smin_val < 0)
-				dst_reg->raw = 0;
+				memset(&dst_reg->raw, 0, sizeof(dst_reg->raw));
 		}
 		break;
 	case BPF_AND:
@@ -7744,6 +7758,7 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			break;
 		case PTR_TO_BTF_ID:
 		case PTR_TO_PERCPU_BTF_ID:
+			dst_reg->btf = aux->btf_var.btf;
 			dst_reg->btf_id = aux->btf_var.btf_id;
 			break;
 		default:
@@ -9739,6 +9754,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 	t = btf_type_skip_modifiers(btf_vmlinux, type, NULL);
 	if (percpu) {
 		aux->btf_var.reg_type = PTR_TO_PERCPU_BTF_ID;
+		aux->btf_var.btf = btf_vmlinux;
 		aux->btf_var.btf_id = type;
 	} else if (!btf_type_is_struct(t)) {
 		const struct btf_type *ret;
@@ -9757,6 +9773,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		aux->btf_var.mem_size = tsize;
 	} else {
 		aux->btf_var.reg_type = PTR_TO_BTF_ID;
+		aux->btf_var.btf = btf_vmlinux;
 		aux->btf_var.btf_id = type;
 	}
 	return 0;
@@ -11609,7 +11626,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		bpf_log(log, "Tracing programs must provide btf_id\n");
 		return -EINVAL;
 	}
-	btf = tgt_prog ? tgt_prog->aux->btf : btf_vmlinux;
+	btf = tgt_prog ? tgt_prog->aux->btf : prog->aux->attach_btf;
 	if (!btf) {
 		bpf_log(log,
 			"FENTRY/FEXIT program can only be attached to another program annotated with BTF\n");
@@ -11885,7 +11902,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			return ret;
 	}
 
-	key = bpf_trampoline_compute_key(tgt_prog, btf_id);
+	key = bpf_trampoline_compute_key(tgt_prog, prog->aux->attach_btf, btf_id);
 	tr = bpf_trampoline_get(key, &tgt_info);
 	if (!tr)
 		return -ENOMEM;
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 618954f82764..d520e61649c8 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -95,6 +95,7 @@ static bool bpf_tcp_ca_is_valid_access(int off, int size,
 }
 
 static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
+					const struct btf *btf,
 					const struct btf_type *t, int off,
 					int size, enum bpf_access_type atype,
 					u32 *next_btf_id)
@@ -102,7 +103,7 @@ static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
 	size_t end;
 
 	if (atype == BPF_READ)
-		return btf_struct_access(log, t, off, size, atype, next_btf_id);
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id);
 
 	if (t != tcp_sock_type) {
 		bpf_log(log, "only read is supported\n");
-- 
2.24.1

