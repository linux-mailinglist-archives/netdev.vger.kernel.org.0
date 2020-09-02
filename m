Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3225B50E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgIBUHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:07:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:60000 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgIBUHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 16:07:16 -0400
IronPort-SDR: NWjj6LBupJqYAkSUj1b9RMPCLzPDOXrpnYvqIdN9JF9c2VbdUrdMbNPSqDcTcqpl62TuVk5UFg
 XHxb8rnB99Tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="154980234"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="154980234"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 13:07:14 -0700
IronPort-SDR: jGP5TPZCRaKlu79PWolS93WHKVNhMsTKszQvXobXh0HFIop/xjdhv/EzwLY/+cBjJiRV6Qglsc
 DWNYgb98iiOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="325919008"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 02 Sep 2020 13:07:12 -0700
Date:   Wed, 2 Sep 2020 22:01:19 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: tailcalls in BPF subprograms
Message-ID: <20200902200119.GA3564@ranger.igk.intel.com>
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
 <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
 <20200801071357.GA19421@ranger.igk.intel.com>
 <20200802030752.bnebgrr6jkl3dgnk@ast-mbp.dhcp.thefacebook.com>
 <f37dea67-9128-a1a2-beaa-2e74b321504a@iogearbox.net>
 <20200821173815.GA3811@ranger.igk.intel.com>
 <20200826213525.6rtjgehjptzqutag@ast-mbp.dhcp.thefacebook.com>
 <20200829231925.GB31692@ranger.igk.intel.com>
 <20200901162412.w7ty2xrtknm2nl64@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901162412.w7ty2xrtknm2nl64@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 09:24:12AM -0700, Alexei Starovoitov wrote:

[...]

> > > > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > > > index 880f283adb66..56b38536b1dd 100644
> > > > --- a/arch/x86/net/bpf_jit_comp.c
> > > > +++ b/arch/x86/net/bpf_jit_comp.c
> > > > @@ -393,7 +393,7 @@ static int get_pop_bytes(bool *callee_regs_used)
> > > >   * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
> > > >   *   if (index >= array->map.max_entries)
> > > >   *     goto out;
> > > > - *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
> > > > + *   if (tail_call_stack_depth + stack_depth > MAX_TAIL_CALL_STACK_DEPTH)
> > > >   *     goto out;
> > > 
> > > I don't think we cannot use this approach because it's not correct. Adding the
> > > stack_depth of the current function doesn't count stack space accurately.
> > > The bpf_tail_call will unwind the current stack. It's the caller's stack
> > > (in case of bpf2bpf) that matters from stack overflow pov.
> > 
> > I must admit I was puzzled when I came back to this stuff after a break,
> > because as you're saying before the actual tailcall we will unwind the
> > stack frame of tailcall's caller (or the current stack frame in simpler
> > terms).
> > 
> > So, to visualize a bit and so that I'm sure I follow:
> > 
> > func1 -> sub rsp, 128
> >   subfunc1 -> sub rsp, 256
> >   tailcall1 -> add rsp, 256
> >     func2 -> sub rsp, 256 (total stack size = 128 + 256 = 384)
> >     subfunc2 -> sub rsp, 64
> >     subfunc22 -> sub rsp, 128
> >     tailcall2 -> add rsp, 128
> >       func3 -> sub rsp, 256 (total stack size 128 + 256 + 64 + 256 = 704)
> > 
> > and so on. And this is what we have to address. If that's it, then thanks
> > for making it explicit that it's about the subprog caller's stack.
> 
> Right. The above is correct. Could you add it to the code as a comment?
> Please replace second and third use of 256 with a different constant to
> make it easier to see that 'sub rsp, X' in func1, func2, and func3 can
> be different.

Good stuff. I played with your suggestion to limit caller's stack depth
down to 256 when there is tailcall in subprogram by creating buffers on
stack among subprogs and use it in some stupid way so that verifier
wouldn't prune it and it seems that it is doing its job. For a moment I
was a bit confused if everything is all right since I saw that I hit the
stack depth of 480, but it was due to the fact that tailcall was in last
subprog AND previous stacks summarized were not above 256. IOW that last
stack will get unwinded before the tailcall as mentioned already multiple
times.

Thanks for all of the explanations below, that is pretty educational, but
I'm glad that I don't have to get my hands dirty with interpreter...yet :)

I wrapped the code you suggested with ifdefs same as the patch that allows
for having tailcalls in BPF subprogs.

Sending v7.

