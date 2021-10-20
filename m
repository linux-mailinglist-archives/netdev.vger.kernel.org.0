Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B32143539F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhJTTRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhJTTRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:17:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4C2C061749;
        Wed, 20 Oct 2021 12:15:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v8so3757141pfu.11;
        Wed, 20 Oct 2021 12:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g40Z1ieSULg3LhXRnp8SpdBkbCADyrSE2qthlKgwJKw=;
        b=fyey9zR0LqyaAoo0cldME4/Xc3pEAnZxZdfqTI0PYAA+XLlAss3HgPsxRNsjOX5jW6
         yKfkaLmQPSdfHcPcsan7VrGAwmgGstP5EEnet9rtBA//M7iuema8YqATipBnML8S78xe
         B4nmJwAd+VO9DxHC9e9FSCcdTqt0qaTevoV+nDfz6OnN8jqsZe8j7FB2+qM0WTImGi2S
         NChOvfp07hVGRNw3BaLcKib3+HB1BzxG6bW4qS/chOpkqYn9gu6HkEL+I5JY8BLYqBCN
         Py74ppf0ajain0B0Kmij611Jg5VinlN1ZMAe/H4rhv0J/syc28tCb28Zb60itbkc6b41
         +o4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g40Z1ieSULg3LhXRnp8SpdBkbCADyrSE2qthlKgwJKw=;
        b=miARXgyjzOSEnOL9ioKnwLSnnd3+b0toRcyqUZtjC1LD1ZIKG9B73tzbpPTr4nyKyX
         ByyUI7+aN3x11A3Qi+w3bXV9JzRBkzjvxjLP4e6ewz9SYRTyo7VQ6tKv/carUAVs/tNp
         LDU+VkNeB0UaoQ8rA3D8M8zwFAgI+7DGrCjF9y6ImHJuai2ctsqGR5LtbhJDg0KOYeQJ
         m+sq3jayXCRxvTN4SOyI54BaizuWfaYBm556bUohtvgIvWnONGVt6440SO/p93u9pAqu
         vyFSHmU41CsVBvLHFc1z4WCDWB42hacHq4m9jXI88w6hmTk+sp+ice0uoRI2x7IEnaxG
         BxEQ==
X-Gm-Message-State: AOAM530T5j/pgJ1C0n0AZtxF5FwWlDtHnFkfZzMf1qv4RNJmSEQUc4uS
        BZUmRbJdsEp2dzPxQT6nXfqL3gw/JtWvXA==
X-Google-Smtp-Source: ABdhPJyxG9IjULlDy5Unk/J8uHP++wcuySzFkW3F1xNdtj6kTywVtIQI3e80FAXiVTPrQF4c/b10pQ==
X-Received: by 2002:a05:6a00:888:b0:44c:c00e:189c with SMTP id q8-20020a056a00088800b0044cc00e189cmr602853pfj.79.1634757338049;
        Wed, 20 Oct 2021 12:15:38 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id fv9sm6844985pjb.26.2021.10.20.12.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:15:37 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 3/8] libbpf: Add weak ksym support to gen_loader
Date:   Thu, 21 Oct 2021 00:45:21 +0530
Message-Id: <20211020191526.2306852-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020191526.2306852-1-memxor@gmail.com>
References: <20211020191526.2306852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4419; h=from:subject; bh=rLpw7iMOrxxAu18b1PGXg+GrO/7ONDH0WAwKpGcoBL0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhcGoe/sWno3JA26jrNaiR2qssr6vhaNVfGDIhsgxB eBbWcV6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXBqHgAKCRBM4MiGSL8RynpjD/ 0cC81KqFuU6ptOws5af9/maPDZggzLSljbW+lQANVRRul99jO5RF8iYSl00JmLpZHEFgvNTkOxwcjp 0Qp2mZo4bqUZCTKq0BCZ/xV7RcGTAPSGM7fHD+qGlMEWXiUrwHwYkQO0AEYtH4DN6fn6YXl6rDBOhK xr4aMjAcBMPzsW24b5pJE7ZwECTxfPIvznX8bXIJVuzjCYzPljb69v0wMiCdEXd1X1ehHDuPSmFGvG fYG6wQaElZ7Bdp1ADIl5WbtxKLE0YXtGpiAbi+PJ//KVKDb4BPLsKdRj3ZPTgNchyfs5lmb0jGrCod e03alqRCl0h/rIHhiai7yppudJDti/juhEajGJYA577Iu75GX4taYN5lvZ63gcmvA9IvIz5zovSysx MJBtPR44ElnP2uV4jnC56Vrk4llkA/WmUbA6k4/rrysGsoT/pF///ok7qVuy5O1hK9P/1xp3EPaKGa gYF55tu1CkC0usY9jlVfoMirXpn9uxSUx5/4Pmjc4dlCfNDNonMbEE08kGa0CQ1uYtFJDzHol+VsjR G/w5PDbslXRwpbOtR/yN7UTlXr6MqDmjZ6tQKp04gcgoKOOJ8cgY/1Np6SYQUWv0Ed1PjeSbybB9SU fuqj6Gjlr1LIYfFuWg8X46ytAFbx3EgBsqWH9r3slHL7oM/vtYp3k9na6Ylw==
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

