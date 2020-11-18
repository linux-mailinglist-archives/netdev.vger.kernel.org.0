Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9D32B843A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgKRS63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:58:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgKRS62 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:58:28 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 900DA20639;
        Wed, 18 Nov 2020 18:58:25 +0000 (UTC)
Date:   Wed, 18 Nov 2020 13:58:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Segher Boessenkool <segher@kernel.crashing.org>,
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
Message-ID: <20201118135823.3f0d24b7@gandalf.local.home>
In-Reply-To: <87o8jutt2h.fsf@mid.deneb.enyo.de>
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
        <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
        <20201118121730.12ee645b@gandalf.local.home>
        <20201118181226.GK2672@gate.crashing.org>
        <87o8jutt2h.fsf@mid.deneb.enyo.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 19:31:50 +0100
Florian Weimer <fw@deneb.enyo.de> wrote:

> * Segher Boessenkool:
> 
> > On Wed, Nov 18, 2020 at 12:17:30PM -0500, Steven Rostedt wrote:  
> >> I could change the stub from (void) to () if that would be better.  
> >
> > Don't?  In a function definition they mean exactly the same thing (and
> > the kernel uses (void) everywhere else, which many people find clearer).  
> 
> And I think () functions expected a caller-provided parameter save
> area on powerpc64le, while (void) functions do not.  It does not
> matter for an empty function, but GCC prefers to use the parameter
> save area instead of setting up a stack frame if it is present.  So
> you get stack corruption if you call a () function as a (void)
> function.  (The other way round is fine.)

I wonder if we should define on all architectures a void void_stub(void),
in assembly, that just does a return, an not worry about gcc messing up the
creation of the stub function.

On x86_64:

GLOBAL(void_stub)
	retq


And so on.

-- Steve
