Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D1E2B9578
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgKSOqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:46:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:45519 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgKSOqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 09:46:47 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 0AJEbiJe017745;
        Thu, 19 Nov 2020 08:37:44 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 0AJEbarp017727;
        Thu, 19 Nov 2020 08:37:36 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 19 Nov 2020 08:37:35 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20201119143735.GU2672@gate.crashing.org>
References: <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com> <20201117153451.3015c5c9@gandalf.local.home> <20201118132136.GJ3121378@hirez.programming.kicks-ass.net> <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com> <20201118121730.12ee645b@gandalf.local.home> <20201118181226.GK2672@gate.crashing.org> <87o8jutt2h.fsf@mid.deneb.enyo.de> <20201118135823.3f0d24b7@gandalf.local.home> <20201118191127.GM2672@gate.crashing.org> <20201119083648.GE3121392@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119083648.GE3121392@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 09:36:48AM +0100, Peter Zijlstra wrote:
> On Wed, Nov 18, 2020 at 01:11:27PM -0600, Segher Boessenkool wrote:
> > Calling this via a different declared function type is undefined
> > behaviour, but that is independent of how the function is *defined*.
> > Your program can make ducks appear from your nose even if that function
> > is never called, if you do that.  Just don't do UB, not even once!
> 
> Ah, see, here I think we disagree. UB is a flaw of the spec, but the
> real world often has very sane behaviour there (sometimes also very
> much not).

That attitude summons ducks.

> In this particular instance the behaviour is UB because the C spec
> doesn't want to pin down the calling convention, which is something I
> can understand.

How do you know?  Were you at the meetings where this was decided?

The most frequent reason something is made UB is when there are multiple
existing implementations with irreconcilable differences.

> But once you combine the C spec with the ABI(s) at hand,
> there really isn't two ways about it. This has to work, under the
> premise that the ABI defines a caller cleanup calling convention.

This is not clear at all (and what "caller cleanup calling convention"
would mean isn't either).  A function call at the C level does not
necessarily correspond at all with a function call at the ABI level, to
begin with.

> So in the view that the compiler is a glorified assembler,

But it isn't.

> Note that we have a fairly extensive tradition of defining away UB with
> language extentions, -fno-strict-overflow, -fno-strict-aliasing,

These are options to make a large swath of not correct C programs
compile (and often work) anyway.  This is useful because there are so
many such programs, because a) people did not lint; and/or b) the
problem never was obvious with some other (or older) compiler; and/or
c) people do not care about writing portable C and prefer writing in
their own non-C dialect.

> -fno-delete-null-pointer-checks etc..

This was added as a security hardening feature.  It of course also is
useful for other things -- most flags are.  It was not added to make yet
another dialect.


Segher
