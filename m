Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AAB2239EC
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 13:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGQLCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 07:02:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:33551 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgGQLCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 07:02:50 -0400
IronPort-SDR: UbzkZFD1gchp0gkVTzSiUVBpcGbItVSswFRhjiQ3hR+JnYsjNMfI7L/tTIDNmKK1S67yIbpDok
 0PYOkQe9hE8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="147555190"
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="147555190"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 03:57:47 -0700
IronPort-SDR: yiYljeuoq+213VRiqNuEMCCUR+9/4/2PSuVeKsiXCTdxY6zXOzSKDy1T/AuLwM8LKPRwkBJYrb
 6N+5tkCR77yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="486929814"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jul 2020 03:57:45 -0700
Date:   Fri, 17 Jul 2020 12:52:55 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and tailcall
 handling in JIT
Message-ID: <20200717105255.GA11239@ranger.igk.intel.com>
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-5-maciej.fijalkowski@intel.com>
 <932141f5-7abb-1c01-111d-a64baf187a40@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <932141f5-7abb-1c01-111d-a64baf187a40@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 01:06:07AM +0200, Daniel Borkmann wrote:
> On 7/16/20 1:36 AM, Maciej Fijalkowski wrote:
> > This commit serves two things:
> > 1) it optimizes BPF prologue/epilogue generation
> > 2) it makes possible to have tailcalls within BPF subprogram
> > 
> > Both points are related to each other since without 1), 2) could not be
> > achieved.
> > 
> > In [1], Alexei says:
> > "The prologue will look like:
> > nop5
> > xor eax,eax  // two new bytes if bpf_tail_call() is used in this
> >               // function
> > push rbp
> > mov rbp, rsp
> > sub rsp, rounded_stack_depth
> > push rax // zero init tail_call counter
> > variable number of push rbx,r13,r14,r15
> > 
> > Then bpf_tail_call will pop variable number rbx,..
> > and final 'pop rax'
> > Then 'add rsp, size_of_current_stack_frame'
> > jmp to next function and skip over 'nop5; xor eax,eax; push rpb; mov
> > rbp, rsp'
> > 
> > This way new function will set its own stack size and will init tail
> > call
> > counter with whatever value the parent had.
> > 
> > If next function doesn't use bpf_tail_call it won't have 'xor eax,eax'.
> > Instead it would need to have 'nop2' in there."
> > 
> > Implement that suggestion.
> > 
> > Since the layout of stack is changed, tail call counter handling can not
> > rely anymore on popping it to rbx just like it have been handled for
> > constant prologue case and later overwrite of rbx with actual value of
> > rbx pushed to stack. Therefore, let's use one of the register (%rcx) that
> > is considered to be volatile/caller-saved and pop the value of tail call
> > counter in there in the epilogue.
> > 
> > Drop the BUILD_BUG_ON in emit_prologue and in
> > emit_bpf_tail_call_indirect where instruction layout is not constant
> > anymore.
> > 
> > Introduce new poke target, 'tailcall_bypass' to poke descriptor that is
> > dedicated for skipping the register pops and stack unwind that are
> > generated right before the actual jump to target program. Reflect also
> > the actual purpose of poke->ip and rename it to poke->tailcall_target so
> > that it will not the be confused with the poke target that is being
> > introduced here.
> > For case when the target program is not present, BPF program will skip
> > the pop instructions and nop5 dedicated for jmpq $target. An example of
> > such state when only R6 of callee saved registers is used by program:
> > 
> > ffffffffc0513aa1:       e9 0e 00 00 00          jmpq   0xffffffffc0513ab4
> > ffffffffc0513aa6:       5b                      pop    %rbx
> > ffffffffc0513aa7:       58                      pop    %rax
> > ffffffffc0513aa8:       48 81 c4 00 00 00 00    add    $0x0,%rsp
> > ffffffffc0513aaf:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> > ffffffffc0513ab4:       48 89 df                mov    %rbx,%rdi
> > 
> > When target program is inserted, the jump that was there to skip
> > pops/nop5 will become the nop5, so CPU will go over pops and do the
> > actual tailcall.
> > 
> > One might ask why there simply can not be pushes after the nop5?
> > In the following example snippet:
> > 
> > ffffffffc037030c:       48 89 fb                mov    %rdi,%rbx
> > (...)
> > ffffffffc0370332:       5b                      pop    %rbx
> > ffffffffc0370333:       58                      pop    %rax
> > ffffffffc0370334:       48 81 c4 00 00 00 00    add    $0x0,%rsp
> > ffffffffc037033b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> > ffffffffc0370340:       48 81 ec 00 00 00 00    sub    $0x0,%rsp
> > ffffffffc0370347:       50                      push   %rax
> > ffffffffc0370348:       53                      push   %rbx
> > ffffffffc0370349:       48 89 df                mov    %rbx,%rdi
> > ffffffffc037034c:       e8 f7 21 00 00          callq  0xffffffffc0372548
> > 
> > There is the bpf2bpf call (at ffffffffc037034c) right after the tailcall
> > and jump target is not present. ctx is in %rbx register and BPF
> > subprogram that we will call into on ffffffffc037034c is relying on it,
> > e.g. it will pick ctx from there. Such code layout is therefore broken
> > as we would overwrite the content of %rbx with the value that was pushed
> > on the prologue. That is the reason for the 'bypass' approach.
> > 
> > Special care needs to be taken during the install/update/remove of
> > tailcall target. In case when target program is not present, the CPU
> > must not execute the pop instructions that precede the tailcall.
> > 
> > To address that, the following states can be defined:
> > A nop, unwind, nop
> > B nop, unwind, tail
> > C skip, unwind, nop
> > D skip, unwind, tail
> > 
> > A is forbidden (lead to incorrectness). The state transitions between
> > tailcall install/update/remove will work as follows:
> > 
> > First install tail call f: C->D->B(f)
> >   * poke the tailcall, after that get rid of the skip
> > Update tail call f to f': B(f)->B(f')
> >   * poke the tailcall (poke->tailcall_target) and do NOT touch the
> >     poke->tailcall_bypass
> > Remove tail call: B(f')->C(f')
> >   * poke->tailcall_bypass is poked back to jump, then we wait the RCU
> >     grace period so that other programs will finish its execution and
> >     after that we are safe to remove the poke->tailcall_target
> > Install new tail call (f''): C(f')->D(f'')->B(f'').
> >   * same as first step
> > 
> > This way CPU can never be exposed to "unwind, tail" state.
> > 
> > For regression checks, 'tailcalls' kselftest was executed:
> > $ sudo ./test_progs -t tailcalls
> >   #64/1 tailcall_1:OK
> >   #64/2 tailcall_2:OK
> >   #64/3 tailcall_3:OK
> >   #64/4 tailcall_4:OK
> >   #64/5 tailcall_5:OK
> >   #64 tailcalls:OK
> > Summary: 1/5 PASSED, 0 SKIPPED, 0 FAILED
> > 
> > Tail call related cases from test_verifier kselftest are also working
> > fine. Sample BPF programs that utilize tail calls (sockex3, tracex5)
> > work properly as well.
> > 
> > [1]: https://lore.kernel.org/bpf/20200517043227.2gpq22ifoq37ogst@ast-mbp.dhcp.thefacebook.com/
> > 
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Overall approach looks reasonable to me. The patch here could still be cleaned up a
> bit further, still very rough. Just minor comments below:

Thank you for spotting all of the issues. I will provide a v2 on monday as
from today to sunday I will be out of reach.

> 
> > ---
> >   arch/x86/net/bpf_jit_comp.c | 241 +++++++++++++++++++++++++++---------
> >   include/linux/bpf.h         |   8 +-
> >   kernel/bpf/arraymap.c       |  61 +++++++--
> >   kernel/bpf/core.c           |   3 +-
> >   4 files changed, 239 insertions(+), 74 deletions(-)
> > 
> [...]
> >   /*
> > - * Emit x86-64 prologue code for BPF program and check its size.
> > + * Emit x86-64 prologue code for BPF program.
> >    * bpf_tail_call helper will skip it while jumping into another program
> >    */
> > -static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
> > +static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
> > +			  bool tail_call)
> >   {
> >   	u8 *prog = *pprog;
> >   	int cnt = X86_PATCH_SIZE;
> > @@ -238,19 +269,16 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
> >   	 */
> >   	memcpy(prog, ideal_nops[NOP_ATOMIC5], cnt);
> >   	prog += cnt;
> > +	if (!ebpf_from_cbpf && tail_call)
> > +		EMIT2(0x31, 0xC0);       /* xor eax, eax */
> > +	else
> > +		EMIT2(0x66, 0x90);       /* nop2 */
> 
> nit: Why does the ebpf_from_cbpf need the extra nop?

Good catch, it doesn't need it :)

> 
> >   	EMIT1(0x55);             /* push rbp */
> >   	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> >   	/* sub rsp, rounded_stack_depth */
> >   	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
> > -	EMIT1(0x53);             /* push rbx */
> > -	EMIT2(0x41, 0x55);       /* push r13 */
> > -	EMIT2(0x41, 0x56);       /* push r14 */
> > -	EMIT2(0x41, 0x57);       /* push r15 */
> > -	if (!ebpf_from_cbpf) {
> > -		/* zero init tail_call_cnt */
> > -		EMIT2(0x6a, 0x00);
> > -		BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
> > -	}
> > +	if (!ebpf_from_cbpf && tail_call)
> > +		EMIT1(0x50);         /* push rax */
> >   	*pprog = prog;
> >   }
> [...]
> > -static void emit_bpf_tail_call_indirect(u8 **pprog)
> > +static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
> > +					u32 stack_depth)
> >   {
> >   	u8 *prog = *pprog;
> > -	int label1, label2, label3;
> > +	int pop_bytes = 0;
> > +	int off1 = 49;
> > +	int off2 = 38;
> > +	int off3 = 16;
> >   	int cnt = 0;
> > +	/* count the additional bytes used for popping callee regs from stack
> > +	 * that need to be taken into account for each of the offsets that
> > +	 * are used for bailing out of the tail call
> > +	 */
> > +	pop_bytes = get_pop_bytes(callee_regs_used);
> > +	off1 += pop_bytes;
> > +	off2 += pop_bytes;
> > +	off3 += pop_bytes;
> > +
> >   	/*
> >   	 * rdi - pointer to ctx
> >   	 * rsi - pointer to bpf_array
> > @@ -370,72 +427,108 @@ static void emit_bpf_tail_call_indirect(u8 **pprog)
> >   	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
> >   	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], edx */
> >   	      offsetof(struct bpf_array, map.max_entries));
> > -#define OFFSET1 (41 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
> > +#define OFFSET1 (off1 + RETPOLINE_RCX_BPF_JIT_SIZE) /* Number of bytes to jump */
> 
> The whole rename belongs into the first patch to avoid breaking bisectability
> as mentioned.

