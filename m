Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D0930F897
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238195AbhBDQwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237778AbhBDQvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:51:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC1D664F5E;
        Thu,  4 Feb 2021 16:50:30 +0000 (UTC)
Date:   Thu, 4 Feb 2021 11:50:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
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
Message-ID: <20210204115029.3b707236@gandalf.local.home>
In-Reply-To: <1836191179.6214.1612375044968.JavaMail.zimbra@efficios.com>
References: <20210203160517.982448432@goodmis.org>
        <20210203160550.710877069@goodmis.org>
        <1836191179.6214.1612375044968.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 12:57:24 -0500 (EST)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > @@ -147,14 +154,34 @@ func_add(struct tracepoint_func **funcs, struct
> > tracepoint_func *tp_func,
> > 			if (old[nr_probes].func == tp_func->func &&
> > 			    old[nr_probes].data == tp_func->data)
> > 				return ERR_PTR(-EEXIST);
> > +			if (old[nr_probes].func == tp_stub_func)
> > +				stub_funcs++;
> > 		}
> > 	}
> > -	/* + 2 : one for new probe, one for NULL func */
> > -	new = allocate_probes(nr_probes + 2);
> > +	/* + 2 : one for new probe, one for NULL func - stub functions */
> > +	new = allocate_probes(nr_probes + 2 - stub_funcs);
> > 	if (new == NULL)
> > 		return ERR_PTR(-ENOMEM);
> > 	if (old) {
> > -		if (pos < 0) {
> > +		if (stub_funcs) {  
> 
> Considering that we end up implementing a case where we carefully copy over
> each item, I recommend we replace the two "memcpy" branches by a single item-wise
> implementation. It's a slow-path anyway, and reducing the overall complexity
> is a benefit for slow paths. Fewer bugs, less code to review, and it's easier to
> reach a decent testing state-space coverage.

Sure.

> 
> > +			/* Need to copy one at a time to remove stubs */
> > +			int probes = 0;
> > +
> > +			pos = -1;
> > +			for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> > +				if (old[nr_probes].func == tp_stub_func)
> > +					continue;
> > +				if (pos < 0 && old[nr_probes].prio < prio)
> > +					pos = probes++;
> > +				new[probes++] = old[nr_probes];
> > +			}
> > +			nr_probes = probes;  
> 
> Repurposing "nr_probes" from accounting for the number of items in the old
> array to counting the number of items in the new array in the middle of the
> function is confusing.
> 
> > +			if (pos < 0)
> > +				pos = probes;
> > +			else
> > +				nr_probes--; /* Account for insertion */  
> 
> This is probably why you need to play tricks with nr_probes here.
> 
> > +		} else if (pos < 0) {
> > 			pos = nr_probes;
> > 			memcpy(new, old, nr_probes * sizeof(struct tracepoint_func));
> > 		} else {
> > @@ -188,8 +215,9 @@ static void *func_remove(struct tracepoint_func **funcs,
> > 	/* (N -> M), (N > 1, M >= 0) probes */
> > 	if (tp_func->func) {
> > 		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> > -			if (old[nr_probes].func == tp_func->func &&
> > -			     old[nr_probes].data == tp_func->data)
> > +			if ((old[nr_probes].func == tp_func->func &&
> > +			     old[nr_probes].data == tp_func->data) ||
> > +			    old[nr_probes].func == tp_stub_func)
> > 				nr_del++;
> > 		}
> > 	}
> > @@ -208,14 +236,32 @@ static void *func_remove(struct tracepoint_func **funcs,
> > 		/* N -> M, (N > 1, M > 0) */
> > 		/* + 1 for NULL */
> > 		new = allocate_probes(nr_probes - nr_del + 1);
> > -		if (new == NULL)
> > -			return ERR_PTR(-ENOMEM);
> > -		for (i = 0; old[i].func; i++)
> > -			if (old[i].func != tp_func->func
> > -					|| old[i].data != tp_func->data)
> > -				new[j++] = old[i];
> > -		new[nr_probes - nr_del].func = NULL;
> > -		*funcs = new;
> > +		if (new) {
> > +			for (i = 0; old[i].func; i++)
> > +				if ((old[i].func != tp_func->func
> > +				     || old[i].data != tp_func->data)
> > +				    && old[i].func != tp_stub_func)
> > +					new[j++] = old[i];
> > +			new[nr_probes - nr_del].func = NULL;
> > +			*funcs = new;
> > +		} else {
> > +			/*
> > +			 * Failed to allocate, replace the old function
> > +			 * with calls to tp_stub_func.
> > +			 */
> > +			for (i = 0; old[i].func; i++)
> > +				if (old[i].func == tp_func->func &&
> > +				    old[i].data == tp_func->data) {
> > +					old[i].func = tp_stub_func;  
> 
> This updates "func" while readers are loading it concurrently. I would recommend
> using WRITE_ONCE here paired with READ_ONCE within __traceiter_##_name.

I'm fine with this change, but it shouldn't make a difference. As we don't
change the data, it doesn't matter which function the compiler calls.
Unless you are worried about the compiler tearing the read. It shouldn't,
but I'm fine with doing things for paranoid sake (especially if it doesn't
affect the performance).

> 
> > +					/* Set the prio to the next event. */  
> 
> I don't get why the priority needs to be changed here. Could it simply stay
> at its original value ? It's already in the correct priority order anyway.

I think it was left over from one of the various changes. As I went to v5,
and then back to v3, I missed revisiting the code, as I was under the
assumption that I had cleaned it up :-/

> 
> > +					if (old[i + 1].func)
> > +						old[i].prio =
> > +							old[i + 1].prio;
> > +					else
> > +						old[i].prio = -1;
> > +				}
> > +			*funcs = old;  
> 
> I'm not sure what setting *funcs to old achieves ? Isn't it already pointing
> to old ?

Again, I think one iteration may have changed it. And I kinda remember
keeping it just to be consistent (*funcs gets updated in the other paths,
and figured it was good to be "safe" and updated it again, even though the
logic has it already set).

> 
> I'll send a patch which applies on top of yours implementing my recommendations.
> It shrinks the code complexity nicely:

Looking at it now.

Thanks,

-- Steve
