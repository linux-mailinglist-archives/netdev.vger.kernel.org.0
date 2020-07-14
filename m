Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1950A21FEFB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgGNUzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:55:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:20282 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgGNUzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 16:55:18 -0400
IronPort-SDR: 75zQywvAJzFQKIjIU+FsPwsBdtGaCbI05L67yPo0CECBqhSMQvgt8HwaZLtO3kj6wPhesYCKYZ
 ku+M4RibfHeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233883280"
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="233883280"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 13:55:16 -0700
IronPort-SDR: 4Bb7Ud4pg5UYrsINMHhYf2Us2HiHbTpdMC43AXIMganEoGpXt4dRn2gbXWyTC7Jkutb4S5CpCU
 649wf2MkOrPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="299670487"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga002.jf.intel.com with ESMTP; 14 Jul 2020 13:55:14 -0700
Date:   Tue, 14 Jul 2020 22:50:35 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [RFC PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and
 tailcall handling in JIT
Message-ID: <20200714205035.GA4423@ranger.igk.intel.com>
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
 <20200702134930.4717-5-maciej.fijalkowski@intel.com>
 <20200710235632.lhn6edwf4a2l3kiz@ast-mbp.dhcp.thefacebook.com>
 <CAADnVQJhhQnjQdrQgMCsx2EDDwELkCvY7Zpfdi_SJUmH6VzZYw@mail.gmail.com>
 <CAADnVQ+AD0T_xqwk-fhoWV25iANs-FMCMVnn2-PALDxdODfepA@mail.gmail.com>
 <20200714010045.GB2435@ranger.igk.intel.com>
 <20200714033630.2fw5wzljbkkfle3j@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714033630.2fw5wzljbkkfle3j@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 08:36:30PM -0700, Alexei Starovoitov wrote:
> On Tue, Jul 14, 2020 at 03:00:45AM +0200, Maciej Fijalkowski wrote:
> > On Fri, Jul 10, 2020 at 08:25:20PM -0700, Alexei Starovoitov wrote:
> > > On Fri, Jul 10, 2020 at 8:20 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > Of course you are right.
> > > > pop+nop+push is incorrect.
> > > >
> > > > How about the following instead:
> > > > - during JIT:
> > > > emit_jump(to_skip_below)  <- poke->tailcall_bypass
> > 
> > That's the jump to the instruction right after the poke->tailcall_target.
> 
> right. Mainly looking for better names than ip and ip_aux.
> 
> > > > pop_callee_regs
> > > > emit_jump(to_tailcall_target) <- poke->tailcall_target
> > 
> > During JIT there's no tailcall_target so this will be nop5, right?
> 
> I thought it will be always jmp, but with new info I agree that
> it will start with nop.
> 
> > 
> > > >
> > > > - Transition from one target to another:
> > > > text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
> > > > if (new_jmp != NULL)
> > > >   text_poke(poke->tailcall_bypass, MOD jmp into nop);
> > > > else
> > > >   text_poke(poke->tailcall_bypass, MOD nop into jmp);
> > > 
> > > One more correction. I meant:
> > > 
> > > if (new_jmp != NULL) {
> > >   text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
> > 
> > Problem with having the old_jmp here is that you could have the
> > tailcall_target removed followed by the new program being inserted. So for
> > that case old_jmp is NULL but we decided to not poke the
> > poke->tailcall_target when removing the program, only the tailcall_bypass
> > is poked back to jmp from nop. IOW old_jmp is not equal to what
> > poke->tailcall_target currently stores. This means that
> > bpf_arch_text_poke() would not be successful for this update and that is
> > the reason of faking it in this patch.
> 
> got it.
> I think it can be solved two ways:
> 1. add synchronize_rcu() after poking of tailcall_bypass into jmp
> and then update tailcall_target into nop.
> so the race you've described in cover letter won't happen.
> In the future with sleepable progs we'd need to call sync_rcu_tasks_trace too.
> Which will make poke_run even slower.
> 
> 2. add a flag to bpf_arch_text_poke() to ignore 5 bytes in there
> and update tailcall_target to new jmp.
> The speed of poke_run will be faster,
> but considering the speed of text_poke_bp() it's starting to feel like
> premature optimization.
> 
> I think approach 1 is cleaner.
> Then the pseudo code will be:
> if (new_jmp != NULL) {
>    text_poke(poke->tailcall_target, MOD_JMP, old ? old_jmp : NULL, new_jmp);
>    if (!old)
>      text_poke(poke->tailcall_bypass, MOD_JMP, bypass_addr, NULL /* into nop */);
> } else {
>    text_poke(poke->tailcall_bypass, MOD_JMP, NULL /* from nop */, bypass_addr);
>    sync_rcu(); /* let progs finish */
>    text_poke(poke->tailcall_target, MOD_JMP, old_jmp, NULL /* into nop */)
> }

Seems like this does the job :) clever stuff with sync_rcu.
I tried this approach and one last thing that needs to be covered
separately is the case of nop->nop update. We should simply avoid poking
in this case. With this in place everything is functional.

I will update the patch and descriptions and send the non-RFC revision, if
you don't mind of course.

> 
> > 
> > >   text_poke(poke->tailcall_bypass, MOD jmp into nop);
> > > } else {
> > >   text_poke(poke->tailcall_bypass, MOD nop into jmp);
> > > }
> > 
> > I think that's what we currently (mostly) have. map_poke_run() is skipping
> > the poke of poke->tailcall_target if new bpf_prog is NULL, just like
> > you're proposing above. Of course I can rename the members in poke
> > descriptor to names you're suggesting. I also assume that by text_poke you
> > meant the bpf_arch_text_poke?
> 
> yep.
> 
> > 
> > I've been able to hide the nop5 detection within the bpf_arch_text_poke so
> > map_poke_run() is arch-independent in that approach. My feeling is that
> > we don't need the old bpf_prog at all.
> > 
> > Some bits might change here due to the jump target alignment that I'm
> > trying to introduce.
> 
> > Can you explain under what circumstances bpf_jit_binary_alloc() would not
> > use get_random_int() ? Out of curiosity as from a quick look I can't tell
> > when.
> 
> I meant when you're doing benchmarking get rid of that randomization
> from bpf_jit_binary_alloc in your test kernel.
> 
> > I'm hitting the following check in do_jit():
> 
> I think aligning bypass_addr is a bit too much. Let it all be linear for now.
> Since iTLB is sporadic it could be due to randomization and nothing to do
> with additional jmp and unwind that this set is introducing.
