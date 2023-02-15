Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA096976D6
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 07:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjBOG7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 01:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbjBOG7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 01:59:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3F53525C;
        Tue, 14 Feb 2023 22:58:30 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fu4-20020a17090ad18400b002341fadc370so1177699pjb.1;
        Tue, 14 Feb 2023 22:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HG8ItZehQii222dsCYFg99bJZP+mXC0UNQ1OCeSNY6U=;
        b=lboxmZtCthEUal//U9+QNUBSp3Fee0YRmuL1QE+RMmAI8MRmUA+yc66cg7RbuCyLct
         ZqcaOmw/2Q9NYGbRgsBf3CVZe1naRTD/5TihfjUTLMQsHwUbra9/s+dWiTKX/Vqw8EMg
         ye5TQx6g5f1xNekcTKyLnA2dpS5LZVYHdC5dI8flsogOFtkf5ZihodL1lyRnIyl6QlFx
         sIZSO0e5eM7v+LNuesv+IVpws3f+t2T3LYLNswe3DLeauoUVkf8NnRhpPyk4HJylSzsf
         DXed66alySIWZDka8/Tf4AXJ3QFqeVFZ4iw9Rs15LgVwrdossBIed3ucEyS2LsEK+YW7
         iR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HG8ItZehQii222dsCYFg99bJZP+mXC0UNQ1OCeSNY6U=;
        b=HIaZTE3avz79eSD96nWA6VxpiX5VNXjaaVeamHL4yuBTHJh/xJBUfIAx7aMrQJXsV1
         3WWm1QsBUH6AuAbvLyIEjNIdjx4tpPxhz/1yZ36+VxBjwqeHMNezJGt+IOB9dxjQF0z0
         rBfVgwnrsWVt6OSXuVN/QTiubAKlpFcJPcK/2Asyo577L59fuP/h0X40CpF3dUfzzR8a
         73Mxsr2o+lCFZxWhhYwYD85MBa2YGkoi4fxY0hqTB5U9PtlZvTwo1h60q5Re3267WsfQ
         ybVrf61paWcyWucc3Oc3HGnFlDo/N+Qkb+jtr88Gndqo+foTI4kEQvD+4zGU+8lo257T
         xqaw==
X-Gm-Message-State: AO0yUKW2JTy8+BP6hvmbt0mQEL+WDg2hTwSS+rZPj/oau0LnpwTFOS7T
        Q8c5FDYI3KPmRoE48RISXvk=
X-Google-Smtp-Source: AK7set/+tuf17jgln8IPOJW1rOfKGKY2tCgHWTqC85QDEjRa2aBWmsJMgNAw+oVfpFHOW3IdFhFb1A==
X-Received: by 2002:a17:902:fb46:b0:19a:96f0:b13 with SMTP id lf6-20020a170902fb4600b0019a96f00b13mr1206277plb.31.1676444304253;
        Tue, 14 Feb 2023 22:58:24 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:d0de])
        by smtp.gmail.com with ESMTPSA id g2-20020a170902c38200b00176b84eb29asm8465570plg.301.2023.02.14.22.58.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Feb 2023 22:58:23 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 2/4] bpf: Introduce kptr_rcu.
Date:   Tue, 14 Feb 2023 22:58:10 -0800
Message-Id: <20230215065812.7551-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
References: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The life time of certain kernel structures like 'struct cgroup' is protected by RCU.
Hence it's safe to dereference them directly from kptr-s in bpf maps.
The resulting pointer is PTR_TRUSTED and can be passed to kfuncs that expect KF_TRUSTED_ARGS.
Derefrence of other kptr-s returns PTR_UNTRUSTED.

For example:
struct map_value {
   struct cgroup __kptr_rcu *cgrp;
};

