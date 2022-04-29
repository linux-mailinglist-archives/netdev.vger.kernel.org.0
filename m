Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B989515696
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbiD2VTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbiD2VTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:19:12 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC19C7CDD6
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:50 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f84aeb403fso78396007b3.22
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=97hzPb+RapHz2LLgk+QHniiLYwk5sZ0XCZRSsdHMJq0=;
        b=Fuwxgb+X1hGohvbz3nAAz/1+KgTOmbRUONHu62jJrOnvyyK9nQU44Cpq9w2J57bOpN
         o9XMvPppMAw4Z732wT/8dd1Jt6tXQDtrkxnrE59X5NJeykiqMbaJGzweDsfUemaaGjAp
         aZxsKzs+sA6pNUKYfgNuvnCrokar9ZKHqJFXs/tZVmxi3kI+EBVwFkOLHAznehfobAJE
         RYvUxpBifHjnuHUj+smHFI8Un6xExQ5JpDMWTnUKZk+H6HMCk3GI4a+1wMWJgvAhlRda
         TxLaFV2pZjPwdYTB5DZWcPJyoK/21Xu2IgLnkiZkh2sqj+wRZPdWB8fqEzssXM9wj8/6
         hdEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=97hzPb+RapHz2LLgk+QHniiLYwk5sZ0XCZRSsdHMJq0=;
        b=BJxGJWyNqdsdBG/e9DFZ/Eg6+cW95oPqvw0TmPwDDPqa2PRegIkFkUEuOjPn1s7smC
         KFylYlSFZkAhjhOWBULZgNOXuDS6oxY2J7vQ5etVGPqyhTb3IFoArRXANzfhR7ANVGud
         N6LTgni4T0t8XhbSb0LF3tgRxZaU6mhPhDmjEXZg1R73fF4bUvBzhUNdTvZ24VH5rBjv
         TcchE8GjlL8pSfQsv7MTXdz3Dr/23x+hj5LZsMXz4ohGbaZBXgnXBNxI5xwN2PybDRWm
         qw7v4gAcXZ0oXJCKUUEs474iys+K0yPGL0ocWPUEl8YmhlCA+k4XVRlRMveVeRSK11vC
         CGig==
X-Gm-Message-State: AOAM530r+ElNZVwEnmjtQMbzyPQDGZo16X0cJdkOrtDKfYElN9nD9gkx
        NNfoVu8zVms6cPWJWVV/UyoZhRsNSBcRHWIVRs2dZszzJ+4kkUX5rdeHogK7mriEpNZytbXWyS6
        K1adtQl79kZ/Enac6EL8gxfcog9UiIhqDXOQRfxyKUtybWH5EFjfuig==
X-Google-Smtp-Source: ABdhPJxLs5ZoEXUwxili4ArEeT9CiZ/G0wcOMowmbMKGpkItM5hrxPjxJVwM0VLagxdU2EjXulEQclo=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b0cc:7605:1029:2d96])
 (user=sdf job=sendgmr) by 2002:a81:7d46:0:b0:2f8:f29:c9ea with SMTP id
 y67-20020a817d46000000b002f80f29c9eamr1343683ywc.362.1651266950145; Fri, 29
 Apr 2022 14:15:50 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:15:33 -0700
In-Reply-To: <20220429211540.715151-1-sdf@google.com>
Message-Id: <20220429211540.715151-4-sdf@google.com>
Mime-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH bpf-next v6 03/10] bpf: per-cgroup lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow attaching to lsm hooks in the cgroup context.

Attaching to per-cgroup LSM works exactly like attaching
to other per-cgroup hooks. New BPF_LSM_CGROUP is added
to trigger new mode; the actual lsm hook we attach to is
signaled via existing attach_btf_id.

For the hooks that have 'struct socket' or 'struct sock' as its first
argument, we use the cgroup associated with that socket. For the rest,
we use 'current' cgroup (this is all on default hierarchy == v2 only).
Note that for some hooks that work on 'struct sock' we still
take the cgroup from 'current' because some of them work on the socket
that hasn't been properly initialized yet.

Behind the scenes, we allocate a shim program that is attached
to the trampoline and runs cgroup effective BPF programs array.
This shim has some rudimentary ref counting and can be shared
between several programs attaching to the same per-cgroup lsm hook.

