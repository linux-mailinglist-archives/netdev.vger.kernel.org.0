Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D586B69FC2C
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjBVT3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjBVT3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:29:45 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DB42B2BB
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:29:40 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536c8bcae3bso77970027b3.2
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ET5uK4G9BnYd+mgYhqQ9kutIdmfzaa4o47ZwKb3KpKg=;
        b=amhiaTMtNJatGLJukmVySR1HZRRjtveJ4zbpPuOmg0XvedYwF0sMIUQhaT1qRMENj0
         NhQC5h7QmOJX/mxgfXSr5xJPjAILx9zcTEFlVkOLjjFU0zTNKvzUjfvmUimwIE1zDBd0
         kjKGJchFsATjiZYwxKylrVqV/+QBBBOBSj2lf6hx2BU3b/0Nt82ppYe8mycpDdMcxO6O
         RCSL4ENYrfSKTc5ephkac/ztcCXuUdBs3uMwijtJx1zoqDMwkozzDbNchsf4p84Z3bCl
         VX/GoZqqwnunYpbU9uPQtVSos7PuXSJroid+a3wLi9gTDrDPI553h384J8vppKNfe0PY
         FLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ET5uK4G9BnYd+mgYhqQ9kutIdmfzaa4o47ZwKb3KpKg=;
        b=fQGxHozID8ZUIzof5a1Ljd90ua2aNzI3aBPACNBp7aLxfGENc15iDcth7NsFaZi7l3
         iWICvWL9HoQowlAV7eZepK1jrF5IfwdHWu977T74SEFO/B93YBhgkIxoHwtoqIAZxvn4
         gJ5zl8ifUm8YL9jQ4DCnWe7VVX9Abn9tj2cp1b3wVfGCFbmfZdEZegWNp1uqLTLoLoVx
         8rvqg7P7kFxfPBRYjX/QCO6xftySFTftIYuKl+nkSgXqUOVTiClHWTYp98pBMMA3U/P9
         jchRKpCmNhx8Z8nysr4BPZhv9oOnBCmMYE9OXBme6L5y6rvX4ksAvRHCkFEK1Ldiunr9
         LpbA==
X-Gm-Message-State: AO0yUKU1DfNhup5dpgAwllBu136AO0Dee+MXdaou4zrLYTIf8X1Av7pZ
        4w253+oVUgTI0oEZT2tImtH5wwyqAGM=
X-Google-Smtp-Source: AK7set/Pa04XjzSQIQpgmKbOq9P2op1nWrFy5MZnIcn7RhtaK/5kiY2YHZG8PWqLvf8NJSncTO0uoME0lXQ=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:10c9:b0:855:fdcb:4467 with SMTP id
 w9-20020a05690210c900b00855fdcb4467mr1578916ybu.0.1677094179755; Wed, 22 Feb
 2023 11:29:39 -0800 (PST)
Date:   Wed, 22 Feb 2023 19:29:22 +0000
In-Reply-To: <20230222192925.1778183-1-edliaw@google.com>
Mime-Version: 1.0
References: <20230222192925.1778183-1-edliaw@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230222192925.1778183-3-edliaw@google.com>
Subject: [PATCH 4.14 v2 2/4] bpf: fix subprog verifier bypass by div/mod by 0 exception
From:   Edward Liaw <edliaw@google.com>
To:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bpf@vger.kernel.org, kernel-team@android.com,
        Edward Liaw <edliaw@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Commit f6b1b3bf0d5f681631a293cfe1ca934b81716f1e upstream.

One of the ugly leftovers from the early eBPF days is that div/mod
operations based on registers have a hard-coded src_reg == 0 test
in the interpreter as well as in JIT code generators that would
return from the BPF program with exit code 0. This was basically
adopted from cBPF interpreter for historical reasons.

There are multiple reasons why this is very suboptimal and prone
to bugs. To name one: the return code mapping for such abnormal
program exit of 0 does not always match with a suitable program
type's exit code mapping. For example, '0' in tc means action 'ok'
where the packet gets passed further up the stack, which is just
undesirable for such cases (e.g. when implementing policy) and
also does not match with other program types.

While trying to work out an exception handling scheme, I also
noticed that programs crafted like the following will currently
pass the verifier:

  0: (bf) r6 = r1
  1: (85) call pc+8
  caller:
   R6=ctx(id=0,off=0,imm=0) R10=fp0,call_-1
  callee:
   frame1: R1=ctx(id=0,off=0,imm=0) R10=fp0,call_1
  10: (b4) (u32) r2 = (u32) 0
  11: (b4) (u32) r3 = (u32) 1
  12: (3c) (u32) r3 /= (u32) r2
  13: (61) r0 = *(u32 *)(r1 +76)
  14: (95) exit
  returning from callee:
   frame1: R0_w=pkt(id=0,off=0,r=0,imm=0)
           R1=ctx(id=0,off=0,imm=0) R2_w=inv0
           R3_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
           R10=fp0,call_1
  to caller at 2:
   R0_w=pkt(id=0,off=0,r=0,imm=0) R6=ctx(id=0,off=0,imm=0)
   R10=fp0,call_-1

  from 14 to 2: R0=pkt(id=0,off=0,r=0,imm=0)
                R6=ctx(id=0,off=0,imm=0) R10=fp0,call_-1
  2: (bf) r1 = r6
  3: (61) r1 = *(u32 *)(r1 +80)
  4: (bf) r2 = r0
  5: (07) r2 += 8
  6: (2d) if r2 > r1 goto pc+1
   R0=pkt(id=0,off=0,r=8,imm=0) R1=pkt_end(id=0,off=0,imm=0)
   R2=pkt(id=0,off=8,r=8,imm=0) R6=ctx(id=0,off=0,imm=0)
   R10=fp0,call_-1
  7: (71) r0 = *(u8 *)(r0 +0)
  8: (b7) r0 = 1
  9: (95) exit

  from 6 to 8: safe
  processed 16 insns (limit 131072), stack depth 0+0

