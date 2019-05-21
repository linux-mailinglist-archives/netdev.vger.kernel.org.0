Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7714B24E4B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 13:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfEULqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 07:46:22 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:51117 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfEULqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 07:46:22 -0400
X-Originating-IP: 90.88.22.185
Received: from localhost (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id A025C2000B;
        Tue, 21 May 2019 11:46:11 +0000 (UTC)
Date:   Tue, 21 May 2019 13:46:11 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v5 5/6] drm: sun4i: Add support for enabling DDC I2C bus
 to sun8i_dw_hdmi glue
Message-ID: <20190521114611.ylmbo2oqeanveil4@flea>
References: <20190520235009.16734-1-megous@megous.com>
 <20190520235009.16734-6-megous@megous.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rjlukvbwopyqxnek"
Content-Disposition: inline
In-Reply-To: <20190520235009.16734-6-megous@megous.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rjlukvbwopyqxnek
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, May 21, 2019 at 01:50:08AM +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
>
> Orange Pi 3 board requires enabling a voltage shifting circuit via GPIO
> for the DDC bus to be usable.
>
> Add support for hdmi-connector node's optional ddc-en-gpios property to
> support this use case.
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 55 +++++++++++++++++++++++++--
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h |  3 ++
>  2 files changed, 55 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> index 39d8509d96a0..59b81ba02d96 100644
> --- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> +++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> @@ -98,6 +98,30 @@ static u32 sun8i_dw_hdmi_find_possible_crtcs(struct drm_device *drm,
>  	return crtcs;
>  }
>
> +static int sun8i_dw_hdmi_find_connector_pdev(struct device *dev,
> +					     struct platform_device **pdev_out)
> +{
> +	struct platform_device *pdev;
> +	struct device_node *remote;
> +
> +	remote = of_graph_get_remote_node(dev->of_node, 1, -1);
> +	if (!remote)
> +		return -ENODEV;
> +
> +	if (!of_device_is_compatible(remote, "hdmi-connector")) {
> +		of_node_put(remote);
> +		return -ENODEV;
> +	}
> +
> +	pdev = of_find_device_by_node(remote);
> +	of_node_put(remote);
> +	if (!pdev)
> +		return -ENODEV;
> +
> +	*pdev_out = pdev;
> +	return 0;
> +}
> +
>  static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
>  			      void *data)
>  {
> @@ -151,16 +175,29 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
>  		return PTR_ERR(hdmi->regulator);
>  	}
>
> +	ret = sun8i_dw_hdmi_find_connector_pdev(dev, &hdmi->connector_pdev);
> +	if (!ret) {
> +		hdmi->ddc_en = gpiod_get_optional(&hdmi->connector_pdev->dev,
> +						  "ddc-en", GPIOD_OUT_HIGH);
> +		if (IS_ERR(hdmi->ddc_en)) {
> +			platform_device_put(hdmi->connector_pdev);
> +			dev_err(dev, "Couldn't get ddc-en gpio\n");
> +			return PTR_ERR(hdmi->ddc_en);
> +		}
> +	}
> +
>  	ret = regulator_enable(hdmi->regulator);
>  	if (ret) {
>  		dev_err(dev, "Failed to enable regulator\n");
> -		return ret;
> +		goto err_unref_ddc_en;
>  	}
>
> +	gpiod_set_value(hdmi->ddc_en, 1);
> +

Do you really need this to be done all the time? I'm guessing you
would only need this when running .get_modes, right?

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--rjlukvbwopyqxnek
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXOPlAwAKCRDj7w1vZxhR
xXfLAPkBCXreeTOBxlliLT+vNeIHXqJAXge39oQ9DnnSMZXH+QEA8gYAqMyb5uND
MB0Ogchlc9aPOpC+/ynIMTSFjk0AgQU=
=yRtx
-----END PGP SIGNATURE-----

--rjlukvbwopyqxnek--
