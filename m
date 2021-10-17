Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59634430822
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245352AbhJQKub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 06:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245332AbhJQKua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 06:50:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D593C061767
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 03:48:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc3i7-0002kV-U1; Sun, 17 Oct 2021 12:48:11 +0200
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AFA186958B6;
        Sun, 17 Oct 2021 10:44:00 +0000 (UTC)
Date:   Sun, 17 Oct 2021 12:43:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     robin@protonic.nl, linux@rempel-privat.de, socketcan@hartkopp.net,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: fix UAF for rx_kref of j1939_priv
Message-ID: <20211017104329.ccz3r5lsadqpbuj5@pengutronix.de>
References: <20210926104757.2021540-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lfm2fzo7ig3sk3dm"
Content-Disposition: inline
In-Reply-To: <20210926104757.2021540-1-william.xuanziyang@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lfm2fzo7ig3sk3dm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.09.2021 18:47:57, Ziyang Xuan wrote:
> It will trigger UAF for rx_kref of j1939_priv as following.
>=20
>         cpu0                                    cpu1
> j1939_sk_bind(socket0, ndev0, ...)
> j1939_netdev_start
>                                         j1939_sk_bind(socket1, ndev0, ...)
>                                         j1939_netdev_start
> j1939_priv_set
>                                         j1939_priv_get_by_ndev_locked
> j1939_jsk_add
> .....
> j1939_netdev_stop
> kref_put_lock(&priv->rx_kref, ...)
>                                         kref_get(&priv->rx_kref, ...)
>                                         REFCOUNT_WARN("addition on 0;...")
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 1 PID: 20874 at lib/refcount.c:25 refcount_warn_saturate+0x=
169/0x1e0
> RIP: 0010:refcount_warn_saturate+0x169/0x1e0
> Call Trace:
>  j1939_netdev_start+0x68b/0x920
>  j1939_sk_bind+0x426/0xeb0
>  ? security_socket_bind+0x83/0xb0
>=20
> The rx_kref's kref_get() and kref_put() should use j1939_netdev_lock to
> protect.
>=20
> Fixes: 9d71dd0c70099 ("can: add support of SAE J1939 protocol")
> Reported-by: syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Added to linux-can/testing, added stable on Cc.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lfm2fzo7ig3sk3dm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFr/k8ACgkQqclaivrt
76n81Af+NxBLZqG3wWfCjpl7IxccdICWAetFxDreGHh2/XjF61A99AZ0cTFUA+88
Ygo2PxOaIUDcRE6Ffb+d6HOeDdHZYCKmHNuB7UnUVsIQNoGVV09hRd9gHzTe0SmW
IWZTml85rCHRu4mIlvIVfINn21umaPPhqlsggYp4cxB2/uyrvLmC1j0Rh00IGx/1
FgNGSIJW1xlacOXtikg8OoPu1mn/8iAYuz69AVWppchPRJ86hqByc6eYRKirmqcc
S0r7Zccb2gZ8cNs5MNGyram8MCB6Jw5+m87rcCxXdJiecqDQra1987MaTEEF7y//
Kcm2E4tnvCZNT7gW8/fvfs8t1Pkenw==
=qnl1
-----END PGP SIGNATURE-----

--lfm2fzo7ig3sk3dm--
