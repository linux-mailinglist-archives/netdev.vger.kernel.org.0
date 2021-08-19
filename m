Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3513F238E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 01:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhHSXRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 19:17:09 -0400
Received: from ozlabs.org ([203.11.71.1]:58237 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhHSXRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 19:17:08 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GrLHc6mcyz9sWw;
        Fri, 20 Aug 2021 09:16:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629414990;
        bh=JRuRcxrgsvz+ySmMZ1ebZzgnlNqFw91zL6kHFmjeQ2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qm+z3PRuiPy1D0ZECxC3CRYRNmRvguarIIozjD3pI1kdoEJYevy2V3u3LIH3Il3Z5
         fOqQQ6oLjSiS+UJxtX/0cM00OG9IoqYzqHbUJpinZD6/Y2QIvHbB4nWlHFyyohwDOe
         C+3tRvUDR3gr74+OJoWVFSOd7T1y3AAhGrqHOhfGjLDTT+oZrYZ0eKNc1vZyNiLSdf
         I3iiIcMmApluKuJmZT2Va59XBuUXXvUV7abwDGw3LsdOKufG5q/HSWH0T+a2jDRtOv
         g4bJC0lfRsgBgy8jL44W0qu7NLnx+Cmzi/787EOF7AqbyRiYQVAnojoAT8y0R2nIyh
         v1m1pZevUZjUw==
Date:   Fri, 20 Aug 2021 09:16:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210820091627.2d071982@canb.auug.org.au>
In-Reply-To: <20210815220432.7eea02e9@canb.auug.org.au>
References: <20210809202046.596dad87@canb.auug.org.au>
        <CAK8P3a103SSaMmFEKehPQO0p9idVwhfck-OX5t1_3-gW4ox2tw@mail.gmail.com>
        <20210815220432.7eea02e9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zEEIMRfpESnzCINoDH766AH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zEEIMRfpESnzCINoDH766AH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 15 Aug 2021 22:04:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 9 Aug 2021 15:21:41 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Mon, Aug 9, 2021 at 12:20 PM Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote: =20
> > >
> > > After merging the net-next tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > >
> > > drivers/net/ethernet/cirrus/cs89x0.c: In function 'net_open':
> > > drivers/net/ethernet/cirrus/cs89x0.c:897:20: error: implicit declarat=
ion of function 'isa_virt_to_bus' [-Werror=3Dimplicit-function-declaration]
> > >   897 |     (unsigned long)isa_virt_to_bus(lp->dma_buff));
> > >       |                    ^~~~~~~~~~~~~~~   =20
> >=20
> > Thank you for the report! I already sent a patch for m68knommu running =
into
> > this issue, but it seems there are other architectures that still have =
it.
> >=20
> > The driver checks CONFIG_ISA_DMA_API at compile time to determine
> > whether isa_virt_to_bus(), set_dma_mode(), set_dma_addr(), ... are all
> > defined.
> >=20
> > It seems that isa_virt_to_bus() is only implemented on most of the
> > architectures that set ISA_DMA_API: alpha, arm, mips, parisc and x86,
> > but not on m68k/coldfire and powerpc.
> >=20
> > Before my patch, the platform driver could only be built on ARM,
> > so maybe we should just go back to that dependency or something
> > like
> >=20
> >          depends on ARM || ((X86 || !ISA_DMA_API) && COMPILE_TEST)
> >=20
> > for extra build coverage. Then again, it's hard to find any machine
> > actually using these: we have a couple of s3c24xx machines that
> > use the wrong device name, so the device never gets probed, the imx
> > machines that used to work are gone, and the ep7211-edb7211.dts
> > is missing a device node for it. Most likely, neither the platform nor
> > the ISA driver are actually used by anyone. =20
>=20
> I am still applying my patch removing COMPILE_TEST from this driver ..

Ping?  Did I miss a fix being merged?

--=20
Cheers,
Stephen Rothwell

--Sig_/zEEIMRfpESnzCINoDH766AH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEe5ksACgkQAVBC80lX
0GyLdgf9F0ROREULuv+N+e4tU/inn1SdqxjYfMR5qTwn0znCi7UBjiscos1bzkcI
KxlEHAWHbZsBxm2ABFy/PXdE0vPrrGHsh56jeHKScQpiskJ1pI/J+WSG580J3COc
wGBPN7uIztt8JppZkLLKhwl/Zsd00voLnEYxcEojlB1doy2yzMj4i0Cc1EjOMOaT
Dm6yVhMGZ4okX3gkxnNrtFh2SNs6a9E4ITgk9SbJbjs5GCm3ufssYTjRaq3lmdOv
H1/WyHEYAfj1z19JKyjJ6v1KSxLKB23D67zKxGQQTGrW3CkRZS0MPv8nBacp+y/Z
tKQ2IJRwhXTKTA4JmEe1E7sZCzcJ2Q==
=gEBF
-----END PGP SIGNATURE-----

--Sig_/zEEIMRfpESnzCINoDH766AH--
