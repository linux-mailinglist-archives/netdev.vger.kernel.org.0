Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C54633CAA5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhCPBO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:14:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234153AbhCPBON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:14:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1E0Ix032595
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=O969AK0PTM9lmu7Aws6QAdpyJAyX3EsioEYFqBJ0jgw=;
 b=TNhfFJPlUwMfhl93FKo1+TyxB0Isme7ccIS1AHkWTDBB0WRL5kbzJII9why9TAiPm1sR
 lRpcsqIqmKWUth2ieO2lPSKHpHR06IPpaLu35IvEnjWuhDx3JrN25xJvb4GjroNZBWu8
 OR+qYghgjgguizNzPvoSZKuWYboa9F7IAcU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379ee5gtcc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:13 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:14:11 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 951DE2942B57; Mon, 15 Mar 2021 18:14:07 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 05/15] bpf: Support kernel function call in x86-32
Date:   Mon, 15 Mar 2021 18:14:07 -0700
Message-ID: <20210316011407.4177113-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 mlxlogscore=971 mlxscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds kernel function call support to the x86-32 bpf jit.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 arch/x86/net/bpf_jit_comp32.c | 198 ++++++++++++++++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.=
c
index d17b67c69f89..f2ac36cf08ac 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1390,6 +1390,19 @@ static inline void emit_push_r64(const u8 src[], u=
8 **pprog)
 	*pprog =3D prog;
 }
=20
+static void emit_push_r32(const u8 src[], u8 **pprog)
+{
+	u8 *prog =3D *pprog;
+	int cnt =3D 0;
+
+	/* mov ecx,dword ptr [ebp+off] */
+	EMIT3(0x8B, add_2reg(0x40, IA32_EBP, IA32_ECX), STACK_VAR(src_lo));
+	/* push ecx */
+	EMIT1(0x51);
+
+	*pprog =3D prog;
+}
+
 static u8 get_cond_jmp_opcode(const u8 op, bool is_cmp_lo)
 {
 	u8 jmp_cond;
@@ -1459,6 +1472,174 @@ static u8 get_cond_jmp_opcode(const u8 op, bool i=
s_cmp_lo)
 	return jmp_cond;
 }
