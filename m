Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A66557CC4A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiGUNnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiGUNnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:00 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188C38244F;
        Thu, 21 Jul 2022 06:42:54 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id ay11-20020a05600c1e0b00b003a3013da120so3344009wmb.5;
        Thu, 21 Jul 2022 06:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eGnKKNZIDDI+j9qwgynrfY5q39VGK62k6vfojM2ufxE=;
        b=GHcfz4RvQ5s2dkb9mtfXRgFStwvnbgGnBH+G20faJYK6ru6QHEn/WVg/gtq6hwkBxz
         TGEAKm/Qu8fSV299cjYx9CR6S+V+B6VFp9AW/3ibmZnGUO6Wa4lyiC1cVqM57BvR9VyV
         BMPu7d90XcpoqApjIP/oiel1AKtb/227JlLURDgOxEGLUH5pZTW/ZjrErZhcKLwBQH7X
         X8hh0jYgCIX1o7TWEj2sjbzWlO/Z4oF+ZA2r7QsWBsHYZ41ZaLcdynlr7wVNj3W9CXQV
         JTnmsb/DoWeRbx3xYVJeHpb/fmXLiiIh/bGuyh1N7qDai6CT9dYJ9QKkHoDd7eWVUOoW
         3MnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eGnKKNZIDDI+j9qwgynrfY5q39VGK62k6vfojM2ufxE=;
        b=2FIVx9YbYaMXbTRmVNVAg3vML5+yyS02wW3uZaes47E5M7bSbl4A1LdLlICOb4++NI
         MJraSybXyXpBfpJtY9om2Dr4DrhC+5dRyWgLp9VFGLquKiiJDrA4nFvGGamGiMJ6MW46
         LQZJ7MGm/0bFB2GD/vOap7BP8DhyD3llyw3Lzeyl9t4OHmOE6HublW2eETUVKqR1Mrw0
         FcEvtr27WU1LxHB0QyrGCOfcixmkfxim7KfXTxvOSW05Hzm+l5jZQVTf9pCWIXzip7hq
         KZOJoye+ZK21byXkx3eQ/ijQcugOWRS+DpUJV2fLhWWzVcF6ddyn6h8CHmJyDVEujQWI
         IxXQ==
X-Gm-Message-State: AJIora/jpxDWzPaTzVY50PLd1FISFmvPbdGfSHZInY3VUTInundsJAGV
        2NWhuW30dwmgUmVjFnwmKqkoi5cWCa5+0w==
X-Google-Smtp-Source: AGRyM1tzgUHI5z/3VXjfiEK81S+7zG5uiokMl17gitfvQRtWr0k1uqC3QoNFXoAhtuptFRzc3/Vj3w==
X-Received: by 2002:a05:600c:4f89:b0:3a3:31a5:87f9 with SMTP id n9-20020a05600c4f8900b003a331a587f9mr2240312wmq.149.1658410972111;
        Thu, 21 Jul 2022 06:42:52 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id z21-20020a05600c0a1500b0039c454067ddsm2122100wmp.15.2022.07.21.06.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:51 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v7 03/13] bpf: Switch to new kfunc flags infrastructure