Note that this patch bloats cgroup size because we add 211
cgroup_bpf_attach_type(s) for simplicity sake. This will be
addressed in the subsequent patch.

Also note that we only add non-sleepable flavor for now. To enable
sleepable use-cases, bpf_prog_run_array_cg has to grab trace rcu,
shim programs have to be freed via trace rcu, cgroup_bpf.effective
should be also trace-rcu-managed + maybe some other changes that
I'm not aware of.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 arch/x86/net/bpf_jit_comp.c     |  22 ++--
 include/linux/bpf-cgroup-defs.h |   6 ++
 include/linux/bpf-cgroup.h      |   7 ++
 include/linux/bpf.h             |  15 +++
 include/linux/bpf_lsm.h         |  14 +++
 include/uapi/linux/bpf.h        |   1 +
 kernel/bpf/bpf_lsm.c            |  64 ++++++++++++
 kernel/bpf/btf.c                |  11 ++
 kernel/bpf/cgroup.c             | 179 +++++++++++++++++++++++++++++---
 kernel/bpf/syscall.c            |  10 ++
 kernel/bpf/trampoline.c         | 161 ++++++++++++++++++++++++++++
 kernel/bpf/verifier.c           |  32 ++++++
 tools/include/uapi/linux/bpf.h  |   1 +
 13 files changed, 503 insertions(+), 20 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 16b6efacf7c6..0b11be002c28 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1764,15 +1764,23 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
 static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 			   struct bpf_prog *p, int stack_size, bool save_ret)
 {
+	void (*exit)(struct bpf_prog *prog, u64 start) = __bpf_prog_exit;
+	u64 (*enter)(struct bpf_prog *prog) = __bpf_prog_enter;
 	u8 *prog = *pprog;
 	u8 *jmp_insn;
 
+	if (p->aux->sleepable) {
+		enter = __bpf_prog_enter_sleepable;
+		exit = __bpf_prog_exit_sleepable;
+	} else if (p->expected_attach_type == BPF_LSM_CGROUP) {
+		enter = __bpf_prog_enter_lsm_cgroup;
+		exit = __bpf_prog_exit_lsm_cgroup;
+	}
+
 	/* arg1: mov rdi, progs[i] */
 	emit_mov_imm64(&prog, BPF_REG_1, (long) p >> 32, (u32) (long) p);
-	if (emit_call(&prog,
-		      p->aux->sleepable ? __bpf_prog_enter_sleepable :
-		      __bpf_prog_enter, prog))
-			return -EINVAL;
+	if (emit_call(&prog, enter, prog))
+		return -EINVAL;
 	/* remember prog start time returned by __bpf_prog_enter */
 	emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
 
@@ -1814,10 +1822,8 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	emit_mov_imm64(&prog, BPF_REG_1, (long) p >> 32, (u32) (long) p);
 	/* arg2: mov rsi, rbx <- start time in nsec */
 	emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
-	if (emit_call(&prog,
-		      p->aux->sleepable ? __bpf_prog_exit_sleepable :
-		      __bpf_prog_exit, prog))
-			return -EINVAL;
+	if (emit_call(&prog, exit, prog))
+		return -EINVAL;
 
 	*pprog = prog;
 	return 0;
diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 5d268e76d8e6..d5a70a35dace 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -10,6 +10,8 @@
 
 struct bpf_prog_array;
 
+#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
+
 enum cgroup_bpf_attach_type {
 	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
 	CGROUP_INET_INGRESS = 0,
@@ -35,6 +37,10 @@ enum cgroup_bpf_attach_type {
 	CGROUP_INET4_GETSOCKNAME,
 	CGROUP_INET6_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
+#ifdef CONFIG_BPF_LSM
+	CGROUP_LSM_START,
+	CGROUP_LSM_END = CGROUP_LSM_START + CGROUP_LSM_NUM - 1,
+#endif
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 6673acfbf2ef..2bd1b5f8de9b 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -23,6 +23,13 @@ struct ctl_table;
 struct ctl_table_header;
 struct task_struct;
 
+unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
+				       const struct bpf_insn *insn);
+unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
+					 const struct bpf_insn *insn);
+unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
+					  const struct bpf_insn *insn);
+
 #ifdef CONFIG_CGROUP_BPF
 
 #define CGROUP_ATYPE(type) \
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0a8927103018..b4ab73c76140 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -762,6 +762,8 @@ u64 notrace __bpf_prog_enter(struct bpf_prog *prog);
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
 u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog);
 void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start);
