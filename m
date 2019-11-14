Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074C5FCE3C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKNS52 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15524 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfKNS51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:27 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEIhCjR012800
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:26 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8rgdnq7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:26 -0800
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 10:57:25 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 02B4F76071B; Thu, 14 Nov 2019 10:57:25 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 02/20] bpf: refactor x86 JIT into helpers
Date:   Thu, 14 Nov 2019 10:57:02 -0800
Message-ID: <20191114185720.1641606-3-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=527 mlxscore=0 suspectscore=1 clxscore=1034 priorityscore=1501
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor x86 JITing of LDX, STX, CALL instructions into separate helper
functions.  No functional changes in LDX and STX helpers.  There is a minor
change in CALL helper. It will populate target address correctly on the first
pass of JIT instead of second pass. That won't reduce total number of JIT
passes though.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 arch/x86/net/bpf_jit_comp.c | 152 +++++++++++++++++++++++-------------
 1 file changed, 98 insertions(+), 54 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 8cd23d8309bf..fb99d976ad6e 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -198,6 +198,8 @@ struct jit_context {
 /* Maximum number of bytes emitted while JITing one eBPF insn */
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
+/* number of bytes emit_call() needs to generate call instruction */
+#define X86_CALL_SIZE		5
 
 #define PROLOGUE_SIZE		20
 
@@ -390,6 +392,99 @@ static void emit_mov_reg(u8 **pprog, bool is64, u32 dst_reg, u32 src_reg)
 	*pprog = prog;
 }
 
+/* LDX: dst_reg = *(u8*)(src_reg + off) */
+static void emit_ldx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+
+	switch (size) {
+	case BPF_B:
+		/* Emit 'movzx rax, byte ptr [rax + off]' */
+		EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB6);
+		break;
+	case BPF_H:
+		/* Emit 'movzx rax, word ptr [rax + off]' */
+		EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB7);
+		break;
+	case BPF_W:
+		/* Emit 'mov eax, dword ptr [rax+0x14]' */
+		if (is_ereg(dst_reg) || is_ereg(src_reg))
+			EMIT2(add_2mod(0x40, src_reg, dst_reg), 0x8B);
+		else
+			EMIT1(0x8B);
+		break;
+	case BPF_DW:
+		/* Emit 'mov rax, qword ptr [rax+0x14]' */
+		EMIT2(add_2mod(0x48, src_reg, dst_reg), 0x8B);
+		break;
+	}
+	/*
+	 * If insn->off == 0 we can save one extra byte, but
+	 * special case of x86 R13 which always needs an offset
+	 * is not worth the hassle
+	 */
+	if (is_imm8(off))
+		EMIT2(add_2reg(0x40, src_reg, dst_reg), off);
+	else
+		EMIT1_off32(add_2reg(0x80, src_reg, dst_reg), off);
+	*pprog = prog;
+}
+
+/* STX: *(u8*)(dst_reg + off) = src_reg */
+static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+
+	switch (size) {
+	case BPF_B:
+		/* Emit 'mov byte ptr [rax + off], al' */
+		if (is_ereg(dst_reg) || is_ereg(src_reg) ||
+		    /* We have to add extra byte for x86 SIL, DIL regs */
+		    src_reg == BPF_REG_1 || src_reg == BPF_REG_2)
+			EMIT2(add_2mod(0x40, dst_reg, src_reg), 0x88);
+		else
+			EMIT1(0x88);
+		break;
+	case BPF_H:
+		if (is_ereg(dst_reg) || is_ereg(src_reg))
+			EMIT3(0x66, add_2mod(0x40, dst_reg, src_reg), 0x89);
+		else
+			EMIT2(0x66, 0x89);
+		break;
+	case BPF_W:
+		if (is_ereg(dst_reg) || is_ereg(src_reg))
+			EMIT2(add_2mod(0x40, dst_reg, src_reg), 0x89);
+		else
+			EMIT1(0x89);
+		break;
+	case BPF_DW:
+		EMIT2(add_2mod(0x48, dst_reg, src_reg), 0x89);
+		break;
+	}
+	if (is_imm8(off))
+		EMIT2(add_2reg(0x40, dst_reg, src_reg), off);
+	else
+		EMIT1_off32(add_2reg(0x80, dst_reg, src_reg), off);
+	*pprog = prog;
+}
+
+static int emit_call(u8 **pprog, void *func, void *ip)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+	s64 offset;
+
+	offset = func - (ip + X86_CALL_SIZE);
+	if (!is_simm32(offset)) {
+		pr_err("Target call %p is out of range\n", func);
+		return -EINVAL;
+	}
+	EMIT1_off32(0xE8, offset);
+	*pprog = prog;
+	return 0;
+}
 
 static bool ex_handler_bpf(const struct exception_table_entry *x,
 			   struct pt_regs *regs, int trapnr,
@@ -773,68 +868,22 @@ st:			if (is_imm8(insn->off))
 
 			/* STX: *(u8*)(dst_reg + off) = src_reg */
 		case BPF_STX | BPF_MEM | BPF_B:
-			/* Emit 'mov byte ptr [rax + off], al' */
-			if (is_ereg(dst_reg) || is_ereg(src_reg) ||
-			    /* We have to add extra byte for x86 SIL, DIL regs */
-			    src_reg == BPF_REG_1 || src_reg == BPF_REG_2)
-				EMIT2(add_2mod(0x40, dst_reg, src_reg), 0x88);
-			else
-				EMIT1(0x88);
-			goto stx;
 		case BPF_STX | BPF_MEM | BPF_H:
-			if (is_ereg(dst_reg) || is_ereg(src_reg))
-				EMIT3(0x66, add_2mod(0x40, dst_reg, src_reg), 0x89);
-			else
-				EMIT2(0x66, 0x89);
-			goto stx;
 		case BPF_STX | BPF_MEM | BPF_W:
-			if (is_ereg(dst_reg) || is_ereg(src_reg))
-				EMIT2(add_2mod(0x40, dst_reg, src_reg), 0x89);
-			else
-				EMIT1(0x89);
-			goto stx;
 		case BPF_STX | BPF_MEM | BPF_DW:
-			EMIT2(add_2mod(0x48, dst_reg, src_reg), 0x89);
-stx:			if (is_imm8(insn->off))
-				EMIT2(add_2reg(0x40, dst_reg, src_reg), insn->off);
-			else
-				EMIT1_off32(add_2reg(0x80, dst_reg, src_reg),
-					    insn->off);
+			emit_stx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
 			break;
 
 			/* LDX: dst_reg = *(u8*)(src_reg + off) */
 		case BPF_LDX | BPF_MEM | BPF_B:
 		case BPF_LDX | BPF_PROBE_MEM | BPF_B:
-			/* Emit 'movzx rax, byte ptr [rax + off]' */
-			EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB6);
-			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_H:
 		case BPF_LDX | BPF_PROBE_MEM | BPF_H:
