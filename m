Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21B348B537
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350397AbiAKSGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345404AbiAKSFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:05:11 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E601C061201;
        Tue, 11 Jan 2022 10:05:06 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id g5so9263437plo.12;
        Tue, 11 Jan 2022 10:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ixIM/s3Gcr7kbHAhe3tJYvCNhRaobLhYKdIdObXj/tQ=;
        b=VOUQ20gD6x/XJGzNSBplT5avxy/sXSxrri9nWPuFWeb+JOZISW8dzzDrjCtOjFx3Un
         A8UjAyy42U7F1cZCZrXXeo8T+micCWqN+4BCsMDQpPmOyucDwxPpFW7nhRSeAOGGNTxL
         FQjyfackp3Us3jymdV2ipOMVz0M6j+ODf5FshSqpYRna4HrMPheOSmrszbO2GRNmAhJw
         tM/G340vCfBF98InH4zc6TUnFr00F43PFcSPwpn/EHIf63QkVyrGYgqjxk7LJnzX8vyg
         wsUfS/w41F9mPHCBUMZom6wfitc+YNDTkhM5+uJfQevIUAWzCJJeAuhNPVW+Liy2a4Fp
         CKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ixIM/s3Gcr7kbHAhe3tJYvCNhRaobLhYKdIdObXj/tQ=;
        b=R80O7dEyTKXTrEOyjqsusklYw53M3qMMpUAp+NgdZPUtSTV5EAr7csou/nSSwv+IpY
         pyznxE1zRjhZaQcC5uGCkHFzPwL7cWENGPzcCQCzQacsj/1WDonxuLghXSwplEwKYpkR
         XzvezegpaWtdEXV41fBq1qByoeGrJT68IzheqCBkX2+oN78RDGYL8aPAu5o6ioGDtWyy
         M6xwD6fIhA9Ukdft2pfx3M3gCkl45pcs8XO18WUYrFNKjj5eVtcVnrZUK83Ki+6s7MWZ
         ovpqqhEyEcAiSansgaHrCFa0So3TaTPfSXCkHWt+k3BEQ72ZPKOHMaOhNxERcDEcbUCa
         ftxg==
X-Gm-Message-State: AOAM533mCaAbO6UdrgMfBZWExSB80nGiSwH0P60z/N8HXaMgMkh7sSWC
        Wtp+RvwNyxXPASly0V7QOS9rweWA+OdEoQ==
X-Google-Smtp-Source: ABdhPJyauNGuJzfkhOjKGG/xInI0IibqqQ1SOV/KSfq7Y8LV7OATgSxPH3a53brPm+tHNWpSGIdOVA==
X-Received: by 2002:a63:8f43:: with SMTP id r3mr5092796pgn.195.1641924305354;
        Tue, 11 Jan 2022 10:05:05 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id t7sm10947420pfj.168.2022.01.11.10.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:05:05 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v7 03/10] bpf: Remove check_kfunc_call callback and old kfunc BTF ID API
Date:   Tue, 11 Jan 2022 23:34:21 +0530
Message-Id: <20220111180428.931466-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111180428.931466-1-memxor@gmail.com>
References: <20220111180428.931466-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=19078; h=from:subject; bh=gzCfGLe7z4TShFmcGatSQQLSct79UjT7q6ReikbK43Y=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh3cajsf/dmHHtsOiok+0rsSawfUClAFpuxRlp8Akb t2v03juJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYd3GowAKCRBM4MiGSL8RykiWD/ 40vSvQkCCBFNBDqJKABIdKJbc9eUaRWjltFAK6rwV+gFi3sHkb4+8kjJhcZjSBSQSNuzFEivv3MCdw rVLfUzw10FDFS387gNwuDa46AOFrH3RJKqr8o9PicmtR3Z3Mmv/yMB8pYwr/Ap8wviHA0XoDod/B4C yL6tEnDHCXwqi+psdAAViNWtY0BRx10aOO3leKXgjvdDM134x+c2SsRabtH8InXvUwWacVMVqt+qsS AIalxZCnLMJTH3yeatqHv8Hb52WC+HP/QZtTYe112AYM2LQQlHAmiKsW1ifqvHKe1xf2I0HFIIdfL4 yvXI0ANs3RuGxqwI58i7+3t1AtlhkT3CgVP1wabFSVwzFk/I64W+5+cKqZUyXe8L8LClasM9JCtaII JRwMXfg8s3ccZqVWNdU0CSt2x2E4T5x65Gn7clDB1IWiFtAqFUAJGU5cCCj4kJpFwjfdwRR7eCxPEL sfEUtWsbA9ZwRyph+YGnmKBHqpDYxpYOnek3t51gmOY/eAGUoDAcU8dv+5nfoXfnfNaD+Sfgku/6TY prbdZ4wkexBRe2YQhpAZ+w9zrAAbJpG/NDygTov20+mDcTci9uxjL5YXu9uFQZNXf1zaClTQTOAcgH cdM3hCR/8c6d1mfbPQaoZCFNNMueGPAUiA3OBBCFJSU33/E3khHKs1Akipvw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Completely remove the old code for check_kfunc_call to help it work
with modules, and also the callback itself.

