Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534392B1636
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgKMHKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgKMHKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 02:10:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827BFC0613D1;
        Thu, 12 Nov 2020 23:10:54 -0800 (PST)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605251452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p661EQmTuzLYneEuJa/ev2/JCDeTtK3+51IrCpEGIx4=;
        b=1j/xvyLtnRgZWBKfjeCcMAOE9yhTELeF2yKA2/BrSin3vL6x31DcOMwKBmZke2LNTnU38B
        BEtI0/z4/zCSrc1HACJW4pPgYsQ4X7ILKM1LL5OivmjhdQE8eCoNIPpcIUPGCvIEWMK1Fb
        z6+NlWGqB01O0Est5Iw1bHZ++Nj3+8LuEgKC19aj+5ITpYMf1+K/5oGxgJLY67GiUQ4+Wx
        IgPZqxi8eRZFTHLYSxZcyqDvF4FiUH4/Fh4lWPfoSZHIDADy6RMYY0nY1at2GA5BGzX00G
        x/WqPQTKNAe+oW5Gy1GYeskq4exxfbd40tP3rZvbdwHSic9PhjD9A0MZX9mCBw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605251452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p661EQmTuzLYneEuJa/ev2/JCDeTtK3+51IrCpEGIx4=;
        b=hroMx/wLMdj6QQiA8kbT3d6n6Py4NG0TqJBy2Jo8wL188cAPX0eqUw3AbrFJDo+WKgirA5
        djrsuOYQ9R26hNCw==
To:     YueHaibing <yuehaibing@huawei.com>, olteanv@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] net: dsa: sja1105: Fix return value check in sja1105_ptp_clock_register()
In-Reply-To: <20201112145532.38320-1-yuehaibing@huawei.com>
References: <20201112145532.38320-1-yuehaibing@huawei.com>
Date:   Fri, 13 Nov 2020 08:10:42 +0100
Message-ID: <87a6vlspe5.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Nov 12 2020, YueHaibing wrote:
> drivers/net/dsa/sja1105/sja1105_ptp.c:869 sja1105_ptp_clock_register() wa=
rn: passing zero to 'PTR_ERR'
>
> ptp_clock_register() returns ERR_PTR() and never returns
> NULL. The NULL test should be removed.

Which is not true. From the documentation:

 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.

Please, always Cc Richard for PTP patches.

Actually you can have a look at this discussion here:

 https://lkml.kernel.org/netdev/1605086686-5140-1-git-send-email-wangqing@v=
ivo.com/

>
> Fixes: bb77f36ac21d ("net: dsa: sja1105: Add support for the PTP clock")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_ptp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1=
105/sja1105_ptp.c
> index 1b90570b257b..1e41d491c854 100644
> --- a/drivers/net/dsa/sja1105/sja1105_ptp.c
> +++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
> @@ -865,7 +865,7 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
>  	spin_lock_init(&tagger_data->meta_lock);
>=20=20
>  	ptp_data->clock =3D ptp_clock_register(&ptp_data->caps, ds->dev);
> -	if (IS_ERR_OR_NULL(ptp_data->clock))
> +	if (IS_ERR(ptp_data->clock))

When you do this, you'll have to make sure that the driver handles the
NULL case "gracefully".

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+uMXIACgkQeSpbgcuY
8KbErxAAhNswqyW8m8JuzoRZhbCA/1qQ2AU28O+rrV4OHIdmEA/czoRM/fcQfw0Z
2Otd5B21XGEo2iFNMkiPd77Bw4XeNydHUi+8tkcTaRIRm6r5tPqqtyiHBC6UHAHL
x9WY1CWsP3iBCGXV5EgoA+wrQCIZQChcKmSz5rf0r19G4YHz8Ixh9tLHnvoNqBrJ
mD10CBRSd0AXwuIDyJp3xaNvkvABlIanKLcEOhUNA0VVxTEufwheSCmYRGVZYlwj
duY254pxOo0QH0VMZVEKdIZ5lYs+ddXGrBs4TQzDyjjbq2aZHLqxkfS5JRk50RRW
HKvOzawppyFJithvv3oG+QEhXQUWceREQ+kSyhA3J83mW/LQAsgr1kaBRfRUj/fQ
FtpRj8stII6DOQSHs+GXWVDcdrz4YV+j0XtGYWYjZJkNk3+OFM9ODnVsNKCjLbPb
206zjAGwSqZqpgISEMU1kRLnyuYMN/dFU4LgyDe4/YtoOmITvwZ1UeW18kYy9q4Y
JUeQxN183U5NbwMYdQZeDWh54ARdSxSJ5NemMiShHWelLHfknmcBI/riYLDaOkA6
kYjYv9KkQnqHhCbrcmBp3IZb4v/lD1Zzt3Dv8kxinBq2Q7xMXLx4apU0Q9Cy4J60
J/pCS3GD0ebMR53BWK2BAcODPs6E1bhaKdwBeDigHy4i0di46vk=
=NV8K
-----END PGP SIGNATURE-----
--=-=-=--
