Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AE13A1A90
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbhFIQLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:11:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:55126 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhFIQLX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 12:11:23 -0400
IronPort-SDR: sAt8pXMOnbMBMDmdv5SJVqzoTpizSWIh53dNLjHcaT/rI67nw0IvchHdr5543vVZHpGrdokxPD
 krtnHJ5X2EDQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="185477303"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="185477303"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 09:04:02 -0700
IronPort-SDR: CgE1yeU5oBzGahGwILLMEy1eTwerjPOQIObEBLmB4MPFrZ8jaNIyrB3wTT8hL8p1D7TmoSYf1M
 1vZQUsendSCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="413789382"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2021 09:04:00 -0700
Date:   Wed, 9 Jun 2021 17:51:31 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf 1/2] bpf: Fix null ptr deref with mixed tail calls
 and subprogs
Message-ID: <20210609155131.GA12061@ranger.igk.intel.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
 <162318061518.323820.4329181800429686297.stgit@john-XPS-13-9370>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162318061518.323820.4329181800429686297.stgit@john-XPS-13-9370>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 12:30:15PM -0700, John Fastabend wrote:
> The sub-programs prog->aux->poke_tab[] is populated in jit_subprogs() and
> then used when emitting 'BPF_JMP|BPF_TAIL_CALL' insn->code from the
> individual JITs. The poke_tab[] to use is stored in the insn->imm by
> the code adding it to that array slot. The JIT then uses imm to find the
> right entry for an individual instruction. In the x86 bpf_jit_comp.c
> this is done by calling emit_bpf_tail_call_direct with the poke_tab[]
> of the imm value.
> 
> However, we observed the below null-ptr-deref when mixing tail call
> programs with subprog programs. For this to happen we just need to
> mix bpf-2-bpf calls and tailcalls with some extra calls or instructions
> that would be patched later by one of the fixup routines. So whats
> happening?
> 
> Before the fixup_call_args() -- where the jit op is done -- various
> code patching is done by do_misc_fixups(). This may increase the
> insn count, for example when we patch map_lookup_up using map_gen_lookup
> hook. This does two things. First, it means the instruction index,
> insn_idx field, of a tail call instruction will move by a 'delta'.
> 
> In verifier code,
> 
>  struct bpf_jit_poke_descriptor desc = {
>   .reason = BPF_POKE_REASON_TAIL_CALL,
>   .tail_call.map = BPF_MAP_PTR(aux->map_ptr_state),
>   .tail_call.key = bpf_map_key_immediate(aux),
>   .insn_idx = i + delta,
>  };
> 
> Then subprog start values subprog_info[i].start will be updated
> with the delta and any poke descriptor index will also be updated
> with the delta in adjust_poke_desc(). If we look at the adjust
> subprog starts though we see its only adjusted when the delta
> occurs before the new instructions,
> 
>         /* NOTE: fake 'exit' subprog should be updated as well. */
>         for (i = 0; i <= env->subprog_cnt; i++) {
>                 if (env->subprog_info[i].start <= off)
>                         continue;
> 
> Earlier subprograms are not changed because their start values
> are not moved. But, adjust_poke_desc() does the offset + delta
> indiscriminately. The result is poke descriptors are potentially
> corrupted.
> 
> Then in jit_subprogs() we only populate the poke_tab[]
> when the above insn_idx is less than the next subprogram start. From
> above we corrupted our insn_idx so we might incorrectly assume a
> poke descriptor is not used in a subprogram omitting it from the
> subprogram. And finally when the jit runs it does the deref of poke_tab
> when emitting the instruction and crashes with below. Because earlier
> step omitted the poke descriptor.
> 
> The fix is straight forward with above context. Simply move same logic
> from adjust_subprog_starts() into adjust_poke_descs() and only adjust
> insn_idx when needed.
> 
> [   88.487438] BUG: KASAN: null-ptr-deref in do_jit+0x184a/0x3290
> [   88.487455] Write of size 8 at addr 0000000000000008 by task test_progs/5295
> [   88.487490] Call Trace:
> [   88.487498]  dump_stack+0x93/0xc2
> [   88.487515]  kasan_report.cold+0x5f/0xd8
> [   88.487530]  ? do_jit+0x184a/0x3290
> [   88.487542]  do_jit+0x184a/0x3290
>  ...
> [   88.487709]  bpf_int_jit_compile+0x248/0x810
>  ...
> [   88.487765]  bpf_check+0x3718/0x5140
>  ...
> [   88.487920]  bpf_prog_load+0xa22/0xf10
> 
> CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
> Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  kernel/bpf/verifier.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 94ba5163d4c5..ac8373da849c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11408,7 +11408,7 @@ static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len
>  	}
>  }
>  
> -static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
> +static void adjust_poke_descs(struct bpf_prog *prog, u32 off, u32 len)
>  {
>  	struct bpf_jit_poke_descriptor *tab = prog->aux->poke_tab;
>  	int i, sz = prog->aux->size_poke_tab;
> @@ -11416,6 +11416,8 @@ static void adjust_poke_descs(struct bpf_prog *prog, u32 len)
>  
>  	for (i = 0; i < sz; i++) {
>  		desc = &tab[i];

Can we have a comment below that would say something like:
"don't update taicall's insn idx if the patching is being done on higher
insns" ?

What I'm saying is that after a long break from that code I find 'off' as
a confusing name. It's the offset within the flat-structured bpf prog (so
the prog that is not yet sliced onto subprogs). Maybe we could find a
better name for that, like "curr_insn_idx". I'm not sure what's your view
on that.

OTOH I'm aware that whole content of bpf_patch_insn_data operates on
'off'.

Generally sorry that I missed that, it didn't come to my mind to mix in
other helpers that include patching.

Anyway:
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> +		if (desc->insn_idx <= off)
> +			continue;
>  		desc->insn_idx += len - 1;
>  	}
>  }
> @@ -11436,7 +11438,7 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
>  	if (adjust_insn_aux_data(env, new_prog, off, len))
>  		return NULL;
>  	adjust_subprog_starts(env, off, len);
> -	adjust_poke_descs(new_prog, len);
> +	adjust_poke_descs(new_prog, off, len);
>  	return new_prog;
>  }
>  
> 
> 
