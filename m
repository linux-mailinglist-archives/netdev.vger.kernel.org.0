Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A105E17ADE8
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 19:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgCESNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 13:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgCESNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 13:13:45 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72AD3208C3;
        Thu,  5 Mar 2020 18:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583432024;
        bh=MmGDQGgUx19Dykruo0Cq7gbv2FwEMbYDwZcR4vu6+Os=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vz1BUssI0NEhzosLWpEr+RiciXDS6RcTrXWqtOuq2RPYzTY5rymONNq9lI4RGNtQM
         qto0N2RD1cqfHfq11AylBRGbbdSC8LYtVCbmTlkuFXiujZ0jWnnYeyEM65z0ndIGxM
         DzNHwvojzKghXagVnyIxRSnc0IgUCPnxWI6rUcBA=
Date:   Thu, 5 Mar 2020 10:13:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200305101342.01427a2a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87tv332hak.fsf@toke.dk>
References: <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
        <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
        <87pndt4268.fsf@toke.dk>
        <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
        <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
        <87k1413whq.fsf@toke.dk>
        <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
        <20200304114000.56888dac@kicinski-fedora-PC1C0HJN>
        <20200304204506.wli3enu5w25b35h7@ast-mbp>
        <20200304132439.6abadbe3@kicinski-fedora-PC1C0HJN>
        <20200305010706.dk7zedpyj5pb5jcv@ast-mbp>
        <20200305001620.204c292e@cakuba.hsd1.ca.comcast.net>
        <87tv332hak.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Mar 2020 12:05:23 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Wed, 4 Mar 2020 17:07:08 -0800, Alexei Starovoitov wrote: =20
> >> > Maybe also the thief should not have CAP_ADMIN in the first place?
> >> > And ask a daemon to perform its actions..   =20
> >>=20
> >> a daemon idea keeps coming back in circles.
> >> With FD-based kprobe/uprobe/tracepoint/fexit/fentry that problem is go=
ne,
> >> but xdp, tc, cgroup still don't have the owner concept.
> >> Some people argued that these three need three separate daemons.
> >> Especially since cgroups are mainly managed by systemd plus container
> >> manager it's quite different from networking (xdp, tc) where something
> >> like 'networkd' might makes sense.
> >> But if you take this line of thought all the ways systemd should be th=
at
> >> single daemon to coordinate attaching to xdp, tc, cgroup because
> >> in many cases cgroup and tc progs have to coordinate the work. =20
> >
> > The feature creep could happen, but Toke's proposal has a fairly simple
> > feature set, which should be easy to cover by a stand alone daemon.
> >
> > Toke, I saw that in the library discussion there was no mention of=20
> > a daemon, what makes a daemon solution unsuitable? =20
>=20
> Quoting from the last discussion[0]:
>=20
> > - Introducing a new, separate code base that we'll have to write, suppo=
rt
> >   and manage updates to.
> >
> > - Add a new dependency to using XDP (now you not only need the kernel
> >   and libraries, you'll also need the daemon).
> >
> > - Have to duplicate or wrap functionality currently found in the kernel;
> >   at least:
> >  =20
> >     - Keeping track of which XDP programs are loaded and attached to
> >       each interface (as well as the "new state" of their attachment
> >       order).
> >
> >     - Some kind of interface with the verifier; if an app does
> >       xdpd_rpc_load(prog), how is the verifier result going to get back
> >       to the caller?
> >
> > - Have to deal with state synchronisation issues (how does xdpd handle
> >   kernel state changing from underneath it?).
> >=20
> > While these are issues that are (probably) all solvable, I think the
> > cost of solving them is far higher than putting the support into the
> > kernel. Which is why I think kernel support is the best solution :) =20
>=20
> The context was slightly different, since this was before we had
> freplace support in the kernel. But apart from the point about the
> verifier, I think the arguments still stand. In fact, now that we have
> that, we don't even need userspace linking, so basically a daemon's only
> task would be to arbitrate access to the XDP hook? In my book,
> arbitrating access to resources is what the kernel is all about...

You said that like the library doesn't arbitrate access and manage
resources.. It does exactly the same work the daemon would do.

Your prog chaining in the kernel proposal, now that would be a kernel
mechanism, but that's not what we're discussing here.

Daemon just trades off the complexity of making calls for the complexity
of the system and serializing/de-serializing the state.
