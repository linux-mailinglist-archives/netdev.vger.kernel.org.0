Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D535B21E65F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 05:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgGNDge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 23:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgGNDge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 23:36:34 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E538AC061755;
        Mon, 13 Jul 2020 20:36:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m16so5241222pls.5;
        Mon, 13 Jul 2020 20:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4pKtxXD5uW5bqrdDTHd+u/sbZZ6ngHW7Y1Ck/na4mqk=;
        b=djxbHP+YYSXZr27XXad/vl4SP+097JssZiRic0/vKVqaPPBrMc82mdXZvfkrFZskT/
         QF9aucsCvGRwOCc9tJXHgdNBIZ68jagxYUwYeRtzyXzT0Ap8u5KrgeRX9cSPWEN6d7n5
         fIBgIpgBc+oKHUhV8ZQGjvwN19JBoyzOimFJ5CosNPeqrZinbwTrZ+5VBONiIMkbfRaG
         aGktWcPzRBkU2GCtbufyaZoKZWde4wZvlkrvxY2pl/r7Jvd+sRVfDVGmZf4e0YYvh9g+
         C9eH8pqKuJsOKZHNmb15wZbZ9SxOeC2FazcsbWzzK7iEmNnP9Mce4b6AL4f5rFDe0a40
         HSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4pKtxXD5uW5bqrdDTHd+u/sbZZ6ngHW7Y1Ck/na4mqk=;
        b=SLA2+da1UBqJKLm0dLaGdW5jLJpUI0N5L6J+hqd7xvAxS3U0/go12k0ShJZZJlb26t
         ki05Ab5Q7po5xbVylyTbDrBk5S5FDoXOGJEKQVRxJpUns4dsYxedd3JBht7gkN69mbZq
         ipdaEP5lCUOJKNk2WgE5kZIIhXQjOPBthHYLsTrspBo+9sj6tkZ5K+sLwUWv59jIedZs
         BkdqVqHs+3yy+AKafT8UIV8I/dfRQDVhGtO8nxDTU+71X6xKL3VOWyPv9zrCT/L9iFJn
         AvaiyCvGECBLgMlez8xqJizaXo7MLLlJLsjlJP9ElL6NFPHQjKIsyJXKtWzcpo02MyY2
         fA8w==
X-Gm-Message-State: AOAM531MBke94lW+y1atfcAgVTnrs0IogfzUTJsSL0P7wY95/aMaCZby
        spKl1i4TAQfNGGFjyOaAvIs=
X-Google-Smtp-Source: ABdhPJy3R5A353cfZPZeoubFnI09Sx68y7klNumerUxc5EpOMcyJPVQjrjAj12VPdpFoMz7m9eIFMg==
X-Received: by 2002:a17:90b:300a:: with SMTP id hg10mr2468786pjb.211.1594697793381;
        Mon, 13 Jul 2020 20:36:33 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ca])
        by smtp.gmail.com with ESMTPSA id a2sm16255442pfg.120.2020.07.13.20.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 20:36:32 -0700 (PDT)
