Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A298A6A7037
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCAPvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCAPu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:50:56 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79CD457D1;
        Wed,  1 Mar 2023 07:50:55 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p6so8011141pga.0;
        Wed, 01 Mar 2023 07:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677685855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faJ7mc6oUHrWjyXNkw+7M0lLdt4KdopPLj9GK5dJLQ4=;
        b=VfjpdNYz2/0AH/9CFXXWjWYMVdBwCRZsaEyuZRrzhgxq/MSjeB5duIj4SK4NFeDyO4
         ALCfQKrxu2H4YBzn0TQXYKgMsCcItFGHUmB+KDPwjWSYTiGZbX2rdGAUP4jxdDGPo+dc
         OFaq2z/CoLgEVFfYcDDQPSO+DvSuDfYQvZoi/NTI3rgIj3Pn1iYt0zRYegO/u+WXTwp4
         pn90VsDIDS2fe4O02zE9mB4lOrfFzwSZIsYPXVwMbTPOHUjarY6waIvvA06AHliSdvst
         jx/VQ/K7y21EqAUcONabnbYKVBPJrT7uzyTVFblj3DKyBhC2kBG+J7hthBGCV1rH5NIV
         FIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677685855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=faJ7mc6oUHrWjyXNkw+7M0lLdt4KdopPLj9GK5dJLQ4=;
        b=aQ6DPQA1ItncIn/qfEeIs0mV3pwBk7uwOALqB3wYsyZwD7KklDdiLxFMxI/tyA/Ibf
         pYC0ZvxBnfLHcHf+yn3gysLXuQlrVBhSThybaIf2YYOB+q3eh8YPAWq27jh9HsjPao/L
         qL17JS7ogrspqjVC/NQdVT1DVci632ZOSEREk6fHKI1vQDcaeLbWLGJ8VdpnBYs4cK2W
         zSNX2TXomvOylOxNX0rEAVXI09SfdVfKsj3qbWm1HH4uzHGlc7iPqeTpg+N7tJP91iRB
         H/ZZlx82uyvn6sBBmlbD9mxIIe1AUrITxUp5D45hast5m5ZUNpMik4yCbcNPhZpP5YsQ
         mscg==
X-Gm-Message-State: AO0yUKWu0TzM6+FLY0O0zpWfUKl/t8flx44n2BVBQoV4Bsdl/wPRV9yA
        LR+fB6Cr2bRTAnO9wQ293QUZ0HAtpCg=
X-Google-Smtp-Source: AK7set/vh1mKlCXvIhK+lToen1hsDwejDVcoe1pEmedRIU7g1WSeQX6s91lM2cMPEln9a8hJ6e8oJw==
X-Received: by 2002:a62:6586:0:b0:5a8:5e6d:28d7 with SMTP id z128-20020a626586000000b005a85e6d28d7mr6867420pfb.0.1677685854774;
        Wed, 01 Mar 2023 07:50:54 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm7589490pgn.70.2023.03.01.07.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 07:50:54 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v13 bpf-next 02/10] bpf: Refactor process_dynptr_func
Date:   Wed,  1 Mar 2023 07:49:45 -0800
Message-Id: <20230301154953.641654-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
MIME-Version: 1.0
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

