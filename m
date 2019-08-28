Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C4F9F795
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 02:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfH1Az4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 20:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbfH1Azz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 20:55:55 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAB5123403
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566953754;
        bh=ETl9UTqtFq5ucJEuRyuhovV2EjatmLdjv8DhhGnTaI8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WhXXiyRdTC7RrNGpcf5yrEs38uSVnMXkmXD7i5n44BShcZ5Ye6st+ddnm9P7Goc3l
         6EY2LusJ+LeLVq/2nl3tZKgSdJjlgzGFjwJufbYTShHHjmSqblhfa+LCm2r40wStAa
         LZHzc58zUe3mBh3uepPnqlbjZWW6mE5jXVxsvP28=
Received: by mail-wr1-f45.google.com with SMTP id y8so618637wrn.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 17:55:53 -0700 (PDT)
X-Gm-Message-State: APjAAAVsopYdehcLMS//gs9PcuI+la7PWanL9xAaFFceIpsCDSaUr2e/
        QZF+yqbypxVJdVKLoUqvsNYUrIWl2cvULtfo0+aiCg==
X-Google-Smtp-Source: APXvYqz7r0mDuQDT80ezJPr/NGdVzagC8FvPkF15lLorc35oafp3cHwMFggCmvg21V2H5HVj+nxef3EIV+US8w+aylI=
X-Received: by 2002:adf:f18c:: with SMTP id h12mr794799wro.47.1566953752242;
 Tue, 27 Aug 2019 17:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 27 Aug 2019 17:55:41 -0700
X-Gmail-Original-Message-ID: <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
Message-ID: <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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

On Tue, Aug 27, 2019 at 5:34 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:
> > [adding some security and tracing folks to cc]
> >
> > On Tue, Aug 27, 2019 at 1:52 PM Alexei Starovoitov <ast@kernel.org> wrote:
> > >
> > > Introduce CAP_BPF that allows loading all types of BPF programs,
> > > create most map types, load BTF, iterate programs and maps.
> > > CAP_BPF alone is not enough to attach or run programs.
> > >
> > > Networking:
> > >
> > > CAP_BPF and CAP_NET_ADMIN are necessary to:
> > > - attach to cgroup-bpf hooks like INET_INGRESS, INET_SOCK_CREATE, INET4_CONNECT
> > > - run networking bpf programs (like xdp, skb, flow_dissector)
> > >
> > > Tracing:
> > >
> > > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > > are necessary to:
> > > - attach bpf program to raw tracepoint
> > > - use bpf_trace_printk() in all program types (not only tracing programs)
> > > - create bpf stackmap
> > >
> > > To attach bpf to perf_events perf_event_open() needs to succeed as usual.
> > >
> > > CAP_BPF controls BPF side.
> > > CAP_NET_ADMIN controls intersection where BPF calls into networking.
> > > perf_paranoid_tracepoint_raw controls intersection where BPF calls into tracing.
> > >
> > > In the future CAP_TRACING could be introduced to control
> > > creation of kprobe/uprobe and attaching bpf to perf_events.
> > > In such case bpf_probe_read() thin wrapper would be controlled by CAP_BPF.
> > > Whereas probe_read() would be controlled by CAP_TRACING.
> > > CAP_TRACING would also control generic kprobe+probe_read.
> > > CAP_BPF and CAP_TRACING would be necessary for tracing bpf programs
> > > that want to use bpf_probe_read.
> >
> > First, some high-level review:
> >
> > Can you write up some clear documentation aimed at administrators that
> > says what CAP_BPF does?  For example, is it expected that CAP_BPF by
> > itself permits reading all kernel memory?
>
> hmm. the answer is in the sentence you quoted right above.

I was hoping for something in Documentation/admin-guide, not in a
changelog that's hard to find.