+u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog);
+void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start);
 void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
 void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
 
@@ -1029,6 +1031,7 @@ struct bpf_prog_aux {
 	u64 load_time; /* ns since boottime */
 	u32 verified_insns;
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
+	int cgroup_atype; /* enum cgroup_bpf_attach_type */
 	char name[BPF_OBJ_NAME_LEN];
 #ifdef CONFIG_SECURITY
 	void *security;
@@ -1166,6 +1169,9 @@ struct bpf_dummy_ops {
 int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
 			    union bpf_attr __user *uattr);
 #endif
+int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+				    struct bpf_attach_target_info *tgt_info);
+void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
 #else
 static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
 {
@@ -1189,6 +1195,14 @@ static inline int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map,
 {
 	return -EINVAL;
 }
+static inline int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+						  struct bpf_attach_target_info *tgt_info)
+{
+	return -EOPNOTSUPP;
+}
+static inline void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
+{
+}
 #endif
 
 struct bpf_array {
@@ -2338,6 +2352,7 @@ void *bpf_arch_text_copy(void *dst, void *src, size_t len);
 
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
+int btf_id_set_index(const struct btf_id_set *set, u32 id);
 
 #define MAX_BPRINTF_VARARGS		12
 
diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 479c101546ad..7f0e59f5f9be 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -42,6 +42,9 @@ extern const struct bpf_func_proto bpf_inode_storage_get_proto;
 extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
 void bpf_inode_storage_free(struct inode *inode);
 
+int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
+int bpf_lsm_hook_idx(u32 btf_id);
+
 #else /* !CONFIG_BPF_LSM */
 
 static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
@@ -65,6 +68,17 @@ static inline void bpf_inode_storage_free(struct inode *inode)
 {
 }
 
+static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
+					   bpf_func_t *bpf_func)
+{
+	return -ENOENT;
+}
+
+static inline int bpf_lsm_hook_idx(u32 btf_id)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_BPF_LSM */
 
 #endif /* _LINUX_BPF_LSM_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 444fe6f1cf35..112e396bbe65 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -998,6 +998,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_TRACE_KPROBE_MULTI,
+	BPF_LSM_CGROUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 064eccba641d..a0e68ef5dfb1 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/bpf_local_storage.h>
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
+#include <linux/bpf-cgroup.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached.
@@ -35,6 +36,66 @@ BTF_SET_START(bpf_lsm_hooks)
 #undef LSM_HOOK
 BTF_SET_END(bpf_lsm_hooks)
 
