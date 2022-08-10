Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3350B58E7BD
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiHJHTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiHJHTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:19:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AA884EC9
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 00:19:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oLfzz-0004PJ-Jn; Wed, 10 Aug 2022 09:19:27 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6EEB8C65A9;
        Wed, 10 Aug 2022 07:19:26 +0000 (UTC)
Date:   Wed, 10 Aug 2022 09:19:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Sebastian =?utf-8?B?V8O8cmw=?= <sebastian.wuerl@ororatech.com>
Subject: Re: [PATCH net 4/4] can: mcp251x: Fix race condition on receive
 interrupt
Message-ID: <20220810071924.z3fbou2wbg6s7jjl@pengutronix.de>
References: <20220809075317.1549323-1-mkl@pengutronix.de>
 <20220809075317.1549323-5-mkl@pengutronix.de>
 <20220809115016.1db564b3@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5m3gw4gol5kj2loq"
Content-Disposition: inline
In-Reply-To: <20220809115016.1db564b3@kernel.org>
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


--5m3gw4gol5kj2loq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.08.2022 11:50:16, Jakub Kicinski wrote:
> On Tue,  9 Aug 2022 09:53:17 +0200 Marc Kleine-Budde wrote:
> > @@ -1082,6 +1079,18 @@ static irqreturn_t mcp251x_can_ist(int irq, void=
 *dev_id)
> >  			if (mcp251x_is_2510(spi))
> >  				mcp251x_write_bits(spi, CANINTF,
> >  						   CANINTF_RX0IF, 0x00);
> > +
> > +			/* check if buffer 1 is already known to be full, no need to re-rea=
d */
> > +			if (!(intf & CANINTF_RX1IF)) {
> > +				u8 intf1, eflag1;
> > +			=09
>=20
> This line is full of trailing whitespace, could you add a fix on top to
> remove it and resend?

Doh! It was me moving both variables there to reduce their scope and
somehow the whitespace slipped in. Here's an updated PR:

https://lore.kernel.org/all/20220810071448.1627857-1-mkl@pengutronix.de/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5m3gw4gol5kj2loq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLzW/kACgkQrX5LkNig
012WzQf7BfVypr61XIbVCgZtPBv2yuXfOP/35jLumTUFabf5R8wg8f/ixjfwyh0Y
M3DPSe3gEsdEcb34yewWngMUnSiIMhJk3sCreb0auXXnuQ7rbNMWpn0VsSrX0jFf
4qlM9jYfxZG2tsCh/XnVpJ1ssj9i+Slob5UEodYcxn8IhaKv6L+cXR15huGkR47b
NxoMJIJFVqdoDkxy3quLqcdT5f9eoPonSUFAyh1M8aV570sHVJh8MnnpM6eMbnmf
mRgLSJ9Z1v2me5dIENyaCgFL04vW5LABlAx0Q8lpsw2uOWX3BGhrUcZKLIg2Fsjk
G48kWPz+sBqR5IBQawfvUOsf/0cqWw==
=NS4m
-----END PGP SIGNATURE-----

--5m3gw4gol5kj2loq--
