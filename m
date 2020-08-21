Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE1524DED0
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgHURoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:44:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:54066 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgHURoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:44:17 -0400
IronPort-SDR: mWxeZNfcG5y+WI0Q2VMGzdVHtdEBFdvSrIgHEuIeYUbQUjjp+uRaIOX5oWG/LrbUM2h7ennTpt
 AEv9fUa/kkTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="219878826"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="219878826"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:43:53 -0700
IronPort-SDR: mEb6d0/YJXbGaaVtvjKVghWGvIkJY4pP9aMJ6zktQ6WmwNMAmnLE82G8aRn1/DCGWlcQ94JFIR
 w/NsLekSeY2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="498601057"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 21 Aug 2020 10:43:50 -0700
Date:   Fri, 21 Aug 2020 19:38:15 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: tailcalls in BPF subprograms
Message-ID: <20200821173815.GA3811@ranger.igk.intel.com>
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
 <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
 <20200801071357.GA19421@ranger.igk.intel.com>
 <20200802030752.bnebgrr6jkl3dgnk@ast-mbp.dhcp.thefacebook.com>
 <f37dea67-9128-a1a2-beaa-2e74b321504a@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f37dea67-9128-a1a2-beaa-2e74b321504a@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 04:00:10PM +0200, Daniel Borkmann wrote:
> On 8/2/20 5:07 AM, Alexei Starovoitov wrote:
> > On Sat, Aug 01, 2020 at 09:13:57AM +0200, Maciej Fijalkowski wrote:
> > > On Sat, Aug 01, 2020 at 03:03:19AM +0200, Daniel Borkmann wrote:
> > > > On 7/31/20 2:03 AM, Maciej Fijalkowski wrote:
> > > > > v5->v6:
> > > > > - propagate only those poke descriptors that individual subprogram is
> > > > >     actually using (Daniel)
> > > > > - drop the cumbersome check if poke desc got filled in map_poke_run()
> > > > > - move poke->ip renaming in bpf_jit_add_poke_descriptor() from patch 4
> > > > >     to patch 3 to provide bisectability (Daniel)
> > > > 
> > > > I did a basic test with Cilium on K8s with this set, spawning a few Pods
> > > > and checking connectivity & whether we're not crashing since it has bit more
> > > > elaborate tail call use. So far so good. I was inclined to push the series
> > > > out, but there is one more issue I noticed and didn't notice earlier when
> > > > reviewing, and that is overall stack size:
> > > > 
> > > > What happens when you create a single program that has nested BPF to BPF
> > > > calls e.g. either up to the maximum nesting or one call that is using up
> > > > the max stack size which is then doing another BPF to BPF call that contains
> > > > the tail call. In the tail call map, you have the same program in there.
> > > > This means we create a worst case stack from BPF size of max_stack_size *
> > > > max_tail_call_size, that is, 512*32. So that adds 16k worst case. For x86
> > > > we have a stack of arch/x86/include/asm/page_64_types.h:
> > > > 
> > > >    #define THREAD_SIZE_ORDER       (2 + KASAN_STACK_ORDER)
> > > >   #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
> > > > 
> > > > So we end up with 16k in a typical case. And this will cause kernel stack
> > > > overflow; I'm at least not seeing where we handle this situation in the
> > 
> > Not quite. The subprog is always 32 byte stack (from safety pov).
> > The real stack (when JITed) can be lower or zero.
> > So the max stack is (512 - 32) * 32 = 15360.
> > So there is no overflow, but may be a bit too close to comfort.
> 
> I did a check with adding `stack_not_used(current)` to various points which
> provides some useful data under CONFIG_DEBUG_STACK_USAGE. From tc ingress side
> I'm getting roughly 13k free stack space which is definitely less than 15k even
> at tc layer. I also checked on sk_filter_trim_cap() on ingress and worst case I
> saw is very close to 12k, so a malicious or by accident a buggy program would be
> able to cause a stack overflow as-is.
> 
> > Imo the room is ok to land the set and the better enforcement can
> > be done as a follow up later, like below idea...
> > 
> > > > set. Hm, need to think more, but maybe this needs tracking of max stack
> > > > across tail calls to force an upper limit..
> > > 
> > > My knee jerk reaction would be to decrement the allowed max tail calls,
> > > but not sure if it's an option and if it would help.
> > 
> > How about make the verifier use a lower bound for a function with a tail call ?
> > Something like 64 would work.
> > subprog_info[idx].stack_depth with tail_call will be >= 64.
> > Then the main function will be automatically limited to 512-64 and the worst
> > case stack = 14kbyte.
> 
> Even 14k is way too close, see above. Some archs that are supported by the kernel
> run under 8k total stack size. In the long run if more archs would support tail
> calls with bpf-to-bpf calls, we might need a per-arch upper cap, but I think in
> this context here an upper total cap on x86 that is 4k should be reasonable, it
> sounds broken to me if more is indeed needed for the vast majority of use cases.
> 
> > When the sub prog with tail call is not an empty body (malicious stack
> > abuser) then the lower bound won't affect anything.
> > A bit annoying that stack_depth will be used by JIT to actually allocate
> > that much. Some of it will not be used potentially, but I think it's fine.
> > It's much simpler solution than to keep two variables to track stack size.
> > Or may be check_max_stack_depth() can be a bit smarter and it can detect
> > that subprog is using tail_call without actually hacking stack_depth variable.
> 
> +1, I think that would be better, maybe we could have a different cost function
> for the tail call counter itself depending in which call-depth we are, but that
> also requires two vars for tracking (tail call counter, call depth counter), so
> more JIT changes & emitted insns required. :/ Otoh, what if tail call counter
> is limited to 4k and we subtract stack usage instead with a min cost (e.g. 128)
> if progs use less than that? Though the user experience will be really bad in
> this case given these semantics feel less deterministic / hard to debug from
> user PoV.

