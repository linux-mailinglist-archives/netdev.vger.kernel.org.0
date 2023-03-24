Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF16C81E6
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjCXPyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjCXPyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:54:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6351B1969A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:54:36 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pfjkE-0003wQ-UE; Fri, 24 Mar 2023 16:54:23 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0D55919B9E7;
        Fri, 24 Mar 2023 15:54:19 +0000 (UTC)
Date:   Fri, 24 Mar 2023 16:54:18 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        michael@amarulasolutions.com, Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v7 5/5] can: bxcan: add support for ST bxCAN
 controller
Message-ID: <20230324155418.nn44wxwjjjiqqhdf@pengutronix.de>
References: <20230315211040.2455855-1-dario.binacchi@amarulasolutions.com>
 <20230315211040.2455855-6-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cpmjthz5s44cl3qg"
Content-Disposition: inline
In-Reply-To: <20230315211040.2455855-6-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cpmjthz5s44cl3qg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.03.2023 22:10:40, Dario Binacchi wrote:
[...]

> +static int __maybe_unused bxcan_suspend(struct device *dev)
> +{
> +	struct net_device *ndev =3D dev_get_drvdata(dev);
> +	struct bxcan_priv *priv =3D netdev_priv(ndev);
> +
> +	if (!netif_running(ndev))
> +		return 0;
> +
> +	netif_stop_queue(ndev);
> +	netif_device_detach(ndev);
> +
> +	bxcan_enter_sleep_mode(priv);
> +	priv->can.state =3D CAN_STATE_SLEEPING;
> +	clk_disable_unprepare(priv->clk);

The driver enabled the clock in probe, right? So in case the interface
is down you don't disable the clock and keep it running during
suspend. Is this a problem?

You can disable the clock in probe and enable it in open/disable in
close.

> +	return 0;
> +}

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cpmjthz5s44cl3qg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQdx6cACgkQvlAcSiqK
BOhIzAf/QrMxYd4klMcThRsnQ4udN8k2Eaj/CiWuJ172yNqr0dk3sAwYuvvpbwal
R1HzHoAkcTECNx+HOmGYSmZKNDONrWm84brl+wsZPSPIY1BmguVe3MyDKVD8Hv5/
Mu8eMml9CzKNdvV6n1GpCiCOGl4QTAJzRxVmzJ7QH1UTlXSWj8z0jh3JEP/SBp5Q
uyZM4JyS+UbFCz6Ic5Vdnod+1kGJfC9oN8hYkp91s1WEmGkYvZjWzrK1Etuycch0
Sugr0VPvKlxSQ8Mi0heuO7ms09iF3pgs1k6SVSpKHhNAEXS/wTmdT4IHQqljaPDR
o9JdAlJOEEXmCRL+Bb/AwISMZSv2uA==
=8O6F
-----END PGP SIGNATURE-----

--cpmjthz5s44cl3qg--
