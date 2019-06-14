Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED3F46559
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfFNRHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfFNRHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 13:07:40 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1AF94C057E65;
        Fri, 14 Jun 2019 17:07:25 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB9D51001B2E;
        Fri, 14 Jun 2019 17:07:22 +0000 (UTC)
Date:   Fri, 14 Jun 2019 12:07:20 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Alexei Starovoitov' <alexei.starovoitov@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Message-ID: <20190614170720.57yxtxvd4qee337l@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
 <20190613215807.wjcop6eaadirz5xm@ast-mbp.dhcp.thefacebook.com>
 <57f6e69da6b3461a9c39d71aa1b58662@AcuMS.aculab.com>
 <20190614134401.q2wbh6mvo4nzmw2o@treble>
 <9b8aa912df694d25b581786100d3e2e2@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b8aa912df694d25b581786100d3e2e2@AcuMS.aculab.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 14 Jun 2019 17:07:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 01:58:21PM +0000, David Laight wrote:
> From: Josh Poimboeuf
> > Sent: 14 June 2019 14:44
> > 
> > On Fri, Jun 14, 2019 at 10:50:23AM +0000, David Laight wrote:
> > > On Thu, Jun 13, 2019 at 08:21:03AM -0500, Josh Poimboeuf wrote:
> > > > The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
> > > > thus prevents the FP unwinder from unwinding through JIT generated code.
> > > >
> > > > RBP is currently used as the BPF stack frame pointer register.  The
> > > > actual register used is opaque to the user, as long as it's a
> > > > callee-saved register.  Change it to use R12 instead.
> > >
> > > Could you maintain the system %rbp chain through the BPF stack?
> > 
> > Do you mean to save RBP again before changing it again, so that we
> > create another stack frame inside the BPF stack?  That might work.
> 
> The unwinder will (IIRC) expect *%rbp to be the previous %rbp value.
> If you maintain that it will probably all work.
> 
> > > It might even be possible to put something relevant in the %rip
> > > location.
> > 
> > I'm not sure what you mean here.
> 
> The return address is (again IIRC) %rbp[-8] so the unwinder will
> expect that address to be a symbol.

Ah, gotcha.  We don't necessarily need the real rip on the stack as the
unwinder can handle bad text addresses ok.  Though the real one would be
better.

> I do remember a stack trace printer for x86 this didn't need
> any annotation of the object code and didn't need frame pointers.
> The only downside was that it had to 'guess' (ie scan the stack)
> to get out of functions that couldn't return.
> Basically it followed the control flow forwards tracking the
> values of %sp and %bp until it found a return instuction.
> All it has to do is detect loops and retry from the other
> target of conditional branches.

That actually sounds kind of cool, though I don't think we need that for
the kernel.

Anyway here's a patch with your suggestion.  I think it's the best idea
so far because it doesn't require the use of R12, nor does it require
abstracting BPF_REG_FP with an offset.  And the diffstat is pretty
small and self-contained.

It seems to work, though I didn't put a real RIP on the stack yet.  This
is based on top of the "x86/bpf: Simplify prologue generation" patch.

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 485692d4b163..fa1fe65c4cb4 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -186,7 +186,7 @@ struct jit_context {
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
 
-#define PROLOGUE_SIZE		20
+#define PROLOGUE_SIZE		24
 
 /*
  * Emit x86-64 prologue code for BPF program and check its size.
@@ -197,14 +197,17 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
+	/* push rbp */
+	EMIT1(0x55);
+	/* mov rbp, rsp */
+	EMIT3(0x48, 0x89, 0xE5);
+
 	/* push r15 */
 	EMIT2(0x41, 0x57);
 	/* push r14 */
 	EMIT2(0x41, 0x56);
 	/* push r13 */
 	EMIT2(0x41, 0x55);
-	/* push rbp */
-	EMIT1(0x55);
 	/* push rbx */
 	EMIT1(0x53);
 
@@ -218,10 +221,13 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
 
 	/*
 	 * RBP is used for the BPF program's FP register.  It points to the end
-	 * of the program's stack area.
-	 *
-	 * mov rbp, rsp
+	 * of the program's stack area.  Create another stack frame so the
+	 * unwinder can unwind through the generated code.  The tail_call_cnt
+	 * value doubles as an (invalid) RIP address.
 	 */
+	/* push rbp */
+	EMIT1(0x55);
+	/* mov rbp, rsp */
 	EMIT3(0x48, 0x89, 0xE5);
 
 	/* sub rsp, rounded_stack_depth */
@@ -237,19 +243,21 @@ static void emit_epilogue(u8 **pprog)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	/* lea rsp, [rbp+0x8] */
-	EMIT4(0x48, 0x8D, 0x65, 0x08);
+	/* leave (restore rsp and rbp) */
+	EMIT1(0xC9);
+	/* pop rbx (skip over tail_call_cnt) */
+	EMIT1(0x5B);
 
 	/* pop rbx */
 	EMIT1(0x5B);
-	/* pop rbp */
-	EMIT1(0x5D);
 	/* pop r13 */
 	EMIT2(0x41, 0x5D);
 	/* pop r14 */
 	EMIT2(0x41, 0x5E);
 	/* pop r15 */
 	EMIT2(0x41, 0x5F);
+	/* pop rbp */
+	EMIT1(0x5D);
 
 	/* ret */
 	EMIT1(0xC3);
@@ -298,13 +306,13 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT3(0x8B, 0x45, 0x04);                  /* mov eax, dword ptr [rbp + 4] */
+	EMIT3(0x8B, 0x45, 0x0C);                  /* mov eax, dword ptr [rbp + 12] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
 #define OFFSET2 (27 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT3(0x89, 0x45, 0x04);                  /* mov dword ptr [rbp + 4], eax */
+	EMIT3(0x89, 0x45, 0x0C);                  /* mov dword ptr [rbp + 12], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
