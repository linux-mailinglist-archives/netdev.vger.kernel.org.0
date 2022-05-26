Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF7E5355A1
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349125AbiEZVfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiEZVfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:35:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7C6C5E6B;
        Thu, 26 May 2022 14:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7976461BA6;
        Thu, 26 May 2022 21:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D8C34119;
        Thu, 26 May 2022 21:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600938;
        bh=ASQjq4qhq/uc5gB1njKYLAspvIggQMeUtMIP6Vwh8P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jw5kIIzYv3iAlE0+EAWbrKz4J60OaXUWUIfEYKVcrUMSuHpZny3EtcNdALR8/NAcJ
         vhUUtReY+letbfyy5EfSZ+pNauVODPRWBHjCRHo0CFo1pcbeUHUVBvmbtfU2qlZha9
         EN/z1i6swe/STh+P83j6BihhS0+wtdsC0Tr9zTCy47cHq4I7XIexVOojjCLm83Gxh1
         /zb5vTSLqEt4NBwovTVOTiMFh3OQVYQl9dRV7ZDIawRuSF46E2kYhwkzFHfZU86YDz
         UkG1q0LArQ6fI/QTlABi6tQ/Iwko2Bn7wwlPtZmoub57M9G3fIoWD7U6ZFLBWezxri
         NiGmLlPphbkcg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 03/14] bpf: Support rdonly PTR_TO_BTF_ID for pointer to const return value
Date:   Thu, 26 May 2022 23:34:51 +0200
Message-Id: <b8d0b69e33a6280807e36ac92b116c61ec3fbcbd.1653600578.git.lorenzo@kernel.org>
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

Allow specifying MEM_RDONLY flag with PTR_TO_BTF_ID, which blocks write
access to object even for cases where it is permitted using a custom
btf_struct_access callback. This is currently set for return values from
kfunc where it points to const struct.

This is not to mean that helpers cannot modify such a 'pointer to const
struct', it's just that any write access that is usually permitted for
such pointers in a program won't be allowed for this instance.

For RET_PTR_TO_MEM_OR_BTF_ID, MEM_RDONLY was previously folded because
it didn't apply to PTR_TO_BTF_ID. Now, we check if variable is const
and mark the pointer to it as MEM_RDONLY.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/btf.h              | 29 ++++++++++++++++++++++++
 kernel/bpf/btf.c                 | 24 --------------------
 kernel/bpf/verifier.c            | 39 ++++++++++++++++++++++++--------
 net/bpf/test_run.c               | 15 ++++++++++--
 net/netfilter/nf_conntrack_bpf.c |  4 ++--
 5 files changed, 74 insertions(+), 37 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 2611cea2c2b6..f8dc5f810b40 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -234,6 +234,11 @@ static inline bool btf_type_is_typedef(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
 }
 
+static inline bool btf_type_is_const(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_CONST;
+}
+
 static inline bool btf_type_is_func(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC;
@@ -264,6 +269,30 @@ static inline bool btf_type_is_struct(const struct btf_type *t)
 	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
 }
 
