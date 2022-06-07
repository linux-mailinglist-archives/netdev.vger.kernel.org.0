Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D745E53FAF4
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240704AbiFGKNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240699AbiFGKNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:13:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCAEB41E6
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:13:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyWDD-0007Vn-UH; Tue, 07 Jun 2022 12:13:23 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 53B2A8DAEE;
        Tue,  7 Jun 2022 10:13:22 +0000 (UTC)
Date:   Tue, 7 Jun 2022 12:13:21 +0200
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
Subject: Re: [RFC PATCH 13/13] can: slcan: extend the protocol with CAN state
 info
Message-ID: <20220607101321.3uihcgpomplyjhhq@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-14-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fjxfvns6rqj5jqt6"
Content-Disposition: inline
In-Reply-To: <20220607094752.1029295-14-dario.binacchi@amarulasolutions.com>
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


--fjxfvns6rqj5jqt6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 11:47:52, Dario Binacchi wrote:
> It extends the protocol to receive the adapter CAN state changes
> (warning, busoff, etc.) and forward them to the netdev upper levels.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>=20
> ---
>=20
>  drivers/net/can/slcan/slcan-core.c | 65 ++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>=20
> diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/s=
lcan-core.c
> index 02e7c14de45c..ab4c08a7dc81 100644
> --- a/drivers/net/can/slcan/slcan-core.c
> +++ b/drivers/net/can/slcan/slcan-core.c
> @@ -78,6 +78,9 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan inter=
faces");
>  #define SLC_CMD_LEN 1
>  #define SLC_SFF_ID_LEN 3
>  #define SLC_EFF_ID_LEN 8
> +#define SLC_STATE_LEN 1
> +#define SLC_STATE_BE_RXCNT_LEN 3
> +#define SLC_STATE_BE_TXCNT_LEN 3
> =20
>  struct slcan {
>  	struct can_priv         can;
> @@ -182,6 +185,66 @@ int slcan_enable_err_rst_on_open(struct net_device *=
ndev, bool on)
>    *			STANDARD SLCAN DECAPSULATION			 *
>    **********************************************************************=
**/
> =20
> +static void slc_bump_state(struct slcan *sl)
> +{
> +	struct net_device *dev =3D sl->dev;
> +	struct sk_buff *skb;
> +	struct can_frame *cf;
> +	char *cmd =3D sl->rbuff;
> +	u32 rxerr, txerr;
> +	enum can_state state, rx_state, tx_state;
> +
> +	if (*cmd !=3D 's')
> +		return;
> +
> +	cmd +=3D SLC_CMD_LEN;
> +	switch (*cmd) {
> +	case 'a':
> +		state =3D CAN_STATE_ERROR_ACTIVE;
> +		break;
> +	case 'w':
> +		state =3D CAN_STATE_ERROR_WARNING;
> +		break;
> +	case 'p':
> +		state =3D CAN_STATE_ERROR_PASSIVE;
> +		break;
> +	case 'f':
> +		state =3D CAN_STATE_BUS_OFF;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	if (state =3D=3D sl->can.state)
> +		return;
> +
> +	cmd +=3D SLC_STATE_BE_RXCNT_LEN + 1;
> +	cmd[SLC_STATE_BE_TXCNT_LEN] =3D 0;
> +	if (kstrtou32(cmd, 10, &txerr))
> +		return;
> +
> +	*cmd =3D 0;
> +	cmd -=3D SLC_STATE_BE_RXCNT_LEN;
> +	if (kstrtou32(cmd, 10, &rxerr))
> +		return;
> +
> +	skb =3D alloc_can_err_skb(dev, &cf);
> +	if (unlikely(!skb))
> +		return;

Please continue error handling, even if no skb can be allocated.

> +
> +	cf->data[6] =3D txerr;
> +	cf->data[7] =3D rxerr;
> +
> +	tx_state =3D txerr >=3D rxerr ? state : 0;
> +	rx_state =3D txerr <=3D rxerr ? state : 0;
> +	can_change_state(dev, cf, tx_state, rx_state);
> +
> +	if (state =3D=3D CAN_STATE_BUS_OFF)
> +		can_bus_off(dev);
> +
> +	netif_rx(skb);
> +}
> +
>  static void slc_bump_err(struct slcan *sl)
>  {
>  	struct net_device *dev =3D sl->dev;
> @@ -354,6 +417,8 @@ static void slc_bump(struct slcan *sl)
>  		return slc_bump_frame(sl);
>  	case 'e':
>  		return slc_bump_err(sl);
> +	case 's':
> +		return slc_bump_state(sl);
>  	default:
>  		return;
>  	}

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fjxfvns6rqj5jqt6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfJL8ACgkQrX5LkNig
011k3Qf/S04hVETwcCTTfKH75fegb17pqUNLCHcPS3ubAAop4hkLHKYiBuQVepDK
rfKQ52ooyNLNZukKR8m6PzOV5kwD5zdXeW9WyqK3qtRt6PZYh4QvA2ZF8eK+cXg5
UqXnhoAHkXj3YlHrHvrUNNOVtOodL2XjfDTe7NfmeWMbgybp5v/7+EkAFUJgroIA
1Wu+4Iwaz8IALF+NcBLvhSm0Pgijp1t7ct51QCxg6zVEhXD7p/eKpbfsRJkMg0gB
ExVebxApqA1QWMRG4EgK0F9ZvL8VD+Y3PDoknETfksTuTMivtipztkj9qT+WiF6f
cvTNzoITrRuIbs9KqdklpMxuSuXbfg==
=SHmK
-----END PGP SIGNATURE-----

--fjxfvns6rqj5jqt6--
