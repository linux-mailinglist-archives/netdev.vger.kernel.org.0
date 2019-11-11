Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FCBF7686
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKKOhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfKKOhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 09:37:34 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA70121925;
        Mon, 11 Nov 2019 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573483053;
        bh=wt2SP0Q7YpLCVKnumwcbslHQuGSL73MTys1RYn9Q7yA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j3Cnu/Lr+GY5ByGjbfJNXHl3blG1p0sR/Zv8TSCZXqDTTOO49tpNoMjoug4Or1BdF
         jo4CR9OfNfbFqyWXAm/fltYXC5Y9AaBpm2EgVeeI8lRPzbk6LWwn7FaICcQ+kUrivL
         KjkjfopEOZ8zxE+DE62hbrmKH7VXbewGpFNA3RHc=
Date:   Mon, 11 Nov 2019 16:37:25 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     ilias.apalodimas@linaro.org, brouer@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: Regression in mvneta with XDP patches
Message-ID: <20191111143725.GB4197@localhost.localdomain>
References: <20191111134615.GA8153@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline
In-Reply-To: <20191111134615.GA8153@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo, Jesper, Ilias
>=20

Hi Andrew,

> I just found that the XDP patches to mvneta have caused a regression.
>=20
> This one breaks networking:
>=20
> commit 8dc9a0888f4c8e27b25e48ff1b4bc2b3a845cc2d (HEAD)
> Author: Lorenzo Bianconi <lorenzo@kernel.org>
> Date:   Sat Oct 19 10:13:23 2019 +0200
>=20
>     net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine
>    =20
>     Refactor mvneta_rx_swbm code introducing mvneta_swbm_rx_frame and
>     mvneta_swbm_add_rx_fragment routines. Rely on build_skb in oreder to
>     allocate skb since the previous patch introduced buffer recycling usi=
ng
>     the page_pool API.
>     This patch fixes even an issue in the original driver where dma buffe=
rs
>     are accessed before dma sync.
>     mvneta driver can run on not cache coherent devices so it is
>     necessary to sync DMA buffers before sending them to the device
>     in order to avoid memory corruptions. Running perf analysis we can
>     see a performance cost associated with this DMA-sync (anyway it is
>     already there in the original driver code). In follow up patches we
>     will add more logic to reduce DMA-sync as much as possible.
>=20
> I'm using an Linksys WRT1900ac, which has an Armada XP SoC. Device
> tree is arch/arm/boot/dts/armada-xp-linksys-mamba.dts.

looking at the dts, could you please confirm mvneta is using hw or sw buffe=
r manager
on this board? Moreover are you using DSA as well?

Regards,
Lorenzo

>=20
> With this patch applied, transmit appears to work O.K. My dhcp server
> is seeing good looking BOOTP requests and replying. However what is
> being received by the WRT1900ac is bad.
>=20
> 11:36:20.038558 d8:f7:00:00:00:00 (oui Unknown) > 00:00:00:00:5a:45 (oui =
Ethernet) Null Informati4
>         0x0000:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0010:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0020:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0030:  0000 0000 0000                           ......
> 11:36:26.924914 d8:f7:00:00:00:00 (oui Unknown) > 00:00:00:00:5a:45 (oui =
Ethernet) Null Informati4
>         0x0000:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0010:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0020:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0030:  0000 0000 0000                           ......
> 11:36:27.636597 4c:69:6e:75:78:20 (oui Unknown) > 6e:20:47:4e:55:2f (oui =
Unknown), ethertype Unkn=20
>         0x0000:  2873 7472 6574 6368 2920 4c69 6e75 7820  (stretch).Linux.
>         0x0010:  352e 342e 302d 7263 362d 3031 3438 312d  5.4.0-rc6-01481-
>         0x0020:  6739 3264 3965 3038 3439 3662 382d 6469  g92d9e08496b8-di
>         0x0030:  7274 7920 2333 2053 756e 204e 6f76 2031  rty.#3.Sun.Nov.1
>         0x0040:  3020 3136 3a31 373a 3531 2043 5354 2032  0.16:17:51.CST.2
>         0x0050:  3031 3920 6172 6d76 376c 0e04 009c 0080  019.armv7l......
>         0x0060:  100c 0501 0a00 000e 0200 0000 0200 1018  ................
>         0x0070:  1102 fe80 0000 0000 0000 eefa aaff fe01  ................
>         0x0080:  12fe 0200 0000 0200 0804 6574 6830 fe09  ..........eth0..
>         0x0090:  0012 0f03 0100 0000 00fe 0900 120f 0103  ................
>         0x00a0:  ec00 0010 0000 e3ed 5509 0000 0000 0000  ........U.......
>         0x00b0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x00c0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x00d0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x00e0:  0000 0000 0000
>=20
> This actually looks like random kernel memory.
>=20
>      Andrew

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXclyIgAKCRA6cBh0uS2t
rDpEAQD4pZz+sgn4HFLyKWSzwkEo0CWcBEB9dTUMXyjr7piPXQEAgASHPediNrB1
WHfdbfhPsEB4jcHjM6IUcBB1Cljemw8=
=LGoR
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
