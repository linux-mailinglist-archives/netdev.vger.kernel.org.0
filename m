Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82F86C3BF2
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjCUUjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjCUUjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:39:02 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F7838B6F;
        Tue, 21 Mar 2023 13:39:01 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so17159598pjz.1;
        Tue, 21 Mar 2023 13:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbvMiertEJLycVloMHKS7yMvdcuq9AftYH+u/ksDT6U=;
        b=fuUYvRdMexPDqrHuVkfDu82NtGzlt5S4pB4qvFOotcMT52UI3oo1hLTmlkj8HzVYZ0
         ZJKPQ47wQA6BUhZc3JesL8FhSEZdkiMedb3tlJJi+Jxrt8igaqG8XfzeAZWxXLdPprQl
         pW0Osx/MoFXTI+DQexNfvqhpxYIq+D/dbthV4HjK2Wh4M/CjKqWmTgqqRtA9hCUApiA6
         WeZ5U/pW0dQXrQG9HI+TiTy5eqK3yc1To/cq0C6N1aPHc7j5zmSOVI64QIkxhuxhnUfg
         9kLii28MEFLwAn/Jme3duJFvSKTmZzaPT1llIss0gVNvelTGga1Px912Bg8JLURt9O4O
         40bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbvMiertEJLycVloMHKS7yMvdcuq9AftYH+u/ksDT6U=;
        b=Zs6zlF1Ccb40dEcaMJlf4ubmcsFAa7ViWQDegP0WISOWPt7BVeEs9nAIjULg8FYFIU
         rlY4tvq7nVw2ZeQZSAiNTemDkVXiKCJXT87CT6BhjKHgoV10STEXKsccmLBkFH0mlNiB
         3Zr6bRyJfHtf6EbjKa8lidSQf7mo9LJaBXihncmLh5cimS9hDPmNxqy2YJacktnaPLaC
         yMz+4fAT323KQnm8GOdNYCriCXvT1EVIhqMskuaumVixcncA9AYqvcBv2RAbnFFFrqj1
         4VsTqVRpghmgmSXG5Wl9TirnJ0+HnQkDJkEaULQ2FrhsJIrVrgv5bqqX/dwxShEEpaSu
         mC0Q==
X-Gm-Message-State: AO0yUKUt3QnRdVuEJtmbr7ZmBS4hvmcz659j+g2j/R5QnIXjNy/ESalt
        E/xUXynKOajmYMkd7h+5tsI=
X-Google-Smtp-Source: AK7set/NYSjEI32fPrGUbrvNX581jwzRuNt9LLFCHt2/TT/zKTXYTopqsNztydNV3gS6CWitiUtYRA==
X-Received: by 2002:a05:6a20:4885:b0:da:be69:a046 with SMTP id fo5-20020a056a20488500b000dabe69a046mr2720767pzb.51.1679431141045;
        Tue, 21 Mar 2023 13:39:01 -0700 (PDT)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:500::5:34cf])
        by smtp.gmail.com with ESMTPSA id g11-20020aa7818b000000b005892ea4f092sm8907030pfi.95.2023.03.21.13.38.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Mar 2023 13:39:00 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 1/4] libbpf: Rename RELO_EXTERN_VAR/FUNC.
Date:   Tue, 21 Mar 2023 13:38:51 -0700
Message-Id: <20230321203854.3035-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
References: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

RELO_EXTERN_VAR/FUNC names are not correct anymore. RELO_EXTERN_VAR represent
ksym symbol in ld_imm64 insn. It can point to kernel variable or kfunc.
Rename RELO_EXTERN_VAR->RELO_EXTERN_LD64 and RELO_EXTERN_FUNC->RELO_EXTERN_CALL
to match what they actually represent.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 149864ea88d1..f8131f963803 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -315,8 +315,8 @@ enum reloc_type {
 	RELO_LD64,
 	RELO_CALL,
 	RELO_DATA,
-	RELO_EXTERN_VAR,
-	RELO_EXTERN_FUNC,
+	RELO_EXTERN_LD64,
+	RELO_EXTERN_CALL,
 	RELO_SUBPROG_ADDR,
 	RELO_CORE,
 };
@@ -4009,9 +4009,9 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 		pr_debug("prog '%s': found extern #%d '%s' (sym %d) for insn #%u\n",
 			 prog->name, i, ext->name, ext->sym_idx, insn_idx);
 		if (insn->code == (BPF_JMP | BPF_CALL))
-			reloc_desc->type = RELO_EXTERN_FUNC;
+			reloc_desc->type = RELO_EXTERN_CALL;
 		else
-			reloc_desc->type = RELO_EXTERN_VAR;
+			reloc_desc->type = RELO_EXTERN_LD64;
 		reloc_desc->insn_idx = insn_idx;
 		reloc_desc->sym_off = i; /* sym_off stores extern index */
 		return 0;
@@ -5855,7 +5855,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 						   relo->map_idx, map);
 			}
 			break;
-		case RELO_EXTERN_VAR:
+		case RELO_EXTERN_LD64:
 			ext = &obj->externs[relo->sym_off];
 			if (ext->type == EXT_KCFG) {
 				if (obj->gen_loader) {
@@ -5877,7 +5877,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 				}
 			}
 			break;
-		case RELO_EXTERN_FUNC:
+		case RELO_EXTERN_CALL:
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
 			if (ext->is_set) {
@@ -6115,7 +6115,7 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
 			continue;
 
 		relo = find_prog_insn_relo(prog, insn_idx);
-		if (relo && relo->type == RELO_EXTERN_FUNC)
+		if (relo && relo->type == RELO_EXTERN_CALL)
 			/* kfunc relocations will be handled later
 			 * in bpf_object__relocate_data()
 			 */
@@ -7072,14 +7072,14 @@ static int bpf_program_record_relos(struct bpf_program *prog)
 		struct extern_desc *ext = &obj->externs[relo->sym_off];
 
 		switch (relo->type) {
-		case RELO_EXTERN_VAR:
+		case RELO_EXTERN_LD64:
 			if (ext->type != EXT_KSYM)
 				continue;
 			bpf_gen__record_extern(obj->gen_loader, ext->name,
 					       ext->is_weak, !ext->ksym.type_id,
 					       BTF_KIND_VAR, relo->insn_idx);
 			break;
-		case RELO_EXTERN_FUNC:
+		case RELO_EXTERN_CALL:
 			bpf_gen__record_extern(obj->gen_loader, ext->name,
 					       ext->is_weak, false, BTF_KIND_FUNC,
 					       relo->insn_idx);
-- 
2.34.1

