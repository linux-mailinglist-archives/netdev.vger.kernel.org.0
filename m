Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF65638DF0
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiKYP5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKYP5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:57:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4974385A
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:57:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyb4Q-0000OU-5K; Fri, 25 Nov 2022 16:56:54 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:339c:bb17:19c8:3a96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1D5DF129D48;
        Fri, 25 Nov 2022 15:56:53 +0000 (UTC)
Date:   Fri, 25 Nov 2022 16:56:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] can: esd_usb: Allow REC and TEC to return to
 zero
Message-ID: <20221125155651.ilwfs64mtzcn2zvi@pengutronix.de>
References: <20221124203806.3034897-1-frank.jungclaus@esd.eu>
 <20221124203806.3034897-2-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="33cwzs42srezyfdd"
Content-Disposition: inline
In-Reply-To: <20221124203806.3034897-2-frank.jungclaus@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--33cwzs42srezyfdd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.11.2022 21:38:06, Frank Jungclaus wrote:
> We don't get any further EVENT from an esd CAN USB device for changes
> on REC or TEC while those counters converge to 0 (with ecc =3D=3D 0).
> So when handling the "Back to Error Active"-event force
> txerr =3D rxerr =3D 0, otherwise the berr-counters might stay on
> values like 95 forever ...
>=20
> Also, to make life easier during the ongoing development a
> netdev_dbg() has been introduced to allow dumping error events send by
> an esd CAN USB device.
>=20
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>

Please add a Fixes tag.

https://elixir.bootlin.com/linux/v6.0/source/Documentation/process/handling=
-regressions.rst#L107

> ---
>  drivers/net/can/usb/esd_usb.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index 1bcfad11b1e4..da24c649aadd 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -230,10 +230,14 @@ static void esd_usb_rx_event(struct esd_usb_net_pri=
v *priv,
> =20
>  	if (id =3D=3D ESD_EV_CAN_ERROR_EXT) {
>  		u8 state =3D msg->msg.rx.data[0];
> -		u8 ecc =3D msg->msg.rx.data[1];
> +		u8 ecc   =3D msg->msg.rx.data[1];

unrelated, please remove.

>  		u8 rxerr =3D msg->msg.rx.data[2];
>  		u8 txerr =3D msg->msg.rx.data[3];
> =20
> +		netdev_dbg(priv->netdev,
> +			   "CAN_ERR_EV_EXT: dlc=3D%#02x state=3D%02x ecc=3D%02x rec=3D%02x te=
c=3D%02x\n",
> +			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
> +
>  		skb =3D alloc_can_err_skb(priv->netdev, &cf);
>  		if (skb =3D=3D NULL) {
>  			stats->rx_dropped++;
> @@ -260,6 +264,8 @@ static void esd_usb_rx_event(struct esd_usb_net_priv =
*priv,
>  				break;
>  			default:
>  				priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> +				txerr =3D 0;
> +				rxerr =3D 0;
>  				break;
>  			}
>  		} else {

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--33cwzs42srezyfdd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOA5cAACgkQrX5LkNig
010adAf+JqrrWFgc6phKSI+7QqpLsN9JB9bQCPb4OjM0XSmjgo3CC3Oga+K0G/Uw
dNzFtDVX98O1Z49SOPQKIh5Bo5e25POxaFJlGpWTWzoXsZUZqSX+0jZJ4KBeuhLQ
AkjbwB+Ddb8xlj0yC18WvfHlMnIIxnR1okCeGxtr779XP3okg9W0BbK2jC/GIzlN
HynmYfjCOTGfHBroUUB4HETnh5zzXqZtPrJt150U4IwuN3e63NfWeFyQcYapL5L8
0W1sYADZ8mDVE8zYgcxNNLITZj0rlK8IKSYtvKUo4kE/ROZRDrLeaajYg9oxhXRS
VYj5lAYHJbK0tXLxZeQP4pXG42HRIA==
=rXgd
-----END PGP SIGNATURE-----

--33cwzs42srezyfdd--
