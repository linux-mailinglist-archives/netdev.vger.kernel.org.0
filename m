Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39B521E4F3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 03:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgGNBFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 21:05:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:31826 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgGNBFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 21:05:25 -0400
IronPort-SDR: 4xLgp83rXTxDp406/EqDrsDos3JBBgCzIeS3U/3s8ClUQd5TiGK50XEmeyk0/4NDlj7583xjht
 dmp9ghzggqFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="233617914"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="233617914"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 18:05:24 -0700
IronPort-SDR: 98vjgs5eu/nwB7CI/YFVjU6MdU0Pj29keJ84DwlyG79cWv0PKRnjAgfWBMG0qVYzVN2mvij0wS
 wUxto5wR8Mog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="429583509"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 13 Jul 2020 18:05:22 -0700
Date:   Tue, 14 Jul 2020 03:00:45 +0200
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
Message-ID: <20200714010045.GB2435@ranger.igk.intel.com>
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
 <20200702134930.4717-5-maciej.fijalkowski@intel.com>
 <20200710235632.lhn6edwf4a2l3kiz@ast-mbp.dhcp.thefacebook.com>
 <CAADnVQJhhQnjQdrQgMCsx2EDDwELkCvY7Zpfdi_SJUmH6VzZYw@mail.gmail.com>
 <CAADnVQ+AD0T_xqwk-fhoWV25iANs-FMCMVnn2-PALDxdODfepA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+AD0T_xqwk-fhoWV25iANs-FMCMVnn2-PALDxdODfepA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 08:25:20PM -0700, Alexei Starovoitov wrote:
> On Fri, Jul 10, 2020 at 8:20 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > Of course you are right.
> > pop+nop+push is incorrect.
> >
> > How about the following instead:
> > - during JIT:
> > emit_jump(to_skip_below)  <- poke->tailcall_bypass

That's the jump to the instruction right after the poke->tailcall_target.

> > pop_callee_regs
> > emit_jump(to_tailcall_target) <- poke->tailcall_target

During JIT there's no tailcall_target so this will be nop5, right?

> >
> > - Transition from one target to another:
> > text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
> > if (new_jmp != NULL)
> >   text_poke(poke->tailcall_bypass, MOD jmp into nop);
> > else
> >   text_poke(poke->tailcall_bypass, MOD nop into jmp);
> 
> One more correction. I meant:
> 
> if (new_jmp != NULL) {
>   text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)

Problem with having the old_jmp here is that you could have the
tailcall_target removed followed by the new program being inserted. So for
that case old_jmp is NULL but we decided to not poke the
poke->tailcall_target when removing the program, only the tailcall_bypass
is poked back to jmp from nop. IOW old_jmp is not equal to what
poke->tailcall_target currently stores. This means that
bpf_arch_text_poke() would not be successful for this update and that is
the reason of faking it in this patch.

>   text_poke(poke->tailcall_bypass, MOD jmp into nop);
> } else {
>   text_poke(poke->tailcall_bypass, MOD nop into jmp);
> }

I think that's what we currently (mostly) have. map_poke_run() is skipping
the poke of poke->tailcall_target if new bpf_prog is NULL, just like
you're proposing above. Of course I can rename the members in poke
descriptor to names you're suggesting. I also assume that by text_poke you
meant the bpf_arch_text_poke?

I've been able to hide the nop5 detection within the bpf_arch_text_poke so
map_poke_run() is arch-independent in that approach. My feeling is that
we don't need the old bpf_prog at all.

Some bits might change here due to the jump target alignment that I'm
trying to introduce.
