Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D005227CD5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfEWM1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:27:15 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36787 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbfEWM1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 08:27:14 -0400
X-Originating-IP: 90.88.22.185
Received: from localhost (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8D5E060005;
        Thu, 23 May 2019 12:27:01 +0000 (UTC)
Date:   Thu, 23 May 2019 14:27:01 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
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
Message-ID: <20190523122701.qeuthkrczdzngzod@flea>
References: <20190520235009.16734-1-megous@megous.com>
 <20190520235009.16734-6-megous@megous.com>
 <20190521114611.ylmbo2oqeanveil4@flea>
 <20190521121519.k343dgv3cgpewjl2@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xaediv5ol6nrlghm"
Content-Disposition: inline
In-Reply-To: <20190521121519.k343dgv3cgpewjl2@core.my.home>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xaediv5ol6nrlghm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2019 at 02:15:19PM +0200, Ond=C5=99ej Jirman wrote:
> Hi Maxime,
>
> On Tue, May 21, 2019 at 01:46:11PM +0200, Maxime Ripard wrote:
> > Hi,
> >
> > On Tue, May 21, 2019 at 01:50:08AM +0200, megous@megous.com wrote:
> > > From: Ondrej Jirman <megous@megous.com>
> > >
> > > Orange Pi 3 board requires enabling a voltage shifting circuit via GP=
IO
> > > for the DDC bus to be usable.
> > >
> > > Add support for hdmi-connector node's optional ddc-en-gpios property =
to
> > > support this use case.
> > >
> > > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > > ---
> > >  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 55 +++++++++++++++++++++++++=
--
> > >  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h |  3 ++
> > >  2 files changed, 55 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/=
sun4i/sun8i_dw_hdmi.c
> > > index 39d8509d96a0..59b81ba02d96 100644
> > > --- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> > > +++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> > > @@ -98,6 +98,30 @@ static u32 sun8i_dw_hdmi_find_possible_crtcs(struc=
t drm_device *drm,
> > >  	return crtcs;
> > >  }
> > >
> > > +static int sun8i_dw_hdmi_find_connector_pdev(struct device *dev,
> > > +					     struct platform_device **pdev_out)
> > > +{
> > > +	struct platform_device *pdev;
> > > +	struct device_node *remote;
> > > +
> > > +	remote =3D of_graph_get_remote_node(dev->of_node, 1, -1);
> > > +	if (!remote)
> > > +		return -ENODEV;
> > > +
> > > +	if (!of_device_is_compatible(remote, "hdmi-connector")) {
> > > +		of_node_put(remote);
> > > +		return -ENODEV;
> > > +	}
> > > +
> > > +	pdev =3D of_find_device_by_node(remote);
> > > +	of_node_put(remote);
> > > +	if (!pdev)
> > > +		return -ENODEV;
> > > +
> > > +	*pdev_out =3D pdev;
> > > +	return 0;
> > > +}
> > > +
> > >  static int sun8i_dw_hdmi_bind(struct device *dev, struct device *mas=
ter,
> > >  			      void *data)
> > >  {
> > > @@ -151,16 +175,29 @@ static int sun8i_dw_hdmi_bind(struct device *de=
v, struct device *master,
> > >  		return PTR_ERR(hdmi->regulator);
> > >  	}
> > >
> > > +	ret =3D sun8i_dw_hdmi_find_connector_pdev(dev, &hdmi->connector_pde=
v);
> > > +	if (!ret) {
> > > +		hdmi->ddc_en =3D gpiod_get_optional(&hdmi->connector_pdev->dev,
> > > +						  "ddc-en", GPIOD_OUT_HIGH);
> > > +		if (IS_ERR(hdmi->ddc_en)) {
> > > +			platform_device_put(hdmi->connector_pdev);
> > > +			dev_err(dev, "Couldn't get ddc-en gpio\n");
> > > +			return PTR_ERR(hdmi->ddc_en);
> > > +		}
> > > +	}
> > > +
> > >  	ret =3D regulator_enable(hdmi->regulator);
> > >  	if (ret) {
> > >  		dev_err(dev, "Failed to enable regulator\n");
> > > -		return ret;
> > > +		goto err_unref_ddc_en;
> > >  	}
> > >
> > > +	gpiod_set_value(hdmi->ddc_en, 1);
> > > +
> >
> > Do you really need this to be done all the time? I'm guessing you
> > would only need this when running .get_modes, right?
>
> I don't think it hurts anything. Enabled voltage shifting circuit doesn't
> draw any current, unless DDC is actually transmitting data. On most boards
> I'd imagine this circuit is always on anyway (Orange Pi 3 schematic even =
has
> an option to tie this signal to VCC-IO instead of GPIO).

Ok, it works for me then

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--xaediv5ol6nrlghm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXOaRjgAKCRDj7w1vZxhR
xXP8AQDJFrAb2tEeZAxbO0lR5xA3HSBZ1CG8XwnZfh/DVcz7IgD/d1nl6k3ae3tz
jt35NpcG3EPiCyUUHN1/ZuAY6YBkHQc=
=qe05
-----END PGP SIGNATURE-----

--xaediv5ol6nrlghm--