Date:   Thu, 21 Jul 2022 15:42:35 +0200
Message-Id: <20220721134245.2450-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=26926; i=memxor@gmail.com; h=from:subject; bh=d10gkXtsiilQ6gOPqzWWioGa4JBfIqAkJu6QkQ523Fw=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfOIAH8p+ct1e/bBC3UnHVo1B8zGxC7JVN/q8qE zMb3HxKJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8RyrvdD/ 9ADDn3enEbyKRo7UlJaDi/xGS2tqsgev4awo+r60b2xFJV5YC6aoarsrAc4lWTYejMGauxuktWcDqt n3cNH1t1MTnlXRgaIwwGnv8iqoRFPWkwtNY2Ep33xUqUNXcn2Ujj9Y3DexposJXF1vcCNmhdVtre/Z /eAtF3gJdASLpbvU5MeU3jvB1yJUCo2p2XWEgmz9ISm7JnML4Oh63oK667fZ6IBdk0dntfffTn7pmv sFtQFGGF52SuJrA/zxKbAY7s4Hih33LzK30GXLUEkhQlzizULb4+66tSN5B+HyAATLZK81oxi88bij ZKzb9pSYBgiXrFKNvHrfT1TIbEYvfwv1KI+hWdIDW7MAcdd63aC3TJOaBNqyDOsGofu9/0XvZm4hub LcQVLOWUKNFx+LiRgk5fsc2vY4CvdFKdZbnfxeQYlTnjeazOP9eBD/edp/Hyh3cPWr8SRcfzvQF6Jg o1LyBqSIui1ngo+XTsy/ADeMQEmGuFA3RDa5Ln7KCkezXd0JMfylM4OuQPjOhpaP1KGivK9VpsZvEg QZ25l9VkWhnyltSnN8SgNQ6qP6H75QaY1Xidr39WqaVaXVIquQj8I2+dM6jYvpGvATVKBoBBGEZkWt vs2IcNQEBQ3+XGxRjn2MCnsEOCOKU4ywIGbrbIOzcAk1YSHRp4hlSUKlq5Hw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Instead of populating multiple sets to indicate some attribute and then
researching the same BTF ID in them, prepare a single unified BTF set
which indicates whether a kfunc is allowed to be called, and also its
attributes if any at the same time. Now, only one call is needed to
perform the lookup for both kfunc availability and its attributes.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h                           |   3 +-
 include/linux/btf.h                           |  33 ++----
 kernel/bpf/btf.c                              | 106 ++++++++----------
 kernel/bpf/verifier.c                         |  14 +--
 net/bpf/test_run.c                            |  70 ++++--------
 net/ipv4/bpf_tcp_ca.c                         |  18 +--
 net/ipv4/tcp_bbr.c                            |  24 ++--
 net/ipv4/tcp_cubic.c                          |  20 ++--
 net/ipv4/tcp_dctcp.c                          |  20 ++--
 net/netfilter/nf_conntrack_bpf.c              |  49 ++------
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  10 +-
 11 files changed, 145 insertions(+), 222 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a5bf00649995..974b575eb9e3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1920,7 +1920,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 				struct bpf_reg_state *regs);
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs);
+			      struct bpf_reg_state *regs,
+			      u32 kfunc_flags);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
 int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 1bfed7fa0428..6dfc6eaf7f8c 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -12,14 +12,11 @@
 #define BTF_TYPE_EMIT(type) ((void)(type *)0)
 #define BTF_TYPE_EMIT_ENUM(enum_val) ((void)enum_val)
 
-enum btf_kfunc_type {
-	BTF_KFUNC_TYPE_CHECK,
-	BTF_KFUNC_TYPE_ACQUIRE,
-	BTF_KFUNC_TYPE_RELEASE,
-	BTF_KFUNC_TYPE_RET_NULL,
-	BTF_KFUNC_TYPE_KPTR_ACQUIRE,
-	BTF_KFUNC_TYPE_MAX,
-};
+/* These need to be macros, as the expressions are used in assembler input */
+#define KF_ACQUIRE	(1 << 0) /* kfunc is an acquire function */
+#define KF_RELEASE	(1 << 1) /* kfunc is a release function */
+#define KF_RET_NULL	(1 << 2) /* kfunc returns a pointer that may be NULL */
+#define KF_KPTR_GET	(1 << 3) /* kfunc returns reference to a kptr */
 
 struct btf;
 struct btf_member;
@@ -30,16 +27,7 @@ struct btf_id_set;
 
 struct btf_kfunc_id_set {
 	struct module *owner;
-	union {
-		struct {
-			struct btf_id_set *check_set;
-			struct btf_id_set *acquire_set;
-			struct btf_id_set *release_set;
-			struct btf_id_set *ret_null_set;
-			struct btf_id_set *kptr_acquire_set;
-		};
-		struct btf_id_set *sets[BTF_KFUNC_TYPE_MAX];
-	};
+	struct btf_id_set8 *set;
 };
 
 struct btf_id_dtor_kfunc {
@@ -378,9 +366,9 @@ const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
 struct btf *btf_parse_vmlinux(void);
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
-bool btf_kfunc_id_set_contains(const struct btf *btf,
+u32 *btf_kfunc_id_set_contains(const struct btf *btf,
 			       enum bpf_prog_type prog_type,
-			       enum btf_kfunc_type type, u32 kfunc_btf_id);
+			       u32 kfunc_btf_id);
 int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 			      const struct btf_kfunc_id_set *s);
 s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id);
