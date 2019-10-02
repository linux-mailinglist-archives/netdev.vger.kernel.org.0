Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105FDC948E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfJBXAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbfJBXAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:00:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC4F21848;
        Wed,  2 Oct 2019 23:00:28 +0000 (UTC)
Date:   Wed, 2 Oct 2019 19:00:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Andy Lutomirski" <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20191002190027.4e204ea8@gandalf.local.home>
In-Reply-To: <a98725c6-a7db-1d9f-7033-5ecd96438c8d@fb.com>
References: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
        <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
        <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
        <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
        <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
        <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
        <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
        <20190928193727.1769e90c@oasis.local.home>
        <201909301129.5A1129C@keescook>
        <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
        <20191001181052.43c9fabb@gandalf.local.home>
        <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
        <20191001184731.0ec98c7a@gandalf.local.home>
        <a98725c6-a7db-1d9f-7033-5ecd96438c8d@fb.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Oct 2019 17:18:21 +0000
Alexei Starovoitov <ast@fb.com> wrote:

> >> It's an interesting idea, but I don't think it can work.
> >> Please see bpf_trace_printk implementation in kernel/trace/bpf_trace.c
> >> It's a lot more than string printing.  
> > 
> > Well, trace_printk() is just string printing. I was thinking that the
> > bpf_trace_printk() could just use a vsnprintf() into a temporary buffer
> > (like trace_printk() does), and then call the trace event to write it
> > out.  
> 
> are you proposing to replicate get_trace_buf() functionality
> into bpf_trace_printk?

No, do you need bpf_trace_printk() to run in all contexts?
trace_printk() does the get_trace_buf() dance so that it can be called
without locks and from any context including NMIs.

> So print into temp string buffer is done twice?
> I'm not excited about such hack.
> And what's the goal? so that trace_bpf_print(string_msg);
> can go through _run-time_ check whether that particular trace event
> was allowed in tracefs ?

No, just to use a standard event instead of hacking into
trace_printk().

> That's not how file system acls are typically designed.
> The permission check is at open(). Not at write().
> If I understood you correctly you're proposing to check permissions
> at bpf program run-time which is no good.
> 
> bpf_trace_printk() already has one small buffer for
> probe_kernel_read-ing an unknown string to pass into %s.
> That's not ftrace. That's core tracing. That aspect is covered by 
> CAP_TRACING as well.

Then use that buffer.

> 
> 
> >>  
> >>> The user could then just enable the trace event from the file system. I
> >>> could also work on making instances work like /tmp does (with the
> >>> sticky bit) in creation. That way people with write access to the
> >>> instances directory, can make their own buffers that they can use (and
> >>> others can't access).  
> >>
> >> We tried instances in bcc in the past and eventually removed all the
> >> support. The overhead of instances is too high to be usable.  
> > 
> > What overhead? An ftrace instance should not have any more overhead than
> > the root one does (it's the same code). Or are you talking about memory
> > overhead?  
> 
> Yes. Memory overhead. Human users doing cat/echo into tracefs won't be
> creating many instances, so that's the only practical usage of them.

If it's a real event, it can go into any of the ftrace buffers (top
level or instance), but it gives you the choice.

> 
> >   
> >>  
> >>>
> >>>      
> >>>>
> >>>> Both 'trace' and 'trace_pipe' have quirky side effects.
> >>>> Like opening 'trace' file will make all parallel trace_printk() to be ignored.
> >>>> While reading 'trace_pipe' file will clear it.
> >>>> The point that traditional 'read' and 'write' ACLs don't map as-is
> >>>> to tracefs, so I would be careful categorizing things into
> >>>> confidentiality vs integrity only based on access type.  
> >>>
> >>> What exactly is the bpf_trace_printk() used for? I may have other ideas
> >>> that can help.  
> >>
> >> It's debugging of bpf programs. Same is what printk() is used for
> >> by kernel developers.
> >>  
> > 
> > How is it extracted? Just read from the trace or trace_pipe file?  
> 
> yep. Just like kernel devs look at dmesg when they sprinkle printk.
> btw, if you can fix 'trace' file issue that stops all trace_printk
> while 'trace' file is open that would be great.
> Some users have been bitten by this behavior. We even documented it.

The behavior is documented as well in the ftrace documentation. That's
why we suggest the trace_pipe redirected into a file so that you don't
lose data (unless the writer goes too fast). If you prefer a producer
consumer where you lose newer events (like perf does), you can turn off
overwrite mode, and it will drop events when the buffer is full (see
options/overwrite).

-- Steve
