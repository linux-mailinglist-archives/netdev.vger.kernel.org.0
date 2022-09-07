Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD1B5B0720
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 16:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiIGOj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 10:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiIGOja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 10:39:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EEEE84
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 07:39:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVwD0-0002Dt-BP; Wed, 07 Sep 2022 16:39:18 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:4f89:9809:42f0:f1dc])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A9262DC94A;
        Wed,  7 Sep 2022 14:39:15 +0000 (UTC)
Date:   Wed, 7 Sep 2022 16:39:15 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        kernel@pengutronix.de,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <20220907143915.5w65kainpykfobte@pengutronix.de>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
 <9f03470a-99a3-0f98-8057-bc07b0c869a5@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hkjhm4jys5dqhibu"
Content-Disposition: inline
In-Reply-To: <9f03470a-99a3-0f98-8057-bc07b0c869a5@pengutronix.de>
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


--hkjhm4jys5dqhibu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.09.2022 09:38:04, Marc Kleine-Budde wrote:
> On 9/1/22 4:04 PM, Cs=C3=B3k=C3=A1s Bence wrote:
> > Mutexes cannot be taken in a non-preemptible context,
> > causing a panic in `fec_ptp_save_state()`. Replacing
> > `ptp_clk_mutex` by `tmreg_lock` fixes this.
>=20
> I was on holidays, but this doesn't look good.

Does anyone care to fix this? Cs=C3=B3k=C3=A1s?

> > @@ -2036,15 +2037,15 @@ static int fec_enet_clk_enable(struct net_devic=
e *ndev, bool enable)
> >  			return ret;
> > =20
> >  		if (fep->clk_ptp) {
> > -			mutex_lock(&fep->ptp_clk_mutex);
> > +			spin_lock_irqsave(&fep->tmreg_lock, flags);
> >  			ret =3D clk_prepare_enable(fep->clk_ptp);
>=20
> clock_prepare() (and thus clk_prepare_enable()) must not be called from a=
tomic
> context.

You cannot call clk_prepare_enable() from atomic context. If you compile
your kernel with lockdep, you'll get this splat:

| [    5.907789] BUG: sleeping function called from invalid context at driv=
ers/net/ethernet/freescale/fec_main.c:2071
| [    5.918140] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1=
, name: swapper/0
| [    5.926181] preempt_count: 1, expected: 0                             =
                      =20
| [    5.930223] 2 locks held by swapper/0/1:                              =
                      =20
| [    5.934180]  #0: c41a4094 (&dev->mutex){....}-{4:4}, at: __driver_atta=
ch+0x8c/0x150
| [    5.941968]  #1: c42439b0 (&fep->tmreg_lock){....}-{3:3}, at: fec_enet=
_clk_enable+0x5c/0x25c
| [    5.950533] irq event stamp: 124698                                   =
                      =20
| [    5.954052] hardirqs last  enabled at (124697): [<c0f6c6dc>] _raw_spin=
_unlock_irqrestore+0x58/0x6c
| [    5.963058] hardirqs last disabled at (124698): [<c0f6c490>] _raw_spin=
_lock_irqsave+0x88/0xa4
| [    5.971622] softirqs last  enabled at (122454): [<c02b47bc>] bdi_regis=
ter_va+0x1ac/0x1d8                                                         =
                                           =20
| [    5.979753] softirqs last disabled at (122452): [<c02b4738>] bdi_regis=
ter_va+0x128/0x1d8

| $ head -2071 drivers/net/ethernet/freescale/fec_main.c | tail -15
|=20
| static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
| {
|         struct fec_enet_private *fep =3D netdev_priv(ndev);
|         unsigned long flags;
|         int ret;
|=20
|         if (enable) {
|                 ret =3D clk_prepare_enable(fep->clk_enet_out);
|                 if (ret)
|                         return ret;
|=20
|                 if (fep->clk_ptp) {
|                         spin_lock_irqsave(&fep->tmreg_lock, flags);
|                         ret =3D clk_prepare_enable(fep->clk_ptp);

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hkjhm4jys5dqhibu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMYrRAACgkQrX5LkNig
0109hQf/UvGZwLX/AKStRB0yVG6LKI4BqYLVWrfKgIeRulO1WTiT0Zc5f+jWLuuq
qSdNq5OhIPaPPmCibrqMgDRL0jZLv6YPdp0xk+Uji9YnEiLF8eQwOR7Y5dl1ub9P
8Btbts30LOuKGsl0PXjreKQQVPydYg8tYZECvtySda2LTg1rsaESE8aHDeO8N6f1
0RsIyQKtH96tVow5wbtMHndl/liZ/OfKatupA1Uf+sUppqqL7Dlix5Rw67lk9fke
ypZofmzkRUbUY1tSWSCgw6m7SYUaYut7GFmDzbhMXOQp1y2bzUbVs04KeVjpqH0d
7WHxkPi+1v1pBpl1nqKYkbtlaCj+kA==
=JR2X
-----END PGP SIGNATURE-----

--hkjhm4jys5dqhibu--
