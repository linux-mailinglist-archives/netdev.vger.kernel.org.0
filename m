Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D98412803
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhITV3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233436AbhITV1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:27:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFDD2611ED;
        Mon, 20 Sep 2021 21:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632173143;
        bh=dw+A7Y3e0WSWT0+/KIUnJQ2tK7/MI3rN2fIRg79FIGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QtEu9g4/WCo53oAPlEMS3aCxydot0jtyqCX0QfK7JRGi1Lr6fLWi4AO4TyqgLpHmG
         HjAxgCF9HcAojetVdnyTpzPEVyFhuvL9pJBRc1FjA5XnEJLNHIH4ufjT9wKKhIpGTI
         oVBL/6UCzIF4NbDSPZwAOTmjCvxu++b1G6nsqVoxSqxedsc9a/M78ErYqeevvLX3Xf
         gsZJpqfhhczzwfRxnd9f1vUX3PwnLafxAIDzznUcbEsTZWlKxA4ajYqZK52KB71x0Q
         P85lw7FpqmZwBGbgXOIrmlBXrCXycyomcIXL3B5HQsR0YJM7EuvkL8yh/KTM43MC5P
         ZWTB3Qkyb1swg==
Date:   Mon, 20 Sep 2021 14:25:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
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
Message-ID: <20210920142542.7b451b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87lf3r3qrn.fsf@toke.dk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 23:01:48 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > In fact I don't think there is anything infra can do better for
> > flushing than the prog itself:
> >
> > 	bool mod =3D false;
> >
> > 	ptr =3D bpf_header_pointer(...);
> > 	...
> > 	if (some_cond(...)) {
> > 		change_packet(...);
> > 		mod =3D true;
> > 	}
> > 	...
> > 	if (mod) =20
>=20
> to have an additional check like:
>=20
> if (mod && ptr =3D=3D stack)
>=20
> (or something to that effect). No?

Good point. Do you think we should have the kernel add/inline this
optimization or have the user do it explicitly.

The draft API was:

void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,=20
                           u32 offset, u32 len, void *stack_buf)

Which does not take the ptr returned by header_pointer(), but that's
easy to add (well, easy other than the fact it'd be the 6th arg).

BTW I drafted the API this way to cater to the case where flush()
is called without a prior call to header_pointer(). For when packet
trailer or header is populated directly from a map value. Dunno if
that's actually useful, either.
