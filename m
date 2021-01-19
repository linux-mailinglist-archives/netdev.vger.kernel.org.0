Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815052FC06D
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 20:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389940AbhASTys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 14:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729966AbhASTun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 14:50:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB04AC061574
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 11:50:02 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l1x0r-00004s-6z; Tue, 19 Jan 2021 20:50:01 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l1x0q-0000Wp-2l; Tue, 19 Jan 2021 20:50:00 +0100
Date:   Tue, 19 Jan 2021 20:49:59 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        julietk@linux.vnet.ibm.com, mpe@ellerman.id.au, paulus@samba.org,
        kernel@pengutronix.de, benh@kernel.crashing.org, drt@linux.ibm.com,
        kuba@kernel.org, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
Subject: Re: [PATCH net RFC] ibmvnic: device remove has higher precedence
 over reset
Message-ID: <20210119194959.a67nlfbngx4drvyz@pengutronix.de>
References: <20210119193313.43791-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ifdlur3z3zt3xfst"
Content-Disposition: inline
In-Reply-To: <20210119193313.43791-1-ljp@linux.ibm.com>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ifdlur3z3zt3xfst
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 19, 2021 at 01:33:13PM -0600, Lijun Pan wrote:
> Returning -EBUSY in ibmvnic_remove() does not actually hold the
> removal procedure since driver core doesn't care for the return
> value (see __device_release_driver() in drivers/base/dd.c
> calling dev->bus->remove()) though vio_bus_remove
> (in arch/powerpc/platforms/pseries/vio.c) records the
> return value and passes it on. [1]
>=20
> During the device removal precedure, we should not schedule
> any new reset, and rely on the flush_work and flush_delayed_work
> to complete the pending resets, and specifically we need to
> let __ibmvnic_reset() keep running while in REMOVING state since
> flush_work and flush_delayed_work shall call __ibmvnic_reset finally.
>=20
> [1] https://lore.kernel.org/linuxppc-dev/20210117101242.dpwayq6wdgfdzirl@=
pengutronix.de/T/#m48f5befd96bc9842ece2a3ad14f4c27747206a53
> Reported-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during device=
 reset")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ib=
m/ibmvnic.c
> index aed985e08e8a..11f28fd03057 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2235,8 +2235,7 @@ static void __ibmvnic_reset(struct work_struct *wor=
k)
>  	while (rwi) {
>  		spin_lock_irqsave(&adapter->state_lock, flags);
> =20
> -		if (adapter->state =3D=3D VNIC_REMOVING ||
> -		    adapter->state =3D=3D VNIC_REMOVED) {
> +		if (adapter->state =3D=3D VNIC_REMOVED) {

I think you need to keep the check for VNIC_REMOVING. Otherwise you
don't prevent that a new reset being queued after ibmvnic_remove() set
the state to VNIC_REMOVING. Am I missing something?

>  			spin_unlock_irqrestore(&adapter->state_lock, flags);
>  			kfree(rwi);
>  			rc =3D EBUSY;
> @@ -5372,11 +5371,6 @@ static int ibmvnic_remove(struct vio_dev *dev)
>  	unsigned long flags;
> =20
>  	spin_lock_irqsave(&adapter->state_lock, flags);
> -	if (test_bit(0, &adapter->resetting)) {
> -		spin_unlock_irqrestore(&adapter->state_lock, flags);
> -		return -EBUSY;
> -	}
> -
>  	adapter->state =3D VNIC_REMOVING;
>  	spin_unlock_irqrestore(&adapter->state_lock, flags);

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--ifdlur3z3zt3xfst
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmAHN+UACgkQwfwUeK3K
7An/jwf/bC16CArScNyPsAO++IqJQ++XUuvOLoHeIeyOHln+dF0H5pXXO9YhQZJQ
OpQfjv4j3TBBzNofJvc/qtmJbuLrpIySTXK/OEgsBAV9VpoD/xr4c+Q5YP9zxIg6
Ehz/fuQ8Fw2U0vGJFnqlfi+vq0NsiSW4XIDVvtCLpbfTEJ8M9o9d91aTZxO+4CPk
Ep4JHLe9dSfd6FRIzCaBQtnqca5IihXdUor8INDWkWhSAe+vJvhWtK0KGffr0lrd
+4Fp2/1vPmj1yl+fkwMZZAOs4jtAJCw77HlV3PgHOE/nrRHYvAQk0ISX5QTBktcH
ZyCcmi+PUx6ZJUd/RJn1YQlpmKAjbw==
=7T34
-----END PGP SIGNATURE-----

--ifdlur3z3zt3xfst--