@@ -397,12 +385,11 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 {
 	return NULL;
 }
-static inline bool btf_kfunc_id_set_contains(const struct btf *btf,
+static inline u32 *btf_kfunc_id_set_contains(const struct btf *btf,
 					     enum bpf_prog_type prog_type,
-					     enum btf_kfunc_type type,
 					     u32 kfunc_btf_id)
 {
-	return false;
+	return NULL;
 }
 static inline int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 					    const struct btf_kfunc_id_set *s)
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 5869f03bcb6e..4d9c2d88720f 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -213,7 +213,7 @@ enum {
 };
 
 struct btf_kfunc_set_tab {
-	struct btf_id_set *sets[BTF_KFUNC_HOOK_MAX][BTF_KFUNC_TYPE_MAX];
+	struct btf_id_set8 *sets[BTF_KFUNC_HOOK_MAX];
 };
 
 struct btf_id_dtor_kfunc_tab {
@@ -1616,7 +1616,7 @@ static void btf_free_id(struct btf *btf)
 static void btf_free_kfunc_set_tab(struct btf *btf)
 {
 	struct btf_kfunc_set_tab *tab = btf->kfunc_set_tab;
-	int hook, type;
+	int hook;
 
 	if (!tab)
 		return;
@@ -1625,10 +1625,8 @@ static void btf_free_kfunc_set_tab(struct btf *btf)
 	 */
 	if (btf_is_module(btf))
 		goto free_tab;
-	for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
-		for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++)
-			kfree(tab->sets[hook][type]);
-	}
+	for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++)
+		kfree(tab->sets[hook]);
 free_tab:
 	kfree(tab);
 	btf->kfunc_set_tab = NULL;
@@ -6172,7 +6170,8 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
-				    bool ptr_to_mem_ok)
+				    bool ptr_to_mem_ok,
+				    u32 kfunc_flags)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	struct bpf_verifier_log *log = &env->log;
@@ -6210,10 +6209,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
 	if (is_kfunc) {
 		/* Only kfunc can be release func */
-		rel = btf_kfunc_id_set_contains(btf, resolve_prog_type(env->prog),
-						BTF_KFUNC_TYPE_RELEASE, func_id);
-		kptr_get = btf_kfunc_id_set_contains(btf, resolve_prog_type(env->prog),
-						     BTF_KFUNC_TYPE_KPTR_ACQUIRE, func_id);
+		rel = kfunc_flags & KF_RELEASE;
+		kptr_get = kfunc_flags & KF_KPTR_GET;
 	}
 
 	/* check that BTF function arguments match actual types that the
@@ -6442,7 +6439,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 		return -EINVAL;
 
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
-	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
+	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
 
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
@@ -6455,9 +6452,10 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs)
+			      struct bpf_reg_state *regs,
+			      u32 kfunc_flags)
 {
-	return btf_check_func_arg_match(env, btf, func_id, regs, true);
+	return btf_check_func_arg_match(env, btf, func_id, regs, true, kfunc_flags);
 }
 
 /* Convert BTF of a function into bpf_reg_state if possible
@@ -6854,6 +6852,11 @@ bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
 	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
 }
 
+static void *btf_id_set8_contains(const struct btf_id_set8 *set, u32 id)
+{
+	return bsearch(&id, set->pairs, set->cnt, sizeof(set->pairs[0]), btf_id_cmp_func);
+}
+
 enum {
 	BTF_MODULE_F_LIVE = (1 << 0),
 };
@@ -7102,16 +7105,16 @@ BTF_TRACING_TYPE_xxx
 
 /* Kernel Function (kfunc) BTF ID set registration API */
 
