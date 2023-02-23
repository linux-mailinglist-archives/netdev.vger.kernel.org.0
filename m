Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499176A016F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 04:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbjBWDHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 22:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbjBWDHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 22:07:41 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971B548E27;
        Wed, 22 Feb 2023 19:07:30 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u14so7349969ple.7;
        Wed, 22 Feb 2023 19:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LxIoFt7I8yVjq/M6ku17cKIo5Gzn0LxFg4YBhjXYa2Q=;
        b=mBrpZumQytDJYXQNmOB/1ifHeAnxcXQEiVdzYM+9DVxzISQZGegthvJtwTd+fhg7Ax
         mcEp534CNJ/xXgq1PGMvt/04J+8yyq/paOzj5IuC70/2ywuHKETSV84JLoboI9VIX//l
         XQGtqV8KLlyLL8fAzVs2ncSMvLvyeHa9kGwlTNTXpQOHomo5SUXyzqOS2N7lBg/59rGx
         ynuHRi3T9J5GcR3KjcdmOcA2SjPVyfLSL4rt/XVkldJ1cuu6qQdVb+/LeQ72vxntS5Jy
         elI60mItJ0dm8x+GfIRuNcXMw2qJ5hoatAm0mP7RUgC9sn4nyuI6qDFO+7SYfdc6D6+r
         xrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LxIoFt7I8yVjq/M6ku17cKIo5Gzn0LxFg4YBhjXYa2Q=;
        b=eoJ9pK+usr6FMOfTWAZeIoZFOuIIODZwXxV22cpJ5O9dCb4E6xSD8LQ1Dyu1n9XBHT
         KBnerYS5XdFFVbmaAEp0WkoaKEJ4PDhXiOhnAjQ4cSodKsEF6VeV+yj3NuA3v2hnwk7q
         uK7HCf51XHUeAl32avqLKecNfglAyLndMf1SXXWMfOKKkQPC9LlgRMjXssjanP/cTvrO
         Bao7Z7FbN9C/xhuVwJHgQKqtMRxnEQ3epSgDC4hqESeADGIL0GLcoLQUZ7DonHLd7Rdh
         0TuGmegxcBeJz5Ox9JzDB39+2ybBMM8ixmOuPr82ecA2uBWRwRglFcPZ56fK2O0/X/vr
         ehlA==
X-Gm-Message-State: AO0yUKVeT+01iiaqpRH0vzCBvituy7OSZjBpc5694T/koRr2joV2GbfX
        1V7MDmq957th2U2HGZbReLY=
X-Google-Smtp-Source: AK7set+gRm+keQxVu4pjkYpqd9q2QXyuLDgYiFNICenfB7AydKegAnVfPHlZqk2NKQRZzy0+tSzaYQ==
X-Received: by 2002:a17:903:183:b0:19b:33c0:40ab with SMTP id z3-20020a170903018300b0019b33c040abmr11973246plg.43.1677121649777;
        Wed, 22 Feb 2023 19:07:29 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:9cb3])
        by smtp.gmail.com with ESMTPSA id jw9-20020a170903278900b0019a7d58e595sm2514413plb.143.2023.02.22.19.07.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Feb 2023 19:07:29 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 2/4] bpf: Introduce kptr_rcu.
Date:   Wed, 22 Feb 2023 19:07:15 -0800
Message-Id: <20230223030717.58668-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230223030717.58668-1-alexei.starovoitov@gmail.com>
References: <20230223030717.58668-1-alexei.starovoitov@gmail.com>
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
Hence it's safe to dereference them directly from kptr_rcu tagged pointers in bpf maps.
The resulting pointer is MEM_RCU and can be passed to kfuncs that expect KF_RCU.
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

  cg2 = v->cgrp; // This is new feature introduced by this patch.
  // cg2 is PTR_MAYBE_NULL | MEM_RCU.
  // When cg2 != NULL, it's a valid cgroup, but its percpu_ref could be zero

  bpf_cgroup_ancestor(cg2, level); // safe to do.
}

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 Documentation/bpf/kfuncs.rst                 | 11 ++++---
 include/linux/bpf.h                          | 15 ++++++---
 include/linux/btf.h                          |  2 +-
 kernel/bpf/btf.c                             | 22 ++++++++++++-
 kernel/bpf/helpers.c                         |  7 +++--
 kernel/bpf/syscall.c                         |  4 +++
 kernel/bpf/verifier.c                        | 33 +++++++++++++-------
 net/bpf/test_run.c                           |  3 +-
 tools/lib/bpf/bpf_helpers.h                  |  1 +
 tools/testing/selftests/bpf/verifier/calls.c |  2 +-
 10 files changed, 72 insertions(+), 28 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index d085594eae19..b76b3a699f96 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -232,11 +232,12 @@ added later.
 2.4.8 KF_RCU flag
 -----------------
 
-The KF_RCU flag is used for kfuncs which have a rcu ptr as its argument.
-When used together with KF_ACQUIRE, it indicates the kfunc should have a
-single argument which must be a trusted argument or a MEM_RCU pointer.
-The argument may have reference count of 0 and the kfunc must take this
-into consideration.
+The KF_RCU flag is a weaker version of KF_TRUSTED_ARGS. The kfuncs marked with
+KF_RCU expect either PTR_TRUSTED or MEM_RCU arguments. The verifier guarantees
+that the objects are valid and there is no use-after-free, but the pointers
+maybe NULL and pointee object's reference count could have reached zero, hence
+kfuncs must do != NULL check and consider refcnt==0 case when accessing such
+arguments.
 
 .. _KF_deprecated_flag:
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 520b238abd5a..c6098b5d8e77 100644
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
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 49e0fe6d8274..556b3e2e7471 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -70,7 +70,7 @@
 #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
 #define KF_SLEEPABLE    (1 << 5) /* kfunc may sleep */
 #define KF_DESTRUCTIVE  (1 << 6) /* kfunc performs destructive actions */
