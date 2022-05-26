Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78017535590
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiEZVgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349139AbiEZVf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828A9E2770;
        Thu, 26 May 2022 14:35:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F070561B9F;
        Thu, 26 May 2022 21:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9393C34113;
        Thu, 26 May 2022 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600954;
        bh=48We6qG1H0Lampl10l/ZCWya5IW2jF018MmP42l9VbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6VkfIhgODdm0i5Wn1amHTxV8ZtA67Jz7EU82dbifZaw2wA4Q/r8kqd25w8AJotPc
         OkTnc2JUNOr8xFPap3ovwyKiklCzjuLwgxivgqmugvjj2ewhftAFEBCLfqpWAnNdlk
         mTyFlCy65B0TCqDGU607FS2xfdpQ6nyosj7fAp114JgD1nbZ/9mfJBQuNUVIQ4S9We
         Z2eZ3JxOodgprlwsSeYVW3FpPkHp23+teYOpmJRjrDWWlCoT2tcBdfeVthhBgnJklG
         Rhs0qHVYLH6+FvMDoCps+jMwbbyuSnFRvG6aoyS3jJMXSA2HQ8auxBYDqjWdKu4vP5
         oiSvZ0Ld2mEMg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 07/14] bpf: Define acquire-release pairs for kfuncs
Date:   Thu, 26 May 2022 23:34:55 +0200
Message-Id: <0d951f5f56365c4f8a7b2ed8951d997b7bc696ef.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Introduce support for specifying pairings of acquire release kfuncs, so
that when there are multiple candidates that may produce the same type
of referenced PTR_TO_BTF_ID, it is clear which ones are allowed and
which ones are not. This is an additional check performed after the
typical type checks kfuncs are subjected to.

This is needed because we want to prevent bpf_ct_release for pointer
obtained from bpf_xdp_ct_alloc, and only allow it to be passed to
insert kfunc. Since bpf_ct_release takes const parameter, it can
take rdonly and non-rdonly PTR_TO_BTF_ID. To avoid this confusion
in case of multiple candidate release kfuncs, we can define a strict
pairing between acquire and release kfuncs that will be checked and
enforced only if defined. The only condition is that an acquire kfunc
either has no mappings, or defines all possible mappings.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/bpf_verifier.h     |  1 +
 include/linux/btf.h              | 11 ++++
 kernel/bpf/btf.c                 | 99 +++++++++++++++++++++++++++++++-
 kernel/bpf/verifier.c            | 17 +++++-
 net/netfilter/nf_conntrack_bpf.c | 31 ++++++----
 5 files changed, 147 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index e8439f6cbe57..fb87f9cfa41a 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -68,6 +68,7 @@ struct bpf_reg_state {
 		struct {
 			struct btf *btf;
 			u32 btf_id;
+			u32 acq_kfunc_btf_id;
 		};
 
 		u32 mem_size; /* for PTR_TO_MEM | PTR_TO_MEM_OR_NULL */
diff --git a/include/linux/btf.h b/include/linux/btf.h
index f8dc5f810b40..30977d7332c6 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -40,6 +40,8 @@ struct btf_kfunc_id_set {
 		};
 		struct btf_id_set *sets[BTF_KFUNC_TYPE_MAX];
 	};
+	u32 *acq_rel_pairs;
+	u32 acq_rel_pairs_cnt;
 };
 
 struct btf_id_dtor_kfunc {
@@ -382,6 +384,9 @@ struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
 bool btf_kfunc_id_set_contains(const struct btf *btf,
 			       enum bpf_prog_type prog_type,
 			       enum btf_kfunc_type type, u32 kfunc_btf_id);
+int btf_kfunc_match_acq_rel_pair(const struct btf *btf,
+				 enum bpf_prog_type prog_type,
+				 u32 acq_kfunc_btf_id, u32 rel_kfunc_btf_id);
 int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 			      const struct btf_kfunc_id_set *s);
 s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id);
