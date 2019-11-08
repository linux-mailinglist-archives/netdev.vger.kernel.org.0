Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F888F5A2A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbfKHVgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:36:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50140 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731657AbfKHVgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:36:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=u/rXS9sACG8pfSIHTvZQbSWH3YOQncP+X2SVgkQxufo=; b=hZbEh+4B/QnOGUfYFGT7EAdGE
        dUv4QSgb1HY12qyYvdwKcGwV61D0MzoqshMefhCYdEPsANMopZL46i9TTr1123A6kdP0EJckPnTO0
        ZTF4AONEnUtXajbL+M8gKzeXxTRzNwb7CWksrulW7nj2qvBGuVMe87dQWwRaulCz+DJBJyN3a4VEH
        kXox3UfpNTb4h5POpuBefNV5mmcPcxugiJGW+IeOd2Og+AW92Q1T/3xHeOr38dxjGsFTWuA9tY+8p
        G6NtfZ+Rplo+2OCsEYq1ApL99fTwMPu/dAuKot6cKDsh8r/FoDq12nR0som5Sy/L/f6+O2waEBcjh
        6bwWqEzmw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iTBvf-0003kZ-FS; Fri, 08 Nov 2019 21:36:27 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 48530980E2D; Fri,  8 Nov 2019 22:36:24 +0100 (CET)
Date:   Fri, 8 Nov 2019 22:36:24 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Message-ID: <20191108213624.GM3079@worktop.programming.kicks-ass.net>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-3-ast@kernel.org>
 <20191108091156.GG4114@hirez.programming.kicks-ass.net>
 <20191108093607.GO5671@hirez.programming.kicks-ass.net>
 <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
 <CAADnVQKmrVGVHM70OT0jc7reRp1LdWTM8dhE1Gde21oxw++jwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKmrVGVHM70OT0jc7reRp1LdWTM8dhE1Gde21oxw++jwg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 11:32:41AM -0800, Alexei Starovoitov wrote:
> On Fri, Nov 8, 2019 at 5:42 AM Alexei Starovoitov <ast@fb.com> wrote:
> >
> > On 11/8/19 1:36 AM, Peter Zijlstra wrote:
> > > On Fri, Nov 08, 2019 at 10:11:56AM +0100, Peter Zijlstra wrote:
> > >> On Thu, Nov 07, 2019 at 10:40:23PM -0800, Alexei Starovoitov wrote:
> > >>> Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
> > >>> nops/calls in kernel text into calls into BPF trampoline and to patch
> > >>> calls/nops inside BPF programs too.
> > >>
> > >> This thing assumes the text is unused, right? That isn't spelled out
> > >> anywhere. The implementation is very much unsafe vs concurrent execution
> > >> of the text.
> > >
> > > Also, what NOP/CALL instructions will you be hijacking? If you're
> > > planning on using the fentry nops, then what ensures this and ftrace
> > > don't trample on one another? Similar for kprobes.
> > >
> > > In general, what ensures every instruction only has a single modifier?
> >
> > Looks like you didn't bother reading cover letter and missed a month

I did indeed not. A Changelog should be self sufficient and this one is
sorely lacking. The cover leter is not preserved and should therefore
not contain anything of value that is not also covered in the
Changelogs.

> > of discussions between my and Steven regarding exactly this topic
> > though you were directly cc-ed in all threads :(

I read some of it; it is a sad fact that I cannot read all email in my
inbox, esp. not if, like in the last week or so, I'm busy hunting a
regression.

And what I did remember of the emails I saw left me with the questions
that were not answered by the changelog.

> > tldr for kernel fentry nops it will be converted to use
> > register_ftrace_direct() whenever it's available.

So why the rush and not wait for that work to complete? It appears to me
that without due coordination between bpf and ftrace badness could
happen.

> > For all other nops, calls, jumps that are inside BPF programs BPF infra
> > will continue modifying them through this helper.
> > Daniel's upcoming bpf_tail_call() optimization will use text_poke as well.

This is probably off topic, but isn't tail-call optimization something
done at JIT time and therefore not in need ot text_poke()?

> >  > I'm very uncomfortable letting random bpf proglets poke around in the
> > kernel text.
> >
> > 1. There is no such thing as 'proglet'. Please don't invent meaningless
> > names.

Again offtopic, but I'm not inventing stuff here:

  /prog'let/ [UK] A short extempore program written to meet an immediate, transient need.

which, methinks, succinctly captures the spirit of BPF.

> > 2. BPF programs have no ability to modify kernel text.

OK, that is good.

> > 3. BPF infra taking all necessary measures to make sure that poking
> > kernel's and BPF generated text is safe.

From the other subthread and your response below, it seems you are aware
that you in fact need text_poke_bp(). Again, it would've been excellent
Changelog/comment material to call out that the patch as presented is in
fact broken.

> I was thinking more about this.
> Peter,
> do you mind we apply your first patch:
> https://lore.kernel.org/lkml/20191007081944.88332264.2@infradead.org/
> to both tip and bpf-next trees?

That would indeed be a much better solution. I'll repost much of that on
Monday, and then we'll work on getting at the very least that one patch
in a tip/branch we can share.

> Then I can use text_poke_bp() as-is without any additional ugliness
> on my side that would need to be removed in few weeks.

This I do _NOT_ understand. Why are you willing to merge a known broken
patch? What is the rush, why can't you wait for all the prerequisites to
land?
