Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BB558F918
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiHKIar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiHKIaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:30:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87513137B
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:30:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oM3aU-0002Wy-0c; Thu, 11 Aug 2022 10:30:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3A669C747A;
        Thu, 11 Aug 2022 08:30:41 +0000 (UTC)
Date:   Thu, 11 Aug 2022 10:30:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] can: rx-offload: Break loop on queue full
Message-ID: <20220811083039.xi4fkj2cl4k22wm7@pengutronix.de>
References: <20220810144536.389237-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="s6ozykicaunnl2sy"
Content-Disposition: inline
In-Reply-To: <20220810144536.389237-1-u.kleine-koenig@pengutronix.de>
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


--s6ozykicaunnl2sy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.08.2022 16:45:36, Uwe Kleine-K=C3=B6nig wrote:
> The following happend on an i.MX25 using flexcan with many packets on
> the bus:
>=20
> The rx-offload queue reached a length more than skb_queue_len_max. So in
> can_rx_offload_offload_one() the drop variable was set to true which
> made the call to .mailbox_read() (here: flexcan_mailbox_read()) just
> return ERR_PTR(-ENOBUFS) (plus some irrelevant hardware interaction) and
> so can_rx_offload_offload_one() returned ERR_PTR(-ENOBUFS), too.
>=20
> Now can_rx_offload_irq_offload_fifo() looks as follows:
>=20
> 	while (1) {
> 		skb =3D can_rx_offload_offload_one(offload, 0);
> 		if (IS_ERR(skb))
> 			continue;
> 		...
> 	}
>=20
> As the i.MX25 is a single core CPU while the rx-offload processing is
> active there is no thread to process packets from the offload queue and
> so it doesn't get shorter.
>=20
> The result is a tight loop: can_rx_offload_offload_one() does nothing
> relevant and returns an error code and so
> can_rx_offload_irq_offload_fifo() calls can_rx_offload_offload_one()
> again.
>=20
> To break that loop don't continue calling can_rx_offload_offload_one()
> after it reported an error.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>=20
> this patch just implements the obvious change to break the loop. I'm not
> 100% certain that there is no corner case where the break is wrong. The
> problem exists at least since v5.6, didn't go back further to check.
>=20
> This fixes a hard hang on said i.MX25.

As Uwe suggested in an IRC conversation, the correct fix for the flexcan
driver is to return NULL if there is no CAN frame pending.

I'll send a -v2.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--s6ozykicaunnl2sy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmL0viwACgkQrX5LkNig
012x7Qf/ZNMk/dsREbMdNeQBVsCyN6IvXErj6bykSFxTkigt8iz1j4l71DNPSnzr
b6S3zKnmMOrLUX0bl6N2YXDzJhdPTMs06gjg9yWriLLKjCy9qITiQ+kQIbgz5ZUf
lzi1Ta6Y9nAJoRZ6lsUSKkxbiXvG4dV5KUqLKHsIGWLvOonp1tjfcGbApw0GiJhO
83MPMlE6FUp3a+kS2W2yvELq0YBtK2wfwyAaVdpngFUmoX5shN4cC2/+kHl5xIi+
xm3W1gvdr0FGxDDd6g6b3ey8TscoIbyLYPQyULQu2Udk4M/mnBdLVndIHq8crYIN
gGjgYj1uwNqxz0ieH3cu8Iv6JMp1+A==
=lxhW
-----END PGP SIGNATURE-----

--s6ozykicaunnl2sy--
