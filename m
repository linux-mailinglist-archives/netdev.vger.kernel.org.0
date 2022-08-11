Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFCE58FA3A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiHKJnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbiHKJnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:43:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEDC81698
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 02:43:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oM4ix-0004BG-Ty; Thu, 11 Aug 2022 11:43:31 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1ACD2C7587;
        Thu, 11 Aug 2022 09:43:31 +0000 (UTC)
Date:   Thu, 11 Aug 2022 11:43:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] can: rx-offload: Break loop on queue full
Message-ID: <20220811094329.hgkgeydboswlfwvr@pengutronix.de>
References: <20220810144536.389237-1-u.kleine-koenig@pengutronix.de>
 <20220811083039.xi4fkj2cl4k22wm7@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zllfu5hp6pdxzqpm"
Content-Disposition: inline
In-Reply-To: <20220811083039.xi4fkj2cl4k22wm7@pengutronix.de>
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


--zllfu5hp6pdxzqpm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.08.2022 10:30:39, Marc Kleine-Budde wrote:
> On 10.08.2022 16:45:36, Uwe Kleine-K=C3=B6nig wrote:
> > The following happend on an i.MX25 using flexcan with many packets on
> > the bus:
> >=20
> > The rx-offload queue reached a length more than skb_queue_len_max. So in
> > can_rx_offload_offload_one() the drop variable was set to true which
> > made the call to .mailbox_read() (here: flexcan_mailbox_read()) just
> > return ERR_PTR(-ENOBUFS) (plus some irrelevant hardware interaction) and
> > so can_rx_offload_offload_one() returned ERR_PTR(-ENOBUFS), too.
> >=20
> > Now can_rx_offload_irq_offload_fifo() looks as follows:
> >=20
> > 	while (1) {
> > 		skb =3D can_rx_offload_offload_one(offload, 0);
> > 		if (IS_ERR(skb))
> > 			continue;
> > 		...
> > 	}
> >=20
> > As the i.MX25 is a single core CPU while the rx-offload processing is
> > active there is no thread to process packets from the offload queue and
> > so it doesn't get shorter.
> >=20
> > The result is a tight loop: can_rx_offload_offload_one() does nothing
> > relevant and returns an error code and so
> > can_rx_offload_irq_offload_fifo() calls can_rx_offload_offload_one()
> > again.
> >=20
> > To break that loop don't continue calling can_rx_offload_offload_one()
> > after it reported an error.
> >=20
> > Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >=20
> > this patch just implements the obvious change to break the loop. I'm not
> > 100% certain that there is no corner case where the break is wrong. The
> > problem exists at least since v5.6, didn't go back further to check.
> >=20
> > This fixes a hard hang on said i.MX25.
>=20
> As Uwe suggested in an IRC conversation, the correct fix for the flexcan
> driver is to return NULL if there is no CAN frame pending.
>=20
> I'll send a -v2.

https://lore.kernel.org/all/20220811094254.1864367-1-mkl@pengutronix.de

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zllfu5hp6pdxzqpm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmL0zz8ACgkQrX5LkNig
011+Xwf/X4VsSsn3CgA4sPOsk5lCd1TSocL6rIW/b44B/giltDfJ7zaIJGndd9sz
qSiOcNLsxKm9JTp+m9YPlBqeszH7PQ3EDce7jey9nFZW+dp8QvAYwdoGTYHpU3YA
MDXjjCj4CqamYqiR8cK+A6pex5HJAdyEYOeET8gy6eiDiy+hoh6WE90qBH9C6Blc
tJLbNhL5q8kDopXxhGCSa37BMqVGkbFzql5oXFBmLem8U5CIMAwxHYtcNKBWffOV
tqOA15FqJdbCom5jNS+SwuImCWIPG1c+kzKRQq/8KGt9LPWpEsZqGjTNq4pcA3KC
PqCclvArr7RT5UBuPMuOat7ZBUaprQ==
=OTv0
-----END PGP SIGNATURE-----

--zllfu5hp6pdxzqpm--