Ack.

> 
> >   	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
> > -	label1 = cnt;
> >   	/*
> >   	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> >   	 *	goto out;
> >   	 */
> > -	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
> > +	EMIT2_off32(0x8B, 0x85                    /* mov eax, dword ptr [rbp - (4 + sd)] */,
> > +		    -4 - round_up(stack_depth, 8));
> >   	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
> > -#define OFFSET2 (30 + RETPOLINE_RAX_BPF_JIT_SIZE)
> > +#define OFFSET2 (off2 + RETPOLINE_RCX_BPF_JIT_SIZE)
> >   	EMIT2(X86_JA, OFFSET2);                   /* ja out */
> > -	label2 = cnt;
> >   	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
> > -	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
> > +	EMIT2_off32(0x89, 0x85,                   /* mov dword ptr [rbp - (4 + sd)], eax */
> > +		    -4 - round_up(stack_depth, 8));
> 
> nit: should probably sit in a var

Sure.

> 
> >   	/* prog = array->ptrs[index]; */
> > -	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
> > +	EMIT4_off32(0x48, 0x8B, 0x8C, 0xD6,        /* mov rcx, [rsi + rdx * 8 + offsetof(...)] */
> >   		    offsetof(struct bpf_array, ptrs));
> >   	/*
> >   	 * if (prog == NULL)
> >   	 *	goto out;
> >   	 */
> > -	EMIT3(0x48, 0x85, 0xC0);		  /* test rax,rax */
> > -#define OFFSET3 (8 + RETPOLINE_RAX_BPF_JIT_SIZE)
> > -	EMIT2(X86_JE, OFFSET3);                   /* je out */
> > -	label3 = cnt;
> > +	EMIT3(0x48, 0x85, 0xC9);                   /* test rcx,rcx */
> > +#define OFFSET3 (off3 + RETPOLINE_RCX_BPF_JIT_SIZE)
> > +	EMIT2(X86_JE, OFFSET3);                    /* je out */
> [...]
> 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index c67c88ad35f8..38897b9c7d61 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -651,14 +651,15 @@ enum bpf_jit_poke_reason {
> >   /* Descriptor of pokes pointing /into/ the JITed image. */
> >   struct bpf_jit_poke_descriptor {
> > -	void *ip;
> > +	void *tailcall_target;
> > +	void *tailcall_bypass;
> >   	union {
> >   		struct {
> >   			struct bpf_map *map;
> >   			u32 key;
> >   		} tail_call;
> >   	};
> > -	bool ip_stable;
> > +	bool tailcall_target_stable;
> 
> Probably makes sense to split off the pure rename into a separate patch to
> reduce this one slightly.

I was thinking of that as well. I will pull out as you're suggesting.

> 
> >   	u8 adj_off;
> >   	u16 reason;
> >   };
> > @@ -1775,6 +1776,9 @@ enum bpf_text_poke_type {
> >   	BPF_MOD_JUMP,
> >   };
> > +/* Number of bytes emit_patch() needs to generate instructions */
> > +#define X86_PATCH_SIZE		5
> 
> nit: this is arch specific, so should not be exposed in here, neither in
> arraymap.c below

Okay, so I think that we should add another member to poke descriptor that
will hold specifically the bypass address so that we wouldn't have to
calculate it in here. And I think this extension should go to this patch
whereas the renaming to a separate.

> 
> >   int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> >   		       void *addr1, void *addr2);
> > diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> > index c66e8273fccd..d15729a3f46c 100644
> > --- a/kernel/bpf/arraymap.c
> > +++ b/kernel/bpf/arraymap.c
> > @@ -750,6 +750,7 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
> >   				    struct bpf_prog *old,
> >   				    struct bpf_prog *new)
> >   {
> > +	u8 *bypass_addr, *old_addr, *new_addr;
> >   	struct prog_poke_elem *elem;
> >   	struct bpf_array_aux *aux;
> > @@ -770,12 +771,13 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
> >   			 *    there could be danger of use after free otherwise.
> >   			 * 2) Initially when we start tracking aux, the program
> >   			 *    is not JITed yet and also does not have a kallsyms
> > -			 *    entry. We skip these as poke->ip_stable is not
> > -			 *    active yet. The JIT will do the final fixup before
> > -			 *    setting it stable. The various poke->ip_stable are
> > -			 *    successively activated, so tail call updates can
> > -			 *    arrive from here while JIT is still finishing its
> > -			 *    final fixup for non-activated poke entries.
> > +			 *    entry. We skip these as poke->tailcall_target_stable
> > +			 *    is not active yet. The JIT will do the final fixup
> > +			 *    before setting it stable. The various
> > +			 *    poke->tailcall_target_stable are successively activated,
> > +			 *    so tail call updates can arrive from here while JIT
> > +			 *    is still finishing its final fixup for non-activated
> > +			 *    poke entries.
> >   			 * 3) On program teardown, the program's kallsym entry gets
> >   			 *    removed out of RCU callback, but we can only untrack
> >   			 *    from sleepable context, therefore bpf_arch_text_poke()
> > @@ -792,20 +794,53 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
> >   			 * 5) Any other error happening below from bpf_arch_text_poke()
> >   			 *    is a unexpected bug.
> >   			 */
> > -			if (!READ_ONCE(poke->ip_stable))
> > +			if (!READ_ONCE(poke->tailcall_target_stable))
> >   				continue;
> >   			if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
> >   				continue;
> >   			if (poke->tail_call.map != map ||
> >   			    poke->tail_call.key != key)
> >   				continue;
> > +			/* protect against un-updated poke descriptors since
> > +			 * we could fill them from subprog and the same desc
> > +			 * is present on main's program poke tab
> > +			 */
> > +			if (!poke->tailcall_bypass || !poke->tailcall_target)
> > +				continue;
> 
> Can't we avoid copying these descriptors over to the subprog in the first place?

