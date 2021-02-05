Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD15310658
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhBEIK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:10:57 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49491 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhBEIIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:08:11 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l7w72-0006id-K0; Fri, 05 Feb 2021 09:05:08 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:8f9f:ac65:660b:ab5f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 33B765D725F;
        Fri,  5 Feb 2021 08:05:04 +0000 (UTC)
Date:   Fri, 5 Feb 2021 09:05:02 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Xulin Sun <xulin.sun@windriver.com>
Cc:     wg@grandegger.com, dmurphy@ti.com, sriram.dash@samsung.com,
        kuba@kernel.org, davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xulinsun@gmail.com
Subject: Re: [PATCH 1/2] can: m_can: m_can_plat_probe(): free can_net device
 in case probe fails
Message-ID: <20210205080502.4chauzh3rey6bpvu@hardanger.blackshift.org>
References: <20210205072559.13241-1-xulin.sun@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zbu6fhcwy5glorai"
Content-Disposition: inline
In-Reply-To: <20210205072559.13241-1-xulin.sun@windriver.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zbu6fhcwy5glorai
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.02.2021 15:25:58, Xulin Sun wrote:
> The can_net device is allocated through kvzalloc(), if the subsequent pro=
be
> cases fail to initialize, it should free the can_net device that has been
> successfully allocated before.
>=20
> To fix below memory leaks call trace:
>=20
> unreferenced object 0xfffffc08418b0000 (size 32768):
> comm "kworker/0:1", pid 22, jiffies 4294893966 (age 931.976s)
> hex dump (first 32 bytes):
> 63 61 6e 25 64 00 00 00 00 00 00 00 00 00 00 00 can%d...........
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> backtrace:
> [<000000003faec9cc>] __kmalloc+0x1a4/0x3e0
> [<00000000560b1cad>] kvmalloc_node+0xa0/0xb0
> [<0000000093bada32>] alloc_netdev_mqs+0x60/0x380
> [<0000000041ddbb53>] alloc_candev_mqs+0x6c/0x14c
> [<00000000d08c7529>] m_can_class_allocate_dev+0x64/0x18c
> [<000000009fef1617>] m_can_plat_probe+0x2c/0x1f4
> [<000000006fdcc497>] platform_drv_probe+0x5c/0xb0
> [<00000000fd0f0726>] really_probe+0xec/0x41c
> [<000000003ffa5158>] driver_probe_device+0x60/0xf0
> [<000000005986c77e>] __device_attach_driver+0xb0/0x100
> [<00000000757823bc>] bus_for_each_drv+0x8c/0xe0
> [<0000000059253919>] __device_attach+0xdc/0x180
> [<0000000035c2b9f1>] device_initial_probe+0x28/0x34
> [<0000000082e2c85c>] bus_probe_device+0xa4/0xb0
> [<00000000cc6181c3>] deferred_probe_work_func+0x7c/0xb0
> [<0000000001b85f22>] process_one_work+0x1ec/0x480
>=20
> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>

This patch doesn't apply to net/master, since v5.10 there is a
similar fix:

    85816aba460c can: m_can: Fix freeing of can device from peripherials

Please update to latest v5.10.x. If you're on a kernel that's still
supported, and you're using the latest stable of that kernel, and it
doesn't have that patch applied, ask on linux-stable to pick up that
patch.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zbu6fhcwy5glorai
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAc/CsACgkQqclaivrt
76k4GAgAoCzMCXRD1nv4RBLQvl3ihvz9ra5Z2cMrl+RdHhEue7jym67pAAdMb0Vp
2HRMfryBK1po6t4pMk5FSe1bL2tWcTJ4hZ8yrLCClZYL5dQEM7h37e0Ewqe23+KN
KVwalbpqalVlRxfpTYRtPelEMW/4i6mfeosw4ALnfisp9hklroKjrEKBZRhUDAUA
uwbCtKNGmXUVCxQFI+z+oNB79wr+SMiV3kyI6e4ANIdNop/8V9JsPgZ1nQ9xixgg
sNoc69LUGhzY3k+2TTURJwiKVDWbun23MeaOWuZT+Lztw9XzFpilupzs+LbLc5TY
2dpmcgFZkIXCAL5r2g7Ts0trc4W5ag==
=1ObZ
-----END PGP SIGNATURE-----

--zbu6fhcwy5glorai--
