Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBBE1A00FF
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 00:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgDFWQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 18:16:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34370 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgDFWQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 18:16:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id l14so730061pgb.1
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 15:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id;
        bh=I8Ag8RJmxCZk7aftpHG1/aOT8pIgsaZRRBMA74l4szs=;
        b=M8J8NhOnd6VsGu2mROnqMiucZGBJHkCFpdPuRUXTHrWBoiRpSX/zdOAAme47f8IpmO
         LbxP9RDtmYBA4sFMzviQSaX6l/c2ApCo5J9ZISFFgE3ic036efVrwB2nD7wkS1aBm/gE
         pEWLs6KKpMP1482IJ5rRxQ3ubJH7OiJ35zFuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I8Ag8RJmxCZk7aftpHG1/aOT8pIgsaZRRBMA74l4szs=;
        b=irpqKDIDWh6NTsw+gQ0QvyT3RedcxcSEvak3tP2acFcYbqLF4TEjLFxaD7Ns5tZsuQ
         5wFVKMAuscTyzETQ9PaZfFSXFnGZKHBhKEmCbD7PhVq6O1Vx+74nNdEqqBegi4jW9dZw
         m3gFUva3Sv8+/a/CY98SGDE6AVCTqv5JldDlfIb+22cCCRaIstRH1oUOHVoEW433kdCQ
         +pSw9+JfJ76QHfeSzTpVqVr7P08GxrtEvepvKn+tx19Jdg+fr8lUN+Tk/hgfMHYHGTGo
         GPlmyPKKqLP5LRTronygXLpvimnwWKy+C/28S1hR24FagXwlZoLxhNG+pHG8tJF2R1sI
         Wy0A==
X-Gm-Message-State: AGi0PuafsRWWntwjRhKjA+B8FmkHcwzY1r4hapJU6KyJYh/k3Ff8NGuC
        ZYTJLy7kKn0zh+xJIyNIR4EQUw==
X-Google-Smtp-Source: APiQypLGxqHjlTUmIKxBeT61WxtzGWT1x2WVVzwD4uK2qvte99BMAMa7HumrAI/VX29+HNxtKillxg==
X-Received: by 2002:a63:dd09:: with SMTP id t9mr1182732pgg.432.1586211388598;
        Mon, 06 Apr 2020 15:16:28 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id s12sm11714998pgi.38.2020.04.06.15.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 15:16:28 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Xi Wang <xi.wang@gmail.com>, Luke Nelson <luke.r.nels@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf] riscv, bpf: Fix offset range checking for auipc+jalr on RV64
Date:   Mon,  6 Apr 2020 22:16:04 +0000
Message-Id: <20200406221604.18547-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing code in emit_call on RV64 checks that the PC-relative offset
to the function fits in 32 bits before calling emit_jump_and_link to emit
an auipc+jalr pair. However, this check is incorrect because offsets in
the range [2^31 - 2^11, 2^31 - 1] cannot be encoded using auipc+jalr on
RV64 (see discussion [1]). The RISC-V spec has recently been updated
to reflect this fact [2, 3].

This patch fixes the problem by moving the check on the offset into
emit_jump_and_link and modifying it to the correct range of encodable
offsets, which is [-2^31 - 2^11, 2^31 - 2^11). This also enforces the
check on the offset to other uses of emit_jump_and_link (e.g., BPF_JA)
as well.

Currently, this bug is unlikely to be triggered, because the memory
region from which JITed images are allocated is close enough to kernel
text for the offsets to not become too large; and because the bounds on
BPF program size are small enough. This patch prevents this problem from
becoming an issue if either of these change.

[1]: https://groups.google.com/a/groups.riscv.org/forum/#!topic/isa-dev/bwWFhBnnZFQ
[2]: https://github.com/riscv/riscv-isa-manual/commit/b1e42e09ac55116dbf9de5e4fb326a5a90e4a993
[3]: https://github.com/riscv/riscv-isa-manual/commit/4c1b2066ebd2965a422e41eb262d0a208a7fea07

Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit_comp64.c | 49 +++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index cc1985d8750a..d208a9fd6c52 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -110,6 +110,16 @@ static bool is_32b_int(s64 val)
 	return -(1L << 31) <= val && val < (1L << 31);
 }
 
