Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E773FD3F0
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 08:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242343AbhIAGps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 02:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242074AbhIAGpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 02:45:47 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F06DC061575;
        Tue, 31 Aug 2021 23:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1630478686;
        bh=WVLWadZL6lDdLLOQSpArpAbR/yZfLdFO9nlownYWBEI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CQfYRaP1lutB94VrlRsZhE931hbVvv2WomOj/3YOIxLI2YnafJ+ROCsqvLI37udcC
         StMpGPYB10mqL8iOgXNsvZhJ4lBrx/4yg8K03oRko9O+k9HpU+SnmWXosl6vJb0Bv1
         OG6RlZ1jb6pGhfJtnDoqp1Idtb5iZ3mLVWcfosNDh1Z9TmWP2En2wMPKLoG15AxNz7
         VUM3uOKFxVAhJF/eyBH5ljTo8ruGMXJP6IcMwRtZV+dTI9fvqnVDpxx79tYkryfZk5
         PWRFGdzRsncSNqBp6b92CMmM82WWpWHSuMqxwaKfWCUdmWJlzI7XV27DJmYhLV/N3W
         YbXWyn1u9K7Xg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GzvgL4GZ3z9ssD;
        Wed,  1 Sep 2021 16:44:45 +1000 (AEST)
Date:   Wed, 1 Sep 2021 16:44:45 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210901164445.4ff9d8ce@canb.auug.org.au>
In-Reply-To: <20210820091627.2d071982@canb.auug.org.au>
References: <20210809202046.596dad87@canb.auug.org.au>
        <CAK8P3a103SSaMmFEKehPQO0p9idVwhfck-OX5t1_3-gW4ox2tw@mail.gmail.com>
        <20210815220432.7eea02e9@canb.auug.org.au>
        <20210820091627.2d071982@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/s6=qHMJch1q9dqq9U5oPO.k";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/s6=qHMJch1q9dqq9U5oPO.k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 20 Aug 2021 09:16:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Sun, 15 Aug 2021 22:04:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > On Mon, 9 Aug 2021 15:21:41 +0200 Arnd Bergmann <arnd@arndb.de> wrote: =
=20
> > >
> > > On Mon, Aug 9, 2021 at 12:20 PM Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:   =20
> > > >
> > > > After merging the net-next tree, today's linux-next build (powerpc
> > > > allyesconfig) failed like this:
> > > >
> > > > drivers/net/ethernet/cirrus/cs89x0.c: In function 'net_open':
> > > > drivers/net/ethernet/cirrus/cs89x0.c:897:20: error: implicit declar=
ation of function 'isa_virt_to_bus' [-Werror=3Dimplicit-function-declaratio=
n]
> > > >   897 |     (unsigned long)isa_virt_to_bus(lp->dma_buff));
> > > >       |                    ^~~~~~~~~~~~~~~     =20
> > >=20
> > > Thank you for the report! I already sent a patch for m68knommu runnin=
g into
> > > this issue, but it seems there are other architectures that still hav=
e it.
> > >=20
> > > The driver checks CONFIG_ISA_DMA_API at compile time to determine
> > > whether isa_virt_to_bus(), set_dma_mode(), set_dma_addr(), ... are all
> > > defined.
> > >=20
> > > It seems that isa_virt_to_bus() is only implemented on most of the
> > > architectures that set ISA_DMA_API: alpha, arm, mips, parisc and x86,
> > > but not on m68k/coldfire and powerpc.
> > >=20
> > > Before my patch, the platform driver could only be built on ARM,
> > > so maybe we should just go back to that dependency or something
> > > like
> > >=20
> > >          depends on ARM || ((X86 || !ISA_DMA_API) && COMPILE_TEST)
> > >=20
> > > for extra build coverage. Then again, it's hard to find any machine
> > > actually using these: we have a couple of s3c24xx machines that
> > > use the wrong device name, so the device never gets probed, the imx
> > > machines that used to work are gone, and the ep7211-edb7211.dts
> > > is missing a device node for it. Most likely, neither the platform nor
> > > the ISA driver are actually used by anyone.   =20
> >=20
> > I am still applying my patch removing COMPILE_TEST from this driver .. =
=20
>=20
> Ping?  Did I miss a fix being merged?

Ping, again.  The net=3Dnext tree has now been merged by Linus, so has
this been fixed?  Or is Linus' tree now broken for this build?

--=20
Cheers,
Stephen Rothwell

--Sig_/s6=qHMJch1q9dqq9U5oPO.k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEvIV0ACgkQAVBC80lX
0Gz3fQf+Nwk6edQzEj9I2xNWStxk0I1+DALKDAFcqPhx9o8Xb6Ty+HeJGUllmHxc
mA11SubeyXlFR06HcusTtNcw8w3qUxG69SEKm5OCBwl4HuXtonzoc+neb1rfdeLP
jMxIdGF671fqbNTXQfVw4sJJhJlk6QG4xtcH7w62qSyrbUHnABOhGIqXNzwJB6o2
zLVPhg61wblkr1dwDQ/3OVnPZUYlftfTmwOhXuKE1KdY0NtRx0ZJwWTHiOXyODKN
rFjYhsDd9NyK1r2kgzba5N+qdWi072pUxnEofWeMMKMveHcsC9ZB/Yu50WhmhQSo
Q80XzHAPzoBVDJRM6HHFNqL7sc2lww==
=fRNX
-----END PGP SIGNATURE-----

--Sig_/s6=qHMJch1q9dqq9U5oPO.k--
