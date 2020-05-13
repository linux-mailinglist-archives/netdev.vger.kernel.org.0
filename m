Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657F21D1222
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 14:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbgEMMB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 08:01:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:55774 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgEMMB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 08:01:59 -0400
IronPort-SDR: 6YUN3gy2kgZG7j295pumrh/FRwi9j5m9+ZU6uZN2QWDWWVegsc4MkCCDQtJdiCULaZC6DKQi6F
 z46uTGoaA8Rg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 05:01:58 -0700
IronPort-SDR: 5UK9tc+QFHHtZVgAk6v85Us7XhMKRXyQGhTnCn6vXujSNP2yNSySJ9FLgFLvXwW5j1rXQfm6nY
 rdWgj1jIFa/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,387,1583222400"; 
   d="scan'208";a="409666355"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 13 May 2020 05:01:55 -0700
Date:   Wed, 13 May 2020 13:58:55 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, lmb@cloudflare.com,
        john.fastabend@gmail.com
Subject: Re: [RFC PATCH bpf-next 0/1] bpf, x64: optimize JIT
 prologue/epilogue generation
Message-ID: <20200513115855.GA3574@ranger.igk.intel.com>
References: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
 <2e3c6be0-e482-d856-7cc1-b1d03a26428e@iogearbox.net>
 <20200512000153.hfdeh653v533qbe6@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512000153.hfdeh653v533qbe6@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:01:53PM -0700, Alexei Starovoitov wrote:
> On Mon, May 11, 2020 at 10:05:25PM +0200, Daniel Borkmann wrote:
> > Hey Maciej,

Sorry for the delay.
Combining two answers in here (Alexei/Daniel). I appreciate your input.

> > 
> > On 5/11/20 4:39 PM, Maciej Fijalkowski wrote:
> > > Hi!
> > > 
> > > Today, BPF x86-64 JIT is preserving all of the callee-saved registers
> > > for each BPF program being JITed, even when none of the R6-R9 registers
> > > are used by the BPF program. Furthermore the tail call counter is always
> > > pushed/popped to/from the stack even when there is no tail call usage in
> > > BPF program being JITed. Optimization can be introduced that would
> > > detect the usage of R6-R9 and based on that push/pop to/from the stack
> > > only what is needed. Same goes for tail call counter.
> > > 
> > > Results look promising for such instruction reduction. Below are the
> > > numbers for xdp1 sample on FVL 40G NIC receiving traffic from pktgen:
> > > 
> > > * With optimization: 22.3 Mpps
> > > * Without:           19.0 mpps
> > > 
> > > So it's around 15% of performance improvement. Note that xdp1 is not
> > > using any of callee saved registers, nor the tail call, hence such
> > > speed-up.
> > > 
> > > There is one detail that needs to be handled though.
> > > 
> > > Currently, x86-64 JIT tail call implementation is skipping the prologue
> > > of target BPF program that has constant size. With the mentioned
> > > optimization implemented, each particular BPF program that might be
> > > inserted onto the prog array map and therefore be the target of tail
> > > call, could have various prologue size.
> > > 
> > > Let's have some pseudo-code example:
> > > 
> > > func1:
> > > pro
> > > code
> > > epi
> > > 
> > > func2:
> > > pro
> > > code'
> > > epi
> > > 
> > > func3:
> > > pro
> > > code''
> > > epi
> > > 
> > > Today, pro and epi are always the same (9/7) instructions. So a tail
> > > call from func1 to func2 is just a:
> > > 
> > > jump func2 + sizeof pro in bytes (PROLOGUE_SIZE)
> > > 
> > > With the optimization:
> > > 
> > > func1:
> > > pro
> > > code
> > > epi
> > > 
> > > func2:
> > > pro'
> > > code'
> > > epi'
> > > 
> > > func3:
> > > pro''
> > > code''
> > > epi''
> > > 
> > > For making the tail calls up and running with the mentioned optimization
> > > in place, x86-64 JIT should emit the pop registers instructions
> > > that were pushed on prologue before the actual jump. Jump offset should
> > > skip the instructions that are handling rbp/rsp, not the whole prologue.
> > > 
> > > A tail call within func1 would then need to be:
> > > epi -> pop what pro pushed, but no leave/ret instructions
> > > jump func2 + 16 // first push insn of pro'; if no push, then this would
> > >                  // a direct jump to code'
> > > 
> > > Magic value of 16 comes from count of bytes that represent instructions
> > > that are skipped:
> > > 0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> > > 55                      push   %rbp
> > > 48 89 e5                mov    %rsp,%rbp
> > > 48 81 ec 08 00 00 00    sub    $0x8,%rsp
> > > 
> > > which would in many cases add *more* instructions for tailcalls. If none
> > > of callee-saved registers are used, then there would be no overhead with
> > > such optimization in place.
> > > 
> > > I'm not sure how to measure properly the impact on the BPF programs that
> > > are utilizing tail calls. Any suggestions?
> > 
> > Right, so far the numbers above (no callee saved registers, no tail calls)
> > are really the best case scenario. I think programs not using callee saved
> > registers are probably very limited in what they do, and tail calls are often
> > used as well (although good enough for AF_XDP, for example). So I wonder how
> > far we would regress with callee saved registers and tail calls. For Cilium
> > right now you can roughly assume a worst case tail call depth of ~6 with static
> > jumps (that we patch to jmp/nop). Only in one case we have a tail call map
> > index that is non-static. In terms of registers, assume all of them are used
> > one way or another. If you could check the impact in such setting, that would
> > be great.

