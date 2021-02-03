Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5667230E0EE
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhBCRZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:25:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232301AbhBCRYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 12:24:39 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE9B964F86;
        Wed,  3 Feb 2021 17:23:55 +0000 (UTC)
Date:   Wed, 3 Feb 2021 12:23:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
        Florian Weimer <fw@deneb.enyo.de>,
        syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com,
        syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com,
        Matt Mullins <mmullins@mmlx.us>
Subject: Re: [for-next][PATCH 14/15] tracepoint: Do not fail unregistering a
 probe due to memory failure
Message-ID: <20210203122354.5da83b21@gandalf.local.home>
In-Reply-To: <YBrYx3kCqiEH8HEw@hirez.programming.kicks-ass.net>
References: <20210203160517.982448432@goodmis.org>
        <20210203160550.710877069@goodmis.org>
        <YBrYx3kCqiEH8HEw@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 18:09:27 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Feb 03, 2021 at 11:05:31AM -0500, Steven Rostedt wrote:
> > +		if (new) {
> > +			for (i = 0; old[i].func; i++)
> > +				if ((old[i].func != tp_func->func
> > +				     || old[i].data != tp_func->data)
> > +				    && old[i].func != tp_stub_func)  
> 
> logical operators go at the end..

Agreed. I just added that "if (new) {" around the original block, didn't
think about the formatting when doing so.

> 
> > +					new[j++] = old[i];
> > +			new[nr_probes - nr_del].func = NULL;
> > +			*funcs = new;
> > +		} else {
> > +			/*
> > +			 * Failed to allocate, replace the old function
> > +			 * with calls to tp_stub_func.
> > +			 */
> > +			for (i = 0; old[i].func; i++)  
> 
> 							{
> 
> > +				if (old[i].func == tp_func->func &&
> > +				    old[i].data == tp_func->data) {  
> 
> like here.
> 
> > +					old[i].func = tp_stub_func;
> > +					/* Set the prio to the next event. */
> > +					if (old[i + 1].func)
> > +						old[i].prio =
> > +							old[i + 1].prio;  
> 
> multi line demands { }, but in this case just don't line-break.

Sure.

> 
> > +					else
> > +						old[i].prio = -1;
> > +				}  
> 
> 			}
> 
> > +			*funcs = old;
> > +		}
> >  	}
> >  	debug_print_probes(*funcs);
> >  	return old;
> > @@ -295,10 +341,12 @@ static int tracepoint_remove_func(struct tracepoint *tp,
> >  	tp_funcs = rcu_dereference_protected(tp->funcs,
> >  			lockdep_is_held(&tracepoints_mutex));
> >  	old = func_remove(&tp_funcs, func);
> > -	if (IS_ERR(old)) {
> > -		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
> > +	if (WARN_ON_ONCE(IS_ERR(old)))
> >  		return PTR_ERR(old);
> > -	}
> > +
> > +	if (tp_funcs == old)
> > +		/* Failed allocating new tp_funcs, replaced func with stub */
> > +		return 0;  
> 
> { }

Even if it's just a comment that causes multiple lines? I could just move
the comment above the if.

This has already been through my test suite, and since the changes
requested are just formatting and non-functional, I'll just add a clean up
patch on top.

Thanks!

-- Steve
