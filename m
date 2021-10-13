Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC53442B930
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238472AbhJMHgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbhJMHgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:36:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38435C061570;
        Wed, 13 Oct 2021 00:34:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so1556261pjb.4;
        Wed, 13 Oct 2021 00:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZFvV0ObucGHgqH1avC4TXdCBFx77/ZHPi4yg4e3UIEk=;
        b=UCuPLkvWXNuZFrszOM5yYVO/O9Hhp7cLHM34UR9yH4QwFj843kVcuo9FBKEDt86GBD
         59X4lGXN/XsXr5m/ECQuY5SK39BdKfhGzBiUS/qi+bQjDIJUij7eO+N0VVCl4ptkHNOf
         97xqeRj8TXtLm1Fu9IDofeIRcH9pP2PiWRDrkFmnYYUhVvX9x4lQZs16wBec6Lhq0dyG
         YEDYTNGwSzjSCdjCMvnOx5aT5+UQcSPWlgO3WnO5dpcRP+fRCFXcKUlCjqBP+T1cZijo
         ifGdE/8znWgl6/IfbFsrf+LXHcsFK3n360GxChTfnaB7NQibLXLvXLTMjhcOolUdK4QK
         MKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZFvV0ObucGHgqH1avC4TXdCBFx77/ZHPi4yg4e3UIEk=;
        b=Fj8HepFavLy62AFXKFUzrmmGvRri8/geo5KFu4Krrk807gPGUPyd0s6+GPzODeU5tX
         FO78xHkTlaIWHHDr+sqUq1v6UTalDibvxgUOMMSBy6aKpRYecSRvsE/3O4Z2PX+KkIJh
         jO/iyHGaPHZZduyMoBsuvUALIuTJWyk+4PUdvG77QoS6/7tI/eKjjIf4HD+N/eLW1Vrf
         HuOkfZRTtA9wjN++9Lmx4kzZYHNUfxbqVgTiqHbVEx8k8OK7uGgPE0fuNY46mvlVpzEa
         qF2mFyO4hJlNIz1DBUo9rX3bHaObqLHl24MXdme3NVxbocjMFB4nIRG2Ys62THLEeyDr
         8JXw==
X-Gm-Message-State: AOAM533lwre2ww86sobVp0fLfTCfUQ0ms1rMH2BwGLde5s9GYt5hP1QR
        erCqetxxLdft+Qj8nttUXsmArk4Cp9Y=
X-Google-Smtp-Source: ABdhPJwPsBrBB9VhjNUS3/ud3pR0u69B0yZAG2oXQ1PEqRaW3W6Vy4C9uiagCnLgqxdSqv3cywW5iA==
X-Received: by 2002:a17:90b:3581:: with SMTP id mm1mr11543499pjb.93.1634110440605;
        Wed, 13 Oct 2021 00:34:00 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id d138sm13054423pfd.74.2021.10.13.00.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:34:00 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 3/8] libbpf: Add weak ksym support to gen_loader
Date:   Wed, 13 Oct 2021 13:03:43 +0530
Message-Id: <20211013073348.1611155-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013073348.1611155-1-memxor@gmail.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5011; h=from:subject; bh=AmcPIQOc226gQujGSXFGoCBc7ztOjdv6HlCuUwj0xGY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhZovSvjNkaMwNzs//v3MohZR0l8cxOAcpxK8HhRFQ b8UsIqeJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWaL0gAKCRBM4MiGSL8Ryuv/D/ 9KlzEUj3XexhrxMRC4/BfRSru8n+PoC6y4+geefS4oEqY+DTafX/1UTYtS/fdmV7/KDO6TAGHrHGsh g3xiK5NlOjbR/+2RsPTHZK7VaJTuUHGcwhOzttcquOC5yWncE4XJimUyWw7w6oznRp+rR3LAx7xjMI L4vrmQcwoYfqXEUVKRVFA/XPAcmy+DkI62o/sxGBIlX+wXLs/76zItq174z4tomGQo0gG/3yVDXwn1 GtOSCNQg1PDkgacjGmnZdPaumwBwrcJQDtAvHO4ST4u/8K6KCmGXkYlYa1Cq8sqdnvRF8vo3zhzPqq jQu75YrFvdhKCd8Hc4WMSaliQMikUpNMReCf4ABdWudK/37WKeDIcAOh5YJ7Af7YYmXoU5A/nSlDCy 46C9NbHCj0K7gDVrep6+zuhtm+BqAptYxNqiLAlE7dVv2jcBzVNCJw63MdBaHG4XEU2vJeWhy+oQAs 4Skl14gbb2eW2IypYd3l0ri/Rnp5xhNQSAYyetYA9bwwADwMb7arwOIqkbpDZRUjVe2WXl/7hdBbru h8EhzgQb0+GHtWHkJUxQC3mK7pcq7oHVWqrFXb3UJO+TEJNimgMUzRNlMmGggXjxoZAGfN8WK2cy+p DF6jWiWoiHELrcO3LCVpnHJUT1cTgnGAWyy1tq7wNtAFl+j/V+f+RH+6LRjQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This extends existing ksym relocation code to also support relocating
weak ksyms. Care needs to be taken to zero out the src_reg (currently
BPF_PSEUOD_BTF_ID, always set for gen_loader by bpf_object__relocate_data)
when the BTF ID lookup fails at runtime.  This is not a problem for
libbpf as it only sets ext->is_set when BTF ID lookup succeeds (and only
proceeds in case of failure if ext->is_weak, leading to src_reg
remaining as 0 for weak unresolved ksym).

