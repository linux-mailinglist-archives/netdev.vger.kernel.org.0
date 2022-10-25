Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C2060C63A
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 10:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiJYITM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 04:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiJYITD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 04:19:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9A6C2CA8
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 01:19:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onF98-000755-1U; Tue, 25 Oct 2022 10:18:50 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 358BF109365;
        Tue, 25 Oct 2022 08:18:48 +0000 (UTC)
Date:   Tue, 25 Oct 2022 10:18:46 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20221025081846.kbabbavzlz72dwhc@pengutronix.de>
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
 <20221012062558.732930-3-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g4nb3ysqtgjqax7z"
Content-Disposition: inline
In-Reply-To: <20221012062558.732930-3-matej.vasilevski@seznam.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--g4nb3ysqtgjqax7z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.10.2022 08:25:56, Matej Vasilevski wrote:
> This patch adds support for retrieving hardware timestamps to RX and
> error CAN frames. It uses timecounter and cyclecounter structures,
> because the timestamping counter width depends on the IP core integration
> (it might not always be 64-bit).
> For platform devices, you should specify "ts" clock in device tree.
> For PCI devices, the timestamping frequency is assumed to be the same
> as bus frequency.
>=20
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>

[...]

> @@ -640,12 +663,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff=
 *skb, struct net_device *nde
>   * @priv:	Pointer to CTU CAN FD's private data
>   * @cf:		Pointer to CAN frame struct
>   * @ffw:	Previously read frame format word
> + * @skb:	Pointer to buffer to store timestamp
>   *
>   * Note: Frame format word must be read separately and provided in 'ffw'.
>   */
> -static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf, u32 ffw)
> +static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf,
> +				 u32 ffw, u64 *timestamp)

| drivers/net/can/ctucanfd/ctucanfd_base.c:672: warning: Function parameter=
 or member 'timestamp' not described in 'ctucan_read_rx_frame'             =
         =20
| drivers/net/can/ctucanfd/ctucanfd_base.c:672: warning: Excess function pa=
rameter 'skb' description in 'ctucan_read_rx_frame'    =20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--g4nb3ysqtgjqax7z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXm+QACgkQrX5LkNig
012zwwf9FauuUSSLqD54GBklBhQmf1EZjdawC3a0ZjhcJ4U6HBStuNAblr0Gb5QN
h6OvayKrGkGieXtiDWGK8JdOEucPIVX0/PAevGQWqk9R1XpJm+vVhGP4fZiGHUXh
mIEEktRPm29ZzDgGNeFc9CqHsFy6Cf5TlRBR90dqUUgYSaevXIhuz0Fbajyn4eSk
so1to5qiujGbLBVKdgIMamkuDqh22KQqkhh2phUoPd6RPBBncydn6dcUDlXa1wTj
7jCklcOqbRnGm0S1AX471uxUDFandscNWLlFbq73+6NHC2V0urNqTMVWQJwH1BZJ
8YPduKRWXD/dZhE5GmyBSPWKHfsL6A==
=XGgm
-----END PGP SIGNATURE-----

--g4nb3ysqtgjqax7z--
