Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EECF46B7F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfFNVGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:06:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36542 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfFNVF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 17:05:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id f21so2202831pgi.3;
        Fri, 14 Jun 2019 14:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SQuYBXnXEaNAofToynPhRfWzIHngm1NHOxCYeqSxd9k=;
        b=teLm5RHLQ0/v9w+bvb3mf5X10O3BwI5QEoTaaPeUNBBCGz9cqigLWUWHZIhry9WkhL
         pRqd+0j5E7kFvCxqphY2/1tbPTjUy+IvVJqvznul0y1eLrhh0MmHyiDr2WiFlTvNEier
         1BItiNruF+awb0ruSVs6ofnZkB+yBR0vO47PkeZfpbhd2e3oYD5/pXS+Ifz0CC1s3VNU
         UE0DMWzqvi0EtE6/dzd8A+Z2sYv9rJmHS0kQ2w3kqLfVPOadPhBfOG8/pA2zPgu9I1cH
         WMyieaowyQSVyQPgS1aEmr5dfkroXZL37RO2FnAtT67y7L6vTuWuy3vvZqGtHsiepg2W
         uyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SQuYBXnXEaNAofToynPhRfWzIHngm1NHOxCYeqSxd9k=;
        b=jIrtyJgAMuK5lVvTaSi5nyPCFtN5WQheVGWNbfDZ7uXRDv9/wz6mJgQTLvQh4Eq9J1
         cC9g5FbS7LQUufdpQYd17MLKmfTKyFisY7deqO3KWNhbRX8xbGlgJiUPqBpOzdjdypfD
         EtEgDJT3YbQyq1G6F5h1GLTuK8h0fGMEm7re5UO3+JOTa37ESUTVRQcGZ9jxnOdiSy2G
         Av5rl/SwVDnyiSuKYu1nCLYqx2od9mgk7np+U6QXtNNNYeyS9FfNr55wZPu6571pj8wX
         rTtMQEeNeTMYqGVzxSiaGDoo9htgQaxkHGtAl74vrDmLH+oqrrmrmiJLNKQCA1tD9rgW
         DALg==
X-Gm-Message-State: APjAAAUPKzqj2czGty3KDlAMKLyDG718mDQCho2V3QOVHy2Y61EGEAxU
        Jo2tn4HQ59ZJsxsk6btMpGY=
X-Google-Smtp-Source: APXvYqzfhpu2hIhHksc9tAEwcAGpKoONJ8z7nwASjLTarX9FoHzU00l6Gr0niUFWyyVx0TXAtX6eDw==
X-Received: by 2002:a17:90a:23ce:: with SMTP id g72mr13064688pje.77.1560546358612;
        Fri, 14 Jun 2019 14:05:58 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:6345])
        by smtp.gmail.com with ESMTPSA id w187sm4348808pfb.4.2019.06.14.14.05.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 14:05:57 -0700 (PDT)
