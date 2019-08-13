Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3679A8C4C0
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfHMXYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfHMXYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 19:24:37 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D845C208C2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 23:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565738675;
        bh=IDa79GuxHq7Qqla/PhVad+zrJSyH+Vx2VFX4WK5JGBg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NfeLQjfeq0UtvNcro2xYItSPeN4/6O7CMibcvBIG1MAaNUGFf9jKIDngbUhedcC6/
         1MAPyO2sJEkhabCi55yGQBvFNbkjvatm9jV4+vmk5KrsbsQdBWarwtKq519WrK7MZn
         OI2p7kUXsP8cej1B4nvR22iEsdgcPEqbu3ufZrqE=
Received: by mail-wm1-f51.google.com with SMTP id p77so2075680wme.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 16:24:34 -0700 (PDT)
X-Gm-Message-State: APjAAAVIfxRDNWEXqH6S0EnfC3D0nzbrdxCIMHwEDarF2jX0NqcL4LZS
        cFZKWin2kmFlr4bf/jYXeMoCMfj5JeILfPAVZ5XYsQ==
X-Google-Smtp-Source: APXvYqwgTpjl41fR5CWj/fGmilJy1Egm8dXK/E6Vgtdq+/9WrFEqe15FjCShiOW2cL1g+fL6OZPhjmFPLOCzhHl0UoE=
X-Received: by 2002:a7b:c4d2:: with SMTP id g18mr5136350wmk.79.1565738673185;
 Tue, 13 Aug 2019 16:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com> <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp> <CAKOZuev8XY5+shG8SiWcx4z12QnkgzhcUqCHs9t+eV2z-6nzPA@mail.gmail.com>
In-Reply-To: <CAKOZuev8XY5+shG8SiWcx4z12QnkgzhcUqCHs9t+eV2z-6nzPA@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 13 Aug 2019 16:24:21 -0700
X-Gmail-Original-Message-ID: <CALCETrWu_g-hhQeEbq4OCfP9QSreRh3_FAfY-w0s9am0aJ1JAw@mail.gmail.com>
Message-ID: <CALCETrWu_g-hhQeEbq4OCfP9QSreRh3_FAfY-w0s9am0aJ1JAw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Daniel Colascione <dancol@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 3:27 PM Daniel Colascione <dancol@google.com> wrote:
>
> On Tue, Aug 13, 2019 at 2:58 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Aug 06, 2019 at 10:24:25PM -0700, Andy Lutomirski wrote:
> > > >
> > > > Inside containers and inside nested containers we need to start processes
> > > > that will use bpf. All of the processes are trusted.
> > >
> > > Trusted by whom?  In a non-nested container, the container manager
> > > *might* be trusted by the outside world.  In a *nested* container,
> > > unless the inner container management is controlled from outside the
> > > outer container, it's not trusted.  I don't know much about how
> > > Facebook's containers work, but the LXC/LXD/Podman world is moving
> > > very strongly toward user namespaces and maximally-untrusted
> > > containers, and I think bpf() should work in that context.
> >
> > agree that containers (namespaces) reduce amount of trust necessary
> > for apps to run, but the end goal is not security though.
> > Linux has become a single user system.
> > If user can ssh into the host they can become root.
> > If arbitrary code can run on the host it will be break out of any sandbox.
> > Containers are not providing the level of security that is enough
> > to run arbitrary code. VMs can do it better, but cpu bugs don't make it easy.
> > Containers are used to make production systems safer.
> > Some people call it more 'secure', but it's clearly not secure for
> > arbitrary code and that is what kernel.unprivileged_bpf_disabled allows.
> > When we say 'unprivileged bpf' we really mean arbitrary malicious bpf program.
> > It's been a constant source of pain. The constant blinding, randomization,
> > verifier speculative analysis, all spectre v1, v2, v4 mitigations
> > are simply not worth it. It's a lot of complex kernel code without users.
> > There is not a single use case to allow arbitrary malicious bpf
> > program to be loaded and executed.
> > As soon as we have /dev/bpf to allow all of bpf to be used without root
> > we will set sysctl kernel.unprivileged_bpf_disabled=1
> > Hence I prefer this /dev/bpf mechanism to be as simple a possible.
> > The applications that will use it are going to be just as trusted as systemd.
> >
> > > > To solve your concern of bypassing all capable checks...
> > > > How about we do /dev/bpf/full_verifier first?
> > > > It will replace capable() checks in the verifier only.
> > >
> > > I'm not convinced that "in the verifier" is the right distinction.
> > > Telling administrators that some setting lets certain users bypass
> > > bpf() verifier checks doesn't have a clear enough meaning.
> >
> > linux is a single user system. there are no administrators any more.
> > No doubt, folks will disagree, but that game is over.
> > At least on bpf side it's done.
> >
> > > I propose,
> > > instead, that the current capable() checks be divided into three
> > > categories:
> >
> > I don't see a use case for these categories.
> > All bpf programs extend the kernel in some way.
> > The kernel vs user is one category.
> > Conceptually CAP_BPF is enough. It would be similar to CAP_NET_ADMIN.
> > When application has CAP_NET_ADMIN it covers all of networking knobs.
> > There is no use case that would warrant fine grain CAP_ROUTE_ADMIN,
> > CAP_ETHTOOL_ADMIN, CAP_ETH0_ADMIN, etc.
> > Similarly CAP_BPF as the only knob is enough.
> > The only disadvantage of CAP_BPF is that it's not possible to
> > pass it from one systemd-like daemon to another systemd-like daemon.
> > Hence /dev/bpf idea and passing file descriptor.
> >
> > > This type of thing actually fits quite nicely into an idea I've been
> > > thinking about for a while called "implicit rights". In very brief
> > > summary, there would be objects called /dev/rights/xyz, where xyz is
> > > the same of a "right".  If there is a readable object of the right
> > > type at the literal path "/dev/rights/xyz", then you have right xyz.
> > > There's a bit more flexibility on top of this.  BPF could use
> > > /dev/rights/bpf/maptypes/lpm and
> > > /dev/rights/bpf/verifier/bounded_loops, for example.  Other non-BPF
> > > use cases include a biggie:
> > > /dev/rights/namespace/create_unprivileged_userns.
> > > /dev/rights/bind_port/80 would be nice, too.
> >
> > The concept of "implicit rights" is very nice and I'm sure it will
> > be a good fit somewhere, but I don't see why use it in bpf space.
> > There is no use case for fine grain partition of bpf features.
>
> Isn't this "implicit rights" model just another kind of ambient
> authority --- one that constrains the otherwise-free filesystem
> namespace to boot?