+/* List of LSM hooks that should operate on 'current' cgroup regardless
+ * of function signature.
+ */
+BTF_SET_START(bpf_lsm_current_hooks)
+/* operate on freshly allocated sk without any cgroup association */
+BTF_ID(func, bpf_lsm_sk_alloc_security)
+BTF_ID(func, bpf_lsm_sk_free_security)
+BTF_SET_END(bpf_lsm_current_hooks)
+
+int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
+			     bpf_func_t *bpf_func)
+{
+	const struct btf_type *first_arg_type;
+	const struct btf_type *sock_type;
+	const struct btf_type *sk_type;
+	const struct btf *btf_vmlinux;
+	const struct btf_param *args;
+	s32 type_id;
+
+	if (!prog->aux->attach_func_proto ||
+	    !btf_type_is_func_proto(prog->aux->attach_func_proto))
+		return -EINVAL;
+
+	if (btf_type_vlen(prog->aux->attach_func_proto) < 1 ||
+	    btf_id_set_contains(&bpf_lsm_current_hooks,
+				prog->aux->attach_btf_id)) {
+		*bpf_func = __cgroup_bpf_run_lsm_current;
+		return 0;
+	}
+
+	args = btf_params(prog->aux->attach_func_proto);
+
+	btf_vmlinux = bpf_get_btf_vmlinux();
+
+	type_id = btf_find_by_name_kind(btf_vmlinux, "socket", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	sock_type = btf_type_by_id(btf_vmlinux, type_id);
+
+	type_id = btf_find_by_name_kind(btf_vmlinux, "sock", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	sk_type = btf_type_by_id(btf_vmlinux, type_id);
+
+	first_arg_type = btf_type_resolve_ptr(btf_vmlinux, args[0].type, NULL);
+	if (first_arg_type == sock_type)
+		*bpf_func = __cgroup_bpf_run_lsm_socket;
+	else if (first_arg_type == sk_type)
+		*bpf_func = __cgroup_bpf_run_lsm_sock;
+	else
+		*bpf_func = __cgroup_bpf_run_lsm_current;
+
+	return 0;
+}
+
+int bpf_lsm_hook_idx(u32 btf_id)
+{
+	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
+}
+
 int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 			const struct bpf_prog *prog)
 {
@@ -141,6 +202,9 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_ima_inode_hash_proto : NULL;
 	case BPF_FUNC_ima_file_hash:
 		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
+	case BPF_FUNC_get_local_storage:
+		return prog->expected_attach_type == BPF_LSM_CGROUP ?
+			&bpf_get_local_storage_proto : NULL;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2f0b0440131c..a90f04a8a8ee 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5248,6 +5248,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 	if (arg == nr_args) {
 		switch (prog->expected_attach_type) {
+		case BPF_LSM_CGROUP:
 		case BPF_LSM_MAC:
 		case BPF_TRACE_FEXIT:
 			/* When LSM programs are attached to void LSM hooks
@@ -6726,6 +6727,16 @@ static int btf_id_cmp_func(const void *a, const void *b)
 	return *pa - *pb;
 }
 
+int btf_id_set_index(const struct btf_id_set *set, u32 id)
+{
+	const u32 *p;
+
+	p = bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func);
+	if (!p)
+		return -1;
+	return p - set->ids;
+}
+
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
 {
 	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 134785ab487c..9cc38454e402 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -14,6 +14,9 @@
 #include <linux/string.h>
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/btf_ids.h>
+#include <linux/bpf_lsm.h>
+#include <linux/bpf_verifier.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
 
@@ -61,6 +64,85 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 	return run_ctx.retval;
 }
 
+unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
+				       const struct bpf_insn *insn)
+{
+	const struct bpf_prog *shim_prog;
+	struct sock *sk;
+	struct cgroup *cgrp;
+	int ret = 0;
+	u64 *regs;
+
+	regs = (u64 *)ctx;
+	sk = (void *)(unsigned long)regs[BPF_REG_0];
+	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
+	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
+
+	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	if (likely(cgrp))
+		ret = bpf_prog_run_array_cg(&cgrp->bpf,
+					    shim_prog->aux->cgroup_atype,
+					    ctx, bpf_prog_run, 0, NULL);
+	return ret;
+}
+
+unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
+					 const struct bpf_insn *insn)
+{
+	const struct bpf_prog *shim_prog;
+	struct socket *sock;
+	struct cgroup *cgrp;
+	int ret = 0;
+	u64 *regs;
+
+	regs = (u64 *)ctx;
+	sock = (void *)(unsigned long)regs[BPF_REG_0];
+	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
+	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
+
+	cgrp = sock_cgroup_ptr(&sock->sk->sk_cgrp_data);
+	if (likely(cgrp))
+		ret = bpf_prog_run_array_cg(&cgrp->bpf,
+					    shim_prog->aux->cgroup_atype,
+					    ctx, bpf_prog_run, 0, NULL);
+	return ret;
+}
+
+unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
+					  const struct bpf_insn *insn)
+{
+	const struct bpf_prog *shim_prog;
+	struct cgroup *cgrp;
+	int ret = 0;
+
+	if (unlikely(!current))
+		return 0;
+
+	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
+	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
+
+	rcu_read_lock();
+	cgrp = task_dfl_cgroup(current);
+	if (likely(cgrp))
+		ret = bpf_prog_run_array_cg(&cgrp->bpf,
+					    shim_prog->aux->cgroup_atype,
+					    ctx, bpf_prog_run, 0, NULL);
+	rcu_read_unlock();
+	return ret;
+}
+
+#ifdef CONFIG_BPF_LSM
+static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
+{
+	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
+}
+#else
+static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_BPF_LSM */
+
 void cgroup_bpf_offline(struct cgroup *cgrp)
 {
 	cgroup_get(cgrp);
@@ -139,6 +221,11 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
 	link->cgroup = NULL;
 }
 
+static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog)
+{
+	bpf_trampoline_unlink_cgroup_shim(prog);
+}
+
 /**
  * cgroup_bpf_release() - put references of all bpf programs and
  *                        release all cgroup bpf data
@@ -163,10 +250,16 @@ static void cgroup_bpf_release(struct work_struct *work)
 
 		hlist_for_each_entry_safe(pl, pltmp, progs, node) {
 			hlist_del(&pl->node);
-			if (pl->prog)
+			if (pl->prog) {
+				if (atype == BPF_LSM_CGROUP)
+					bpf_cgroup_lsm_shim_release(pl->prog);
 				bpf_prog_put(pl->prog);
-			if (pl->link)
+			}
+			if (pl->link) {
+				if (atype == BPF_LSM_CGROUP)
+					bpf_cgroup_lsm_shim_release(pl->link->link.prog);
 				bpf_cgroup_link_auto_detach(pl->link);
+			}
 			kfree(pl);
 			static_branch_dec(&cgroup_bpf_enabled_key[atype]);
 		}
@@ -479,6 +572,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_prog *old_prog = NULL;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_attach_target_info tgt_info = {};
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_list *pl;
 	struct hlist_head *progs;
@@ -495,9 +589,34 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		/* replace_prog implies BPF_F_REPLACE, and vice versa */
 		return -EINVAL;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
+	if (type == BPF_LSM_CGROUP) {
+		struct bpf_prog *p = prog ? : link->link.prog;
+
+		if (replace_prog) {
+			/* Reusing shim from the original program. */
+			if (replace_prog->aux->attach_btf_id !=
+			    p->aux->attach_btf_id)
+				return -EINVAL;
+
+			atype = replace_prog->aux->cgroup_atype;
+		} else {
+			err = bpf_check_attach_target(NULL, p, NULL,
+						      p->aux->attach_btf_id,
+						      &tgt_info);
+			if (err)
+				return -EINVAL;
+
+			atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
+			if (atype < 0)
+				return atype;
+		}
+
+		p->aux->cgroup_atype = atype;
+	} else {
+		atype = to_cgroup_bpf_attach_type(type);
+		if (atype < 0)
+			return -EINVAL;
+	}
 
 	progs = &cgrp->bpf.progs[atype];
 
@@ -549,9 +668,17 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	bpf_cgroup_storages_assign(pl->storage, storage);
 	cgrp->bpf.flags[atype] = saved_flags;
 
+	if (type == BPF_LSM_CGROUP && !old_prog) {
+		struct bpf_prog *p = prog ? : link->link.prog;
+
+		err = bpf_trampoline_link_cgroup_shim(p, &tgt_info);
+		if (err)
+			goto cleanup;
+	}
+
 	err = update_effective_progs(cgrp, atype);
 	if (err)
-		goto cleanup;
+		goto cleanup_trampoline;
 
 	if (old_prog)
 		bpf_prog_put(old_prog);
@@ -560,6 +687,13 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	bpf_cgroup_storages_link(new_storage, cgrp, type);
 	return 0;
 
+cleanup_trampoline:
+	if (type == BPF_LSM_CGROUP && !old_prog) {
+		struct bpf_prog *p = prog ? : link->link.prog;
+
+		bpf_trampoline_unlink_cgroup_shim(p);
+	}
+
 cleanup:
 	if (old_prog) {
 		pl->prog = old_prog;
@@ -651,9 +785,18 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	struct hlist_head *progs;
 	bool found = false;
 
-	atype = to_cgroup_bpf_attach_type(link->type);
-	if (atype < 0)
-		return -EINVAL;
+	if (link->type == BPF_LSM_CGROUP) {
+		atype = link->link.prog->aux->cgroup_atype;
+
+		/* Reusing shim from the original program. */
+		if (new_prog->aux->attach_btf_id !=
+		    link->link.prog->aux->attach_btf_id)
+			return -EINVAL;
+	} else {
+		atype = to_cgroup_bpf_attach_type(link->type);
+		if (atype < 0)
+			return -EINVAL;
+	}
 
 	progs = &cgrp->bpf.progs[atype];
 
@@ -669,6 +812,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	if (!found)
 		return -ENOENT;
 
+	if (link->type == BPF_LSM_CGROUP)
+		new_prog->aux->cgroup_atype = atype;
+
 	old_prog = xchg(&link->link.prog, new_prog);
 	replace_effective_prog(cgrp, atype, link);
 	bpf_prog_put(old_prog);
@@ -752,9 +898,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	u32 flags;
 	int err;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
+	if (type == BPF_LSM_CGROUP) {
+		struct bpf_prog *p = prog ? : link->link.prog;
+
+		atype = p->aux->cgroup_atype;
+	} else {
+		atype = to_cgroup_bpf_attach_type(type);
+		if (atype < 0)
+			return -EINVAL;
+	}
 
 	progs = &cgrp->bpf.progs[atype];
 	flags = cgrp->bpf.flags[atype];
@@ -776,6 +928,9 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	if (err)
 		goto cleanup;
 
+	if (old_prog && old_prog->expected_attach_type == BPF_LSM_CGROUP)
+		bpf_cgroup_lsm_shim_release(old_prog);
+
 	/* now can actually delete it from this cgroup list */
 	hlist_del(&pl->node);
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e0aead17dff4..53fe0ae9f8cf 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3421,6 +3421,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_LOOKUP;
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
+	case BPF_LSM_CGROUP:
+		return BPF_PROG_TYPE_LSM;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3474,6 +3476,11 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_LSM:
+		if (ptype == BPF_PROG_TYPE_LSM &&
+		    prog->expected_attach_type != BPF_LSM_CGROUP)
+			return -EINVAL;
+
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 		break;
 	default:
@@ -3511,6 +3518,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_LSM:
 		return cgroup_bpf_prog_detach(attr, ptype);
 	default:
 		return -EINVAL;
@@ -4543,6 +4551,8 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 			ret = bpf_raw_tp_link_attach(prog, NULL);
 		else if (prog->expected_attach_type == BPF_TRACE_ITER)
 			ret = bpf_iter_link_attach(attr, uattr, prog);
+		else if (prog->expected_attach_type == BPF_LSM_CGROUP)
+			ret = cgroup_bpf_link_attach(attr, prog);
 		else
 			ret = bpf_tracing_prog_attach(prog,
 						      attr->link_create.target_fd,
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 0c4fd194e801..77dfa517c47c 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -11,6 +11,8 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/module.h>
 #include <linux/static_call.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf_lsm.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -485,6 +487,147 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 	return err;
 }
 
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
+static struct bpf_prog *cgroup_shim_alloc(const struct bpf_prog *prog,
+					  bpf_func_t bpf_func)
+{
+	struct bpf_prog *p;
+
+	p = bpf_prog_alloc(1, 0);
+	if (!p)
+		return NULL;
+
+	p->jited = false;
+	p->bpf_func = bpf_func;
+
+	p->aux->cgroup_atype = prog->aux->cgroup_atype;
+	p->aux->attach_func_proto = prog->aux->attach_func_proto;
+	p->aux->attach_btf_id = prog->aux->attach_btf_id;
+	p->aux->attach_btf = prog->aux->attach_btf;
+	btf_get(p->aux->attach_btf);
+	p->type = BPF_PROG_TYPE_LSM;
+	p->expected_attach_type = BPF_LSM_MAC;
+	bpf_prog_inc(p);
+
+	return p;
+}
+
+static struct bpf_prog *cgroup_shim_find(struct bpf_trampoline *tr,
+					 bpf_func_t bpf_func)
+{
+	const struct bpf_prog_aux *aux;
+	int kind;
+
+	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
+		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
+			struct bpf_prog *p = aux->prog;
+
+			if (p->bpf_func == bpf_func)
+				return p;
+		}
+	}
+
+	return NULL;
+}
+
+int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+				    struct bpf_attach_target_info *tgt_info)
+{
+	struct bpf_prog *shim_prog = NULL;
+	struct bpf_trampoline *tr;
+	bpf_func_t bpf_func;
+	u64 key;
+	int err;
+
+	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
+					 prog->aux->attach_btf_id);
+
+	err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
+	if (err)
+		return err;
+
+	tr = bpf_trampoline_get(key, tgt_info);
+	if (!tr)
+		return  -ENOMEM;
+
+	mutex_lock(&tr->mutex);
+
+	shim_prog = cgroup_shim_find(tr, bpf_func);
+	if (shim_prog) {
+		/* Reusing existing shim attached by the other program. */
+		bpf_prog_inc(shim_prog);
+		mutex_unlock(&tr->mutex);
+		return 0;
+	}
+
+	/* Allocate and install new shim. */
+
+	shim_prog = cgroup_shim_alloc(prog, bpf_func);
+	if (!shim_prog) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = __bpf_trampoline_link_prog(shim_prog, tr);
+	if (err)
+		goto out;
+
+	mutex_unlock(&tr->mutex);
+
+	return 0;
+out:
+	if (shim_prog)
+		bpf_prog_put(shim_prog);
+
+	mutex_unlock(&tr->mutex);
+	return err;
+}
+
+void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
+{
+	struct bpf_prog *shim_prog;
+	struct bpf_trampoline *tr;
+	bpf_func_t bpf_func;
+	u64 key;
+	int err;
+
+	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
+					 prog->aux->attach_btf_id);
+
+	err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
+	if (err)
+		return;
+
+	tr = bpf_trampoline_lookup(key);
+	if (!tr)
+		return;
+
+	mutex_lock(&tr->mutex);
+
+	shim_prog = cgroup_shim_find(tr, bpf_func);
+	if (shim_prog) {
+		/* We use shim_prog refcnt for tracking whether to
+		 * remove the shim program from the trampoline.
+		 * Trampoline's mutex is held while refcnt is
+		 * added/subtracted so we don't need to care about
+		 * potential races.
+		 */
+
+		if (atomic64_read(&shim_prog->aux->refcnt) == 1)
+			WARN_ON_ONCE(__bpf_trampoline_unlink_prog(shim_prog, tr));
+
+		bpf_prog_put(shim_prog);
+	}
+
+	mutex_unlock(&tr->mutex);
+
+	bpf_trampoline_put(tr); /* bpf_trampoline_lookup */
+
+	if (shim_prog)
+		bpf_trampoline_put(tr);
+}
+#endif
+
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info)
 {
@@ -609,6 +752,24 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
 	rcu_read_unlock();
 }
 
