Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B159203879
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgFVNvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbgFVNvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:51:08 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B123520716;
        Mon, 22 Jun 2020 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592833868;
        bh=efQ2lDxw4orBAR8yTf7yEpmQfUZp69/5ULtJyw6nOzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A1SH9hNwY8l0W0enC1ZspWW73Xl3Z/4jfvlMzVwkHsFnR94Y8iuHVe1FJcqjzhO6+
         Ryexj938pdk0R5DqvqwXjfBilF4TLbOzNkNEH/8nk/Wez9GQ8g787O8Na/WsD35mXT
         kac8fNojgV4pwdCt5XeO8Y3C0EXooEWHoILZjvA4=
Date:   Mon, 22 Jun 2020 14:51:06 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 09/15] net: phy: delay PHY driver probe until PHY
 registration
Message-ID: <20200622135106.GK4560@sirena.org.uk>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-10-brgl@bgdev.pl>
 <20200622133940.GL338481@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8kI7hWEHMS8Z+7/0"
Content-Disposition: inline
In-Reply-To: <20200622133940.GL338481@lunn.ch>
X-Cookie: laser, n.:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8kI7hWEHMS8Z+7/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 22, 2020 at 03:39:40PM +0200, Andrew Lunn wrote:

> The PHY subsystem cannot be the first to run into this problem, that
> you need a device structure to make use of the regulator API, but you
> need the regulator API to probe the device. How do other subsystems
> work around this?

If the bus includes power management for the devices on the bus the
controller is generally responsible for that rather than the devices,
the devices access this via facilities provided by the bus if needed.
If the device is enumerated by firmware prior to being physically
enumerable then the bus will generally instantiate the device model
device and then arrange to wait for the physical device to appear and
get joined up with the device model device, typically in such situations
the physical device might appear and disappear dynamically at runtime
based on what the driver is doing anyway.

> Maybe it is time to add a lower level API to the regulator framework?

I don't see any need for that here, this is far from the only thing
that's keyed off a struct device and having the device appear and
disappear at runtime can make things like runtime PM look really messy
to userspace.

We could use a pre-probe stage in the device model for hotpluggable
buses in embedded contexts where you might need to bring things out of
reset or power them up before they'll appear on the bus for enumeration
but buses have mostly handled that at their level.

--8kI7hWEHMS8Z+7/0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7wt0kACgkQJNaLcl1U
h9DojAgAg2xKTg4gIiJrHsBsTywL4IZkKlRMbm2PDJ5+lsXLkRzZ+JOxic+SS0U8
uHnzeaqi/Yk+hMYR/7U8rZSS9zznj/fnnr62B3jCi2m2kfLlhzELzITMLYAw7a2x
LEjxS/xad/vvPekNstKWQ8UDXDvfXJ0rrpvRF4S2XoJnoAd+LWoPwSZwmEdVuWWi
RwVjPihfj16iMUsIGjWk+po1ac0U9CLeszltaxsk0l4xpp4AVfPLOyhgph5usA32
1BIpHC1jyP8OBeHCFFPaokc7KmL1u+gxL5MyYlsZJ2Uw7bBdtPI844oXVYy3/fFQ
rDS4EhjpcMeQGFZ1a3DJHlIFu7xs6Q==
=Itk7
-----END PGP SIGNATURE-----

--8kI7hWEHMS8Z+7/0--
