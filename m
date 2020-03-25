Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F74A191E91
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 02:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgCYBZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 21:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727196AbgCYBZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 21:25:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CE1620719;
        Wed, 25 Mar 2020 01:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585099542;
        bh=6TzA+BtOtrGQQQwsWQV9wKptD9SCYw1ump4lGExrYdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UgWLmPLeuJBHyyf0UoCEFgztX+jkuspr5GcR3YPnHtGdvogl2At/23EpoXCtN57Yo
         02YbqfZHO7ivkpxAlMdvugewxMP1eQRmy8d4xzuZ4LovFFV8hGHC8bZgSO7pA3SCfO
         gh7xY3iiXgVFwpyfoqbmSTfPjnEHANcWezPpDr7Y=
Date:   Tue, 24 Mar 2020 18:25:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200324182540.5b3c7307@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEf4Bzb=FuVVw1wwLbGW1LU05heAFoUiJjm71=Qqxr+dS78qyQ@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
        <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
        <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
        <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
        <87tv2f48lp.fsf@toke.dk>
        <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
        <87h7ye3mf3.fsf@toke.dk>
        <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
        <87tv2e10ly.fsf@toke.dk>
        <20200324115349.6447f99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEf4Bzb=FuVVw1wwLbGW1LU05heAFoUiJjm71=Qqxr+dS78qyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 15:30:58 -0700 Andrii Nakryiko wrote:
> On Tue, Mar 24, 2020 at 11:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 24 Mar 2020 11:57:45 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te: =20
> > > > If everyone is using libbpf, does kernel system (bpf syscall vs
> > > > netlink) matter all that much? =20
> > >
> > > This argument works the other way as well, though: If libbpf can
> > > abstract the subsystem differences and provide a consistent interface=
 to
> > > "the BPF world", why does BPF need to impose its own syscall API on t=
he
> > > networking subsystem? =20
> >
> > Hitting the nail on the head there, again :)
> >
> > Once upon a time when we were pushing for libbpf focus & unification,
> > one of my main motivations was that a solid library that most people
> > use give us the ability to provide user space abstractions. =20
>=20
> Yes, but bpf_link is not a user-space abstraction only anymore. It
> started that way and we quickly realized that we still will need
> kernel support. Not everything can be abstracted in user-space only.
> So I don't see any contradiction here, that's still libbpf focus.
>
> > As much as adding new kernel interfaces "to rule them all" is fun, it
> > has a real cost. =20
>=20
> We are adding kernel interface regardless of XDP (for cgroups and
> tracing, then perf_events, etc). The real point and real cost here is
> to not have another duplication of same functionality just for XDP use
> case. That's the real cost, not the other way around. Don't know how
> to emphasize this further.

Toke's change is net 30 lines of kernel code while retaining full netlink
compliance and abilities. The integration with libbpf is pretty trivial
as well. He has an actual project which needs this functionality, and
for which his change is sufficient.

Neither LoC/maintenance burden nor use cases are in favor of bpf_link
to put it mildly.

> And there is very little fun involved from my side, believe it or not...

