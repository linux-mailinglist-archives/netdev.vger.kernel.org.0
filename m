Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AD93B24FA
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhFXC17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhFXC1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:27:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9A1C061767;
        Wed, 23 Jun 2021 19:25:32 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e22so3423328pgv.10;
        Wed, 23 Jun 2021 19:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gWLeiI/YxLXkaPJxEUwZ2EHBQUf5f2raKdNCp6AYQe0=;
        b=YdXLxr6Pi501wpAFp9/YwG/wEL6VBL8FbJ8jvoT/nDALtXTK0OylaL5O5K3pqHlX2t
         27XWYWAVTaEYwaKyXo6kP1+/+XeyNwsOJj6WP/zfXbnRHTAdJSjfjGPxhsX0TK0Nf7h1
         ClOr1Zr94DmdAAe0qlGgxnuAnZVirTqAulGvfRnWiEQ8IFkFevaD+kDc6jO9blitiQc8
         v+3qhvC9CQUZVJkQNHR1N5HWC6F+0cPC7OTHRcPnVbMWNrNsf/etQHBQmjPQHa7i9+f3
         dkaAs9lUzpfQjZYQXAib5vz+DYfasNeWS4BFao3wnGr4P8y5X4hX3J9WxY+xUuKAnwNe
         2OLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gWLeiI/YxLXkaPJxEUwZ2EHBQUf5f2raKdNCp6AYQe0=;
        b=kcnNf2cjSXqRTQLMqjDyJmmyKOXqtJfsxg1G/j66nrprH+hXg18KmYq90madv6bUp1
         34MDLwgz8Tq1IlrF37HmQe/cFxeucLGvubXHCiJWrJU6ai8uRiCUFbghOtx+XKSPl3Xp
         a9icy9QopavQTYmqPOOyzR73PZEJjxYyplGrckkmVyVcaPMkIzR/3k5mIzLYlDLiIywO
         OM2gxMry1HfPX9FVhrh7IR4f94bBi9itrfYdGKnMHBYA3JULDLbs3iCgUPrE6YQ1KDcA
         UrPWN752fuO2HojL6Aa9FJ9HZ1bLNuQn/TwYKHIZ86OMOhNBlI2t18BQom4i+QBrta/y
         aC7A==
X-Gm-Message-State: AOAM531ZuITiQ+XmcII10/alChYBCpmcLDGheNLb+pnz6uV6zew0fRTk
        EOM1/MHx4nW9MLlXagJAGTH80YJr5Hs=
X-Google-Smtp-Source: ABdhPJxfH9QpfWNkwLnurSVfThdoKEu2CuzxQ87QkOtYR8kTqI5f6RUuJIVaTL/Ik7B3Op+2TA9xiw==
X-Received: by 2002:a63:4d62:: with SMTP id n34mr2497006pgl.302.1624501531931;
        Wed, 23 Jun 2021 19:25:31 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:a319])
        by smtp.gmail.com with ESMTPSA id f17sm4675965pjj.21.2021.06.23.19.25.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:25:31 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 6/8] bpf: Teach stack depth check about async callbacks.
Date:   Wed, 23 Jun 2021 19:25:16 -0700
Message-Id: <20210624022518.57875-7-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
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
index ce30c4ceaa6d..5001cdcc3677 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -399,6 +399,7 @@ struct bpf_subprog_info {
 	bool has_tail_call;
 	bool tail_call_reachable;
 	bool has_ld_abs;
+	bool is_async_cb;
 };
 
 /* single container for all structs
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 503338093184..fe5ba8a46ce9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3704,6 +3704,8 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
 continue_func:
 	subprog_end = subprog[idx + 1].start;
 	for (; i < subprog_end; i++) {
+		int next_insn;
+
 		if (!bpf_pseudo_call(insn + i) && !bpf_pseudo_func(insn + i))
 			continue;
 		/* remember insn and function to return to */
@@ -3711,13 +3713,22 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
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
@@ -5733,6 +5744,7 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		struct bpf_verifier_state *async_cb;
 
 		/* there is no real recursion here. timer callbacks are async */
+		env->subprog_info[subprog].is_async_cb = true;
 		async_cb = push_async_cb(env, env->subprog_info[subprog].start,
 					 *insn_idx, subprog);
 		if (!async_cb)
-- 
2.30.2

