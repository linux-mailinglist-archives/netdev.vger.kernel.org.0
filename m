Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F2C535599
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbiEZVf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349146AbiEZVfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:35:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3613E732D;
        Thu, 26 May 2022 14:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E70A0B82208;
        Thu, 26 May 2022 21:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A33DC34116;
        Thu, 26 May 2022 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600942;
        bh=NSLGp1ZxKdaAmViK9dyj47U8pQr9uUnIw1bRYSLQZTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPPqUAH9CVU4Glr0JjL3+gPwMIOnjViRHx0fcm/MfyqOjalWKMagAtx4rYCORcyo4
         qMLgEuI7zXsemKgWwm40LaIrOLRZVTo4ZPntgHe/HtWDNmXp392R/My4und5Vk8dZq
         d/gg34ICy9exaLTeVb3LiAI8bWkjYWHlSGj1++mWsD6dYx0cGpSoTcX7nD/GQUoVjr
         IOQuh4EgXBx0feA68sH5J8ieBDlMnfKaWU5IDRZsLR4k7jVUIBOIimDwd1UC7ibzNf
         /+Vrhq/g4SSYHKxCLV7xl753V2r5z0L4g4a9N5rysOLYYYbbv8kteRspoRVITZDRBl
         5d5J6GqisfBMA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 04/14] bpf: Support storing rdonly PTR_TO_BTF_ID in BPF maps
Date:   Thu, 26 May 2022 23:34:52 +0200
Message-Id: <5dd1dc450b52966f2cdde33e70fd098249a37e58.1653600578.git.lorenzo@kernel.org>
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

User needs to declare kptr as pointer to const struct in map to be able
to permit store of a read only PTR_TO_BTF_ID, be it trusted or
untrusted. It is ofcourse allowed to also store normal PTR_TO_BTF_ID to
such fields, but the next load will mark the register as read only
PTR_TO_BTF_ID.

bpf_kptr_xchg now accepts read only PTR_TO_BTF_ID in addition to normal
ones, and changes its second parameter type from void * to const void *
so that when it is a prototype in BPF C, users can pass const declared
pointers into it.

On load, the destination registers now gains MEM_RDONLY in addition to
flags that were set previously. This why kptr needs to point to const
struct, since we need to carry the MEM_RDONLY flag in the prog to map
to prog chain.

In addition to this, loads for members now also set MEM_RDONLY when it
is for pointer to const struct.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/bpf.h            |  5 +++++
 include/uapi/linux/bpf.h       |  2 +-
 kernel/bpf/btf.c               | 21 +++++++++++++++++++--
 kernel/bpf/helpers.c           |  4 ++--
 kernel/bpf/verifier.c          | 32 +++++++++++++++++++++-----------
 tools/include/uapi/linux/bpf.h |  2 +-
 6 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2b914a56a2c5..49e3e7f4b0f9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -169,6 +169,10 @@ enum bpf_kptr_type {
 	BPF_KPTR_REF,
 };
 
