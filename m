Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531503EF2F2
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 21:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhHQT4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 15:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhHQT4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 15:56:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2E0C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 12:55:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mG5Bj-0007dJ-9H; Tue, 17 Aug 2021 21:55:55 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:4c82:b09e:fec8:3248])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 499F1669233;
        Tue, 17 Aug 2021 19:55:53 +0000 (UTC)
Date:   Tue, 17 Aug 2021 21:55:51 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/7] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210817195551.wwgu7dnhb6qyvo7n@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-6-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="femi54sv3tzgjgry"
Content-Disposition: inline
In-Reply-To: <20210815033248.98111-6-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--femi54sv3tzgjgry
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.08.2021 12:32:46, Vincent Mailhol wrote:
> +static int can_tdc_changelink(struct net_device *dev, const struct nlatt=
r *nla,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb_tdc[IFLA_CAN_TDC_MAX + 1];
> +	struct can_priv *priv =3D netdev_priv(dev);
> +	struct can_tdc *tdc =3D &priv->tdc;
> +	const struct can_tdc_const *tdc_const =3D priv->tdc_const;
> +	int err;
> +
> +	if (!tdc_const || !can_tdc_is_enabled(priv))
> +		return -EOPNOTSUPP;
> +
> +	if (dev->flags & IFF_UP)
> +		return -EBUSY;
> +
> +	err =3D nla_parse_nested(tb_tdc, IFLA_CAN_TDC_MAX, nla,
> +			       can_tdc_policy, extack);
> +	if (err)
> +		return err;
> +
> +	if (tb_tdc[IFLA_CAN_TDC_TDCV]) {
> +		u32 tdcv =3D nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCV]);
> +
> +		if (tdcv < tdc_const->tdcv_min || tdcv > tdc_const->tdcv_max)
> +			return -EINVAL;
> +
> +		tdc->tdcv =3D tdcv;

You have to assign to a temporary struct first, and set the priv->tdc
after complete validation, otherwise you end up with inconsistent
values.

> +	}
> +
> +	if (tb_tdc[IFLA_CAN_TDC_TDCO]) {
> +		u32 tdco =3D nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCO]);
> +
> +		if (tdco < tdc_const->tdco_min || tdco > tdc_const->tdco_max)
> +			return -EINVAL;
> +
> +		tdc->tdco =3D tdco;
> +	}
> +
> +	if (tb_tdc[IFLA_CAN_TDC_TDCF]) {
> +		u32 tdcf =3D nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCF]);
> +
> +		if (tdcf < tdc_const->tdcf_min || tdcf > tdc_const->tdcf_max)
> +			return -EINVAL;
> +
> +		tdc->tdcf =3D tdcf;
> +	}
> +
> +	return 0;
> +}

To reproduce (ip pseudo-code only :D ):

ip down
ip up tdc-mode manual tdco 111 tdcv 33  # 111 is out of range, 33 is valid
ip down
ip up                                   # results in tdco=3D0 tdcv=3D33 mod=
e=3Dmanual

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--femi54sv3tzgjgry
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEcFEUACgkQqclaivrt
76nN1ggAr4yOd2SysaDbW1q1G/J0QK6Q8Seymr9AqJ4CpYspWe/iEEipRUQIDmBz
5iiSt/NnFqMh9wyxL2gmawzZQA9gwv82r+dfFI+3zW4OdEoO+Qw6Z1PNwGB/EDTa
9FOWJvb+8aE5cdiF47Yl7l4geUWqq2mxeAJ1ULEFqkmNBkmr4WuYIIQWroycl4z6
O8wG1H//MuoMnCUr7TzKl4jiuwSIamcUhGfmsAzJ8LVPNhoVmg1VQ7acghUhEf8c
Iet9QLefSIcsuJ2Nfx5FUYlJ4SL5h65ZYZdAYcgRCip2d/J50gS7wEMznqO32LVp
vh36Inpa5enOTjJvOPo/HXTCtlpAxw==
=zn8F
-----END PGP SIGNATURE-----

--femi54sv3tzgjgry--
