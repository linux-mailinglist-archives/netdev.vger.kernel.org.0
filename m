Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C0C3B967E
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 21:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhGATXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 15:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbhGATXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 15:23:31 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99FBC061765;
        Thu,  1 Jul 2021 12:21:00 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c15so4191974pls.13;
        Thu, 01 Jul 2021 12:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=euC7f1lwJ0DS9gjXPO5ZTl7WLktQXMZwRBwfnY7ZxVk=;
        b=twaWkp8gTQeZCEh7gXiqbBEplg/dfeS8fH0WLpSWI+dKDOu7JMdJQtmNGJyOVcCUee
         c9g3PddofIMS3SroHnn/r8HXw+mTFc3qyq9NOOHjgmruHW5Bqipm/X+G1uLy3ojVBQBd
         V7DdbijfCdelr7ossEP3xN2c5z09yjWfXYMBRiNWFqd5x47hsO2SaqJOLHacqluLRpE0
         B7WNGyho4IuhJj6J/JiOM/OlC2Khowfl6oVOmBhWXHd/vLQsmvrvqzGjn60Z0R/+iDUK
         qBTAFk2lAlf1cnxlb5eCe9vsEkxl4sCwQE5xtjSBmkbS/x7uYSh0lzcn9fg81Gx7K2R4
         RaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=euC7f1lwJ0DS9gjXPO5ZTl7WLktQXMZwRBwfnY7ZxVk=;
        b=F2MZKFy60vP2x6p2T4JlhF41R7VRr7cbo13S/zBqyNFErgU/5uW39a5+dBRF0Y3c6q
         fkvKYjllEGOVwjsC7v9M6M+XuuQ4x0vttT7jipMNvD0yW6kbY/EXQPQImkBmfQzyNxyO
         GofXaZSON1xFeEmhNtTtVgJGHQA01XOltbDKzBmxkkfKZNndFT8hELnRhF/UnEwOsDMi
         pATiCUTNaeBtkejOLDgLFSy4Ss41WflFJeCeNczImUTtnt9iitH0/zxu8IaSWhh3/vih
         rVoHEd0joed9jmKhY4Je1k7X1rO39ZZdd8iHhZXGlSmfF/TZKD4tp+b4Y1i1VQOmQHfL
         2uXw==
X-Gm-Message-State: AOAM530dZmOj8cK+EZKVHzZ9rDuAKdXHo0M/eAn2NggLaFLHSQ8k+8vC
        ZulzPP9TWM/w9tHc56UWGwOJnWtRexY=
X-Google-Smtp-Source: ABdhPJwZ6zRQPh9/dX7NwUdBf+pkxirWlsmrKSNxf5lJCXS861gzSkLcueN2RHtiEsOQX7UNUEjRKA==
X-Received: by 2002:a17:90a:6402:: with SMTP id g2mr1141995pjj.82.1625167260467;
        Thu, 01 Jul 2021 12:21:00 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f1f2])
        by smtp.gmail.com with ESMTPSA id w8sm607725pgf.81.2021.07.01.12.20.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:21:00 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 7/9] bpf: Teach stack depth check about async callbacks.
Date:   Thu,  1 Jul 2021 12:20:42 -0700
Message-Id: <20210701192044.78034-8-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
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
index 46259d02083f..e3efb48951f0 100644
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