=20
+/* i386 kernel compiles with "-mregparm=3D3".  From gcc document:
+ *
+ * =3D=3D=3D=3D snippet =3D=3D=3D=3D
+ * regparm (number)
+ *	On x86-32 targets, the regparm attribute causes the compiler
+ *	to pass arguments number one to (number) if they are of integral
+ *	type in registers EAX, EDX, and ECX instead of on the stack.
+ *	Functions that take a variable number of arguments continue
+ *	to be passed all of their arguments on the stack.
+ * =3D=3D=3D=3D snippet =3D=3D=3D=3D
+ *
+ * The first three args of a function will be considered for
+ * putting into the 32bit register EAX, EDX, and ECX.
+ *
+ * Two 32bit registers are used to pass a 64bit arg.
+ *
+ * For example,
+ * void foo(u32 a, u32 b, u32 c, u32 d):
+ *	u32 a: EAX
+ *	u32 b: EDX
+ *	u32 c: ECX
+ *	u32 d: stack
+ *
+ * void foo(u64 a, u32 b, u32 c):
+ * 	u64 a: EAX (lo32) EDX (hi32)
+ *	u32 b: ECX
+ *	u32 c: stack
+ *
+ * void foo(u32 a, u64 b, u32 c):
+ *	u32 a: EAX
+ *	u64 b: EDX (lo32) ECX (hi32)
+ *	u32 c: stack
+ *
+ * void foo(u32 a, u32 b, u64 c):
+ *	u32 a: EAX
+ *	u32 b: EDX
+ *	u64 c: stack
+ *
+ * The return value will be stored in the EAX (and EDX for 64bit value).
+ *
+ * For example,
+ * u32 foo(u32 a, u32 b, u32 c):
+ *	return value: EAX
+ *
+ * u64 foo(u32 a, u32 b, u32 c):
+ *	return value: EAX (lo32) EDX (hi32)
+ *
+ * Notes:
+ *	The verifier only accepts function having integer and pointers
+ *	as its args and return value, so it does not have
+ *	struct-by-value.
+ *
+ * emit_kfunc_call() finds out the btf_func_model by calling
+ * bpf_jit_find_kern_func_model().  A btf_func_model
+ * has the details about the number of args, size of each arg,
+ * and the size of the return value.
+ *
+ * It first decides how many args can be passed by EAX, EDX, and ECX.
+ * That will decide what args should be pushed to the stack:
+ * [first_stack_regno, last_stack_regno] are the bpf regnos
+ * that should be pushed to the stack.
+ *
+ * It will first push all args to the stack because the push
+ * will need to use ECX.  Then, it moves
+ * [BPF_REG_1, first_stack_regno) to EAX, EDX, and ECX.
+ *
+ * When emitting a call (0xE8), it needs to figure out
+ * the jmp_offset relative to the jit-insn address immediately
+ * following the call (0xE8) instruction.  At this point, it knows
+ * the end of the jit-insn address after completely translated the
+ * current (BPF_JMP | BPF_CALL) bpf-insn.  It is passed as "end_addr"
+ * to the emit_kfunc_call().  Thus, it can learn the "immediate-follow-c=
all"
+ * address by figuring out how many jit-insn is generated between
+ * the call (0xE8) and the end_addr:
+ *	- 0-1 jit-insn (3 bytes each) to restore the esp pointer if there
+ *	  is arg pushed to the stack.
+ *	- 0-2 jit-insns (3 bytes each) to handle the return value.
+ */
+static int emit_kfunc_call(const struct bpf_prog *bpf_prog, u8 *end_addr=
,
+			   const struct bpf_insn *insn, u8 **pprog)
+{
+	const u8 arg_regs[] =3D { IA32_EAX, IA32_EDX, IA32_ECX };
+	int i, cnt =3D 0, first_stack_regno, last_stack_regno;
+	int free_arg_regs =3D ARRAY_SIZE(arg_regs);
+	const struct btf_func_model *fm;
+	int bytes_in_stack =3D 0;
+	const u8 *cur_arg_reg;
+	u8 *prog =3D *pprog;
+	s64 jmp_offset;
+
+	fm =3D bpf_jit_find_kern_func_model(bpf_prog, insn);
+	if (!fm)
+		return -EINVAL;
+
+	first_stack_regno =3D BPF_REG_1;
+	for (i =3D 0; i < fm->nr_args; i++) {
+		int regs_needed =3D fm->arg_size[i] > sizeof(u32) ? 2 : 1;
+
+		if (regs_needed > free_arg_regs)
+			break;
+
+		free_arg_regs -=3D regs_needed;
+		first_stack_regno++;
+	}
+
+	/* Push the args to the stack */
+	last_stack_regno =3D BPF_REG_0 + fm->nr_args;
+	for (i =3D last_stack_regno; i >=3D first_stack_regno; i--) {
+		if (fm->arg_size[i - 1] > sizeof(u32)) {
+			emit_push_r64(bpf2ia32[i], &prog);
+			bytes_in_stack +=3D 8;
+		} else {
+			emit_push_r32(bpf2ia32[i], &prog);
+			bytes_in_stack +=3D 4;
+		}
+	}
+
+	cur_arg_reg =3D &arg_regs[0];
+	for (i =3D BPF_REG_1; i < first_stack_regno; i++) {
+		/* mov e[adc]x,dword ptr [ebp+off] */
+		EMIT3(0x8B, add_2reg(0x40, IA32_EBP, *cur_arg_reg++),
+		      STACK_VAR(bpf2ia32[i][0]));
+		if (fm->arg_size[i - 1] > sizeof(u32))
+			/* mov e[adc]x,dword ptr [ebp+off] */
+			EMIT3(0x8B, add_2reg(0x40, IA32_EBP, *cur_arg_reg++),
+			      STACK_VAR(bpf2ia32[i][1]));
+	}
+
+	if (bytes_in_stack)
+		/* add esp,"bytes_in_stack" */
+		end_addr -=3D 3;
+
+	/* mov dword ptr [ebp+off],edx */
+	if (fm->ret_size > sizeof(u32))
+		end_addr -=3D 3;
+
+	/* mov dword ptr [ebp+off],eax */
+	if (fm->ret_size)
+		end_addr -=3D 3;
+
+	jmp_offset =3D (u8 *)__bpf_call_base + insn->imm - end_addr;
+	if (!is_simm32(jmp_offset)) {
+		pr_err("unsupported BPF kernel function jmp_offset:%lld\n",
+		       jmp_offset);
+		return -EINVAL;
+	}
+
+	EMIT1_off32(0xE8, jmp_offset);
+
+	if (fm->ret_size)
+		/* mov dword ptr [ebp+off],eax */
+		EMIT3(0x89, add_2reg(0x40, IA32_EBP, IA32_EAX),
+		      STACK_VAR(bpf2ia32[BPF_REG_0][0]));
+
+	if (fm->ret_size > sizeof(u32))
+		/* mov dword ptr [ebp+off],edx */
+		EMIT3(0x89, add_2reg(0x40, IA32_EBP, IA32_EDX),
+		      STACK_VAR(bpf2ia32[BPF_REG_0][1]));
+
+	if (bytes_in_stack)
+		/* add esp,"bytes_in_stack" */
+		EMIT3(0x83, add_1reg(0xC0, IA32_ESP), bytes_in_stack);
+
+	*pprog =3D prog;
+
+	return 0;
+}
+
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		  int oldproglen, struct jit_context *ctx)
 {
@@ -1888,6 +2069,18 @@ static int do_jit(struct bpf_prog *bpf_prog, int *=
addrs, u8 *image,
 			if (insn->src_reg =3D=3D BPF_PSEUDO_CALL)
 				goto notyet;
=20
+			if (insn->src_reg =3D=3D BPF_PSEUDO_KFUNC_CALL) {
+				int err;
+
+				err =3D emit_kfunc_call(bpf_prog,
+						      image + addrs[i],
+						      insn, &prog);
+
+				if (err)
+					return err;
+				break;
+			}
+
 			func =3D (u8 *) __bpf_call_base + imm32;
 			jmp_offset =3D func - (image + addrs[i]);
=20
@@ -2393,3 +2586,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_pro=
g *prog)
 					   tmp : orig_prog);
 	return prog;
 }
+
+bool bpf_jit_supports_kfunc_call(void)
+{
+	return true;
+}
--=20
2.30.2