A pattern similar to emit_relo_kfunc_btf is followed of first storing
the default values and then jumping over actual stores in case of an
error. For src_reg adjustment, we also need to perform it when copying
the populated instruction, so depending on if copied insn[0].imm is 0 or
not, we decide to jump over the adjustment.

We cannot reach that point unless the ksym was weak and resolved and
zeroed out, as the emit_check_err will cause us to jump to cleanup
label, so we do not need to recheck whether the ksym is weak before
doing the adjustment after copying BTF ID and BTF FD.

This is consistent with how libbpf relocates weak ksym. Logging
statements are added to show the relocation result and aid debugging.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/gen_loader.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 6be17dd48f02..0e84d644791e 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -13,6 +13,7 @@
 #include "hashmap.h"
 #include "bpf_gen_internal.h"
 #include "skel_internal.h"
+#include <asm/byteorder.h>
 
 #define MAX_USED_MAPS	64
 #define MAX_USED_PROGS	32
@@ -776,6 +777,7 @@ static void emit_relo_ksym_typeless(struct bpf_gen *gen,
 static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
 {
 	struct ksym_desc *kdesc;
+	__u32 reg_mask;
 
 	kdesc = get_ksym_desc(gen, relo);
 	if (!kdesc)
@@ -786,27 +788,52 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
 			       kdesc->insn + offsetof(struct bpf_insn, imm));
 		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
 			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
-		goto log;
+		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_9, BPF_REG_8, offsetof(struct bpf_insn, imm)));
+		/* jump over src_reg adjustment if imm is not 0 */
+		emit(gen, BPF_JMP_IMM(BPF_JNE, BPF_REG_9, 0, 3));
+		goto clear_src_reg;
 	}
 	/* remember insn offset, so we can copy BTF ID and FD later */
 	kdesc->insn = insn;
 	emit_bpf_find_by_name_kind(gen, relo);
-	emit_check_err(gen);
+	if (!relo->is_weak)
+		emit_check_err(gen);
+	/* set default values as 0 */
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, offsetof(struct bpf_insn, imm), 0));
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 0));
+	/* skip success case stores if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 4));
 	/* store btf_id into insn[insn_idx].imm */
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, offsetof(struct bpf_insn, imm)));
 	/* store btf_obj_fd into insn[insn_idx + 1].imm */
 	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
 			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
-log:
+	emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 3));
+clear_src_reg:
+	/* clear bpf_object__relocate_data's src_reg assignment, otherwise we get a verifier failure */
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	reg_mask = 0x0f; /* src_reg,dst_reg,... */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	reg_mask = 0xf0; /* dst_reg,src_reg,... */
+#else
+#error "Unsupported bit endianness, cannot proceed"
+#endif
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	emit(gen, BPF_ALU32_IMM(BPF_AND, BPF_REG_9, reg_mask));
+	emit(gen, BPF_STX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, offsetofend(struct bpf_insn, code)));
+
 	if (!gen->log_level)
 		return;
 	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
 			      offsetof(struct bpf_insn, imm)));
 	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_insn) +
 			      offsetof(struct bpf_insn, imm)));
-	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var (%s:count=%d): imm: %%d, fd: %%d",
-		   relo->name, kdesc->ref);
+	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var t=1 w=%d (%s:count=%d): imm[0]: %%d, imm[1]: %%d",
+		   relo->is_weak, relo->name, kdesc->ref);
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	debug_regs(gen, BPF_REG_9, -1, " var t=1 w=%d (%s:count=%d): insn.reg",
+		   relo->is_weak, relo->name, kdesc->ref);
 }
 
 static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
-- 
2.33.0

