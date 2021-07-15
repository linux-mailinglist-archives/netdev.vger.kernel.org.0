Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218273C9557
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhGOA5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbhGOA5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:57:35 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5354C061760;
        Wed, 14 Jul 2021 17:54:41 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 70so937568pgh.2;
        Wed, 14 Jul 2021 17:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LNlh7ErWiTtr7/sCr5asAT8Vf7CkuB43ibafMS37p1A=;
        b=UgTozhoMoUV1gIhadV7s9ZQwoOrKrzOSiVOefgf4YkbHrhrew1jof24XW7JagqZ+xx
         skB9+2KHRK8gtRViJRLnrfzNbzxJriPHWk3Wv8CALzT6D3m6XEQAZ5yZIicAUw88L/dU
         2z3rV133vMg0ja3koFzhZwspcE+hKgRtyMTJpAboKBKCRQnbP9GrVZlfuBhSY/xfSwZz
         +zgCubLxxxxatPtwWCSAXc1dqfB86Sx7HHFqU6nc28IagpwcYbR6r48eTjBKwTZKV/E4
         mFeAc004pfanN9vlNP81OJwEhzopbBKj7WPFRiHJ3uZQ0O1M2gDE6KVvxRPrfTk+8UGd
         Notg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LNlh7ErWiTtr7/sCr5asAT8Vf7CkuB43ibafMS37p1A=;
        b=q6ngFt5hFWHwi9kI7jMNxos+SCt839AV2r90ApbFW67VCOfaFWfKYNbpp6Mk7Tp6OT
         gRzmC7uFEFf7HkyWLdDgyHWOJdGm/TEDkBM7FzSKwEjxX8xXU6hX9sf5DvyI0d5PODys
         CjA3aKuIx70RWpYF93B3sunSjw/0zLdBBdcCTNS4BpPbfP9Z+mAcU1JQVvv1b6pitPlG
         muh2pAwYBHnkUxkjrxN/Cx4Of8HjORmVPN1sSxQZ38pPirzlueRfXC0RBGOy8vr0d5Cf
         K+5dpt9z1hyD5sIQEH5P1fDeVLYOiJf7Qd4Y9uwt81T4pmzlIGWyaiIA8FJD8yUa+cyQ
         +ZwQ==
X-Gm-Message-State: AOAM530sPnRAlwPZbCkqGt4nMpYIhY/Yv/1AzLnvYpqcZNNFQu2lyV2d
        a1X3ngrIe3upwZFB3mgfX50=
X-Google-Smtp-Source: ABdhPJwxKqEcHsBFuZLTKAStRdvglnT51WekPYhvWW+NlwQcS1piQhk2HAi26DhlGXOo5VmbjIM+gQ==
X-Received: by 2002:a63:ee06:: with SMTP id e6mr826350pgi.374.1626310481477;
        Wed, 14 Jul 2021 17:54:41 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:120c])
        by smtp.gmail.com with ESMTPSA id nl2sm3439011pjb.10.2021.07.14.17.54.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jul 2021 17:54:40 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 bpf-next 09/11] bpf: Teach stack depth check about async callbacks.
Date:   Wed, 14 Jul 2021 17:54:15 -0700
Message-Id: <20210715005417.78572-10-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
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
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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