-static int __btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
-				    enum btf_kfunc_type type,
-				    struct btf_id_set *add_set, bool vmlinux_set)
+static int btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
+				  struct btf_id_set8 *add_set)
 {
+	bool vmlinux_set = !btf_is_module(btf);
 	struct btf_kfunc_set_tab *tab;
-	struct btf_id_set *set;
+	struct btf_id_set8 *set;
 	u32 set_cnt;
 	int ret;
 
-	if (hook >= BTF_KFUNC_HOOK_MAX || type >= BTF_KFUNC_TYPE_MAX) {
+	if (hook >= BTF_KFUNC_HOOK_MAX) {
 		ret = -EINVAL;
 		goto end;
 	}
@@ -7127,7 +7130,7 @@ static int __btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
 		btf->kfunc_set_tab = tab;
 	}
 
-	set = tab->sets[hook][type];
+	set = tab->sets[hook];
 	/* Warn when register_btf_kfunc_id_set is called twice for the same hook
 	 * for module sets.
 	 */
@@ -7141,7 +7144,7 @@ static int __btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
 	 * pointer and return.
 	 */
 	if (!vmlinux_set) {
-		tab->sets[hook][type] = add_set;
+		tab->sets[hook] = add_set;
 		return 0;
 	}
 
@@ -7150,7 +7153,7 @@ static int __btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
 	 * and concatenate all individual sets being registered. While each set
 	 * is individually sorted, they may become unsorted when concatenated,
 	 * hence re-sorting the final set again is required to make binary
-	 * searching the set using btf_id_set_contains function work.
+	 * searching the set using btf_id_set8_contains function work.
 	 */
 	set_cnt = set ? set->cnt : 0;
 
@@ -7165,8 +7168,8 @@ static int __btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
 	}
 
 	/* Grow set */
-	set = krealloc(tab->sets[hook][type],
-		       offsetof(struct btf_id_set, ids[set_cnt + add_set->cnt]),
+	set = krealloc(tab->sets[hook],
+		       offsetof(struct btf_id_set8, pairs[set_cnt + add_set->cnt]),
 		       GFP_KERNEL | __GFP_NOWARN);
 	if (!set) {
 		ret = -ENOMEM;
@@ -7174,15 +7177,15 @@ static int __btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
 	}
 
 	/* For newly allocated set, initialize set->cnt to 0 */
-	if (!tab->sets[hook][type])
+	if (!tab->sets[hook])
 		set->cnt = 0;
-	tab->sets[hook][type] = set;
+	tab->sets[hook] = set;
 
 	/* Concatenate the two sets */
-	memcpy(set->ids + set->cnt, add_set->ids, add_set->cnt * sizeof(set->ids[0]));
+	memcpy(set->pairs + set->cnt, add_set->pairs, add_set->cnt * sizeof(set->pairs[0]));
 	set->cnt += add_set->cnt;
 
-	sort(set->ids, set->cnt, sizeof(set->ids[0]), btf_id_cmp_func, NULL);
+	sort(set->pairs, set->cnt, sizeof(set->pairs[0]), btf_id_cmp_func, NULL);
 
 	return 0;
 end:
@@ -7190,38 +7193,25 @@ static int __btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
 	return ret;
 }
 
-static int btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
-				  const struct btf_kfunc_id_set *kset)
-{
-	bool vmlinux_set = !btf_is_module(btf);
-	int type, ret = 0;
-
-	for (type = 0; type < ARRAY_SIZE(kset->sets); type++) {
-		if (!kset->sets[type])
-			continue;
-
-		ret = __btf_populate_kfunc_set(btf, hook, type, kset->sets[type], vmlinux_set);
-		if (ret)
-			break;
-	}
-	return ret;
-}
-
-static bool __btf_kfunc_id_set_contains(const struct btf *btf,
+static u32 *__btf_kfunc_id_set_contains(const struct btf *btf,
 					enum btf_kfunc_hook hook,
-					enum btf_kfunc_type type,
 					u32 kfunc_btf_id)
 {
-	struct btf_id_set *set;
+	struct btf_id_set8 *set;
+	u32 *id;
 
-	if (hook >= BTF_KFUNC_HOOK_MAX || type >= BTF_KFUNC_TYPE_MAX)
-		return false;
+	if (hook >= BTF_KFUNC_HOOK_MAX)
+		return NULL;
 	if (!btf->kfunc_set_tab)
-		return false;
-	set = btf->kfunc_set_tab->sets[hook][type];
+		return NULL;
+	set = btf->kfunc_set_tab->sets[hook];
 	if (!set)
-		return false;
-	return btf_id_set_contains(set, kfunc_btf_id);
+		return NULL;
+	id = btf_id_set8_contains(set, kfunc_btf_id);
+	if (!id)
+		return NULL;
+	/* The flags for BTF ID are located next to it */
+	return id + 1;
 }
 
 static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
@@ -7249,14 +7239,14 @@ static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
  * keeping the reference for the duration of the call provides the necessary
  * protection for looking up a well-formed btf->kfunc_set_tab.
  */
-bool btf_kfunc_id_set_contains(const struct btf *btf,
+u32 *btf_kfunc_id_set_contains(const struct btf *btf,
 			       enum bpf_prog_type prog_type,
-			       enum btf_kfunc_type type, u32 kfunc_btf_id)
+			       u32 kfunc_btf_id)
 {
 	enum btf_kfunc_hook hook;
 
 	hook = bpf_prog_type_to_kfunc_hook(prog_type);
-	return __btf_kfunc_id_set_contains(btf, hook, type, kfunc_btf_id);
+	return __btf_kfunc_id_set_contains(btf, hook, kfunc_btf_id);
 }
 
 /* This function must be invoked only from initcalls/module init functions */
@@ -7283,7 +7273,7 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 		return PTR_ERR(btf);
 
 	hook = bpf_prog_type_to_kfunc_hook(prog_type);
-	ret = btf_populate_kfunc_set(btf, hook, kset);
+	ret = btf_populate_kfunc_set(btf, hook, kset->set);
 	btf_put(btf);
 	return ret;
 }
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c59c3df0fea6..6a12e3613d22 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7560,6 +7560,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	int err, insn_idx = *insn_idx_p;
 	const struct btf_param *args;
 	struct btf *desc_btf;
