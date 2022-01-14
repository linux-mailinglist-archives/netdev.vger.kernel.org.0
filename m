Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C828648EE74
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243513AbiANQku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243490AbiANQku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:40:50 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D342FC061574;
        Fri, 14 Jan 2022 08:40:49 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id i129so3200995pfe.13;
        Fri, 14 Jan 2022 08:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HD4M3Rk3Zy1xZdRPZfheZqpk/6G81Ql2oVsCPzjOTpg=;
        b=P4FV0rf10JhHeUrUCnmy178CuvP+5rqDeRnjvef/EmYK1OrwAmqRZZItkLNoJ0hh3X
         K8AukRFIbQLH5c+g5+Od+IHeERLMICNAqzmfPG6o5EcTYburtia5/5auJUMMN9VPPZ16
         VqdIcMS9tKLoUvlg2T+kqRfLj9Np2JOJ+xmmgD+jnsscAVue9SDq+Ve1hmtp0OkmiVh0
         vSYZKYr5WdxVrwa63eNgNSb1TA9Hw/sVZqRPA4jcqJ4LKelRzlbyspOF5jrewpj6ToYi
         olTO0pDV6ybBKo2c1qXXgEJvfeSF4cxavUjiqV/hM0285tRGd2wZU2c/mtlGEec5CplG
         +SEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HD4M3Rk3Zy1xZdRPZfheZqpk/6G81Ql2oVsCPzjOTpg=;
        b=Bk3sLMSiA+3yF0pove1NpQS/5vQ0g1KA0GGB3DOcSs1rXhQGK63l1ufI9Bw6dkxn1E
         U9SflcOE4qaVlf4C59MiaADdKcabsixwC5spG8GCWXp6nvUfJ4WHt+J9io6xyRI/agor
         ATDPNoU66HHvuCjdTnrKU54fYhiLu1erL8dR4UTFXPjSnMuw8AXP9IvG/9HM1wRJOBlQ
         cPV3FCb1chok0JUGxgt7lNgcKelDuRL0EsuH2coCudzfxJSlikcwGQ4FBP9QO54VEGIm
         pFfxFqirI1aV+GHFO2onqra4FQ4WWeqEojnhTtzrnYmB9S+LqVukY//a36wU0rWbO/KX
         ylEg==
X-Gm-Message-State: AOAM530rKVcpkcA5aNUZSRg6yn/MNCVI1HGEV8VTP+UM075+obQ+vyT8
        KEF/9ygKCDFLg+4DeMsmZKDIBxFxPr6uHA==
X-Google-Smtp-Source: ABdhPJyGK8qJtA2autuBKye6yRy5TWwGzOJC0WmBs9IR1+9hPzKz+MP0x8pL8Y17Voz+9sp32YEY7w==
X-Received: by 2002:a63:780a:: with SMTP id t10mr8707093pgc.177.1642178448973;
        Fri, 14 Jan 2022 08:40:48 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id p10sm6534476pfo.95.2022.01.14.08.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:40:48 -0800 (PST)
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
Subject: [PATCH bpf-next v8 03/10] bpf: Remove check_kfunc_call callback and old kfunc BTF ID API
Date:   Fri, 14 Jan 2022 22:09:46 +0530
Message-Id: <20220114163953.1455836-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114163953.1455836-1-memxor@gmail.com>
References: <20220114163953.1455836-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=19078; h=from:subject; bh=qP8+YrbAeYhQKlnoyjhE81rLgo+bWiINORVY92RkRZQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh4acUpEfMN5rT+jRFh6whlwL8O+uCbVwpxOlL8j7V 78zBF6uJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYeGnFAAKCRBM4MiGSL8RyrFsD/ 0cOJRQa21x3xLYzOQaZwgfYKMvkiUXOvZ59Evl6aGEsArplMceqRHfKY4yi44QdHhILi126i2rIlik lNJkquUXO4576KHE2ZjYfBpD/NvXracrcL1G/b4ytrIXlv+i8oEWw0PiB5E+yjTlnZ7J8DT9RJE/Co graLDKkLUwOMUb/RmvRdMJFX5US6jfWA4v0ew2CmRZFFGhaeRG4ubSF4dKhwLv84ganblZFinLcUCn RouyYWGJgTpr4aj+Wu4fyR3tHrUUr+Wrdji9nvkyLBwTYVUdq1fchEggR5veo/4uAqUfND6lL9xROj XhCFsPAerV7fmwHSHEgNrrk7+u40cR3FjBXaNcoMUGDwy8dEp58gwoZTwyRNHA9gOrH7W4GzEDEEHR +fUw1Ebz872lroRf7E9juxVPvp6MRkZ3i4HVXHrXlnZfBTAn2vM0prhqaMh2fI3WDvITzQrYaXCs1d 3pGhDf8mLJw2mm9VDCc6OFeSpoKZ1pp0sfd7+N3gskZnLrgnqd/k7I9LQNN7inEiBkMUUGicn62VH3 9E/g45GOehjSUu7lJkSIKnCMWSmCPp681fXPFjocasruWTQ1kQ45QhtV+3tQFDZPZCkxp9g9Hqkk37 NvYIHXGhjP8r+xe1rd4x1aS4YuEADyT9rpCefIpB341NWdzc3v+8njLnFr7Q==
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
index c451f8e2612a..b12cfe3b12bb 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -359,48 +359,4 @@ static inline int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
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
index 74037bd65d17..4be5cf629ca9 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6682,52 +6682,6 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
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
index bfb45381fb3f..72802c1eb5ac 100644
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
@@ -1795,8 +1795,6 @@ static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
 		sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
 		     kfunc_btf_cmp_by_off, NULL);
 	}
-	if (btf_modp)
-		*btf_modp = b->module;
 	return b->btf;
 }
 
@@ -1813,8 +1811,7 @@ void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab)
 }
 
 static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
-				       u32 func_id, s16 offset,
-				       struct module **btf_modp)
+				       u32 func_id, s16 offset)
 {
 	if (offset) {
 		if (offset < 0) {
@@ -1825,7 +1822,7 @@ static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
 			return ERR_PTR(-EINVAL);
 		}
 
-		return __find_kfunc_desc_btf(env, offset, btf_modp);
+		return __find_kfunc_desc_btf(env, offset);
 	}
 	return btf_vmlinux ?: ERR_PTR(-ENOENT);
 }
@@ -1888,7 +1885,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_btf_tab = btf_tab;
 	}
 
-	desc_btf = find_kfunc_desc_btf(env, func_id, offset, NULL);
+	desc_btf = find_kfunc_desc_btf(env, func_id, offset);
 	if (IS_ERR(desc_btf)) {
 		verbose(env, "failed to find BTF for kernel function\n");
 		return PTR_ERR(desc_btf);
@@ -2349,7 +2346,7 @@ static const char *disasm_kfunc_name(void *data, const struct bpf_insn *insn)
 	if (insn->src_reg != BPF_PSEUDO_KFUNC_CALL)
 		return NULL;
 
-	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off, NULL);
+	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off);
 	if (IS_ERR(desc_btf))
 		return "<error>";
 
@@ -6820,7 +6817,6 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
-	struct module *btf_mod = NULL;
 	const struct btf_param *args;
 	struct btf *desc_btf;
 	int err;
@@ -6829,7 +6825,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	if (!insn->imm)
 		return 0;
 
-	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
+	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
 
@@ -6838,8 +6834,8 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
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