> 
> > > But this callee (that does tail_call eventually) can be called from multiple
> > > callsites in the caller and potentially from different callers, so
> > > the callee cannot know the stack value to subtract without additional verifier help.
> > > We can try to keep the maximum depth of stack (including all call frames) in
> > > the verfier that leads to that callee with bpf_tail_call() and then pass it
> > > into JITs to do this stack accounting. It's reasonable additional complexity in
> > > the verifier, but it's painful to add the interpreter support.
> > 
> > Not sure if we're on the same page - we allow this set only for x64 arch.
> > Why do you mention the interpreter and other JITs?
> 
> It's not 100% mandatory to make the interpreter compatible with JIT,
> but we should always try to keep the parity when possible.
> Like when I was working on BPF trampoline I've considered to support JITed code
> only, since generation of trampoline itself requires Just-In-Time code
> generation. But I took the extra effort to make sure invoke_bpf_prog() in
> arch/x86/net/bpf_jit_comp.c supports interpreter as well. There could be bugs
> in the interpreter or JIT. Having two ways to execute the program is useful for
> many reasons.
> 
> In this case the new tail_call handling in x86 JIT will unwind the current stack,
> so existing interpreter handling of tail_call won't quite work.
> Take a look at bpf_patch_call_args(), JMP_CALL_ARGS:, and JMP_TAIL_CALL:.
> The JMP_TAIL_CALL will sort-of unwind the current stack, but the size of the stack
> will be reused for tail_call target function.
> Illustrating on your example:
>  func1 -> sub rsp, 128
>    subfunc1 -> sub rsp, 256
>    tailcall1 -> add rsp, 256
>      func2 -> sub rsp, 192 (total stack size = 128 + 192 = 320)
>      subfunc2 -> sub rsp, 64
>      subfunc22 -> sub rsp, 128
>      tailcall2 -> add rsp, 128
>        func3 -> sub rsp, 224 (total stack size 128 + 192 + 64 + 224 = 608)
> 
> The interpreter will call into subfunc1 with 256 bytes of the interpreter stack
> and will reuse it for tail_call into func2.
> If func2 needs 192, it's going to work fine, but if it needs more than 256
> there will be stack overflow.
> 
> We can disable mixing bpf2bpf calls and tail_calls when interpreter is used
> for now, but it would be good to support it somehow.
> 
> > We could introduce one of your suggestions to verifier and surround it with
> > proper ifdefs like patch 5/6 is doing it.
> 
> If we use the approach of changing JMP_TAIL_CALL pseudo insn to do:
> -               tail_call_cnt++;
> +               tail_call_stack += insn->off;
> then we have to update other JITs to do the same.
> Other JITs do NOT need to support bpf2bpf calls with tail_calls.
> they do NOT need to do current stack unwinding, but they have to match
> the new behavior of JMP_TAIL_CALL otherwise such interpreter vs JIT
> discrepancy will create plenty of unhappy users.
> 
> > > We would need to hack BPF_TAIL_CALL insn. Like we can store
> > > max_stack_of_all_callsites into insn->off when we do fixup_bpf_calls().
> > > Then interpreter will do:
> > > iff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index ed0b3578867c..9a8b54c1adb6 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -1532,10 +1532,10 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u6
> > > 
> > >                 if (unlikely(index >= array->map.max_entries))
> > >                         goto out;
> > > -               if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
> > > +               if (unlikely(tail_call_stack > MAX_TAIL_CALL_STACK /* 4096 */))
> > >                         goto out;
> > > 
> > > -               tail_call_cnt++;
> > > +               tail_call_stack += insn->off;
> > > 
> > > and similar thing JITs would have to do. That includes modifying all existing JITs.
> > 
> > Again, I don't get why we would have to address everything else besides
> > x64 JIT.
> > 
> > > 
> > > When bpf_tail_call() is called from top frame (instead of bpf-to-bpf subprog)
> > > we can init 'off' with 128, so the old 32 call limit will be preserved.
> > > But if we go with such massive user visible change I'd rather init 'off' with 32.
> > > Then the tail call cnt limit will be 4096/32 = 128 invocations.
> > > At least it will address a complain from folks that were hitting 32 limit.
> > > 
> > > Another approach is to use what I've suggested earlier.
> > > Adjust the math in check_max_stack_depth():
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 8a097a85d01b..9c6c909a1ab9 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -2982,6 +2982,11 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
> > >         int ret_prog[MAX_CALL_FRAMES];
> > > 
> > >  process_func:
> > > +       if (idx && subprog[idx].has_tail_call && depth >= 256) {
> > > +               verbose(env, "Cannot do bpf_tail_call when call stack of previous frames is %d bytes. Too large\n",
> > > +                       depth);
> > > +               return -EACCES;
> > > +       }
> > > Then the worst case stack will be 256 * 32 = 8k while tail_call_cnt of 32 will stay as-is.
> > > And no need to change interpreter or JITs.
> > 
> > I tend to lean towards simpler solutions as this work is already complex.
> > Let's hear Daniel's opinion though.
> 
> Let's go with this simpler solution. We can add fancier stack
> accounting later.
