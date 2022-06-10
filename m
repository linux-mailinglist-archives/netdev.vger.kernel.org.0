Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727D7546B23
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350016AbiFJQ6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349665AbiFJQ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:58:14 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B9F3122D
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:11 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l14-20020a170903120e00b00168af494a94so2453779plh.4
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=53gIA+jneob3qvPE2G2GhD0Sv2uQZbqozTbV7pWLRHc=;
        b=r0xVGUordPN6eV09XwXG15l/LlviC/dEwmLhHX/bN7ydygzxGKZyb8mOsDIn+NA/hF
         LFrS/fSNh4B7MmvWNggE98qSODj9UZj3tIV07ZAT69FWb4ZNyQ6LoIw5XetGeuL1aAOw
         BpoNFjJA8NENOEONqjeT6Bp31pn5xq+TXDVYVMx9v0IXhlObMavfPxmwMZNlHFFFVmn3
         SSHsEoHjBU6vNgeYxe1WIhaZExaOQx2Kv/vnmkZkr2zktEBZutKEmGR89GZ8I+QJeZfE
         xgmoXniBpCDXIta/M3k6TZJbfkbrgGJNHpjarJiIycS/+GbCBvliO8gIsiv6dc1pX1wT
         uVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=53gIA+jneob3qvPE2G2GhD0Sv2uQZbqozTbV7pWLRHc=;
        b=hoFGIH1lHuqthPy3JhdCXy3K/9WPzfrM/G12EGCXM3nwaGBwgzpUtycNjve08PONMT
         z/ZBbZrQ4JrSyNvAH3epyxE5upa7s5CpzySwVuAVb+G+70T/3gNk8N40pKSDJL6RhHTU
         N4+XSQM/TV5VmzIVD10Lx5Uap/bTzlK8UttI1OOmkhovI9vbuYqv0Gd8V6aH2MMbsVpw
         4N3FiqVv8FBl+xbsYyA9nYqQeXCc4Iqtj7BpCm29F+DAkRQRnm/Mmcxnint7BHwqFIGU
         5McBIS2k3s0evVNDLc7uXEvmea1wUzpohvqgX8ARiS6n5fhDDQuuWIZ8FqncA15NcwWf
         +OJg==
X-Gm-Message-State: AOAM531EaDeq5Uy/rxpVTycUTsi1CzpUgStLuNob6tjL2LEB7T4+ZbIO
        wNDEYX4jyDQGkYkJsfUCIIFQ7txvlfw2B3k0togwlYRxst2AggcIle2sdUh+fTPuxDbRGBrtM4V
        /k00kW/ZI30jhBkGGh7feYv6KbGdn4VW61DmWE7GjBt+V6rpE4XdWHw==
X-Google-Smtp-Source: ABdhPJyCLDwt/pN78fsh5Ws49Gi6XmziDVez88G4Vbb+7A877pZIxkjOcqXlLvLwqxlnqL3b2+MDbmI=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:170b:b0:51b:d1fd:5335 with SMTP id
 h11-20020a056a00170b00b0051bd1fd5335mr42954526pfc.28.1654880290974; Fri, 10
 Jun 2022 09:58:10 -0700 (PDT)
