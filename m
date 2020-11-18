Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D872B8458
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgKRTFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:05:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:54376 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgKRTFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:05:05 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 0AIIthGu019175;
        Wed, 18 Nov 2020 12:55:43 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 0AIIteOV019174;
        Wed, 18 Nov 2020 12:55:40 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 18 Nov 2020 12:55:40 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20201118185540.GL2672@gate.crashing.org>
References: <20201116175107.02db396d@gandalf.local.home> <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com> <20201117142145.43194f1a@gandalf.local.home> <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com> <20201117153451.3015c5c9@gandalf.local.home> <20201118132136.GJ3121378@hirez.programming.kicks-ass.net> <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com> <20201118121730.12ee645b@gandalf.local.home> <20201118181226.GK2672@gate.crashing.org> <87o8jutt2h.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8jutt2h.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 07:31:50PM +0100, Florian Weimer wrote:
> * Segher Boessenkool:
> 
> > On Wed, Nov 18, 2020 at 12:17:30PM -0500, Steven Rostedt wrote:
> >> I could change the stub from (void) to () if that would be better.
> >
> > Don't?  In a function definition they mean exactly the same thing (and
> > the kernel uses (void) everywhere else, which many people find clearer).
> 
> And I think () functions expected a caller-provided parameter save
> area on powerpc64le, while (void) functions do not.

Like I said (but you cut off, didn't realise it matters I guess):

> > In a function declaration that is not part of a definition it means no
> > information about the arguments is specified, a quite different thing.

Since the caller does not know if the callee will need a save area, it
has to assume it does.  Similar is true for many ABIs.

> It does not
> matter for an empty function, but GCC prefers to use the parameter
> save area instead of setting up a stack frame if it is present.  So
> you get stack corruption if you call a () function as a (void)
> function.  (The other way round is fine.)

If you have no prototype for a function, you have to assume worst case,
yes.  Calling things "a () function" can mean two things (a declaration
that is or isn't a definition, two very different things), so it helps
to be explicit about it.

Just use (void) and do not worry :-)


Segher