SEC("tp_btf/cgroup_mkdir")
int BPF_PROG(test_cgrp_get_ancestors, struct cgroup *cgrp_arg, const char *path)
{
  struct cgroup *cg, *cg2;

  cg = bpf_cgroup_acquire(cgrp_arg); // cg is PTR_TRUSTED and ref_obj_id > 0
  bpf_kptr_xchg(&v->cgrp, cg);

  cg2 = v->cgrp; // cg2 is PTR_TRUSTED | MEM_RCU. This is new feature introduced by this patch.

  bpf_cgroup_ancestor(cg2, level); // safe to do. cg2 will not disappear
}

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h          | 15 ++++++++++-----
 include/linux/bpf_verifier.h |  2 +-
 kernel/bpf/btf.c             | 22 +++++++++++++++++++++-
 kernel/bpf/syscall.c         |  4 ++++
 kernel/bpf/verifier.c        | 33 ++++++++++++++++++++++-----------
 tools/lib/bpf/bpf_helpers.h  |  1 +
 6 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index be34f7deb6c3..c9cc11653b83 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -178,11 +178,12 @@ enum btf_field_type {
 	BPF_TIMER      = (1 << 1),
 	BPF_KPTR_UNREF = (1 << 2),
 	BPF_KPTR_REF   = (1 << 3),
-	BPF_KPTR       = BPF_KPTR_UNREF | BPF_KPTR_REF,
-	BPF_LIST_HEAD  = (1 << 4),
-	BPF_LIST_NODE  = (1 << 5),
-	BPF_RB_ROOT    = (1 << 6),
-	BPF_RB_NODE    = (1 << 7),
+	BPF_KPTR_RCU   = (1 << 4),
+	BPF_KPTR       = BPF_KPTR_UNREF | BPF_KPTR_REF | BPF_KPTR_RCU,
+	BPF_LIST_HEAD  = (1 << 5),
+	BPF_LIST_NODE  = (1 << 6),
+	BPF_RB_ROOT    = (1 << 7),
+	BPF_RB_NODE    = (1 << 8),
 	BPF_GRAPH_NODE_OR_ROOT = BPF_LIST_NODE | BPF_LIST_HEAD |
 				 BPF_RB_NODE | BPF_RB_ROOT,
 };
@@ -284,6 +285,8 @@ static inline const char *btf_field_type_name(enum btf_field_type type)
 	case BPF_KPTR_UNREF:
 	case BPF_KPTR_REF:
 		return "kptr";
+	case BPF_KPTR_RCU:
+		return "kptr_rcu";
 	case BPF_LIST_HEAD:
 		return "bpf_list_head";
 	case BPF_LIST_NODE:
@@ -307,6 +310,7 @@ static inline u32 btf_field_type_size(enum btf_field_type type)
 		return sizeof(struct bpf_timer);
 	case BPF_KPTR_UNREF:
 	case BPF_KPTR_REF:
+	case BPF_KPTR_RCU:
 		return sizeof(u64);
 	case BPF_LIST_HEAD:
 		return sizeof(struct bpf_list_head);
@@ -331,6 +335,7 @@ static inline u32 btf_field_type_align(enum btf_field_type type)
 		return __alignof__(struct bpf_timer);
 	case BPF_KPTR_UNREF:
 	case BPF_KPTR_REF:
+	case BPF_KPTR_RCU:
 		return __alignof__(u64);
 	case BPF_LIST_HEAD:
 		return __alignof__(struct bpf_list_head);
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index cf1bb1cf4a7b..e7c01294b3d3 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -682,7 +682,7 @@ static inline bool bpf_prog_check_recur(const struct bpf_prog *prog)
 	}
 }
 
