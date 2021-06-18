Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9938B3AC4C7
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhFRHTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhFRHTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:19:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16D3C061760
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 00:17:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lu8km-0003gp-5p; Fri, 18 Jun 2021 09:17:24 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:e7d0:b47e:7728:2b24])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A8CA463EA3C;
        Fri, 18 Jun 2021 07:04:52 +0000 (UTC)
Date:   Fri, 18 Jun 2021 09:04:52 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: can: fix use-after-free in ems_usb_disconnect
Message-ID: <20210618070452.cjt7f5hzlfikztwz@pengutronix.de>
References: <20210617185130.5834-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6tq7svrpdp6b2uth"
Content-Disposition: inline
In-Reply-To: <20210617185130.5834-1-paskripkin@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6tq7svrpdp6b2uth
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.06.2021 21:51:30, Pavel Skripkin wrote:
> In ems_usb_disconnect() dev pointer, which is
> netdev private data, is used after free_candev() call:
>=20
> 	if (dev) {
> 		unregister_netdev(dev->netdev);
> 		free_candev(dev->netdev);
>=20
> 		unlink_all_urbs(dev);
>=20
> 		usb_free_urb(dev->intr_urb);
>=20
> 		kfree(dev->intr_in_buffer);
> 		kfree(dev->tx_msg_buffer);
> 	}
>=20
> Fix it by simply moving free_candev() at the end of
> the block.
>=20
> Fail log:
>  BUG: KASAN: use-after-free in ems_usb_disconnect
>  Read of size 8 at addr ffff88804e041008 by task kworker/1:2/2895
>=20
>  CPU: 1 PID: 2895 Comm: kworker/1:2 Not tainted 5.13.0-rc5+ #164
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0=
-g155821a-rebuilt.opensuse.4
>  Workqueue: usb_hub_wq hub_event
>  Call Trace:
>      dump_stack (lib/dump_stack.c:122)
>      print_address_description.constprop.0.cold (mm/kasan/report.c:234)
>      kasan_report.cold (mm/kasan/report.c:420 mm/kasan/report.c:436)
>      ems_usb_disconnect (drivers/net/can/usb/ems_usb.c:683 drivers/net/ca=
n/usb/ems_usb.c:1058)
>=20
> Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB=
 interface")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Applied to linux-can/testing and added stable on Cc.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6tq7svrpdp6b2uth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDMRZEACgkQqclaivrt
76mnqgf/aSKQviylfEMXNmblnBD4eGq3CMjiugvH+K4jof1OJ72ztvdUzP2DAfd/
9CA0EE0UWEVpqhcUteGMMgM7F0+AqJF4PvgqiR5YT2qqnWg40xDcC2+NtdRYNBqt
fQt+mzbXNj5J39v8l8FJGPo5Ip7E561khpGG9jA5BFgIT70jegTdNPho+uUV+CKV
1co2LUuDCPtnN/GZHOI3bLflWqr2p1V60RimGZK9QbOLYuf5ZynHkB4+GrwVO+MV
Sryao3eO/JR06Ty6vo4RVh0SqWOFx549SGsl+O9pn7W5U4Sw+5eklu5UVW6OyL52
pWNIVhvfae9qHdITE3ZftnG0OPd1gQ==
=n50B
-----END PGP SIGNATURE-----

--6tq7svrpdp6b2uth--