+static bool in_auipc_jalr_range(s64 val)
+{
+	/*
+	 * auipc+jalr can reach any signed PC-relative offset in the range
+	 * [-2^31 - 2^11, 2^31 - 2^11).
+	 */
+	return (-(1L << 31) - (1L << 11)) <= val &&
+		val < ((1L << 31) - (1L << 11));
+}
+
 static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 {
 	/* Note that the immediate from the add is sign-extended,
@@ -380,20 +390,24 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
 	*rd = RV_REG_T2;
 }
 
-static void emit_jump_and_link(u8 rd, s64 rvoff, bool force_jalr,
-			       struct rv_jit_context *ctx)
+static int emit_jump_and_link(u8 rd, s64 rvoff, bool force_jalr,
+			      struct rv_jit_context *ctx)
 {
 	s64 upper, lower;
 
 	if (rvoff && is_21b_int(rvoff) && !force_jalr) {
 		emit(rv_jal(rd, rvoff >> 1), ctx);
-		return;
+		return 0;
+	} else if (in_auipc_jalr_range(rvoff)) {
+		upper = (rvoff + (1 << 11)) >> 12;
+		lower = rvoff & 0xfff;
+		emit(rv_auipc(RV_REG_T1, upper), ctx);
+		emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
+		return 0;
 	}
 
-	upper = (rvoff + (1 << 11)) >> 12;
-	lower = rvoff & 0xfff;
-	emit(rv_auipc(RV_REG_T1, upper), ctx);
-	emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
+	pr_err("bpf-jit: target offset 0x%llx is out of range\n", rvoff);
+	return -ERANGE;
 }
 
 static bool is_signed_bpf_cond(u8 cond)
@@ -407,18 +421,16 @@ static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
 	s64 off = 0;
 	u64 ip;
 	u8 rd;
+	int ret;
 
 	if (addr && ctx->insns) {
 		ip = (u64)(long)(ctx->insns + ctx->ninsns);
 		off = addr - ip;
-		if (!is_32b_int(off)) {
-			pr_err("bpf-jit: target call addr %pK is out of range\n",
-			       (void *)addr);
-			return -ERANGE;
-		}
 	}
 
-	emit_jump_and_link(RV_REG_RA, off, !fixed, ctx);
+	ret = emit_jump_and_link(RV_REG_RA, off, !fixed, ctx);
+	if (ret)
+		return ret;
 	rd = bpf_to_rv_reg(BPF_REG_0, ctx);
 	emit(rv_addi(rd, RV_REG_A0, 0), ctx);
 	return 0;
@@ -429,7 +441,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 {
 	bool is64 = BPF_CLASS(insn->code) == BPF_ALU64 ||
 		    BPF_CLASS(insn->code) == BPF_JMP;
-	int s, e, rvoff, i = insn - ctx->prog->insnsi;
+	int s, e, rvoff, ret, i = insn - ctx->prog->insnsi;
 	struct bpf_prog_aux *aux = ctx->prog->aux;
 	u8 rd = -1, rs = -1, code = insn->code;
 	s16 off = insn->off;
@@ -699,7 +711,9 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
 		rvoff = rv_offset(i, off, ctx);
-		emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		ret = emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		if (ret)
+			return ret;
 		break;
 
 	/* IF (dst COND src) JUMP off */
@@ -801,7 +815,6 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_JMP | BPF_CALL:
 	{
 		bool fixed;
-		int ret;
 		u64 addr;
 
 		mark_call(ctx);
@@ -826,7 +839,9 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			break;
 
 		rvoff = epilogue_offset(ctx);
-		emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		ret = emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		if (ret)
+			return ret;
 		break;
 
 	/* dst = imm64 */
-- 
2.17.1

