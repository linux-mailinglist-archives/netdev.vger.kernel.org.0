Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E803C57FFC1
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiGYNZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiGYNZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:25:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999CE5FD5
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 06:25:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oFy5G-0002CC-6O; Mon, 25 Jul 2022 15:25:18 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1793DB9964;
        Mon, 25 Jul 2022 13:25:15 +0000 (UTC)
Date:   Mon, 25 Jul 2022 15:25:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/6] can: slcan: extend supported features (step 2)
Message-ID: <20220725132514.h3iva4xi4sdncus6@pengutronix.de>
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yohv5x576q7yvjhc"
Content-Disposition: inline
In-Reply-To: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
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


--yohv5x576q7yvjhc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.07.2022 08:54:13, Dario Binacchi wrote:
> With this series I try to finish the task, started with the series [1],
> of completely removing the dependency of the slcan driver from the
> userspace slcand/slcan_attach applications.
>=20
> The series, however, still lacks a patch for sending the bitrate setting
> command to the adapter:
>=20
> slcan_attach -b <btr> <dev>
>=20
> Without at least this patch the task cannot be considered truly completed.
>=20
> The idea I got is that this can only happen through the ethtool API.
> Among the various operations made available by this interface I would
> have used the set_regs (but only the get_regs has been developed), or,
> the set_eeprom, even if the setting would not be stored in an eeprom.
> IMHO it would take a set_regs operation with a `struct ethtool_wregs'
> parameter similar to `struct ethtool_eeprom' without the magic field:

This doesn't feel right.

> struct ethtool_wregs {
> 	__u32	cmd;
> 	__u32	offset;
> 	__u32	len;
> 	__u8	data[0];
> };
>=20
> But I am not the expert and if there was an alternative solution already
> usable, it would be welcome.

Have a look at the get/set_tunable() callback:

| https://elixir.bootlin.com/linux/latest/source/include/linux/ethtool.h#L5=
75

You probably have to add a new tunable. Here you'll find the people and
commits that changed the tunable:

| https://github.com/torvalds/linux/blame/master/include/uapi/linux/ethtool=
=2Eh#L229

It's usually worth including them in an RFC patch series where you add a
new tunable and make use of it in the slcan driver.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yohv5x576q7yvjhc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLembgACgkQrX5LkNig
011YBwf8D6sYc5Z10hNfGDyKQ3RcYyhgRysl2n8u/I+7BTE6Y3+sOXF5X0Gt5auQ
O3L54lyy3/LKsyXwoCRPUgMOgbLCPwPI0EqLNEKhpTrQAJ5h0uCbRZkUREhkngtO
Tr9MoBK+7JmHVOpZUBVVIXB631k/RNvCZQXm1wlUsumXqX13EFPImJvuk+dDo1lm
TrM1mSGX8FAq4OG2mlvdLwztIJExjprR2hP2zyUs3gEJk6r4z5z5N5TBCcU8+bH0
98kyOZzlpUcSB1tIK7V1KHOsW2kifnyGGueznkI/V22bNzq0E4e1jeUjANuEtMXm
nWmiiH/XE7rvUL/kf4ER0yut8pUv8g==
=K8BG
-----END PGP SIGNATURE-----

--yohv5x576q7yvjhc--
