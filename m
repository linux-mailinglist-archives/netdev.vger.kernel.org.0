Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418F51C7FA0
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 03:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgEGBFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 21:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgEGBFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 21:05:18 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF717C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 18:05:17 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id z6so1359328plk.10
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 18:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=35i1uOH32weCZseOrM7fgg14K7q1B6kLHtPYbgszlOo=;
        b=R/LDR7DFzMXYZtRwYFLz7iACbiKbk+k+Fkge+bTZCHhLGYhkN4PhrbjMvBie2fQe2+
         +eAjuQYI/c48Lsec6zz61Z9S5eMUUq/CRbcaT3r7NoM2/8p/Ifi8rb+EmEzXzyzm6zzs
         P5IC8QPCu1DOeyp9e1xAwHT3aEwgIZBFbdcLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=35i1uOH32weCZseOrM7fgg14K7q1B6kLHtPYbgszlOo=;
        b=br5cXg+nyZL+hS4+NFGGX1yzGtKHOX8KXgiQztGrzTuInT3+8VatETFNxiqb6ATTWS
         uonOpJGRAl5MQOdsnTH39WQwh7MjY48DuvXrhPagt0y4o2DAjPXl2PHPxG9LTZtSuPYf
         1LjySZuU+eRNYYRyxsgEIgKygaZxknigVS1DnQ4Oi2UaAaMSG/UMEfhwrmT27DQgYgtB
         cul2VzYFmocgONQjR+xw7M91YEotps43sg+AdpRtE9TvbfzRlAWcCa92hD5HF2rMoa4j
         sQjh4YUuXEU0G/+D7Ha1GWAKY2kvKUn82X8kdYQx8kj6y8K7bLqo1QLbQmmQyl0LQzAg
         wvCg==
X-Gm-Message-State: AGi0PuZ6D/WbutUQQsdnjqISJI79CuKCoqmXMPkl9+orwDaFqafUYR6v
        JUIxOADbHfKz21iIZx/pVArz9IOBgmoHrA==
X-Google-Smtp-Source: APiQypKFU2PaEl7A2Ov+j6vFjii0e84UEN8OWo1rfo+p71phRPmL3Wiz+FYt/QG7MmEDbct+2lejIA==
X-Received: by 2002:a17:902:694b:: with SMTP id k11mr8267407plt.59.1588813517313;
        Wed, 06 May 2020 18:05:17 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id ev5sm6165250pjb.1.2020.05.06.18.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 18:05:16 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Enrico Weigelt <info@metux.net>, Torsten Duwe <duwe@suse.de>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [RFC PATCH bpf-next 3/3] bpf, arm64: Optimize ADD,SUB,JMP BPF_K using arm64 add/sub immediates
Date:   Wed,  6 May 2020 18:05:03 -0700
Message-Id: <20200507010504.26352-4-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507010504.26352-1-luke.r.nels@gmail.com>
References: <20200507010504.26352-1-luke.r.nels@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code for BPF_{ADD,SUB} BPF_K loads the BPF immediate to a
temporary register before performing the addition/subtraction. Similarly,
BPF_JMP BPF_K cases load the immediate to a temporary register before
comparison.

This patch introduces optimizations that use arm64 immediate add, sub,
cmn, or cmp instructions when the BPF immediate fits. If the immediate
does not fit, it falls back to using a temporary register.

Example of generated code for BPF_ALU64_IMM(BPF_ADD, R0, 2):

without optimization:

  24: mov x10, #0x2
  28: add x7, x7, x10

with optimization:

  24: add x7, x7, #0x2

The code could use A64_{ADD,SUB}_I directly and check if it returns
AARCH64_BREAK_FAULT, similar to how logical immediates are handled.
However, aarch64_insn_gen_add_sub_imm from insn.c prints error messages
when the immediate does not fit, and it's simpler to check if the
immediate fits ahead of time.

Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/arm64/net/bpf_jit.h      |  8 ++++++++
 arch/arm64/net/bpf_jit_comp.c | 36 +++++++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index f36a779949e6..923ae7ff68c8 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -100,6 +100,14 @@
 /* Rd = Rn OP imm12 */
 #define A64_ADD_I(sf, Rd, Rn, imm12) A64_ADDSUB_IMM(sf, Rd, Rn, imm12, ADD)
 #define A64_SUB_I(sf, Rd, Rn, imm12) A64_ADDSUB_IMM(sf, Rd, Rn, imm12, SUB)
