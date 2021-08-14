Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9262D3EC24C
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbhHNLNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbhHNLNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:13:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7581EC061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 04:12:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mErap-0006l4-Mg; Sat, 14 Aug 2021 13:12:47 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:9c12:ab28:ecb4:fe2f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 690556672B6;
        Sat, 14 Aug 2021 11:12:45 +0000 (UTC)
Date:   Sat, 14 Aug 2021 13:12:43 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/7] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210814111243.biquurwkyzmhmsad@pengutronix.de>
References: <20210814091750.73931-1-mailhol.vincent@wanadoo.fr>
 <20210814091750.73931-6-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4shgy4pvm2efxhha"
Content-Disposition: inline
In-Reply-To: <20210814091750.73931-6-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4shgy4pvm2efxhha
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.08.2021 18:17:48, Vincent Mailhol wrote:
[...]

>  static int can_changelink(struct net_device *dev, struct nlattr *tb[],
>  			  struct nlattr *data[],
>  			  struct netlink_ext_ack *extack)
>  {
>  	struct can_priv *priv =3D netdev_priv(dev);
> +	u32 tdc_mask =3D 0;
>  	int err;
> =20
>  	/* We need synchronization with dev->stop() */
> @@ -107,6 +179,7 @@ static int can_changelink(struct net_device *dev, str=
uct nlattr *tb[],
>  		struct can_ctrlmode *cm;
>  		u32 ctrlstatic;
>  		u32 maskedflags;
> +		u32 tdc_flags;
> =20
>  		/* Do not allow changing controller mode while running */
>  		if (dev->flags & IFF_UP)
> @@ -138,7 +211,18 @@ static int can_changelink(struct net_device *dev, st=
ruct nlattr *tb[],
>  			dev->mtu =3D CAN_MTU;
>  			memset(&priv->data_bittiming, 0,
>  			       sizeof(priv->data_bittiming));
> +			memset(&priv->tdc, 0, sizeof(priv->tdc));
> +			priv->ctrlmode &=3D ~CAN_CTRLMODE_TDC_MASK;
>  		}
> +
> +		tdc_flags =3D cm->flags & CAN_CTRLMODE_TDC_MASK;
> +		/* CAN_CTRLMODE_TDC_{AUTO,MANUAL} are mutually exclusive */
> +		if (tdc_flags =3D=3D CAN_CTRLMODE_TDC_MASK)
> +			return -EOPNOTSUPP;
> +		/* If one of CAN_CTRLMODE_TDC_* is set then TDC must be set */
> +		if (tdc_flags && !data[IFLA_CAN_TDC])
> +			return -EOPNOTSUPP;

These don't need information form the can_priv, right? So these checks
can be moved to can_validate()?

> +		tdc_mask =3D cm->mask & CAN_CTRLMODE_TDC_MASK;
>  	}

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4shgy4pvm2efxhha
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEXpSkACgkQqclaivrt
76lPBAgAiA1KYdu+Pm1Su6TWxfQKUKI6UbAud8iKhBti39RNRgD6V5zQGQBZGhNS
wqFdr1nRzsdLT/oQ4W8M0EWrS+mNvB5IPk/geNY9jO1rC46KAZtWwoyf7BqIlfx3
higjmxcgqe/teVyMh6/L+5QWqdv2Lz2WBiI9DY2+6IZAgqsVQfyMqI93KF8zwJpr
EjM6u6xJsCnCiUhDpCAmX/S1sOOKa9VaLLkAdK9x1jx3WNKE3xE76gQHJFKlu0TJ
0Mn173df3TUTjX5drGHuQKSn6tKqZZOsZxn+O1CQw1+JZyY1S4jorZ4o3swLn8+y
VROzoormCCov12GfAZJ68ayCvdUWtQ==
=Dlcn
-----END PGP SIGNATURE-----

--4shgy4pvm2efxhha--