I think we can, but can we consider it as something that we will do as a
follow-up?

> 
> > +			if (!old && !new)
> > +				continue;
> 
> Could we avoid this above but instead signal via bpf_arch_text_poke() that nothing
> had to be patched? Reason is that bpf_arch_text_poke() will still do the sanity
> check to make sure reality meets expectation wrt current insns (which is also
> why I didn't add this skip). In that case we could then just avoid the expensive
> synchronize_rcu().

I was even thinking to have such a check before walking through the poke
descriptors, so that's the opposite of what you suggest.

If you insist, I can play with this a bit on monday, but I recall that it
was the only thing that was stopping the Alexei's pseudo-code from being
fully functional (the nop->nop update).

> 
> > -			ret = bpf_arch_text_poke(poke->ip, BPF_MOD_JUMP,
> > -						 old ? (u8 *)old->bpf_func +
> > -						 poke->adj_off : NULL,
> > -						 new ? (u8 *)new->bpf_func +
> > -						 poke->adj_off : NULL);
> > -			BUG_ON(ret < 0 && ret != -EINVAL);
> > +			bypass_addr = (u8 *)poke->tailcall_target + X86_PATCH_SIZE;
> > +			old_addr = old ? (u8 *)old->bpf_func + poke->adj_off : NULL;
> > +			new_addr = new ? (u8 *)new->bpf_func + poke->adj_off : NULL;
> > +
> > +			if (new) {
> > +				ret = bpf_arch_text_poke(poke->tailcall_target,
> > +							 BPF_MOD_JUMP,
> > +							 old_addr, new_addr);
> > +				BUG_ON(ret < 0 && ret != -EINVAL);
> > +				if (!old) {
> > +					ret = bpf_arch_text_poke(poke->tailcall_bypass,
> > +								 BPF_MOD_JUMP,
> > +								 bypass_addr, NULL);
> > +					BUG_ON(ret < 0 && ret != -EINVAL);
> > +				}
> > +			} else {
> > +				ret = bpf_arch_text_poke(poke->tailcall_bypass,
> > +							 BPF_MOD_JUMP,
> > +							 NULL, bypass_addr);
> > +				BUG_ON(ret < 0 && ret != -EINVAL);
> > +				/* let other CPUs finish the execution of program
> > +				 * so that it will not possible to expose them
> > +				 * to invalid nop, stack unwind, nop state
> > +				 */
> > +				synchronize_rcu();
> 
> Very heavyweight that we need to potentially call this /multiple/ times for just a
> /single/ map update under poke mutex even ... but agree it's needed here to avoid
> racing. :(
> 
> > +				ret = bpf_arch_text_poke(poke->tailcall_target,
> > +							 BPF_MOD_JUMP,
> > +							 old_addr, NULL);
> > +				BUG_ON(ret < 0 && ret != -EINVAL);
> > +			}
> >   		}
> >   	}
> >   }