-#define KF_RCU          (1 << 7) /* kfunc only takes rcu pointer arguments */
+#define KF_RCU          (1 << 7) /* kfunc takes either rcu or trusted pointer arguments */
 
 /*
  * Tag marking a kernel function as a kfunc. This is meant to minimize the
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 01dee7d48e6d..1428d7b15c1c 100644
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
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5b278a38ae58..58d01560b665 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2094,11 +2094,12 @@ __bpf_kfunc struct cgroup *bpf_cgroup_ancestor(struct cgroup *cgrp, int level)
 {
 	struct cgroup *ancestor;
 
-	if (level > cgrp->level || level < 0)
+	if (!cgrp || level > cgrp->level || level < 0)
 		return NULL;
 
 	ancestor = cgrp->ancestors[level];
-	cgroup_get(ancestor);
+	if (!cgroup_tryget(ancestor))
+		return NULL;
 	return ancestor;
 }
 #endif /* CONFIG_CGROUPS */
@@ -2166,7 +2167,7 @@ BTF_ID_FLAGS(func, bpf_rbtree_first, KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_acquire, KF_ACQUIRE | KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_cgroup_kptr_get, KF_ACQUIRE | KF_KPTR_GET | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
-BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_TRUSTED_ARGS | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 #endif
 BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
 BTF_SET8_END(generic_btf_ids)
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
index 5cb8b623f639..401ff0d74de7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4183,7 +4183,7 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 			       struct bpf_reg_state *reg, u32 regno)
 {
 	const char *targ_name = kernel_type_name(kptr_field->kptr.btf, kptr_field->kptr.btf_id);
-	int perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED;
+	int perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED | MEM_RCU;
 	const char *reg_name = "";
 
 	/* Only unreferenced case accepts untrusted pointers */
@@ -4230,12 +4230,12 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
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
@@ -4250,6 +4250,14 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
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
@@ -4273,7 +4281,7 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 	/* We only allow loading referenced kptr, since it will be marked as
 	 * untrusted, similar to unreferenced kptr.
 	 */
-	if (class != BPF_LDX && kptr_field->type == BPF_KPTR_REF) {
+	if (class != BPF_LDX && kptr_field->type != BPF_KPTR_UNREF) {
 		verbose(env, "store to referenced kptr disallowed\n");
 		return -EACCES;
 	}
@@ -4284,7 +4292,10 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 		 * value from map as PTR_TO_BTF_ID, with the correct type.
 		 */
 		mark_btf_ld_reg(env, cur_regs(env), value_regno, PTR_TO_BTF_ID, kptr_field->kptr.btf,
-				kptr_field->kptr.btf_id, PTR_MAYBE_NULL | PTR_UNTRUSTED);
+				kptr_field->kptr.btf_id,
+				kptr_field->type == BPF_KPTR_RCU && in_rcu_cs(env) ?
+				PTR_MAYBE_NULL | MEM_RCU :
+				PTR_MAYBE_NULL | PTR_UNTRUSTED);
 		/* For mark_ptr_or_null_reg */
 		val_reg->id = ++env->id_gen;
 	} else if (class == BPF_STX) {
@@ -4338,6 +4349,7 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 			switch (field->type) {
 			case BPF_KPTR_UNREF:
 			case BPF_KPTR_REF:
+			case BPF_KPTR_RCU:
 				if (src != ACCESS_DIRECT) {
 					verbose(env, "kptr cannot be accessed indirectly by helper\n");
 					return -EACCES;
@@ -5134,11 +5146,10 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
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
@@ -6182,7 +6193,7 @@ static int process_kptr_func(struct bpf_verifier_env *env, int regno,
 		verbose(env, "off=%d doesn't point to kptr\n", kptr_off);
 		return -EACCES;
 	}
-	if (kptr_field->type != BPF_KPTR_REF) {
+	if (kptr_field->type != BPF_KPTR_REF && kptr_field->type != BPF_KPTR_RCU) {
 		verbose(env, "off=%d kptr isn't referenced kptr\n", kptr_off);
 		return -EACCES;
 	}
@@ -9106,7 +9117,7 @@ static int process_kf_arg_ptr_to_kptr(struct bpf_verifier_env *env,
 	}
 
 	kptr_field = btf_record_find(reg->map_ptr->record, reg->off + reg->var_off.value, BPF_KPTR);
-	if (!kptr_field || kptr_field->type != BPF_KPTR_REF) {
+	if (!kptr_field || (kptr_field->type != BPF_KPTR_REF && kptr_field->type != BPF_KPTR_RCU)) {
 		verbose(env, "arg#0 no referenced kptr at map value offset=%llu\n",
 			reg->off + reg->var_off.value);
 		return -EINVAL;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 6f3d654b3339..73e5029ab5c9 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -737,6 +737,7 @@ __bpf_kfunc void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
 
 __bpf_kfunc void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p)
 {
+	/* p could be NULL and p->cnt could be 0 */
 }
 
 __bpf_kfunc void bpf_kfunc_call_test_destructive(void)
@@ -784,7 +785,7 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail3)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail2)
-BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS | KF_RCU)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_static_unused_arg)
 BTF_SET8_END(test_sk_check_kfunc_ids)
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
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 289ed202ec66..9a326a800e5c 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -243,7 +243,7 @@
 	},
 	.result_unpriv = REJECT,
 	.result = REJECT,
-	.errstr = "R1 must be referenced",
+	.errstr = "R1 must be",
 },
 {
 	"calls: valid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
-- 
2.30.2

