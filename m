Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8274818A6
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhL3ChT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbhL3ChS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:37:18 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD59C061574;
        Wed, 29 Dec 2021 18:37:18 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c2so20195187pfc.1;
        Wed, 29 Dec 2021 18:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WM5oD1Byg/t6Sbbjt4usMoaSXxzVr3wYCRglQIFf25Q=;
        b=o3CjyFOQWk5AC5itRB8KodMVnXHZpK8lnhAOKoLhozpiaZE56cEStdx5Jg91lZuiaS
         oqAzGdGSZImuN8iF7D8BRgvBx/KzPivWG/0E9WLoNYX2AwiPqVAlLkvxuUm/f6f3yk6N
         /cI/vh4vBSgIl7CH9Tt6dge5qWEX8qGcBdL/Nn2Wkvt5paSyxyFfAPdwXlC7f0ImMLIw
         5wH2172C2hUjJHWMrAgdwW9Z+J5U64xZOy6qvqO9QY7OPw9YQXsEyE6w08QkCNGX0vhz
         Kmub28oAuSbg3rxw75wCpGVUkgihTa23uIaWMoutM5LSGG4iGNocxWpMh21cIHKf9Wts
         vn6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WM5oD1Byg/t6Sbbjt4usMoaSXxzVr3wYCRglQIFf25Q=;
        b=HL0K2/PSBrbiuhNkhifRA1Na+WJSHEsXGM/eW2TRUY2Hxyku0Q2SIqraKgO40+6mIT
         GA6XecYIDYYT3wcMy1BwD8mCJUWQsufmYq09HbyC31jZhdnRYo4/e2brtNUMwFHPRSwT
         nDGg9p/VQ5nGHj3Rk9mhqklodLEo8wrOiOIXmyXSAUSPagNE5eP7XB5FDrGosn04h9r4
         8+BbLfBbw/cBZXEdZ2y5x2M6Adft04CdJBE2Ce4thr30cgLvNEtOnvyZGaQtqQ8ipBdF
         ihXSGYAJuE2ZVtOJ/Bcm3q4LbaU9lvQFx0C4AU5cS3m0iDcT2cKBYNWPmLK8IXGTTNCw
         eYHA==
X-Gm-Message-State: AOAM530oA73SK6vJqdOr+vSHT1ebPPtB4703uVkDgkKj6DOixjt+uvBB
        ZjY3vQnVUmEznwPbiS7YRdClpbRuAAU=
X-Google-Smtp-Source: ABdhPJw9ub+WY5Pt3+oMTBBtq6OvCNORNy7x0p+5Lv/8KVP83CLY1h8mYv07uCTNiG7XHmW4caB1SQ==
X-Received: by 2002:a63:b959:: with SMTP id v25mr20205561pgo.573.1640831837746;
        Wed, 29 Dec 2021 18:37:17 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id f7sm23069470pfc.141.2021.12.29.18.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 18:37:17 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 3/9] bpf: Remove check_kfunc_call callback and old kfunc BTF ID API
