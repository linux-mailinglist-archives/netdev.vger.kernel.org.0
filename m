Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC8254808D
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 09:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbiFMHcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 03:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbiFMHcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 03:32:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE6112D03
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 00:32:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o0eYV-00060s-4U; Mon, 13 Jun 2022 09:32:11 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DA39493918;
        Mon, 13 Jun 2022 07:32:08 +0000 (UTC)
Date:   Mon, 13 Jun 2022 09:32:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 12/13] can: slcan: extend the protocol with error info
Message-ID: <20220613073208.anak24kpffnngube@pengutronix.de>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
 <20220612213927.3004444-13-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hi4omindgk2aohao"
Content-Disposition: inline
In-Reply-To: <20220612213927.3004444-13-dario.binacchi@amarulasolutions.com>
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


--hi4omindgk2aohao
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.06.2022 23:39:26, Dario Binacchi wrote:
> It extends the protocol to receive the adapter CAN communication errors
> and forward them to the netdev upper levels.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>=20
> ---
>=20
> (no changes since v2)
>=20
> Changes in v2:
> - Protect decoding against the case the len value is longer than the
>   received data.

Where is that check?

> - Continue error handling even if no skb can be allocated.
>=20
>  drivers/net/can/slcan/slcan-core.c | 130 ++++++++++++++++++++++++++++-
>  1 file changed, 129 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/s=
lcan-core.c
> index 3df35ae8f040..48077edb9497 100644
> --- a/drivers/net/can/slcan/slcan-core.c
> +++ b/drivers/net/can/slcan/slcan-core.c
> @@ -175,8 +175,118 @@ int slcan_enable_err_rst_on_open(struct net_device =
*ndev, bool on)
>    *			STANDARD SLCAN DECAPSULATION			 *
>    **********************************************************************=
**/
> =20
> +static void slc_bump_err(struct slcan *sl)
> +{
> +	struct net_device *dev =3D sl->dev;
> +	struct sk_buff *skb;
> +	struct can_frame *cf;
> +	char *cmd =3D sl->rbuff;
> +	bool rx_errors =3D false, tx_errors =3D false;
> +	int i, len;
> +
> +	if (*cmd !=3D 'e')
> +		return;

This has already been checked in the caller, right?

> +
> +	cmd +=3D SLC_CMD_LEN;
> +	/* get len from sanitized ASCII value */
> +	len =3D *cmd++;
> +	if (len >=3D '0' && len < '9')
> +		len -=3D '0';
> +	else
> +		return;
> +
> +	skb =3D alloc_can_err_skb(dev, &cf);
> +
> +	if (skb)
> +		cf->can_id |=3D CAN_ERR_PROT | CAN_ERR_BUSERROR;
> +
> +	for (i =3D 0; i < len; i++, cmd++) {
> +		switch (*cmd) {
> +		case 'a':
> +			netdev_dbg(dev, "ACK error\n");
> +			tx_errors =3D true;

Nitpick:
Please decide if you want to set tx/tx_errors here and increment at the
end of the function....or.....

> +			if (skb) {
> +				cf->can_id |=3D CAN_ERR_ACK;
> +				cf->data[3] =3D CAN_ERR_PROT_LOC_ACK;
> +			}
> +
> +			break;
> +		case 'b':
> +			netdev_dbg(dev, "Bit0 error\n");
> +			tx_errors =3D true;
> +			if (skb)
> +				cf->data[2] |=3D CAN_ERR_PROT_BIT0;
> +
> +			break;
> +		case 'B':
> +			netdev_dbg(dev, "Bit1 error\n");
> +			tx_errors =3D true;
> +			if (skb)
> +				cf->data[2] |=3D CAN_ERR_PROT_BIT1;
> +
> +			break;
> +		case 'c':
> +			netdev_dbg(dev, "CRC error\n");
> +			rx_errors =3D true;
> +			if (skb) {
> +				cf->data[2] |=3D CAN_ERR_PROT_BIT;
> +				cf->data[3] =3D CAN_ERR_PROT_LOC_CRC_SEQ;
> +			}
> +
> +			break;
> +		case 'f':
> +			netdev_dbg(dev, "Form Error\n");
> +			rx_errors =3D true;
> +			if (skb)
> +				cf->data[2] |=3D CAN_ERR_PROT_FORM;
> +
> +			break;
> +		case 'o':
> +			netdev_dbg(dev, "Rx overrun error\n");
> +			dev->stats.rx_over_errors++;
> +			dev->stats.rx_errors++;

=2E...if you want to increment in the case.

> +			if (skb) {
> +				cf->can_id |=3D CAN_ERR_CRTL;
> +				cf->data[1] =3D CAN_ERR_CRTL_RX_OVERFLOW;
> +			}
> +
> +			break;
> +		case 'O':
> +			netdev_dbg(dev, "Tx overrun error\n");
> +			dev->stats.tx_errors++;
> +			if (skb) {
> +				cf->can_id |=3D CAN_ERR_CRTL;
> +				cf->data[1] =3D CAN_ERR_CRTL_TX_OVERFLOW;
> +			}
> +
> +			break;
> +		case 's':
> +			netdev_dbg(dev, "Stuff error\n");
> +			rx_errors =3D true;
> +			if (skb)
> +				cf->data[2] |=3D CAN_ERR_PROT_STUFF;
> +
> +			break;
> +		default:
> +			if (skb)
> +				dev_kfree_skb(skb);
> +
> +			return;
> +		}
> +	}
> +
> +	if (rx_errors)
> +		dev->stats.rx_errors++;
> +
> +	if (tx_errors)
> +		dev->stats.tx_errors++;
> +
> +	if (skb)
> +		netif_rx(skb);
> +}
> +
>  /* Send one completely decapsulated can_frame to the network layer */
> -static void slc_bump(struct slcan *sl)
> +static void slc_bump_frame(struct slcan *sl)
>  {
>  	struct sk_buff *skb;
>  	struct can_frame *cf;
> @@ -255,6 +365,24 @@ static void slc_bump(struct slcan *sl)
>  	dev_kfree_skb(skb);
>  }
> =20
> +static void slc_bump(struct slcan *sl)
> +{
> +	switch (sl->rbuff[0]) {
> +	case 'r':
> +		fallthrough;
> +	case 't':
> +		fallthrough;
> +	case 'R':
> +		fallthrough;
> +	case 'T':
> +		return slc_bump_frame(sl);
> +	case 'e':
> +		return slc_bump_err(sl);
> +	default:
> +		return;
> +	}
> +}
> +
>  /* parse tty input stream */
>  static void slcan_unesc(struct slcan *sl, unsigned char s)
>  {
> --=20
> 2.32.0
>=20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hi4omindgk2aohao
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKm5/UACgkQrX5LkNig
011BTAf+LVMpE9mxzEZB/h0rR6tDLiBIjNvITU9UdnF/yiCZCmW0Yd7XqgM/2d/B
MaW/KH5KEN+MspVoNy0urOdxUbWa8PNE9W3EQpqFc8ZrZ7K2ADu26OHWEosAMNDx
vFAPl6H0mATaUyNLgUli+Eb5822i88AwM7//IiDWrmM4c992Oywff9+Z7JVtC5CH
1A2pd2dleefWs7obcDTORI0dlDuWIXserMeJQbdQkbndA2dn7OIEcViDyySH8sdL
qKpNZeC+/HIeEgEEBrl7ag6Fa/ZVP2LZJilk55GRKp0xSSmlxoXkxTjlXz39UGW5
E7OvzB8Lij+ENpX4AR/gGrey/NxzkA==
=pIY1
-----END PGP SIGNATURE-----

--hi4omindgk2aohao--
