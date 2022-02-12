Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DAF4B320E
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353147AbiBLAft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:35:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245212AbiBLAfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:35:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DFED7F
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 16:35:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFDECB82DF9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 00:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB4EC340E9;
        Sat, 12 Feb 2022 00:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644626143;
        bh=770kDDXLOHwqej7GKkp6lR8iVXtDxx6M30EgN5vV3jk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cqSjGOYAUsV34uvrxHaRyN5XQvcnGAoqS5DP3+klOefdzuFRfkkz4pOat1nd00y8Y
         kv0z9AWZ+ffmwyADbu8SI/FIeGc6GVeRMLTUZauoIxhtpkDXm9W1daDP4GLkhJ8W3i
         kQ0qH4n343D/HNZtBDAZQt0tNTmt9UjzMNHs4FJ1Th7BpaTHtav5Z9TDaKY5rXzUbz
         6dXoldysIBcQBUDFQAaVQR+/LA6AU3c/z60sBOgVFmlqH9kGDdmOuW+VymMfvlZlvJ
         BFe/ll4LHLj/U66p3NWV7fS7YrgU/E+ub0Lz8rCcAIcIjwwBAl/lXP5FIoOsT2Hsje
         ys5/v2kle6M9g==
Date:   Fri, 11 Feb 2022 16:35:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Kees Cook <keescook@chromium.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: ether_addr_equal_64bits breakage with gcc-12
Message-ID: <20220211163541.74b0836a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211141213.l4yitk7aifehjymp@pengutronix.de>
References: <20220211141213.l4yitk7aifehjymp@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Feb 2022 15:12:13 +0100 Marc Kleine-Budde wrote:
> Hello,
>=20
> the current arm-linux-gnueabihf-gcc 12 snapshot in Debian breaks (at
> least with CONFIG_WERROR=3Dy):
>=20
> |   CC      net/core/dev.o
> | net/core/dev.c: In function =E2=80=98bpf_prog_run_generic_xdp=E2=80=99:
> | net/core/dev.c:4618:21: warning: =E2=80=98ether_addr_equal_64bits=E2=80=
=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
> |  4618 |         orig_host =3D ether_addr_equal_64bits(eth->h_dest, skb-=
>dev->dev_addr);
> |       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~
> | net/core/dev.c:4618:21: note: referencing argument 1 of type =E2=80=98c=
onst u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> | net/core/dev.c:4618:21: note: referencing argument 2 of type =E2=80=98c=
onst u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> | In file included from net/core/dev.c:91:
> | include/linux/etherdevice.h:375:20: note: in a call to function =E2=80=
=98ether_addr_equal_64bits=E2=80=99
> |   375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
> |       |                    ^~~~~~~~~~~~~~~~~~~~~~~
> | net/core/dev.c:4619:22: warning: =E2=80=98is_multicast_ether_addr_64bit=
s=E2=80=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
> |  4619 |         orig_bcast =3D is_multicast_ether_addr_64bits(eth->h_de=
st);
> |       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> | net/core/dev.c:4619:22: note: referencing argument 1 of type =E2=80=98c=
onst u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> | include/linux/etherdevice.h:137:20: note: in a call to function =E2=80=
=98is_multicast_ether_addr_64bits=E2=80=99
> |   137 | static inline bool is_multicast_ether_addr_64bits(const u8 addr=
[6+2])
> |       |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> | net/core/dev.c:4646:27: warning: =E2=80=98ether_addr_equal_64bits=E2=80=
=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
> |  4646 |             (orig_host !=3D ether_addr_equal_64bits(eth->h_dest,
> |       |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> |  4647 |                                                   skb->dev->dev=
_addr)) ||
> |       |                                                   ~~~~~~~~~~~~~=
~~~~~~
> | net/core/dev.c:4646:27: note: referencing argument 1 of type =E2=80=98c=
onst u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> | net/core/dev.c:4646:27: note: referencing argument 2 of type =E2=80=98c=
onst u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> | include/linux/etherdevice.h:375:20: note: in a call to function =E2=80=
=98ether_addr_equal_64bits=E2=80=99
> |   375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
> |       |                    ^~~~~~~~~~~~~~~~~~~~~~~
> | net/core/dev.c:4648:28: warning: =E2=80=98is_multicast_ether_addr_64bit=
s=E2=80=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
> |  4648 |             (orig_bcast !=3D is_multicast_ether_addr_64bits(eth=
->h_dest))) {
> |       |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~
> | net/core/dev.c:4648:28: note: referencing argument 1 of type =E2=80=98c=
onst u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> | include/linux/etherdevice.h:137:20: note: in a call to function =E2=80=
=98is_multicast_ether_addr_64bits=E2=80=99
> |   137 | static inline bool is_multicast_ether_addr_64bits(const u8 addr=
[6+2])
> |       |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> | arm-linux-gnueabihf-gcc -v
> | Using built-in specs.
> | COLLECT_GCC=3D/usr/bin/arm-linux-gnueabihf-gcc
> | COLLECT_LTO_WRAPPER=3D/usr/lib/gcc-cross/arm-linux-gnueabihf/12/lto-wra=
pper
> | Target: arm-linux-gnueabihf
> | Configured with: ../src/configure -v --with-pkgversion=3D'Debian 12-202=
20126-1' --with-bugurl=3Dfile:///usr/share/doc/gcc-12/README.Bugs --enable-=
languages=3Dc,ada,c++,go,d,fortran,objc,obj-c++,m2 --prefix=3D/usr --with-g=
cc-major-version-only --program-suffix=3D-12 --enable-shared --enable-linke=
r-build-id --libexecdir=3D/usr/lib --without-included-gettext --enable-thre=
ads=3Dposix --libdir=3D/usr/lib --enable-nls --with-sysroot=3D/ --enable-cl=
ocale=3Dgnu --enable-libstdcxx-debug --enable-libstdcxx-time=3Dyes --with-d=
efault-libstdcxx-abi=3Dnew --enable-gnu-unique-object --disable-libitm --di=
sable-libquadmath --disable-libquadmath-support --enable-plugin --enable-de=
fault-pie --with-system-zlib --enable-libphobos-checking=3Drelease --withou=
t-target-system-zlib --enable-multiarch --disable-sjlj-exceptions --with-ar=
ch=3Darmv7-a+fp --with-float=3Dhard --with-mode=3Dthumb --disable-werror --=
enable-checking=3Drelease --build=3Dx86_64-linux-gnu --host=3Dx86_64-linux-=
gnu --target=3Darm-linux-gnueabihf --program-prefix=3Darm-linux-gnueabihf- =
--includedir=3D/usr/arm-linux-gnueabihf/include
> | Thread model: posix
> | Supported LTO compression algorithms: zlib zstd
> | gcc version 12.0.1 20220126 (experimental) [master r12-6872-gf3e6ef7d87=
3] (Debian 12-20220126-1)

Maybe Kees will have as suggestion - Kees, are there any best practices
for dealing with such issues? For the reference we do a oversized load
from a structure (read 8B of a 6B array):

struct ethhdr {
	unsigned char	h_dest[6];
	unsigned char	h_source[6];
	__be16		h_proto;
} __attribute__((packed));

But then discard the irrelevant bytes:

#if defined(CONFIG_HAVE_EFFICIENT...
	u64 fold =3D (*(const u64 *)addr1) ^ (*(const u64 *)addr2);
#ifdef __BIG_ENDIAN
	return (fold >> 16) =3D=3D 0;
#else ...


The structure is uAPI, for added fun.
