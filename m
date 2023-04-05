Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628766D85DE
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjDESUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDESUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:20:21 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1C37689;
        Wed,  5 Apr 2023 11:20:12 -0700 (PDT)
Received: from mercury (dyndsl-091-248-212-122.ewe-ip-backbone.de [91.248.212.122])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 75B3866031B4;
        Wed,  5 Apr 2023 19:20:10 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680718810;
        bh=O1SmSIaEGwTASaQ4p6AtJMjiy2CQgrBY5WPfIwkrp5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fzAzEpU6ldXCM+XK3H6e+HZis/nAJchFpWM59ew9VuFeiMTYws6t0NpVWmCD8LiNb
         pZA4/SOCs/EIA5rfDlV8dMKiXJ72z2tH8HnZjLDn2DkSzx8zYtE13JoPGBjJTFM+eb
         EOoqF02Zip1wlCdQnoeCzb/VP0bNrdeiUNLXguk2zNWLZg4ifKNLsVkUgo+P1Mv3Mo
         ingtMZYWTLb17Wv7myGa1Vr2hxzg7rhCEG8rSiiDuoHXTuI8UXHWf5qgCiwbDxhqQV
         V5gK7vdN1yo2rJkUAmDs5rbmGhXOhPMUMvRKnfZRxFvvGQvByTcwH5/ywsriiYSt6E
         GBBKkrCLg/xJw==
Received: by mercury (Postfix, from userid 1000)
        id A88D5106125E; Wed,  5 Apr 2023 20:20:08 +0200 (CEST)
Date:   Wed, 5 Apr 2023 20:20:08 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCHv2 2/2] net: ethernet: stmmac: dwmac-rk: fix optional phy
 regulator handling
Message-ID: <20230405182008.tmegtq5xprkcwvss@mercury.elektranox.org>
References: <20230405161043.46190-1-sebastian.reichel@collabora.com>
 <20230405161043.46190-3-sebastian.reichel@collabora.com>
 <ZC2zMzaUMY0/VCRR@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4mi6hilgokkjkgxj"
Content-Disposition: inline
In-Reply-To: <ZC2zMzaUMY0/VCRR@corigine.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4mi6hilgokkjkgxj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

On Wed, Apr 05, 2023 at 07:43:15PM +0200, Simon Horman wrote:
> On Wed, Apr 05, 2023 at 06:10:43PM +0200, Sebastian Reichel wrote:
> > The usual devm_regulator_get() call already handles "optional"
> > regulators by returning a valid dummy and printing a warning
> > that the dummy regulator should be described properly. This
> > code open coded the same behaviour, but masked any errors that
> > are not -EPROBE_DEFER and is quite noisy.
> >=20
> > This change effectively unmasks and propagates regulators errors
> > not involving -ENODEV, downgrades the error print to warning level
> > if no regulator is specified and captures the probe defer message
> > for /sys/kernel/debug/devices_deferred.
> >=20
> > Fixes: 2e12f536635f8 ("net: stmmac: dwmac-rk: Use standard devicetree p=
roperty for phy regulator")
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/n=
et/ethernet/stmicro/stmmac/dwmac-rk.c
> > index 6fdad0f10d6f..d9deba110d4b 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > @@ -1656,14 +1656,11 @@ static struct rk_priv_data *rk_gmac_setup(struc=
t platform_device *pdev,
> >  		}
> >  	}
> > =20
> > -	bsp_priv->regulator =3D devm_regulator_get_optional(dev, "phy");
> > +	bsp_priv->regulator =3D devm_regulator_get(dev, "phy");
> >  	if (IS_ERR(bsp_priv->regulator)) {
> > -		if (PTR_ERR(bsp_priv->regulator) =3D=3D -EPROBE_DEFER) {
> > -			dev_err(dev, "phy regulator is not available yet, deferred probing\=
n");
> > -			return ERR_PTR(-EPROBE_DEFER);
> > -		}
> > -		dev_err(dev, "no regulator found\n");
> > -		bsp_priv->regulator =3D NULL;
>=20
> Does phy_power_on() need to be updated for this change?
> F.e. Does the bsp_priv->regulator =3D=3D NULL still make sense?

Yes, it can be removed (but does not hurt). The regulator API
returns NULL for devm_regulator_get when CONFIG_REGULATOR is
not enabled. But regulator_enable/regulator_disable are just
'return 0;' stubs for that case anyways.

-- Sebastian

> > +		ret =3D PTR_ERR(bsp_priv->regulator);
> > +		dev_err_probe(dev, ret, "failed to get phy regulator\n");
> > +		return ERR_PTR(ret);
> >  	}
> > =20
> >  	ret =3D of_property_read_string(dev->of_node, "clock_in_out", &string=
s);
> > --=20
> > 2.39.2
> >=20
>=20
> --=20
> To unsubscribe, send mail to kernel-unsubscribe@lists.collabora.co.uk.

--4mi6hilgokkjkgxj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmQtu8sACgkQ2O7X88g7
+ppRzA//QWUeFo5AdCjnToZr9ZTGZKoAOkYOoiXq5DvMYDdMSL6ibt8BGYJrSQ8/
M792jDTc9YSAAF5vhzIjRlNaJsJVTZmFHXTuS6axvZTl/YwcyhnEpkTSEyf4YQCT
Nh+BBl7Ie54dAAIgeowmcEwxnw736AIZczRCwjAz2/ZJm5WHXf2eXzTCifiav2V2
ouTdJEfWiUn5/UJj+m1tbdbfRO+UWE+bASkEWNArhYi/5RcC1dMWElatorRxHz/0
6aNaGmsRrC4XWETq/rpnvrDjDJO59NRpe43SkIiP5oB/HXb0MU6iAeuWtXbYr+G2
i7qBELe4WT4Uiz48Nub0bguVZad86bkVg8T4+rTtli/JcTtX8g6ai0iMdvY59+ui
y9B31VQD2KTupt5tU7wH10yvrS9KG9/c7qM2e4t1Iy7FuTtE2AaeFAdH85Wna+M/
Sfm7qhcJBL7dSprzg84JUIw0akvLUnWi56YW5NcZFWLc5PU0si0rdh6lBKQf7GyB
1VSseI4T37/ENwiyD359hkR3KHoK5fVzlkHacg3IBWd4KoUniJnnk39SPNPTeBEg
57BSO1DykUFrVSIdVqEz1UE6NMs9L/qrm1XEl4W2rwLe20ROfBpN43T+r8yxg45u
kw9DAyRKwsSzlMjaiUaDqisFn/rZIrlWD4AAz9Th/HK2vaJtUfU=
=x7Bi
-----END PGP SIGNATURE-----

--4mi6hilgokkjkgxj--