Date:   Fri, 10 Jun 2022 09:57:56 -0700
In-Reply-To: <20220610165803.2860154-1-sdf@google.com>
Message-Id: <20220610165803.2860154-4-sdf@google.com>
Mime-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH bpf-next v9 03/10] bpf: per-cgroup lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 arch/x86/net/bpf_jit_comp.c     |  24 ++--
 include/linux/bpf-cgroup-defs.h |   8 ++
 include/linux/bpf-cgroup.h      |   7 ++
 include/linux/bpf.h             |  24 ++++
 include/linux/bpf_lsm.h         |  13 +++
 include/linux/btf_ids.h         |   3 +-
 include/uapi/linux/bpf.h        |   1 +
 kernel/bpf/bpf_lsm.c            |  48 ++++++++
 kernel/bpf/btf.c                |  11 ++
 kernel/bpf/cgroup.c             | 139 ++++++++++++++++++++--
 kernel/bpf/core.c               |   2 +
 kernel/bpf/syscall.c            |  10 ++
 kernel/bpf/trampoline.c         | 198 ++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c           |  32 ++++++
 tools/include/linux/btf_ids.h   |   4 +-
 tools/include/uapi/linux/bpf.h  |   1 +
 16 files changed, 504 insertions(+), 21 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index f298b18a9a3d..54a814fa41e0 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1770,6 +1770,10 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 			   struct bpf_tramp_link *l, int stack_size,
 			   int run_ctx_off, bool save_ret)
 {
+	void (*exit)(struct bpf_prog *prog, u64 start,
+		     struct bpf_tramp_run_ctx *run_ctx) = __bpf_prog_exit;
+	u64 (*enter)(struct bpf_prog *prog,
+		     struct bpf_tramp_run_ctx *run_ctx) = __bpf_prog_enter;
 	u8 *prog = *pprog;
 	u8 *jmp_insn;
 	int ctx_cookie_off = offsetof(struct bpf_tramp_run_ctx, bpf_cookie);
@@ -1788,15 +1792,21 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	 */
 	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_1, -run_ctx_off + ctx_cookie_off);
 
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
 	/* arg2: lea rsi, [rbp - ctx_cookie_off] */
 	EMIT4(0x48, 0x8D, 0x75, -run_ctx_off);
 
-	if (emit_call(&prog,
-		      p->aux->sleepable ? __bpf_prog_enter_sleepable :
-		      __bpf_prog_enter, prog))
-			return -EINVAL;
+	if (emit_call(&prog, enter, prog))
+		return -EINVAL;
 	/* remember prog start time returned by __bpf_prog_enter */
 	emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
 
@@ -1840,10 +1850,8 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
 	/* arg3: lea rdx, [rbp - run_ctx_off] */
 	EMIT4(0x48, 0x8D, 0x55, -run_ctx_off);
-	if (emit_call(&prog,
-		      p->aux->sleepable ? __bpf_prog_exit_sleepable :
-		      __bpf_prog_exit, prog))
-			return -EINVAL;
+	if (emit_call(&prog, exit, prog))
+		return -EINVAL;
 
 	*pprog = prog;
 	return 0;
diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 5d268e76d8e6..b99f8c3e37ea 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -10,6 +10,12 @@
 
 struct bpf_prog_array;
 
+#ifdef CONFIG_BPF_LSM
+#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
+#else
+#define CGROUP_LSM_NUM 0
+#endif
+
 enum cgroup_bpf_attach_type {
 	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
 	CGROUP_INET_INGRESS = 0,
@@ -35,6 +41,8 @@ enum cgroup_bpf_attach_type {
 	CGROUP_INET4_GETSOCKNAME,
 	CGROUP_INET6_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
+	CGROUP_LSM_START,
+	CGROUP_LSM_END = CGROUP_LSM_START + CGROUP_LSM_NUM - 1,
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
index b0af68b6297b..4dceb86229f6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -778,6 +778,10 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
 u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx);
 void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
 				       struct bpf_tramp_run_ctx *run_ctx);
+u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
+					struct bpf_tramp_run_ctx *run_ctx);
+void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
+					struct bpf_tramp_run_ctx *run_ctx);
 void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
 void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
 
