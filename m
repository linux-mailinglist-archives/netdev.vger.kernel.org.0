Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8726041F90A
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 03:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhJBBTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 21:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbhJBBTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 21:19:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84457C061775;
        Fri,  1 Oct 2021 18:18:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n18so10901276pgm.12;
        Fri, 01 Oct 2021 18:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ca4SdbIhIHMuh9EoVTgPuluOrdenClS4TJHUJqAp3eo=;
        b=mB/0+iSnqIjUuvrzblrQe1B0xXtB1dVHZlr7PXnlN2bH2qQgDfLdQGpdiKwtW1Pcav
         u6R4RK1Eix13my0y5n3Wn3SV53zgXk8Z8WZzCF6DVRkaC+BS4697TnC5zh6y5oWofsvM
         jCAJ4i64ZLyoG9BsO3g1J6bs9XOv9ySf6aWS/k+D61Luz3ST3GqFOhZr6fwpxM4pFsA0
         X2Tkniu8ivezWQWNjyurK2zWxmymqadxsxRusVMUPEpr7Xq0EXux0dxNkCG0+TDtGyJZ
         6RAtAQqggj5D8++hWUIpEnxgiV7QuzE4adz4XoCSWeM2gv/g4yWKL6on71ar842VSyZJ
         wPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ca4SdbIhIHMuh9EoVTgPuluOrdenClS4TJHUJqAp3eo=;
        b=4XvNJXpVzkaRItix9XEhRZz9mG2LN6LZBaduphokWjltzWCMio4llurkoYj8LLJwmu
         dzLM3OVHwYakHG4nodyAA50sfVi+Gz+U98fEQMjQDdurhh9guYhBo5TobU7lyfbpWoNz
         Ro+z71naYqCr2c796UegC7e7Lp0W8pjoQ7cK40SYhWBLmi5UDI9VZB9DlSm7NCQxI3Lw
         RK4OWE/fYGJyAlPgfvMysrZz4vxtQaammJS0AeIqMj9H1RZOdxNuqfFZvI8A+Zh7SgXQ
         0yz1xzI2Xt2BVfk798CqVGcBW781DcnL2v//qA/l6646ZaCR9j0kOxGpJVGa2b17VHjk
         JM+Q==
X-Gm-Message-State: AOAM530c6wFbR7b6yhmi93QijXbRigNE7+CugJfFL6YDkESbhoB1+N/M
        gx4Wvn53dn9+VzThtGc4/rlSI5urfNo=
X-Google-Smtp-Source: ABdhPJzmXBwDazSegIFHqTimKmI4RUpgoCbq4kaWGdrQtMbaz7RVtXpx1khbOfyu6nl5W2iCsuxahQ==
X-Received: by 2002:a63:6a0a:: with SMTP id f10mr885403pgc.105.1633137483775;
        Fri, 01 Oct 2021 18:18:03 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j9sm7236405pfi.121.2021.10.01.18.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:18:03 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v7 1/9] bpf: Introduce BPF support for kernel module function calls
