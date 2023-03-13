Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B59A6B7D57
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjCMQWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCMQWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:22:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634275D8A8
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:22:21 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbkwF-0007fb-Mb; Mon, 13 Mar 2023 17:22:19 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbkwE-003tEL-9Q; Mon, 13 Mar 2023 17:22:18 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbkwD-004bBN-6B; Mon, 13 Mar 2023 17:22:17 +0100
Date:   Mon, 13 Mar 2023 17:21:41 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Clark Wang <xiaoning.wang@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Wei Fang <wei.fang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/9] net: fec: Don't return early on error in
 .remove()
Message-ID: <20230313162141.vkhyz77u44wxq4vn@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
 <20230313103653.2753139-3-u.kleine-koenig@pengutronix.de>
 <e84585f2-e3d9-4a87-bfd4-a9ba458553b9@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zjshe2mvnzhq3324"
Content-Disposition: inline
In-Reply-To: <e84585f2-e3d9-4a87-bfd4-a9ba458553b9@lunn.ch>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zjshe2mvnzhq3324
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Andrew,

On Mon, Mar 13, 2023 at 04:07:12PM +0100, Andrew Lunn wrote:
> On Mon, Mar 13, 2023 at 11:36:46AM +0100, Uwe Kleine-K=F6nig wrote:
> > If waking up the device in .remove() fails, exiting early results in
> > strange state: The platform device will be unbound but not all resources
> > are freed. E.g. the network device continues to exist without an parent.
> >=20
> > Instead of an early error return, only skip the cleanup that was already
> > done by suspend and release the remaining resources.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/et=
hernet/freescale/fec_main.c
> > index c73e25f8995e..31d1dc5e9196 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -4465,15 +4465,13 @@ fec_drv_remove(struct platform_device *pdev)
> >  	struct device_node *np =3D pdev->dev.of_node;
> >  	int ret;
> > =20
> > -	ret =3D pm_runtime_resume_and_get(&pdev->dev);
> > -	if (ret < 0)
> > -		return ret;
> > +	ret =3D pm_runtime_get_sync(&pdev->dev);
> > =20
> >  	cancel_work_sync(&fep->tx_timeout_work);
> >  	fec_ptp_stop(pdev);
> >  	unregister_netdev(ndev);
> >  	fec_enet_mii_remove(fep);
> > -	if (fep->reg_phy)
> > +	if (ret >=3D 0 && fep->reg_phy)
> >  		regulator_disable(fep->reg_phy);
> > =20
> >  	if (of_phy_is_fixed_link(np))
>=20
> I'm not sure this is correct. My experience with the FEC is that if
> the device is run time suspended, access to the hardware does not
> work. In the case i was debugging, MDIO bus reads/writes time out. I
> think IO reads and writes turn into NOPs, but i don't actually know.
>=20
> So if pm_runtime_resume_and_get() fails, fec_ptp_stop() probably does
> not work if it touches the hardware.

While creating the patch I checked, and just from looking at the code
I'd say it doesn't access hardware.

> I guess fec_enet_mii_remove()
> unregisters any PHYs, which could cause MDIO bus access to shut down
> the PHYs, so i expect that also does not work.

fec_enet_mii_remove only calls mdiobus_unregister + mdiobus_free which
should be software only?!

> regulator_disable() probably does actually work because that is a
> different hardware block unaffected by the suspend.

fec_suspend() calls

        if (fep->reg_phy && !(fep->wol_flag & FEC_WOL_FLAG_ENABLE))
                regulator_disable(fep->reg_phy);

and if resume failed I have to assume that fec_resume() didn't come
around reenabling it. So not disabling the regulator in .remove() is
correct.

> So i think you need to decide:
>=20
> exit immediately if resume fails, leaving dangling PHYs, netdev,
> regulator etc

I think keeping netdev is very prone to surprises. You'd still have eth0
(or however your device is called), it might even work somewhat, or it
might oops because devm_platform_ioremap_resource is undone.
=20
> Keep going, but maybe everything is going to grind to a halt soon
> afterwards when accessing the hardware.
>=20
> You seem to prefer keep going, so i would also suggest you disable the
> regulator.

(Described above why I didn't.)

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--zjshe2mvnzhq3324
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmQPTZIACgkQwfwUeK3K
7Alz6QgAl8vh7FKc3J645vNRUfHP2upb3L3pnf89LyMMN8FVLakrXIDCWoQLaX+k
AhW2tnw4Sv+ci8SpfkYUos6BR8WIXHtjMk5DchhvHqmsee+bcdo5H5KCqJbuByyl
MzHP5WFNQRd/ZMaYaQL/2jR/bQ/JuQ3VWClnPT1MGjfh662wPIZDG2Tqb6ToaAnJ
PBIEQIDrxz0R7VBM3d0fZGGdz5lJVCtYQErDMJ8j2xWup04mURoW0hHLbN1feEwM
Ga6X/5xILMe+3ewLYF2/p5fpZwgfCC+ApQcnTh+J/hI40QVlj0bdzx4DTHaUzGxt
/Gshdo4KR/ZtjfPBWBQ9WDnX0s/HjQ==
=Prsc
-----END PGP SIGNATURE-----

--zjshe2mvnzhq3324--