+u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog)
+	__acquires(RCU)
+{
+	/* Runtime stats are exported via actual BPF_LSM_CGROUP
+	 * programs, not the shims.
+	 */
+	rcu_read_lock();
+	migrate_disable();
+	return NO_START_TIME;
+}
+
+void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start)
+	__releases(RCU)
+{
+	migrate_enable();
+	rcu_read_unlock();
+}
+
 u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog)
 {
 	rcu_read_lock_trace();
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 813f6ee80419..99703d96c579 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14455,6 +14455,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		fallthrough;
 	case BPF_MODIFY_RETURN:
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP:
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
 		if (!btf_type_is_func(t)) {
@@ -14633,6 +14634,33 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	return 0;
 }
 
+static int check_used_maps(struct bpf_verifier_env *env)
+{
+	int i;
+
+	for (i = 0; i < env->used_map_cnt; i++) {
+		struct bpf_map *map = env->used_maps[i];
+
+		switch (env->prog->expected_attach_type) {
+		case BPF_LSM_CGROUP:
+			if (map->map_type != BPF_MAP_TYPE_CGROUP_STORAGE &&
+			    map->map_type != BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
+				break;
+
+			if (map->key_size != sizeof(__u64)) {
+				verbose(env, "only global cgroup local storage is supported for BPF_LSM_CGROUP\n");
+				return -EINVAL;
+			}
+
+			break;
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
 struct btf *bpf_get_btf_vmlinux(void)
 {
 	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
@@ -14854,6 +14882,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 		convert_pseudo_ld_imm64(env);
 	}
 
+	ret = check_used_maps(env);
+	if (ret < 0)
+		goto err_release_maps;
+
 	adjust_btf_func(env);
 
 err_release_maps:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 444fe6f1cf35..112e396bbe65 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -998,6 +998,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_TRACE_KPROBE_MULTI,
+	BPF_LSM_CGROUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.36.0.464.gb9c8b46e94-goog