-#define BPF_REG_TRUSTED_MODIFIERS (MEM_ALLOC | PTR_TRUSTED)
+#define BPF_REG_TRUSTED_MODIFIERS (MEM_ALLOC | PTR_TRUSTED | MEM_RCU)
 
 static inline bool bpf_type_has_unsafe_modifiers(u32 type)
 {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1bba71c6176a..9b0342220a2d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3287,6 +3287,8 @@ static int btf_find_kptr(const struct btf *btf, const struct btf_type *t,
 		type = BPF_KPTR_UNREF;
 	else if (!strcmp("kptr", __btf_name_by_offset(btf, t->name_off)))
 		type = BPF_KPTR_REF;
+	else if (!strcmp("kptr_rcu", __btf_name_by_offset(btf, t->name_off)))
+		type = BPF_KPTR_RCU;
 	else
 		return -EINVAL;
 
@@ -3449,6 +3451,7 @@ static int btf_find_struct_field(const struct btf *btf,
 			break;
 		case BPF_KPTR_UNREF:
 		case BPF_KPTR_REF:
+		case BPF_KPTR_RCU:
 			ret = btf_find_kptr(btf, member_type, off, sz,
 					    idx < info_cnt ? &info[idx] : &tmp);
 			if (ret < 0)
@@ -3514,6 +3517,7 @@ static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
 			break;
 		case BPF_KPTR_UNREF:
 		case BPF_KPTR_REF:
+		case BPF_KPTR_RCU:
 			ret = btf_find_kptr(btf, var_type, off, sz,
 					    idx < info_cnt ? &info[idx] : &tmp);
 			if (ret < 0)
@@ -3552,6 +3556,18 @@ static int btf_find_field(const struct btf *btf, const struct btf_type *t,
 	return -EINVAL;
 }
 
+BTF_SET_START(rcu_protected_types)
+BTF_ID(struct, prog_test_ref_kfunc)
+BTF_ID(struct, cgroup)
+BTF_SET_END(rcu_protected_types)
+
+static bool rcu_protected_object(const struct btf *btf, u32 btf_id)
+{
+	if (!btf_is_kernel(btf))
+		return false;
+	return btf_id_set_contains(&rcu_protected_types, btf_id);
+}
+
 static int btf_parse_kptr(const struct btf *btf, struct btf_field *field,
 			  struct btf_field_info *info)
 {
@@ -3570,10 +3586,13 @@ static int btf_parse_kptr(const struct btf *btf, struct btf_field *field,
 	if (id < 0)
 		return id;
 
+	if (info->type == BPF_KPTR_RCU && !rcu_protected_object(kernel_btf, id))
+		return -EINVAL;
+
 	/* Find and stash the function pointer for the destruction function that
 	 * needs to be eventually invoked from the map free path.
 	 */
-	if (info->type == BPF_KPTR_REF) {
+	if (info->type == BPF_KPTR_REF || info->type == BPF_KPTR_RCU) {
 		const struct btf_type *dtor_func;
 		const char *dtor_func_name;
 		unsigned long addr;
@@ -3737,6 +3756,7 @@ struct btf_record *btf_parse_fields(const struct btf *btf, const struct btf_type
 			break;
 		case BPF_KPTR_UNREF:
 		case BPF_KPTR_REF:
+		case BPF_KPTR_RCU:
 			ret = btf_parse_kptr(btf, &rec->fields[i], &info_arr[i]);
 			if (ret < 0)
 				goto end;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e3fcdc9836a6..2e730918911c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -539,6 +539,7 @@ void btf_record_free(struct btf_record *rec)
 		switch (rec->fields[i].type) {
 		case BPF_KPTR_UNREF:
 		case BPF_KPTR_REF:
+		case BPF_KPTR_RCU:
 			if (rec->fields[i].kptr.module)
 				module_put(rec->fields[i].kptr.module);
 			btf_put(rec->fields[i].kptr.btf);
@@ -584,6 +585,7 @@ struct btf_record *btf_record_dup(const struct btf_record *rec)
 		switch (fields[i].type) {
 		case BPF_KPTR_UNREF:
 		case BPF_KPTR_REF:
+		case BPF_KPTR_RCU:
 			btf_get(fields[i].kptr.btf);
 			if (fields[i].kptr.module && !try_module_get(fields[i].kptr.module)) {
 				ret = -ENXIO;
@@ -669,6 +671,7 @@ void bpf_obj_free_fields(const struct btf_record *rec, void *obj)
 			WRITE_ONCE(*(u64 *)field_ptr, 0);
 			break;
 		case BPF_KPTR_REF:
+		case BPF_KPTR_RCU:
 			field->kptr.dtor((void *)xchg((unsigned long *)field_ptr, 0));
 			break;
 		case BPF_LIST_HEAD:
@@ -1058,6 +1061,7 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 				break;
 			case BPF_KPTR_UNREF:
 			case BPF_KPTR_REF:
+			case BPF_KPTR_RCU:
 				if (map->map_type != BPF_MAP_TYPE_HASH &&
 				    map->map_type != BPF_MAP_TYPE_LRU_HASH &&
 				    map->map_type != BPF_MAP_TYPE_ARRAY &&
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 21e08c111702..b23d6e3a9699 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4159,7 +4159,7 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 			       struct bpf_reg_state *reg, u32 regno)
 {
 	const char *targ_name = kernel_type_name(kptr_field->kptr.btf, kptr_field->kptr.btf_id);
-	int perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED;
+	int perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED | MEM_RCU;
 	const char *reg_name = "";
 
 	/* Only unreferenced case accepts untrusted pointers */
@@ -4206,12 +4206,12 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	 * In the kptr_ref case, check_func_arg_reg_off already ensures reg->off
 	 * is zero. We must also ensure that btf_struct_ids_match does not walk
 	 * the struct to match type against first member of struct, i.e. reject
-	 * second case from above. Hence, when type is BPF_KPTR_REF, we set
+	 * second case from above. Hence, when type is BPF_KPTR_REF | BPF_KPTR_RCU, we set
 	 * strict mode to true for type match.
 	 */
 	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
 				  kptr_field->kptr.btf, kptr_field->kptr.btf_id,
-				  kptr_field->type == BPF_KPTR_REF))
+				  kptr_field->type == BPF_KPTR_REF || kptr_field->type == BPF_KPTR_RCU))
 		goto bad_type;
 	return 0;
 bad_type:
@@ -4226,6 +4226,14 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	return -EINVAL;
 }
 
+/* The non-sleepable programs and sleepable programs with explicit bpf_rcu_read_lock()
+ * can dereference RCU protected pointers and result is PTR_TRUSTED.
+ */
+static bool in_rcu_cs(struct bpf_verifier_env *env)
+{
+	return env->cur_state->active_rcu_lock || !env->prog->aux->sleepable;
+}
+
 static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 				 int value_regno, int insn_idx,
 				 struct btf_field *kptr_field)
@@ -4249,7 +4257,7 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 	/* We only allow loading referenced kptr, since it will be marked as
 	 * untrusted, similar to unreferenced kptr.
 	 */
-	if (class != BPF_LDX && kptr_field->type == BPF_KPTR_REF) {
+	if (class != BPF_LDX && kptr_field->type != BPF_KPTR_UNREF) {
 		verbose(env, "store to referenced kptr disallowed\n");
 		return -EACCES;
 	}
@@ -4260,7 +4268,10 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 		 * value from map as PTR_TO_BTF_ID, with the correct type.
 		 */
 		mark_btf_ld_reg(env, cur_regs(env), value_regno, PTR_TO_BTF_ID, kptr_field->kptr.btf,
-				kptr_field->kptr.btf_id, PTR_MAYBE_NULL | PTR_UNTRUSTED);
+				kptr_field->kptr.btf_id,
+				kptr_field->type == BPF_KPTR_RCU && in_rcu_cs(env) ?
+				PTR_MAYBE_NULL | PTR_TRUSTED | MEM_RCU :
+				PTR_MAYBE_NULL | PTR_UNTRUSTED);
 		/* For mark_ptr_or_null_reg */
 		val_reg->id = ++env->id_gen;
 	} else if (class == BPF_STX) {
@@ -4314,6 +4325,7 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 			switch (field->type) {
 			case BPF_KPTR_UNREF:
 			case BPF_KPTR_REF:
+			case BPF_KPTR_RCU:
 				if (src != ACCESS_DIRECT) {
 					verbose(env, "kptr cannot be accessed indirectly by helper\n");
 					return -EACCES;
@@ -5110,11 +5122,10 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		 * read lock region. Also mark rcu pointer as PTR_MAYBE_NULL since
 		 * it could be null in some cases.
 		 */
-		if (!env->cur_state->active_rcu_lock ||
-		    !(is_trusted_reg(reg) || is_rcu_reg(reg)))
-			flag &= ~MEM_RCU;
-		else
+		if (in_rcu_cs(env) && (is_trusted_reg(reg) || is_rcu_reg(reg)))
 			flag |= PTR_MAYBE_NULL;
+		else
+			flag &= ~MEM_RCU;
 	} else if (reg->type & MEM_RCU) {
 		/* ptr (reg) is marked as MEM_RCU, but the struct field is not tagged
 		 * with __rcu. Mark the flag as PTR_UNTRUSTED conservatively.
@@ -6157,7 +6168,7 @@ static int process_kptr_func(struct bpf_verifier_env *env, int regno,
 		verbose(env, "off=%d doesn't point to kptr\n", kptr_off);
 		return -EACCES;
 	}
-	if (kptr_field->type != BPF_KPTR_REF) {
+	if (kptr_field->type != BPF_KPTR_REF && kptr_field->type != BPF_KPTR_RCU) {
 		verbose(env, "off=%d kptr isn't referenced kptr\n", kptr_off);
 		return -EACCES;
 	}
@@ -9069,7 +9080,7 @@ static int process_kf_arg_ptr_to_kptr(struct bpf_verifier_env *env,
 	}
 
 	kptr_field = btf_record_find(reg->map_ptr->record, reg->off + reg->var_off.value, BPF_KPTR);
-	if (!kptr_field || kptr_field->type != BPF_KPTR_REF) {
+	if (!kptr_field || (kptr_field->type != BPF_KPTR_REF && kptr_field->type != BPF_KPTR_RCU)) {
 		verbose(env, "arg#0 no referenced kptr at map value offset=%llu\n",
 			reg->off + reg->var_off.value);
 		return -EINVAL;
diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 7d12d3e620cc..affc0997f937 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -176,6 +176,7 @@ enum libbpf_tristate {
 #define __ksym __attribute__((section(".ksyms")))
 #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")))
 #define __kptr __attribute__((btf_type_tag("kptr")))
+#define __kptr_rcu __attribute__((btf_type_tag("kptr_rcu")))
 
 #ifndef ___bpf_concat
 #define ___bpf_concat(a, b) a ## b
-- 
2.30.2

