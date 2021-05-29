Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CD8394C56
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 15:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhE2NjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 09:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhE2NjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 09:39:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5544261205;
        Sat, 29 May 2021 13:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622295453;
        bh=OGCLamFQwUKrua5lO2n1AwkC03xHV4Wn4zKoYU3nWic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RPXERx5SoivDOxC2KGYgdmL3M1mNgHUxBnCQAxesZggzKF7yDrkx28MjZj0+xWlYt
         fGVBepFx8c47/0eBf5MxIrT1EX+513kkPqhxuHbZKZLeCrGoxfXavqo4RnNGFyaSDu
         bv5+go1vdhZ0LJfan8V2DZhbI1Ppr8RLBrQqR2rIgmDYp1fmnryS/zgqAdu8aaqld8
         LRDazMPub4OGz6QFWW7rMxPk50eKVbe1RW1C0FR7A1nFh2Uf7+ipzp1ZezEOT0DJhf
         o1hjaYzl+t6Z67O1+XCzEnjC6H04B1JsnJyWBoIuE3yAjqWxbUKB52Wk7Xs8Ce6KUN
         b5yG5GXLaFj+w==
Date:   Sat, 29 May 2021 15:37:28 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tom Herbert <tom@herbertland.com>, bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        David Ahern <dsahern@gmail.com>, magnus.karlsson@intel.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, bjorn@kernel.org,
        Maciej =?utf-8?Q?Fija=C5=82kowski_=28Intel=29?= 
        <maciej.fijalkowski@intel.com>,
        john fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 1/4] net: xdp: introduce flags field in xdp_buff
 and xdp_frame
Message-ID: <YLJDmP0Z5Fa8OVlJ@lore-desk>
References: <cover.1622222367.git.lorenzo@kernel.org>
 <b5b2f560006cf5f56d67d61d5837569a0949d0aa.1622222367.git.lorenzo@kernel.org>
 <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
 <20210528215654.31619c97@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tpZcavsnymHtin+e"
Content-Disposition: inline
In-Reply-To: <20210528215654.31619c97@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tpZcavsnymHtin+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 28 May 2021 14:18:33 -0700 Tom Herbert wrote:
> > On Fri, May 28, 2021 at 10:44 AM Lorenzo Bianconi <lorenzo@kernel.org> =
wrote:
> > > Introduce flag field in xdp_buff and xdp_frame data structure in order
> > > to report xdp_buffer metadata. For the moment just hw checksum hints
> > > are defined but flags field will be reused for xdp multi-buffer
> > > For the moment just CHECKSUM_UNNECESSARY is supported.
> > > CHECKSUM_COMPLETE will need to set csum value in metada space.
> > > =20
> > Lorenzo,
> >=20
> > This isn't sufficient for the checksum-unnecessary interface, we'd
> > also need ability to set csum_level for cases the device validated
> > more than one checksum.
> >=20
> > IMO, we shouldn't support CHECKSUM_UNNECESSARY for new uses like this.
> > For years now, the Linux community has been pleading with vendors to
> > provide CHECKSUM_COMPLETE which is far more useful and robust than
> > CHECSUM_UNNECESSARY, and yet some still haven't got with the program
> > even though we see more and more instances where CHECKSUM_UNNECESSARY
> > doesn't even work at all (e.g. cases with SRv6, new encaps device
> > doesn't understand). I believe it's time to take a stand! :-)
>=20
> I must agree. Not supporting CHECKSUM_COMPLETE seems like a step back.

I completely agree on it and I want add support for CHECKSUM_COMPLETE as so=
on
as we decide what is the best way to store csum value (xdp_metadata?). At t=
he
same time this preliminary series wants to add support just for
CHECSUM_UNNECESSARY. Moreover the flags field in xdp_buff/xdp_frame will be
reused for xdp multi-buff work.

Regards,
Lorenzo

--tpZcavsnymHtin+e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYLJDlAAKCRA6cBh0uS2t
rAHXAP9xAi/Afp79ZGNtVfDfdaj3qvLWl5yKp0aUxrHmLAeLTwD/RTrcqF/Aksat
XGYa6WytemnCTM60o6EBEkYig//7qgM=
=6bqi
-----END PGP SIGNATURE-----

--tpZcavsnymHtin+e--
