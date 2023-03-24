Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5816C852C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjCXSd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjCXSdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:33:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D24C16AE8
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:33:16 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pfmDG-0000Ih-N4; Fri, 24 Mar 2023 19:32:30 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2648C19BB98;
        Fri, 24 Mar 2023 18:32:27 +0000 (UTC)
Date:   Fri, 24 Mar 2023 19:32:25 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/16] can: m_can: Write transmit header and data in
 one transaction
Message-ID: <20230324183225.wydiuvs3ibdmnxqq@pengutronix.de>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-7-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kosqnrl7qx2j7t4l"
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-7-msp@baylibre.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kosqnrl7qx2j7t4l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.03.2023 12:05:36, Markus Schneider-Pargmann wrote:
> Combine header and data before writing to the transmit fifo to reduce
> the overhead for peripheral chips.
>=20
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>  drivers/net/can/m_can/m_can.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index a5003435802b..35a2332464e5 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1681,6 +1681,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_cl=
assdev *cdev)
>  		m_can_write(cdev, M_CAN_TXBAR, 0x1);
>  		/* End of xmit function for version 3.0.x */
>  	} else {
> +		char buf[TXB_ELEMENT_SIZE];

Can you create a proper struct that describes a single FIFO entry (id,
dlc, data)? Use that struct instead of the struct id_and_dlc
fifo_header.

> +		u8 len_padded =3D DIV_ROUND_UP(cf->len, 4);
>  		/* Transmit routine for version >=3D v3.1.x */
> =20
>  		txfqs =3D m_can_read(cdev, M_CAN_TXFQS);
> @@ -1720,12 +1722,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_=
classdev *cdev)
>  		fifo_header.dlc =3D FIELD_PREP(TX_BUF_MM_MASK, putidx) |
>  			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
>  			fdflags | TX_BUF_EFC;
> -		err =3D m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &fifo_header, 2);
> -		if (err)
> -			goto out_fail;
> +		memcpy(buf, &fifo_header, 8);
> +		memcpy_and_pad(&buf[8], len_padded, &cf->data, cf->len, 0);
> =20
> -		err =3D m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA,
> -				       cf->data, DIV_ROUND_UP(cf->len, 4));
> +		err =3D m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID,
> +				       buf, 2 + len_padded);
>  		if (err)
>  			goto out_fail;

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kosqnrl7qx2j7t4l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQd7LYACgkQvlAcSiqK
BOjHiQf+KWfgNwMny4MGohV5bLDNSGWL0X4eOcmNj8QPM3TMHO0WxNeAmPtEzmca
P3HNV0o1SPM2VapKAIM0qGmxrdotwBmCWZ/6MvbrAAC2dR5auimY5ujfzRXGjSbd
sCfQDgm2AeTF1cZH48O/1+0NfSAoPH6Cj1K+/wmflTRCIg6HcGQgX9LzgVbjf0mB
QfI6acVZV0qJmksfRd3eVL68e9kSOXhjbrsZTwlVfbkIP0vY8agsfXA0ES4UqT1t
oGVYY2DjkYl9ZIMGqiwfjSE6oZaO8AGBU2hlOUJlfhcvR7u3JLb1ajKGcf3/QpoK
P0OE2B7FTYYUMvvHSggV3jO+FTDOsg==
=WDZ0
-----END PGP SIGNATURE-----

--kosqnrl7qx2j7t4l--
