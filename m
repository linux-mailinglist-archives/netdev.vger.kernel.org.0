Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8625028E5C7
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgJNR4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgJNR4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 13:56:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE66C061755;
        Wed, 14 Oct 2020 10:56:13 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e7so236609pfn.12;
        Wed, 14 Oct 2020 10:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=i5ZBQYPbVVeY387O8tMq4XxmBEBI4/xwYg8DRWWTk9M=;
        b=hE2CXlpfqgFUIIIGVvAmwvm6RB0buuU/f61LiHEyYCgHrqhiTPKGWQuqaDavfjIR4l
         6VSrjTF6JuTBfv7KsL3QArMbw0w4QqgBrQhZPkMBKbYrDX7EMgx617ngVXfoRboiDsBJ
         AY9bBeEnzLiX9odbHDEFQV5d8bjDDIBORQZsm6+pfTceSo7orfwBA/pjQd32NBIMBofX
         A4+JYLVopYo4RYEhRV/Bav8ScJIvAtZgCJx5lBXEBhQLTG70y6dTC0q/tRs8BZ2Q/FlE
         AvP9XWAW1akUDQH8M7Rx2OLg7PHpnKhvAKkYeNl4LO88r8d9yoh+dXTdckzreBgQVlyq
         aEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i5ZBQYPbVVeY387O8tMq4XxmBEBI4/xwYg8DRWWTk9M=;
        b=ZgiGoYfDMFCV2dopSOqU0u+kfctqz62JxSBH0EzaqzYoYX/zl6WZihMa3hPgDEw/D3
         2Mv7wZpPhTHfaP8yXsOvS4YjhK7Sn12K8aPfgB3avdVA98rXT+ng73lW16G+91Tr05W3
         50Oa4S0TJXXL3iPUA/YRetXuZt7hqU1kwOeDjOLvm0hsGqLCm2Zfo5iuWM0hJ/Cf+4NO
         KL7HsWLGIP/1+5Si6xqC7xd69w1UAdnbYS+8FE1QAeH0VrMcMy/HLYtS7z7TiIJtkpb8
         u/4D8ONoijCDAMyQsY0sUeKgOMksWTkoXGEbk1WJ4BzIONmWB+Xs0WYwLtVyClq83Jv0
         ciog==
X-Gm-Message-State: AOAM532YKEjMzFdMneyu6EG1Nz+DbBcuBgErbvdnULAjVP6sRHYY9RO1
        X5tYcdpxRVlt3vvXrbRLPgs=
X-Google-Smtp-Source: ABdhPJwuh2oHUl5Ip6h+JdGOlho5vbP02R8mzTQT4Yu/5GTNZ8ACFgMXiqy3/vuc03wHjl80VsFUBQ==
X-Received: by 2002:aa7:9255:0:b029:158:ca2e:3f33 with SMTP id 21-20020aa792550000b0290158ca2e3f33mr435839pfp.59.1602698170987;
        Wed, 14 Oct 2020 10:56:10 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id q123sm260314pfq.56.2020.10.14.10.56.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2020 10:56:10 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Fix register equivalence tracking.
Date:   Wed, 14 Oct 2020 10:56:08 -0700
Message-Id: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
true or false branch. In the case 'if (reg->id)' check was done on the other
branch the counter part register would have reg->id == 0 when called into
find_equal_scalars(). In such case the helper would incorrectly identify other
registers with id == 0 as equivalent and propagate the state incorrectly.
Fix it by preserving ID across reg_set_min_max().
In other words any kind of comparison operator on the scalar register
should preserve its ID to recognize:
r1 = r2
if (r1 == 20) {
  #1 here both r1 and r2 == 20
} else if (r2 < 20) {
  #2 here both r1 and r2 < 20
}

The patch is addressing #1 case. The #2 was working correctly already.

