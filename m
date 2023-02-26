Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A026A2EDF
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 09:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBZIwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 03:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBZIwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 03:52:00 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DAC11655;
        Sun, 26 Feb 2023 00:51:58 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id x34so3232715pjj.0;
        Sun, 26 Feb 2023 00:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FiOQD6venFBWNf0Z4AQ/wrw3IlSiEPKwiV4MlNJJ/3s=;
        b=i3BptMSN8Twhn2K1balN381KlVwpMcAbO3KRarvcS8/Tu/lNqcPpQG8Q9wBVWXgP3Q
         hgKXw5Zpne4xc54WcMzId9W+QZ0dRP8G5I9I9YhcJuIhT8aaeBtJU0SkBs7Y3eVjtdxy
         LDmMU3hcdzWCKejgPafwHwVj0QrJT+sVAKFmJHRTSCNz/d7ryFBoFA0+Dn2V+gstEt28
         V7SMu5URgKubGhN+34spJoo6Mt6gyifklzSuFWayowLPcNw3XQ0lE/jar6sqR7pXJ8b5
         11fn4D/nMUqW70ziVKdoDah2knIYb9JL6GxdP/VorQO4DSzcQOmqMKZhm+9Ffyk9Gjxj
         PlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FiOQD6venFBWNf0Z4AQ/wrw3IlSiEPKwiV4MlNJJ/3s=;
        b=h+Qb5hpzV8zweFPsDTwmdex+w1ZkbAmEb44rY77B0VN72c8SBh7p1tdbhQeIbChECR
         TPXnEEVG4y+0YEWBs7UDqETzH38Xuji1r4DFxrlnSjP39LtKnMNVe8RMtaOAtkrWJ7me
         Y9niFkm5oV4unU9F/qkHvyAHwSdlH0oXndoHLw62jbCo0Uxo93LRp9sb6bRWLuKnHFyb
         7bBBk4cB7SFbBTv/eEZd14mIJDelMnicC8bGWIStMTlHF8fW6A9I0tm0XLTGXZj1qa+e
         R/xkTO/kdpTAHPLNBNJtU5BmjqD1ko7y25h2RC0jZFCA0IietaB1zZiJJnOUp25uuSg+
         UfuA==
X-Gm-Message-State: AO0yUKVczAtWwO82cq8SgrJ0yLDxMLdcXT9u5IvOVmGIor+VYgqv6CyJ
        AhhHMrJ0W9YbdCPTGg0+IL4kyXBW1rg=
X-Google-Smtp-Source: AK7set99dxabQkO8bhQ9TNf+zy46ecnrIxC4c+0L9/7RqNWaX1x3yGiHbn7CccOiYArBvLYiJ7ZxCA==
X-Received: by 2002:a05:6a21:869d:b0:cb:fe3e:e33 with SMTP id ox29-20020a056a21869d00b000cbfe3e0e33mr10467848pzb.42.1677401518050;
        Sun, 26 Feb 2023 00:51:58 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id s10-20020a62e70a000000b00592591d1634sm2227299pfh.97.2023.02.26.00.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 00:51:57 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v12 bpf-next 02/10] bpf: Refactor process_dynptr_func
Date:   Sun, 26 Feb 2023 00:51:12 -0800
Message-Id: <20230226085120.3907863-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226085120.3907863-1-joannelkoong@gmail.com>
References: <20230226085120.3907863-1-joannelkoong@gmail.com>
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
 kernel/bpf/verifier.c        | 58 ++++++++++++++++++------------------
 2 files changed, 29 insertions(+), 32 deletions(-)

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
index 5cb8b623f639..baecccc5fa7a 100644
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
@@ -6219,7 +6229,6 @@ int process_dynptr_func(struct bpf_verifier_env *env, int regno,
 			enum bpf_arg_type arg_type, struct bpf_call_arg_meta *meta)
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