This change cleans up process_dynptr_func's flow to be more intuitive
and updates some comments with more context.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf_verifier.h |  3 --
 kernel/bpf/verifier.c        | 62 ++++++++++++++++++------------------
 2 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index cf1bb1cf4a7b..b26ff2a8f63b 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -616,9 +616,6 @@ int check_func_arg_reg_off(struct bpf_verifier_env *env,
 			   enum bpf_arg_type arg_type);
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size);
-struct bpf_call_arg_meta;
-int process_dynptr_func(struct bpf_verifier_env *env, int regno,
-			enum bpf_arg_type arg_type, struct bpf_call_arg_meta *meta);
 
 /* this lives here instead of in bpf.h because it needs to dereference tgt_prog */
 static inline u64 bpf_trampoline_compute_key(const struct bpf_prog *tgt_prog,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5cb8b623f639..e0e00509846b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -959,39 +959,49 @@ static int destroy_if_dynptr_stack_slot(struct bpf_verifier_env *env,
 	return 0;
 }
 
-static bool is_dynptr_reg_valid_uninit(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
-				       int spi)
+static bool is_dynptr_reg_valid_uninit(struct bpf_verifier_env *env, struct bpf_reg_state *reg)
 {
+	int spi;
+
 	if (reg->type == CONST_PTR_TO_DYNPTR)
 		return false;
 
-	/* For -ERANGE (i.e. spi not falling into allocated stack slots), we
-	 * will do check_mem_access to check and update stack bounds later, so
-	 * return true for that case.
+	spi = dynptr_get_spi(env, reg);
+
+	/* -ERANGE (i.e. spi not falling into allocated stack slots) isn't an
+	 * error because this just means the stack state hasn't been updated yet.
+	 * We will do check_mem_access to check and update stack bounds later.
 	 */
-	if (spi < 0)
-		return spi == -ERANGE;
-	/* We allow overwriting existing unreferenced STACK_DYNPTR slots, see
-	 * mark_stack_slots_dynptr which calls destroy_if_dynptr_stack_slot to
-	 * ensure dynptr objects at the slots we are touching are completely
-	 * destructed before we reinitialize them for a new one. For referenced
-	 * ones, destroy_if_dynptr_stack_slot returns an error early instead of
-	 * delaying it until the end where the user will get "Unreleased
+	if (spi < 0 && spi != -ERANGE)
+		return false;
+
+	/* We don't need to check if the stack slots are marked by previous
+	 * dynptr initializations because we allow overwriting existing unreferenced
+	 * STACK_DYNPTR slots, see mark_stack_slots_dynptr which calls
+	 * destroy_if_dynptr_stack_slot to ensure dynptr objects at the slots we are
+	 * touching are completely destructed before we reinitialize them for a new
+	 * one. For referenced ones, destroy_if_dynptr_stack_slot returns an error early
+	 * instead of delaying it until the end where the user will get "Unreleased
 	 * reference" error.
 	 */
 	return true;
 }
 
-static bool is_dynptr_reg_valid_init(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
-				     int spi)
+static bool is_dynptr_reg_valid_init(struct bpf_verifier_env *env, struct bpf_reg_state *reg)
 {
 	struct bpf_func_state *state = func(env, reg);
-	int i;
+	int i, spi;
 
-	/* This already represents first slot of initialized bpf_dynptr */
+	/* This already represents first slot of initialized bpf_dynptr.
+	 *
+	 * CONST_PTR_TO_DYNPTR already has fixed and var_off as 0 due to
+	 * check_func_arg_reg_off's logic, so we don't need to check its
+	 * offset and alignment.
+	 */
 	if (reg->type == CONST_PTR_TO_DYNPTR)
 		return true;
 
+	spi = dynptr_get_spi(env, reg);
 	if (spi < 0)
 		return false;
 	if (!state->stack[spi].spilled_ptr.dynptr.first_slot)
@@ -6215,11 +6225,10 @@ static int process_kptr_func(struct bpf_verifier_env *env, int regno,
  * Helpers which do not mutate the bpf_dynptr set MEM_RDONLY in their argument
  * type, and declare it as 'const struct bpf_dynptr *' in their prototype.
  */
-int process_dynptr_func(struct bpf_verifier_env *env, int regno,
-			enum bpf_arg_type arg_type, struct bpf_call_arg_meta *meta)
+static int process_dynptr_func(struct bpf_verifier_env *env, int regno,
+			       enum bpf_arg_type arg_type, struct bpf_call_arg_meta *meta)
 {
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
-	int spi = 0;
 
 	/* MEM_UNINIT and MEM_RDONLY are exclusive, when applied to an
 	 * ARG_PTR_TO_DYNPTR (or ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_*):
@@ -6228,15 +6237,6 @@ int process_dynptr_func(struct bpf_verifier_env *env, int regno,
 		verbose(env, "verifier internal error: misconfigured dynptr helper type flags\n");
 		return -EFAULT;
 	}
-	/* CONST_PTR_TO_DYNPTR already has fixed and var_off as 0 due to
-	 * check_func_arg_reg_off's logic. We only need to check offset
-	 * and its alignment for PTR_TO_STACK.
-	 */
-	if (reg->type == PTR_TO_STACK) {
-		spi = dynptr_get_spi(env, reg);
-		if (spi < 0 && spi != -ERANGE)
-			return spi;
-	}
 
 	/*  MEM_UNINIT - Points to memory that is an appropriate candidate for
 	 *		 constructing a mutable bpf_dynptr object.
@@ -6254,7 +6254,7 @@ int process_dynptr_func(struct bpf_verifier_env *env, int regno,
 	 *		 to.
 	 */
 	if (arg_type & MEM_UNINIT) {
-		if (!is_dynptr_reg_valid_uninit(env, reg, spi)) {
+		if (!is_dynptr_reg_valid_uninit(env, reg)) {
 			verbose(env, "Dynptr has to be an uninitialized dynptr\n");
 			return -EINVAL;
 		}
@@ -6277,7 +6277,7 @@ int process_dynptr_func(struct bpf_verifier_env *env, int regno,
 			return -EINVAL;
 		}
 
-		if (!is_dynptr_reg_valid_init(env, reg, spi)) {
+		if (!is_dynptr_reg_valid_init(env, reg)) {
 			verbose(env,
 				"Expected an initialized dynptr as arg #%d\n",
 				regno);
-- 
2.34.1

