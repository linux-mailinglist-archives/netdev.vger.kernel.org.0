Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20DE6BF245
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCQUTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCQUTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:19:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12203B20E;
        Fri, 17 Mar 2023 13:19:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso6452143pjb.2;
        Fri, 17 Mar 2023 13:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679084368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JN9cBNt3h3eIh0OXmvX38/fGd4Tx0MODI3Ugpo8F75o=;
        b=GmxUn1U4n3wS6krTdx/OdDtgbVO7VbB71sT1m9gfx+34+syc12nqNFLhg6HW1eX6Z/
         m6/cBB7SSxJ22qydBZ4I7X58HASdli7jgOU+KCOYVoo1f8NiTIG50M93d95hPTkCms2m
         AmdFlQJGNODafqSMFUSFdXPNTKQ1L5i+cmhCUYXUpyJ5Czh7v420f0fGZ1Ng6MUA846k
         7u5oGcRPHJn5ukv3Flkw88nGCE+/YzEAWXBzBzbnLYJq3fwQCc7JDGKWq9UsQA/KLnf6
         ddSME8JSPajGlhkrVWT8UTvcz3Atg2wbvHUQ+xGn6g7m5zHsPEKR7+EbVvqVyFyZinKE
         /mHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679084368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JN9cBNt3h3eIh0OXmvX38/fGd4Tx0MODI3Ugpo8F75o=;
        b=4kS2xtcWVCynGAx3FxBJr41kjbyAARGfw7wQI4VQ2pQaY0/KmZIlBMsooLs5EYjyGt
         mqPthszVI0wdZNWcr6PY1Yi+R8VCNFj+JKgjxuUM0kHFNV79W4xY+8UISvs7ipS3j20l
         k3NgD7gd5byYqv4Fgxy3D1MM31Q+6f6VYoAIWgdt/JYditNX+Omn5wVXV/80+iFNCoZZ
         FeEiNqasJLWlv1n42SgPJP6+kBwu9rvDepPNFpKjAFaBC0dHGHn9LCPHPs8HKCo/tvah
         4DLWUrlbUR//r/n+TUSbCCoLZ7r2nDMHK4b3NCQaqCjSVFqbBSjEbO4Shfh752hBednm
         vqcw==
X-Gm-Message-State: AO0yUKWY7deYbfVGShSpTrFczTR9KCe4oV3/RzSZBWC8tBy4i3TDK/Gs
        10XjYQizuPBzMtzl2jIohSKpK0IR5NM=
X-Google-Smtp-Source: AK7set+5G5gszHJ74ll+JFQF3HwLPjJ5P/pooksNjyG6Pzi7hqu0h/un0ga4n7eMvIEJSKGbp/KELg==
X-Received: by 2002:a17:90b:3a8f:b0:23f:63d5:c10f with SMTP id om15-20020a17090b3a8f00b0023f63d5c10fmr2735385pjb.25.1679084368394;
        Fri, 17 Mar 2023 13:19:28 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090a1b0600b002311ae14a01sm5339849pjq.11.2023.03.17.13.19.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Mar 2023 13:19:28 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 1/4] bpf: Allow ld_imm64 instruction to point to kfunc.
Date:   Fri, 17 Mar 2023 13:19:17 -0700
Message-Id: <20230317201920.62030-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
References: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexei Starovoitov <ast@kernel.org>

Allow ld_imm64 insn with BPF_PSEUDO_BTF_ID to hold the address of kfunc. The
ld_imm64 pointing to a valid kfunc will be seen as non-null PTR_TO_MEM by
is_branch_taken() logic of the verifier, while libbpf will resolve address to
unknown kfunc as ld_imm64 reg, 0 which will also be recognized by
is_branch_taken() and the verifier will proceed dead code elimination. BPF
programs can use this logic to detect at load time whether kfunc is present in
the kernel with bpf_ksym_exists() macro that is introduced in the next patches.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/verifier.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d62b7127ff2a..1bc8a6d6fdd2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15952,8 +15952,8 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		goto err_put;
 	}
 
-	if (!btf_type_is_var(t)) {
-		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n", id);
+	if (!btf_type_is_var(t) && !btf_type_is_func(t)) {
+		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR or KIND_FUNC\n", id);
 		err = -EINVAL;
 		goto err_put;
 	}
@@ -15966,6 +15966,14 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		err = -ENOENT;
 		goto err_put;
 	}
+	insn[0].imm = (u32)addr;
+	insn[1].imm = addr >> 32;
+
+	if (btf_type_is_func(t)) {
+		aux->btf_var.reg_type = PTR_TO_MEM | MEM_RDONLY;
+		aux->btf_var.mem_size = 0;
+		goto check_btf;
+	}
 
 	datasec_id = find_btf_percpu_datasec(btf);
 	if (datasec_id > 0) {
@@ -15978,9 +15986,6 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		}
 	}
 
-	insn[0].imm = (u32)addr;
-	insn[1].imm = addr >> 32;
-
 	type = t->type;
 	t = btf_type_skip_modifiers(btf, type, NULL);
 	if (percpu) {
@@ -16008,7 +16013,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		aux->btf_var.btf = btf;
 		aux->btf_var.btf_id = type;
 	}
-
+check_btf:
 	/* check whether we recorded this BTF (and maybe module) already */
 	for (i = 0; i < env->used_btf_cnt; i++) {
 		if (env->used_btfs[i].btf == btf) {
-- 
2.34.1

