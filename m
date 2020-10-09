Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753D7287FD3
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgJIBMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbgJIBMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 21:12:51 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6FBC0613D5;
        Thu,  8 Oct 2020 18:12:51 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id q123so5463294pfb.0;
        Thu, 08 Oct 2020 18:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vDpdwGTb8iUWFZjaTWPEQf/T2hOZ8LtQp7hjPN2NHiQ=;
        b=pfH8mHhjC8nXeLruxzef1xLxah5dLlAuhLDIms8OnVwWvgNMPU3IygPNEpIo2VoCSC
         StGRZ3SaVrr8ZZq5pVVaFYrDjZVPAOloEtSej1bcbm8zTINikKdvwklZwaPih8CIMb3e
         yEVlbmdj3R0mLcIvGLMzzLlP9DO72AGOvPm9+0Dep1peUOlDcJ13QVauUMgzc+Fji660
         GBAcW4nWZfswhC0VH3EPcOcTJGTb/n4QiVZ0860/6L9V1AONpACBBQeQgVELxkmCVXIl
         HdqtVcBXG95Odw/Brf723UO23j86Eg5yFYwaVeNzVzACJHB/DJdiBalkN8m/35Ha6lwD
         UJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vDpdwGTb8iUWFZjaTWPEQf/T2hOZ8LtQp7hjPN2NHiQ=;
        b=Q97z5hPQskjS8ZrIXjYaciPXF/0HxgjsB6moViOnH5X6jtP4sKGVKs4qUpieRz/FMA
         sDgpdQuL4buKmzlSryY3N/ZiPjnVLXHZCYV4+g0shXvAOsR4ajQcxH+RcEstRKr3XyvK
         qOP7Qbf9jDfntflaUy3uL/UdVFwo2LlfF9BN0AA3QDwbo6x5U94ffqYu6cCl/WuncJ7S
         RGljNqccNw1bXyOo5QPW5gwvsm90GvImLD2blg6eXoSDZCmeo8cTyVAbI+B5UDFmWH2x
         LJzmkSpb+kb91fpb2NWgSCnujrZ70ha63n2p98fKVIYyPPBS8+g3fG9sJrOB+TCZYnBC
         hk4g==
X-Gm-Message-State: AOAM5311jpX7mVCGBjilwgWd7fQ7mlWYuVQWZN+7Y69c1WoIdES8PkOu
        E3y1fk806NJZeldt25i6UJM=
X-Google-Smtp-Source: ABdhPJx86lMG41mxFJU/GJQ/kaTTAW3ruixNjqEnqP4kb6cgfZ3Wkar2xPGwr2Ew+IqYroy/BETo6A==
X-Received: by 2002:a17:90a:ff06:: with SMTP id ce6mr1734175pjb.38.1602205970718;
        Thu, 08 Oct 2020 18:12:50 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id k15sm8275822pfp.217.2020.10.08.18.12.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 18:12:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: Asm tests for the verifier regalloc tracking.
Date:   Thu,  8 Oct 2020 18:12:40 -0700
Message-Id: <20201009011240.48506-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add asm tests for register allocator tracking logic.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../testing/selftests/bpf/verifier/regalloc.c | 243 ++++++++++++++++++
 1 file changed, 243 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c

diff --git a/tools/testing/selftests/bpf/verifier/regalloc.c b/tools/testing/selftests/bpf/verifier/regalloc.c
new file mode 100644
index 000000000000..ac71b824f97a
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/regalloc.c
@@ -0,0 +1,243 @@
+{
+	"regalloc basic",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 8),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 20, 4),
+	BPF_JMP_IMM(BPF_JSLT, BPF_REG_2, 0, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc negative",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 8),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 24, 4),
+	BPF_JMP_IMM(BPF_JSLT, BPF_REG_2, 0, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = REJECT,
+	.errstr = "invalid access to map value, value_size=48 off=48 size=1",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc src_reg mark",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 20, 5),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_JMP_REG(BPF_JSGE, BPF_REG_3, BPF_REG_2, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc src_reg negative",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 22, 5),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_JMP_REG(BPF_JSGE, BPF_REG_3, BPF_REG_2, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = REJECT,
+	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc and spill",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 11),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 20, 7),
+	/* r0 has upper bound that should propagate into r2 */
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -8), /* spill r2 */
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_2, 0), /* clear r0 and r2 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_10, -8), /* fill r3 */
+	BPF_JMP_REG(BPF_JSGE, BPF_REG_0, BPF_REG_3, 2),
+	/* r3 has lower and upper bounds */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_3),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc and spill negative",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 11),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 48, 7),
+	/* r0 has upper bound that should propagate into r2 */
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -8), /* spill r2 */
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_2, 0), /* clear r0 and r2 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_10, -8), /* fill r3 */
+	BPF_JMP_REG(BPF_JSGE, BPF_REG_0, BPF_REG_3, 2),
+	/* r3 has lower and upper bounds */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_3),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = REJECT,
+	.errstr = "invalid access to map value, value_size=48 off=48 size=8",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc three regs",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 10),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_2),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 12, 5),
+	BPF_JMP_IMM(BPF_JSLT, BPF_REG_2, 0, 4),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_4),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc after call",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 10),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_9, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 6),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_8, 20, 4),
+	BPF_JMP_IMM(BPF_JSLT, BPF_REG_9, 0, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_8),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_9),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc in callee",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_7),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_1, 20, 5),
+	BPF_JMP_IMM(BPF_JSLT, BPF_REG_2, 0, 4),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_3, BPF_REG_1),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_3, BPF_REG_2),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_3, 0),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
-- 
2.23.0