+	u32 *kfunc_flags;
 	bool acq;
 
 	/* skip for now, but return error when we find this in fixup_kfunc_call */
@@ -7575,18 +7576,16 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	func_name = btf_name_by_offset(desc_btf, func->name_off);
 	func_proto = btf_type_by_id(desc_btf, func->type);
 
-	if (!btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
-				      BTF_KFUNC_TYPE_CHECK, func_id)) {
+	kfunc_flags = btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog), func_id);
+	if (!kfunc_flags) {
 		verbose(env, "calling kernel function %s is not allowed\n",
 			func_name);
 		return -EACCES;
 	}
-
-	acq = btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
-					BTF_KFUNC_TYPE_ACQUIRE, func_id);
+	acq = *kfunc_flags & KF_ACQUIRE;
 
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, *kfunc_flags);
 	if (err < 0)
 		return err;
 	/* In case of release function, we get register number of refcounted
@@ -7630,8 +7629,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		regs[BPF_REG_0].btf = desc_btf;
 		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
-		if (btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
-					      BTF_KFUNC_TYPE_RET_NULL, func_id)) {
+		if (*kfunc_flags & KF_RET_NULL) {
 			regs[BPF_REG_0].type |= PTR_MAYBE_NULL;
 			/* For mark_ptr_or_null_reg, see 93c230e3f5bd6 */
 			regs[BPF_REG_0].id = ++env->id_gen;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index dc9dc0bedca0..ca5b7234a350 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -695,48 +695,26 @@ __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
 
