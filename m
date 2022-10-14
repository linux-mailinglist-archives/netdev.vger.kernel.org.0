Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B765FE940
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 09:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJNHLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 03:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiJNHLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 03:11:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D680915B333
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 00:11:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ojEqm-0006Gw-HT; Fri, 14 Oct 2022 09:11:20 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3D443FDE12;
        Fri, 14 Oct 2022 07:11:17 +0000 (UTC)
Date:   Fri, 14 Oct 2022 09:11:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: mcan: Add support for handling DLEC error on CAN
 FD
Message-ID: <20221014071114.a6ls5ay56xk4cin3@pengutronix.de>
References: <CGME20221014053017epcas5p359d337008999640fa140c691f47bc79c@epcas5p3.samsung.com>
 <20221014050332.45045-1-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="auelfjaotv27cxiq"
Content-Disposition: inline
In-Reply-To: <20221014050332.45045-1-vivek.2311@samsung.com>
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


--auelfjaotv27cxiq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.10.2022 10:33:32, Vivek Yadav wrote:
> When a frame in CAN FD format has reached the data phase, the next
> CAN event (error or valid frame) will be shown in DLEC.
>=20
> Utilizes the dedicated flag (Data Phase Last Error Code: DLEC flag) to
> determine the type of last error that occurred in the data phase
> of a CAN FD frame and handle the bus errors.
>=20
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
> ---
> This patch is dependent on following patch from Marc:
> [1]: https://lore.kernel.org/all/20221012074205.691384-1-mkl@pengutronix.=
de/
>=20
>  drivers/net/can/m_can/m_can.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 18a138fdfa66..8cff1f274aab 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -156,6 +156,7 @@ enum m_can_reg {
>  #define PSR_EW		BIT(6)
>  #define PSR_EP		BIT(5)
>  #define PSR_LEC_MASK	GENMASK(2, 0)
> +#define PSR_DLEC_MASK   GENMASK(8, 10)
> =20
>  /* Interrupt Register (IR) */
>  #define IR_ALL_INT	0xffffffff
> @@ -876,8 +877,16 @@ static int m_can_handle_bus_errors(struct net_device=
 *dev, u32 irqstatus,
>  	if (cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) {
>  		u8 lec =3D FIELD_GET(PSR_LEC_MASK, psr);
> =20
> -		if (is_lec_err(lec))
> +		if (is_lec_err(lec)) {
>  			work_done +=3D m_can_handle_lec_err(dev, lec);
> +		} else {

In case of high interrupt latency there might be lec and dlec errors
pending. As this is error handling and not the hot path, please check
for both, i.e.:

                if (is_lec_err(lec))
                        work_done +=3D m_can_handle_lec_err(dev, lec);

                if (is_lec_err(dlec))
                        work_done +=3D m_can_handle_lec_err(dev, dlec);

> +			u8 dlec =3D FIELD_GET(PSR_DLEC_MASK, psr);
> +
> +			if (is_lec_err(dlec)) {
> +				netdev_dbg(dev, "Data phase error detected\n");

If you add a debug, please add one for the Arbitration phase, too.

> +				work_done +=3D m_can_handle_lec_err(dev, dlec);
> +			}
> +		}
>  	}
> =20
>  	/* handle protocol errors in arbitration phase */

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--auelfjaotv27cxiq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNJC5AACgkQrX5LkNig
012inQgAqQAHXULDQgDxLcGMMPHf9Vc3xfSIeMCKvDX3RUBDNygZ0JYa3OO0xBBX
pOmqPmXTJqHCnvzbNIS0D3GqfnITBx2fNfkTT/h4TLYcBCTICtMiKEdG4Kihr1o8
OkEFSaq43m+0kwDVpRRQFGsRezCphHlSGoAsHrA07udvncLLmWpaktNwB/KXcy1w
PoltReQJGwDVA5stJh6lpYpX3rSvFg2K6lOYnMuCOEKUYkM+vilenXw2k/PJQ+qh
EbxayxkqAWJqwNbD48a2aqcsGzl3z5gTf6LnRemJ7FgYk8uN2r9mG+Qa7AKxHIW+
YeX5J7PmPWPtXN80OOx1nXUUOHd7gA==
=2FT1
-----END PGP SIGNATURE-----

--auelfjaotv27cxiq--
