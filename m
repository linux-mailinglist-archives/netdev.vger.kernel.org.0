Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83C99FA44
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfH1GMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfH1GMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:12:44 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ED2E2341C
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 06:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566972763;
        bh=ODzQkK6y27HTo68G01A4Bfylvnf3Ipj6FoWEYUVyD1k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yv6jQRLFdWGyyb5DKLDWI4t2UfhKj784gNv9AAHwaPaPDqXlVUckEmII5IcnMwuwL
         oeoN4MQtrfedcHvyrtZ+3C4G6tIzoUqgHXmGYh2e5XoffCSUf5ypfOAoAPMlUKjbbm
         ZIJ0FMdKEC7PWV/QS4W+Ii+fT2s7wv9kq2q1OGN8=
Received: by mail-wr1-f47.google.com with SMTP id b16so1145639wrq.9
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 23:12:43 -0700 (PDT)
X-Gm-Message-State: APjAAAXgUXA2GJQN4pzOlFxS7MAq60GYKYHghU40IgvHc4w0D8hzzb+7
        jOGnJv80ep3H3jY2TVsIZj9/fQi5jGbgBTsLc1QEmA==
X-Google-Smtp-Source: APXvYqwm8CdxDaqnZvTy7LYUZZA5fEy5yH/c41ZCti/xj4ypzoZ14FdW4nC0tYfmE9AtKy6W6kkpjlDxGD49ApJoba4=
X-Received: by 2002:adf:f18c:: with SMTP id h12mr2179606wro.47.1566972761352;
 Tue, 27 Aug 2019 23:12:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com> <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 27 Aug 2019 23:12:29 -0700
X-Gmail-Original-Message-ID: <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
Message-ID: <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
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

On Tue, Aug 27, 2019 at 9:43 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 27, 2019 at 05:55:41PM -0700, Andy Lutomirski wrote:
> >
> > I was hoping for something in Documentation/admin-guide, not in a
> > changelog that's hard to find.
>
> eventually yes.
>
> > >
> > > > Changing the capability that some existing operation requires could
> > > > break existing programs.  The old capability may need to be accepted
> > > > as well.
> > >
> > > As far as I can see there is no ABI breakage. Please point out
> > > which line of the patch may break it.
> >
> > As a more or less arbitrary selection:
> >
> >  void bpf_prog_kallsyms_add(struct bpf_prog *fp)
> >  {
> >         if (!bpf_prog_kallsyms_candidate(fp) ||
> > -           !capable(CAP_SYS_ADMIN))
> > +           !capable(CAP_BPF))
> >                 return;
> >
> > Before your patch, a task with CAP_SYS_ADMIN could do this.  Now it
> > can't.  Per the usual Linux definition of "ABI break", this is an ABI
> > break if and only if someone actually did this in a context where they
> > have CAP_SYS_ADMIN but not all capabilities.  How confident are you
> > that no one does things like this?
> >  void bpf_prog_kallsyms_add(struct bpf_prog *fp)
> >  {
> >         if (!bpf_prog_kallsyms_candidate(fp) ||
> > -           !capable(CAP_SYS_ADMIN))
> > +           !capable(CAP_BPF))
> >                 return;
>
> Yes. I'm confident that apps don't drop everything and
> leave cap_sys_admin only before doing bpf() syscall, since it would
> break their own use of networking.
> Hence I'm not going to do the cap_syslog-like "deprecated" message mess
> because of this unfounded concern.
> If I turn out to be wrong we will add this "deprecated mess" later.
>
> >
> > From the previous discussion, you want to make progress toward solving
> > a lot of problems with CAP_BPF.  One of them was making BPF
> > firewalling more generally useful. By making CAP_BPF grant the ability
> > to read kernel memory, you will make administrators much more nervous
> > to grant CAP_BPF.
>
> Andy, were your email hacked?
> I explained several times that in this proposal
> CAP_BPF _and_ CAP_TRACING _both_ are necessary to read kernel memory.
> CAP_BPF alone is _not enough_.

You have indeed said this many times.  You've stated it as a matter of
fact as though it cannot possibly discussed.  I'm asking you to
justify it.

> > Similarly, and correct me if I'm wrong, most of
> > these capabilities are primarily or only useful for tracing, so I
> > don't see why users without CAP_TRACING should get them.
> > bpf_trace_printk(), in particular, even has "trace" in its name :)
> >
> > Also, if a task has CAP_TRACING, it's expected to be able to trace the
> > system -- that's the whole point.  Why shouldn't it be able to use BPF
> > to trace the system better?
>
> CAP_TRACING shouldn't be able to do BPF because BPF is not tracing only.

What does "do BPF" even mean?  seccomp() does BPF.  SO_ATTACH_FILTER
does BPF.  Saying that using BPF should require a specific capability
seems kind of like saying that using the network should require a
specific capability.  Linux (and Unixy systems in general) distinguish
between binding low-number ports, binding high-number ports, using raw
sockets, and changing the system's IP address.  These have different
implications and require different capabilities.

It seems like you are specifically trying to add a new switch to turn
as much of BPF as possible on and off.  Why?

> >
> > test_run allows fully controlled inputs, in a context where a program
> > can trivially flush caches, mistrain branch predictors, etc first.  It
> > seems to me that, if a JITted bpf program contains an exploitable
> > speculation gadget (MDS, Spectre v1, RSB, or anything else),
>
> speaking of MDS... I already asked you to help investigate its
> applicability with existing bpf exposure. Are you going to do that?

I am blissfully uninvolved in MDS, and I don't know all that much more
about the overall mechanism than a random reader of tech news :)  ISTM
there are two meaningful ways that BPF could be involved: a BPF
program could leak info into the state exposed by MDS, or a BPF
program could try to read that state.  From what little I understand,
it's essentially inevitable that BPF leaks information into MDS state,
and this is probably even controllable by an attacker that understands
MDS in enough detail.    So the interesting questions are: can BPF be
used to read MDS state and can BPF be used to leak information in a
more useful way than the rest of the kernel to an attacker.

Keeping in mind that the kernel will flush MDS state on every exit to
usermode, I think the most likely attack is to try to read MDS state
with BPF.  This could happen, I suppose -- BPF programs can easily
contain the usual speculation gadgets of "do something and read an
address that depends on the outcome".  Fortunately, outside of
bpf_probe_read(), AFAIK BPF programs can't directly touch user memory,
and an attacker that is allowed to use bpf_probe_read() doesn't need
MDS to read things.

So it's not entirely obvious to me how an attack would be mounted.
test_run would make it a lot easier, I think.

>
> > it will
> > be *much* easier to exploit it using test_run than using normal
> > network traffic.  Similarly, normal network traffic will have network
> > headers that are valid enough to have caused the BPF program to be
> > invoked in the first place.  test_run can inject arbitrary garbage.
>
> Please take a look at Jann's var1 exploit. Was it hard to run bpf prog
> in controlled environment without test_run command ?
>

Can you send me a link?