Yes.

> IMHO, the kernel should be moving toward explicit
> authorization tokens modeled by file descriptors and away from
> contextual authorization decisions.

And yes, I agree there too. Here's how I think about it: there are
really two layers here:

Rights: these are objects like /dev/rights/bpf/some_bpf_privilege or
/dev/rights/namespace/unpriv_userns, and you would, ideally, use them
like genuine capabilities.  You'd pass an fd with appropriate access
(FMODE_READ, presumably, since exec is awkward to work with for fds)
into bpf() or similar, and the kernel would say "yep, caller has the
capability" and do something.  There's nothing really restricting them
to /dev/rights, but they more or less have to live on a memory-backed
file system (a real backing store has all kinds of issues), and
putting them in /dev gets a lot of nifty properties for free.  For
example, existing container systems that don't know about them will
automatically deny them to containers, since nothing with an ounce of
sense passes all of /dev through to a container.  But container
systems that are aware of them can bind-mount them into the container.
And /dev is already known to be magical due to things like
/dev/urandom.

The implicit part on top is less than ideal, but it solves two problems:

1. It keeps compatibility with existing code.  There are programs that
expect unshare(CLONE_NEWUSER) to work -- with *implicit* rights, it
will work exactly when it's supposed to.  Also, for cases like
CLONE_NEWUSER, it does have more or less the right semantics -- if
they were explicit, most programs would just try to open
/dev/rights/namespace/unpriv_userns and pass the fd to unshare2, so
we're not losing much.

2. For things like eBPF where the set of rights could be a moving
target, implicit rights lets the model evolve without breaking
userspace.  So if LPM maps eventually become bulletproof and a right
is no longer needed, it still works.  Or if some feature in the
verifier that is currently unrestricted were subsequently deemed to
need restrictions, they could be added without retrofitting all the
users.

There are cases where implicit rights would be totally inappropriate.
For example, a CAP_DAC_READ_SEARCH right could not be safely made
implicit.  In general, I think the implicit model works for system
calls where it's unambiguous what the caller wants to have happen and
there, depending on privilege level, it either works or it doesn't.
So, for accessing a filesystem, it's not at all obvious whether a
program is accessing it on its own behalf or on a client's behalf, and
privilege usage should be explicit.  For something like "don't
Spectre-mitigate this eBPF program", the semantics change and the
request should IMO be explicit.  For for "create an LPM map", I don't
see how a confused deputy is likely, and an implicit right seems
reasonable.  Similarly, for creating a namespace or binding a network
port, confused deputies seem unlikely.  (For connecting to a network
address, if such a thing were ever restricted, confused deputies are
definitely possible and happen all the time, e.g. under a DNS
rebinding attack.)
