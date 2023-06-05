Return-Path: <netdev+bounces-7865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9F5721E42
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47AD91C20AAE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131AF138C;
	Mon,  5 Jun 2023 06:38:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A17382
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:38:00 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08E3DA
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:37:59 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q63qF-00043K-DJ; Mon, 05 Jun 2023 08:37:23 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 5E1B51D2073;
	Mon,  5 Jun 2023 06:37:17 +0000 (UTC)
Date: Mon, 5 Jun 2023 08:37:16 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
	Robin van der Gracht <robin@protonic.nl>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 0/2] can: j1939: avoid possible use-after-free when
 j1939_can_rx_register fails
Message-ID: <20230605-extras-liftoff-ccf0e4c92335-mkl@pengutronix.de>
References: <20230526171910.227615-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qfzt5qhgkbk447j7"
Content-Disposition: inline
In-Reply-To: <20230526171910.227615-1-pchelkin@ispras.ru>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--qfzt5qhgkbk447j7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.05.2023 20:19:08, Fedor Pchelkin wrote:
> The patch series fixes a possible racy use-after-free scenario described
> in 2/2: if j1939_can_rx_register() fails then the concurrent thread may
> have already read the invalid priv structure.
>
> The 1/2 makes j1939_netdev_lock a mutex so that access to
> j1939_can_rx_register() can be serialized without changing GFP_KERNEL to
> GFP_ATOMIC inside can_rx_register(). This seems to be safe.
>
> Note that the patch series has been tested only via Syzkaller and not with
> a real device.

Applied to linux-can + adding stable on Cc.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--qfzt5qhgkbk447j7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmR9gpoACgkQvlAcSiqK
BOia1QgAhIj1/4OuiSj/sZFfiYVe2ixv9bFwMNCr3gEDO3xzjgoj1Q3xK9QwSes4
+5+qz5R7RzaKXxYbcnhqtFKy5oAH7ioZIzgLpYkiR3OMBa4Bboqg1iB4mWq4eQ6M
BoxHqr2PFUt7fZNKp+k0ucu3KDvPX2js6aoMeQhZ6XpRYB59lEK9HHMdsPBNNGoC
dlOvEWfZH75Cd6AS3ClUX+aaocETje1wx5xBcmGY/Jj79w3QBXDlakPXp24yNmhz
Q/iJR8mAd0jvNNZeu5s9MOsbolKAh2U4ffRvGNfyTWV/O72C8xhQnoyR32iY3Xiv
zuvJFYNNhFYpc8xmaelwUt31yF7HQw==
=vpgs
-----END PGP SIGNATURE-----

--qfzt5qhgkbk447j7--

