Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008072B7DC6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 13:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgKRMqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 07:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgKRMqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 07:46:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF9A724180;
        Wed, 18 Nov 2020 12:46:10 +0000 (UTC)
Date:   Wed, 18 Nov 2020 07:46:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Matt Mullins <mmullins@mmlx.us>, paulmck <paulmck@kernel.org>,
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
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2] tracepoint: Do not fail unregistering a probe due to
 memory allocation
Message-ID: <20201118074609.20fdf9c4@gandalf.local.home>
In-Reply-To: <CAADnVQJekaejHo0eTnnUp68tOhwUv8t47DpGoOgc9Y+_19PpeA@mail.gmail.com>
References: <20201117211836.54acaef2@oasis.local.home>
        <CAADnVQJekaejHo0eTnnUp68tOhwUv8t47DpGoOgc9Y+_19PpeA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 20:54:24 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> >  extern int
> > @@ -310,7 +312,12 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
> >                 do {                                                    \
> >                         it_func = (it_func_ptr)->func;                  \
> >                         __data = (it_func_ptr)->data;                   \
> > -                       ((void(*)(void *, proto))(it_func))(__data, args); \
> > +                       /*                                              \
> > +                        * Removed functions that couldn't be allocated \
> > +                        * are replaced with TRACEPOINT_STUB.           \
> > +                        */                                             \
> > +                       if (likely(it_func != TRACEPOINT_STUB))         \
> > +                               ((void(*)(void *, proto))(it_func))(__data, args); \  
> 
> I think you're overreacting to the problem.

I will disagree with that.

> Adding run-time check to extremely unlikely problem seems wasteful.

Show me a real benchmark that you can notice a problem here. I bet that
check is even within the noise of calling an indirect function. Especially
on a machine with retpolines.

> 99.9% of the time allocate_probes() will do kmalloc from slab of small
> objects.
> If that slab is out of memory it means it cannot allocate a single page.
> In such case so many things will be failing to alloc that system
> is unlikely operational. oom should have triggered long ago.
> Imo Matt's approach to add __GFP_NOFAIL to allocate_probes()

Looking at the GFP_NOFAIL comment:

 * %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures. The allocation could block
 * indefinitely but will never return with failure. Testing for
 * failure is pointless.
 * New users should be evaluated carefully (and the flag should be
 * used only when there is no reasonable failure policy) but it is
 * definitely preferable to use the flag rather than opencode endless
 * loop around allocator.

I realized I made a mistake in my patch for using it, as my patch is a
failure policy. It looks like something we want to avoid in general.

Thanks, I'll send a v3 that removes it.

> when it's called from func_remove() is much better.
> The error was reported by syzbot that was using
> memory fault injections. ENOMEM in allocate_probes() was
> never seen in real life and highly unlikely will ever be seen.

And the biggest thing you are missing here, is that if you are running on a
machine that has static calls, this code is never hit unless you have more
than one callback on a single tracepoint. That's because when there's only
one callback, it gets called directly, and this loop is not involved.

-- Steve
