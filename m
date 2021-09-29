Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB1D41CB31
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbhI2RsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244776AbhI2Rr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 13:47:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3161361465;
        Wed, 29 Sep 2021 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632937576;
        bh=eTdjvQH/CdfOQ7X4ByS3Qx9OO5zspwx3avBYC1T9Gxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aC61OETwUJOuqBc5LQRP+kC2sdJ+KJbEVU7spHjTMFUSTRwiSYbVi5Z1JkuaGY3vM
         pLiisyxUZsCzutFzrtzkKCWI4IaaixWlV9VNXhIaDNFhR1oKMxT1nshoY8rLI7+jvn
         pnLZ3g00AP4cYDTduxuzIGgCQY7WVyOaFQpIqC2lTXILwPdCDt2MlEK/s5SFUgf7wn
         s2D55xrS8nf7N1n5abbqqlC21bs+EmWBesvxrxf9guwkRxXGBxoerSCcoaMaijUYS/
         ITvQ55ZOqKqPiF5rW7ldDEl8bWoOMXk4UP5tEmKZFHnUUaEdXbScyY3v99NSVYAXmU
         kDMdTTkPln5Iw==
Date:   Wed, 29 Sep 2021 10:46:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210929104615.6179efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACAyw98tVmuRbMr5RpPY_0GmU_bQAH+d9=UoEx3u5g+nGSwfYQ@mail.gmail.com>
References: <cover.1631289870.git.lorenzo@kernel.org>
        <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YUSrWiWh57Ys7UdB@lore-desk>
        <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
        <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
        <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch>
        <8735q25ccg.fsf@toke.dk>
        <20210920110216.4c54c9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87lf3r3qrn.fsf@toke.dk>
        <20210920142542.7b451b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87ilyu50kl.fsf@toke.dk>
        <CACAyw98tVmuRbMr5RpPY_0GmU_bQAH+d9=UoEx3u5g+nGSwfYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 11:36:33 +0100 Lorenz Bauer wrote:
> On Mon, 20 Sept 2021 at 23:46, Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> > > The draft API was:
> > >
> > > void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,
> > >                            u32 offset, u32 len, void *stack_buf)
> > >
> > > Which does not take the ptr returned by header_pointer(), but that's
> > > easy to add (well, easy other than the fact it'd be the 6th arg). =20
> >
> > I guess we could play some trickery with stuffing offset/len/flags into
> > one or two u64s to save an argument or two? =20
>=20
> Adding another pointer arg seems really hard to explain as an API.
> What happens if I pass the "wrong" ptr? What happens if I pass NULL?

Sure. We can leave the checking to the program then, but that ties
our hands for the implementation changes later on.

Not sure which pointer type will be chosen for the ret value but it=20
may allow error checking at verification.

> How about this: instead of taking stack_ptr, take the return value
> from header_pointer as an argument. Then use the already existing
> (right ;P) inlining to do the following:
>=20
>    if (md->ptr + args->off !=3D ret_ptr)
>      __pointer_flush(...)

That only checks for the case where pointer is in the "head" frag,
and is not generally correct. You need to check the length of the=20
first frag is smaller than off. Otherwise BPF stack may "happen"
to follow the head page and math will work out.

It would also be slower than Lorenzo's current code, which allows
access to tail pages without copying.
