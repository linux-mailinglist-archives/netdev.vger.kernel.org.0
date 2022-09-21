Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99655C04BB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbiIUQxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiIUQwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:52:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975F710549;
        Wed, 21 Sep 2022 09:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 090D8B831B5;
        Wed, 21 Sep 2022 16:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A2BC433C1;
        Wed, 21 Sep 2022 16:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663778943;
        bh=DcauXafPF+0XLIfc/8CHnuSwDSldDe6Qu+jpy3kh/bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDCNq25ek4w4P7KEizFKuTX9KRWpS3nQ7FL03c1xZw9JVK68m3J3tB2mNHffGCoEq
         +JPYuqAUdICqvOWpaqUD0h7tyjwbrnu3XoNBz0e4QlzF0BzuQS8DchLW+WTSF7lDts
         ERU7TF2AzKrCIaJFUXMbVFayjWoY1F0QGekt24MNxIlXAktOkiiLrV6ulOcLwqh0IW
         ML2i+zDdzaQodYeKGnw7DMsLhkUSbyXsLOXYDtIFaNcSkvLbg4MakheLFZBHx5HB/K
         LltmLD7VrSBqxJD5nDccVCIEv/DaMx6zBULY+YPrpkt3SDRF1LvW14USqnEZ5vGFuq
         Barvo5bsMescQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 1/3] bpf: Tweak definition of KF_TRUSTED_ARGS
Date:   Wed, 21 Sep 2022 18:48:25 +0200
Message-Id: <cdede0043c47ed7a357f0a915d16f9ce06a1d589.1663778601.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663778601.git.lorenzo@kernel.org>
References: <cover.1663778601.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Instead of forcing all arguments to be referenced pointers with non-zero
reg->ref_obj_id, tweak the definition of KF_TRUSTED_ARGS to mean that
only PTR_TO_BTF_ID (and socket types translated to PTR_TO_BTF_ID) have
that constraint, and require their offset to be set to 0.

The rest of pointer types are also accomodated in this definition of
trusted pointers, but with more relaxed rules regarding offsets.

The inherent meaning of setting this flag is that all kfunc pointer
arguments have a guranteed lifetime, and kernel object pointers
(PTR_TO_BTF_ID, PTR_TO_CTX) are passed in their unmodified form (with
offset 0). In general, this is not true for PTR_TO_BTF_ID as it can be
obtained using pointer walks.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 Documentation/bpf/kfuncs.rst | 24 ++++++++++++++++--------
 kernel/bpf/btf.c             | 18 +++++++++++++-----
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 781731749e55..0f858156371d 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -137,14 +137,22 @@ KF_ACQUIRE and KF_RET_NULL flags.
 --------------------------
 
 The KF_TRUSTED_ARGS flag is used for kfuncs taking pointer arguments. It
-indicates that the all pointer arguments will always be refcounted, and have
-their offset set to 0. It can be used to enforce that a pointer to a refcounted
-object acquired from a kfunc or BPF helper is passed as an argument to this
-kfunc without any modifications (e.g. pointer arithmetic) such that it is
-trusted and points to the original object. This flag is often used for kfuncs
-that operate (change some property, perform some operation) on an object that
-was obtained using an acquire kfunc. Such kfuncs need an unchanged pointer to
-ensure the integrity of the operation being performed on the expected object.
+indicates that the all pointer arguments will always have a guaranteed lifetime,
+and pointers to kernel objects are always passed to helpers in their unmodified
+form (as obtained from acquire kfuncs).
+
+It can be used to enforce that a pointer to a refcounted object acquired from a
+kfunc or BPF helper is passed as an argument to this kfunc without any
+modifications (e.g. pointer arithmetic) such that it is trusted and points to
+the original object.
+
+Meanwhile, it is also allowed pass pointers to normal memory to such kfuncs,
+but those can have a non-zero offset.
+
+This flag is often used for kfuncs that operate (change some property, perform
+some operation) on an object that was obtained using an acquire kfunc. Such
+kfuncs need an unchanged pointer to ensure the integrity of the operation being
+performed on the expected object.
 
 2.4.6 KF_SLEEPABLE flag
 -----------------------
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b3940c605aac..db745cd3018e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6232,7 +6232,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    bool processing_call)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
-	bool rel = false, kptr_get = false, trusted_arg = false;
+	bool rel = false, kptr_get = false, trusted_args = false;
 	bool sleepable = false;
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
@@ -6270,7 +6270,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		/* Only kfunc can be release func */
 		rel = kfunc_meta->flags & KF_RELEASE;
 		kptr_get = kfunc_meta->flags & KF_KPTR_GET;
-		trusted_arg = kfunc_meta->flags & KF_TRUSTED_ARGS;
+		trusted_args = kfunc_meta->flags & KF_TRUSTED_ARGS;
 		sleepable = kfunc_meta->flags & KF_SLEEPABLE;
 	}
 
@@ -6281,6 +6281,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		enum bpf_arg_type arg_type = ARG_DONTCARE;
 		u32 regno = i + 1;
 		struct bpf_reg_state *reg = &regs[regno];
+		bool obj_ptr = false;
 
 		t = btf_type_skip_modifiers(btf, args[i].type, NULL);
 		if (btf_type_is_scalar(t)) {
@@ -6328,10 +6329,17 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			return -EINVAL;
 		}
 
+		/* These register types have special constraints wrt ref_obj_id
+		 * and offset checks. The rest of trusted args don't.
+		 */
+		obj_ptr = reg->type == PTR_TO_CTX || reg->type == PTR_TO_BTF_ID ||
+			  reg2btf_ids[base_type(reg->type)];
+
 		/* Check if argument must be a referenced pointer, args + i has
 		 * been verified to be a pointer (after skipping modifiers).
+		 * PTR_TO_CTX is ok without having non-zero ref_obj_id.
 		 */
-		if (is_kfunc && trusted_arg && !reg->ref_obj_id) {
+		if (is_kfunc && trusted_args && (obj_ptr && reg->type != PTR_TO_CTX) && !reg->ref_obj_id) {
 			bpf_log(log, "R%d must be referenced\n", regno);
 			return -EINVAL;
 		}
@@ -6340,7 +6348,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
 
 		/* Trusted args have the same offset checks as release arguments */
-		if (trusted_arg || (rel && reg->ref_obj_id))
+		if ((trusted_args && obj_ptr) || (rel && reg->ref_obj_id))
 			arg_type |= OBJ_RELEASE;
 		ret = check_func_arg_reg_off(env, reg, regno, arg_type);
 		if (ret < 0)
@@ -6440,7 +6448,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 							   reg_ref_t->name_off);
 			if (!btf_struct_ids_match(log, reg_btf, reg_ref_id,
 						  reg->off, btf, ref_id,
-						  trusted_arg || (rel && reg->ref_obj_id))) {
+						  trusted_args || (rel && reg->ref_obj_id))) {
 				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s but R%d has a pointer to %s %s\n",
 					func_name, i,
 					btf_type_str(ref_t), ref_tname,
-- 
2.37.3

