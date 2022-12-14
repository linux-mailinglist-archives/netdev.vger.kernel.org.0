Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0818164C5C7
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 10:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiLNJWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 04:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbiLNJWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 04:22:16 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B594DDF74
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 01:22:15 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p5Nxq-0001Ou-PI; Wed, 14 Dec 2022 10:22:10 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:631f:86da:f36:1a4c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3C8A013E868;
        Wed, 14 Dec 2022 09:22:10 +0000 (UTC)
Date:   Wed, 14 Dec 2022 10:22:01 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221214092201.xpb3rnwp5rtvrpkr@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
 <20221214091406.g6vim5hvlkm34naf@blmsp>
 <20221214091820.geugui5ws3f7a5ng@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mb3cumlh6u4t4dqq"
Content-Disposition: inline
In-Reply-To: <20221214091820.geugui5ws3f7a5ng@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mb3cumlh6u4t4dqq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.12.2022 10:18:20, Marc Kleine-Budde wrote:
> On 14.12.2022 10:14:06, Markus Schneider-Pargmann wrote:
> > Hi Marc,
> >=20
> > On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > > Currently the driver waits to wakeup the queue until the interrupt =
for
> > > > the transmit event is received and acknowledged. If we want to use =
the
> > > > hardware FIFO, this is too late.
> > > >=20
> > > > Instead release the queue as soon as the transmit was transferred i=
nto
> > > > the hardware FIFO. We are then ready for the next transmit to be
> > > > transferred.
> > >=20
> > > If you want to really speed up the TX path, remove the worker and use
> > > the spi_async() API from the xmit callback, see mcp251xfd_start_xmit(=
).
> > >=20
> > > Extra bonus if you implement xmit_more() and transfer more than 1 skb
> > > per SPI transfer.
> >=20
> > Just a quick question here, I mplemented a xmit_more() call and I am
> > testing it right now, but it always returns false even under high
> > pressure. The device has a txqueuelen set to 1000. Do I need to turn
> > some other knob for this to work?
>=20
> AFAIK you need BQL support: see 0084e298acfe ("can: mcp251xfd: add BQL su=
pport").
>=20
> The etas_es58x driver implements xmit_more(), I added the Author Vincent
> on Cc.

Have a look at netdev_queue_set_dql_min_limit() in the etas driver.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mb3cumlh6u4t4dqq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOZlbUACgkQrX5LkNig
010hogf8Dtw6F/XMcPdIU3znxnOJT90kJifuvcxd4vt4SWiciELuvqiD8pdiUvjD
X3mAUSF3wZkbV6dKPo3IDJFrkjx93TmDCTLfeaSIpTIg5R2z2aAgYqWQ1nkFZRAO
8wKUlI7cQ8S4Y5siIffgVrfZCLJ77e1eG1j9sHHFmRnQ5P6NdU9sGxIfk3hRjRtM
Y+sCG/qVhT/4kISamLJulj11DdgBE33N6WILn/jvB8IDBilYmXK2mIeQVznBPx2h
9Q7S4soFbuia0sDDFkCmI4dyORiE0/yynonlLAOQlq2PbAKRsFWle2D7jd0qG5ps
+qsmf+R9oOmY35eTSLeFHsDz4zHMuA==
=32O4
-----END PGP SIGNATURE-----

--mb3cumlh6u4t4dqq--