The previous commit adds infrastructure to register all sets and put
them in vmlinux or module BTF, and concatenates all related sets
organized by the hook and the type. Once populated, these sets remain
immutable for the lifetime of the struct btf.

Also, since we don't need the 'owner' module anywhere when doing
check_kfunc_call, drop the 'btf_modp' module parameter from
find_kfunc_desc_btf.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h                           |  8 ----
 include/linux/btf.h                           | 44 ------------------
 kernel/bpf/btf.c                              | 46 -------------------
 kernel/bpf/verifier.c                         | 20 ++++----
 net/bpf/test_run.c                            | 23 ++++++----
 net/core/filter.c                             |  1 -
 net/ipv4/bpf_tcp_ca.c                         | 22 +++++----
 net/ipv4/tcp_bbr.c                            | 18 ++++----
 net/ipv4/tcp_cubic.c                          | 17 +++----
 net/ipv4/tcp_dctcp.c                          | 18 ++++----
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 17 +++----
 11 files changed, 73 insertions(+), 161 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6e947cd91152..6d7346c54d83 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -573,7 +573,6 @@ struct bpf_verifier_ops {
 				 const struct btf_type *t, int off, int size,
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
-	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
 };
 
 struct bpf_prog_offload_ops {
@@ -1719,7 +1718,6 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
-bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1971,12 +1969,6 @@ static inline int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 	return -ENOTSUPP;
 }
 
-static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id,
-						  struct module *owner)
-{
-	return false;
-}
-
 static inline void bpf_map_put(struct bpf_map *map)
 {
 }
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 95a8238272af..32113b7e6e41 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -366,48 +366,4 @@ static inline int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 }
 #endif
 
-struct kfunc_btf_id_set {
-	struct list_head list;
-	struct btf_id_set *set;
-	struct module *owner;
-};
-
-struct kfunc_btf_id_list {
-	struct list_head list;
-	struct mutex mutex;
-};
-
-#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
-void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
-			       struct kfunc_btf_id_set *s);
-void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
-				 struct kfunc_btf_id_set *s);
-bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
-			      struct module *owner);
-
-extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
-extern struct kfunc_btf_id_list prog_test_kfunc_list;
-#else
-static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
-					     struct kfunc_btf_id_set *s)
-{
-}
-static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
-					       struct kfunc_btf_id_set *s)
-{
-}
-static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
-					    u32 kfunc_id, struct module *owner)
-{
-	return false;
-}
-
-static struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list __maybe_unused;
-static struct kfunc_btf_id_list prog_test_kfunc_list __maybe_unused;
-#endif
-
-#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
-	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
-					 THIS_MODULE }
-
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index eb29d908e3b7..efc1415ae202 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6689,52 +6689,6 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 }
 EXPORT_SYMBOL_GPL(register_btf_kfunc_id_set);
 
-#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
-
-void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
-			       struct kfunc_btf_id_set *s)
-{
-	mutex_lock(&l->mutex);
-	list_add(&s->list, &l->list);
-	mutex_unlock(&l->mutex);
-}
-EXPORT_SYMBOL_GPL(register_kfunc_btf_id_set);
-
-void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
-				 struct kfunc_btf_id_set *s)
-{
-	mutex_lock(&l->mutex);
-	list_del_init(&s->list);
-	mutex_unlock(&l->mutex);
-}
-EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
-
-bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
-			      struct module *owner)
-{
-	struct kfunc_btf_id_set *s;
-
-	mutex_lock(&klist->mutex);
-	list_for_each_entry(s, &klist->list, list) {
-		if (s->owner == owner && btf_id_set_contains(s->set, kfunc_id)) {
-			mutex_unlock(&klist->mutex);
-			return true;
-		}
-	}
-	mutex_unlock(&klist->mutex);
-	return false;
-}
-
-#define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
-	struct kfunc_btf_id_list name = { LIST_HEAD_INIT(name.list),           \
-					  __MUTEX_INITIALIZER(name.mutex) };   \
-	EXPORT_SYMBOL_GPL(name)
-
-DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
-DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
-
-#endif
-
 int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
 			      const struct btf *targ_btf, __u32 targ_id)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b5ea73560a4d..ec07f4992253 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1741,7 +1741,7 @@ find_kfunc_desc(const struct bpf_prog *prog, u32 func_id, u16 offset)
 }
 
 static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
