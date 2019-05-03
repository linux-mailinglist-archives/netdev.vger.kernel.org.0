Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403D313082
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfECOgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:36:49 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:51423 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfECOgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:36:48 -0400
Received: from localhost (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 563FE200020;
        Fri,  3 May 2019 14:36:44 +0000 (UTC)
Date:   Fri, 3 May 2019 16:36:43 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alban Bedel <albeu@free.fr>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] of_net: add NVMEM support to of_get_mac_address
Message-ID: <20190503143643.hhfamnptcuriav4k@flea>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
 <1556893635-18549-2-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w5grxr2nn7x6p3l6"
Content-Disposition: inline
In-Reply-To: <1556893635-18549-2-git-send-email-ynezz@true.cz>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w5grxr2nn7x6p3l6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 03, 2019 at 04:27:06PM +0200, Petr =C5=A0tetiar wrote:
> Many embedded devices have information such as MAC addresses stored
> inside NVMEMs like EEPROMs and so on. Currently there are only two
> drivers in the tree which benefit from NVMEM bindings.
>
> Adding support for NVMEM into every other driver would mean adding a lot
> of repetitive code. This patch allows us to configure MAC addresses in
> various devices like ethernet and wireless adapters directly from
> of_get_mac_address, which is already used by almost every driver in the
> tree.
>
> Predecessor of this patch which used directly MTD layer has originated
> in OpenWrt some time ago and supports already about 497 use cases in 357
> device tree files.
>
> Cc: Alban Bedel <albeu@free.fr>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: John Crispin <john@phrozen.org>
> Signed-off-by: Petr =C5=A0tetiar <ynezz@true.cz>
> ---
>
>  Changes since v1:
>
>   * moved handling of nvmem after mac-address and local-mac-address prope=
rties
>
>  Changes since v2:
>
>   * moved of_get_mac_addr_nvmem after of_get_mac_addr(np, "address") call
>   * replaced kzalloc, kmemdup and kfree with it's devm variants
>   * introduced of_has_nvmem_mac_addr helper which checks if DT node has n=
vmem
>     cell with `mac-address`
>   * of_get_mac_address now returns ERR_PTR encoded error value
>
>  Changes since v3:
>
>   * removed of_has_nvmem_mac_addr helper as it's not needed now
>   * of_get_mac_address now returns only valid pointer or ERR_PTR encoded =
error value
>
>  drivers/of/of_net.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++=
+++---
>  1 file changed, 51 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
> index d820f3e..9649cd5 100644
> --- a/drivers/of/of_net.c
> +++ b/drivers/of/of_net.c
> @@ -8,8 +8,10 @@
>  #include <linux/etherdevice.h>
>  #include <linux/kernel.h>
>  #include <linux/of_net.h>
> +#include <linux/of_platform.h>
>  #include <linux/phy.h>
>  #include <linux/export.h>
> +#include <linux/device.h>
>
>  /**
>   * of_get_phy_mode - Get phy mode for given device_node
> @@ -47,12 +49,52 @@ static const void *of_get_mac_addr(struct device_node=
 *np, const char *name)
>  	return NULL;
>  }
>
> +static const void *of_get_mac_addr_nvmem(struct device_node *np)
> +{
> +	int ret;
> +	u8 mac[ETH_ALEN];
> +	struct property *pp;
> +	struct platform_device *pdev =3D of_find_device_by_node(np);
> +
> +	if (!pdev)
> +		return ERR_PTR(-ENODEV);
> +
> +	ret =3D nvmem_get_mac_address(&pdev->dev, &mac);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	pp =3D devm_kzalloc(&pdev->dev, sizeof(*pp), GFP_KERNEL);
> +	if (!pp)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pp->name =3D "nvmem-mac-address";
> +	pp->length =3D ETH_ALEN;
> +	pp->value =3D devm_kmemdup(&pdev->dev, mac, ETH_ALEN, GFP_KERNEL);
> +	if (!pp->value) {
> +		ret =3D -ENOMEM;
> +		goto free;
> +	}
> +
> +	ret =3D of_add_property(np, pp);
> +	if (ret)
> +		goto free;
> +
> +	return pp->value;

I'm not sure why you need to do that allocation here, and why you need
to modify the DT?

can't you just return the mac address directly since it's what the
of_get_mac_address caller will expect anyway?

maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--w5grxr2nn7x6p3l6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXMxR8gAKCRDj7w1vZxhR
xbqcAP49YjJI7V+9AD9J0n1SEWgqSDf1RN9dCqV6WDaspNX5cAEA4l11UjhuTwp3
bsOoNNlu5yGF+MU5kr8sKmJYaWx7cAg=
=mHTC
-----END PGP SIGNATURE-----

--w5grxr2nn7x6p3l6--