+enum bpf_kptr_flags {
+	BPF_KPTR_F_RDONLY = (1 << 0),
+};
+
 struct bpf_map_value_off_desc {
 	u32 offset;
 	enum bpf_kptr_type type;
@@ -177,6 +181,7 @@ struct bpf_map_value_off_desc {
 		struct module *module;
 		btf_dtor_kfunc_t dtor;
 		u32 btf_id;
+		int flags;
 	} kptr;
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f4009dbdf62d..cd76ca331f52 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5154,7 +5154,7 @@ union bpf_attr {
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
  *
- * void *bpf_kptr_xchg(void *map_value, void *ptr)
+ * void *bpf_kptr_xchg(void *map_value, const void *ptr)
  *	Description
  *		Exchange kptr at pointer *map_value* with *ptr*, and return the
  *		old value. *ptr* can be NULL, otherwise it must be a referenced
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index bcdfb8ef0481..58de6d1204ee 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3174,6 +3174,7 @@ struct btf_field_info {
 	u32 type_id;
 	u32 off;
 	enum bpf_kptr_type type;
+	int flags;
 };
 
 static int btf_find_struct(const struct btf *btf, const struct btf_type *t,
@@ -3191,6 +3192,7 @@ static int btf_find_kptr(const struct btf *btf, const struct btf_type *t,
 			 u32 off, int sz, struct btf_field_info *info)
 {
 	enum bpf_kptr_type type;
+	bool is_const = false;
 	u32 res_id;
 
 	/* For PTR, sz is always == 8 */
@@ -3211,7 +3213,13 @@ static int btf_find_kptr(const struct btf *btf, const struct btf_type *t,
 		return -EINVAL;
 
 	/* Get the base type */
-	t = btf_type_skip_modifiers(btf, t->type, &res_id);
+	do {
+		res_id = t->type;
+		t = btf_type_by_id(btf, res_id);
+		if (btf_type_is_const(t))
+			is_const = true;
+	} while (btf_type_is_modifier(t));
+
 	/* Only pointer to struct is allowed */
 	if (!__btf_type_is_struct(t))
 		return -EINVAL;
@@ -3219,6 +3227,7 @@ static int btf_find_kptr(const struct btf *btf, const struct btf_type *t,
 	info->type_id = res_id;
 	info->off = off;
 	info->type = type;
+	info->flags = is_const ? BPF_KPTR_F_RDONLY : 0;
 	return BTF_FIELD_FOUND;
 }
 
@@ -3473,6 +3482,7 @@ struct bpf_map_value_off *btf_parse_kptrs(const struct btf *btf,
 		tab->off[i].kptr.btf_id = id;
 		tab->off[i].kptr.btf = kernel_btf;
 		tab->off[i].kptr.module = mod;
+		tab->off[i].kptr.flags = info_arr[i].flags;
 	}
 	tab->nr_off = nr_off;
 	return tab;
@@ -5597,7 +5607,14 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 					tmp_flag = MEM_PERCPU;
 			}
 
-			stype = btf_type_skip_modifiers(btf, mtype->type, &id);
+			stype = mtype;
+			do {
+				id = stype->type;
+				stype = btf_type_by_id(btf, id);
+				if (btf_type_is_const(stype))
+					tmp_flag |= MEM_RDONLY;
+			} while (btf_type_is_modifier(stype));
+
 			if (btf_type_is_struct(stype)) {
 				*next_btf_id = id;
 				*flag = tmp_flag;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 225806a02efb..1aaeb6b330af 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1390,7 +1390,7 @@ void bpf_timer_cancel_and_free(void *val)
 	kfree(t);
 }
 
-BPF_CALL_2(bpf_kptr_xchg, void *, map_value, void *, ptr)
+BPF_CALL_2(bpf_kptr_xchg, void *, map_value, const void *, ptr)
 {
 	unsigned long *kptr = map_value;
 
@@ -1408,7 +1408,7 @@ const struct bpf_func_proto bpf_kptr_xchg_proto = {
 	.ret_type     = RET_PTR_TO_BTF_ID_OR_NULL,
 	.ret_btf_id   = BPF_PTR_POISON,
 	.arg1_type    = ARG_PTR_TO_KPTR,
-	.arg2_type    = ARG_PTR_TO_BTF_ID_OR_NULL | OBJ_RELEASE,
+	.arg2_type    = ARG_PTR_TO_BTF_ID_OR_NULL | MEM_RDONLY | OBJ_RELEASE,
 	.arg2_btf_id  = BPF_PTR_POISON,
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 27db2ef8a006..9b8962e6bc14 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3658,6 +3658,8 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	/* Only unreferenced case accepts untrusted pointers */
 	if (off_desc->type == BPF_KPTR_UNREF)
 		perm_flags |= PTR_UNTRUSTED;
+	if (off_desc->kptr.flags & BPF_KPTR_F_RDONLY)
+		perm_flags |= MEM_RDONLY;
 
 	if (base_type(reg->type) != PTR_TO_BTF_ID || (type_flag(reg->type) & ~perm_flags))
 		goto bad_type;
@@ -3756,6 +3758,8 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 				off_desc->kptr.btf_id, PTR_MAYBE_NULL | PTR_UNTRUSTED);
 		/* For mark_ptr_or_null_reg */
 		val_reg->id = ++env->id_gen;
+		if (off_desc->kptr.flags & BPF_KPTR_F_RDONLY)
+			val_reg->type |= MEM_RDONLY;
 	} else if (class == BPF_STX) {
 		val_reg = reg_state(env, value_regno);
 		if (!register_is_null(val_reg) &&
@@ -5732,20 +5736,13 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 	for (i = 0; i < ARRAY_SIZE(compatible->types); i++) {
 		expected = compatible->types[i];
 		if (expected == NOT_INIT)
-			break;
+			goto error;
 
 		if (type == expected)
-			goto found;
+			break;
 	}
 
-	verbose(env, "R%d type=%s expected=", regno, reg_type_str(env, reg->type));
-	for (j = 0; j + 1 < i; j++)
-		verbose(env, "%s, ", reg_type_str(env, compatible->types[j]));
-	verbose(env, "%s\n", reg_type_str(env, compatible->types[j]));
-	return -EACCES;
-
-found:
-	if (reg->type == PTR_TO_BTF_ID) {
+	if (base_type(reg->type) == PTR_TO_BTF_ID) {
 		/* For bpf_sk_release, it needs to match against first member
 		 * 'struct sock_common', hence make an exception for it. This
 		 * allows bpf_sk_release to work for multiple socket types.
@@ -5753,6 +5750,10 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 		bool strict_type_match = arg_type_is_release(arg_type) &&
 					 meta->func_id != BPF_FUNC_sk_release;
 
+		if (type_flag(reg->type) & MEM_PERCPU)
+			goto done;
+		if (type_flag(reg->type) & ~(PTR_MAYBE_NULL | MEM_RDONLY))
+			goto error;
 		if (!arg_btf_id) {
 			if (!compatible->btf_id) {
 				verbose(env, "verifier internal error: missing arg compatible BTF ID\n");
@@ -5773,8 +5774,14 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 			return -EACCES;
 		}
 	}
-
+done:
 	return 0;
+error:
+	verbose(env, "R%d type=%s expected=", regno, reg_type_str(env, reg->type));
+	for (j = 0; j + 1 < i; j++)
+		verbose(env, "%s, ", reg_type_str(env, compatible->types[j]));
+	verbose(env, "%s\n", reg_type_str(env, compatible->types[j]));
+	return -EACCES;
 }
 
 int check_func_arg_reg_off(struct bpf_verifier_env *env,
@@ -7364,6 +7371,8 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_BTF_ID | ret_flag;
 		if (func_id == BPF_FUNC_kptr_xchg) {
+			if (meta.kptr_off_desc->kptr.flags & BPF_KPTR_F_RDONLY)
+				regs[BPF_REG_0].type |= MEM_RDONLY;
 			ret_btf = meta.kptr_off_desc->kptr.btf;
 			ret_btf_id = meta.kptr_off_desc->kptr.btf_id;
 		} else {
@@ -13395,6 +13404,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		case PTR_TO_BTF_ID:
 		case PTR_TO_BTF_ID | PTR_UNTRUSTED:
 		case PTR_TO_BTF_ID | MEM_RDONLY:
+		case PTR_TO_BTF_ID | PTR_UNTRUSTED | MEM_RDONLY:
 			if (type == BPF_READ) {
 				insn->code = BPF_LDX | BPF_PROBE_MEM |
 					BPF_SIZE((insn)->code);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f4009dbdf62d..cd76ca331f52 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5154,7 +5154,7 @@ union bpf_attr {
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
  *
- * void *bpf_kptr_xchg(void *map_value, void *ptr)
+ * void *bpf_kptr_xchg(void *map_value, const void *ptr)
  *	Description
  *		Exchange kptr at pointer *map_value* with *ptr*, and return the
  *		old value. *ptr* can be NULL, otherwise it must be a referenced
-- 
2.35.3