-					 s16 offset, struct module **btf_modp)
+					 s16 offset)
 {
 	struct bpf_kfunc_btf kf_btf = { .offset = offset };
 	struct bpf_kfunc_btf_tab *tab;
@@ -1796,8 +1796,6 @@ static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
 		sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
 		     kfunc_btf_cmp_by_off, NULL);
 	}
-	if (btf_modp)
-		*btf_modp = b->module;
 	return b->btf;
 }
 
@@ -1814,8 +1812,7 @@ void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab)
 }
 
 static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
-				       u32 func_id, s16 offset,
-				       struct module **btf_modp)
+				       u32 func_id, s16 offset)
 {
 	if (offset) {
 		if (offset < 0) {
@@ -1826,7 +1823,7 @@ static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
 			return ERR_PTR(-EINVAL);
 		}
 
-		return __find_kfunc_desc_btf(env, offset, btf_modp);
+		return __find_kfunc_desc_btf(env, offset);
 	}
 	return btf_vmlinux ?: ERR_PTR(-ENOENT);
 }
@@ -1889,7 +1886,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_btf_tab = btf_tab;
 	}
 
-	desc_btf = find_kfunc_desc_btf(env, func_id, offset, NULL);
+	desc_btf = find_kfunc_desc_btf(env, func_id, offset);
 	if (IS_ERR(desc_btf)) {
 		verbose(env, "failed to find BTF for kernel function\n");
 		return PTR_ERR(desc_btf);
@@ -2350,7 +2347,7 @@ static const char *disasm_kfunc_name(void *data, const struct bpf_insn *insn)
 	if (insn->src_reg != BPF_PSEUDO_KFUNC_CALL)
 		return NULL;
 
-	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off, NULL);
+	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off);
 	if (IS_ERR(desc_btf))
 		return "<error>";
 
@@ -6821,7 +6818,6 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
-	struct module *btf_mod = NULL;
 	const struct btf_param *args;
 	struct btf *desc_btf;
 	int err;
@@ -6830,7 +6826,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	if (!insn->imm)
 		return 0;
 
-	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
+	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
 
@@ -6839,8 +6835,8 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	func_name = btf_name_by_offset(desc_btf, func->name_off);
 	func_proto = btf_type_by_id(desc_btf, func->type);
 
-	if (!env->ops->check_kfunc_call ||
-	    !env->ops->check_kfunc_call(func_id, btf_mod)) {
+	if (!btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
+				      BTF_KFUNC_TYPE_CHECK, func_id)) {
 		verbose(env, "calling kernel function %s is not allowed\n",
 			func_name);
 		return -EACCES;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 46dd95755967..7796a8c747a0 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -5,6 +5,7 @@
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
 #include <linux/slab.h>
+#include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/etherdevice.h>
 #include <linux/filter.h>
@@ -236,18 +237,11 @@ __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
 
-BTF_SET_START(test_sk_kfunc_ids)
+BTF_SET_START(test_sk_check_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test1)
 BTF_ID(func, bpf_kfunc_call_test2)
 BTF_ID(func, bpf_kfunc_call_test3)
-BTF_SET_END(test_sk_kfunc_ids)
-
-bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
-{
-	if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
-		return true;
-	return bpf_check_mod_kfunc_call(&prog_test_kfunc_list, kfunc_id, owner);
-}
+BTF_SET_END(test_sk_check_kfunc_ids)
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
@@ -1067,3 +1061,14 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 	kfree(ctx);
 	return err;
 }