Basically what happens is that in the subprog we make use of a
div/mod by 0 exception and in the 'normal' subprog's exit path
we just return skb->data back to the main prog. This has the
implication that the verifier thinks we always get a pkt pointer
in R0 while we still have the implicit 'return 0' from the div
as an alternative unconditional return path earlier. Thus, R0
then contains 0, meaning back in the parent prog we get the
address range of [0x0, skb->data_end] as read and writeable.
Similar can be crafted with other pointer register types.

Since i) BPF_ABS/IND is not allowed in programs that contain
BPF to BPF calls (and generally it's also disadvised to use in
native eBPF context), ii) unknown opcodes don't return zero
anymore, iii) we don't return an exception code in dead branches,
the only last missing case affected and to fix is the div/mod
handling.

What we would really need is some infrastructure to propagate
exceptions all the way to the original prog unwinding the
current stack and returning that code to the caller of the
BPF program. In user space such exception handling for similar
runtimes is typically implemented with setjmp(3) and longjmp(3)
as one possibility which is not available in the kernel,
though (kgdb used to implement it in kernel long time ago). I
implemented a PoC exception handling mechanism into the BPF
interpreter with porting setjmp()/longjmp() into x86_64 and
adding a new internal BPF_ABRT opcode that can use a program
specific exception code for all exception cases we have (e.g.
div/mod by 0, unknown opcodes, etc). While this seems to work
in the constrained BPF environment (meaning, here, we don't
need to deal with state e.g. from memory allocations that we
would need to undo before going into exception state), it still
has various drawbacks: i) we would need to implement the
setjmp()/longjmp() for every arch supported in the kernel and
for x86_64, arm64, sparc64 JITs currently supporting calls,
ii) it has unconditional additional cost on main program
entry to store CPU register state in initial setjmp() call,
and we would need some way to pass the jmp_buf down into
___bpf_prog_run() for main prog and all subprogs, but also
storing on stack is not really nice (other option would be
per-cpu storage for this, but it also has the drawback that
we need to disable preemption for every BPF program types).
All in all this approach would add a lot of complexity.

Another poor-man's solution would be to have some sort of
additional shared register or scratch buffer to hold state
for exceptions, and test that after every call return to
chain returns and pass R0 all the way down to BPF prog caller.
This is also problematic in various ways: i) an additional
register doesn't map well into JITs, and some other scratch
space could only be on per-cpu storage, which, again has the
side-effect that this only works when we disable preemption,
or somewhere in the input context which is not available
everywhere either, and ii) this adds significant runtime
overhead by putting conditionals after each and every call,
as well as implementation complexity.

Yet another option is to teach verifier that div/mod can
return an integer, which however is also complex to implement
as verifier would need to walk such fake 'mov r0,<code>; exit;'
sequeuence and there would still be no guarantee for having
propagation of this further down to the BPF caller as proper
exception code. For parent prog, it is also is not distinguishable
from a normal return of a constant scalar value.

The approach taken here is a completely different one with
little complexity and no additional overhead involved in
that we make use of the fact that a div/mod by 0 is undefined
behavior. Instead of bailing out, we adapt the same behavior
as on some major archs like ARMv8 [0] into eBPF as well:
X div 0 results in 0, and X mod 0 results in X. aarch64 and
aarch32 ISA do not generate any traps or otherwise aborts
of program execution for unsigned divides. I verified this
also with a test program compiled by gcc and clang, and the
behavior matches with the spec. Going forward we adapt the
eBPF verifier to emit such rewrites once div/mod by register
was seen. cBPF is not touched and will keep existing 'return 0'
semantics. Given the options, it seems the most suitable from
all of them, also since major archs have similar schemes in
place. Given this is all in the realm of undefined behavior,
we still have the option to adapt if deemed necessary and
this way we would also have the option of more flexibility
from LLVM code generation side (which is then fully visible
to verifier). Thus, this patch i) fixes the panic seen in
above program and ii) doesn't bypass the verifier observations.

  [0] ARM Architecture Reference Manual, ARMv8 [ARM DDI 0487B.b]
      http://infocenter.arm.com/help/topic/com.arm.doc.ddi0487b.b/DDI0487B_b_armv8_arm.pdf
      1) aarch64 instruction set: section C3.4.7 and C6.2.279 (UDIV)
         "A division by zero results in a zero being written to
          the destination register, without any indication that
          the division by zero occurred."
      2) aarch32 instruction set: section F1.4.8 and F5.1.263 (UDIV)
         "For the SDIV and UDIV instructions, division by zero
          always returns a zero result."

