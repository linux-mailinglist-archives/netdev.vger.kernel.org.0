Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C403C3BF37A
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 03:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhGHBVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 21:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhGHBVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 21:21:34 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18E8C061767;
        Wed,  7 Jul 2021 18:18:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b12so3953435pfv.6;
        Wed, 07 Jul 2021 18:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ca4Ou8sUVl4fj4o5nVk+7zGezdg9tbhobFr+rWBV8RA=;
        b=OMT2movfCcOCSZUXzp2MOTI6jUkKipUDA2B3Tx/SG+DU1PPU8eGIfLMT5AjfBL3TMp
         aJb1GJBah6SoJMdQUN0RsMPvMhKt7FEYNgEWAzG+4ameAZRmBSYOsEBuOMZnoyCpy0/j
         eYChHC4osL7EzgrrZk6mo43JZDeMVJbjr4W4rpUY0DcMCb16GHJtLaNYZuE91U0mp4UW
         Zho75PoNn1sLvzk5nmYOTCDqTPmzk05Qi8Zav18CMh8eBYnr9jgwjfveBN8q39whp4Fu
         6a6Yxt5FErqpLVXe4gWXO76MBwNm9SGEUwBs3Cu2DAeNqZ7Uh8xBQ3JtxLC0zbS3nVQB
         oqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ca4Ou8sUVl4fj4o5nVk+7zGezdg9tbhobFr+rWBV8RA=;
        b=p8AsWFkwZG5s3KJxvJ1uT9x0oifjucwfeoQZ8mbVfbOfLR92zUUOBoGlpla04P0FMH
         iAIfYINAUHwAIp3PQzH+7AtWQJEQ5K8TBgPqcz8TXaOI40gD8YBOpvHF/jv8dhQvHwKp
         f+uqB0x6eSbXH4mT2rXQlyD9zkB0/ubr1JBi7J9jmvl+Ukit0j6DPAm6m2DHgTZCKVNK
         cEI/9tVkWGyYzbo2UXZrfYPe/zYu21Eyp663m3qk2ryZouAo1i6OlZMfvOECL+cbvy6f
         V23nf2/zi4w+3zB69w6VZ3cxB6jK2go87WBvvBfASNnAcfM3h3G0nkIsLM8giGZ5ovP6
         Mysw==
X-Gm-Message-State: AOAM533Q6x6eiAQdZipjItuiWAKaNNhH5vjTVyJB9qGiTlUmR6p5wNGr
        pL2jqth2ykvZ7qGlbOALD0Q=
X-Google-Smtp-Source: ABdhPJwAMQIlAuafsFd15vAkV4Wl5oQXyG6csSatFRTPuNdEBgeKKOWYL8KbooyWqNXhsbkJS4sV3Q==
X-Received: by 2002:a63:f916:: with SMTP id h22mr29086762pgi.6.1625707132464;
        Wed, 07 Jul 2021 18:18:52 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:9f4e])
        by smtp.gmail.com with ESMTPSA id d20sm417450pfn.219.2021.07.07.18.18.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jul 2021 18:18:51 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 09/11] bpf: Teach stack depth check about async callbacks.
Date:   Wed,  7 Jul 2021 18:18:31 -0700
Message-Id: <20210708011833.67028-10-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
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