Date:   Sat,  2 Oct 2021 06:47:49 +0530
Message-Id: <20211002011757.311265-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211002011757.311265-1-memxor@gmail.com>
References: <20211002011757.311265-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=17834; h=from:subject; bh=h4U8IxPPXHuokioidekTO56Cbx5rBUnervG9uv/DL+k=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhV7MQZcDWLa/UMIVOiFevH9NgdgCveMZLz1Gf4ekR /w6PIRKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVezEAAKCRBM4MiGSL8Ryj1TEA CCZqsNng1mQE8mGtHACtp3WKZJzeE2qw/MXmoWWtv87Di0bmkGEtiZf7VnGrOVg34wt+x7wxO0uuRr U6USzVWrrj+O/nP80bOC4RzgMFUIPbtnjjEVC+ujk3w3MQeq1WvvgYFKNKh7aSKbFJzj2qaVPudmjE MfGYh+dxYlUyV4jqf/xJzNVkhlAhhalyZy4Xde63Q8Dcr2dn8276s3LD3NKw3mFJvM3Z7DFyHrxwbx hSil47SW9nPgkFcsl9ozDr5LYAal78Dmp2ACLz6/AgfF6KWlHA0JQhWVFrAQGjJ19vtCXvCLdOiJMS r4qOI+3JY4UERTBLkMnGQAg80UGb8pinYh2A55ODHbncmfW4hLtDtXAmrmM3PuBUfOHvy7jLh8I0MN /ns3thE/u6UAM/CfSmCioiqEocCu7bQWgpmMIUrVTdVCYpCcxaGjtJrwq8INkYGkSzoagWCromSWLF Gsc+9x1tAeLwGIfPw8WigjvxEDk2xruvp5FTAF0HtuAme4jsnRR+JArI9HnAmR2FStbeE9iySAq/YB ByiqZY7HbkKZOXNgAADvov946e+JzWk4ZRiXwwkBiG/kpoYPzAwUZeC1En5ozLTpPk2xJ9ILh3LeK0 oIYOUisz6/PZi05tkJEyrE9fUn1zuYFwMKlH1p6mYfFDdkHQwyIopPorn15g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support on the kernel side to allow for BPF programs to
call kernel module functions. Userspace will prepare an array of module
BTF fds that is passed in during BPF_PROG_LOAD using fd_array parameter.
In the kernel, the module BTFs are placed in the auxilliary struct for
bpf_prog, and loaded as needed.

The verifier then uses insn->off to index into the fd_array. insn->off
0 is reserved for vmlinux BTF (for backwards compat), so userspace must
use an fd_array index > 0 for module kfunc support. kfunc_btf_tab is
sorted based on offset in an array, and each offset corresponds to one
descriptor, with a max limit up to 256 such module BTFs.

We also change existing kfunc_tab to distinguish each element based on
imm, off pair as each such call will now be distinct.

Another change is to check_kfunc_call callback, which now include a
struct module * pointer, this is to be used in later patch such that the
kfunc_id and module pointer are matched for dynamically registered BTF
sets from loadable modules, so that same kfunc_id in two modules doesn't
lead to check_kfunc_call succeeding. For the duration of the
check_kfunc_call, the reference to struct module exists, as it returns
the pointer stored in kfunc_btf_tab.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h          |   8 +-
 include/linux/bpf_verifier.h |   2 +
 kernel/bpf/core.c            |   4 +
 kernel/bpf/verifier.c        | 202 ++++++++++++++++++++++++++++++-----
 net/bpf/test_run.c           |   2 +-
 net/ipv4/bpf_tcp_ca.c        |   2 +-
 6 files changed, 188 insertions(+), 32 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 19735d59230a..d942ae1d78a1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -513,7 +513,7 @@ struct bpf_verifier_ops {
 				 const struct btf_type *t, int off, int size,
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
-	bool (*check_kfunc_call)(u32 kfunc_btf_id);
+	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
 };
 
 struct bpf_prog_offload_ops {
@@ -876,6 +876,7 @@ struct bpf_prog_aux {
 	void *jit_data; /* JIT specific data. arch dependent */
 	struct bpf_jit_poke_descriptor *poke_tab;
 	struct bpf_kfunc_desc_tab *kfunc_tab;
+	struct bpf_kfunc_btf_tab *kfunc_btf_tab;
 	u32 size_poke_tab;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
@@ -1638,7 +1639,7 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
-bool bpf_prog_test_check_kfunc_call(u32 kfunc_id);
+bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1859,7 +1860,8 @@ static inline int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 	return -ENOTSUPP;
 }
 
-static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id)
+static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id,
+						  struct module *owner)
 {
 	return false;
 }
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 5424124dbe36..c8a78e830fca 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -527,5 +527,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    const struct bpf_prog *tgt_prog,
 			    u32 btf_id,
 			    struct bpf_attach_target_info *tgt_info);
