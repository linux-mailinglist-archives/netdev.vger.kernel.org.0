Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AC7411696
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbhITORF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbhITORC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:02 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ABAC061760;
        Mon, 20 Sep 2021 07:15:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso15357932pjj.0;
        Mon, 20 Sep 2021 07:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4+Sywiu78/ZWqvRnRpYlhOmecgwW6KLOtEzX8JbMVc=;
        b=lwJCpqkCgMcU1j4kgHVp1eWi9ZBkwTfID6D617hajRQqj06khjJc+HvtOgEthwW1LR
         01inzEkS1iIAqPmb6sba+b8OS17QJUAXNHlUo23YF20/MY6V9FHcuK2e2Ac9CEmxPdpn
         DAfrIOlXSSfc0A1gAiowR2mBIyz7IouTJz620I8qUpsq8MMhUxxoQYTG0Xe6JtNV6J75
         14tF/bq9jxx6CtC/933ZhcrBO0ItHagjV1CKHzyGv5LPfpOX+omni+rTfaiR22W7zn7+
         hC97s1/QuC//mXS9N2MB7YNJIRfczE/LJqHasQDU8C2oM7esOsStFacFT5WYTVVe+leb
         mr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4+Sywiu78/ZWqvRnRpYlhOmecgwW6KLOtEzX8JbMVc=;
        b=FuR6VLzAglZP3ps8QH3cv2F5iZJxFp6vs+xcUT+lcvd08LrabS1I2wPyxFtqqu9U6t
         JrPgW9ueku6FD07kqh0935+Rx4jcx8rDkTrsktwZHr+5M3MqrWC0UuWHhJrGAlyrEfbe
         uUuv2a20u4pD3ZSo4xgb4rEv/4AOntRTdVe63lpFmCFEzzjbBsmoKfvAgLu7IdEZp9dW
         UPY4lVt268hdey6AMIxiM2RSiBGm0Qp7f0LHTFeZYZWZ7Vfw3dvNzGta5/+dwS2GNpwL
         A6raZ3e04hv23Y6cz90VV1BXFaX6V+0ELQTAI10monkVZbzW/7K1j24OZCZU0Rg36GAG
         9NuQ==
X-Gm-Message-State: AOAM530ToIWnep9EnkD2U70lsbTZ8UAdXnYlJcU8CWdPouaGB4+E7o16
        DSz5hsxRR6TrH7L3rdpnZSt/QPXUWswkGA==
X-Google-Smtp-Source: ABdhPJzcPvxtxzRKUKCR9fPrNocWGViBi6f4yVHPO62+qwysS0VpAFDQRo1YqJ4PR4Gpg4VRcgpxHg==
X-Received: by 2002:a17:90a:ba0e:: with SMTP id s14mr2165985pjr.213.1632147334710;
        Mon, 20 Sep 2021 07:15:34 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id a11sm15884232pgj.75.2021.09.20.07.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:34 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 01/11] bpf: Introduce BPF support for kernel module function calls
