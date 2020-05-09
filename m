Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5431CC5A0
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEIXyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:54:06 -0400
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:54128 "EHLO
        3.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgEIXyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 19:54:06 -0400
X-Greylist: delayed 15001 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 May 2020 19:54:04 EDT
Received: from player738.ha.ovh.net (unknown [10.108.35.13])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id A99EC1BE326
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 21:06:09 +0200 (CEST)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
        (Authenticated sender: steve@sk2.org)
        by player738.ha.ovh.net (Postfix) with ESMTPSA id 0A9B5124BEB04;
        Sat,  9 May 2020 19:06:01 +0000 (UTC)
Date:   Sat, 9 May 2020 21:05:48 +0200
From:   Stephen Kitt <steve@sk2.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Protect INET_ADDR_COOKIE on 32-bit
 architectures
Message-ID: <20200509210548.116c7385@heffalump.sk2.org>
In-Reply-To: <20200509105914.04fd19c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200508120457.29422-1-steve@sk2.org>
        <20200508205025.3207a54e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200509101322.12651ba0@heffalump.sk2.org>
        <20200509105914.04fd19c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/s1s_w35=OAg5_w9IeCHOaaW"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 18383975156205243802
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddufeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtsehgtderreertdejnecuhfhrohhmpefuthgvphhhvghnucfmihhtthcuoehsthgvvhgvsehskhdvrdhorhhgqeenucggtffrrghtthgvrhhnpeevledvueefvdeivefftdeugeekveethefftdffteelheejkeejjeduffeiudetkeenucfkpheptddrtddrtddrtddpkedvrdeihedrvdehrddvtddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeefkedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/s1s_w35=OAg5_w9IeCHOaaW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 9 May 2020 10:59:14 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat, 9 May 2020 10:13:22 +0200 Stephen Kitt wrote:
> > On Fri, 8 May 2020 20:50:25 -0700, Jakub Kicinski <kuba@kernel.org>
> > wrote: =20
> > > On Fri,  8 May 2020 14:04:57 +0200 Stephen Kitt wrote:   =20
> > > > Commit c7228317441f ("net: Use a more standard macro for
> > > > INET_ADDR_COOKIE") added a __deprecated marker to the cookie name on
> > > > 32-bit architectures, with the intent that the compiler would flag
> > > > uses of the name. However since commit 771c035372a0 ("deprecate the
> > > > '__deprecated' attribute warnings entirely and for good"),
> > > > __deprecated doesn't do anything and should be avoided.
> > > >=20
> > > > This patch changes INET_ADDR_COOKIE to declare a dummy struct so th=
at
> > > > any subsequent use of the cookie's name will in all likelihood break
> > > > the build. It also removes the __deprecated marker.   =20
> > >=20
> > > I think the macro is supposed to cause a warning when the variable
> > > itself is accessed. And I don't think that happens with your patch
> > > applied.   =20
> >=20
> > Yes, the warning is what was lost when __deprecated lost its meaning. I
> > was trying to preserve that, or rather extend it so that the build would
> > break if the cookie was used on 32-bit architectures, and my patch
> > ensures it does if the cookie is used in a comparison or assignment,
> > but ...=20
> > > +       kfree(&acookie);   =20
> >=20
> > I hadn=E2=80=99t thought of taking a pointer to it.
> >=20
> > If we want to preserve the use of the macro with a semi-colon, which is
> > what Joe=E2=80=99s patch introduced (along with the deprecation warning=
), we
> > still need some sort of declaration which can=E2=80=99t be used. Perhaps
> >=20
> > #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
> > 	struct __name {} __attribute__((unused))
> >=20
> > would be better =E2=80=94 it declares the cookie as a struct, not a var=
iable, so
> > then the build fails if the cookie is used as anything other than a
> > struct. If anyone does try to use it as a struct, the build will fail on
> > 64-bit architectures...
> >=20
> >   CC      net/ipv4/inet_hashtables.o
> > net/ipv4/inet_hashtables.c: In function =E2=80=98__inet_lookup_establis=
hed=E2=80=99:
> > net/ipv4/inet_hashtables.c:362:9: error: =E2=80=98acookie=E2=80=99 unde=
clared (first use
> > in this function) kfree(&acookie);
> >          ^~~~~~~
> > net/ipv4/inet_hashtables.c:362:9: note: each undeclared identifier is
> > reported only once for each function it appears in make[2]: ***
> > [scripts/Makefile.build:267: net/ipv4/inet_hashtables.o] Error 1 make[1=
]:
> > *** [scripts/Makefile.build:488: net/ipv4] Error 2 make: ***
> > Makefile:1722: net] Error 2 =20
>=20
> Hm. That does seem better. Although thinking about it - we will not get
> a warning when someone declares a variable with the same name..

Good point!

> What if we went back to your original proposal of an empty struct but
> added in an extern in front? That way we should get linker error on
> pointer references.

That silently fails to fail if any other link object provides a definition
for the symbol, even if the type doesn=E2=80=99t match...

I thought of

	register struct {} __name __attribute__((unused))

but that really feels like tacking on more stuff to handle cases as we think
of them, which makes me wonder what cases I=E2=80=99m not thinking of.

Regards,

Stephen

--Sig_/s1s_w35=OAg5_w9IeCHOaaW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAl62/wwACgkQgNMC9Yht
g5wo4BAAjQOE/+/mkcahMWlo0f2dTATJ71MA7sUP0D6bvFV/y663ziTtzHxxCUqm
0TEZCcmIPcABuqm8BjkfET2R8Q+3dSYOwGQ4oq4ud3s2w/e9vCouDtMPkoXljOhf
BQK52Pk4cuGDolV8QNKXi1cX3HfXbUXbg1jJ270DwQEs/y7+ENFUTaEE21GRA85d
66a1mbDKbw08Vls8NlRYIQUa3l3xL6RxtCb/6zlqAB0OY856HBFYbB7ZSR3NQGPl
WKvNjdB72nkIf4rdWtyd4nyMYn0+IPiUC6JdYKoZhAuunOZLWtL3v4NmA2wPh9vf
/QPqOHuw3/+z8G/7PjAGnxDslgtFUll+2vJG55qRvl65Ke4zEvws/gJX6ucARltP
cXPoOEdJZ0YBmUaPzVylafmobveV6Czf5UuHSeF/5eiNaYMHf45ASdpdifJkstu7
42oYf5VyXObBrkTPJ8BllexkrOVDcvJl545p6ukjYp68RduD7IByvsCHYSt64Tmi
Hg3nWY1fWysJYAr4GBaMjgpdnWtoKBmBwDQbLKSGuBCytHwuk6wLsWMOI5sPt/y5
ewRoSV09NCjsCnlkgoD4xGMPqn3ofM46KRh0fr3HYDsKHDm4Recaexq//kgC33dD
fZPxiykFtaUAT2Erl3yzjJrzY5nwKTbpZu4L+ONmEjTNNS8uKGM=
=kb27
-----END PGP SIGNATURE-----

--Sig_/s1s_w35=OAg5_w9IeCHOaaW--
