Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E75439B8
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbfFMPPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:15:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732216AbfFMNX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:23:57 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 132F83082126;
        Thu, 13 Jun 2019 13:23:57 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C325351C66;
        Thu, 13 Jun 2019 13:23:52 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: [PATCH 9/9] x86/bpf: Convert MOV function/macro argument ordering to AT&T syntax
Date:   Thu, 13 Jun 2019 08:21:06 -0500
Message-Id: <38ff1c9af6fc572aa962f171413dc7495453584c.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560431531.git.jpoimboe@redhat.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 13 Jun 2019 13:23:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the comments have been converted to AT&T syntax, swap the order
of the src/dst arguments in the MOV-related functions and macros to
match the ordering of AT&T syntax.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/net/bpf_jit_comp.c | 44 ++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index a92c2445441d..0d0e96f84992 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -59,9 +59,9 @@ static bool is_uimm32(u64 value)
 }
 
 /* mov src, dst */
-#define EMIT_mov(DST, SRC)								 \
+#define EMIT_mov(SRC, DST)								 \
 	do {										 \
-		if (DST != SRC)								 \
+		if (SRC != DST)								 \
 			EMIT3(add_2mod(0x48, DST, SRC), 0x89, add_2reg(0xC0, DST, SRC)); \
 	} while (0)
 
@@ -352,7 +352,7 @@ static void emit_bpf_tail_call(u8 **pprog)
 }
 
 static void emit_mov_imm32(u8 **pprog, bool sign_propagate,
-			   u32 dst_reg, const u32 imm32)
+			   const u32 imm32, u32 dst_reg)
 {
 	u8 *prog = *pprog;
 	u8 b1, b2, b3;
@@ -392,8 +392,8 @@ static void emit_mov_imm32(u8 **pprog, bool sign_propagate,
 	*pprog = prog;
 }
 
-static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
-			   const u32 imm32_hi, const u32 imm32_lo)
+static void emit_mov_imm64(u8 **pprog, const u32 imm32_hi, const u32 imm32_lo,
+			   u32 dst_reg)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
@@ -405,7 +405,7 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
 		 * directly, so save couple of bytes by just doing
 		 * 'mov imm32, %eax' instead.
 		 */
-		emit_mov_imm32(&prog, false, dst_reg, imm32_lo);
+		emit_mov_imm32(&prog, false, imm32_lo, dst_reg);
 	} else {
 		/* movabs imm64, %rax */
 		EMIT2(add_1mod(0x48, dst_reg), add_1reg(0xB8, dst_reg));
@@ -416,17 +416,17 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
 	*pprog = prog;
 }
 
-static void emit_mov_reg(u8 **pprog, bool is64, u32 dst_reg, u32 src_reg)
+static void emit_mov_reg(u8 **pprog, bool is64, u32 src_reg, u32 dst_reg)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
 
 	if (is64) {
 		/* mov src, dst */
-		EMIT_mov(dst_reg, src_reg);
+		EMIT_mov(src_reg, dst_reg);
 	} else {
 		/* mov32 src, dst */
-		if (is_ereg(dst_reg) || is_ereg(src_reg))
+		if (is_ereg(src_reg) || is_ereg(dst_reg))
 			EMIT1(add_2mod(0x40, dst_reg, src_reg));
 		EMIT2(0x89, add_2reg(0xC0, dst_reg, src_reg));
 	}
@@ -487,7 +487,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ALU | BPF_MOV | BPF_X:
 			emit_mov_reg(&prog,
 				     BPF_CLASS(insn->code) == BPF_ALU64,
-				     dst_reg, src_reg);
+				     src_reg, dst_reg);
 			break;
 
 			/* neg dst */
@@ -553,11 +553,11 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ALU64 | BPF_MOV | BPF_K:
 		case BPF_ALU | BPF_MOV | BPF_K:
 			emit_mov_imm32(&prog, BPF_CLASS(insn->code) == BPF_ALU64,
-				       dst_reg, imm32);
+				       imm32, dst_reg);
 			break;
 
 		case BPF_LD | BPF_IMM | BPF_DW:
-			emit_mov_imm64(&prog, dst_reg, insn[1].imm, insn[0].imm);
+			emit_mov_imm64(&prog, insn[1].imm, insn[0].imm, dst_reg);
 			insn++;
 			i++;
 			break;
@@ -576,13 +576,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 			if (BPF_SRC(insn->code) == BPF_X)
 				/* mov src_reg, %r11 */
-				EMIT_mov(AUX_REG, src_reg);
+				EMIT_mov(src_reg, AUX_REG);
 			else
 				/* mov imm32, %r11 */
 				EMIT3_off32(0x49, 0xC7, 0xC3, imm32);
 
 			/* mov dst_reg, %rax */
-			EMIT_mov(BPF_REG_0, dst_reg);
+			EMIT_mov(dst_reg, BPF_REG_0);
 
 			/*
 			 * xor %edx, %edx
@@ -608,7 +608,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			EMIT1(0x58); /* pop %rax */
 
 			/* mov %r11, dst_reg */
-			EMIT_mov(dst_reg, AUX_REG);
+			EMIT_mov(AUX_REG, dst_reg);
 			break;
 
 		case BPF_ALU | BPF_MUL | BPF_K:
@@ -624,12 +624,12 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				EMIT1(0x52); /* push %rdx */
 
 			/* mov dst_reg, %r11 */
-			EMIT_mov(AUX_REG, dst_reg);
+			EMIT_mov(dst_reg, AUX_REG);
 
 			if (BPF_SRC(insn->code) == BPF_X)
-				emit_mov_reg(&prog, is64, BPF_REG_0, src_reg);
+				emit_mov_reg(&prog, is64, src_reg, BPF_REG_0);
 			else
-				emit_mov_imm32(&prog, is64, BPF_REG_0, imm32);
+				emit_mov_imm32(&prog, is64, imm32, BPF_REG_0);
 
 			if (is64)
 				EMIT1(add_1mod(0x48, AUX_REG));
@@ -642,7 +642,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				EMIT1(0x5A); /* pop %rdx */
 			if (dst_reg != BPF_REG_0) {
 				/* mov %rax, dst_reg */
-				EMIT_mov(dst_reg, BPF_REG_0);
+				EMIT_mov(BPF_REG_0, dst_reg);
 				EMIT1(0x58); /* pop %rax */
 			}
 			break;
@@ -681,7 +681,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			/* Check for bad case when dst_reg == %rcx */
 			if (dst_reg == BPF_REG_4) {
 				/* mov dst_reg, %r11 */
-				EMIT_mov(AUX_REG, dst_reg);
+				EMIT_mov(dst_reg, AUX_REG);
 				dst_reg = AUX_REG;
 			}
 
@@ -689,7 +689,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				EMIT1(0x51); /* push %rcx */
 
 				/* mov src_reg, %rcx */
-				EMIT_mov(BPF_REG_4, src_reg);
+				EMIT_mov(src_reg, BPF_REG_4);
 			}
 
 			/* shl %cl, %rax | shr %cl, %rax | sar %cl, %rax */
@@ -710,7 +710,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 			if (insn->dst_reg == BPF_REG_4)
 				/* mov %r11, dst_reg */
-				EMIT_mov(insn->dst_reg, AUX_REG);
+				EMIT_mov(AUX_REG, insn->dst_reg);
 			break;
 
 		case BPF_ALU | BPF_END | BPF_FROM_BE:
-- 
2.20.1

