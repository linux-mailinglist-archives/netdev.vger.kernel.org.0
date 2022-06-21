Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A29553476
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 16:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351539AbiFUOZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 10:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351599AbiFUOZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 10:25:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DAC2317C
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 07:25:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o3eof-0007fC-NI; Tue, 21 Jun 2022 16:25:17 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-bd72-15a3-eb10-2206.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:bd72:15a3:eb10:2206])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C6EC49B8B5;
        Tue, 21 Jun 2022 14:25:15 +0000 (UTC)
Date:   Tue, 21 Jun 2022 16:25:15 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Thomas.Kopp@microchip.com
Cc:     pavel.modilaynen@volvocars.com, drew@beagleboard.org,
        linux-can@vger.kernel.org, menschel.p@posteo.de,
        netdev@vger.kernel.org, will@macchina.cc
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20220621142515.4xgxhj6oxo5kuepn@pengutronix.de>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
 <PR3P174MB01124C085C0E0A0220F2B11584709@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB53901D49578FE265B239E55AFB7C9@DM4PR11MB5390.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="b53yhzgh5rzrogp6"
Content-Disposition: inline
In-Reply-To: <DM4PR11MB53901D49578FE265B239E55AFB7C9@DM4PR11MB5390.namprd11.prod.outlook.com>
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


--b53yhzgh5rzrogp6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Picking up this old thread....

On 21.12.2021 22:24:52, Thomas.Kopp@microchip.com wrote:
> Thanks for the data. I've looked into this and it seems that the
> second bit being set in your case does not depend on the SPI-Rate (or
> the quirks for that matter) but it seems to be hardware setup related.
>=20
> I'm fine with changing the driver so that it ignores set LSBs but
> would limit it to 2 or 3 bits:

> (buf_rx->data[0] =3D=3D 0x0 || buf_rx->data[0] =3D=3D 0x80))
> becomes
> ((buf_rx->data[0] & 0xf8) =3D=3D 0x0 || (buf_rx->data[0] & 0xf8) =3D=3D 0=
x80)) {
>=20
> The action also needs to be changed and the flip back of the bit needs
> to be removed. In this case the flipped databit that produces a
> matching CRC is actually  correct (i.e. consistent with the 7 LSBs in
> that byte.)
>=20
> A patch could look like this (I'm currently not close to a setup where
> I can compile/test this.)

Thomas, can I have your Signed-off-by for this patch?

Marc

> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/n=
et/can/spi/mcp251xfd/mcp251xfd-regmap.c
> index 297491516a26..e5bc897f37e8 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
> @@ -332,12 +332,10 @@ mcp251xfd_regmap_crc_read(void *context,
>                  *
>                  * If the highest bit in the lowest byte is flipped
>                  * the transferred CRC matches the calculated one. We
> -                * assume for now the CRC calculation in the chip
> -                * works on wrong data and the transferred data is
> -                * correct.
> +                * assume for now the CRC operates on the correct data.
>                  */
>                 if (reg =3D=3D MCP251XFD_REG_TBC &&
> -                   (buf_rx->data[0] =3D=3D 0x0 || buf_rx->data[0] =3D=3D=
 0x80)) {
> +                   ((buf_rx->data[0] & 0xF8) =3D=3D 0x0 || (buf_rx->data=
[0] & 0xF8) =3D=3D 0x80)) {
>                         /* Flip highest bit in lowest byte of le32 */
>                         buf_rx->data[0] ^=3D 0x80;
>=20
> @@ -347,10 +345,8 @@ mcp251xfd_regmap_crc_read(void *context,
>                                                                   val_len=
);
>                         if (!err) {
>                                 /* If CRC is now correct, assume
> -                                * transferred data was OK, flip bit
> -                                * back to original value.
> +                                * flipped data was OK.
>                                  */
> -                               buf_rx->data[0] ^=3D 0x80;
>                                 goto out;
>                         }
>                 }
>=20
> Thanks,
> Thomas
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--b53yhzgh5rzrogp6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKx1McACgkQrX5LkNig
012YUAf/YXu6T42MB7nmX1BM7wyF9wMC+oo/7AhfQa0nGVREg2JVQcO+4H6yuZko
R/681s4acSF6qYkoVyMQgo0UkoAwvl1KegzlNdaP2+eH7CxTSYw+JCc9M+aY9B6r
eBE8yv9b4khgMp+FB5BVx1ms+GEApGqsb6vW7bH1hXa9Zqf/yy/2rY0C/9szkMGy
9cyHUYabnCXjW1Xn0J14Il3Ctn5QnKIrxDr/C2uhhQQVz2LwQa3TDN3CJgqI9aCq
kv/DwbXQd3J+gCQKcAavDUZVI1tGvylyR01S89zmZK8tHffqqqrLOONt9EO5MJQA
1SUToRmMEz7aQgzYZDzajnbWwOfbdg==
=qFiv
-----END PGP SIGNATURE-----

--b53yhzgh5rzrogp6--
