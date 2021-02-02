Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC2730B73F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 06:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhBBFji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 00:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhBBFjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 00:39:36 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08137C061794;
        Mon,  1 Feb 2021 21:38:41 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j11so9222595plt.11;
        Mon, 01 Feb 2021 21:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tuBSTwav67Zz0/G+nU2FCImA/MbR1giOSIQ4KMxUDlc=;
        b=Wk+olFUlmi5fO1atmIFs4xCLvxAmkhRkloMWl/pA5e1/8z4+fDQ0ctNoHWV4lsa/br
         C6w3rIjg0VQDODQTs9lKuGfbUbo0zCqFaKf8tVrbiKK6YClAsKAXosPIzQtxkzNvC9V3
         L7ht9bDtvcstGAf6/cqKr8xMdt3zcEGc4Ku5P7LL3qR2wKTzq2N5Hs7YwP2BJNSE6wCJ
         HIOLO4dsFZ5vkC5scWxtyc1QqqR9wHwdS71VTNuIwIaejMPo/qST5TJanKu3liVW3fbv
         o1rQ7gVBakLd3+e1NaMagSuX7VUgaaTvkHxnPK3QMTfKdb/c294UBWLg4dDNU04T5Uaq
         /vGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tuBSTwav67Zz0/G+nU2FCImA/MbR1giOSIQ4KMxUDlc=;
        b=tGrduwh/cVTuwdJtvqKohy4pRuaXhtgZ8f4/ZZtzxsPD7GFbYtOCUlJOg+XG5YQh+U
         6bZAMNoJl14bgynALphqX+PW/lQWEhPpze7JvetebnTiUnhOPpHIMDd4rPISCmyAkfRY
         OLJ5HjOCxT7RmaPVxgrgkzYzFAniog5aY2wxCxYnwPCBeVmlQG+poHOxNJ0sdGx4DZee
         ClP95jG/Fts8QeKCZs/69jxY4c4XPV0PYkfzdKaVXtw90XUYBcdLB7+E577A0Uvqo4Ng
         aswO6Z3r3Ll7KrqgadmUCTeRxv0qzR6T6V3MhQlVn1NlCRz3Uwph8reWAstMQpDcDC28
         ygvQ==
X-Gm-Message-State: AOAM533tq6wBdhe2U8FCFYpby6li70aOyaF7tIdhhdGIaHhkWQLaQ3Xk
        vXAReLAnJJlbubhx6tDVSuB67b7dCY4=
X-Google-Smtp-Source: ABdhPJzj8nEwNu6tylW6rpAkEUO9Vw70X9r57FPXNZ1Y44NsxHmo2YTBMoBTRtJpJihEVY3TTOTz7A==
X-Received: by 2002:a17:902:f703:b029:de:9a3a:6902 with SMTP id h3-20020a170902f703b02900de9a3a6902mr20676879plo.68.1612244320407;
        Mon, 01 Feb 2021 21:38:40 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id bk18sm1291582pjb.41.2021.02.01.21.38.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Feb 2021 21:38:39 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Emit explicit NULL pointer checks for PROBE_LDX instructions.
Date:   Mon,  1 Feb 2021 21:38:37 -0800
Message-Id: <20210202053837.95909-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

PTR_TO_BTF_ID registers contain either kernel pointer or NULL.
Emit the NULL check explicitly by JIT instead of going into
do_user_addr_fault() on NULL deference.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index b7a2911bda77..a3dc3bd154ac 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -930,6 +930,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		u32 dst_reg = insn->dst_reg;
 		u32 src_reg = insn->src_reg;
 		u8 b2 = 0, b3 = 0;
+		u8 *start_of_ldx;
 		s64 jmp_offset;
 		u8 jmp_cond;
 		u8 *func;
@@ -1278,12 +1279,30 @@ st:			if (is_imm8(insn->off))
 		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
 		case BPF_LDX | BPF_MEM | BPF_DW:
 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
+			if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
+				/* test src_reg, src_reg */
+				maybe_emit_mod(&prog, src_reg, src_reg, true); /* always 1 byte */
+				EMIT2(0x85, add_2reg(0xC0, src_reg, src_reg));
+				/* jne start_of_ldx */
+				EMIT2(X86_JNE, 0);
+				/* xor dst_reg, dst_reg */
+				emit_mov_imm32(&prog, false, dst_reg, 0);
+				/* jmp byte_after_ldx */
+				EMIT2(0xEB, 0);
+
+				/* populate jmp_offset for JNE above */
+				temp[4] = prog - temp - 5 /* sizeof(test + jne) */;
+				start_of_ldx = prog;
+			}
 			emit_ldx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
 			if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
 				struct exception_table_entry *ex;
 				u8 *_insn = image + proglen;
 				s64 delta;
 
+				/* populate jmp_offset for JMP above */
+				start_of_ldx[-1] = prog - start_of_ldx;
+
 				if (!bpf_prog->aux->extable)
 					break;
 
-- 
2.24.1

