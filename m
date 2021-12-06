Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D5B46A112
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356873AbhLFQVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387282AbhLFQUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 11:20:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFA9C0698E4
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 08:16:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muGen-0006iD-Pf; Mon, 06 Dec 2021 17:16:01 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-10fe-3935-792e-fa54.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:10fe:3935:792e:fa54])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BC0596BCFE2;
        Mon,  6 Dec 2021 14:19:41 +0000 (UTC)
Date:   Mon, 6 Dec 2021 15:19:40 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Jimmy Assarsson <extja@kvaser.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: Re: [PATCH v4 5/5] can: do not increase tx_bytes statistics for RTR
 frames
Message-ID: <20211206141940.o3g4uydg6ibspqyq@pengutronix.de>
References: <20211203131808.2380042-1-mailhol.vincent@wanadoo.fr>
 <20211203131808.2380042-6-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yjx3cdgtyh6ektcc"
Content-Disposition: inline
In-Reply-To: <20211203131808.2380042-6-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yjx3cdgtyh6ektcc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.12.2021 22:18:08, Vincent Mailhol wrote:
> The actual payload length of the CAN Remote Transmission Request (RTR)
> frames is always 0, i.e. nothing is transmitted on the wire. However,
> those RTR frames still use the DLC to indicate the length of the
> requested frame.
>=20
> As such, net_device_stats:tx_bytes should not be increased when
> sending RTR frames.
>=20
> The function can_get_echo_skb() already returns the correct length,
> even for RTR frames (c.f. [1]). However, for historical reasons, the
> drivers do not use can_get_echo_skb()'s return value and instead, most
> of them store a temporary length (or dlc) in some local structure or
> array. Using the return value of can_get_echo_skb() solves the
> issue. After doing this, such length/dlc fields become unused and so
> this patch does the adequate cleaning when needed.
>=20
> This patch fixes all the CAN drivers.
>=20
> Finally, can_get_echo_skb() is decorated with the __must_check
> attribute in order to force future drivers to correctly use its return
> value (else the compiler would emit a warning).
>=20
> [1] commit ed3320cec279 ("can: dev: __can_get_echo_skb():
> fix real payload length return value for RTR frames")
>=20
> CC: Nicolas Ferre <nicolas.ferre@microchip.com>
> CC: Alexandre Belloni <alexandre.belloni@bootlin.com>
> CC: Ludovic Desroches <ludovic.desroches@microchip.com>
> CC: Maxime Ripard <mripard@kernel.org>
> CC: Chen-Yu Tsai <wens@csie.org>
> CC: Jernej Skrabec <jernej.skrabec@gmail.com>
> CC: Yasushi SHOJI <yashi@spacecubics.com>
> CC: Oliver Hartkopp <socketcan@hartkopp.net>
> CC: Stephane Grosjean <s.grosjean@peak-system.com>
> Tested-by: Jimmy Assarsson <extja@kvaser.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  drivers/net/can/at91_can.c                    |  8 ++--
>  drivers/net/can/c_can/c_can.h                 |  1 -
>  drivers/net/can/c_can/c_can_main.c            |  7 +---
>  drivers/net/can/cc770/cc770.c                 |  8 +---
>  drivers/net/can/janz-ican3.c                  |  3 +-
>  drivers/net/can/mscan/mscan.c                 |  4 +-
>  drivers/net/can/pch_can.c                     |  9 ++--
>  drivers/net/can/peak_canfd/peak_canfd.c       |  3 +-
>  drivers/net/can/rcar/rcar_can.c               | 11 +++--
>  drivers/net/can/rcar/rcar_canfd.c             |  6 +--
>  drivers/net/can/sja1000/sja1000.c             |  4 +-
>  drivers/net/can/slcan.c                       |  3 +-
>  drivers/net/can/softing/softing_main.c        |  8 ++--
>  drivers/net/can/spi/hi311x.c                  | 24 +++++------
>  drivers/net/can/spi/mcp251x.c                 | 25 +++++------
>  drivers/net/can/sun4i_can.c                   |  5 +--
>  drivers/net/can/usb/ems_usb.c                 |  7 +---
>  drivers/net/can/usb/esd_usb2.c                |  6 +--
>  drivers/net/can/usb/gs_usb.c                  |  7 ++--
>  drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  5 +--
>  .../net/can/usb/kvaser_usb/kvaser_usb_core.c  |  2 +-
>  .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 42 +++++++++----------
>  .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 13 +++---
>  drivers/net/can/usb/mcba_usb.c                | 12 ++----
>  drivers/net/can/usb/peak_usb/pcan_usb_core.c  | 20 ++++-----
>  drivers/net/can/usb/peak_usb/pcan_usb_core.h  |  1 -
>  drivers/net/can/usb/ucan.c                    | 10 ++---
>  drivers/net/can/usb/usb_8dev.c                |  6 +--
>  drivers/net/can/vcan.c                        |  7 ++--
>  drivers/net/can/vxcan.c                       |  2 +-
>  include/linux/can/skb.h                       |  5 ++-
>  31 files changed, 114 insertions(+), 160 deletions(-)
>=20
> diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
> index 97f1d08b4133..b37d9b4f508e 100644
> --- a/drivers/net/can/at91_can.c
> +++ b/drivers/net/can/at91_can.c
> @@ -448,7 +448,6 @@ static void at91_chip_stop(struct net_device *dev, en=
um can_state state)
>  static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_devic=
e *dev)
>  {
>  	struct at91_priv *priv =3D netdev_priv(dev);
> -	struct net_device_stats *stats =3D &dev->stats;
>  	struct can_frame *cf =3D (struct can_frame *)skb->data;
>  	unsigned int mb, prio;
>  	u32 reg_mid, reg_mcr;
> @@ -480,8 +479,6 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *sk=
b, struct net_device *dev)
>  	/* This triggers transmission */
>  	at91_write(priv, AT91_MCR(mb), reg_mcr);
> =20
> -	stats->tx_bytes +=3D cf->len;
> -
>  	/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
>  	can_put_echo_skb(skb, dev, mb - get_mb_tx_first(priv), 0);
> =20
> @@ -852,7 +849,10 @@ static void at91_irq_tx(struct net_device *dev, u32 =
reg_sr)
>  		if (likely(reg_msr & AT91_MSR_MRDY &&
>  			   ~reg_msr & AT91_MSR_MABT)) {
>  			/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
> -			can_get_echo_skb(dev, mb - get_mb_tx_first(priv), NULL);
> +			dev->stats.tx_bytes =3D
                                            +=3D ?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yjx3cdgtyh6ektcc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGuG/IACgkQqclaivrt
76kHGAf/eeW82yLFm3pp3ocLQd2I5RH8wp6Wa+wCXoHSRzTGwVADsy1ypNZR7XWs
g5NP776Fnz9w0NgnxxQ77Yevyvg2RxzCKH7YpPp30J/3BG60Ow9+9LEPqhGxsdDe
Rf8GiJmDgyDeVCI5jfcXvN+QXofDInFQt126Cpxw+t8MMGQCTd7KBzjnhI1mTJ8y
RqNd7IZus5l8pvYOgvXiDSy2Dq/hh7Pi/QZvjNXm9bnNRCmN/DR61FzCd0seI4t/
dCVEA3kL2Y/dpmwBIFVMipsfxQQ6m1jPZ71CmHLOmPIuS3vc3MEjyGS14/JSofvn
1OtNksaTQSO76PfB+21mwSFJOvyJyQ==
=GSxX
-----END PGP SIGNATURE-----

--yjx3cdgtyh6ektcc--