+#define A64_ADDS_I(sf, Rd, Rn, imm12) \
+	A64_ADDSUB_IMM(sf, Rd, Rn, imm12, ADD_SETFLAGS)
+#define A64_SUBS_I(sf, Rd, Rn, imm12) \
+	A64_ADDSUB_IMM(sf, Rd, Rn, imm12, SUB_SETFLAGS)
+/* Rn + imm12; set condition flags */
+#define A64_CMN_I(sf, Rn, imm12) A64_ADDS_I(sf, A64_ZR, Rn, imm12)
+/* Rn - imm12; set condition flags */
+#define A64_CMP_I(sf, Rn, imm12) A64_SUBS_I(sf, A64_ZR, Rn, imm12)
 /* Rd = Rn */
 #define A64_MOV(sf, Rd, Rn) A64_ADD_I(sf, Rd, Rn, 0)
 
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 083e5d8a5e2c..561a2fea9cdd 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -167,6 +167,12 @@ static inline int epilogue_offset(const struct jit_ctx *ctx)
 	return to - from;
 }
 
+static bool is_addsub_imm(u32 imm)
+{
+	/* Either imm12 or shifted imm12. */
+	return !(imm & ~0xfff) || !(imm & ~0xfff000);
+}
+
 /* Stack must be multiples of 16B */
 #define STACK_ALIGN(sz) (((sz) + 15) & ~15)
 
@@ -479,13 +485,25 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	/* dst = dst OP imm */
 	case BPF_ALU | BPF_ADD | BPF_K:
 	case BPF_ALU64 | BPF_ADD | BPF_K:
-		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_ADD(is64, dst, dst, tmp), ctx);
+		if (is_addsub_imm(imm)) {
+			emit(A64_ADD_I(is64, dst, dst, imm), ctx);
+		} else if (is_addsub_imm(-imm)) {
+			emit(A64_SUB_I(is64, dst, dst, -imm), ctx);
+		} else {
+			emit_a64_mov_i(is64, tmp, imm, ctx);
+			emit(A64_ADD(is64, dst, dst, tmp), ctx);
+		}
 		break;
 	case BPF_ALU | BPF_SUB | BPF_K:
 	case BPF_ALU64 | BPF_SUB | BPF_K:
-		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_SUB(is64, dst, dst, tmp), ctx);
+		if (is_addsub_imm(imm)) {
+			emit(A64_SUB_I(is64, dst, dst, imm), ctx);
+		} else if (is_addsub_imm(-imm)) {
+			emit(A64_ADD_I(is64, dst, dst, -imm), ctx);
+		} else {
+			emit_a64_mov_i(is64, tmp, imm, ctx);
+			emit(A64_SUB(is64, dst, dst, tmp), ctx);
+		}
 		break;
 	case BPF_ALU | BPF_AND | BPF_K:
 	case BPF_ALU64 | BPF_AND | BPF_K:
@@ -639,8 +657,14 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP32 | BPF_JSLT | BPF_K:
 	case BPF_JMP32 | BPF_JSGE | BPF_K:
 	case BPF_JMP32 | BPF_JSLE | BPF_K:
-		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_CMP(is64, dst, tmp), ctx);
+		if (is_addsub_imm(imm)) {
+			emit(A64_CMP_I(is64, dst, imm), ctx);
+		} else if (is_addsub_imm(-imm)) {
+			emit(A64_CMN_I(is64, dst, -imm), ctx);
+		} else {
+			emit_a64_mov_i(is64, tmp, imm, ctx);
+			emit(A64_CMP(is64, dst, tmp), ctx);
+		}
 		goto emit_cond_jmp;
 	case BPF_JMP | BPF_JSET | BPF_K:
 	case BPF_JMP32 | BPF_JSET | BPF_K:
-- 
2.17.1

