Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E9918DA4B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 22:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCTVaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 17:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgCTVaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 17:30:18 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364FD20658;
        Fri, 20 Mar 2020 21:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584739817;
        bh=7Ukg78wRWCXbWT/phN5Xv+MSrh6B3aF5e5xhwq7RdJk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jxza0nLPmuNjKqAIWsEOxjOxHQfvXXGqkLlAbZoelUNEedokAzPTWWCH31wf6urXT
         sNJeNWwvtHo5QPqs9nLwCRnuUwYunx2WT4RUZpf+i/wMwI/k6Txqkp0An87E44Crs0
         Fqa3tu1e9oQie2tEg45m+t2mxOg/Br6fHphf/TlY=
Date:   Fri, 20 Mar 2020 14:30:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200320143014.4dde2868@kicinski-fedora-PC1C0HJN>
In-Reply-To: <80235a44-8f01-6733-0638-c70c51cd1b90@iogearbox.net>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
        <ad09e018-377f-9864-60eb-cf4291f49d41@iogearbox.net>
        <80235a44-8f01-6733-0638-c70c51cd1b90@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 21:40:46 +0100 Daniel Borkmann wrote:
> On 3/20/20 9:30 PM, Daniel Borkmann wrote:
> > On 3/20/20 9:48 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote: =20
> >> Jakub Kicinski <kuba@kernel.org> writes: =20
> >>> On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen w=
rote: =20
> >>>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>>>
> >>>> While it is currently possible for userspace to specify that an exis=
ting
> >>>> XDP program should not be replaced when attaching to an interface, t=
here is
> >>>> no mechanism to safely replace a specific XDP program with another.
> >>>>
> >>>> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, which=
 can be
> >>>> set along with IFLA_XDP_FD. If set, the kernel will check that the p=
rogram
> >>>> currently loaded on the interface matches the expected one, and fail=
 the
> >>>> operation if it does not. This corresponds to a 'cmpxchg' memory ope=
ration.
> >>>>
> >>>> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explicit=
ly
> >>>> request checking of the EXPECTED_FD attribute. This is needed for us=
erspace
> >>>> to discover whether the kernel supports the new attribute.
> >>>>
> >>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> =20
> >>>
> >>> I didn't know we wanted to go ahead with this... =20
> >>
> >> Well, I'm aware of the bpf_link discussion, obviously. Not sure what's
> >> happening with that, though. So since this is a straight-forward
> >> extension of the existing API, that doesn't carry a high implementation
> >> cost, I figured I'd just go ahead with this. Doesn't mean we can't have
> >> something similar in bpf_link as well, of course. =20
> >=20
> > Overall series looks okay, but before we go down that road, especially =
given there is
> > the new bpf_link object now, I would like us to first elaborate and fig=
ure out how XDP
> > fits into the bpf_link concept, where its limitations are, whether it e=
ven fits at all,
> > and how its semantics should look like realistically given bpf_link is =
to be generic to
> > all program types. Then we could extend the atomic replace there generi=
cally as well. I
> > think at the very minimum it might have similarities with what is propo=
sed here, but
> > from a user experience I would like to avoid having something similar i=
n XDP API and
> > then again in bpf_link which would just be confusing.. =20
>=20
> Another aspect that falls into this atomic replacement is also that the p=
rograms can
> actually be atomically replaced at runtime. Last time I looked, some driv=
ers still do
> a down/up cycle on replacement and hence traffic would be interrupted. I =
would argue
> that such /atomic/ swap operation on bpf_link would cover a guarantee of =
not having to
> perform this as well (workaround today would be a simple tail call map as=
 entry point).

I don't think that's the case. Drivers generally have a fast path=20
for the active-active replace.

Up/Down is only done to remap DMA buffers and change RX buffer
allocation scheme. That's when program is installed or removed,
not replaced.

I'm sure bpf_link would have solved this problem, though, and all=20
the other problems we don't actually have :-P