+void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab);
+
 
 #endif /* _LINUX_BPF_VERIFIER_H */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 6fddc13fe67f..084df01625cd 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -32,6 +32,7 @@
 #include <linux/perf_event.h>
 #include <linux/extable.h>
 #include <linux/log2.h>
+#include <linux/bpf_verifier.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -2255,6 +2256,9 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	int i;
 
 	aux = container_of(work, struct bpf_prog_aux, work);
+#ifdef CONFIG_BPF_SYSCALL
+	bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
+#endif
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
 	if (bpf_prog_is_dev_bound(aux))
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1433752db740..1d6d10265cab 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1640,52 +1640,173 @@ static int add_subprog(struct bpf_verifier_env *env, int off)
 	return env->subprog_cnt - 1;
 }
 
+#define MAX_KFUNC_DESCS 256
+#define MAX_KFUNC_BTFS	256
+
 struct bpf_kfunc_desc {
 	struct btf_func_model func_model;
 	u32 func_id;
 	s32 imm;
+	u16 offset;
+};
+
+struct bpf_kfunc_btf {
+	struct btf *btf;
+	struct module *module;
+	u16 offset;
 };
 
-#define MAX_KFUNC_DESCS 256
 struct bpf_kfunc_desc_tab {
 	struct bpf_kfunc_desc descs[MAX_KFUNC_DESCS];
 	u32 nr_descs;
 };
 
-static int kfunc_desc_cmp_by_id(const void *a, const void *b)
+struct bpf_kfunc_btf_tab {
+	struct bpf_kfunc_btf descs[MAX_KFUNC_BTFS];
+	u32 nr_descs;
+};
+
+static int kfunc_desc_cmp_by_id_off(const void *a, const void *b)
 {
 	const struct bpf_kfunc_desc *d0 = a;
 	const struct bpf_kfunc_desc *d1 = b;
 
 	/* func_id is not greater than BTF_MAX_TYPE */
-	return d0->func_id - d1->func_id;
+	return d0->func_id - d1->func_id ?: d0->offset - d1->offset;
+}
+
+static int kfunc_btf_cmp_by_off(const void *a, const void *b)
+{
+	const struct bpf_kfunc_btf *d0 = a;
+	const struct bpf_kfunc_btf *d1 = b;
+
+	return d0->offset - d1->offset;
 }
 
 static const struct bpf_kfunc_desc *
-find_kfunc_desc(const struct bpf_prog *prog, u32 func_id)
+find_kfunc_desc(const struct bpf_prog *prog, u32 func_id, u16 offset)
 {
 	struct bpf_kfunc_desc desc = {
 		.func_id = func_id,
+		.offset = offset,
 	};
 	struct bpf_kfunc_desc_tab *tab;
 
 	tab = prog->aux->kfunc_tab;
 	return bsearch(&desc, tab->descs, tab->nr_descs,
-		       sizeof(tab->descs[0]), kfunc_desc_cmp_by_id);
+		       sizeof(tab->descs[0]), kfunc_desc_cmp_by_id_off);
+}
+
+static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
+					 s16 offset, struct module **btf_modp)
+{
+	struct bpf_kfunc_btf kf_btf = { .offset = offset };
+	struct bpf_kfunc_btf_tab *tab;
+	struct bpf_kfunc_btf *b;
+	struct module *mod;
+	struct btf *btf;
+	int btf_fd;
+
+	tab = env->prog->aux->kfunc_btf_tab;
+	b = bsearch(&kf_btf, tab->descs, tab->nr_descs,
+		    sizeof(tab->descs[0]), kfunc_btf_cmp_by_off);
+	if (!b) {
+		if (tab->nr_descs == MAX_KFUNC_BTFS) {
+			verbose(env, "too many different module BTFs\n");
+			return ERR_PTR(-E2BIG);
+		}
+
+		if (bpfptr_is_null(env->fd_array)) {
+			verbose(env, "kfunc offset > 0 without fd_array is invalid\n");
+			return ERR_PTR(-EPROTO);
+		}
+
+		if (copy_from_bpfptr_offset(&btf_fd, env->fd_array,
+					    offset * sizeof(btf_fd),
+					    sizeof(btf_fd)))
+			return ERR_PTR(-EFAULT);
+
+		btf = btf_get_by_fd(btf_fd);
+		if (IS_ERR(btf))
+			return btf;
+
+		if (!btf_is_module(btf)) {
+			verbose(env, "BTF fd for kfunc is not a module BTF\n");
+			btf_put(btf);
+			return ERR_PTR(-EINVAL);
+		}
+
+		mod = btf_try_get_module(btf);
+		if (!mod) {
+			btf_put(btf);
+			return ERR_PTR(-ENXIO);
+		}
+
+		b = &tab->descs[tab->nr_descs++];
+		b->btf = btf;
+		b->module = mod;
+		b->offset = offset;
+
+		sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
+		     kfunc_btf_cmp_by_off, NULL);
+	}
+	if (btf_modp)
+		*btf_modp = b->module;
+	return b->btf;
 }
 
