Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673BA53FCA1
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbiFGLBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242470AbiFGLAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:00:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB3B56416
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:56:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyWt5-00072I-Dw; Tue, 07 Jun 2022 12:56:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 99EDB8DBC5;
        Tue,  7 Jun 2022 10:56:37 +0000 (UTC)
Date:   Tue, 7 Jun 2022 12:56:37 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
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
Subject: Re: [RFC PATCH 12/13] can: slcan: extend the protocol with error info
Message-ID: <20220607105637.4vnqtv4vbnczva73@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-13-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ssxfwmq3jxhh5und"
Content-Disposition: inline
In-Reply-To: <20220607094752.1029295-13-dario.binacchi@amarulasolutions.com>
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


--ssxfwmq3jxhh5und
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 11:47:51, Dario Binacchi wrote:
> It extends the protocol to receive the adapter CAN communication errors
> and forward them to the netdev upper levels.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---
>=20
>  drivers/net/can/slcan/slcan-core.c | 104 ++++++++++++++++++++++++++++-
>  1 file changed, 103 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/s=
lcan-core.c
> index b813a59534a3..02e7c14de45c 100644
> --- a/drivers/net/can/slcan/slcan-core.c
> +++ b/drivers/net/can/slcan/slcan-core.c
> @@ -182,8 +182,92 @@ int slcan_enable_err_rst_on_open(struct net_device *=
ndev, bool on)
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
> +
> +	cmd +=3D SLC_CMD_LEN;
> +	/* get len from sanitized ASCII value */

What happens is a malicious device sends a wrong len value, that's
longer than the RX'ed data?

> +	len =3D *cmd++;
> +	if (len >=3D '0' && len < '9')
> +		len -=3D '0';
> +	else
> +		return;
> +
> +	skb =3D alloc_can_err_skb(dev, &cf);

Please continue error handling, even if no skb can be allocated.

> +	if (unlikely(!skb))
> +		return;
> +
> +	cf->can_id |=3D CAN_ERR_PROT | CAN_ERR_BUSERROR;
> +	for (i =3D 0; i < len; i++, cmd++) {
> +		switch (*cmd) {
> +		case 'a':
> +			netdev_dbg(dev, "ACK error\n");
> +			cf->can_id |=3D CAN_ERR_ACK;
> +			cf->data[3] =3D CAN_ERR_PROT_LOC_ACK;
> +			tx_errors =3D true;
> +			break;
> +		case 'b':
> +			netdev_dbg(dev, "Bit0 error\n");
> +			cf->data[2] |=3D CAN_ERR_PROT_BIT0;
> +			tx_errors =3D true;
> +			break;
> +		case 'B':
> +			netdev_dbg(dev, "Bit1 error\n");
> +			cf->data[2] |=3D CAN_ERR_PROT_BIT1;
> +			tx_errors =3D true;
> +			break;
> +		case 'c':
> +			netdev_dbg(dev, "CRC error\n");
> +			cf->data[2] |=3D CAN_ERR_PROT_BIT;
> +			cf->data[3] =3D CAN_ERR_PROT_LOC_CRC_SEQ;
> +			rx_errors =3D true;
> +			break;
> +		case 'f':
> +			netdev_dbg(dev, "Form Error\n");
> +			cf->data[2] |=3D CAN_ERR_PROT_FORM;
> +			rx_errors =3D true;
> +			break;
> +		case 'o':
> +			netdev_dbg(dev, "Rx overrun error\n");
> +			cf->can_id |=3D CAN_ERR_CRTL;
> +			cf->data[1] =3D CAN_ERR_CRTL_RX_OVERFLOW;
> +			dev->stats.rx_over_errors++;
> +			dev->stats.rx_errors++;
> +			break;
> +		case 'O':
> +			netdev_dbg(dev, "Tx overrun error\n");
> +			cf->can_id |=3D CAN_ERR_CRTL;
> +			cf->data[1] =3D CAN_ERR_CRTL_TX_OVERFLOW;
> +			dev->stats.tx_errors++;
> +			break;
> +		case 's':
> +			netdev_dbg(dev, "Stuff error\n");
> +			cf->data[2] |=3D CAN_ERR_PROT_STUFF;
> +			rx_errors =3D true;
> +			break;
> +		}
> +	}
> +
> +	if (rx_errors)
> +		dev->stats.rx_errors++;
> +
> +	if (tx_errors)
> +		dev->stats.tx_errors++;
> +
> +	netif_rx(skb);
> +}
> +

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ssxfwmq3jxhh5und
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfLuIACgkQrX5LkNig
013hsQgAghzB45G5T/d9COtfEWCcub/p6KFBW8Pt5SQfvSlUfEh7yuScPV/B8tum
Uek/ORPZAes9xoBuNo3UMPsHPCZvaOvbYfY1oNJJuw+rGDYL4v40UismcGr9M9nr
mqEGUj03KjJDPlf1RPNxDsuH2irS05TOKjpXq90ZaN5zB5f6SZlNvfFDHkGMn+Zm
1z0ZZCpWNO9+VS/ZfoUJoY6OgXQxMm3Pw3pdwJqGMelFaD9BAw1f6RK2ceRcvGLi
tY06Tf3mzhzFLAlY856+yPKw8eh7bP2PBLDfa+CVCraCcicUNzEz0a7h8Nf0TaWx
ZaZdTg/teBjBCYq/cnW2z1NOqD86aA==
=emqs
-----END PGP SIGNATURE-----

--ssxfwmq3jxhh5und--
