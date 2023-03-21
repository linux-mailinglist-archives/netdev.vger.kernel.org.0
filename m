Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4E96C29BD
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCUFUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCUFUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:20:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BA239B88;
        Mon, 20 Mar 2023 22:20:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id fd25so8291386pfb.1;
        Mon, 20 Mar 2023 22:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679376000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbvMiertEJLycVloMHKS7yMvdcuq9AftYH+u/ksDT6U=;
        b=ZHGPx94+oTMQP0IdCJr+9WCMNvue+WefV29UEIqxeS/dO5A1HfwOD762W/KPReZFhW
         7aggWJjyVf/K8Cq7614cToRizHCOw4S6GrUodSgdGMX7R8BC+IbfTa76uAHl3XvAhjOc
         Bc1s5XARn9n/OhhMtAkhH8PR70WUMauyi83JuysHyDDbdKnJnYqUWgilIbdml4Drp5Wp
         yu/yGFh1pAv0vqIalT8mIoyb1qxWbyZ4dphZWgebrJ8UgrDdIOny7+5rlz/T3SFuV4T4
         tvfYksFhZ2KjOgurelrmIO/Vovf0babttgp44wS/pCvLgdEMdeZtaKsb4POpSEP0KUqL
         iQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679376000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbvMiertEJLycVloMHKS7yMvdcuq9AftYH+u/ksDT6U=;
        b=suvkkgrWTQSg7dOV98rxFZxR8MCAy4gHWYikfRkXBR69FZj7nWG/xQYRjDPsz0QOOx
         Y+f+7Pnfw/t3xgv96+EtvoqN4V4f4TAsOTAC4FvY07jaEJZXZ4RMhaRsPZhKpAQbOlY6
         ut8nDbyS7C0d+T3c4KZq6YBjzQYC1A38k+WFTr321TI783ZkMkagrYtBZ4WPMUzxY48p
         hGeCSUsf9yynBLPSCscBR7hOMZh4ZWud+MfqBv/k+L5P57JOjM8BbogbXLSvtoyoRYw3
         k7+tKzOF7YvZ/YWOYg7yMh0G7/MwNAxGlpMWW1S7FYD5eCfeYqix1D4QPwXZh3kmXMUR
         Lf4w==
X-Gm-Message-State: AO0yUKWlzgt75DOGci7Pt51suH5luJaLvU/4tskF/GYxzlgvd5TZOKDV
        4Ig8l9+HWjKyldohzNyyM2PFZaPijb8=
X-Google-Smtp-Source: AK7set+fgai7lOYDzZP926ZJAX6mtZ9b/uW96FNcmEhtH5TFIiHpiUyf5uVcMkrIdepGNlnrDHd/iQ==
X-Received: by 2002:aa7:957c:0:b0:626:dc8:b004 with SMTP id x28-20020aa7957c000000b006260dc8b004mr1398154pfq.26.1679375999923;
        Mon, 20 Mar 2023 22:19:59 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:1606])
        by smtp.gmail.com with ESMTPSA id f17-20020a63de11000000b004fc1d91e695sm7168298pgg.79.2023.03.20.22.19.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Mar 2023 22:19:59 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 1/4] libbpf: Rename RELO_EXTERN_VAR/FUNC.
Date:   Mon, 20 Mar 2023 22:19:48 -0700
Message-Id: <20230321051951.58223-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
References: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
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

