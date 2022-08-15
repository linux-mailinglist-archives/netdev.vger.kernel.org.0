Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061F859311B
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiHOO5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHOO5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:57:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E21A1A054;
        Mon, 15 Aug 2022 07:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=35PiSrycvZePEg2FpFCAwxoALwiBP5+CAc/F+ajRY6Q=; b=H7+4HEwwXMWtNjyIxyU/ZlLIAb
        hFvadehrOwjtz7/deu55E5PKv0Plavk8ONWe0YSNcBsgx/VUhfwP11vMxbM0/33ZJHX0uT40uOM6e
        lzTre6xcEAoQQW6r/MZEUIsjlTnvaPCahQYYJ11WPCFG+9PO1CJfeKNgMHZcToZ5DerxDQ/eF6rqR
        AmhzoWf2kC+m3m4k6KKkS44rM4nWNUNXkASGoxuvy24NatNoRUUtCdBD++MTW9iubHl9E8VFaS84I
        Go8HWhyIUR86GFaeXkdjp6bn5MCI+VJ3kxXf7dCVLrSPowGATmiivPI0HLlOsPYP5dgbc1tfVWDTn
        usGwN5iA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNbWG-002h34-A8; Mon, 15 Aug 2022 14:56:44 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 54C42980153; Mon, 15 Aug 2022 16:56:43 +0200 (CEST)
Date:   Mon, 15 Aug 2022 16:56:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
Message-ID: <Yvpeq+vPz63n8gmi@worktop.programming.kicks-ass.net>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
 <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20220815101303.79ace3f8@gandalf.local.home>
 <CAADnVQLhHm-gxJXTbWxJN0fFGW_dyVV+5D-JahVA1Wrj2cGu7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQLhHm-gxJXTbWxJN0fFGW_dyVV+5D-JahVA1Wrj2cGu7g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 07:31:23AM -0700, Alexei Starovoitov wrote:
> On Mon, Aug 15, 2022 at 7:13 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 11 Dec 2019 13:30:13 +0100
> > Björn Töpel <bjorn.topel@gmail.com> wrote:
> >
> > > From: Björn Töpel <bjorn.topel@intel.com>
> > >
> > > The BPF dispatcher is a multi-way branch code generator, mainly
> > > targeted for XDP programs. When an XDP program is executed via the
> > > bpf_prog_run_xdp(), it is invoked via an indirect call. The indirect
> > > call has a substantial performance impact, when retpolines are
> > > enabled. The dispatcher transform indirect calls to direct calls, and
> > > therefore avoids the retpoline. The dispatcher is generated using the
> > > BPF JIT, and relies on text poking provided by bpf_arch_text_poke().
> > >
> > > The dispatcher hijacks a trampoline function it via the __fentry__ nop
> >
> > Why was the ftrace maintainers not Cc'd on this patch?  I would have NACKED
> > it. Hell, it wasn't even sent to LKML! This was BPF being sneaky in
> > updating major infrastructure of the Linux kernel without letting the
> > stakeholders of this change know about it.
> >
> > For some reason, the BPF folks think they own the entire kernel!
> >
> > When I heard that ftrace was broken by BPF I thought it was something
> > unique they were doing, but unfortunately, I didn't investigate what they
> > were doing at the time.
> 
> ftrace is still broken and refusing to accept the fact doesn't make it
> non-broken.

Alexei, stop this. The 'call __fentry__' sites are owned by ftrace.
Always have been. If BPF somehow thinks it can use them without telling
ftrace then it's BPF that's broken.

> > Then they started sending me patches to hide fentry locations from ftrace.
> > And even telling me that fentry != ftrace
> 
> It sounds that you've invented nop5 and kernel's ability
> to replace nop5 with a jump or call.

Ftrace has introduced the mcount/fentry patching into the kernel and has
always owned it for those sites. There is a lot of other text writing
not owned by ftrace. But the fentry sites are ftrace's.

Ftrace was also the one that got us the text_poke_bp() infrastructure
and got it reviewed by the CPU vendors.

Since then we've grown static_branch and static_call, they have their
own patch sites and do no interfere with ftrace.

> ftrace should really stop trying to own all of the kernel text rewrites.
> It's in the way. Like this case.

It doesn't. It hasn't. But it *does* own the fentry sites.

> It was implemented long before static_calls made it to the kernel
> and it's different.

It wasn't long before. Yes it landed a few months prior to the
static_call work, but the whole static_call thing was in progress for a
long long time.

Anyway, yes it is different. But it's still very much broken. You simply
cannot step on __fentry__ sites like that.