@@ -1044,6 +1048,7 @@ struct bpf_prog_aux {
 	struct user_struct *user;
 	u64 load_time; /* ns since boottime */
 	u32 verified_insns;
+	int cgroup_atype; /* enum cgroup_bpf_attach_type */
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	char name[BPF_OBJ_NAME_LEN];
 #ifdef CONFIG_SECURITY
@@ -1117,6 +1122,11 @@ struct bpf_tramp_link {
 	u64 cookie;
 };
 
+struct bpf_shim_tramp_link {
+	struct bpf_tramp_link link;
+	struct bpf_trampoline *trampoline;
+};
+
 struct bpf_tracing_link {
 	struct bpf_tramp_link link;
 	enum bpf_attach_type attach_type;
@@ -1195,6 +1205,9 @@ struct bpf_dummy_ops {
 int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
 			    union bpf_attr __user *uattr);
 #endif
+int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+				    int cgroup_atype);
+void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
 #else
 static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
 {
@@ -1218,6 +1231,14 @@ static inline int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map,
 {
 	return -EINVAL;
 }
+static inline int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+						  int cgroup_atype)
+{
+	return -EOPNOTSUPP;
+}
+static inline void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
+{
+}
 #endif
 
 struct bpf_array {
@@ -2267,6 +2288,8 @@ extern const struct bpf_func_proto bpf_loop_proto;
 extern const struct bpf_func_proto bpf_strncmp_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_task_proto;
 extern const struct bpf_func_proto bpf_kptr_xchg_proto;
+extern const struct bpf_func_proto bpf_set_retval_proto;
+extern const struct bpf_func_proto bpf_get_retval_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
@@ -2384,6 +2407,7 @@ int bpf_arch_text_invalidate(void *dst, size_t len);
 
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
+int btf_id_set_index(const struct btf_id_set *set, u32 id);
 
 #define MAX_BPRINTF_VARARGS		12
 
diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 479c101546ad..61787a5f6af9 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -42,6 +42,9 @@ extern const struct bpf_func_proto bpf_inode_storage_get_proto;
 extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
 void bpf_inode_storage_free(struct inode *inode);
 
+int bpf_lsm_hook_idx(u32 btf_id);
+void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
+
 #else /* !CONFIG_BPF_LSM */
 
 static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
@@ -65,6 +68,16 @@ static inline void bpf_inode_storage_free(struct inode *inode)
 {
 }
 
+static inline void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
+					   bpf_func_t *bpf_func)
+{
+}
+
+static inline int bpf_lsm_hook_idx(u32 btf_id)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_BPF_LSM */
 
 #endif /* _LINUX_BPF_LSM_H */
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 335a19092368..252a4befeab1 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -179,7 +179,8 @@ extern struct btf_id_set name;
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_MPTCP, mptcp_sock)
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_MPTCP, mptcp_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCKET, socket)
 
 enum {
 #define BTF_SOCK_TYPE(name, str) name,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f4009dbdf62d..fa64b0b612fd 100644
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
index c1351df9f7ee..0f72020bfdcf 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/bpf_local_storage.h>
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
+#include <linux/bpf-cgroup.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached.
@@ -35,6 +36,44 @@ BTF_SET_START(bpf_lsm_hooks)
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
+void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
+			     bpf_func_t *bpf_func)
+{
+	const struct btf_param *args;
+
+	if (btf_type_vlen(prog->aux->attach_func_proto) < 1 ||
+	    btf_id_set_contains(&bpf_lsm_current_hooks,
+				prog->aux->attach_btf_id)) {
+		*bpf_func = __cgroup_bpf_run_lsm_current;
+		return;
+	}
+
+	args = btf_params(prog->aux->attach_func_proto);
+
+#ifdef CONFIG_NET
+	if (args[0].type == btf_sock_ids[BTF_SOCK_TYPE_SOCKET])
+		*bpf_func = __cgroup_bpf_run_lsm_socket;
+	else if (args[0].type == btf_sock_ids[BTF_SOCK_TYPE_SOCK])
+		*bpf_func = __cgroup_bpf_run_lsm_sock;
+	else
+#endif
+		*bpf_func = __cgroup_bpf_run_lsm_current;
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
@@ -158,6 +197,15 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
 	case BPF_FUNC_get_attach_cookie:
 		return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
+	case BPF_FUNC_get_local_storage:
+		return prog->expected_attach_type == BPF_LSM_CGROUP ?
+			&bpf_get_local_storage_proto : NULL;
+	case BPF_FUNC_set_retval:
+		return prog->expected_attach_type == BPF_LSM_CGROUP ?
+			&bpf_set_retval_proto : NULL;
+	case BPF_FUNC_get_retval:
+		return prog->expected_attach_type == BPF_LSM_CGROUP ?
+			&bpf_get_retval_proto : NULL;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6c0d8480e15c..ec070d7f2f7a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5363,6 +5363,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 	if (arg == nr_args) {
 		switch (prog->expected_attach_type) {
+		case BPF_LSM_CGROUP:
 		case BPF_LSM_MAC:
 		case BPF_TRACE_FEXIT:
 			/* When LSM programs are attached to void LSM hooks
@@ -6841,6 +6842,16 @@ static int btf_id_cmp_func(const void *a, const void *b)
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
index 4adb4f3ecb7f..b0314889a409 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -14,6 +14,8 @@
 #include <linux/string.h>
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/bpf_lsm.h>
+#include <linux/bpf_verifier.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
 
@@ -61,6 +63,88 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 	return run_ctx.retval;
 }
 
+unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
+				       const struct bpf_insn *insn)
+{
+	const struct bpf_prog *shim_prog;
+	struct sock *sk;
+	struct cgroup *cgrp;
+	int ret = 0;
+	u64 *args;
+
+	args = (u64 *)ctx;
+	sk = (void *)(unsigned long)args[0];
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
+	u64 *args;
+
+	args = (u64 *)ctx;
+	sock = (void *)(unsigned long)args[0];
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
+static enum cgroup_bpf_attach_type
+bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
+{
+	if (attach_type != BPF_LSM_CGROUP)
+		return to_cgroup_bpf_attach_type(attach_type);
+	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
+}
+#else
+static enum cgroup_bpf_attach_type
+bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
+{
+	if (attach_type != BPF_LSM_CGROUP)
+		return to_cgroup_bpf_attach_type(attach_type);
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_BPF_LSM */
+
 void cgroup_bpf_offline(struct cgroup *cgrp)
 {
 	cgroup_get(cgrp);
@@ -163,10 +247,20 @@ static void cgroup_bpf_release(struct work_struct *work)
 
 		hlist_for_each_entry_safe(pl, pltmp, progs, node) {
 			hlist_del(&pl->node);
-			if (pl->prog)
+			if (pl->prog) {
+#ifdef CONFIG_BPF_LSM
+				if (pl->prog->expected_attach_type == BPF_LSM_CGROUP)
+					bpf_trampoline_unlink_cgroup_shim(pl->prog);
+#endif
 				bpf_prog_put(pl->prog);
-			if (pl->link)
+			}
+			if (pl->link) {
+#ifdef CONFIG_BPF_LSM
+				if (pl->link->link.prog->expected_attach_type == BPF_LSM_CGROUP)
+					bpf_trampoline_unlink_cgroup_shim(pl->link->link.prog);
+#endif
 				bpf_cgroup_link_auto_detach(pl->link);
+			}
 			kfree(pl);
 			static_branch_dec(&cgroup_bpf_enabled_key[atype]);
 		}
@@ -479,6 +573,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_prog *old_prog = NULL;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_prog *new_prog = prog ? : link->link.prog;
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_list *pl;
 	struct hlist_head *progs;
@@ -495,7 +590,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		/* replace_prog implies BPF_F_REPLACE, and vice versa */
 		return -EINVAL;
 
-	atype = to_cgroup_bpf_attach_type(type);
+	atype = bpf_cgroup_atype_find(type, new_prog->aux->attach_btf_id);
 	if (atype < 0)
 		return -EINVAL;
 
@@ -549,17 +644,30 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	bpf_cgroup_storages_assign(pl->storage, storage);
 	cgrp->bpf.flags[atype] = saved_flags;
 
+	if (type == BPF_LSM_CGROUP) {
+		err = bpf_trampoline_link_cgroup_shim(new_prog, atype);
+		if (err)
+			goto cleanup;
+	}
+
 	err = update_effective_progs(cgrp, atype);
 	if (err)
-		goto cleanup;
+		goto cleanup_trampoline;
 
-	if (old_prog)
+	if (old_prog) {
+		if (type == BPF_LSM_CGROUP)
+			bpf_trampoline_unlink_cgroup_shim(old_prog);
 		bpf_prog_put(old_prog);
-	else
+	} else {
 		static_branch_inc(&cgroup_bpf_enabled_key[atype]);
+	}
 	bpf_cgroup_storages_link(new_storage, cgrp, type);
 	return 0;
 
+cleanup_trampoline:
+	if (type == BPF_LSM_CGROUP)
+		bpf_trampoline_unlink_cgroup_shim(new_prog);
+
 cleanup:
 	if (old_prog) {
 		pl->prog = old_prog;
@@ -651,7 +759,7 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	struct hlist_head *progs;
 	bool found = false;
 
-	atype = to_cgroup_bpf_attach_type(link->type);
+	atype = bpf_cgroup_atype_find(link->type, new_prog->aux->attach_btf_id);
 	if (atype < 0)
 		return -EINVAL;
 
@@ -803,9 +911,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	struct bpf_prog *old_prog;
 	struct bpf_prog_list *pl;
 	struct hlist_head *progs;
+	u32 attach_btf_id = 0;
 	u32 flags;
 
-	atype = to_cgroup_bpf_attach_type(type);
+	if (prog)
+		attach_btf_id = prog->aux->attach_btf_id;
+	if (link)
+		attach_btf_id = link->link.prog->aux->attach_btf_id;
+
+	atype = bpf_cgroup_atype_find(type, attach_btf_id);
 	if (atype < 0)
 		return -EINVAL;
 
@@ -839,8 +953,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	if (hlist_empty(progs))
 		/* last program was detached, reset flags to zero */
 		cgrp->bpf.flags[atype] = 0;
-	if (old_prog)
+	if (old_prog) {
+		if (type == BPF_LSM_CGROUP)
+			bpf_trampoline_unlink_cgroup_shim(old_prog);
 		bpf_prog_put(old_prog);
+	}
 	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
 	return 0;
 }
@@ -1343,7 +1460,7 @@ BPF_CALL_0(bpf_get_retval)
 	return ctx->retval;
 }
 
-static const struct bpf_func_proto bpf_get_retval_proto = {
+const struct bpf_func_proto bpf_get_retval_proto = {
 	.func		= bpf_get_retval,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
@@ -1358,7 +1475,7 @@ BPF_CALL_1(bpf_set_retval, int, retval)
 	return 0;
 }
 
-static const struct bpf_func_proto bpf_set_retval_proto = {
+const struct bpf_func_proto bpf_set_retval_proto = {
 	.func		= bpf_set_retval,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index e78cc5eea4a5..8d171eb0ed0d 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2651,6 +2651,8 @@ const struct bpf_func_proto bpf_get_local_storage_proto __weak;
 const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
 const struct bpf_func_proto bpf_snprintf_btf_proto __weak;
 const struct bpf_func_proto bpf_seq_printf_btf_proto __weak;
+const struct bpf_func_proto bpf_set_retval_proto __weak;
+const struct bpf_func_proto bpf_get_retval_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index aeb31137b2ed..a237be4f8bb3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3416,6 +3416,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_LOOKUP;
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
+	case BPF_LSM_CGROUP:
+		return BPF_PROG_TYPE_LSM;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3469,6 +3471,11 @@ static int bpf_prog_attach(const union bpf_attr *attr)
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
@@ -3506,6 +3513,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_LSM:
 		return cgroup_bpf_prog_detach(attr, ptype);
 	default:
 		return -EINVAL;
@@ -4540,6 +4548,8 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 			ret = bpf_raw_tp_link_attach(prog, NULL);
 		else if (prog->expected_attach_type == BPF_TRACE_ITER)
 			ret = bpf_iter_link_attach(attr, uattr, prog);
+		else if (prog->expected_attach_type == BPF_LSM_CGROUP)
+			ret = cgroup_bpf_link_attach(attr, prog);
 		else
 			ret = bpf_tracing_prog_attach(prog,
 						      attr->link_create.target_fd,
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 5466e15be61f..023239a10e7c 100644
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
@@ -496,6 +498,177 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
 	return err;
 }
 
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
+static void bpf_shim_tramp_link_release(struct bpf_link *link)
+{
+	struct bpf_shim_tramp_link *shim_link =
+		container_of(link, struct bpf_shim_tramp_link, link.link);
+
+	/* paired with 'shim_link->trampoline = tr' in bpf_trampoline_link_cgroup_shim */
+	if (!shim_link->trampoline)
+		return;
+
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&shim_link->link, shim_link->trampoline));
+	bpf_trampoline_put(shim_link->trampoline);
+}
+
+static void bpf_shim_tramp_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_shim_tramp_link *shim_link =
+		container_of(link, struct bpf_shim_tramp_link, link.link);
+
+	kfree(shim_link);
+}
+
+static const struct bpf_link_ops bpf_shim_tramp_link_lops = {
+	.release = bpf_shim_tramp_link_release,
+	.dealloc = bpf_shim_tramp_link_dealloc,
+};
+
+static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
+						     bpf_func_t bpf_func,
+						     int cgroup_atype)
+{
+	struct bpf_shim_tramp_link *shim_link = NULL;
+	struct bpf_prog *p;
+
+	shim_link = kzalloc(sizeof(*shim_link), GFP_USER);
+	if (!shim_link)
+		return NULL;
+
+	p = bpf_prog_alloc(1, 0);
+	if (!p) {
+		kfree(shim_link);
+		return NULL;
+	}
+
+	p->jited = false;
+	p->bpf_func = bpf_func;
+
+	p->aux->cgroup_atype = cgroup_atype;
+	p->aux->attach_func_proto = prog->aux->attach_func_proto;
+	p->aux->attach_btf_id = prog->aux->attach_btf_id;
+	p->aux->attach_btf = prog->aux->attach_btf;
+	btf_get(p->aux->attach_btf);
+	p->type = BPF_PROG_TYPE_LSM;
+	p->expected_attach_type = BPF_LSM_MAC;
+	bpf_prog_inc(p);
+	bpf_link_init(&shim_link->link.link, BPF_LINK_TYPE_UNSPEC,
+		      &bpf_shim_tramp_link_lops, p);
+
+	return shim_link;
+}
+
+static struct bpf_shim_tramp_link *cgroup_shim_find(struct bpf_trampoline *tr,
+						    bpf_func_t bpf_func)
+{
+	struct bpf_tramp_link *link;
+	int kind;
+
+	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
+		hlist_for_each_entry(link, &tr->progs_hlist[kind], tramp_hlist) {
+			struct bpf_prog *p = link->link.prog;
+
+			if (p->bpf_func == bpf_func)
+				return container_of(link, struct bpf_shim_tramp_link, link);
+		}
+	}
+
+	return NULL;
+}
+
+int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+				    int cgroup_atype)
+{
+	struct bpf_shim_tramp_link *shim_link = NULL;
+	struct bpf_attach_target_info tgt_info = {};
+	struct bpf_trampoline *tr;
+	bpf_func_t bpf_func;
+	u64 key;
+	int err;
+
+	err = bpf_check_attach_target(NULL, prog, NULL,
+				      prog->aux->attach_btf_id,
+				      &tgt_info);
+	if (err)
+		return err;
+
+	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
+					 prog->aux->attach_btf_id);
+
+	bpf_lsm_find_cgroup_shim(prog, &bpf_func);
+	tr = bpf_trampoline_get(key, &tgt_info);
+	if (!tr)
+		return  -ENOMEM;
+
+	mutex_lock(&tr->mutex);
+
+	shim_link = cgroup_shim_find(tr, bpf_func);
+	if (shim_link) {
+		/* Reusing existing shim attached by the other program. */
+		bpf_link_inc(&shim_link->link.link);
+
+		mutex_unlock(&tr->mutex);
+		bpf_trampoline_put(tr); /* bpf_trampoline_get above */
+		return 0;
+	}
+
+	/* Allocate and install new shim. */
+
+	shim_link = cgroup_shim_alloc(prog, bpf_func, cgroup_atype);
+	if (!shim_link) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	err = __bpf_trampoline_link_prog(&shim_link->link, tr);
+	if (err)
+		goto err;
+
+	shim_link->trampoline = tr;
+	/* note, we're still holding tr refcnt from above */
+
+	mutex_unlock(&tr->mutex);
+
+	return 0;
+err:
+	mutex_unlock(&tr->mutex);
+
+	if (shim_link)
+		bpf_link_put(&shim_link->link.link);
+
+	/* have to release tr while _not_ holding its mutex */
+	bpf_trampoline_put(tr); /* bpf_trampoline_get above */
+
+	return err;
+}
+
+void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
+{
+	struct bpf_shim_tramp_link *shim_link = NULL;
+	struct bpf_trampoline *tr;
+	bpf_func_t bpf_func;
+	u64 key;
+
+	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
+					 prog->aux->attach_btf_id);
+
+	bpf_lsm_find_cgroup_shim(prog, &bpf_func);
+	tr = bpf_trampoline_lookup(key);
+	if (!tr)
+		return;
+
+	mutex_lock(&tr->mutex);
+	shim_link = cgroup_shim_find(tr, bpf_func);
+	mutex_unlock(&tr->mutex);
+
+	if (shim_link)
+		bpf_link_put(&shim_link->link.link);
+
+	bpf_trampoline_put(tr); /* bpf_trampoline_lookup above */
+}
+#endif
+
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info)
 {
@@ -628,6 +801,31 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
 	rcu_read_unlock();
 }
 
