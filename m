Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837962B985F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgKSQof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:44:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:60554 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727853AbgKSQoe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 11:44:34 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 0AJGZWpN025422;
        Thu, 19 Nov 2020 10:35:32 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 0AJGZUTd025421;
        Thu, 19 Nov 2020 10:35:30 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 19 Nov 2020 10:35:29 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-toolchains@vger.kernel.org
Subject: Re: violating function pointer signature
Message-ID: <20201119163529.GV2672@gate.crashing.org>
References: <20201118132136.GJ3121378@hirez.programming.kicks-ass.net> <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com> <20201118121730.12ee645b@gandalf.local.home> <20201118181226.GK2672@gate.crashing.org> <87o8jutt2h.fsf@mid.deneb.enyo.de> <20201118135823.3f0d24b7@gandalf.local.home> <20201118191127.GM2672@gate.crashing.org> <20201119083648.GE3121392@hirez.programming.kicks-ass.net> <20201119143735.GU2672@gate.crashing.org> <20201119095951.30269233@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119095951.30269233@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 09:59:51AM -0500, Steven Rostedt wrote:
> On Thu, 19 Nov 2020 08:37:35 -0600
> Segher Boessenkool <segher@kernel.crashing.org> wrote:
> > > Note that we have a fairly extensive tradition of defining away UB with
> > > language extentions, -fno-strict-overflow, -fno-strict-aliasing,  
> > 
> > These are options to make a large swath of not correct C programs
> > compile (and often work) anyway.  This is useful because there are so
> > many such programs, because a) people did not lint; and/or b) the
> > problem never was obvious with some other (or older) compiler; and/or
> > c) people do not care about writing portable C and prefer writing in
> > their own non-C dialect.
> 
> Note, this is not about your average C program. This is about the Linux
> kernel, which already does a lot of tricks in C.

Yes, I know.  And some of that can be supported just fine (usually
because the compiler explicitly supports it); some of that will not
cause problems in practice (e.g. the scope it could cause problems in
is very limited); and some of that is just waiting to break down.  The
question is what category your situation here is in.  The middle one I
think.

> There's a lot of code in
> assembly that gets called from C (and vise versa).

That is just fine, that is what ABIs are for :-)

> We modify code on the
> fly (which tracepoints use two methods of that - with asm-goto/jump-labels
> and static functions).

And that is a lot trickier.  It can be made to work, but there are many
dark nooks and crannies problems can hide in.

> As for your point c), I'm not sure what you mean about portable C

I just meant "valid C language code as defined by the standards".  Many
people want all UB to just go away, while that is *impossible* to do for
many compilers: for example where different architectures or different
ABIs have contradictory requirements.

> (stuck to
> a single compiler, or stuck to a single architecture?). Linux obviously
> supports multiple architectures (more than any other OS), but it is pretty
> stuck to gcc as a compiler (with LLVM just starting to work too).
> 
> We are fine with being stuck to a compiler if it gives us what we want.

Right.  Just know that a compiler can make defined behaviour for *some*
things that are UB in standard C (possibly at a runtime performance
cost), but most things are not feasible.

Alexei's SPARC example (thanks!) shows that even "obvious" things are
not so obviously (or at all) implemented the way you expect on all
systems you care about.


Segher