>
> > Can you give at least one fully described use case where CAP_BPF
> > solves a real-world problem that is not solved by existing mechanisms?
>
> bpftrace binary would be installed with CAP_BPF and CAP_TRACING.
> bcc tools would be installed with CAP_BPF and CAP_TRACING.
> perf binary would be installed with CAP_TRACING only.
> XDP networking daemon would be installed with CAP_BPF and CAP_NET_ADMIN.
> None of them would need full root.

As in just setting these bits in fscaps?  What does this achieve
beyond just installing them setuid-root or with CAP_SYS_ADMIN and
judicious use of capset internally?  For that matter, what prevents
unauthorized users from tracing the system if you do this?  This just
lets anyone trace the system, which seems like a mistake.

Can you clarify your example or give another one?

>
> > Changing the capability that some existing operation requires could
> > break existing programs.  The old capability may need to be accepted
> > as well.
>
> As far as I can see there is no ABI breakage. Please point out
> which line of the patch may break it.

As a more or less arbitrary selection:

 void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 {
        if (!bpf_prog_kallsyms_candidate(fp) ||
-           !capable(CAP_SYS_ADMIN))
+           !capable(CAP_BPF))
                return;

Before your patch, a task with CAP_SYS_ADMIN could do this.  Now it
can't.  Per the usual Linux definition of "ABI break", this is an ABI
break if and only if someone actually did this in a context where they
have CAP_SYS_ADMIN but not all capabilities.  How confident are you
that no one does things like this?
 void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 {
        if (!bpf_prog_kallsyms_candidate(fp) ||
-           !capable(CAP_SYS_ADMIN))
+           !capable(CAP_BPF))
                return;

> > > ---
> > > I would prefer to introduce CAP_TRACING soon, since it
> > > will make tracing and networking permission model symmetrical.
> > >
> >
> > Here's my proposal for CAP_TRACING, documentation-style:
> >
> > --- begin ---
> >
> > CAP_TRACING enables a task to use various kernel features to trace
> > running user programs and the kernel itself.  CAP_TRACING also enables
> > a task to bypass some speculation attack countermeasures.  A task in
> > the init user namespace with CAP_TRACING will be able to tell exactly
> > what kernel code is executed and when, and will be able to read kernel
> > registers and kernel memory.  It will, similarly, be able to read the
> > state of other user tasks.
> >
> > Specifically, CAP_TRACING allows the following operations.  It may
> > allow more operations in the future:
> >
> >  - Full use of perf_event_open(), similarly to the effect of
> > kernel.perf_event_paranoid == -1.
>
> +1
>
> >  - Loading and attaching tracing BPF programs, including use of BPF
> > raw tracepoints.
>
> -1
>
> >  - Use of BPF stack maps.
>
> -1
>
> >  - Use of bpf_probe_read() and bpf_trace_printk().
>
> -1
>
> >  - Use of unsafe pointer-to-integer conversions in BPF.
>
> -1
>
> >  - Bypassing of BPF's speculation attack hardening measures and
> > constant blinding.  (Note: other mechanisms might also allow this.)
>
> -1
> All of the above are allowed by CAP_BPF.
> They are not allowed by CAP_TRACING.

Why?  I don't mean to discount your -1, and you may well have a
compelling reason.  If so, I'll change my proposal.

From the previous discussion, you want to make progress toward solving
a lot of problems with CAP_BPF.  One of them was making BPF
firewalling more generally useful. By making CAP_BPF grant the ability
to read kernel memory, you will make administrators much more nervous
to grant CAP_BPF.  Similarly, and correct me if I'm wrong, most of
these capabilities are primarily or only useful for tracing, so I
don't see why users without CAP_TRACING should get them.
bpf_trace_printk(), in particular, even has "trace" in its name :)

Also, if a task has CAP_TRACING, it's expected to be able to trace the
system -- that's the whole point.  Why shouldn't it be able to use BPF
to trace the system better?

>
> > CAP_TRACING does not override normal permissions on sysfs or debugfs.
> > This means that, unless a new interface for programming kprobes and
> > such is added, it does not directly allow use of kprobes.
>
> kprobes can be created via perf_event_open already.
> So above statement contradicts your first statement.

