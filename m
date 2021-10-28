Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBC843DB3E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhJ1Ghk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhJ1Ghj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33649C061570;
        Wed, 27 Oct 2021 23:35:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s10-20020a17090a6e4a00b001a5f4da9892so19013pjm.3;
        Wed, 27 Oct 2021 23:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g40Z1ieSULg3LhXRnp8SpdBkbCADyrSE2qthlKgwJKw=;
        b=BNXxfDtYrof18QRqAJJmXqe4hwTG0t4slcQg8t79bC9KwPsa0gGmQk7Xg9AfM2eleC
         5SWtGnt/eqds8B1aMIkfcEl5mjTVTYR+liCf4UVx66Q84XUdf5NDgwJ/6Dmr82L0KSmR
         LBfsdxNjcaEV9QX5u0JmM4J0LRPhFJkY6F1dtv/GHiTbVDYnd56JDN9+spM1rH3i0Rht
         8+Gm7bsxQmUZggthkAI37RbC9LUAqPuh23IM/Xrbs0j0acdBzd0VAfELBt8SThOveUHx
         qhQO2xB52D56/SCVVJwuH+MAdHU0inuc/vkTvyGlOcrKxM9InC0BTuAZKAEsp1/5fFHi
         o/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g40Z1ieSULg3LhXRnp8SpdBkbCADyrSE2qthlKgwJKw=;
        b=XD76RuBVA4H27QlhERibsRmZZQn2vgcM6u02l/vhIJl4+biNmWF5WJJvVsk3TpoEoU
         4G04Dd88V5uHyBqnVu+1ZlnDqpLuf62sxNnn79ifM28/nxsAy9H5qJ7lH42zr75tqKe/
         HBkjSRHUvLLMjefGCcFjS2X/Nr6ign54cDEUMg0TWSO/konzrJsSdpRKVhvPMCQQstfv
         /8kAlsmsBnJZwYZPs0Tly1uc1DSpY6fhbTdraXwbe5K6aGv/MUADxqSvZLOxM0kb+TlX
         pi3AwHaowJ9fZPBF/+5SA/3AA9y3NCJGoX+A9B5xF73b6UVa2GHHa3jTEBP51qtrwp/h
         S+tA==
X-Gm-Message-State: AOAM530h97VBwXi9sEd51/WHw/8UkGGOQ0e15is6f20EFYkWOesxBsjY
        58+JKKC3e3RGatbgT1jXCEYOvLhMh3GPCw==
X-Google-Smtp-Source: ABdhPJwCIdcA3Hzqmzi1Um35lZ3iv1SuU34g5djNGYcS279lfCH5pkH2x/23MsLyJEFjVLj0jdF3/Q==
X-Received: by 2002:a17:90a:d245:: with SMTP id o5mr2510920pjw.104.1635402912584;
        Wed, 27 Oct 2021 23:35:12 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id oc12sm1699038pjb.17.2021.10.27.23.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:12 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 3/8] libbpf: Add weak ksym support to gen_loader
Date:   Thu, 28 Oct 2021 12:04:56 +0530
Message-Id: <20211028063501.2239335-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028063501.2239335-1-memxor@gmail.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4419; h=from:subject; bh=rLpw7iMOrxxAu18b1PGXg+GrO/7ONDH0WAwKpGcoBL0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR//sWno3JA26jrNaiR2qssr6vhaNVfGDIhsgxB eBbWcV6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfwAKCRBM4MiGSL8RykdeD/ 0WQPTCHQVVArlHep06qH2O90UA21+FwJjRA+xJj4vMUiNwAMpJj5YYyGl9MERKAbQW0ReB58hxl8Bw vjoQp79BQdrX6SzorukFvD64Agoc5EjW8GT4yRp7KS84LTj7q9PpXO6KedvM9dnY6+8/0DekEzSYKe R0GBT78znGlzA6bPsIxjJHGcMKZ7vMSueAALH8sPzkRJGyMypz4V61OG+6UBG2mmTfKLVTqiH46bnP 7gvYmCFeb0nKF5arTSY0ZejcfUbsfV3rPvdvvV7oeV76WPQwsIom3VsTNiUFgLYZ84ACHfC7MC0SMj xyqIkbesQlqvbNjFpwCFm4ajGA6qPXP2UKDp0g//D56drCA2i4WoHiHExJx+ZR8PMqBrQWJUt/X2kf OxjnyAZTj+4StAjSyYoRfQnoTKhnd7DIKKUzw1TRGBeT+nAi+pvL0chArxorwtnRerRMNbBOvD4A0r eV0D4UAlbHuSqICf7krPo2rGuJBLQAL83tG1qyOHIqiLd/43NfBTQB66ZvjJcM6GMs3b7FVwS/BFXq U2IquUeWwZwddxkimumoGyZqMxsMbO3V/iufTwx1iPRB63yE/vh9/cnJEwD4ggpp/nPjebPpPC7muv 5Jcs0pHnHe4A6nitENXfB3px+MZYHVslvTq2AuzHxBtLoxZhZXhBPoWUFzCg==
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
 tools/lib/bpf/gen_loader.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 11172a868180..1c404752e565 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -13,6 +13,7 @@
 #include "hashmap.h"
 #include "bpf_gen_internal.h"
 #include "skel_internal.h"
+#include <asm/byteorder.h>
 
 #define MAX_USED_MAPS	64
 #define MAX_USED_PROGS	32
@@ -776,12 +777,24 @@ static void emit_relo_ksym_typeless(struct bpf_gen *gen,
 	emit_ksym_relo_log(gen, relo, kdesc->ref);
 }
 
+static __u32 src_reg_mask(void)
+{
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	return 0x0f; /* src_reg,dst_reg,... */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	return 0xf0; /* dst_reg,src_reg,... */
+#else
+#error "Unsupported bit endianness, cannot proceed"
+#endif
+}
+
 /* Expects:
  * BPF_REG_8 - pointer to instruction
  */
 static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
 {
 	struct ksym_desc *kdesc;
+	__u32 reg_mask;
 
 	kdesc = get_ksym_desc(gen, relo);
 	if (!kdesc)
@@ -792,19 +805,35 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
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
+	reg_mask = src_reg_mask();
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	emit(gen, BPF_ALU32_IMM(BPF_AND, BPF_REG_9, reg_mask));
+	emit(gen, BPF_STX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, offsetofend(struct bpf_insn, code)));
+
 	emit_ksym_relo_log(gen, relo, kdesc->ref);
 }
 
-- 
2.33.1