+
+static const struct btf_kfunc_id_set bpf_prog_test_kfunc_set = {
+	.owner     = THIS_MODULE,
+	.check_set = &test_sk_check_kfunc_ids,
+};
+
+static int __init bpf_prog_test_run_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
+}
+late_initcall(bpf_prog_test_run_init);
diff --git a/net/core/filter.c b/net/core/filter.c
index 4603b7cd3cd1..f73a84c75970 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10062,7 +10062,6 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
-	.check_kfunc_call	= bpf_prog_test_check_kfunc_call,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index de610cb83694..b60c9fd7147e 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook  */
 
+#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/bpf_verifier.h>
 #include <linux/bpf.h>
@@ -212,26 +213,23 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 	}
 }
 
-BTF_SET_START(bpf_tcp_ca_kfunc_ids)
+BTF_SET_START(bpf_tcp_ca_check_kfunc_ids)
 BTF_ID(func, tcp_reno_ssthresh)
 BTF_ID(func, tcp_reno_cong_avoid)
 BTF_ID(func, tcp_reno_undo_cwnd)
 BTF_ID(func, tcp_slow_start)
 BTF_ID(func, tcp_cong_avoid_ai)
-BTF_SET_END(bpf_tcp_ca_kfunc_ids)
+BTF_SET_END(bpf_tcp_ca_check_kfunc_ids)
 
-static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id, struct module *owner)
-{
-	if (btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id))
-		return true;
-	return bpf_check_mod_kfunc_call(&bpf_tcp_ca_kfunc_list, kfunc_btf_id, owner);
-}
+static const struct btf_kfunc_id_set bpf_tcp_ca_kfunc_set = {
+	.owner     = THIS_MODULE,
+	.check_set = &bpf_tcp_ca_check_kfunc_ids,
+};
 
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
 	.get_func_proto		= bpf_tcp_ca_get_func_proto,
 	.is_valid_access	= bpf_tcp_ca_is_valid_access,
 	.btf_struct_access	= bpf_tcp_ca_btf_struct_access,
-	.check_kfunc_call	= bpf_tcp_ca_check_kfunc_call,
 };
 
 static int bpf_tcp_ca_init_member(const struct btf_type *t,
@@ -300,3 +298,9 @@ struct bpf_struct_ops bpf_tcp_congestion_ops = {
 	.init = bpf_tcp_ca_init,
 	.name = "tcp_congestion_ops",
 };
+
+static int __init bpf_tcp_ca_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &bpf_tcp_ca_kfunc_set);
+}
+late_initcall(bpf_tcp_ca_kfunc_init);
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index ec5550089b4d..02e8626ccb27 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1154,7 +1154,7 @@ static struct tcp_congestion_ops tcp_bbr_cong_ops __read_mostly = {
 	.set_state	= bbr_set_state,
 };
 
-BTF_SET_START(tcp_bbr_kfunc_ids)
+BTF_SET_START(tcp_bbr_check_kfunc_ids)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
 BTF_ID(func, bbr_init)
@@ -1167,25 +1167,27 @@ BTF_ID(func, bbr_min_tso_segs)
 BTF_ID(func, bbr_set_state)
 #endif
 #endif
-BTF_SET_END(tcp_bbr_kfunc_ids)
+BTF_SET_END(tcp_bbr_check_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_bbr_kfunc_ids, tcp_bbr_kfunc_btf_set);
+static const struct btf_kfunc_id_set tcp_bbr_kfunc_set = {
+	.owner     = THIS_MODULE,
+	.check_set = &tcp_bbr_check_kfunc_ids,
+};
 
 static int __init bbr_register(void)
 {
 	int ret;
 
 	BUILD_BUG_ON(sizeof(struct bbr) > ICSK_CA_PRIV_SIZE);
-	ret = tcp_register_congestion_control(&tcp_bbr_cong_ops);
-	if (ret)
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &tcp_bbr_kfunc_set);
+	if (ret < 0)
 		return ret;
-	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_bbr_kfunc_btf_set);
-	return 0;
+	return tcp_register_congestion_control(&tcp_bbr_cong_ops);
 }
 
 static void __exit bbr_unregister(void)
 {
-	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_bbr_kfunc_btf_set);
 	tcp_unregister_congestion_control(&tcp_bbr_cong_ops);
 }
 
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index e07837e23b3f..24d562dd6225 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -485,7 +485,7 @@ static struct tcp_congestion_ops cubictcp __read_mostly = {
 	.name		= "cubic",
 };
 
-BTF_SET_START(tcp_cubic_kfunc_ids)
+BTF_SET_START(tcp_cubic_check_kfunc_ids)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
 BTF_ID(func, cubictcp_init)