Fixes: 75748837b7e5 ("bpf: Propagate scalar ranges through register assignments.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c                         | 38 ++++++++++++-------
 .../testing/selftests/bpf/verifier/regalloc.c | 26 +++++++++++++
 2 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c43a5e8f0818..39d7f44e7c92 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1010,14 +1010,9 @@ static const int caller_saved[CALLER_SAVED_REGS] = {
 static void __mark_reg_not_init(const struct bpf_verifier_env *env,
 				struct bpf_reg_state *reg);
 
-/* Mark the unknown part of a register (variable offset or scalar value) as
- * known to have the value @imm.
- */
-static void __mark_reg_known(struct bpf_reg_state *reg, u64 imm)
+/* This helper doesn't clear reg->id */
+static void ___mark_reg_known(struct bpf_reg_state *reg, u64 imm)
 {
-	/* Clear id, off, and union(map_ptr, range) */
-	memset(((u8 *)reg) + sizeof(reg->type), 0,
-	       offsetof(struct bpf_reg_state, var_off) - sizeof(reg->type));
 	reg->var_off = tnum_const(imm);
 	reg->smin_value = (s64)imm;
 	reg->smax_value = (s64)imm;
@@ -1030,6 +1025,17 @@ static void __mark_reg_known(struct bpf_reg_state *reg, u64 imm)
 	reg->u32_max_value = (u32)imm;
 }
 
+/* Mark the unknown part of a register (variable offset or scalar value) as
+ * known to have the value @imm.
+ */
+static void __mark_reg_known(struct bpf_reg_state *reg, u64 imm)
+{
+	/* Clear id, off, and union(map_ptr, range) */
+	memset(((u8 *)reg) + sizeof(reg->type), 0,
+	       offsetof(struct bpf_reg_state, var_off) - sizeof(reg->type));
+	___mark_reg_known(reg, imm);
+}
+
 static void __mark_reg32_known(struct bpf_reg_state *reg, u64 imm)
 {
 	reg->var_off = tnum_const_subreg(reg->var_off, imm);
@@ -7001,14 +7007,18 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 		struct bpf_reg_state *reg =
 			opcode == BPF_JEQ ? true_reg : false_reg;
 
-		/* For BPF_JEQ, if this is false we know nothing Jon Snow, but
-		 * if it is true we know the value for sure. Likewise for
-		 * BPF_JNE.
+		/* JEQ/JNE comparison doesn't change the register equivalence.
+		 * r1 = r2;
+		 * if (r1 == 42) goto label;
+		 * ...
+		 * label: // here both r1 and r2 are known to be 42.
+		 *
+		 * Hence when marking register as known preserve it's ID.
 		 */
 		if (is_jmp32)
 			__mark_reg32_known(reg, val32);
 		else
-			__mark_reg_known(reg, val);
+			___mark_reg_known(reg, val);
 		break;
 	}
 	case BPF_JSET:
@@ -7551,7 +7561,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 				reg_combine_min_max(&other_branch_regs[insn->src_reg],
 						    &other_branch_regs[insn->dst_reg],
 						    src_reg, dst_reg, opcode);
-			if (src_reg->id) {
+			if (src_reg->id &&
+			    !WARN_ON_ONCE(src_reg->id != other_branch_regs[insn->src_reg].id)) {
 				find_equal_scalars(this_branch, src_reg);
 				find_equal_scalars(other_branch, &other_branch_regs[insn->src_reg]);
 			}
@@ -7563,7 +7574,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 					opcode, is_jmp32);
 	}
 
-	if (dst_reg->type == SCALAR_VALUE && dst_reg->id) {
+	if (dst_reg->type == SCALAR_VALUE && dst_reg->id &&
+	    !WARN_ON_ONCE(dst_reg->id != other_branch_regs[insn->dst_reg].id)) {
 		find_equal_scalars(this_branch, dst_reg);
 		find_equal_scalars(other_branch, &other_branch_regs[insn->dst_reg]);
 	}
diff --git a/tools/testing/selftests/bpf/verifier/regalloc.c b/tools/testing/selftests/bpf/verifier/regalloc.c
index ac71b824f97a..4ad7e05de706 100644
--- a/tools/testing/selftests/bpf/verifier/regalloc.c
+++ b/tools/testing/selftests/bpf/verifier/regalloc.c
@@ -241,3 +241,29 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
+{
+	"regalloc, spill, JEQ",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8), /* spill r0 */
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 0),
+	/* The verifier will walk the rest twice with r0 == 0 and r0 == map_value */
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_2, 20, 0),
+	/* The verifier will walk the rest two more times with r0 == 20 and r0 == unknown */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_10, -8), /* fill r3 with map_value */
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_3, 0, 1), /* skip ldx if map_value == NULL */
+	/* Buggy verifier will think that r3 == 20 here */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_3, 0), /* read from map_value */
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
-- 
2.23.0

