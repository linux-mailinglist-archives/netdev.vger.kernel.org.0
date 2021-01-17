Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AC22F91AB
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 11:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbhAQKO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 05:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbhAQKN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 05:13:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03122C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 02:13:16 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l153D-0002Ur-R1; Sun, 17 Jan 2021 11:12:51 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l1537-0004rN-6i; Sun, 17 Jan 2021 11:12:45 +0100
Date:   Sun, 17 Jan 2021 11:12:42 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Juliet Kim <julietk@linux.vnet.ibm.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@pengutronix.de
Subject: ibmvnic: Race condition in remove callback
Message-ID: <20210117101242.dpwayq6wdgfdzirl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5xx5owkdwvjrobm2"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5xx5owkdwvjrobm2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

while working on some cleanup I stumbled over a problem in the ibmvnic's
remove callback. Since commit

        7d7195a026ba ("ibmvnic: Do not process device remove during device =
reset")

there is the following code in the remove callback:

        static int ibmvnic_remove(struct vio_dev *dev)
        {
                ...
                spin_lock_irqsave(&adapter->state_lock, flags);
                if (test_bit(0, &adapter->resetting)) {
                        spin_unlock_irqrestore(&adapter->state_lock, flags);
                        return -EBUSY;
                }

                adapter->state =3D VNIC_REMOVING;
                spin_unlock_irqrestore(&adapter->state_lock, flags);

                flush_work(&adapter->ibmvnic_reset);
                flush_delayed_work(&adapter->ibmvnic_delayed_reset);
                ...
        }

Unfortunately returning -EBUSY doesn't work as intended. That's because
the return value of this function is ignored[1] and the device is
considered unbound by the device core (shortly) after ibmvnic_remove()
returns.

While looking into fixing that I noticed a worse problem:

If ibmvnic_reset() (e.g. called by the tx_timeout callback) calls
schedule_work(&adapter->ibmvnic_reset); just after the work queue is
flushed above the problem that 7d7195a026ba intends to fix will trigger
resulting in a use-after-free.

Also ibmvnic_reset() checks for adapter->state without holding the lock
which might be racy, too.

Best regards
Uwe

[1] vio_bus_remove (in arch/powerpc/platforms/pseries/vio.c) records the
    return value and passes it on. But the driver core doesn't care for
    the return value (see __device_release_driver() in drivers/base/dd.c
    calling dev->bus->remove()).

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--5xx5owkdwvjrobm2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmAEDZYACgkQwfwUeK3K
7AkwBQf/c47PaHA1ggqrUFZW6gBFSWnb0WF0g1/68U3HbE+n0NneW5z6EzT9F+lF
zCKvZ21hhpaCya0ELqrJsjaHPsafl+GwbUFZWDXgzTZz3sSIVFEoRqAErOuhkkU9
qXo4hSOsz01PTwQLYd9UjzHnlAUGrhxSavJSuZkzFS/4h/f7pXjUiM0+R0Njz1ob
7UweVmKM4px/6MBOybthxtBohmcZgtBUT2+y8OHfo2972u+FTCjMdaGciOQk2v/+
8W3DjMHyWqgIiUnvRc/AZc2TiuEsthQtq/x1R/QO+dEX66l8oyqTYEWqs95Kk9kO
X3Bes4bDpvxoAp1vAdXBorxocl/BQQ==
=4xyH
-----END PGP SIGNATURE-----

--5xx5owkdwvjrobm2--
