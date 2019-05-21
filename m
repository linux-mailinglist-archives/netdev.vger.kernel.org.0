Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942BA24EBF
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 14:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfEUMPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 08:15:23 -0400
Received: from vps.xff.cz ([195.181.215.36]:38886 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfEUMPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 08:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1558440920; bh=VGlJ9wO7InEXoKlQsJrI3YYXQgBrZfsVum4dwV9O/qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H8itSFBTgfJexSfOsuGiRevevVee8AWok+TNwvYGh7+dE1NYC7HRI8brRhf87wLga
         d9QkGESJyeoaSCyRYs3EQ2grPw+h1Uha56OooMFMOlk4Sm5xTp26Bz32P9/VowQFZP
         xDHQqFWmk/FSFXR/1nm1hEhj9MMSZ7GIUAjIabwA=
Date:   Tue, 21 May 2019 14:15:19 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
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
Message-ID: <20190521121519.k343dgv3cgpewjl2@core.my.home>
Mail-Followup-To: Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>, David Airlie <airlied@linux.ie>,
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
References: <20190520235009.16734-1-megous@megous.com>
 <20190520235009.16734-6-megous@megous.com>
 <20190521114611.ylmbo2oqeanveil4@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521114611.ylmbo2oqeanveil4@flea>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Tue, May 21, 2019 at 01:46:11PM +0200, Maxime Ripard wrote:
> Hi,
> 
> On Tue, May 21, 2019 at 01:50:08AM +0200, megous@megous.com wrote:
> > From: Ondrej Jirman <megous@megous.com>
> >
> > Orange Pi 3 board requires enabling a voltage shifting circuit via GPIO
> > for the DDC bus to be usable.
> >
> > Add support for hdmi-connector node's optional ddc-en-gpios property to
> > support this use case.
> >
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > ---
> >  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 55 +++++++++++++++++++++++++--
> >  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h |  3 ++
> >  2 files changed, 55 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> > index 39d8509d96a0..59b81ba02d96 100644
> > --- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> > +++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> > @@ -98,6 +98,30 @@ static u32 sun8i_dw_hdmi_find_possible_crtcs(struct drm_device *drm,
> >  	return crtcs;
> >  }
> >
> > +static int sun8i_dw_hdmi_find_connector_pdev(struct device *dev,
> > +					     struct platform_device **pdev_out)
> > +{
> > +	struct platform_device *pdev;
> > +	struct device_node *remote;
> > +
> > +	remote = of_graph_get_remote_node(dev->of_node, 1, -1);
> > +	if (!remote)
> > +		return -ENODEV;
> > +
> > +	if (!of_device_is_compatible(remote, "hdmi-connector")) {
> > +		of_node_put(remote);
> > +		return -ENODEV;
> > +	}
> > +
> > +	pdev = of_find_device_by_node(remote);
> > +	of_node_put(remote);
> > +	if (!pdev)
> > +		return -ENODEV;
> > +
> > +	*pdev_out = pdev;
> > +	return 0;
> > +}
> > +
> >  static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
> >  			      void *data)
> >  {
> > @@ -151,16 +175,29 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
> >  		return PTR_ERR(hdmi->regulator);
> >  	}
> >
> > +	ret = sun8i_dw_hdmi_find_connector_pdev(dev, &hdmi->connector_pdev);
> > +	if (!ret) {
> > +		hdmi->ddc_en = gpiod_get_optional(&hdmi->connector_pdev->dev,
> > +						  "ddc-en", GPIOD_OUT_HIGH);
> > +		if (IS_ERR(hdmi->ddc_en)) {
> > +			platform_device_put(hdmi->connector_pdev);
> > +			dev_err(dev, "Couldn't get ddc-en gpio\n");
> > +			return PTR_ERR(hdmi->ddc_en);
> > +		}
> > +	}
> > +
> >  	ret = regulator_enable(hdmi->regulator);
> >  	if (ret) {
> >  		dev_err(dev, "Failed to enable regulator\n");
> > -		return ret;
> > +		goto err_unref_ddc_en;
> >  	}
> >
> > +	gpiod_set_value(hdmi->ddc_en, 1);
> > +
> 
> Do you really need this to be done all the time? I'm guessing you
> would only need this when running .get_modes, right?

I don't think it hurts anything. Enabled voltage shifting circuit doesn't
draw any current, unless DDC is actually transmitting data. On most boards
I'd imagine this circuit is always on anyway (Orange Pi 3 schematic even has
an option to tie this signal to VCC-IO instead of GPIO).

Schematic: https://megous.com/dl/tmp/bfcdd32d655aaa76.png

thank you and regards,
	o.

> Maxime
> 
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