+static inline bool btf_type_is_modifier(const struct btf_type *t)
+{
+	/* Some of them is not strictly a C modifier
+	 * but they are grouped into the same bucket
+	 * for BTF concern:
+	 *   A type (t) that refers to another
+	 *   type through t->type AND its size cannot
+	 *   be determined without following the t->type.
+	 *
+	 * ptr does not fall into this bucket
+	 * because its size is always sizeof(void *).
+	 */
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_TYPEDEF:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_CONST:
+	case BTF_KIND_RESTRICT:
+	case BTF_KIND_TYPE_TAG:
+		return true;
+	}
+
+	return false;
+}
+
 static inline u16 btf_type_vlen(const struct btf_type *t)
 {
 	return BTF_INFO_VLEN(t->info);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9f8dec0ab924..bcdfb8ef0481 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -431,30 +431,6 @@ static int btf_resolve(struct btf_verifier_env *env,
 static int btf_func_check(struct btf_verifier_env *env,
 			  const struct btf_type *t);
 
-static bool btf_type_is_modifier(const struct btf_type *t)
-{
-	/* Some of them is not strictly a C modifier
-	 * but they are grouped into the same bucket
-	 * for BTF concern:
-	 *   A type (t) that refers to another
-	 *   type through t->type AND its size cannot
-	 *   be determined without following the t->type.
-	 *
-	 * ptr does not fall into this bucket
-	 * because its size is always sizeof(void *).
-	 */
-	switch (BTF_INFO_KIND(t->info)) {
-	case BTF_KIND_TYPEDEF:
-	case BTF_KIND_VOLATILE:
-	case BTF_KIND_CONST:
-	case BTF_KIND_RESTRICT:
-	case BTF_KIND_TYPE_TAG:
-		return true;
-	}
-
-	return false;
-}
-
 bool btf_type_is_void(const struct btf_type *t)
 {
 	return t == &btf_void;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e0be76861736..27db2ef8a006 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4507,6 +4507,11 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	}
 
 	if (env->ops->btf_struct_access) {
+		if (atype != BPF_READ && reg->type & MEM_RDONLY) {
+			verbose(env, "pointer points to const object, only read is supported\n");
+			return -EACCES;
+		}
+
 		ret = env->ops->btf_struct_access(&env->log, reg->btf, t,
 						  off, size, atype, &btf_id, &flag);
 	} else {
@@ -7316,9 +7321,15 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		regs[BPF_REG_0].mem_size = meta.mem_size;
 	} else if (base_type(ret_type) == RET_PTR_TO_MEM_OR_BTF_ID) {
 		const struct btf_type *t;
+		bool is_const = false;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		t = btf_type_skip_modifiers(meta.ret_btf, meta.ret_btf_id, NULL);
+		t = btf_type_by_id(meta.ret_btf, meta.ret_btf_id);
+		while (btf_type_is_modifier(t)) {
+			if (btf_type_is_const(t))
+				is_const = true;
+			t = btf_type_by_id(meta.ret_btf, t->type);
+		}
 		if (!btf_type_is_struct(t)) {
 			u32 tsize;
 			const struct btf_type *ret;
@@ -7335,12 +7346,12 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
 			regs[BPF_REG_0].mem_size = tsize;
 		} else {
-			/* MEM_RDONLY may be carried from ret_flag, but it
-			 * doesn't apply on PTR_TO_BTF_ID. Fold it, otherwise
-			 * it will confuse the check of PTR_TO_BTF_ID in
-			 * check_mem_access().
+			/* MEM_RDONLY is carried from ret_flag. Fold it if the
+			 * variable whose pointer is being returned is not
+			 * const.
 			 */
-			ret_flag &= ~MEM_RDONLY;
+			if (!is_const)
+				ret_flag &= ~MEM_RDONLY;
 
 			regs[BPF_REG_0].type = PTR_TO_BTF_ID | ret_flag;
 			regs[BPF_REG_0].btf = meta.ret_btf;
@@ -7535,8 +7546,17 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		mark_reg_unknown(env, regs, BPF_REG_0);
 		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
 	} else if (btf_type_is_ptr(t)) {
-		ptr_type = btf_type_skip_modifiers(desc_btf, t->type,
-						   &ptr_type_id);
+		bool is_const = false;
+
+		ptr_type_id = t->type;
+		ptr_type = btf_type_by_id(desc_btf, ptr_type_id);
+		while (btf_type_is_modifier(ptr_type)) {
+			if (btf_type_is_const(ptr_type))
+				is_const = true;
+			ptr_type_id = ptr_type->type;
+			ptr_type = btf_type_by_id(desc_btf, ptr_type_id);
+		}
+
 		if (!btf_type_is_struct(ptr_type)) {
 			ptr_type_name = btf_name_by_offset(desc_btf,
 							   ptr_type->name_off);
@@ -7547,7 +7567,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		}
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].btf = desc_btf;
-		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
+		regs[BPF_REG_0].type = PTR_TO_BTF_ID | (is_const ? MEM_RDONLY : 0);
 		regs[BPF_REG_0].btf_id = ptr_type_id;
 		if (btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
 					      BTF_KFUNC_TYPE_RET_NULL, func_id)) {
@@ -13374,6 +13394,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			break;
 		case PTR_TO_BTF_ID:
 		case PTR_TO_BTF_ID | PTR_UNTRUSTED:
+		case PTR_TO_BTF_ID | MEM_RDONLY:
 			if (type == BPF_READ) {
 				insn->code = BPF_LDX | BPF_PROBE_MEM |
 					BPF_SIZE((insn)->code);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 4b796e0a9667..2f381cb4acfa 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -582,6 +582,12 @@ bpf_kfunc_call_test_acquire(unsigned long *scalar_ptr)
 	return &prog_test_struct;
 }
 
+noinline const struct prog_test_ref_kfunc *
+bpf_kfunc_call_test_acquire_const(void)
+{
+	return bpf_kfunc_call_test_acquire(NULL);
+}
+
 noinline struct prog_test_member *
 bpf_kfunc_call_memb_acquire(void)
 {
@@ -589,12 +595,14 @@ bpf_kfunc_call_memb_acquire(void)
 	return NULL;
 }
 
-noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
+noinline void bpf_kfunc_call_test_release(const struct prog_test_ref_kfunc *p)
 {
+	struct prog_test_ref_kfunc *pp = (void *)p;
+
 	if (!p)
 		return;
 
-	refcount_dec(&p->cnt);
+	refcount_dec(&pp->cnt);
 }
 
 noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
@@ -704,6 +712,7 @@ BTF_ID(func, bpf_kfunc_call_test1)
 BTF_ID(func, bpf_kfunc_call_test2)
 BTF_ID(func, bpf_kfunc_call_test3)
 BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_acquire_const)
 BTF_ID(func, bpf_kfunc_call_memb_acquire)
 BTF_ID(func, bpf_kfunc_call_test_release)
 BTF_ID(func, bpf_kfunc_call_memb_release)
@@ -723,6 +732,7 @@ BTF_SET_END(test_sk_check_kfunc_ids)
 
 BTF_SET_START(test_sk_acquire_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_acquire_const)
 BTF_ID(func, bpf_kfunc_call_memb_acquire)
 BTF_ID(func, bpf_kfunc_call_test_kptr_get)
 BTF_SET_END(test_sk_acquire_kfunc_ids)
@@ -735,6 +745,7 @@ BTF_SET_END(test_sk_release_kfunc_ids)
 
 BTF_SET_START(test_sk_ret_null_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_acquire_const)
 BTF_ID(func, bpf_kfunc_call_memb_acquire)
 BTF_ID(func, bpf_kfunc_call_test_kptr_get)
 BTF_SET_END(test_sk_ret_null_kfunc_ids)
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index bc4d5cd63a94..85f142739a21 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -130,7 +130,7 @@ __diag_ignore_all("-Wmissing-prototypes",
  * @opts__sz	- Length of the bpf_ct_opts structure
  *		    Must be NF_BPF_CT_OPTS_SZ (12)
  */
-struct nf_conn *
+const struct nf_conn *
 bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 		  u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
 {
@@ -173,7 +173,7 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
  * @opts__sz	- Length of the bpf_ct_opts structure
  *		    Must be NF_BPF_CT_OPTS_SZ (12)
  */
-struct nf_conn *
+const struct nf_conn *
 bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 		  u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
 {
-- 
2.35.3