Hmm.  The way of using perf with kprobes that I'm familiar with is:

# perf probe --add func_name

And this uses "/sys/kernel/debug/tracing//kprobe_events" (with the
double slash!).  Is there indeed another way to do this?

Anyway, I didn't mean to exclude any existing perf_event_open()
mechanism -- what I meant was that, without some extension to my
proposal, /sys/kernel/debug/tracing wouldn't magically become
accessible due to CAP_TRACING.

>
> > If CAP_TRACING, by itself, enables a task to crash or otherwise
> > corrupt the kernel or other tasks, this will be considered a kernel
> > bug.
>
> +1
>
> > CAP_TRACING in a non-init user namespace may, in the future, allow
> > tracing of other tasks in that user namespace or its descendants.  It
> > will not enable kernel tracing or tracing of tasks outside the user
> > namespace in question.
>
> I would avoid describing user ns for now.
> There is enough confusion without it.
>
> > --- end ---
> >
> > Does this sound good?  The idea here is that CAP_TRACING should be
> > very useful even without CAP_BPF, which allows CAP_BPF to be less
> > powerful.
>
> As proposed CAP_BPF does not allow tracing or networking on its own.
> CAP_BPF only controls BPF side.
>
> For example:
> BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
> {
>         int ret;
>
>         ret = probe_kernel_read(dst, unsafe_ptr, size);
>         if (unlikely(ret < 0))
>                 memset(dst, 0, size);
>
>         return ret;
> }
>
> All of BPF (including prototype of bpf_probe_read) is controlled by CAP_BPF.
> But the kernel primitives its using (probe_kernel_read) is controlled by CAP_TRACING.
> Hence a task needs _both_ CAP_BPF and CAP_TRACING to attach and run bpf program
> that uses bpf_probe_read.
>
> Similar with all other kernel code that BPF helpers may call directly or indirectly.
> If there is a way for bpf program to call into piece of code controlled by CAP_TRACING
> such helper would need CAP_BPF and CAP_TRACING.
> If bpf helper calls into something that may mangle networking packet
> such helper would need both CAP_BPF and CAP_NET_ADMIN to execute.

Why do you want to require CAP_BPF to call into functions like
bpf_probe_read()?  I understand why you want to limit access to bpf,
but I think that CAP_TRACING should be sufficient to allow the tracing
parts of BPF.  After all, a lot of your concerns, especially the ones
involving speculation, don't really apply to users with CAP_TRACING --
users with CAP_TRACING can read kernel memory with or without bpf.

>
> > > @@ -2080,7 +2083,10 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
> > >         struct bpf_prog *prog;
> > >         int ret = -ENOTSUPP;
> > >
> > > -       if (!capable(CAP_SYS_ADMIN))
> > > +       if (!capable(CAP_NET_ADMIN) || !capable(CAP_BPF))
> > > +               /* test_run callback is available for networking progs only.
> > > +                * Add cap_bpf_tracing() above when tracing progs become runable.
> > > +                */
> >
> > I think test_run should probably be CAP_SYS_ADMIN forever.  test_run
> > is the only way that one can run a bpf program and call helper
> > functions via the program if one doesn't have permission to attach the
> > program.
>
> Since CAP_BPF + CAP_NET_ADMIN allow attach. It means that a task
> with these two permissions will have programs running anyway.
> (traffic will flow through netdev, socket events will happen, etc)
> Hence no reason to disallow running program via test_run.
>

test_run allows fully controlled inputs, in a context where a program
can trivially flush caches, mistrain branch predictors, etc first.  It
seems to me that, if a JITted bpf program contains an exploitable
speculation gadget (MDS, Spectre v1, RSB, or anything else), it will
be *much* easier to exploit it using test_run than using normal
network traffic.  Similarly, normal network traffic will have network
headers that are valid enough to have caused the BPF program to be
invoked in the first place.  test_run can inject arbitrary garbage.
