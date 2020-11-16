Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557102B5424
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgKPWKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:10:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgKPWKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:10:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E85A223BF;
        Mon, 16 Nov 2020 22:10:29 +0000 (UTC)
Date:   Mon, 16 Nov 2020 17:10:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     paulmck <paulmck@kernel.org>, Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
Message-ID: <20201116171027.458a6c17@gandalf.local.home>
In-Reply-To: <1368007646.46749.1605562481450.JavaMail.zimbra@efficios.com>
References: <00000000000004500b05b31e68ce@google.com>
        <20201115055256.65625-1-mmullins@mmlx.us>
        <20201116121929.1a7aeb16@gandalf.local.home>
        <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
        <20201116154437.254a8b97@gandalf.local.home>
        <20201116160218.3b705345@gandalf.local.home>
        <1368007646.46749.1605562481450.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 16:34:41 -0500 (EST)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- On Nov 16, 2020, at 4:02 PM, rostedt rostedt@goodmis.org wrote:
> 
> > On Mon, 16 Nov 2020 15:44:37 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >   
> >> If you use a stub function, it shouldn't affect anything. And the worse
> >> that would happen is that you have a slight overhead of calling the stub
> >> until you can properly remove the callback.  
> > 
> > Something like this:
> > 
> > (haven't compiled it yet, I'm about to though).

Still need more accounting to work on. Almost finished though. ;-)

> > 
> > -- Steve
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index 3f659f855074..8eab40f9d388 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -53,10 +53,16 @@ struct tp_probes {
> > 	struct tracepoint_func probes[];
> > };
> > 
> > -static inline void *allocate_probes(int count)
> > +/* Called in removal of a func but failed to allocate a new tp_funcs */
> > +static void tp_stub_func(void)  
> 
> I'm still not sure whether it's OK to call a (void) function with arguments.

Actually, I've done it. The thing is, what can actually happen? A void
function that simply returns should not do anything. If anything, the only
waste is that the caller would save more registers than necessary.

I can't think of anything that can actually happen, but perhaps there is. I
wouldn't want to make a stub function for every trace point (it wouldn't be
hard to do).

But perhaps we should ask the compiler people to make sure.

> 
> > +{
> > +	return;
> > +}
> > +
> > +static inline void *allocate_probes(int count, gfp_t extra_flags)
> > {
> > 	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
> > -				       GFP_KERNEL);
> > +				       GFP_KERNEL | extra_flags);
> > 	return p == NULL ? NULL : p->probes;
> > }
> > 
> > @@ -150,7 +156,7 @@ func_add(struct tracepoint_func **funcs, struct
> > tracepoint_func *tp_func,
> > 		}
> > 	}
> > 	/* + 2 : one for new probe, one for NULL func */
> > -	new = allocate_probes(nr_probes + 2);
> > +	new = allocate_probes(nr_probes + 2, 0);
> > 	if (new == NULL)
> > 		return ERR_PTR(-ENOMEM);
> > 	if (old) {
> > @@ -188,8 +194,9 @@ static void *func_remove(struct tracepoint_func **funcs,
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
> > @@ -207,15 +214,20 @@ static void *func_remove(struct tracepoint_func **funcs,
> > 		int j = 0;
> > 		/* N -> M, (N > 1, M > 0) */
> > 		/* + 1 for NULL */
> > -		new = allocate_probes(nr_probes - nr_del + 1);
> > -		if (new == NULL)
> > -			return ERR_PTR(-ENOMEM);
> > -		for (i = 0; old[i].func; i++)
> > -			if (old[i].func != tp_func->func
> > -					|| old[i].data != tp_func->data)
> > -				new[j++] = old[i];
> > -		new[nr_probes - nr_del].func = NULL;
> > -		*funcs = new;
> > +		new = allocate_probes(nr_probes - nr_del + 1, __GFP_NOFAIL);
> > +		if (new) {
> > +			for (i = 0; old[i].func; i++)
> > +				if (old[i].func != tp_func->func
> > +				    || old[i].data != tp_func->data)  
> 
> as you point out in your reply, skip tp_stub_func here too.
> 
> > +					new[j++] = old[i];
> > +			new[nr_probes - nr_del].func = NULL;
> > +		} else {
> > +			for (i = 0; old[i].func; i++)
> > +				if (old[i].func == tp_func->func &&
> > +				    old[i].data == tp_func->data)
> > +					old[i].func = tp_stub_func;  
> 
> I think you'll want a WRITE_ONCE(old[i].func, tp_stub_func) here, matched
> with a READ_ONCE() in __DO_TRACE. This introduces a new situation where the
> func pointer can be updated and loaded concurrently.

I thought about this a little, and then only thing we really should worry
about is synchronizing with those that unregister. Because when we make
this update, there are now two states. the __DO_TRACE either reads the
original func or the stub. And either should be OK to call.

Only the func gets updated and not the data. So what exactly are we worried
about here?

> 
> > +		}
> > +		*funcs = old;  
> 
> The line above seems wrong for the successful allocate_probe case. You will likely
> want *funcs = new on successful allocation, and *funcs = old for the failure case.

Yeah, it crashed because of this ;-)

Like I said, untested!

-- Steve
