Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E26C04CD
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 21:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCSUaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 16:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCSUaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 16:30:20 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD991CBC6;
        Sun, 19 Mar 2023 13:30:19 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso10406683pjb.2;
        Sun, 19 Mar 2023 13:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679257818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z6U7h+18D0pAf+5776vhLSgUetS4tsbDR4TcPakq23Y=;
        b=ZtIH7ZyVso5irfhW2mx27LQVkDKdVklVivZ36isjuTRRIDtc8lzibbxMcmF5qPaRP6
         oN24b0Tb/fBzA/69qep9pG+KDDej91whoaGjQOeEjcQN3z950bVVPkAdfkdZrm+uB00a
         bjg/wtZDFTwHnFI4t7sNcoAbGAai7v7qLTjx4V2ULQHx5n87zLnaq0OlPJfaZBJoS+6D
         MOktTg8mT6YsMLEfj2uN8yqjZPCbghZxar/zr6Vv0Du+NO74UTeC2rlkKn0gst841BsF
         rGmu4glHWprBqmma7fOfC+mUUoUmVwU/UagToqUUNKK17Cfz8NcNNLjWDQnkbGJ3nv8J
         FMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679257818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z6U7h+18D0pAf+5776vhLSgUetS4tsbDR4TcPakq23Y=;
        b=6sVpB59Gix3/SDq3B1gpX/hW2FCEWmBYFFRiz+15YDOH0YcTX+DeOoj95rbBxC5ndM
         KF3dMHFpltDuXCgNRNzSsorLfo0Z2XjslNwgekWK4jlH7xzIwy3Zdp8jTStVWp4FKHKH
         0EK/9RpaDrnBYJV2J9Wmoy11XQ3UndAAlvl0mZAp15n3MpWh6ea3Zdv1BVo2NG9CHnBU
         JP76zqzhAsRElmddPXYSnRrRh00XX4LQs17RlolaCoezTabcolgqP6RGXzKtGczYouor
         gkCxSUUZZOnfjDFVqAIBf63Bp2Ku0+RcLOxlNy5y/oOuZr81vKdjgJt3azSMglztT7XE
         zWiQ==
X-Gm-Message-State: AO0yUKU7nYRuXzK6fIezwqgJQWFKXXXD6dGaagxFkRmSobTtbEdcX8ys
        UzflUxVdwmEIChREw/4Mn12Z2sg2FMQ=
X-Google-Smtp-Source: AK7set/Gzaj+6e7u7rwZunWpEkZi4zyAJpL/4RPh974sc0xZe5hk17vr5uQlrNV6fQ5Xk+T0sJjcew==
X-Received: by 2002:a05:6a20:429a:b0:c2:fb92:3029 with SMTP id o26-20020a056a20429a00b000c2fb923029mr20853968pzj.33.1679257818395;
        Sun, 19 Mar 2023 13:30:18 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id g6-20020a62e306000000b005a8bf239f5csm4937215pfh.193.2023.03.19.13.30.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Mar 2023 13:30:18 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 1/2] libbpf: Fix ld_imm64 copy logic for ksym in light skeleton.
Date:   Sun, 19 Mar 2023 13:30:13 -0700
Message-Id: <20230319203014.55866-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

From: Alexei Starovoitov <ast@kernel.org>

Unlike normal libbpf the light skeleton 'loader' program is doing
btf_find_by_name_kind() call at run-time to find ksym in the kernel and
populate its {btf_id, btf_obj_fd} pair in ld_imm64 insn. To avoid doing the
search multiple times for the same ksym it remembers the first patched ld_imm64
insn and copies {btf_id, btf_obj_fd} from it into subsequent ld_imm64 insn.
Fix a bug in copying logic, since it may incorrectly clear BPF_PSEUDO_BTF_ID flag.

Also replace always true if (btf_obj_fd >= 0) check with unconditional JMP_JA
to clarify the code.

Fixes: d995816b77eb ("libbpf: Avoid reload of imm for weak, unresolved, repeating ksym")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 23f5c46708f8..b74c82bb831e 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -804,11 +804,13 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
 		return;
 	/* try to copy from existing ldimm64 insn */
 	if (kdesc->ref > 1) {
-		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
-			       kdesc->insn + offsetof(struct bpf_insn, imm));
 		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
 			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
-		/* jump over src_reg adjustment if imm is not 0, reuse BPF_REG_0 from move_blob2blob */
+		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
+			       kdesc->insn + offsetof(struct bpf_insn, imm));
+		/* jump over src_reg adjustment if imm (btf_id) is not 0, reuse BPF_REG_0 from move_blob2blob
+		 * If btf_id is zero, clear BPF_PSEUDO_BTF_ID flag in src_reg of ld_imm64 insn
+		 */
 		emit(gen, BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 3));
 		goto clear_src_reg;
 	}
@@ -831,7 +833,7 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
 			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
 	/* skip src_reg adjustment */
-	emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 3));
+	emit(gen, BPF_JMP_IMM(BPF_JA, 0, 0, 3));
 clear_src_reg:
 	/* clear bpf_object__relocate_data's src_reg assignment, otherwise we get a verifier failure */
 	reg_mask = src_reg_mask();
-- 
2.34.1

