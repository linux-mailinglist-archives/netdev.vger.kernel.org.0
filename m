Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47FC548077
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 09:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbiFMHRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 03:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbiFMHRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 03:17:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB201A06B
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 00:17:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o0eKC-00041a-Sm; Mon, 13 Jun 2022 09:17:24 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EDEF5938D8;
        Mon, 13 Jun 2022 07:17:22 +0000 (UTC)
Date:   Mon, 13 Jun 2022 09:17:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 07/13] can: slcan: set bitrate by CAN device driver API
Message-ID: <20220613071722.agougqdrxpwjk2ox@pengutronix.de>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
 <20220612213927.3004444-8-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qztqhaetrzuoaczy"
Content-Disposition: inline
In-Reply-To: <20220612213927.3004444-8-dario.binacchi@amarulasolutions.com>
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


--qztqhaetrzuoaczy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.06.2022 23:39:21, Dario Binacchi wrote:
> It allows to set the bitrate via ip tool, as it happens for the other
> CAN device drivers. It still remains possible to set the bitrate via
> slcand or slcan_attach utilities. In case the ip tool is used, the
> driver will send the serial command to the adapter.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>=20
> ---
>=20
> Changes in v3:
> - Remove the slc_do_set_bittiming().
> - Set the bitrate in the ndo_open().
> - Replace -1UL with -1U in setting a fake value for the bitrate.
>=20
> Changes in v2:
> - Use the CAN framework support for setting fixed bit rates.
>=20
>  drivers/net/can/slcan.c | 39 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 4639a63c3af8..be3f7e5c685b 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -105,6 +105,11 @@ struct slcan {
>  static struct net_device **slcan_devs;
>  static DEFINE_SPINLOCK(slcan_lock);
> =20
> +static const u32 slcan_bitrate_const[] =3D {
> +	10000, 20000, 50000, 100000, 125000,
> +	250000, 500000, 800000, 1000000
> +};
> +
>   /**********************************************************************=
**
>    *			SLCAN ENCAPSULATION FORMAT			 *
>    **********************************************************************=
**/
> @@ -440,6 +445,7 @@ static int slc_close(struct net_device *dev)
>  	netif_stop_queue(dev);
>  	close_candev(dev);
>  	sl->can.state =3D CAN_STATE_STOPPED;
> +	sl->can.bittiming.bitrate =3D 0;

If the bitrate is configured, please keep that value.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qztqhaetrzuoaczy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKm5H8ACgkQrX5LkNig
011Txgf/Z+krb/OgFsK0a5I9hXIEgAOooMeXJd1CEXtskwHF9fVY59+JxpG7gE1o
Y6fc+rRJKEFCitOsa+Y65LmQirJKhHFf9kXj3RFS5THLT9XLh64q+d9xRvQ2kgik
YfjRtFoLGCXgBvJavzKuclVLoIgn3ptf82q31sawHHMbanZDJB3ZzRgwWcHnsD60
KJVRWAnrdXrpS+scLst0WL2PFIPkdpOayxD9BhsfqMdSXwzdgptApZlUBINwCVPT
pv1HH8FI1t7JvMF70U6kUYQ7tEysoPffnWO/LM0OdC6eOeai/Knt4mBQJViKDXiG
H0j1P9D++18cYSg8D0DexqVT1LbGwQ==
=MkiP
-----END PGP SIGNATURE-----

--qztqhaetrzuoaczy--