Alexei suggested progs/bpf_flow.c - is that a good start to you? It won't
reproduce the Cilium environment but I suppose this would give us a taste
of how much regression we might introduce with this approach for tail
calls.

> > 
> > > Daniel, Alexei, what is your view on this?
> > 
> > I think performance wise this would be both pro and con depending how tail
> > calls are used. One upside however, and I think you didn't mention it here
> > would be that we don't need to clamp used stack space to 512, so we could
> > actually track how much stack is used (or if any is used at all) and adapt
> > it between tail calls? Depending on the numbers, if we'd go that route, it

Hm, I didn't mention that because I don't destroy the stack frame from the
tail call 'caller' program (I mean that if A tailcalls to B, then A is a
'caller'). So sort of the old x86-64 JIT behavior is kept - if B returns
then it will go over leave/ret pair so that stack frame (that was created
by program A) is destroyed and we get back to the address that pushed to
stack by caller of main BPF program (A).

Whereas program A before actual tail call will only pop callee saved
registers and B will not manipulate rbp/rsp in prologue.

Such approach is allowing us to refer to the tail call counter in a
constant way, with a little hack that tail call counter is the first thing
pushed to stack, followed by callee-saved registers (if any), so
throughout the tailcalls its placement on stack is left untouched.

So to me, if we would like to get rid of maxing out stack space, then we
would have to do some dancing for preserving the tail call counter - keep
it in some unused register? Or epilogue would pop it from stack to some
register and target program's prologue would push it to stack from that
register (I am making this up probably). And rbp/rsp would need to be
created/destroyed during the program-to-program transition that happens
via tailcall. That would mean also more instructions.

BTW maxing out stack space was because of the way how tail call counter is
handled on x86-64 JIT?

I might be wrong though! :) or missing something obvious. Did you have a
chance to look at the actual patch that went among with this cover letter?

> > should rather be generalized and tracked via verifier so all JITs can behave
> > the same (and these workarounds in verifier lifted). But then 15% performance
> > improvement as you state above is a lot, probably we might regress at least
> > as much as well in your benchmark. I wonder whether there should be a knob
> > for it, though it's mainly implementation detail..
> 
> I was thinking about knob too, but users are rarely going to touch it,
> so if we go for opt-in it will mostly be unused except by few folks.
> So I think it's better to go with this approach unconditionally,
> but first I'd like to see the performance numbers in how it regresses
> the common case. AF_XDP's empty prog that does 'return XDP_PASS' is
> a rare case and imo not worth optimizing for, but I see a lot of value
> if this approach allows to lift tail_call vs bpf2bpf restriction.
> It looks to me that bpf2bpf will be able to work. prog_A will call into prog_B
> and if that prog does any kind of tail_call that tail_call will
> eventually finish and the execution will return to prog_A as normal.

If I am not missing anything then this would involve the rbp/rsp handling
as I stated earlier? If we agree on some way of handling tail call counter
then I can try this out (no 512 stack clamp and handling stack frame
throughout tail calls).

> So I'd like to ask for two things:
> 1. perf numbers for something like progs/bpf_flow.c before and after
> 2. removal of bpf2bpf vs tail_call restriction and new selftests to prove
> that it's working. that will include droping 512 stack clamp.
