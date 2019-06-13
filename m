Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589AD439C6
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732361AbfFMPQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:16:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732208AbfFMNXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:23:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E21E130F1BA3;
        Thu, 13 Jun 2019 13:23:46 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B95F6541F8;
        Thu, 13 Jun 2019 13:23:45 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: [PATCH 5/9] x86/bpf: Support SIB byte generation
Date:   Thu, 13 Jun 2019 08:21:02 -0500
Message-Id: <30e798c2a5b5d89908e6beea03bf2938eaf2a1ca.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560431531.git.jpoimboe@redhat.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 13 Jun 2019 13:23:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for using R12 indexing instructions in BPF JIT code, add
support for generating the x86 SIB byte.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/net/bpf_jit_comp.c | 69 +++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 15 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 485692d4b163..e649f977f8e1 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -143,6 +143,12 @@ static bool is_axreg(u32 reg)
 	return reg == BPF_REG_0;
 }
 
+static bool is_sib_reg(u32 reg)
+{
+	/* R12 isn't used yet */
+	false;
+}
+
 /* Add modifiers if 'reg' maps to x86-64 registers R8..R15 */
 static u8 add_1mod(u8 byte, u32 reg)
 {
@@ -779,10 +785,19 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ST | BPF_MEM | BPF_DW:
 			EMIT2(add_1mod(0x48, dst_reg), 0xC7);
 
-st:			if (is_imm8(insn->off))
-				EMIT2(add_1reg(0x40, dst_reg), insn->off);
+st:
+			if (is_imm8(insn->off))
+				EMIT1(add_1reg(0x40, dst_reg));
+			else
+				EMIT1(add_1reg(0x80, dst_reg));
+
+			if (is_sib_reg(dst_reg))
+				EMIT1(add_1reg(0x20, dst_reg));
+
+			if (is_imm8(insn->off))
+				EMIT1(insn->off);
 			else
-				EMIT1_off32(add_1reg(0x80, dst_reg), insn->off);
+				EMIT(insn->off, 4);
 
 			EMIT(imm32, bpf_size_to_x86_bytes(BPF_SIZE(insn->code)));
 			break;
@@ -811,11 +826,19 @@ st:			if (is_imm8(insn->off))
 			goto stx;
 		case BPF_STX | BPF_MEM | BPF_DW:
 			EMIT2(add_2mod(0x48, dst_reg, src_reg), 0x89);
-stx:			if (is_imm8(insn->off))
-				EMIT2(add_2reg(0x40, dst_reg, src_reg), insn->off);
+stx:
+			if (is_imm8(insn->off))
+				EMIT1(add_2reg(0x40, dst_reg, src_reg));
 			else
-				EMIT1_off32(add_2reg(0x80, dst_reg, src_reg),
-					    insn->off);
+				EMIT1(add_2reg(0x80, dst_reg, src_reg));
+
+			if (is_sib_reg(dst_reg))
+				EMIT1(add_1reg(0x20, dst_reg));
+
+			if (is_imm8(insn->off))
+				EMIT1(insn->off);
+			else
+				EMIT(insn->off, 4);
 			break;
 
 			/* LDX: dst_reg = *(u8*)(src_reg + off) */
@@ -837,16 +860,24 @@ stx:			if (is_imm8(insn->off))
 		case BPF_LDX | BPF_MEM | BPF_DW:
 			/* Emit 'mov rax, qword ptr [rax+0x14]' */
 			EMIT2(add_2mod(0x48, src_reg, dst_reg), 0x8B);
-ldx:			/*
+ldx:
+			/*
 			 * If insn->off == 0 we can save one extra byte, but
 			 * special case of x86 R13 which always needs an offset
 			 * is not worth the hassle
 			 */
 			if (is_imm8(insn->off))
-				EMIT2(add_2reg(0x40, src_reg, dst_reg), insn->off);
+				EMIT1(add_2reg(0x40, src_reg, dst_reg));
+			else
+				EMIT1(add_2reg(0x80, src_reg, dst_reg));
+
+			if (is_sib_reg(src_reg))
+				EMIT1(add_1reg(0x20, src_reg));
+
+			if (is_imm8(insn->off))
+				EMIT1(insn->off);
 			else
-				EMIT1_off32(add_2reg(0x80, src_reg, dst_reg),
-					    insn->off);
+				EMIT(insn->off, 4);
 			break;
 
 			/* STX XADD: lock *(u32*)(dst_reg + off) += src_reg */
@@ -859,11 +890,19 @@ stx:			if (is_imm8(insn->off))
 			goto xadd;
 		case BPF_STX | BPF_XADD | BPF_DW:
 			EMIT3(0xF0, add_2mod(0x48, dst_reg, src_reg), 0x01);
-xadd:			if (is_imm8(insn->off))
-				EMIT2(add_2reg(0x40, dst_reg, src_reg), insn->off);
+xadd:
+			if (is_imm8(insn->off))
+				EMIT1(add_2reg(0x40, dst_reg, src_reg));
+			else
+				EMIT1(add_2reg(0x80, dst_reg, src_reg));
+
+			if (is_sib_reg(dst_reg))
+				EMIT1(add_1reg(0x20, dst_reg));
+
+			if (is_imm8(insn->off))
+				EMIT1(insn->off);
 			else
-				EMIT1_off32(add_2reg(0x80, dst_reg, src_reg),
-					    insn->off);
+				EMIT(insn->off, 4);
 			break;
 
 			/* call */
-- 
2.20.1

