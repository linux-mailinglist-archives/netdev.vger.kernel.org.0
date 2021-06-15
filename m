Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307CF3A7808
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhFOHfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhFOHfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:35:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAD9C061767
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:33:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lt3Zb-00029x-1Y; Tue, 15 Jun 2021 09:33:23 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:8a21:1526:9696:549])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B54E063BCB9;
        Tue, 15 Jun 2021 07:33:20 +0000 (UTC)
Date:   Tue, 15 Jun 2021 09:33:19 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+57281c762a3922e14dfe@syzkaller.appspotmail.com
Subject: Re: [PATCH] can: mcba_usb: fix memory leak in mcba_usb
Message-ID: <20210615073319.fvwilowhsztr5hd6@pengutronix.de>
References: <20210609215833.30393-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dirso6rtm6ed5233"
Content-Disposition: inline
In-Reply-To: <20210609215833.30393-1-paskripkin@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dirso6rtm6ed5233
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.06.2021 00:58:33, Pavel Skripkin wrote:
> Syzbot reported memory leak in SocketCAN driver
> for Microchip CAN BUS Analyzer Tool. The problem
> was in unfreed usb_coherent.
>=20
> In mcba_usb_start() 20 coherent buffers are allocated
> and there is nothing, that frees them:
>=20
> 	1) In callback function the urb is resubmitted and that's all
> 	2) In disconnect function urbs are simply killed, but
> 	   URB_FREE_BUFFER is not set (see mcba_usb_start)
>            and this flag cannot be used with coherent buffers.
>=20
> Fail log:
> [ 1354.053291][ T8413] mcba_usb 1-1:0.0 can0: device disconnected
> [ 1367.059384][ T8420] kmemleak: 20 new suspected memory leaks (see /sys/=
kernel/debug/kmem)
>=20
> So, all allocated buffers should be freed with usb_free_coherent()
> explicitly
>=20
> NOTE:
> The same pattern for allocating and freeing coherent buffers
> is used in drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
>=20
> Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS An=
alyzer")
> Reported-and-tested-by: syzbot+57281c762a3922e14dfe@syzkaller.appspotmail=
=2Ecom
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Applied to linux-can/testing.

Tnx,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dirso6rtm6ed5233
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDIV70ACgkQqclaivrt
76l/SAf+JoHck2coCr+a3nf8Bwn7M/QOaYiaaDNyjAgHvumc6Ue+Z9CTCxS4yDVJ
gZkzRSQQY2tRhkzebDIuXKl2NZDmzJDZNu/7x7w4DJqN7MvEqpcPe6pTeJXRQJ8P
imAR0Dhu9wAH8052P2IDsM6P7IdtawhJjIsMh7upiS4l0bb6wQC7sVcdus4LbR8f
YlAmkYTr+wNoynjExFZCXf51HouOV2VxUBoXrOyp8yB5e+A2343hfxpffOEzobGS
oxY3QJgY0ux53F1NuijPXAo8QC/20phLPY22VwPkxv6v0YmPJuzaCBDtB+TWq6Dl
ZsL1W1PF7PGmCC0qLMIMzbEWs+54rg==
=Uly6
-----END PGP SIGNATURE-----

--dirso6rtm6ed5233--