Fixes: f4d7e40a5b71 ("bpf: introduce function calls (verification)")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 kernel/bpf/core.c     |  8 --------
 kernel/bpf/verifier.c | 38 ++++++++++++++++++++++++++++++--------
 net/core/filter.c     |  9 ++++++++-
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 4ddb846693bb..2ca36bb440de 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1055,14 +1055,10 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 		(*(s64 *) &DST) >>= IMM;
 		CONT;
 	ALU64_MOD_X:
-		if (unlikely(SRC == 0))
-			return 0;
 		div64_u64_rem(DST, SRC, &tmp);
 		DST = tmp;
 		CONT;
 	ALU_MOD_X:
-		if (unlikely((u32)SRC == 0))
-			return 0;
 		tmp = (u32) DST;
 		DST = do_div(tmp, (u32) SRC);
 		CONT;
@@ -1075,13 +1071,9 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 		DST = do_div(tmp, (u32) IMM);
 		CONT;
 	ALU64_DIV_X:
-		if (unlikely(SRC == 0))
-			return 0;
 		DST = div64_u64(DST, SRC);
 		CONT;
 	ALU_DIV_X:
-		if (unlikely((u32)SRC == 0))
-			return 0;
 		tmp = (u32) DST;
 		do_div(tmp, (u32) SRC);
 		DST = (u32) tmp;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e8d9ddd5cb18..836791403129 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4839,15 +4839,37 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 	struct bpf_insn_aux_data *aux;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
-		if (insn->code == (BPF_ALU | BPF_MOD | BPF_X) ||
+		if (insn->code == (BPF_ALU64 | BPF_MOD | BPF_X) ||
+		    insn->code == (BPF_ALU64 | BPF_DIV | BPF_X) ||
+		    insn->code == (BPF_ALU | BPF_MOD | BPF_X) ||
 		    insn->code == (BPF_ALU | BPF_DIV | BPF_X)) {
-			/* due to JIT bugs clear upper 32-bits of src register
-			 * before div/mod operation
-			 */
-			insn_buf[0] = BPF_MOV32_REG(insn->src_reg, insn->src_reg);
-			insn_buf[1] = *insn;
-			cnt = 2;
-			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
+			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
+			struct bpf_insn mask_and_div[] = {
+				BPF_MOV32_REG(insn->src_reg, insn->src_reg),
+				/* Rx div 0 -> 0 */
+				BPF_JMP_IMM(BPF_JNE, insn->src_reg, 0, 2),
+				BPF_ALU32_REG(BPF_XOR, insn->dst_reg, insn->dst_reg),
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				*insn,
+			};
+			struct bpf_insn mask_and_mod[] = {
+				BPF_MOV32_REG(insn->src_reg, insn->src_reg),
+				/* Rx mod 0 -> Rx */
+				BPF_JMP_IMM(BPF_JEQ, insn->src_reg, 0, 1),
+				*insn,
+			};
+			struct bpf_insn *patchlet;
+
+			if (insn->code == (BPF_ALU64 | BPF_DIV | BPF_X) ||
+			    insn->code == (BPF_ALU | BPF_DIV | BPF_X)) {
+				patchlet = mask_and_div + (is64 ? 1 : 0);
+				cnt = ARRAY_SIZE(mask_and_div) - (is64 ? 1 : 0);
+			} else {
+				patchlet = mask_and_mod + (is64 ? 1 : 0);
+				cnt = ARRAY_SIZE(mask_and_mod) - (is64 ? 1 : 0);
+			}
+
+			new_prog = bpf_patch_insn_data(env, i + delta, patchlet, cnt);
 			if (!new_prog)
 				return -ENOMEM;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 29d85a20f4fc..fc665885d57c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -458,8 +458,15 @@ static int bpf_convert_filter(struct sock_filter *prog, int len,
 				break;
 
 			if (fp->code == (BPF_ALU | BPF_DIV | BPF_X) ||
-			    fp->code == (BPF_ALU | BPF_MOD | BPF_X))
+			    fp->code == (BPF_ALU | BPF_MOD | BPF_X)) {
 				*insn++ = BPF_MOV32_REG(BPF_REG_X, BPF_REG_X);
+				/* Error with exception code on div/mod by 0.
+				 * For cBPF programs, this was always return 0.
+				 */
+				*insn++ = BPF_JMP_IMM(BPF_JNE, BPF_REG_X, 0, 2);
+				*insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_A, BPF_REG_A);
+				*insn++ = BPF_EXIT_INSN();
+			}
 
 			*insn = BPF_RAW_INSN(fp->code, BPF_REG_A, BPF_REG_X, 0, fp->k);
 			break;
-- 
2.39.2.637.g21b0678d19-goog

