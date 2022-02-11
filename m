Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79CC4B279B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 15:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241383AbiBKOM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 09:12:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiBKOMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 09:12:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4055CDF1
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 06:12:24 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nIWeo-0002SJ-LU; Fri, 11 Feb 2022 15:12:18 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0040A3143B;
        Fri, 11 Feb 2022 14:12:16 +0000 (UTC)
Date:   Fri, 11 Feb 2022 15:12:13 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: ether_addr_equal_64bits breakage with gcc-12
Message-ID: <20220211141213.l4yitk7aifehjymp@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2el65uhlktt7clfl"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2el65uhlktt7clfl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

the current arm-linux-gnueabihf-gcc 12 snapshot in Debian breaks (at
least with CONFIG_WERROR=3Dy):

|   CC      net/core/dev.o
| net/core/dev.c: In function =E2=80=98bpf_prog_run_generic_xdp=E2=80=99:
| net/core/dev.c:4618:21: warning: =E2=80=98ether_addr_equal_64bits=E2=80=
=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
|  4618 |         orig_host =3D ether_addr_equal_64bits(eth->h_dest, skb->d=
ev->dev_addr);
|       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
| net/core/dev.c:4618:21: note: referencing argument 1 of type =E2=80=98con=
st u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
| net/core/dev.c:4618:21: note: referencing argument 2 of type =E2=80=98con=
st u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
| In file included from net/core/dev.c:91:
| include/linux/etherdevice.h:375:20: note: in a call to function =E2=80=98=
ether_addr_equal_64bits=E2=80=99
|   375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
|       |                    ^~~~~~~~~~~~~~~~~~~~~~~
| net/core/dev.c:4619:22: warning: =E2=80=98is_multicast_ether_addr_64bits=
=E2=80=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
|  4619 |         orig_bcast =3D is_multicast_ether_addr_64bits(eth->h_dest=
);
|       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| net/core/dev.c:4619:22: note: referencing argument 1 of type =E2=80=98con=
st u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
| include/linux/etherdevice.h:137:20: note: in a call to function =E2=80=98=
is_multicast_ether_addr_64bits=E2=80=99
|   137 | static inline bool is_multicast_ether_addr_64bits(const u8 addr[6=
+2])
|       |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| net/core/dev.c:4646:27: warning: =E2=80=98ether_addr_equal_64bits=E2=80=
=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
|  4646 |             (orig_host !=3D ether_addr_equal_64bits(eth->h_dest,
|       |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|  4647 |                                                   skb->dev->dev_a=
ddr)) ||
|       |                                                   ~~~~~~~~~~~~~~~=
~~~~
| net/core/dev.c:4646:27: note: referencing argument 1 of type =E2=80=98con=
st u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
| net/core/dev.c:4646:27: note: referencing argument 2 of type =E2=80=98con=
st u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
| include/linux/etherdevice.h:375:20: note: in a call to function =E2=80=98=
ether_addr_equal_64bits=E2=80=99
|   375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
|       |                    ^~~~~~~~~~~~~~~~~~~~~~~
| net/core/dev.c:4648:28: warning: =E2=80=98is_multicast_ether_addr_64bits=
=E2=80=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
|  4648 |             (orig_bcast !=3D is_multicast_ether_addr_64bits(eth->=
h_dest))) {
|       |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
| net/core/dev.c:4648:28: note: referencing argument 1 of type =E2=80=98con=
st u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
| include/linux/etherdevice.h:137:20: note: in a call to function =E2=80=98=
is_multicast_ether_addr_64bits=E2=80=99
|   137 | static inline bool is_multicast_ether_addr_64bits(const u8 addr[6=
+2])
|       |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

| arm-linux-gnueabihf-gcc -v
| Using built-in specs.
| COLLECT_GCC=3D/usr/bin/arm-linux-gnueabihf-gcc
| COLLECT_LTO_WRAPPER=3D/usr/lib/gcc-cross/arm-linux-gnueabihf/12/lto-wrapp=
er
| Target: arm-linux-gnueabihf
| Configured with: ../src/configure -v --with-pkgversion=3D'Debian 12-20220=
126-1' --with-bugurl=3Dfile:///usr/share/doc/gcc-12/README.Bugs --enable-la=
nguages=3Dc,ada,c++,go,d,fortran,objc,obj-c++,m2 --prefix=3D/usr --with-gcc=
-major-version-only --program-suffix=3D-12 --enable-shared --enable-linker-=
build-id --libexecdir=3D/usr/lib --without-included-gettext --enable-thread=
s=3Dposix --libdir=3D/usr/lib --enable-nls --with-sysroot=3D/ --enable-cloc=
ale=3Dgnu --enable-libstdcxx-debug --enable-libstdcxx-time=3Dyes --with-def=
ault-libstdcxx-abi=3Dnew --enable-gnu-unique-object --disable-libitm --disa=
ble-libquadmath --disable-libquadmath-support --enable-plugin --enable-defa=
ult-pie --with-system-zlib --enable-libphobos-checking=3Drelease --without-=
target-system-zlib --enable-multiarch --disable-sjlj-exceptions --with-arch=
=3Darmv7-a+fp --with-float=3Dhard --with-mode=3Dthumb --disable-werror --en=
able-checking=3Drelease --build=3Dx86_64-linux-gnu --host=3Dx86_64-linux-gn=
u --target=3Darm-linux-gnueabihf --program-prefix=3Darm-linux-gnueabihf- --=
includedir=3D/usr/arm-linux-gnueabihf/include
| Thread model: posix
| Supported LTO compression algorithms: zlib zstd
| gcc version 12.0.1 20220126 (experimental) [master r12-6872-gf3e6ef7d873]=
 (Debian 12-20220126-1)

regards,
Marc

--
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2el65uhlktt7clfl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIGbrgACgkQrX5LkNig
012gKggAjL3oLaxv5ui+C8nII08VeMC2MiqeV1YyScLhE7ysR2v4cEi1LO/jhIBH
JzX2hfRL3PxDoVj3YfwnKOB3VsTNYxNk4ln8eigSbZzgCV67OVqWjG3LDJ5/p+Zz
PUeu43LWe95DKKzMGSRDAr9275tkE7Hd9T893PL5aj4ktJtHTWlZ5ebVFF+Zylri
ZfE9aoMjv7K5+hmmVOSle1xTnh/KpK5oK1smut7UYMAeiQlP4CivZHz8ahJwO8b5
J/W65RugMrsiOG+b+kMicxHjEp+zblT2Nl7bk3RnKSeJOgP7wNZd3ggWI0GxHJd5
7Me4/ngoi+lgas7MF2f52viajv4PYQ==
=uCpe
-----END PGP SIGNATURE-----

--2el65uhlktt7clfl--
