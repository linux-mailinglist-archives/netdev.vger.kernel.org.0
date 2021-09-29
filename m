Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C1841CB42
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345516AbhI2Rul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345449AbhI2Ruj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 13:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAD7061440;
        Wed, 29 Sep 2021 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632937738;
        bh=QWgsOLwpXxz3fNUhaZNND/TYsYAt0u8ThxKlLeyN1v8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OSCs05IzSK/ZklX6KN0g9t8jB3E/r9vNllbV3OUdOfySyfAHyOMZ1EOEGWqjbgyku
         IpSDUb68j3mP6Qp/5TjBc0wx210HD+cGiZmVZmSSb4fnFWKEPo5M0PuxkYyHLgZ9X5
         jJfIrP3jZ6qfT5TL6foJL3WfYo1THzBa5QA1askUaov4KWhj7Ji7dx+JlW4J3X2Sz2
         DHzSPgYMg0CV9DWcv7FVHFas8NPIkBfrl3wa3fU/dtg7EXec0Uf5tILxD7dgTYns9n
         IzUUOjo4ixDNBc79lEtglQO4s1AmeBchrls9Os8NRclVfN2wz2oM++fv3YFh8hoMSQ
         SgimH4A3AkzbA==
Date:   Wed, 29 Sep 2021 10:48:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
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
Message-ID: <20210929104856.2d3f15e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87sfxnin6i.fsf@toke.dk>
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
        <87sfxnin6i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 14:25:09 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> I guess we could play some trickery with stuffing offset/len/flags into
> >> one or two u64s to save an argument or two? =20
> >
> > Adding another pointer arg seems really hard to explain as an API.
> > What happens if I pass the "wrong" ptr? What happens if I pass NULL?
> >
> > How about this: instead of taking stack_ptr, take the return value
> > from header_pointer as an argument. =20
>=20
> Hmm, that's a good point; I do think that passing the return value from
> header pointer is more natural as well (you're flushing pointer you just
> wrote to, after all).

It is more natural but doesn't allow for the same level of optimization.
Wouldn't consistent naming obviate the semantics?
