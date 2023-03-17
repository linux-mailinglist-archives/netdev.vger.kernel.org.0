Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4286F6BF213
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjCQUEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCQUEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:04:46 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958F1C9261;
        Fri, 17 Mar 2023 13:04:44 -0700 (PDT)
Received: from mercury (unknown [185.254.75.29])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 2AA4466030C4;
        Fri, 17 Mar 2023 20:04:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1679083483;
        bh=6VkdQ9psqUaKshJfhzoZVQyKORhNMnzeUFqYVonN1oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G/CLwaYQvRYH+vRxBZiG0wGq8tTkOyyEf0jhqhQ4j/AW/iqqLGeubsG4RqH+jhDmJ
         IYgOqfXHnGEZVVunRa3vxHjoZipj985oYG1EttIcVW+GkzzLLZYd48wOLB1gFtdBRc
         9f2dzRuBWChnLFLBurr3hUDmxy/4/ozvzipwO5wqnOmdoywwKsbndmSHDYMZKYKqGt
         NXbQvhrSLFa6JK6GmieBUfe8VwS2Y3mIeVz9sdDY2voUSktzr8n28thv0jWS+BGMWe
         8mwOF0vkViYqDHunAu4Pd8IEO2IGzwptElilILPK79WLmZKrvyrp2w/5ahoJrX4MyS
         mTu1dpG5W05rg==
Received: by mercury (Postfix, from userid 1000)
        id C41AF10620FB; Fri, 17 Mar 2023 21:04:40 +0100 (CET)
Date:   Fri, 17 Mar 2023 21:04:40 +0100
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
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
Subject: Re: [PATCHv1 1/2] net: ethernet: stmmac: dwmac-rk: fix optional
 clock handling
Message-ID: <20230317200440.vfy2y5ynuuig2peu@mercury.elektranox.org>
References: <20230317174243.61500-1-sebastian.reichel@collabora.com>
 <20230317174243.61500-2-sebastian.reichel@collabora.com>
 <ZBSwX+eBsE02A3Xz@nimitz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mpto7wro7k5znqiy"
Content-Disposition: inline
In-Reply-To: <ZBSwX+eBsE02A3Xz@nimitz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mpto7wro7k5znqiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 17, 2023 at 07:24:31PM +0100, Piotr Raczynski wrote:
> On Fri, Mar 17, 2023 at 06:42:42PM +0100, Sebastian Reichel wrote:
> > Right now any clock errors are printed and otherwise ignored.
> > This has multiple disadvantages:
> >=20
> > 1. it prints errors for clocks that do not exist (e.g. rk3588
> >    reports errors for "mac_clk_rx", "mac_clk_tx" and "clk_mac_speed")
> >=20
> > 2. it does not handle errors like -EPROBE_DEFER correctly
> >=20
> > This series fixes it by switching to devm_clk_get_optional(),
> > so that missing clocks are not considered an error and then
> > passing on any other errors using dev_err_probe().
> >=20
>=20
> Fixes tag would help here.