-BTF_SET_START(test_sk_check_kfunc_ids)
-BTF_ID(func, bpf_kfunc_call_test1)
-BTF_ID(func, bpf_kfunc_call_test2)
-BTF_ID(func, bpf_kfunc_call_test3)
-BTF_ID(func, bpf_kfunc_call_test_acquire)
-BTF_ID(func, bpf_kfunc_call_memb_acquire)
-BTF_ID(func, bpf_kfunc_call_test_release)
-BTF_ID(func, bpf_kfunc_call_memb_release)
-BTF_ID(func, bpf_kfunc_call_memb1_release)
-BTF_ID(func, bpf_kfunc_call_test_kptr_get)
-BTF_ID(func, bpf_kfunc_call_test_pass_ctx)
-BTF_ID(func, bpf_kfunc_call_test_pass1)
-BTF_ID(func, bpf_kfunc_call_test_pass2)
-BTF_ID(func, bpf_kfunc_call_test_fail1)
-BTF_ID(func, bpf_kfunc_call_test_fail2)
-BTF_ID(func, bpf_kfunc_call_test_fail3)
-BTF_ID(func, bpf_kfunc_call_test_mem_len_pass1)
-BTF_ID(func, bpf_kfunc_call_test_mem_len_fail1)
-BTF_ID(func, bpf_kfunc_call_test_mem_len_fail2)
-BTF_SET_END(test_sk_check_kfunc_ids)
-
-BTF_SET_START(test_sk_acquire_kfunc_ids)
-BTF_ID(func, bpf_kfunc_call_test_acquire)
-BTF_ID(func, bpf_kfunc_call_memb_acquire)
-BTF_ID(func, bpf_kfunc_call_test_kptr_get)
-BTF_SET_END(test_sk_acquire_kfunc_ids)
-
-BTF_SET_START(test_sk_release_kfunc_ids)
-BTF_ID(func, bpf_kfunc_call_test_release)
-BTF_ID(func, bpf_kfunc_call_memb_release)
-BTF_ID(func, bpf_kfunc_call_memb1_release)
-BTF_SET_END(test_sk_release_kfunc_ids)
-
-BTF_SET_START(test_sk_ret_null_kfunc_ids)
-BTF_ID(func, bpf_kfunc_call_test_acquire)
-BTF_ID(func, bpf_kfunc_call_memb_acquire)
-BTF_ID(func, bpf_kfunc_call_test_kptr_get)
-BTF_SET_END(test_sk_ret_null_kfunc_ids)
-
-BTF_SET_START(test_sk_kptr_acquire_kfunc_ids)
-BTF_ID(func, bpf_kfunc_call_test_kptr_get)
-BTF_SET_END(test_sk_kptr_acquire_kfunc_ids)
+BTF_SET8_START(test_sk_check_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test1)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test2)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test3)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_acquire, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_kfunc_call_memb_acquire, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_kfunc_call_memb_release, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_kfunc_call_memb1_release, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_kptr_get, KF_ACQUIRE | KF_RET_NULL | KF_KPTR_GET)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass_ctx)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass1)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_pass2)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail1)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail2)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail3)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail1)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail2)
+BTF_SET8_END(test_sk_check_kfunc_ids)
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
 			   u32 size, u32 headroom, u32 tailroom)
@@ -1620,12 +1598,8 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 }
 
 static const struct btf_kfunc_id_set bpf_prog_test_kfunc_set = {
-	.owner        = THIS_MODULE,
-	.check_set        = &test_sk_check_kfunc_ids,
-	.acquire_set      = &test_sk_acquire_kfunc_ids,
-	.release_set      = &test_sk_release_kfunc_ids,
-	.ret_null_set     = &test_sk_ret_null_kfunc_ids,
-	.kptr_acquire_set = &test_sk_kptr_acquire_kfunc_ids
+	.owner = THIS_MODULE,
+	.set   = &test_sk_check_kfunc_ids,
 };
 
 BTF_ID_LIST(bpf_prog_test_dtor_kfunc_ids)
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 7a181631b995..85a9e500c42d 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -197,17 +197,17 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 	}
 }
 
-BTF_SET_START(bpf_tcp_ca_check_kfunc_ids)
-BTF_ID(func, tcp_reno_ssthresh)
-BTF_ID(func, tcp_reno_cong_avoid)
-BTF_ID(func, tcp_reno_undo_cwnd)
-BTF_ID(func, tcp_slow_start)
-BTF_ID(func, tcp_cong_avoid_ai)
-BTF_SET_END(bpf_tcp_ca_check_kfunc_ids)
+BTF_SET8_START(bpf_tcp_ca_check_kfunc_ids)
+BTF_ID_FLAGS(func, tcp_reno_ssthresh)
+BTF_ID_FLAGS(func, tcp_reno_cong_avoid)
+BTF_ID_FLAGS(func, tcp_reno_undo_cwnd)
+BTF_ID_FLAGS(func, tcp_slow_start)
+BTF_ID_FLAGS(func, tcp_cong_avoid_ai)
+BTF_SET8_END(bpf_tcp_ca_check_kfunc_ids)
 
 static const struct btf_kfunc_id_set bpf_tcp_ca_kfunc_set = {
-	.owner     = THIS_MODULE,
-	.check_set = &bpf_tcp_ca_check_kfunc_ids,
+	.owner = THIS_MODULE,
+	.set   = &bpf_tcp_ca_check_kfunc_ids,
 };
 
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 075e744bfb48..54eec33c6e1c 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1154,24 +1154,24 @@ static struct tcp_congestion_ops tcp_bbr_cong_ops __read_mostly = {
 	.set_state	= bbr_set_state,
 };
 
