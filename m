Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD2627D94C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgI2Uxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:53:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:13113 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729365AbgI2Uxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:53:44 -0400
IronPort-SDR: rskgEad0DgPcO2AHn9HcmpvPqTtrYWj2r8v6NlKTwod1Kq1uHf/udlGArG6NSz8kF9TWdRCi3n
 guHWUdAmNvXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="159668561"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="159668561"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 13:53:43 -0700
IronPort-SDR: cOkihGD7tF0az2viF+jPPFy5yoIuxTi6iZkZY0PnHl7J90R/w0gEFNyMymDuOWQCzNbPCxdNP6
 tHKgvaWF2qpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="493478937"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 29 Sep 2020 13:53:41 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 2/2] bpf: x64: do not emit sub/add 0, %rsp when !stack_depth
Date:   Tue, 29 Sep 2020 22:46:53 +0200
Message-Id: <20200929204653.4325-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200929204653.4325-1-maciej.fijalkowski@intel.com>
References: <20200929204653.4325-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no particular reason for keeping the "sub 0, %rsp" insn within
the BPF's x64 JIT prologue.

When tail call code was skipping the whole prologue section these 7
bytes that represent the rsp subtraction could not be simply discarded
as the jump target address would be broken. An option to address that
would be to substitute it with nop7.

Right now tail call is skipping only first 11 bytes of target program's
prologue and "sub X, %rsp" is the first insn that is processed, so if
stack depth is zero then this insn could be omitted without the need for
nop7 swap.

Therefore, do not emit the "sub 0, %rsp" in prologue when program is not
making use of R10 register. Also, make the emission of "add X, %rsp"
conditional in tail call code logic and take into account the presence
of mentioned insn when calculating the jump offsets.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index a263918043ce..796506dcfc42 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -281,7 +281,8 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
 	EMIT1(0x55);             /* push rbp */
 	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
 	/* sub rsp, rounded_stack_depth */
-	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
+	if (stack_depth)
+		EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
 	if (tail_call_reachable)
 		EMIT1(0x50);         /* push rax */
 	*pprog = prog;
@@ -407,9 +408,9 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	int tcc_off = -4 - round_up(stack_depth, 8);
 	u8 *prog = *pprog;
 	int pop_bytes = 0;
-	int off1 = 49;
-	int off2 = 38;
-	int off3 = 16;
+	int off1 = 42;
+	int off2 = 31;
+	int off3 = 9;
 	int cnt = 0;
 
 	/* count the additional bytes used for popping callee regs from stack
@@ -421,6 +422,12 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	off2 += pop_bytes;
 	off3 += pop_bytes;
 
+	if (stack_depth) {
+		off1 += 7;
+		off2 += 7;
+		off3 += 7;
+	}
+
 	/*
 	 * rdi - pointer to ctx
 	 * rsi - pointer to bpf_array
@@ -465,8 +472,9 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	prog = *pprog;
 
 	EMIT1(0x58);                              /* pop rax */
-	EMIT3_off32(0x48, 0x81, 0xC4,             /* add rsp, sd */
-		    round_up(stack_depth, 8));
+	if (stack_depth)
+		EMIT3_off32(0x48, 0x81, 0xC4,     /* add rsp, sd */
+			    round_up(stack_depth, 8));
 
 	/* goto *(prog->bpf_func + X86_TAIL_CALL_OFFSET); */
 	EMIT4(0x48, 0x8B, 0x49,                   /* mov rcx, qword ptr [rcx + 32] */
@@ -491,7 +499,7 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	int tcc_off = -4 - round_up(stack_depth, 8);
 	u8 *prog = *pprog;
 	int pop_bytes = 0;
-	int off1 = 27;
+	int off1 = 20;
 	int poke_off;
 	int cnt = 0;
 
@@ -506,10 +514,14 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	 * total bytes for:
 	 * - nop5/ jmpq $off
 	 * - pop callee regs
-	 * - sub rsp, $val
+	 * - sub rsp, $val if depth > 0
 	 * - pop rax
 	 */
-	poke_off = X86_PATCH_SIZE + pop_bytes + 7 + 1;
+	poke_off = X86_PATCH_SIZE + pop_bytes + 1;
+	if (stack_depth) {
+		poke_off += 7;
+		off1 += 7;
+	}
 
 	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
@@ -533,7 +545,8 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	pop_callee_regs(pprog, callee_regs_used);
 	prog = *pprog;
 	EMIT1(0x58);                                  /* pop rax */
-	EMIT3_off32(0x48, 0x81, 0xC4, round_up(stack_depth, 8));
+	if (stack_depth)
+		EMIT3_off32(0x48, 0x81, 0xC4, round_up(stack_depth, 8));
 
 	memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
 	prog += X86_PATCH_SIZE;
-- 
2.20.1

