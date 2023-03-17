Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4D16BF22C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCQUMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCQUMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:12:16 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C1C4BEA4;
        Fri, 17 Mar 2023 13:12:15 -0700 (PDT)
Received: from mercury (unknown [185.254.75.29])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 894AC66030C4;
        Fri, 17 Mar 2023 20:12:13 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1679083933;
        bh=c16sLiOeccS8KTDmT9/HV/tDsSJrCy5p/gbYAo6FcEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJ1Ha+QXhCX4LTUiUk1xtJscagAXDUfwikk1BCZY2AFYT1rbjaSWIyG7cxt7P2+/n
         6t1k2sOMzs8mCCqL5OWMGCBJQI0Cle0qCQvvZM96HFQ329v8X/vbP88R3rXp58m3LD
         loycqFZdKPZIXt/lP6ryUNwI3kibEtyJ0W856xfKVbr2VJQUY3GfM0Wqc5f7M0NV12
         exSd+LkInCPV5zMFt+18QrhlMgu1SzY0M62YHVPBsyy5T7PuEPT67/svqJzH6xv5Yj
         1GSx+Y3vqHBLpOTjtoOyy+3ZvrvjD4DRETuvWbZx0ri+K4Xv+PV3N/OCzWcxsKORo+
         bUqEw6RLvO8Tw==
Received: by mercury (Postfix, from userid 1000)
        id 5AD6710620FB; Fri, 17 Mar 2023 21:12:11 +0100 (CET)
Date:   Fri, 17 Mar 2023 21:12:11 +0100
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
Subject: Re: [PATCHv1 2/2] net: ethernet: stmmac: dwmac-rk: fix optional phy
 regulator handling
Message-ID: <20230317201211.24fubww5diviajva@mercury.elektranox.org>
References: <20230317174243.61500-1-sebastian.reichel@collabora.com>
 <20230317174243.61500-3-sebastian.reichel@collabora.com>
 <ZBSukvE/EEH5UsTQ@nimitz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jkubeakbqhht6epr"
Content-Disposition: inline
In-Reply-To: <ZBSukvE/EEH5UsTQ@nimitz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jkubeakbqhht6epr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 17, 2023 at 07:16:50PM +0100, Piotr Raczynski wrote:
> On Fri, Mar 17, 2023 at 06:42:43PM +0100, Sebastian Reichel wrote:
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
>=20
> Code looks fine, however this seems like a fix, then Fixes tag would
> be nice. Also target tree (net?) should be specified.

Fixes: 2e12f536635f8 ("net: stmmac: dwmac-rk: Use standard devicetree prope=
rty for phy regulator")

net-next should be good enough.

-- Sebastian

>=20
> >=20
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/n=
et/ethernet/stmicro/stmmac/dwmac-rk.c
> > index 126812cd17e6..01de0174fa18 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > @@ -1680,14 +1680,11 @@ static struct rk_priv_data *rk_gmac_setup(struc=
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

--jkubeakbqhht6epr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmQUyZsACgkQ2O7X88g7
+ppJEg/+JXUSw7gVtRZO0AqettGINoHQifLhrkRScYvQqIN5vYNqilTt4tZifkHe
0k5t2H3vYwNR7A+EP19VjQQ+4PnGjCYaB3Q02vDvi/IcqSizWqFd0dl16pWJRBSw
mYdG7NtSKmiz0BZg/TH6rQbh39nSO9FAziRNTAtCrmnHVWUZ1hXcGQwEONvCjRZ+
HzoNSuk+G8jd5dv28uaeImF3nW03iLceFbiyw1iXJQ7SaRD93kpw/ezgVFmLXl0R
r34KgeY/I7Hu8ARCL6y9Ef7kwTMfejixpc2JFHE6939tPAcrf6BloNqNO4dqicIm
LD/yHhCXGS6ZVp6aVF//Tq93bkPMsQwoXiLhuhcQP89f4+VCqRNuNjgv4us9VKBG
Caw9iqGTwGPwFsZYjLaZ8Wl4t5N51xt95xRVzeP93NVQ+8ufh/fgyTubqCrPa8UE
XWiHtb6QXzwBI70S9TGN9wy//WbB+bd2Hv0W6rFCSRckxY44DJzR3aAs3HLy2CVE
kxVvdW4M6toPjyI0TO8i8Fv/URmwO6maF6mebm6R+dm8Xkbk7tGdxy4kFxqff8U3
2CDDnwf6krvpjDlTn7QLL3+4BqHBQjMsTO9kCGmI8M48x5MsTI0700bFCDNxJgL0
p27QT+03gfYWaKV+rFCwUhNiOcrVmvNCJ3DQnGV4tZzBUYGTCNc=
=EnDp
-----END PGP SIGNATURE-----

--jkubeakbqhht6epr--