-BTF_SET_START(tcp_bbr_check_kfunc_ids)
+BTF_SET8_START(tcp_bbr_check_kfunc_ids)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
-BTF_ID(func, bbr_init)
-BTF_ID(func, bbr_main)
-BTF_ID(func, bbr_sndbuf_expand)
-BTF_ID(func, bbr_undo_cwnd)
-BTF_ID(func, bbr_cwnd_event)
-BTF_ID(func, bbr_ssthresh)
-BTF_ID(func, bbr_min_tso_segs)
-BTF_ID(func, bbr_set_state)
+BTF_ID_FLAGS(func, bbr_init)
+BTF_ID_FLAGS(func, bbr_main)
+BTF_ID_FLAGS(func, bbr_sndbuf_expand)
+BTF_ID_FLAGS(func, bbr_undo_cwnd)
+BTF_ID_FLAGS(func, bbr_cwnd_event)
+BTF_ID_FLAGS(func, bbr_ssthresh)
+BTF_ID_FLAGS(func, bbr_min_tso_segs)
+BTF_ID_FLAGS(func, bbr_set_state)
 #endif
 #endif
-BTF_SET_END(tcp_bbr_check_kfunc_ids)
+BTF_SET8_END(tcp_bbr_check_kfunc_ids)
 
 static const struct btf_kfunc_id_set tcp_bbr_kfunc_set = {
-	.owner     = THIS_MODULE,
-	.check_set = &tcp_bbr_check_kfunc_ids,
+	.owner = THIS_MODULE,
+	.set   = &tcp_bbr_check_kfunc_ids,
 };
 
 static int __init bbr_register(void)
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 68178e7280ce..768c10c1f649 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -485,22 +485,22 @@ static struct tcp_congestion_ops cubictcp __read_mostly = {
 	.name		= "cubic",
 };
 
-BTF_SET_START(tcp_cubic_check_kfunc_ids)
+BTF_SET8_START(tcp_cubic_check_kfunc_ids)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
-BTF_ID(func, cubictcp_init)
-BTF_ID(func, cubictcp_recalc_ssthresh)
-BTF_ID(func, cubictcp_cong_avoid)
-BTF_ID(func, cubictcp_state)
-BTF_ID(func, cubictcp_cwnd_event)
-BTF_ID(func, cubictcp_acked)
+BTF_ID_FLAGS(func, cubictcp_init)
+BTF_ID_FLAGS(func, cubictcp_recalc_ssthresh)
+BTF_ID_FLAGS(func, cubictcp_cong_avoid)
+BTF_ID_FLAGS(func, cubictcp_state)
+BTF_ID_FLAGS(func, cubictcp_cwnd_event)
+BTF_ID_FLAGS(func, cubictcp_acked)
 #endif
 #endif
-BTF_SET_END(tcp_cubic_check_kfunc_ids)
+BTF_SET8_END(tcp_cubic_check_kfunc_ids)
 
 static const struct btf_kfunc_id_set tcp_cubic_kfunc_set = {
-	.owner     = THIS_MODULE,
-	.check_set = &tcp_cubic_check_kfunc_ids,
+	.owner = THIS_MODULE,
+	.set   = &tcp_cubic_check_kfunc_ids,
 };
 
 static int __init cubictcp_register(void)
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index ab034a4e9324..2a6c0dd665a4 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -239,22 +239,22 @@ static struct tcp_congestion_ops dctcp_reno __read_mostly = {
 	.name		= "dctcp-reno",
 };
 
-BTF_SET_START(tcp_dctcp_check_kfunc_ids)
+BTF_SET8_START(tcp_dctcp_check_kfunc_ids)
 #ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
-BTF_ID(func, dctcp_init)
-BTF_ID(func, dctcp_update_alpha)
-BTF_ID(func, dctcp_cwnd_event)
-BTF_ID(func, dctcp_ssthresh)
-BTF_ID(func, dctcp_cwnd_undo)
-BTF_ID(func, dctcp_state)
+BTF_ID_FLAGS(func, dctcp_init)
+BTF_ID_FLAGS(func, dctcp_update_alpha)
+BTF_ID_FLAGS(func, dctcp_cwnd_event)
+BTF_ID_FLAGS(func, dctcp_ssthresh)
+BTF_ID_FLAGS(func, dctcp_cwnd_undo)
+BTF_ID_FLAGS(func, dctcp_state)
 #endif
 #endif