@@ -405,6 +410,12 @@ static inline bool btf_kfunc_id_set_contains(const struct btf *btf,
 {
 	return false;
 }
+static inline int btf_kfunc_match_acq_rel_pair(const struct btf *btf,
+					       enum bpf_prog_type prog_type,
+					       u32 acq_kfunc_btf_id, u32 rel_kfunc_btf_id)
+{
+	return 0;
+}
 static inline int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 					    const struct btf_kfunc_id_set *s)
 {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9b9fbb43c417..456ba6120aa8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -214,6 +214,7 @@ enum {
 
 struct btf_kfunc_set_tab {
 	struct btf_id_set *sets[BTF_KFUNC_HOOK_MAX][BTF_KFUNC_TYPE_MAX];
+	struct btf_id_set *acq_rel_pairs[BTF_KFUNC_HOOK_MAX];
 };
 
 struct btf_id_dtor_kfunc_tab {
@@ -1595,6 +1596,7 @@ static void btf_free_kfunc_set_tab(struct btf *btf)
 	for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
 		for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++)
 			kfree(tab->sets[hook][type]);
+		kfree(tab->acq_rel_pairs[hook]);
 	}
 free_tab:
 	kfree(tab);
@@ -6226,7 +6228,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
 			if (base_type(reg->type) == PTR_TO_BTF_ID) {
 				if ((reg->type & MEM_RDONLY) && !is_ref_t_const) {
-					bpf_log(log, "cannot pass read only pointer to arg#%d", i);
+					bpf_log(log, "cannot pass read only pointer to arg#%d\n", i);
 					return -EINVAL;
 				}
 				reg_btf = reg->btf;
@@ -7119,6 +7121,55 @@ static int btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
 	return ret;
 }
 
+static int btf_populate_kfunc_acq_rel_pairs(struct btf *btf, enum btf_kfunc_hook hook,
+					    const struct btf_kfunc_id_set *kset)
+{
+	struct btf_kfunc_set_tab *tab;
+	struct btf_id_set *pairs;
+	u32 cnt;
+	int ret;
+
+	if (hook >= BTF_KFUNC_HOOK_MAX || (kset->acq_rel_pairs_cnt & 1)) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	tab = btf->kfunc_set_tab;
+	pairs = tab->acq_rel_pairs[hook];
+	/* Only one call allowed for modules */
+	if (WARN_ON_ONCE(pairs && btf_is_module(btf))) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	cnt = pairs ? pairs->cnt : 0;
+	if (cnt > U32_MAX - kset->acq_rel_pairs_cnt) {
+		ret = -EOVERFLOW;
+		goto end;
+	}
+
+	pairs = krealloc(tab->acq_rel_pairs[hook],
+			 offsetof(struct btf_id_set, ids[cnt + kset->acq_rel_pairs_cnt]),
+			 GFP_KERNEL | __GFP_NOWARN);
+	if (!pairs) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	if (!tab->acq_rel_pairs[hook])
+		pairs->cnt = 0;
+	tab->acq_rel_pairs[hook] = pairs;
+
+	memcpy(pairs->ids + pairs->cnt, kset->acq_rel_pairs,
+	       kset->acq_rel_pairs_cnt * sizeof(pairs->ids[0]));
+	pairs->cnt += kset->acq_rel_pairs_cnt;
+
+	return 0;
+end:
+	btf_free_kfunc_set_tab(btf);
+	return ret;
+}
+
 static bool __btf_kfunc_id_set_contains(const struct btf *btf,
 					enum btf_kfunc_hook hook,
 					enum btf_kfunc_type type,
@@ -7171,6 +7222,51 @@ bool btf_kfunc_id_set_contains(const struct btf *btf,
 	return __btf_kfunc_id_set_contains(btf, hook, type, kfunc_btf_id);
 }
 
+/* If no mapping exists, just rely on argument matching. Otherwise even if one
+ * mapping exists for acq_kfunc_btf_id, we fail on not finding a matching pair.
+ * Hence, an acquire kfunc either has 0 mappings, or N mappings. In case of 0
+ * mappings, only rely on the result of argument matches. In case of N mappings,
+ * always check for a mapping between the acquire and release function, and fail
+ * on not finding a match.
+ */
+int btf_kfunc_match_acq_rel_pair(const struct btf *btf,
+				 enum bpf_prog_type prog_type,
+				 u32 acq_kfunc_btf_id, u32 rel_kfunc_btf_id)
+{
+	struct btf_kfunc_set_tab *tab = btf->kfunc_set_tab;
+	enum btf_kfunc_hook hook;
+	struct btf_id_set *pairs;
+	bool was_seen = false;
+	u32 i;
+
+	if (!acq_kfunc_btf_id)
+		return 0;
+	hook = bpf_prog_type_to_kfunc_hook(prog_type);
+	if (hook >= BTF_KFUNC_HOOK_MAX)
+		return -EINVAL;
+	if (WARN_ON_ONCE(!tab))
+		return -EFAULT;
+	pairs = tab->acq_rel_pairs[hook];
+	if (!pairs)
+		return 0;
+	for (i = 0; i < pairs->cnt; i += 2) {
+		if (pairs->ids[i] == acq_kfunc_btf_id) {
+			was_seen = true;
+			if (pairs->ids[i + 1] == rel_kfunc_btf_id)
+				return 0;
+		}
+	}
+	/* There are some mappings for this acq_kfunc_btf_id, but none that
+	 * matched this pair.
+	 */
+	if (was_seen)
+		return -ENOENT;
+	/* There are no mappings for this acq_kfunc_btf_id, just rely on
+	 * argument matching.
+	 */
+	return 0;
+}
+
 /* This function must be invoked only from initcalls/module init functions */
 int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 			      const struct btf_kfunc_id_set *kset)
@@ -7196,6 +7292,7 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 
 	hook = bpf_prog_type_to_kfunc_hook(prog_type);
 	ret = btf_populate_kfunc_set(btf, hook, kset);
+	ret = ret ?: btf_populate_kfunc_acq_rel_pairs(btf, hook, kset);
 	btf_put(btf);
 	return ret;
 }
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8cc754d83521..cd8bf00a657f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7532,7 +7532,21 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	 * PTR_TO_BTF_ID back from btf_check_kfunc_arg_match, do the release now
 	 */
 	if (err) {
-		err = release_reference(env, regs[err].ref_obj_id);
+		int regno = err;
+
+		if (regs[regno].acq_kfunc_btf_id && desc_btf != regs[regno].btf) {
+			verbose(env, "verifier internal error: acquire and release kfunc BTF must match");
+			return -EFAULT;
+		}
+		err = btf_kfunc_match_acq_rel_pair(desc_btf, resolve_prog_type(env->prog),
+						   regs[regno].acq_kfunc_btf_id, func_id);
+		if (err) {
+			if (err == -ENOENT)
+				verbose(env, "kfunc %s#%d not permitted to release reference\n",
+					func_name, func_id);
+			return err;
+		}
+		err = release_reference(env, regs[regno].ref_obj_id);
 		if (err) {
 			verbose(env, "kfunc %s#%d reference has not been acquired before\n",
 				func_name, func_id);
@@ -7592,6 +7606,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 				return id;
 			regs[BPF_REG_0].id = id;
 			regs[BPF_REG_0].ref_obj_id = id;
+			regs[BPF_REG_0].acq_kfunc_btf_id = func_id;
 		}
 	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
 
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index fbf58eb74c79..5169405dd9d1 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -243,20 +243,31 @@ BTF_SET_END(nf_ct_release_kfunc_ids)
 /* Both sets are identical */
 #define nf_ct_ret_null_kfunc_ids nf_ct_acquire_kfunc_ids
 
+BTF_ID_LIST(nf_ct_acq_rel_pairs)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+
 static const struct btf_kfunc_id_set nf_conntrack_xdp_kfunc_set = {
-	.owner        = THIS_MODULE,
-	.check_set    = &nf_ct_xdp_check_kfunc_ids,
-	.acquire_set  = &nf_ct_acquire_kfunc_ids,
-	.release_set  = &nf_ct_release_kfunc_ids,
-	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
+	.owner             = THIS_MODULE,
+	.check_set         = &nf_ct_xdp_check_kfunc_ids,
+	.acquire_set       = &nf_ct_acquire_kfunc_ids,
+	.release_set       = &nf_ct_release_kfunc_ids,
+	.ret_null_set      = &nf_ct_ret_null_kfunc_ids,
+	.acq_rel_pairs     = nf_ct_acq_rel_pairs,
+	.acq_rel_pairs_cnt = 10,
 };
 
 static const struct btf_kfunc_id_set nf_conntrack_tc_kfunc_set = {
-	.owner        = THIS_MODULE,
-	.check_set    = &nf_ct_tc_check_kfunc_ids,
-	.acquire_set  = &nf_ct_acquire_kfunc_ids,
-	.release_set  = &nf_ct_release_kfunc_ids,
-	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
+	.owner             = THIS_MODULE,
+	.check_set         = &nf_ct_tc_check_kfunc_ids,
+	.acquire_set       = &nf_ct_acquire_kfunc_ids,
+	.release_set       = &nf_ct_release_kfunc_ids,
+	.ret_null_set      = &nf_ct_ret_null_kfunc_ids,
+	.acq_rel_pairs     = nf_ct_acq_rel_pairs,
+	.acq_rel_pairs_cnt = 10,
 };
 
 BTF_ID_LIST_SINGLE(nf_conn_btf_id, struct, nf_conn)
-- 
2.35.3