Date:   Thu, 30 Dec 2021 08:06:59 +0530
Message-Id: <20211230023705.3860970-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211230023705.3860970-1-memxor@gmail.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=17005; h=from:subject; bh=XUnv8DMXqQDwcp1DhXfFt5bSP7odVUmpnz03ia6Ar2A=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhzRr9FseVawTd2CgXgQfZfveNOU3GQHEoDJuHSh45 l5RN5b+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYc0a/QAKCRBM4MiGSL8RymOnEA CHQM3hdZIPuck0jUBLzc7AE5jfMgvJJFMJQqmEx3jBacQ4QQ2brTUm5+2PS6323mhJKAeV7kfMQZks 8mAbiuABqJGfBCZCC05VwsLGqts21MuAP6NGRqbUYbGFgT96fRQC6jv2jhpIxoOohunofwbiJm5aUr eSlE9eeaYdYTZbESn4qNmX/nB703JfQM3e0sFXsEID6isQWXTafigb323fYpCFaxMBFZXqUAdwKPsw iqL78JAkIAtwPc0K9wDykmeLWVBNzgS2SAeOLlFm9WgRUyDyTuIZtAXWgrk3YdU53Q744nX1aHphhI pHpxERG7bBsqryN4QJLu2+cFrFLdDI0uIYuXmXDaSm/98V65E5nqM75R/qviP4TbHDIp/7Ge9QPz8f w25PeC298OjVuPPilFo8I5+dfAiian22hv5XUEXjq7sT/YrKu120sXS4ABHSaRPAHkHgqITTwsYu+B EXGf7kh+rmse7qWE0FAUFFkhI6N/vvNZPLB+dzDd4YeZNFJPib8+FP0y6M+z5w/kYZS4GGUowOa21p 9HaOv9umT1PLdpZLBMEgxgX+F/HtIFE+MSllqDnhNA8OKT1f2Tgk1nw0phT17NI5j9yA+CVAV1aAmt J/aqWW4jgN2QwHO/fYgGmmhBAWWZz6n9Qt1Gd1n+xB/imGDN2wJdNUx1znMQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Completely remove the old code for check_kfunc_call to help it work
with modules.

The previous commit finds all symbols in vmlinux or modules while
parsing and preparing their BTF, and concatenates all related sets
organized by the hook and the type. Then, they are sorted to enable
bsearch using btf_id_set_contains.

Also, since we don't need the 'owner' module anywhere when doing
check_kfunc_call, drop the 'btf_modp' module parameter from
find_kfunc_desc_btf.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h                           |  8 ----
 include/linux/btf.h                           | 44 -----------------
 kernel/bpf/btf.c                              | 48 -------------------
 kernel/bpf/verifier.c                         | 20 ++++----
 net/bpf/test_run.c                            | 11 +----
 net/core/filter.c                             |  1 -
 net/ipv4/bpf_tcp_ca.c                         | 12 +----
 net/ipv4/tcp_bbr.c                            | 15 ++----
 net/ipv4/tcp_cubic.c                          | 15 ++----
 net/ipv4/tcp_dctcp.c                          | 15 ++----
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 15 ++----
 11 files changed, 24 insertions(+), 180 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 26753139d5b4..e381aeeffdd2 100644
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
index 48ac2dc437a2..b0283a1778c3 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -345,48 +345,4 @@ static inline bool btf_kfunc_id_set_contains(const struct btf *btf,
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
index c03c7b5a417c..f5b3049a56e0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6687,54 +6687,6 @@ BTF_ID_LIST_GLOBAL(btf_tracing_ids, MAX_BTF_TRACING_TYPE)
 BTF_TRACING_TYPE_xxx
 #undef BTF_TRACING_TYPE
 
-/* BTF ID set registration API for modules */
-
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
index ca5cd0de804c..e9503192101f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1735,7 +1735,7 @@ find_kfunc_desc(const struct bpf_prog *prog, u32 func_id, u16 offset)
 }
 
 static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
-					 s16 offset, struct module **btf_modp)
+					 s16 offset)
 {
 	struct bpf_kfunc_btf kf_btf = { .offset = offset };
 	struct bpf_kfunc_btf_tab *tab;
@@ -1789,8 +1789,6 @@ static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
 		sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
 		     kfunc_btf_cmp_by_off, NULL);
 	}
-	if (btf_modp)
-		*btf_modp = b->module;
 	return b->btf;
 }
 
@@ -1807,8 +1805,7 @@ void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab)
 }
 
 static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
-				       u32 func_id, s16 offset,
-				       struct module **btf_modp)
+				       u32 func_id, s16 offset)
 {
 	if (offset) {
 		if (offset < 0) {
@@ -1819,7 +1816,7 @@ static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
 			return ERR_PTR(-EINVAL);
 		}
 
-		return __find_kfunc_desc_btf(env, offset, btf_modp);
+		return __find_kfunc_desc_btf(env, offset);
 	}
 	return btf_vmlinux ?: ERR_PTR(-ENOENT);
 }
