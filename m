Return-Path: <netdev+bounces-12227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB0A736D4F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:27:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48E582811DC
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C186156F0;
	Tue, 20 Jun 2023 13:27:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF9A156E6
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:27:24 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8D0B4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:27:20 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1qBbO0-0001kM-Kn; Tue, 20 Jun 2023 15:27:08 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 125FB1DDB46;
	Tue, 20 Jun 2023 13:27:07 +0000 (UTC)
Date: Tue, 20 Jun 2023 15:27:06 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Sylvain Girard <sylvain.girard@se.com>,
	Pascal Eberhard <pascal.eberhard@se.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Herve Codina <herve.codina@bootlin.com>,
	=?utf-8?B?SsOpcsOpbWll?= Dautheribes <jeremie.dautheribes@bootlin.com>
Subject: Re: [PATCH net-next 1/2] can: sja1000: Prepare the use of a threaded
 handler
Message-ID: <20230620-unicycle-wifi-fbc8d73e51fb-mkl@pengutronix.de>
References: <20230616134553.2786391-1-miquel.raynal@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="twvrtwtwm6ooxttw"
Content-Disposition: inline
In-Reply-To: <20230616134553.2786391-1-miquel.raynal@bootlin.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--twvrtwtwm6ooxttw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.06.2023 15:45:52, Miquel Raynal wrote:
> In order to support a flavor of the sja1000 which sometimes freezes, it
> will be needed upon certain interrupts to perform a soft reset. The soft
> reset operation takes a bit of time, so better not do it within the hard
> interrupt handler but rather in a threaded handler. Let's prepare the
> possibility for sja1000_err() to request "interrupting" the current flow
> and request the threaded handler to be run while keeping the interrupt
> line low.
>=20
> There is no functional change.

Applied both to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--twvrtwtwm6ooxttw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmSRqScACgkQvlAcSiqK
BOixTQf/ZM+1W1w4QwaNlbaDdf6BotsAN1/sdJzb+iBdzdsp74JSePsBsOue9OGi
pe/xto0QMzqd8Xed0Y1OYH52XJfRoCrEHWd/hQJT09SpX2tnvvG2FpH9n6F8LWdY
AM54VixYtEipWEg+f7l1gnCqfKudzfaflu5XsRunAfpGKRXJNBKUnKgUZcRe36F9
3gLyRqBcqDjRrKedzTdUHQ9orlFmUVxFr+WIGvQX6W7R5Z6nC+FAZj1gQlsNyLR4
qnP+c8c7obcKhSy54DSTIC2psrO4oR7NVdnfkVXDxlLeC3eXdk2ODMpv1VyWOAUS
zbSHzhshoLh7E0rHCrJkvB46sAWIew==
=95zw
-----END PGP SIGNATURE-----

--twvrtwtwm6ooxttw--

