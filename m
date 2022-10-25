Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B5060C80F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 11:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJYJ3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 05:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiJYJ2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 05:28:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240D613D10
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 02:25:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onGBY-0000jR-F6; Tue, 25 Oct 2022 11:25:24 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 72D3B10944C;
        Tue, 25 Oct 2022 09:25:22 +0000 (UTC)
Date:   Tue, 25 Oct 2022 11:25:20 +0200
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
Message-ID: <20221025092520.lz7qkafrwolwnbau@pengutronix.de>
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
 <20221012062558.732930-3-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2pqevftidrz3jehg"
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


--2pqevftidrz3jehg
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

>  int ctucan_suspend(struct device *dev)
> @@ -1337,12 +1456,41 @@ int ctucan_resume(struct device *dev)
>  }
>  EXPORT_SYMBOL(ctucan_resume);
> =20
> +int ctucan_runtime_suspend(struct device *dev)
> +{
> +	struct net_device *ndev =3D dev_get_drvdata(dev);
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +
> +	clk_disable_unprepare(priv->timestamp_clk);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ctucan_runtime_suspend);
> +
> +int ctucan_runtime_resume(struct device *dev)
> +{
> +	struct net_device *ndev =3D dev_get_drvdata(dev);
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +	int ret;
> +
> +	ret =3D clk_prepare_enable(priv->timestamp_clk);
> +	if (ret) {
> +		dev_err(dev, "Cannot enable timestamping clock: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ctucan_runtime_resume);

Regarding the timestamp_clk handling:

If you prepare_enable the timestamp_clk during probe_common() and don't
disable_unprepare it, it stays on the whole lifetime of the driver. So
there's no need/reason for the runtime suspend/resume functions.

So either keep the clock powered and remove the suspend/resume functions
or shut down the clock after probe.

If you want to make things 1000% clean, you can get the timestamp's
clock rate during open() and re-calculate the mult and shift. The
background is that the clock rate might change if the clock is not
enabled (at least that's not guaranteed by the common clock framework).
Actual HW implementations might differ.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2pqevftidrz3jehg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXq34ACgkQrX5LkNig
0137awgAl+o5l9VnGtWijsorYQSdAlZHIMgEBzaCdGHe45E7q/nvYSgyliBc7J6a
58GYkPDD0D7WH82InFuLecm//MqLImiXZZqoo9RaqsLMTjV12xV//vNPZIQoA0+I
FSLP9Gg/TZUN1ORPert99XZ+9u8ZcFHHQCGor9zSEf9GGc+iurMmG7eBNzX9KS9r
6TPJkifeuG0f+Sh7G8WVDxUjQ/I1j5xZ2Z0fat1yn9aTZVIVUpkeyNkKBKpf++hS
dc4xJGc85UeOLystjoaZTqENchO2zfVzK4YxEwVms93OcBtj4+OiQ5lNkYYnxVqn
gblQRt1atIAWuwlgNo7woeu6C38HSA==
=A8pO
-----END PGP SIGNATURE-----

--2pqevftidrz3jehg--