@@ -1882,7 +1879,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_btf_tab = btf_tab;
 	}
 
-	desc_btf = find_kfunc_desc_btf(env, func_id, offset, NULL);
+	desc_btf = find_kfunc_desc_btf(env, func_id, offset);
 	if (IS_ERR(desc_btf)) {
 		verbose(env, "failed to find BTF for kernel function\n");
 		return PTR_ERR(desc_btf);
@@ -2343,7 +2340,7 @@ static const char *disasm_kfunc_name(void *data, const struct bpf_insn *insn)
 	if (insn->src_reg != BPF_PSEUDO_KFUNC_CALL)
 		return NULL;
 
-	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off, NULL);
+	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off);
 	if (IS_ERR(desc_btf))
 		return "<error>";
 
@@ -6804,7 +6801,6 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
-	struct module *btf_mod = NULL;
 	const struct btf_param *args;
 	struct btf *desc_btf;
 	int err;
@@ -6813,7 +6809,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	if (!insn->imm)
 		return 0;
 
-	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
+	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
 
@@ -6822,8 +6818,8 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
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
index 46dd95755967..2ccd567aa514 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -236,18 +236,11 @@ __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
 
-BTF_SET_START(test_sk_kfunc_ids)
+BTF_KFUNC_SET_START(tc, check, test_sk_kfunc_ids)
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
+BTF_KFUNC_SET_END(tc, check, test_sk_kfunc_ids)
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
diff --git a/net/core/filter.c b/net/core/filter.c
index 606ab5a98a1a..404a9530ed25 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10001,7 +10001,6 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
-	.check_kfunc_call	= bpf_prog_test_check_kfunc_call,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index de610cb83694..468fe66220f3 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -212,26 +212,18 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 	}
 }
 
-BTF_SET_START(bpf_tcp_ca_kfunc_ids)
+BTF_KFUNC_SET_START(struct_ops, check, bpf_tcp_ca)
 BTF_ID(func, tcp_reno_ssthresh)
 BTF_ID(func, tcp_reno_cong_avoid)
 BTF_ID(func, tcp_reno_undo_cwnd)
 BTF_ID(func, tcp_slow_start)
 BTF_ID(func, tcp_cong_avoid_ai)
-BTF_SET_END(bpf_tcp_ca_kfunc_ids)
-
-static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id, struct module *owner)
-{
-	if (btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id))
-		return true;
-	return bpf_check_mod_kfunc_call(&bpf_tcp_ca_kfunc_list, kfunc_btf_id, owner);
-}
+BTF_KFUNC_SET_END(struct_ops, check, bpf_tcp_ca)
 
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
 	.get_func_proto		= bpf_tcp_ca_get_func_proto,
 	.is_valid_access	= bpf_tcp_ca_is_valid_access,
 	.btf_struct_access	= bpf_tcp_ca_btf_struct_access,