Date:   Fri, 14 Jun 2019 14:05:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
Message-ID: <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:56:43PM -0500, Josh Poimboeuf wrote:
> The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
> thus prevents the FP unwinder from unwinding through JIT generated code.
> 
> Fix it by saving the new RBP value on the stack before updating it.
> This effectively creates a new stack frame which the unwinder can
> understand.
> 
> Also, simplify the BPF JIT prologue such that it more closely resembles
> a typical compiler-generated prologue.  This also reduces the prologue
> size quite a bit overall.
> 
> Suggested-by: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 106 ++++++++++++++++++------------------
>  1 file changed, 54 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index da8c988b0f0f..fa1fe65c4cb4 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -186,56 +186,54 @@ struct jit_context {
>  #define BPF_MAX_INSN_SIZE	128
>  #define BPF_INSN_SAFETY		64
>  
> -#define AUX_STACK_SPACE		40 /* Space for RBX, R13, R14, R15, tailcnt */
> -
> -#define PROLOGUE_SIZE		37
> +#define PROLOGUE_SIZE		24
>  
>  /*
>   * Emit x86-64 prologue code for BPF program and check its size.
>   * bpf_tail_call helper will skip it while jumping into another program
>   */
> -static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
> +static void emit_prologue(u8 **pprog, u32 stack_depth)
>  {
>  	u8 *prog = *pprog;
>  	int cnt = 0;
>  
>  	/* push rbp */
>  	EMIT1(0x55);
> -
> -	/* mov rbp,rsp */
> +	/* mov rbp, rsp */
>  	EMIT3(0x48, 0x89, 0xE5);
>  
> -	/* sub rsp, rounded_stack_depth + AUX_STACK_SPACE */
> -	EMIT3_off32(0x48, 0x81, 0xEC,
> -		    round_up(stack_depth, 8) + AUX_STACK_SPACE);
> +	/* push r15 */
> +	EMIT2(0x41, 0x57);
> +	/* push r14 */
> +	EMIT2(0x41, 0x56);
> +	/* push r13 */
> +	EMIT2(0x41, 0x55);
> +	/* push rbx */
> +	EMIT1(0x53);
>  
> -	/* sub rbp, AUX_STACK_SPACE */
> -	EMIT4(0x48, 0x83, 0xED, AUX_STACK_SPACE);
> -
> -	/* mov qword ptr [rbp+0],rbx */
> -	EMIT4(0x48, 0x89, 0x5D, 0);
> -	/* mov qword ptr [rbp+8],r13 */
> -	EMIT4(0x4C, 0x89, 0x6D, 8);
> -	/* mov qword ptr [rbp+16],r14 */
> -	EMIT4(0x4C, 0x89, 0x75, 16);
> -	/* mov qword ptr [rbp+24],r15 */
> -	EMIT4(0x4C, 0x89, 0x7D, 24);
> +	/*
> +	 * Push the tail call counter (tail_call_cnt) for eBPF tail calls.
> +	 * Initialized to zero.
> +	 *
> +	 * push $0
> +	 */
> +	EMIT2(0x6a, 0x00);
>  
> -	if (!ebpf_from_cbpf) {
> -		/*
> -		 * Clear the tail call counter (tail_call_cnt): for eBPF tail
> -		 * calls we need to reset the counter to 0. It's done in two
> -		 * instructions, resetting RAX register to 0, and moving it
> -		 * to the counter location.
> -		 */
> +	/*
> +	 * RBP is used for the BPF program's FP register.  It points to the end
> +	 * of the program's stack area.  Create another stack frame so the
> +	 * unwinder can unwind through the generated code.  The tail_call_cnt
> +	 * value doubles as an (invalid) RIP address.
> +	 */
> +	/* push rbp */
> +	EMIT1(0x55);
> +	/* mov rbp, rsp */
> +	EMIT3(0x48, 0x89, 0xE5);

Have you tested it ?
I really doubt, since in my test both CONFIG_UNWINDER_ORC and
CONFIG_UNWINDER_FRAME_POINTER failed to unwind through such odd frame.

Here is much simple patch that I mentioned in the email yesterday,
but you failed to listen instead of focusing on perceived 'code readability'.

It makes one proper frame and both frame and orc unwinders are happy.

From 442d91571a7f7f92a5cd3bd4a1b139390befbee3 Mon Sep 17 00:00:00 2001
From: Alexei Starovoitov <ast@kernel.org>
Date: Fri, 14 Jun 2019 12:56:43 -0500
Subject: [PATCH bpf] x86/bpf: Fix 64-bit JIT frame pointer usage

The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
thus prevents the FP unwinder from unwinding through JIT generated code.
Fix it by moving callee saved space to the bottom.
Similar to how it was before commit 177366bf7ceb.

Fixes: 177366bf7ceb ("bpf: change x86 JITed program stack layout")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 84 +++++++++++++++----------------------
 1 file changed, 34 insertions(+), 50 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index a858d9f331b0..4259593b6935 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -190,56 +190,38 @@ struct jit_context {
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
 
-#define AUX_STACK_SPACE		40 /* Space for RBX, R13, R14, R15, tailcnt */
-
-#define PROLOGUE_SIZE		37
+#define PROLOGUE_SIZE		20
 
 /*
  * Emit x86-64 prologue code for BPF program and check its size.
  * bpf_tail_call helper will skip it while jumping into another program
  */
-static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
+static void emit_prologue(u8 **pprog, u32 stack_depth)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
 
 	/* push rbp */
 	EMIT1(0x55);
-
-	/* mov rbp,rsp */
+	/* mov rbp, rsp */
 	EMIT3(0x48, 0x89, 0xE5);
 
-	/* sub rsp, rounded_stack_depth + AUX_STACK_SPACE */
-	EMIT3_off32(0x48, 0x81, 0xEC,
-		    round_up(stack_depth, 8) + AUX_STACK_SPACE);
-
-	/* sub rbp, AUX_STACK_SPACE */
-	EMIT4(0x48, 0x83, 0xED, AUX_STACK_SPACE);
-
-	/* mov qword ptr [rbp+0],rbx */
-	EMIT4(0x48, 0x89, 0x5D, 0);
-	/* mov qword ptr [rbp+8],r13 */
-	EMIT4(0x4C, 0x89, 0x6D, 8);
-	/* mov qword ptr [rbp+16],r14 */
-	EMIT4(0x4C, 0x89, 0x75, 16);
-	/* mov qword ptr [rbp+24],r15 */
-	EMIT4(0x4C, 0x89, 0x7D, 24);
+	/* sub rsp, rounded_stack_depth */
+	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
 
-	if (!ebpf_from_cbpf) {
-		/*
-		 * Clear the tail call counter (tail_call_cnt): for eBPF tail
-		 * calls we need to reset the counter to 0. It's done in two
-		 * instructions, resetting RAX register to 0, and moving it
-		 * to the counter location.
-		 */
+	/* push r15 */
+	EMIT2(0x41, 0x57);
+	/* push r14 */
+	EMIT2(0x41, 0x56);
+	/* push r13 */
+	EMIT2(0x41, 0x55);
+	/* push rbx */
+	EMIT1(0x53);
 
-		/* xor eax, eax */
-		EMIT2(0x31, 0xc0);
-		/* mov qword ptr [rbp+32], rax */
-		EMIT4(0x48, 0x89, 0x45, 32);
+	/* zero init tail_call_cnt */
+	EMIT2(0x6a, 0x00);
 
-		BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
-	}
+	BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
 
 	*pprog = prog;
 }
@@ -249,19 +231,22 @@ static void emit_epilogue(u8 **pprog)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	/* mov rbx, qword ptr [rbp+0] */
-	EMIT4(0x48, 0x8B, 0x5D, 0);
-	/* mov r13, qword ptr [rbp+8] */
-	EMIT4(0x4C, 0x8B, 0x6D, 8);
-	/* mov r14, qword ptr [rbp+16] */
-	EMIT4(0x4C, 0x8B, 0x75, 16);
-	/* mov r15, qword ptr [rbp+24] */
-	EMIT4(0x4C, 0x8B, 0x7D, 24);
+	/* pop rbx (skip over tail_call_cnt) */
+	EMIT1(0x5B);
+
+	/* pop rbx */
+	EMIT1(0x5B);
+	/* pop r13 */
+	EMIT2(0x41, 0x5D);
+	/* pop r14 */
+	EMIT2(0x41, 0x5E);
+	/* pop r15 */
+	EMIT2(0x41, 0x5F);
+	/* leave (restore rsp and rbp) */
+	EMIT1(0xC9);
 
-	/* add rbp, AUX_STACK_SPACE */
-	EMIT4(0x48, 0x83, 0xC5, AUX_STACK_SPACE);
-	EMIT1(0xC9); /* leave */
-	EMIT1(0xC3); /* ret */
+	/* ret */
+	EMIT1(0xC3);
 
 	*pprog = prog;
 }
@@ -307,13 +292,13 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, 36);              /* mov eax, dword ptr [rbp + 36] */
+	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
 #define OFFSET2 (30 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, 36);              /* mov dword ptr [rbp + 36], eax */
+	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
@@ -441,8 +426,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	int proglen = 0;
 	u8 *prog = temp;
 
-	emit_prologue(&prog, bpf_prog->aux->stack_depth,
-		      bpf_prog_was_classic(bpf_prog));
+	emit_prologue(&prog, bpf_prog->aux->stack_depth);
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		const s32 imm32 = insn->imm;
-- 
2.20.0