Date:   Mon, 13 Jul 2020 20:36:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [RFC PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and
 tailcall handling in JIT
Message-ID: <20200714033630.2fw5wzljbkkfle3j@ast-mbp.dhcp.thefacebook.com>
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
 <20200702134930.4717-5-maciej.fijalkowski@intel.com>
 <20200710235632.lhn6edwf4a2l3kiz@ast-mbp.dhcp.thefacebook.com>
 <CAADnVQJhhQnjQdrQgMCsx2EDDwELkCvY7Zpfdi_SJUmH6VzZYw@mail.gmail.com>
 <CAADnVQ+AD0T_xqwk-fhoWV25iANs-FMCMVnn2-PALDxdODfepA@mail.gmail.com>
 <20200714010045.GB2435@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714010045.GB2435@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 03:00:45AM +0200, Maciej Fijalkowski wrote:
> On Fri, Jul 10, 2020 at 08:25:20PM -0700, Alexei Starovoitov wrote:
> > On Fri, Jul 10, 2020 at 8:20 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > Of course you are right.
> > > pop+nop+push is incorrect.
> > >
> > > How about the following instead:
> > > - during JIT:
> > > emit_jump(to_skip_below)  <- poke->tailcall_bypass
> 
> That's the jump to the instruction right after the poke->tailcall_target.

right. Mainly looking for better names than ip and ip_aux.

> > > pop_callee_regs
> > > emit_jump(to_tailcall_target) <- poke->tailcall_target
> 
> During JIT there's no tailcall_target so this will be nop5, right?

I thought it will be always jmp, but with new info I agree that
it will start with nop.

> 
> > >
> > > - Transition from one target to another:
> > > text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
> > > if (new_jmp != NULL)
> > >   text_poke(poke->tailcall_bypass, MOD jmp into nop);
> > > else
> > >   text_poke(poke->tailcall_bypass, MOD nop into jmp);
> > 
> > One more correction. I meant:
> > 
> > if (new_jmp != NULL) {
> >   text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
> 
> Problem with having the old_jmp here is that you could have the
> tailcall_target removed followed by the new program being inserted. So for
> that case old_jmp is NULL but we decided to not poke the
> poke->tailcall_target when removing the program, only the tailcall_bypass
> is poked back to jmp from nop. IOW old_jmp is not equal to what
> poke->tailcall_target currently stores. This means that
> bpf_arch_text_poke() would not be successful for this update and that is
> the reason of faking it in this patch.

got it.
I think it can be solved two ways:
1. add synchronize_rcu() after poking of tailcall_bypass into jmp
and then update tailcall_target into nop.
so the race you've described in cover letter won't happen.
In the future with sleepable progs we'd need to call sync_rcu_tasks_trace too.
Which will make poke_run even slower.

2. add a flag to bpf_arch_text_poke() to ignore 5 bytes in there
and update tailcall_target to new jmp.
The speed of poke_run will be faster,
but considering the speed of text_poke_bp() it's starting to feel like
premature optimization.

I think approach 1 is cleaner.
Then the pseudo code will be:
if (new_jmp != NULL) {
   text_poke(poke->tailcall_target, MOD_JMP, old ? old_jmp : NULL, new_jmp);
   if (!old)
     text_poke(poke->tailcall_bypass, MOD_JMP, bypass_addr, NULL /* into nop */);
} else {
   text_poke(poke->tailcall_bypass, MOD_JMP, NULL /* from nop */, bypass_addr);
   sync_rcu(); /* let progs finish */
   text_poke(poke->tailcall_target, MOD_JMP, old_jmp, NULL /* into nop */)
}

> 
> >   text_poke(poke->tailcall_bypass, MOD jmp into nop);
> > } else {
> >   text_poke(poke->tailcall_bypass, MOD nop into jmp);
> > }
> 
> I think that's what we currently (mostly) have. map_poke_run() is skipping
> the poke of poke->tailcall_target if new bpf_prog is NULL, just like
> you're proposing above. Of course I can rename the members in poke
> descriptor to names you're suggesting. I also assume that by text_poke you
> meant the bpf_arch_text_poke?

yep.

> 
> I've been able to hide the nop5 detection within the bpf_arch_text_poke so
> map_poke_run() is arch-independent in that approach. My feeling is that
> we don't need the old bpf_prog at all.
> 
> Some bits might change here due to the jump target alignment that I'm
> trying to introduce.

> Can you explain under what circumstances bpf_jit_binary_alloc() would not
> use get_random_int() ? Out of curiosity as from a quick look I can't tell
> when.

I meant when you're doing benchmarking get rid of that randomization
from bpf_jit_binary_alloc in your test kernel.

> I'm hitting the following check in do_jit():

I think aligning bypass_addr is a bit too much. Let it all be linear for now.
Since iTLB is sporadic it could be due to randomization and nothing to do
with additional jmp and unwind that this set is introducing.