+u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
+					struct bpf_tramp_run_ctx *run_ctx)
+	__acquires(RCU)
+{
+	/* Runtime stats are exported via actual BPF_LSM_CGROUP
+	 * programs, not the shims.
+	 */
+	rcu_read_lock();
+	migrate_disable();
+
+	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
+
+	return NO_START_TIME;
+}
+
+void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
+					struct bpf_tramp_run_ctx *run_ctx)
+	__releases(RCU)
+{
+	bpf_reset_run_ctx(run_ctx->saved_run_ctx);
+
+	migrate_enable();
+	rcu_read_unlock();
+}
+
 u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx)
 {
 	rcu_read_lock_trace();
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2d2872682278..975145d6bbee 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7264,6 +7264,18 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 				reg_type_str(env, regs[BPF_REG_1].type));
 			return -EACCES;
 		}
+		break;
+	case BPF_FUNC_set_retval:
+		if (env->prog->expected_attach_type == BPF_LSM_CGROUP) {
+			if (!env->prog->aux->attach_func_proto->type) {
+				/* Make sure programs that attach to void
+				 * hooks don't try to modify return value.
+				 */
+				verbose(env, "BPF_LSM_CGROUP that attach to void LSM hooks can't modify return value!\n");
+				return -EINVAL;
+			}
+		}
+		break;
 	}
 
 	if (err)