-BTF_SET_END(tcp_dctcp_check_kfunc_ids)
+BTF_SET8_END(tcp_dctcp_check_kfunc_ids)
 
 static const struct btf_kfunc_id_set tcp_dctcp_kfunc_set = {
-	.owner     = THIS_MODULE,
-	.check_set = &tcp_dctcp_check_kfunc_ids,
+	.owner = THIS_MODULE,
+	.set   = &tcp_dctcp_check_kfunc_ids,
 };
 
 static int __init dctcp_register(void)
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index bc4d5cd63a94..cf2096f65d0e 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -219,48 +219,21 @@ void bpf_ct_release(struct nf_conn *nfct)
 
 __diag_pop()
 
-BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
-BTF_ID(func, bpf_xdp_ct_lookup)
-BTF_ID(func, bpf_ct_release)
-BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
-
-BTF_SET_START(nf_ct_tc_check_kfunc_ids)
-BTF_ID(func, bpf_skb_ct_lookup)
-BTF_ID(func, bpf_ct_release)
-BTF_SET_END(nf_ct_tc_check_kfunc_ids)
-
-BTF_SET_START(nf_ct_acquire_kfunc_ids)
-BTF_ID(func, bpf_xdp_ct_lookup)
-BTF_ID(func, bpf_skb_ct_lookup)
-BTF_SET_END(nf_ct_acquire_kfunc_ids)
-
-BTF_SET_START(nf_ct_release_kfunc_ids)
-BTF_ID(func, bpf_ct_release)
-BTF_SET_END(nf_ct_release_kfunc_ids)
-
-/* Both sets are identical */
-#define nf_ct_ret_null_kfunc_ids nf_ct_acquire_kfunc_ids
-
-static const struct btf_kfunc_id_set nf_conntrack_xdp_kfunc_set = {
-	.owner        = THIS_MODULE,
-	.check_set    = &nf_ct_xdp_check_kfunc_ids,
-	.acquire_set  = &nf_ct_acquire_kfunc_ids,
-	.release_set  = &nf_ct_release_kfunc_ids,
-	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
-};
-
-static const struct btf_kfunc_id_set nf_conntrack_tc_kfunc_set = {
-	.owner        = THIS_MODULE,
-	.check_set    = &nf_ct_tc_check_kfunc_ids,
-	.acquire_set  = &nf_ct_acquire_kfunc_ids,
-	.release_set  = &nf_ct_release_kfunc_ids,
-	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
+BTF_SET8_START(nf_ct_kfunc_set)
+BTF_ID_FLAGS(func, bpf_xdp_ct_lookup, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_skb_ct_lookup, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_ct_release, KF_RELEASE)
+BTF_SET8_END(nf_ct_kfunc_set)
+
+static const struct btf_kfunc_id_set nf_conntrack_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &nf_ct_kfunc_set,
 };
 
 int register_nf_conntrack_bpf(void)
 {
 	int ret;
 
-	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &nf_conntrack_xdp_kfunc_set);
-	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_tc_kfunc_set);
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &nf_conntrack_kfunc_set);
+	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_kfunc_set);
 }
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index e585e1cefc77..792cb15bac40 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -148,13 +148,13 @@ static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
 	.write = bpf_testmod_test_write,
 };
 
-BTF_SET_START(bpf_testmod_check_kfunc_ids)
-BTF_ID(func, bpf_testmod_test_mod_kfunc)
-BTF_SET_END(bpf_testmod_check_kfunc_ids)
+BTF_SET8_START(bpf_testmod_check_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_testmod_test_mod_kfunc)
+BTF_SET8_END(bpf_testmod_check_kfunc_ids)
 
 static const struct btf_kfunc_id_set bpf_testmod_kfunc_set = {
-	.owner     = THIS_MODULE,
-	.check_set = &bpf_testmod_check_kfunc_ids,
+	.owner = THIS_MODULE,
+	.set   = &bpf_testmod_check_kfunc_ids,
 };
 
 extern int bpf_fentry_test1(int a);
-- 
2.34.1

