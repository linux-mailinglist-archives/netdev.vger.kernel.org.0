Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6B92B9B96
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgKSTgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:36:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:39398 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727593AbgKSTgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:36:31 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 0AJJRBpu004150;
        Thu, 19 Nov 2020 13:27:11 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 0AJJR87q004149;
        Thu, 19 Nov 2020 13:27:08 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 19 Nov 2020 13:27:08 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>
Subject: Re: violating function pointer signature
Message-ID: <20201119192708.GW2672@gate.crashing.org>
References: <20201118121730.12ee645b@gandalf.local.home> <20201118181226.GK2672@gate.crashing.org> <87o8jutt2h.fsf@mid.deneb.enyo.de> <20201118135823.3f0d24b7@gandalf.local.home> <20201118191127.GM2672@gate.crashing.org> <20201119083648.GE3121392@hirez.programming.kicks-ass.net> <20201119143735.GU2672@gate.crashing.org> <20201119095951.30269233@gandalf.local.home> <20201119163529.GV2672@gate.crashing.org> <fac6049651cf4cef92162bec84550458@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fac6049651cf4cef92162bec84550458@AcuMS.aculab.com>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 05:42:34PM +0000, David Laight wrote:
> From: Segher Boessenkool
> > Sent: 19 November 2020 16:35
> > I just meant "valid C language code as defined by the standards".  Many
> > people want all UB to just go away, while that is *impossible* to do for
> > many compilers: for example where different architectures or different
> > ABIs have contradictory requirements.
> 
> Some of the UB in the C language are (probably) there because
> certain (now obscure) hardware behaved that way.

Yes.

> For instance integer arithmetic may saturate on overflow
> (or do even stranger things if the sign is a separate bit).

And some still does!

> I'm not quite sure it was ever possible to write a C compiler
> for a cpu that processed numbers in ASCII (up to 10 digits),
> binary arithmetic was almost impossible.

A machine that really stores decimal numbers?  Not BCD or the like?
Yeah wow, that will be hard.

> There are also the CPU that only have 'word' addressing - so
> that 'pointers to characters' take extra instructions.

Such machines are still made, and are programmed in C as well.

> ISTM that a few years ago the gcc developers started looking
> at some of these 'UB' and decided they could make use of
> them to make some code faster (and break other code).

When UB would happen in some situation, the compiler can simply assume
that situation does not happen.  This makes it possible to do a lot of
optimisations (many to do with loops) that cannot be done otherwise
(including those to do with signed overflow).  And many of those
optimisations are worthwhile.

> One of the problems with UB is that whereas you might expect
> UB arithmetic to generate an unexpected result and/or signal
> it is completely open-ended and could fire an ICBM at the coder.

Yes, UB is undefined behaviour.  Unspecified is something else (and C
has that as well, also implementation-defined, etc.)

In some cases GCC (and any other modern compiler) can make UB be IB
instead, with some flag for example, like -fno-strict-* does.  In other
cases it isn't so easy at all.  In cases like you have here (where the
validity of what you want to do depends on the ABI in effect) things are
not easy :-/


Segher