@@ -10474,6 +10486,22 @@ static int check_return_code(struct bpf_verifier_env *env)
 	case BPF_PROG_TYPE_SK_LOOKUP:
 		range = tnum_range(SK_DROP, SK_PASS);
 		break;
+
+	case BPF_PROG_TYPE_LSM:
+		if (env->prog->expected_attach_type != BPF_LSM_CGROUP) {
+			/* Regular BPF_PROG_TYPE_LSM programs can return
+			 * any value.
+			 */
+			return 0;
+		}
+		if (!env->prog->aux->attach_func_proto->type) {
+			/* Make sure programs that attach to void
+			 * hooks don't try to modify return value.
+			 */
+			range = tnum_range(1, 1);
+		}
+		break;
+
 	case BPF_PROG_TYPE_EXT:
 		/* freplace program can return anything as its return value
 		 * depends on the to-be-replaced kernel func or bpf program.
@@ -10490,6 +10518,9 @@ static int check_return_code(struct bpf_verifier_env *env)
 
 	if (!tnum_in(range, reg->var_off)) {
 		verbose_invalid_scalar(env, reg, &range, "program exit", "R0");
+		if (prog->expected_attach_type == BPF_LSM_CGROUP &&
+		    !prog->aux->attach_func_proto->type)
+			verbose(env, "Note, BPF_LSM_CGROUP that attach to void LSM hooks can't modify return value!\n");
 		return -EINVAL;
 	}
 
@@ -14713,6 +14744,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		fallthrough;
 	case BPF_MODIFY_RETURN:
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP:
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
 		if (!btf_type_is_func(t)) {
diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
index 57890b357f85..2345b502b439 100644
--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -172,7 +172,9 @@ extern struct btf_id_set name;
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCKET, socket)
 
 enum {
 #define BTF_SOCK_TYPE(name, str) name,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f4009dbdf62d..fa64b0b612fd 100644
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
2.36.1.476.g0c4daa206d-goog