-static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
+void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab)
+{
+	if (!tab)
+		return;
+
+	while (tab->nr_descs--) {
+		module_put(tab->descs[tab->nr_descs].module);
+		btf_put(tab->descs[tab->nr_descs].btf);
+	}
+	kfree(tab);
+}
+
+static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
+				       u32 func_id, s16 offset,
+				       struct module **btf_modp)
+{
+	struct btf *kfunc_btf;
+
+	if (offset) {
+		if (offset < 0) {
+			/* In the future, this can be allowed to increase limit
+			 * of fd index into fd_array, interpreted as u16.
+			 */
+			verbose(env, "negative offset disallowed for kernel module function call\n");
+			return ERR_PTR(-EINVAL);
+		}
+
+		kfunc_btf = __find_kfunc_desc_btf(env, offset, btf_modp);
+		if (IS_ERR_OR_NULL(kfunc_btf)) {
+			verbose(env, "cannot find module BTF for func_id %u\n", func_id);
+			return kfunc_btf ?: ERR_PTR(-ENOENT);
+		}
+		return kfunc_btf;
+	}
+	return btf_vmlinux ?: ERR_PTR(-ENOENT);
+}
+
+static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 {
 	const struct btf_type *func, *func_proto;
+	struct bpf_kfunc_btf_tab *btf_tab;
 	struct bpf_kfunc_desc_tab *tab;
 	struct bpf_prog_aux *prog_aux;
 	struct bpf_kfunc_desc *desc;
 	const char *func_name;
+	struct btf *desc_btf;
 	unsigned long addr;
 	int err;
 
 	prog_aux = env->prog->aux;
 	tab = prog_aux->kfunc_tab;
+	btf_tab = prog_aux->kfunc_btf_tab;
 	if (!tab) {
 		if (!btf_vmlinux) {
 			verbose(env, "calling kernel function is not supported without CONFIG_DEBUG_INFO_BTF\n");
@@ -1713,7 +1834,20 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 		prog_aux->kfunc_tab = tab;
 	}
 
-	if (find_kfunc_desc(env->prog, func_id))
+	if (!btf_tab && offset) {
+		btf_tab = kzalloc(sizeof(*btf_tab), GFP_KERNEL);
+		if (!btf_tab)
+			return -ENOMEM;
+		prog_aux->kfunc_btf_tab = btf_tab;
+	}
+
+	desc_btf = find_kfunc_desc_btf(env, func_id, offset, NULL);
+	if (IS_ERR(desc_btf)) {
+		verbose(env, "failed to find BTF for kernel function\n");
+		return PTR_ERR(desc_btf);
+	}
+
+	if (find_kfunc_desc(env->prog, func_id, offset))
 		return 0;
 
 	if (tab->nr_descs == MAX_KFUNC_DESCS) {
@@ -1721,20 +1855,20 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 		return -E2BIG;
 	}
 
-	func = btf_type_by_id(btf_vmlinux, func_id);
+	func = btf_type_by_id(desc_btf, func_id);
 	if (!func || !btf_type_is_func(func)) {
 		verbose(env, "kernel btf_id %u is not a function\n",
 			func_id);
 		return -EINVAL;
 	}
-	func_proto = btf_type_by_id(btf_vmlinux, func->type);
+	func_proto = btf_type_by_id(desc_btf, func->type);
 	if (!func_proto || !btf_type_is_func_proto(func_proto)) {
 		verbose(env, "kernel function btf_id %u does not have a valid func_proto\n",
 			func_id);
 		return -EINVAL;
 	}
 
-	func_name = btf_name_by_offset(btf_vmlinux, func->name_off);
+	func_name = btf_name_by_offset(desc_btf, func->name_off);
 	addr = kallsyms_lookup_name(func_name);
 	if (!addr) {
 		verbose(env, "cannot find address for kernel function %s\n",
@@ -1745,12 +1879,13 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
 	desc->imm = BPF_CALL_IMM(addr);
-	err = btf_distill_func_proto(&env->log, btf_vmlinux,
+	desc->offset = offset;
+	err = btf_distill_func_proto(&env->log, desc_btf,
 				     func_proto, func_name,
 				     &desc->func_model);
 	if (!err)
 		sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
-		     kfunc_desc_cmp_by_id, NULL);
+		     kfunc_desc_cmp_by_id_off, NULL);
 	return err;
 }
 
@@ -1829,7 +1964,7 @@ static int add_subprog_and_kfunc(struct bpf_verifier_env *env)
 		} else if (bpf_pseudo_call(insn)) {
 			ret = add_subprog(env, i + insn->imm + 1);
 		} else {
-			ret = add_kfunc_call(env, insn->imm);
+			ret = add_kfunc_call(env, insn->imm, insn->off);
 		}
 
 		if (ret < 0)
@@ -2166,12 +2301,17 @@ static int get_prev_insn_idx(struct bpf_verifier_state *st, int i,
 static const char *disasm_kfunc_name(void *data, const struct bpf_insn *insn)
 {
 	const struct btf_type *func;
+	struct btf *desc_btf;
 
 	if (insn->src_reg != BPF_PSEUDO_KFUNC_CALL)
 		return NULL;
 
-	func = btf_type_by_id(btf_vmlinux, insn->imm);
-	return btf_name_by_offset(btf_vmlinux, func->name_off);
+	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off, NULL);
+	if (IS_ERR(desc_btf))
+		return "<error>";
+
+	func = btf_type_by_id(desc_btf, insn->imm);
+	return btf_name_by_offset(desc_btf, func->name_off);
 }
 
 /* For given verifier state backtrack_insn() is called from the last insn to
@@ -6530,23 +6670,29 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
+	struct module *btf_mod = NULL;
 	const struct btf_param *args;
+	struct btf *desc_btf;
 	int err;
 
+	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
+	if (IS_ERR(desc_btf))
+		return PTR_ERR(desc_btf);
+
 	func_id = insn->imm;
-	func = btf_type_by_id(btf_vmlinux, func_id);
-	func_name = btf_name_by_offset(btf_vmlinux, func->name_off);
-	func_proto = btf_type_by_id(btf_vmlinux, func->type);
+	func = btf_type_by_id(desc_btf, func_id);
+	func_name = btf_name_by_offset(desc_btf, func->name_off);
+	func_proto = btf_type_by_id(desc_btf, func->type);
 
 	if (!env->ops->check_kfunc_call ||
-	    !env->ops->check_kfunc_call(func_id)) {
+	    !env->ops->check_kfunc_call(func_id, btf_mod)) {
 		verbose(env, "calling kernel function %s is not allowed\n",
 			func_name);
 		return -EACCES;
 	}
 
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, btf_vmlinux, func_id, regs);
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
 	if (err)
 		return err;
 
@@ -6554,15 +6700,15 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		mark_reg_not_init(env, regs, caller_saved[i]);
 
 	/* Check return type */
-	t = btf_type_skip_modifiers(btf_vmlinux, func_proto->type, NULL);
+	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
 	if (btf_type_is_scalar(t)) {
 		mark_reg_unknown(env, regs, BPF_REG_0);
 		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
 	} else if (btf_type_is_ptr(t)) {
-		ptr_type = btf_type_skip_modifiers(btf_vmlinux, t->type,
+		ptr_type = btf_type_skip_modifiers(desc_btf, t->type,
 						   &ptr_type_id);
 		if (!btf_type_is_struct(ptr_type)) {
-			ptr_type_name = btf_name_by_offset(btf_vmlinux,
+			ptr_type_name = btf_name_by_offset(desc_btf,
 							   ptr_type->name_off);
 			verbose(env, "kernel function %s returns pointer type %s %s is not supported\n",
 				func_name, btf_type_str(ptr_type),
@@ -6570,7 +6716,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			return -EINVAL;
 		}
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].btf = btf_vmlinux;
+		regs[BPF_REG_0].btf = desc_btf;
 		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
 		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
@@ -6581,7 +6727,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	for (i = 0; i < nargs; i++) {
 		u32 regno = i + 1;
 
-		t = btf_type_skip_modifiers(btf_vmlinux, args[i].type, NULL);
+		t = btf_type_skip_modifiers(desc_btf, args[i].type, NULL);
 		if (btf_type_is_ptr(t))
 			mark_btf_func_reg_size(env, regno, sizeof(void *));
 		else
@@ -11121,7 +11267,8 @@ static int do_check(struct bpf_verifier_env *env)
 			env->jmps_processed++;
 			if (opcode == BPF_CALL) {
 				if (BPF_SRC(insn->code) != BPF_K ||
-				    insn->off != 0 ||
+				    (insn->src_reg != BPF_PSEUDO_KFUNC_CALL
+				     && insn->off != 0) ||
 				    (insn->src_reg != BPF_REG_0 &&
 				     insn->src_reg != BPF_PSEUDO_CALL &&
 				     insn->src_reg != BPF_PSEUDO_KFUNC_CALL) ||
@@ -12477,6 +12624,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->stack_depth = env->subprog_info[i].stack_depth;
 		func[i]->jit_requested = 1;
 		func[i]->aux->kfunc_tab = prog->aux->kfunc_tab;
+		func[i]->aux->kfunc_btf_tab = prog->aux->kfunc_btf_tab;
 		func[i]->aux->linfo = prog->aux->linfo;
 		func[i]->aux->nr_linfo = prog->aux->nr_linfo;
 		func[i]->aux->jited_linfo = prog->aux->jited_linfo;
@@ -12665,7 +12813,7 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
-	desc = find_kfunc_desc(env->prog, insn->imm);
+	desc = find_kfunc_desc(env->prog, insn->imm, insn->off);
 	if (!desc) {
 		verbose(env, "verifier internal error: kernel function descriptor not found for func_id %u\n",
 			insn->imm);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 6593a71dba5f..b5dfe6cac274 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -241,7 +241,7 @@ BTF_ID(func, bpf_kfunc_call_test2)
 BTF_ID(func, bpf_kfunc_call_test3)
 BTF_SET_END(test_sk_kfunc_ids)
 
-bool bpf_prog_test_check_kfunc_call(u32 kfunc_id)
+bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 {
 	return btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id);
 }
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 0dcee9df1326..b3afd3361f34 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -255,7 +255,7 @@ BTF_ID(func, bbr_set_state)
 #endif	/* CONFIG_X86 */
 BTF_SET_END(bpf_tcp_ca_kfunc_ids)
 
-static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id)
+static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id, struct module *owner)
 {
 	return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
 }
-- 
2.33.0

