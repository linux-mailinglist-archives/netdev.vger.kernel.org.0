Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5E8A1F79
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfH2Pni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbfH2Pni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 11:43:38 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B251421726
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567093417;
        bh=Bf7qPlGUF5ncgGF7xPwWfoZ96AH0GQTONCGSJJO0ILM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dB1NAEDT11NVk8mh8gwwVkr7ucDrdCe+aft7g9cEI3COyzU7wKZAlCjzp74TBAyVK
         slA4H/afXPvKvukQqpuRXEykZpQsK5ndXudmb0fvQPB7NuoH0SA9y3dU8126pMeASm
         gHCc04SuW8Pn0dpoarGsWK8P8jzEHrDS3EbJgMpo=
Received: by mail-wm1-f52.google.com with SMTP id v15so4257384wml.0
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 08:43:36 -0700 (PDT)
X-Gm-Message-State: APjAAAXMOCXZ8cpTeWduzZG/DfIRiH+wEb8OmcveXthlIGLsUjkcKi50
        h4PZmW48MywcSSpdsAYgL3ebx2FzaFvfPpNM06QO9w==
X-Google-Smtp-Source: APXvYqzRkyS1nWJSFtXBAeKXiKlI+EhmvqeWKaGcIIDOMF6gTOsTy80m0M5IDFc3+xAboKNjq3vs7k/iFGpPWRUG3HM=
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr12397339wmu.76.1567093415251;
 Thu, 29 Aug 2019 08:43:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828071421.GK2332@hirez.programming.kicks-ass.net> <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
 <20190829093434.36540972@gandalf.local.home>
In-Reply-To: <20190829093434.36540972@gandalf.local.home>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 29 Aug 2019 08:43:23 -0700
X-Gmail-Original-Message-ID: <CALCETrWYu0XB_d-MhXFgopEmBu-pog493G1e+KsE3dS32UULgA@mail.gmail.com>
Message-ID: <CALCETrWYu0XB_d-MhXFgopEmBu-pog493G1e+KsE3dS32UULgA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 6:34 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 28 Aug 2019 15:08:28 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Wed, Aug 28, 2019 at 09:14:21AM +0200, Peter Zijlstra wrote:
> > > On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:
> > >
> > > > > Tracing:
> > > > >
> > > > > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > > > > are necessary to:
> > >
> > > That's not tracing, that's perf.
> > >
>
> > re: your first comment above.
> > I'm not sure what difference you see in words 'tracing' and 'perf'.
> > I really hope we don't partition the overall tracing category
> > into CAP_PERF and CAP_FTRACE only because these pieces are maintained
> > by different people.
>
> I think Peter meant: It's not tracing, it's profiling.
>
> And there is a bit of separation between the two, although there is an
> overlap.
>
> Yes, perf can do tracing but it's designed more for profiling.

As I see it, there are a couple of reasons to split something into
multiple capabilities.  If they allow users to do well-defined things
that have materially different risks from the perspective of the
person granting the capabilities, then they can usefully be different.
Similarly, if one carries a risk of accidental use that another does
not, they should usefully be different.  An example of the first is
that CAP_NET_BIND_SERVICE has very different powers from
CAP_NET_ADMIN, whereas CAP_SYS_ADMIN and CAP_PTRACE are really quite
similar from a security perspective.  An example of the latter is that
CAP_DAC_OVERRIDE changes overall open() semantics and CAP_SYS_ADMIN
does not, at least not outside of /proc.

Things having different development histories and different
maintainers doesn't seem like a good reason to split the capabilities
IMO.

>
> > On one side perf_event_open() isn't really doing tracing (as step by
> > step ftracing of function sequences), but perf_event_open() opens
> > an event and the sequence of events (may include IP) becomes a trace.
> > imo CAP_TRACING is the best name to descibe the privileged space
> > of operations possible via perf_event_open, ftrace, kprobe, stack traces, etc.
>
> I have no issue with what you suggest. I guess it comes down to how
> fine grain people want to go. Do we want it to be all or nothing?
> Should CAP_TRACING allow for write access to tracefs? Or should we go
> with needing both CAP_TRACING and permissions in that directory
> (like changing the group ownership of the files at every boot).
>
> Perhaps we should have a CAP_TRACING_RO, that gives read access to
> tracefs (and write if the users have permissions). And have CAP_TRACING
> to allow full write access as well (allowing for users to add kprobe
> events and enabling tracers like the function tracer).

I can imagine splitting it into three capabilities:

CAP_TRACE_KERNEL: learn which kernel functions are called when.  This
would allow perf profiling, for example, but not sampling of kernel
regs.

CAP_TRACE_READ_KERNEL_DATA: allow the tracing, profiling, etc features
that can read the kernel's data.  So you get function arguments via
kprobe, kernel regs, and APIs that expose probe_kernel_read()

CAP_TRACE_USER: trace unrelated user processes

I'm not sure the code is written in a way that makes splitting
CAP_TRACE_KERNEL and CAP_TRACE_READ_KERNEL_DATA, and I'm not sure that
CAP_TRACE_KERNEL is all that useful except for plain perf record
without CAP_TRACE_READ_KERNEL_DATA.  What do you all think?  I suppose
it could also be:

CAP_PROFILE_KERNEL: Use perf with events that aren't kprobes or
tracepoints.  Does not grant the ability to sample regs or the kernel
stack directly.

CAP_TRACE_KERNEL: Use all of perf, ftrace, kprobe, etc.

CAP_TRACE_USER: Use all of perf with scope limited to user mode and uprobes.

> As the above seems to favor the idea of CAP_TRACING allowing write
> access to tracefs, should we have a CAP_TRACING_RO for just read access
> and limited perf abilities?

How about making a separate cap for limited perf capabilities along
the lines of the above?

For what it's worth, it should be straightforward using full tracing
to read out the kernel's random number pool, for example, but it would
be difficult or impossible to do that using just perf record -e
cycles.