Fixes: 7ad269ea1a2b7 ("GMAC: add driver for Rockchip RK3288 SoCs integrated=
 GMAC")

That commit is from 2014-12-29. I only noticed the dev_err()
messages on RK3588, so going via -next without backporting should be fine.

Please tell me if I should resend with the Fixes tag.

-- Sebastian

> Piotr
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > ---
> >  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 47 ++++++++++---------
> >  1 file changed, 24 insertions(+), 23 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/n=
et/ethernet/stmicro/stmmac/dwmac-rk.c
> > index 4b8fd11563e4..126812cd17e6 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > @@ -1479,49 +1479,50 @@ static int rk_gmac_clk_init(struct plat_stmmace=
net_data *plat)
> > =20
> >  	bsp_priv->clk_enabled =3D false;
> > =20
> > -	bsp_priv->mac_clk_rx =3D devm_clk_get(dev, "mac_clk_rx");
> > +	bsp_priv->mac_clk_rx =3D devm_clk_get_optional(dev, "mac_clk_rx");
> >  	if (IS_ERR(bsp_priv->mac_clk_rx))
> > -		dev_err(dev, "cannot get clock %s\n",
> > -			"mac_clk_rx");
> > +		return dev_err_probe(dev, PTR_ERR(bsp_priv->mac_clk_rx),
> > +				"cannot get clock %s\n", "mac_clk_rx");
> > =20
> > -	bsp_priv->mac_clk_tx =3D devm_clk_get(dev, "mac_clk_tx");
> > +	bsp_priv->mac_clk_tx =3D devm_clk_get_optional(dev, "mac_clk_tx");
> >  	if (IS_ERR(bsp_priv->mac_clk_tx))
> > -		dev_err(dev, "cannot get clock %s\n",
> > -			"mac_clk_tx");
> > +		return dev_err_probe(dev, PTR_ERR(bsp_priv->mac_clk_tx),
> > +				"cannot get clock %s\n", "mac_clk_tx");
> > =20
> > -	bsp_priv->aclk_mac =3D devm_clk_get(dev, "aclk_mac");
> > +	bsp_priv->aclk_mac =3D devm_clk_get_optional(dev, "aclk_mac");
> >  	if (IS_ERR(bsp_priv->aclk_mac))
> > -		dev_err(dev, "cannot get clock %s\n",
> > -			"aclk_mac");
> > +		return dev_err_probe(dev, PTR_ERR(bsp_priv->aclk_mac),
> > +				"cannot get clock %s\n", "aclk_mac");
> > =20
> > -	bsp_priv->pclk_mac =3D devm_clk_get(dev, "pclk_mac");
> > +	bsp_priv->pclk_mac =3D devm_clk_get_optional(dev, "pclk_mac");
> >  	if (IS_ERR(bsp_priv->pclk_mac))
> > -		dev_err(dev, "cannot get clock %s\n",
> > -			"pclk_mac");
> > +		return dev_err_probe(dev, PTR_ERR(bsp_priv->pclk_mac),
> > +				"cannot get clock %s\n", "pclk_mac");
> > =20
> > -	bsp_priv->clk_mac =3D devm_clk_get(dev, "stmmaceth");
> > +	bsp_priv->clk_mac =3D devm_clk_get_optional(dev, "stmmaceth");
> >  	if (IS_ERR(bsp_priv->clk_mac))
> > -		dev_err(dev, "cannot get clock %s\n",
> > -			"stmmaceth");
> > +		return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac),
> > +				"cannot get clock %s\n", "stmmaceth");
> > =20
> >  	if (bsp_priv->phy_iface =3D=3D PHY_INTERFACE_MODE_RMII) {
> > -		bsp_priv->clk_mac_ref =3D devm_clk_get(dev, "clk_mac_ref");
> > +		bsp_priv->clk_mac_ref =3D devm_clk_get_optional(dev, "clk_mac_ref");
> >  		if (IS_ERR(bsp_priv->clk_mac_ref))
> > -			dev_err(dev, "cannot get clock %s\n",
> > -				"clk_mac_ref");
> > +			return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_ref),
> > +					"cannot get clock %s\n", "clk_mac_ref");
> > =20
> >  		if (!bsp_priv->clock_input) {
> >  			bsp_priv->clk_mac_refout =3D
> > -				devm_clk_get(dev, "clk_mac_refout");
> > +				devm_clk_get_optional(dev, "clk_mac_refout");
> >  			if (IS_ERR(bsp_priv->clk_mac_refout))
> > -				dev_err(dev, "cannot get clock %s\n",
> > -					"clk_mac_refout");
> > +				return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_refout),
> > +						"cannot get clock %s\n", "clk_mac_refout");
> >  		}
> >  	}
> > =20
> > -	bsp_priv->clk_mac_speed =3D devm_clk_get(dev, "clk_mac_speed");
> > +	bsp_priv->clk_mac_speed =3D devm_clk_get_optional(dev, "clk_mac_speed=
");
> >  	if (IS_ERR(bsp_priv->clk_mac_speed))
> > -		dev_err(dev, "cannot get clock %s\n", "clk_mac_speed");
> > +		return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_speed),
> > +				"cannot get clock %s\n", "clk_mac_speed");
> > =20
> >  	if (bsp_priv->clock_input) {
> >  		dev_info(dev, "clock input from PHY\n");
> > --=20
> > 2.39.2
> >=20
>=20
> --=20
> To unsubscribe, send mail to kernel-unsubscribe@lists.collabora.co.uk.

--mpto7wro7k5znqiy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmQUx9UACgkQ2O7X88g7
+prqRw/8Ctg9+w0APsrUuwOaK7iZRmPegyPuRJbtX0HwN2xzMO/PoLln7K0shhoj
iOaEbyyelqJBRjQXXf6GVrOPVfOW52/MOk0CZoYRsBNJCTdJYUJfweGTQUb9sp67
rzmJ4Q44/hDNVLnNGJdC/WlJnqdmVwCpzw+vO2yn6TqFOKBgu/gHF5FjPPC9+cGm
130I0Xx77VAeWaw6nkkVokYzjMYfPyv4InWtZqWjb9yTUTKqGljz+xwaWtOqdmx2
ZXQ15m/nq7COzGkuoU0WiyNtH7JOoCjE+neAMh0iw6xeUZ4iPuAd7DT5TWnHuyLg
E/QiNQTKWvtGEvODEBvB1gyYz27x2NM6B4j9heVQGl6v6SFBcRqz+F8uOW5zfQLA
Zr6Fgq7wyKd4LngIG+T1Ng2cZCGuPARZIQFj/FICYki85//nZ7ztDwLEetzZ1x5E
P+uIbdo0AtzI5HmyGug4B9xAZv8+Q//NG49ZPrTGAyMD2yihpC+5/gTi/4+tJ4Rf
jcWao/BLcKbyI3x07AqPXxu7xniRogugm7KdgMaibyvxTTLMsrr5z2amU56wJZqG
qXpA/HRdLvkxbWDlkArTmFnWSmhwsgHXXMx7WaFJaNQiB7jQWA2VuararLsvA0vA
znh9GxIuZPAsYacRSgWNhSozMoDsq80ea6RchqzW0NI9WoRgLts=
=lhD9
-----END PGP SIGNATURE-----

--mpto7wro7k5znqiy--
