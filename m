Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A04455B3B3
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiFZTOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiFZTOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:14:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4553CB7C2
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 12:14:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o5Xhz-0007BC-7G; Sun, 26 Jun 2022 21:14:11 +0200
Received: from pengutronix.de (p200300ea0f229100c1f120485ffcf4df.dip0.t-ipconnect.de [IPv6:2003:ea:f22:9100:c1f1:2048:5ffc:f4df])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 74F999FAC2;
        Sun, 26 Jun 2022 19:14:08 +0000 (UTC)
Date:   Sun, 26 Jun 2022 21:14:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Thomas.Kopp@microchip.com
Cc:     pavel.modilaynen@volvocars.com, drew@beagleboard.org,
        linux-can@vger.kernel.org, menschel.p@posteo.de,
        netdev@vger.kernel.org, will@macchina.cc
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20220626191407.hcio6opdcxuf3adc@pengutronix.de>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
 <PR3P174MB01124C085C0E0A0220F2B11584709@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB53901D49578FE265B239E55AFB7C9@DM4PR11MB5390.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ebatoozct53ny7dd"
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


--ebatoozct53ny7dd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.12.2021 22:24:52, Thomas.Kopp@microchip.com wrote:
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

With this change the read of the TBC on the mcp2517fd becomes much more
stable. No more single bit flips in the 1st data byte that can be fixed
with xor 0x80.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ebatoozct53ny7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmK4r/wACgkQrX5LkNig
010cAwf/ZvLFcs2+Qp4EECfU58rZCo9cCJDLLXuoxOHkGimcs87jtRnXatBmlxWH
zMa7BJGCSM4HWYv7r8ykuUpHpyUO36lCPXgEAPM4HoY/UTgrBaLn2iysaQbEw5kT
d1YL6xb+x/rXFBVW4zUNaVmEJAaZvAL4BAXQEwboz3U3x98l8yI3pO2bLVP22eFB
RCI32vTAt7fwU8a/ebuUAx6H36G6HIWVhdFWEBnL83T8Ie5SE8aZB30TxPi+4gye
axI7RfKdXk0+F5ReTYfCwd6mrRs6t9L4oO3TZI+k1++04XtiAdHzEP1cih3x6fhe
WpFn58RizF5wh5bJ+0xdRAZzVd0P+A==
=9a7c
-----END PGP SIGNATURE-----

--ebatoozct53ny7dd--
