Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69127A1B88
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfH2Nei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfH2Nei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:34:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6CE2339E;
        Thu, 29 Aug 2019 13:34:35 +0000 (UTC)
Date:   Thu, 29 Aug 2019 09:34:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190829093434.36540972@gandalf.local.home>
In-Reply-To: <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
        <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190828071421.GK2332@hirez.programming.kicks-ass.net>
        <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 15:08:28 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Aug 28, 2019 at 09:14:21AM +0200, Peter Zijlstra wrote:
> > On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:
> >   
> > > > Tracing:
> > > >
> > > > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > > > are necessary to:  
> > 
> > That's not tracing, that's perf.
> >   

> re: your first comment above.
> I'm not sure what difference you see in words 'tracing' and 'perf'.
> I really hope we don't partition the overall tracing category
> into CAP_PERF and CAP_FTRACE only because these pieces are maintained
> by different people.

I think Peter meant: It's not tracing, it's profiling.

And there is a bit of separation between the two, although there is an
overlap.

Yes, perf can do tracing but it's designed more for profiling.

> On one side perf_event_open() isn't really doing tracing (as step by
> step ftracing of function sequences), but perf_event_open() opens
> an event and the sequence of events (may include IP) becomes a trace.
> imo CAP_TRACING is the best name to descibe the privileged space
> of operations possible via perf_event_open, ftrace, kprobe, stack traces, etc.

I have no issue with what you suggest. I guess it comes down to how
fine grain people want to go. Do we want it to be all or nothing?
Should CAP_TRACING allow for write access to tracefs? Or should we go
with needing both CAP_TRACING and permissions in that directory
(like changing the group ownership of the files at every boot). 

Perhaps we should have a CAP_TRACING_RO, that gives read access to
tracefs (and write if the users have permissions). And have CAP_TRACING
to allow full write access as well (allowing for users to add kprobe
events and enabling tracers like the function tracer).

> 
> Another reason are kuprobes. They can be crated via perf_event_open
> and via tracefs. Are they in CAP_PERF or in CAP_FTRACE ? In both, right?
> Should then CAP_KPROBE be used ? that would be an overkill.
> It would partition the space even further without obvious need.
> 
> Looking from BPF angle... BPF doesn't have integration with ftrace yet.
> bpf_trace_printk is using ftrace mechanism, but that's 1% of ftrace.
> In the long run I really like to see bpf using all of ftrace.
> Whereas bpf is using a lot of 'perf'.
> And extending some perf things in bpf specific way.
> Take a look at how BPF_F_STACK_BUILD_ID. It's clearly perf/stack_tracing
> feature that generic perf can use one day.
> Currently it sits in bpf land and accessible via bpf only.
> Though its bpf only today I categorize it under CAP_TRACING.
> 
> I think CAP_TRACING privilege should allow task to do all of perf_event_open,
> kuprobe, stack trace, ftrace, and kallsyms.
> We can think of some exceptions that should stay under CAP_SYS_ADMIN,
> but most of the functionality available by 'perf' binary should be
> usable with CAP_TRACING. 'perf' can do bpf too.
> With CAP_BPF it would be all set.

As the above seems to favor the idea of CAP_TRACING allowing write
access to tracefs, should we have a CAP_TRACING_RO for just read access
and limited perf abilities?

-- Steve