Let's get this rolling again.
I like this approach, but from the opposite way - instead of decrementing
from 4k, let's start with 0 like we did before and add up the
max(stack_size, 128) on each tailcall as you suggested.

Reason for that is no need for changes in prologue, we can keep the xor
eax,eax insn which occupies 2 bytes whereas mov eax, 4096 needs 5 bytes
from what I see.

cmp eax, 4096 also needs more bytes than what cmp eax, MAX_TAIL_CALL_CNT
needed, but that's something we need as well as change mentioned below.

One last change is add eax, 1 becomes the add eax, max(stack_size, 128)
and it is also encoded differently.

Let me know if you're fine with that and if i can post v7.
Dirty patch below that I will squash onto patch 5 if it's fine.

From 01d2494eed07284ea56134f40c6a304b109090ab Mon Sep 17 00:00:00 2001
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Fri, 21 Aug 2020 14:04:27 +0200
Subject: [PATCH] bpf: track stack size in tailcall

WIP

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 37 ++++++++++++++++++++-----------------
 include/linux/bpf.h         |  1 +
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 880f283adb66..56b38536b1dd 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -393,7 +393,7 @@ static int get_pop_bytes(bool *callee_regs_used)
  * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
  *   if (index >= array->map.max_entries)
  *     goto out;
- *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
+ *   if (tail_call_stack_depth + stack_depth > MAX_TAIL_CALL_STACK_DEPTH)
  *     goto out;
  *   prog = array->ptrs[index];
  *   if (prog == NULL)
@@ -404,11 +404,12 @@ static int get_pop_bytes(bool *callee_regs_used)
 static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 					u32 stack_depth)
 {
-	int tcc_off = -4 - round_up(stack_depth, 8);
+	u16 sd = max_t(u16, round_up(stack_depth, 8), 128);
+	int tcsd_off = -4 - round_up(stack_depth, 8);
 	u8 *prog = *pprog;
 	int pop_bytes = 0;
-	int off1 = 49;
-	int off2 = 38;
+	int off1 = 49 + 4;
+	int off2 = 38 + 2;
 	int off3 = 16;
 	int cnt = 0;
 
@@ -438,15 +439,16 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_stack_depth > MAX_TAIL_CALL_STACK_DEPTH)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, tcc_off);         /* mov eax, dword ptr [rbp - tcc_off] */
-	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
+	EMIT2_off32(0x8B, 0x85, tcsd_off);        /* mov eax, dword ptr [rbp - tcsd_off] */
+	EMIT1_off32(0x3D,                         /* cmp eax, MAX_TAIL_CALL_STACK_DEPTH */
+		    MAX_TAIL_CALL_STACK_DEPTH);
 #define OFFSET2 (off2 + RETPOLINE_RCX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
