Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865243EC8E0
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 14:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbhHOMFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 08:05:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34031 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhHOMFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 08:05:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GnbZ95Vfnz9sRf;
        Sun, 15 Aug 2021 22:04:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629029074;
        bh=/e/u+HakknBf/YXsodXMs+jehw2MCLDx0/6uHG/P/rA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fyqehoEkAKz8ilSostopIrbQl8eaTlv26kX4XLy0l8qRsnRhFfn7qGkihXcTJxKlB
         xMsSIdzmDDLaXd0EJGdWa8bm4xE5c2xjRQsaqD7HD7ijG+tCiZMiybKoPgH8rawiGf
         pt/ZmBbL+JdYfD6XUIzEzrrTOIG0R0qE+krVl79CT782UA9hg8QbztJZjiwFCO+WXL
         QNyFXnDaWz1h1c1X5Q6bU2iZw0kJvTROAR3prkCN1G8mEFJjdcEwCTAkRDgtUIClrX
         LyQ5V3n/34Gf7vC9lQGdvA/b7j6W3nQgZbulDPYFoDTzoFHYLEpanV4X89QoY4rU5L
         kYAEWT/MTCnVA==
Date:   Sun, 15 Aug 2021 22:04:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210815220432.7eea02e9@canb.auug.org.au>
In-Reply-To: <CAK8P3a103SSaMmFEKehPQO0p9idVwhfck-OX5t1_3-gW4ox2tw@mail.gmail.com>
References: <20210809202046.596dad87@canb.auug.org.au>
        <CAK8P3a103SSaMmFEKehPQO0p9idVwhfck-OX5t1_3-gW4ox2tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.Ve5Cx0xKbyyzuf6xk1M.eW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.Ve5Cx0xKbyyzuf6xk1M.eW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 9 Aug 2021 15:21:41 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Aug 9, 2021 at 12:20 PM Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > After merging the net-next tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > drivers/net/ethernet/cirrus/cs89x0.c: In function 'net_open':
> > drivers/net/ethernet/cirrus/cs89x0.c:897:20: error: implicit declaratio=
n of function 'isa_virt_to_bus' [-Werror=3Dimplicit-function-declaration]
> >   897 |     (unsigned long)isa_virt_to_bus(lp->dma_buff));
> >       |                    ^~~~~~~~~~~~~~~ =20
>=20
> Thank you for the report! I already sent a patch for m68knommu running in=
to
> this issue, but it seems there are other architectures that still have it.
>=20
> The driver checks CONFIG_ISA_DMA_API at compile time to determine
> whether isa_virt_to_bus(), set_dma_mode(), set_dma_addr(), ... are all
> defined.
>=20
> It seems that isa_virt_to_bus() is only implemented on most of the
> architectures that set ISA_DMA_API: alpha, arm, mips, parisc and x86,
> but not on m68k/coldfire and powerpc.
>=20
> Before my patch, the platform driver could only be built on ARM,
> so maybe we should just go back to that dependency or something
> like
>=20
>          depends on ARM || ((X86 || !ISA_DMA_API) && COMPILE_TEST)
>=20
> for extra build coverage. Then again, it's hard to find any machine
> actually using these: we have a couple of s3c24xx machines that
> use the wrong device name, so the device never gets probed, the imx
> machines that used to work are gone, and the ep7211-edb7211.dts
> is missing a device node for it. Most likely, neither the platform nor
> the ISA driver are actually used by anyone.

I am still applying my patch removing COMPILE_TEST from this driver ..
--=20
Cheers,
Stephen Rothwell

--Sig_/.Ve5Cx0xKbyyzuf6xk1M.eW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEZAtAACgkQAVBC80lX
0GxciAgAmfs1SjfSTyTMrGJPZig6bp/1ZlZkmTVl3zaYeZfx+MbzBZ+1iKm5Guge
IU2ptOXKBOAIq87QVzq6zDgGS1iS9pCqo7gbzxd7RFqjKR+mEjX/cgZamoPVOWIZ
jA2swigu6YnPa+IOsXgqum3dEfoPxACpnUVwHourZ2wqnoqWs7SmgncnPag6XW4j
5EssC/JKHNwoE1WohvSkg4yT4yl+MEBA4Ko8+QIRFZyFpP1gPumjDoR/b/P+slbB
HW6NoV/mtr+CXwGUuz4pzLXDWiT65i7Dr9U7/66FxdxdR+Gw2k9gEysqrbWK2xfv
180JBzN1QT27PHaFwWTE0bmooE0nLw==
=FN3c
-----END PGP SIGNATURE-----

--Sig_/.Ve5Cx0xKbyyzuf6xk1M.eW--
