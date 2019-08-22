Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2659997DB
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388320AbfHVPQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 11:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbfHVPQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 11:16:25 -0400
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A7AD233FE
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566486984;
        bh=Tf1+MDA69J0XTZzWamIuhdxeoHFNTy9Fyfn4iYGAZGs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bkO7C8v9wAeZYGXw5f6Xr+szEfbrXDIUsIe0VZ1gaVQyROD43Z5Z8hxDR5zMMm3A+
         1Ap4Ud+7d1Znd870XYABj8pk9PoNgfILdTaONAY1sXSeeIRcIv8+V0CxeY2SudeJuE
         xCmbz6TPthx+YmkHswYEo6lWE1Fz5o8ONhD1mzfE=
Received: by mail-wm1-f50.google.com with SMTP id o4so6035148wmh.2
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 08:16:24 -0700 (PDT)
X-Gm-Message-State: APjAAAXaHubp/0Om7CQXBtuYCobZ6vj00P+auK4t918XBL52HYlB7CVV
        kHWr+sJuQiXFxYlZ2/49QCRyPa0ZYxvC6/ZVoos4Wg==
X-Google-Smtp-Source: APXvYqxQ1AVQ1mEvC+8xddKYiWzcyAfBMfPjZtgkp09pgDXfScoAGkzKjCOB0yc36Gc4bXCeASZ6p9c2UV4us/F0dkE=
X-Received: by 2002:a05:600c:22d7:: with SMTP id 23mr7421334wmg.0.1566486982786;
 Thu, 22 Aug 2019 08:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com> <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com> <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
In-Reply-To: <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 22 Aug 2019 08:16:11 -0700
X-Gmail-Original-Message-ID: <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
Message-ID: <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Chenbo Feng <chenbofeng.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 7:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/7/19 7:24 AM, Andy Lutomirski wrote:
> > On Mon, Aug 5, 2019 at 6:11 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >> On Mon, Aug 05, 2019 at 02:25:35PM -0700, Andy Lutomirski wrote:
> >>> It tries to make the kernel respect the access modes for fds.  Without
> >>> this patch, there seem to be some holes: nothing looked at program fds
> >>> and, unless I missed something, you could take a readonly fd for a
> >>> program, pin the program, and reopen it RW.
> >>
> >> I think it's by design. iirc Daniel had a use case for something like this.
> >
> > That seems odd.  Daniel, can you elaborate?
>
> [ ... catching up late. ]
>
> Not from my side, the change was added by Chenbo back then for Android
> use-case to replace xt_qtaguid and xt_owner with BPF programs and to
> allow unprivileged applications to read maps. More on their architecture:
>
>    https://source.android.com/devices/tech/datausage/ebpf-traffic-monitor
>
>  From the cover-letter:
>
>    [...]
>    The network-control daemon (netd) creates and loads an eBPF object for
>    network packet filtering and analysis. It passes the object FD to an
>    unprivileged network monitor app (netmonitor), which is not allowed to
>    create, modify or load eBPF objects, but is allowed to read the traffic
>    stats from the map.
>    [...]

I suspect that this use case is, in fact, mostly broken in current
kernels.  An unprivileged process with a read-only fd to a bpf map can
BPF_OBJ_PIN the map and then re-open it read-write.  As far as I can
tell, the only thing mitigating this is that it won't work unless the
attacker has write access to some directory in bpffs.

> > Trusted by whom?  In a non-nested container, the container manager
> > *might* be trusted by the outside world.  In a *nested* container,
> > unless the inner container management is controlled from outside the
> > outer container, it's not trusted.  I don't know much about how
> > Facebook's containers work, but the LXC/LXD/Podman world is moving
> > very strongly toward user namespaces and maximally-untrusted
> > containers, and I think bpf() should work in that context.
>
> [...] and if we opt-in with CAP_NET_ADMIN, for example, then it should
> ideally be possible for that container to install BPF programs for
> mangling, dropping, forwarding etc as long as it's only affecting it's
> /own/ netns like the rest of networking subsystem controls that work
> in that case. I would actually like to get to this at some point and
> make it more approachable as long as there is a way for an admin to
> /opt into it/ via policy (aka not by default).

For better or for worse, I think this would need a massive
re-architecting of the way bpf filtering works.  bpf filters attach to
cgroups, which aren't scoped to network namespaces at all.  So we need
a different permission model.

> Thinking out loud, I'd
> love some sort of a hybrid, that is, a mixture of CAP_BPF_ADMIN and
> customizable seccomp policy. Meaning, there could be several CAP_BPF
> type sub-policies e.g. from allowing everything (equivalent to the
> /dev/bpf on/off handle or CAP_SYS_ADMIN we have today) down to
> programmable user defined policy that can be tailored to specific
> needs like granting apps to BPF_OBJ_GET and BPF_MAP_LOOKUP elements
> or granting to load+mangle a specific subset of maps (e.g. BPF_MAP_TYPE_{ARRAY,
> HASH,LRU_HASH,LPM_TRIE}) and prog types (...) plus attaching them to
> their own netns, and if that is untrusted, then same restrictions/
> mitigations could be done by the verifier as with (current) unprivileged
> BPF, enabled via programmable policy as well. We wouldn't make any
> static/fixed assumptions, but allow users to define them based on their
> own use-cases. Haven't looked how feasible this would be, but something
> to take into consideration when we rework the current [admittedly
> suboptimal all-or-nothing] model we have. Is this something you had in
> mind as well for your wip proposal, Andy?
>

Hmm.  Fine-grained seccomp stuff like this is very much in scope for
the seccomp discussion that's happening at LPC this year.
Unfortunately, I'm not there, but I'm participating via the mailing
list.

I also finally finished typing a very rough draft of my bpf ideas.
I'll email them out momentarily in a separate email.  I think it
should come fairly close to doing what you want.