-			/* Emit 'movzx rax, word ptr [rax + off]' */
-			EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB7);
-			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_W:
 		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
-			/* Emit 'mov eax, dword ptr [rax+0x14]' */
-			if (is_ereg(dst_reg) || is_ereg(src_reg))
-				EMIT2(add_2mod(0x40, src_reg, dst_reg), 0x8B);
-			else
-				EMIT1(0x8B);
-			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_DW:
 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
-			/* Emit 'mov rax, qword ptr [rax+0x14]' */
-			EMIT2(add_2mod(0x48, src_reg, dst_reg), 0x8B);
-ldx:			/*
-			 * If insn->off == 0 we can save one extra byte, but
-			 * special case of x86 R13 which always needs an offset
-			 * is not worth the hassle
-			 */
-			if (is_imm8(insn->off))
-				EMIT2(add_2reg(0x40, src_reg, dst_reg), insn->off);
-			else
-				EMIT1_off32(add_2reg(0x80, src_reg, dst_reg),
-					    insn->off);
+			emit_ldx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
 			if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
 				struct exception_table_entry *ex;
 				u8 *_insn = image + proglen;
@@ -899,13 +948,8 @@ xadd:			if (is_imm8(insn->off))
 			/* call */
 		case BPF_JMP | BPF_CALL:
 			func = (u8 *) __bpf_call_base + imm32;
-			jmp_offset = func - (image + addrs[i]);
-			if (!imm32 || !is_simm32(jmp_offset)) {
-				pr_err("unsupported BPF func %d addr %p image %p\n",
-				       imm32, func, image);
+			if (!imm32 || emit_call(&prog, func, image + addrs[i - 1]))
 				return -EINVAL;
-			}
-			EMIT1_off32(0xE8, jmp_offset);
 			break;
 
 		case BPF_JMP | BPF_TAIL_CALL:
-- 
2.23.0