-	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, tcc_off);         /* mov dword ptr [rbp - tcc_off], eax */
+	EMIT1_off32(0x05, sd);                    /* add eax, stack_depth */
+	EMIT2_off32(0x89, 0x85, tcsd_off);        /* mov dword ptr [rbp - tcsd_off], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x8C, 0xD6,       /* mov rcx, [rsi + rdx * 8 + offsetof(...)] */
@@ -488,10 +490,11 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 				      u8 **pprog, int addr, u8 *image,
 				      bool *callee_regs_used, u32 stack_depth)
 {
-	int tcc_off = -4 - round_up(stack_depth, 8);
+	u16 sd = max_t(u16, round_up(stack_depth, 8), 128);
+	int tcsd_off = -4 - round_up(stack_depth, 8);
 	u8 *prog = *pprog;
 	int pop_bytes = 0;
-	int off1 = 27;
+	int off1 = 27 + 2;
 	int poke_off;
 	int cnt = 0;
 
@@ -512,14 +515,14 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	poke_off = X86_PATCH_SIZE + pop_bytes + 7 + 1;
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_stack_depth > MAX_TAIL_CALL_STACK_DEPTH)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, tcc_off);             /* mov eax, dword ptr [rbp - tcc_off] */
-	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);         /* cmp eax, MAX_TAIL_CALL_CNT */
+	EMIT2_off32(0x8B, 0x85, tcsd_off);            /* mov eax, dword ptr [rbp - tcsd_off] */
+	EMIT1_off32(0x3D, MAX_TAIL_CALL_STACK_DEPTH); /* cmp eax, MAX_TAIL_CALL_STACK_DEPTH */
 	EMIT2(X86_JA, off1);                          /* ja out */
-	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, tcc_off);             /* mov dword ptr [rbp - tcc_off], eax */
+	EMIT1_off32(0x05, sd);                        /* add eax, stack_size */
+	EMIT2_off32(0x89, 0x85, tcsd_off);            /* mov dword ptr [rbp - tcsd_off], eax */
 
 	poke->tailcall_bypass = image + (addr - poke_off - X86_PATCH_SIZE);
 	poke->adj_off = X86_TAIL_CALL_OFFSET;
@@ -1430,7 +1433,7 @@ xadd:			if (is_imm8(insn->off))
 			ctx->cleanup_addr = proglen;
 			pop_callee_regs(&prog, callee_regs_used);
 			if (!bpf_prog_was_classic(bpf_prog) && tail_call_seen)
-				EMIT1(0x59); /* pop rcx, get rid of tail_call_cnt */
+				EMIT1(0x59); /* pop rcx, get rid of tail_call_stack_depth */
 			EMIT1(0xC9);         /* leave */
 			EMIT1(0xC3);         /* ret */
 			break;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c9c460a437ed..5600dfd2217a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -895,6 +895,7 @@ struct bpf_array {
 
 #define BPF_COMPLEXITY_LIMIT_INSNS      1000000 /* yes. 1M insns */
 #define MAX_TAIL_CALL_CNT 32
+#define MAX_TAIL_CALL_STACK_DEPTH 4096
 
 #define BPF_F_ACCESS_MASK	(BPF_F_RDONLY |		\
 				 BPF_F_RDONLY_PROG |	\
-- 
2.20.1

> 
> > Essentially I'm proposing to tweak this formula:
> > depth += round_up(max_t(u32, subprog[idx].stack_depth, 1), 32);
> > and replace 1 with 64 for subprogs with tail_call.
> > 
> 