@@ -496,9 +496,12 @@ BTF_ID(func, cubictcp_cwnd_event)
 BTF_ID(func, cubictcp_acked)
 #endif
 #endif
-BTF_SET_END(tcp_cubic_kfunc_ids)
+BTF_SET_END(tcp_cubic_check_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_cubic_kfunc_ids, tcp_cubic_kfunc_btf_set);
+static const struct btf_kfunc_id_set tcp_cubic_kfunc_set = {
+	.owner     = THIS_MODULE,
+	.check_set = &tcp_cubic_check_kfunc_ids,
+};
 
 static int __init cubictcp_register(void)
 {
@@ -534,16 +537,14 @@ static int __init cubictcp_register(void)
 	/* divide by bic_scale and by constant Srtt (100ms) */
 	do_div(cube_factor, bic_scale * 10);
 
-	ret = tcp_register_congestion_control(&cubictcp);
-	if (ret)
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &tcp_cubic_kfunc_set);
+	if (ret < 0)
 		return ret;
-	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_cubic_kfunc_btf_set);
-	return 0;
+	return tcp_register_congestion_control(&cubictcp);
 }
 
 static void __exit cubictcp_unregister(void)
 {
-	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_cubic_kfunc_btf_set);
 	tcp_unregister_congestion_control(&cubictcp);
 }
 
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 0d7ab3cc7b61..1943a6630341 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -238,7 +238,7 @@ static struct tcp_congestion_ops dctcp_reno __read_mostly = {
 	.name		= "dctcp-reno",
 };
 
-BTF_SET_START(tcp_dctcp_kfunc_ids)
+BTF_SET_START(tcp_dctcp_check_kfunc_ids)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
 BTF_ID(func, dctcp_init)
@@ -249,25 +249,27 @@ BTF_ID(func, dctcp_cwnd_undo)
 BTF_ID(func, dctcp_state)
 #endif
 #endif
-BTF_SET_END(tcp_dctcp_kfunc_ids)
+BTF_SET_END(tcp_dctcp_check_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_dctcp_kfunc_ids, tcp_dctcp_kfunc_btf_set);
+static const struct btf_kfunc_id_set tcp_dctcp_kfunc_set = {
+	.owner     = THIS_MODULE,
+	.check_set = &tcp_dctcp_check_kfunc_ids,
+};
 
 static int __init dctcp_register(void)
 {
 	int ret;
 
 	BUILD_BUG_ON(sizeof(struct dctcp) > ICSK_CA_PRIV_SIZE);
-	ret = tcp_register_congestion_control(&dctcp);
-	if (ret)
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &tcp_dctcp_kfunc_set);
+	if (ret < 0)
 		return ret;
-	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_dctcp_kfunc_btf_set);
-	return 0;
+	return tcp_register_congestion_control(&dctcp);
 }
 
 static void __exit dctcp_unregister(void)
 {
-	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_dctcp_kfunc_btf_set);
 	tcp_unregister_congestion_control(&dctcp);
 }
 
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index df3b292a8ffe..c0805d0d753f 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -109,26 +109,27 @@ static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
 	.write = bpf_testmod_test_write,
 };
 
-BTF_SET_START(bpf_testmod_kfunc_ids)
+BTF_SET_START(bpf_testmod_check_kfunc_ids)
 BTF_ID(func, bpf_testmod_test_mod_kfunc)
-BTF_SET_END(bpf_testmod_kfunc_ids)
+BTF_SET_END(bpf_testmod_check_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&bpf_testmod_kfunc_ids, bpf_testmod_kfunc_btf_set);
+static const struct btf_kfunc_id_set bpf_testmod_kfunc_set = {
+	.owner     = THIS_MODULE,
+	.check_set = &bpf_testmod_check_kfunc_ids,
+};
 
 static int bpf_testmod_init(void)
 {
 	int ret;
 
-	ret = sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
-	if (ret)
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_testmod_kfunc_set);
+	if (ret < 0)
 		return ret;
-	register_kfunc_btf_id_set(&prog_test_kfunc_list, &bpf_testmod_kfunc_btf_set);
-	return 0;
+	return sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
 }
 
 static void bpf_testmod_exit(void)
 {
-	unregister_kfunc_btf_id_set(&prog_test_kfunc_list, &bpf_testmod_kfunc_btf_set);
 	return sysfs_remove_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
 }
 
-- 
2.34.1

