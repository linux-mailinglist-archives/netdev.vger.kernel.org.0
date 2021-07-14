Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCAC3C7ADD
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 03:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237307AbhGNBIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 21:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbhGNBIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 21:08:31 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA5EC061797;
        Tue, 13 Jul 2021 18:05:38 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v7so327556pgl.2;
        Tue, 13 Jul 2021 18:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ca4Ou8sUVl4fj4o5nVk+7zGezdg9tbhobFr+rWBV8RA=;
        b=cQdsBdM2uPyDuVThJhAUYuE9vohCjbWOYZEzHuEN313pBKsTdbWExZ2lzHMrcf71Z2
         bQOT8zf/rCLdboOu8+2HRq4xl20+NpCaO/R7KVu5wmt+/Xhgz6NZkk+t4ZwTLk0h6L2Z
         ardn5sTao/89AdFfO2GuI1hsW0gxOeNKpYJORPqfYLwQFn/DWaIXuQkoR3hpWKEWQfb/
         JourNyrmb11DhkzdChQICTBXuHXOWyqii1c1HCrwxQHavrwNuQpookclG5S+H5in0Dng
         s0jk6XsO7QBqoruDjRxHbfZ/D+02BMl5KhfrZSBUbPy1mFXbeAyd4fMW5KZuxuAFud3h
         IgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ca4Ou8sUVl4fj4o5nVk+7zGezdg9tbhobFr+rWBV8RA=;
        b=OskKh5WeDt5LsxSHsNclw46PRPMtyz/3w9dLZBn/WCR0AI4PZ16Ni/Xa2FRsPBpazK
         HG4/nHMF8b8ALtQM8YBs/qVvsxdPkNS4MPZyNfqR2hevBpZQXoX8QsN2XTDvNfZxN4p/
         ZbMAgAbNZQdn+pkaqLQmFYdzf7zT9AjaHC5rEuS0MkqL3vqwYnUTScAXyPBKYslBvEBI
         QKS1wanjs8NoEAscfzF/r6E6SCNO7aqtPtRrmRDzx5WMbTVpRnB0OlE0X5GF2fe/3zFm
         mTCl/YDdKJ6c8TujTct89aiYXPaCRqBMBdOGk3CJK6BEbbFfo+Zsv0MK8zWS3ACGc1eI
         JC5g==
X-Gm-Message-State: AOAM533UG9imstWuOhHFwrP3CifQNmMwNq74c5S4rHbiirv1AKLeksei
        29Dq2KhsudS3qyuhfbDbUCQ=
X-Google-Smtp-Source: ABdhPJxm53a9EErV4bLSYv5ItU4MzedfyBsBe2aJGyCWtM1axOWf6Dp/DxordgGY0zwM4Qva3+OqiA==
X-Received: by 2002:a63:5b51:: with SMTP id l17mr6765848pgm.408.1626224738466;
        Tue, 13 Jul 2021 18:05:38 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:10f1])
        by smtp.gmail.com with ESMTPSA id cx4sm4073560pjb.53.2021.07.13.18.05.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 18:05:37 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 bpf-next 09/11] bpf: Teach stack depth check about async callbacks.
Date:   Tue, 13 Jul 2021 18:05:17 -0700
Message-Id: <20210714010519.37922-10-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Teach max stack depth checking algorithm about async callbacks
that don't increase bpf program stack size.
Also add sanity check that bpf_tail_call didn't sneak into async cb.
It's impossible, since PTR_TO_CTX is not available in async cb,
hence the program cannot contain bpf_tail_call(ctx,...);

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 18 +++++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 242d0b1a0772..b847e1ccd10f 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -406,6 +406,7 @@ struct bpf_subprog_info {
 	bool has_tail_call;
 	bool tail_call_reachable;
 	bool has_ld_abs;
+	bool is_async_cb;
 };
 
 /* single container for all structs
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ab6ce598a652..84f67580ab19 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3709,6 +3709,8 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
 continue_func:
 	subprog_end = subprog[idx + 1].start;
 	for (; i < subprog_end; i++) {
+		int next_insn;
+
 		if (!bpf_pseudo_call(insn + i) && !bpf_pseudo_func(insn + i))
 			continue;
 		/* remember insn and function to return to */
@@ -3716,13 +3718,22 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
 		ret_prog[frame] = idx;
 
 		/* find the callee */
-		i = i + insn[i].imm + 1;
-		idx = find_subprog(env, i);
+		next_insn = i + insn[i].imm + 1;
+		idx = find_subprog(env, next_insn);
 		if (idx < 0) {
 			WARN_ONCE(1, "verifier bug. No program starts at insn %d\n",
-				  i);
+				  next_insn);
 			return -EFAULT;
 		}
+		if (subprog[idx].is_async_cb) {
+			if (subprog[idx].has_tail_call) {
+				verbose(env, "verifier bug. subprog has tail_call and async cb\n");
+				return -EFAULT;
+			}
+			 /* async callbacks don't increase bpf prog stack size */
+			continue;
+		}
+		i = next_insn;
 
 		if (subprog[idx].has_tail_call)
 			tail_call_reachable = true;
@@ -5761,6 +5772,7 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		struct bpf_verifier_state *async_cb;
 
 		/* there is no real recursion here. timer callbacks are async */
+		env->subprog_info[subprog].is_async_cb = true;
 		async_cb = push_async_cb(env, env->subprog_info[subprog].start,
 					 *insn_idx, subprog);
 		if (!async_cb)
-- 
2.30.2