-	.check_kfunc_call	= bpf_tcp_ca_check_kfunc_call,
 };
 
 static int bpf_tcp_ca_init_member(const struct btf_type *t,
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index ec5550089b4d..f65582f3795c 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1154,7 +1154,7 @@ static struct tcp_congestion_ops tcp_bbr_cong_ops __read_mostly = {
 	.set_state	= bbr_set_state,
 };
 
-BTF_SET_START(tcp_bbr_kfunc_ids)
+BTF_KFUNC_SET_START(struct_ops, check, tcp_bbr)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
 BTF_ID(func, bbr_init)
@@ -1167,25 +1167,16 @@ BTF_ID(func, bbr_min_tso_segs)
 BTF_ID(func, bbr_set_state)
 #endif
 #endif
-BTF_SET_END(tcp_bbr_kfunc_ids)
-
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_bbr_kfunc_ids, tcp_bbr_kfunc_btf_set);
+BTF_KFUNC_SET_END(struct_ops, check, tcp_bbr)
 
 static int __init bbr_register(void)
 {
-	int ret;
-
 	BUILD_BUG_ON(sizeof(struct bbr) > ICSK_CA_PRIV_SIZE);
-	ret = tcp_register_congestion_control(&tcp_bbr_cong_ops);
-	if (ret)
-		return ret;
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
index e07837e23b3f..a67bad26b69e 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -485,7 +485,7 @@ static struct tcp_congestion_ops cubictcp __read_mostly = {
 	.name		= "cubic",
 };
 
-BTF_SET_START(tcp_cubic_kfunc_ids)
+BTF_KFUNC_SET_START(struct_ops, check, tcp_cubic)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
 BTF_ID(func, cubictcp_init)
@@ -496,14 +496,10 @@ BTF_ID(func, cubictcp_cwnd_event)
 BTF_ID(func, cubictcp_acked)
 #endif
 #endif
-BTF_SET_END(tcp_cubic_kfunc_ids)
-
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_cubic_kfunc_ids, tcp_cubic_kfunc_btf_set);
+BTF_KFUNC_SET_END(struct_ops, check, tcp_cubic)
 
 static int __init cubictcp_register(void)
 {
-	int ret;
-
 	BUILD_BUG_ON(sizeof(struct bictcp) > ICSK_CA_PRIV_SIZE);
 
 	/* Precompute a bunch of the scaling factors that are used per-packet
@@ -534,16 +530,11 @@ static int __init cubictcp_register(void)
 	/* divide by bic_scale and by constant Srtt (100ms) */
 	do_div(cube_factor, bic_scale * 10);
 
-	ret = tcp_register_congestion_control(&cubictcp);
-	if (ret)
-		return ret;
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
index 0d7ab3cc7b61..b5d7b1b914b3 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -238,7 +238,7 @@ static struct tcp_congestion_ops dctcp_reno __read_mostly = {
 	.name		= "dctcp-reno",
 };
 
-BTF_SET_START(tcp_dctcp_kfunc_ids)
+BTF_KFUNC_SET_START(struct_ops, check, tcp_dctcp)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
 BTF_ID(func, dctcp_init)
@@ -249,25 +249,16 @@ BTF_ID(func, dctcp_cwnd_undo)
 BTF_ID(func, dctcp_state)
 #endif
 #endif
-BTF_SET_END(tcp_dctcp_kfunc_ids)
-
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_dctcp_kfunc_ids, tcp_dctcp_kfunc_btf_set);
+BTF_KFUNC_SET_END(struct_ops, check, tcp_dctcp)
 
 static int __init dctcp_register(void)
 {
-	int ret;
-
 	BUILD_BUG_ON(sizeof(struct dctcp) > ICSK_CA_PRIV_SIZE);
-	ret = tcp_register_congestion_control(&dctcp);
-	if (ret)
-		return ret;
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
index 5d52ea2768df..13b2af3fa17a 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -89,26 +89,17 @@ static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
 	.write = bpf_testmod_test_write,
 };
 
-BTF_SET_START(bpf_testmod_kfunc_ids)
+BTF_KFUNC_SET_START(tc, check, bpf_testmod)
 BTF_ID(func, bpf_testmod_test_mod_kfunc)
-BTF_SET_END(bpf_testmod_kfunc_ids)
-
-static DEFINE_KFUNC_BTF_ID_SET(&bpf_testmod_kfunc_ids, bpf_testmod_kfunc_btf_set);
+BTF_KFUNC_SET_END(tc, check, bpf_testmod)
 
 static int bpf_testmod_init(void)
 {
-	int ret;
-
-	ret = sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
-	if (ret)
-		return ret;
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