Date:   Mon, 20 Sep 2021 19:45:16 +0530
Message-Id: <20210920141526.3940002-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=17724; h=from:subject; bh=YYhLh2NEYoz0aH/JN9qE6gZqWRRerwMmCkU0qqEfTYY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaDGbRTKZUgb7mLYTksiRlSamXwDsTamk/y5c5y InLiJrSJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWgwAKCRBM4MiGSL8RyrAwD/ 9yCH1+KjmqjSM7UUhEMfdKboO1IITJ0Vq3UmOf3yWpePSyzPfy+YQusrLnJY6+qoA+A7SMsFinpldv X3rjYYqJ8+DC9Ll6HXKl3ZLh4wnmSyNRELsMcMgYBIGMkXVNVjP9wvZ0+1fifXUdFRO71/LAskQAUc EcyN94CVOW+QICK9jZc8QBYWJ6d32D3Y1PZXxFBKftpSrgBd2Wf9t2cCWkYwV2GZ6iUuG9gleEgjEw yQAfnHdrMja36FCKGDKPYAY/TiUer64YxC9preWOJM1rARMv34G8V25+whlO2jwZTKJ/Ma+DOdNrwP j+g5qhpq9rd7Z3QdOztdbKfPVmrmCfiA8lvXN3kON+D9Qdxr95bXBdt5jcAl1veML8G3DkrHzUghFU MXkoaiBFo+x6tPEwvPgUWXLZXw+Tws3AaCmn/OgsqZyXiUf0dtjG1/FPZkZhSHb+fTMrTaBP5S0vZi uXC6+jKrF9PAosPbr+cPdZTcF8iw0m7fipAhB8gSPG6b4Z5l0dsqeGMpwHxmn27vdu0eSl4JBl3zmC lC0nHf5Kz5737sRQMfUqmfQuXCVJsllhkZlxY93o7MTpPe1T3k5KRJTlJU77kUX1NzPjz+gmJjlgZ/ uDo8t94Thsl/0M6WcjthmmsAO4f8hRWYeG9ypGwLprymuBoChYIeMJS5gyfA==
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
index b6c45a6cbbba..81b1b3d0d546 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -511,7 +511,7 @@ struct bpf_verifier_ops {
 				 const struct btf_type *t, int off, int size,
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
-	bool (*check_kfunc_call)(u32 kfunc_btf_id);
+	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
 };
 
 struct bpf_prog_offload_ops {
@@ -874,6 +874,7 @@ struct bpf_prog_aux {
 	void *jit_data; /* JIT specific data. arch dependent */
 	struct bpf_jit_poke_descriptor *poke_tab;
 	struct bpf_kfunc_desc_tab *kfunc_tab;
+	struct bpf_kfunc_btf_tab *kfunc_btf_tab;
 	u32 size_poke_tab;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
@@ -1636,7 +1637,7 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
-bool bpf_prog_test_check_kfunc_call(u32 kfunc_id);
+bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1857,7 +1858,8 @@ static inline int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
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
index e76b55917905..5b465d67cf65 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1626,52 +1626,173 @@ static int add_subprog(struct bpf_verifier_env *env, int off)
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
@@ -1699,7 +1820,20 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
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
@@ -1707,20 +1841,20 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
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
@@ -1731,12 +1865,13 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
 	desc->imm = BPF_CAST_CALL(addr) - __bpf_call_base;
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
 
@@ -1815,7 +1950,7 @@ static int add_subprog_and_kfunc(struct bpf_verifier_env *env)
 		} else if (bpf_pseudo_call(insn)) {
 			ret = add_subprog(env, i + insn->imm + 1);
 		} else {
-			ret = add_kfunc_call(env, insn->imm);
+			ret = add_kfunc_call(env, insn->imm, insn->off);
 		}
 
 		if (ret < 0)
@@ -2152,12 +2287,17 @@ static int get_prev_insn_idx(struct bpf_verifier_state *st, int i,
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
@@ -6485,23 +6625,29 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
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
 
@@ -6509,15 +6655,15 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
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
@@ -6525,7 +6671,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			return -EINVAL;
 		}
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].btf = btf_vmlinux;
+		regs[BPF_REG_0].btf = desc_btf;
 		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
 		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
@@ -6536,7 +6682,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	for (i = 0; i < nargs; i++) {
 		u32 regno = i + 1;
 
-		t = btf_type_skip_modifiers(btf_vmlinux, args[i].type, NULL);
+		t = btf_type_skip_modifiers(desc_btf, args[i].type, NULL);
 		if (btf_type_is_ptr(t))
 			mark_btf_func_reg_size(env, regno, sizeof(void *));
 		else
@@ -11076,7 +11222,8 @@ static int do_check(struct bpf_verifier_env *env)
 			env->jmps_processed++;
 			if (opcode == BPF_CALL) {
 				if (BPF_SRC(insn->code) != BPF_K ||
-				    insn->off != 0 ||
+				    (insn->src_reg != BPF_PSEUDO_KFUNC_CALL
+				     && insn->off != 0) ||
 				    (insn->src_reg != BPF_REG_0 &&
 				     insn->src_reg != BPF_PSEUDO_CALL &&
 				     insn->src_reg != BPF_PSEUDO_KFUNC_CALL) ||
@@ -12432,6 +12579,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->stack_depth = env->subprog_info[i].stack_depth;
 		func[i]->jit_requested = 1;
 		func[i]->aux->kfunc_tab = prog->aux->kfunc_tab;
+		func[i]->aux->kfunc_btf_tab = prog->aux->kfunc_btf_tab;
 		func[i]->aux->linfo = prog->aux->linfo;
 		func[i]->aux->nr_linfo = prog->aux->nr_linfo;
 		func[i]->aux->jited_linfo = prog->aux->jited_linfo;
@@ -12621,7 +12769,7 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
-	desc = find_kfunc_desc(env->prog, insn->imm);
+	desc = find_kfunc_desc(env->prog, insn->imm, insn->off);
 	if (!desc) {
 		verbose(env, "verifier internal error: kernel function descriptor not found for func_id %u\n",
 			insn->imm);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index fcb2f493f710..fe5c34f414a2 100644
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

