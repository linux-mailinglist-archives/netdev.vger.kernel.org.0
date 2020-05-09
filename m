Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09041CBF0D
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgEIIaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:30:10 -0400
Received: from 4.mo178.mail-out.ovh.net ([46.105.49.171]:42332 "EHLO
        4.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgEIIaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 04:30:09 -0400
X-Greylist: delayed 990 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 May 2020 04:30:08 EDT
Received: from player795.ha.ovh.net (unknown [10.110.115.178])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id E4D4F9CAE2
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 10:13:36 +0200 (CEST)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
        (Authenticated sender: steve@sk2.org)
        by player795.ha.ovh.net (Postfix) with ESMTPSA id B27E6120BE947;
        Sat,  9 May 2020 08:13:30 +0000 (UTC)
Date:   Sat, 9 May 2020 10:13:22 +0200
From:   Stephen Kitt <steve@sk2.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Protect INET_ADDR_COOKIE on 32-bit
 architectures
Message-ID: <20200509101322.12651ba0@heffalump.sk2.org>
In-Reply-To: <20200508205025.3207a54e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200508120457.29422-1-steve@sk2.org>
        <20200508205025.3207a54e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/9mvdhOCxYpkif46yAk3haxY"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 7363385392269053338
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddtudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgesghdtreerredtjeenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepveelvdeufedvieevffdtueegkeevteehffdtffetleehjeekjeejudffieduteeknecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejleehrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9mvdhOCxYpkif46yAk3haxY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for taking the time to review my patch.

On Fri, 8 May 2020 20:50:25 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri,  8 May 2020 14:04:57 +0200 Stephen Kitt wrote:
> > Commit c7228317441f ("net: Use a more standard macro for
> > INET_ADDR_COOKIE") added a __deprecated marker to the cookie name on
> > 32-bit architectures, with the intent that the compiler would flag
> > uses of the name. However since commit 771c035372a0 ("deprecate the
> > '__deprecated' attribute warnings entirely and for good"),
> > __deprecated doesn't do anything and should be avoided.
> >=20
> > This patch changes INET_ADDR_COOKIE to declare a dummy struct so that
> > any subsequent use of the cookie's name will in all likelihood break
> > the build. It also removes the __deprecated marker.
>=20
> I think the macro is supposed to cause a warning when the variable
> itself is accessed. And I don't think that happens with your patch
> applied.

Yes, the warning is what was lost when __deprecated lost its meaning. I was
trying to preserve that, or rather extend it so that the build would break =
if
the cookie was used on 32-bit architectures, and my patch ensures it does if
the cookie is used in a comparison or assignment, but ...

> +       kfree(&acookie);

I hadn=E2=80=99t thought of taking a pointer to it.

If we want to preserve the use of the macro with a semi-colon, which is what
Joe=E2=80=99s patch introduced (along with the deprecation warning), we sti=
ll need
some sort of declaration which can=E2=80=99t be used. Perhaps

#define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
	struct __name {} __attribute__((unused))

would be better =E2=80=94 it declares the cookie as a struct, not a variabl=
e, so then
the build fails if the cookie is used as anything other than a struct. If
anyone does try to use it as a struct, the build will fail on 64-bit
architectures...

  CC      net/ipv4/inet_hashtables.o
net/ipv4/inet_hashtables.c: In function =E2=80=98__inet_lookup_established=
=E2=80=99:
net/ipv4/inet_hashtables.c:362:9: error: =E2=80=98acookie=E2=80=99 undeclar=
ed (first use in this function)
  kfree(&acookie);
         ^~~~~~~
net/ipv4/inet_hashtables.c:362:9: note: each undeclared identifier is repor=
ted only once for each function it appears in
make[2]: *** [scripts/Makefile.build:267: net/ipv4/inet_hashtables.o] Error=
 1
make[1]: *** [scripts/Makefile.build:488: net/ipv4] Error 2
make: *** Makefile:1722: net] Error 2

Regards,

Stephen

--Sig_/9mvdhOCxYpkif46yAk3haxY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAl62ZiIACgkQgNMC9Yht
g5zjJg/+KlAVGvSNFVCsuRBtGULhWAy7mQpPubb0UBbKPLW7F9yOlXtV/WZyaudp
ncRtq62brLrsIWvozJLtP4sW8r8A3sL4qLKIy+6xrKCcovr33PRrssPRz2j7iFQF
P+95CYHoFRygzYgodQVPRZh3Oyqzoff21tW8bgJYj8vORKiYo0KqJ512i6q28CoU
FSQ6Yf8aPnhYfnDns2Vce7Yh2seghF28sI4+a8H1gf1RE386RYhnq4GMbFlwhIS/
kqAV1UOspX6RfkbtQrdl/oaHJ0F3GOBPPhJLIP9yZmsdQjYwyaoVE8Nq0Dlw97Y1
vH06953MaU8YuXuUlvACU2pYi4kUh66qEZnw7oTViv+uYE3sd2JMFr5RU3XqlOFk
Lzp7hRBEL6KWWtrL7/0woKBTDH3S95zUbWifPDQo5ZKjXo84pZO8nbtJBnhIgdO6
7yqEDR3hwL4ZEQlQUVlU4LAkVw/iZawCfCeTNM8hxj8ufFvtQs8Pb8P+yFC3SFLT
2QtfAomXNiuGDqIp2YFa6HnVUTal7c/U/HjglmNaaqmDza9U5Awd/1vpwYN8ZvSM
C3cz+FVo9bZSyLd9mDn7wnzVSxlKA3E6c9WRu0bLxBY6emMZu13YyRdsVhkizMvQ
oAKcUpohy5uhhOPCYpjR7S0/4m+R00nypojvaN50Aevtk1CPcwI=
=YPeA
-----END PGP SIGNATURE-----

--Sig_/9mvdhOCxYpkif46yAk3haxY--
