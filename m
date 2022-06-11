Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A705547617
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 17:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbiFKPXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 11:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbiFKPXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 11:23:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DBC222B9
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 08:23:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o02x8-0000FO-7V; Sat, 11 Jun 2022 17:23:06 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 07D6492EBF;
        Sat, 11 Jun 2022 15:23:02 +0000 (UTC)
Date:   Sat, 11 Jun 2022 17:23:02 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: phy: dp83td510: disable cable test
 support for 1Vpp PHYs
Message-ID: <20220611152302.fw76ws75olzcwasp@pengutronix.de>
References: <20220608123236.792405-1-o.rempel@pengutronix.de>
 <20220608123236.792405-4-o.rempel@pengutronix.de>
 <YqSxtvZUEmaxmihV@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oh2oxnswzfmcsdq3"
Content-Disposition: inline
In-Reply-To: <YqSxtvZUEmaxmihV@lunn.ch>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oh2oxnswzfmcsdq3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.06.2022 17:16:06, Andrew Lunn wrote:
> >  static int dp83td510_cable_test_start(struct phy_device *phydev)
> >  {
> > -	int ret;
> > +	struct dp83td510_priv *priv =3D phydev->priv;
> > +	int ret, cfg =3D 0;
> > +
> > +	/* Generate 2.4Vpp pulse if HW is allowed to do so */
> > +	if (priv->allow_v2_4_mode) {
> > +		cfg |=3D DP83TD510E_TDR_TX_TYPE;
> > +	} else {
> > +		/* This PHY do not provide usable results with 1Vpp pulse.
>=20
> s/do/does
>=20
>=20
> > +		 * Potentially different dp83td510_tdr_init() values are
> > +		 * needed.
> > +		 */
> > +		return -EOPNOTSUPP;
> > +	}
>=20
> I don't remember the details for v2.4. Is it possible to change up
> from 1v to 2.4v for the duration of the cable test? Is there a danger
> to damage the link peer? I guess not, since you need to pass EMC
> testing which zaps it with 100Kv or something. So is this more a local
> supply issue?

In some industrial areas (e.g. ATEX (explosion protection)) 2.4V is not
allowed due to regulations. If the PHY is strapped to 1.0V we assume for
now this has a good reason and don't crank up the voltage :)

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--oh2oxnswzfmcsdq3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKks1MACgkQrX5LkNig
011eugf+PjsR7mtKLNTUA0tdq9/3obqmNjr/cGsx9jYZ8YSzcBWZXOEZ3YkNbopa
9SwfmMpXqvbSFXOBMt0N0pV+LJEikamhOlJLxMyL+/UhRiO/zRuX5IGHKwm/k1Cv
B/rxUS6r+9cmFNu0splGcsP9U5K6RCko9ByxU4GL8P5TUwFxxro8MVNVTzuhxTVI
hA8ooncenDJsYQ4Gk/LBtGsp6VemGf3DJLD2lCX1HfeMyBB7PhvyjJc/ov92dcC2
3t0YaBiOumHr1vQOcFGAGS2XxSieeoCRBnNw/5CpQZyhPCXK7303ieCA8s6YeTAS
WXhsL4dPcNAZfB84E1mEKwkLLeXDIw==
=VE56
-----END PGP SIGNATURE-----

--oh2oxnswzfmcsdq3--
