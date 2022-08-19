Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFE759A760
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351837AbiHSUzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 16:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352041AbiHSUyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 16:54:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA41310EEF6;
        Fri, 19 Aug 2022 13:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EM8M9rtfttMconDtRzIUZchXg2tD3wTiMgn/nNNDO2g=; b=Gq/dX8+bnXufoMznu+Ys8x6HYO
        uW7uu6loPC0u43fvejcFAcQ55RMAgNReEze2cGKBKo+GwkHAJzCJ+Xa7b+PBUNxtFfu4re5bLvmeu
        oJnzcMMAMXC+RPnxN534UgiLQ7FJoc+PEGXfFtWFrSQRj3Y3KOSVYJBBAXMCazAsbhLA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oP90Q-00Dx9i-OW; Fri, 19 Aug 2022 22:54:14 +0200
Date:   Fri, 19 Aug 2022 22:54:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 4/7] net: pse-pd: add generic PSE driver
Message-ID: <Yv/4du75DNO2Xykr@lunn.ch>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819120109.3857571-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 02:01:06PM +0200, Oleksij Rempel wrote:
> Add generic driver to support simple Power Sourcing Equipment without
> automatic classification support.
> 
> This driver was tested on 10Bast-T1L switch with regulator based PoDL PSE.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/pse-pd/Kconfig       |  11 +++
>  drivers/net/pse-pd/Makefile      |   2 +
>  drivers/net/pse-pd/pse_generic.c | 146 +++++++++++++++++++++++++++++++
>  3 files changed, 159 insertions(+)
>  create mode 100644 drivers/net/pse-pd/pse_generic.c
> 
> diff --git a/drivers/net/pse-pd/Kconfig b/drivers/net/pse-pd/Kconfig
> index 49c7f0bcff526..a804c9f1af2bc 100644
> --- a/drivers/net/pse-pd/Kconfig
> +++ b/drivers/net/pse-pd/Kconfig
> @@ -9,3 +9,14 @@ menuconfig PSE_CONTROLLER
>  	  Generic Power Sourcing Equipment Controller support.
>  
>  	  If unsure, say no.
> +
> +if PSE_CONTROLLER
> +
> +config PSE_GENERIC
> +	tristate "Generic PSE driver"
> +	help
> +	  This module provides support for simple Ethernet Power Sourcing
> +	  Equipment without automatic classification support. For example for
> +	  PoDL (802.3bu) specification.
> +
> +endif
> diff --git a/drivers/net/pse-pd/Makefile b/drivers/net/pse-pd/Makefile
> index cbb79fc2e2706..80ef39ad68f10 100644
> --- a/drivers/net/pse-pd/Makefile
> +++ b/drivers/net/pse-pd/Makefile
> @@ -2,3 +2,5 @@
>  # Makefile for Linux PSE drivers
>  
>  obj-$(CONFIG_PSE_CONTROLLER) += pse-core.o
> +
> +obj-$(CONFIG_PSE_GENERIC) += pse_generic.o
> diff --git a/drivers/net/pse-pd/pse_generic.c b/drivers/net/pse-pd/pse_generic.c
> new file mode 100644
> index 0000000000000..f264d4d589f59
> --- /dev/null
> +++ b/drivers/net/pse-pd/pse_generic.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//
> +// Driver for the Generic Ethernet Power Sourcing Equipment, without
> +// auto classification support.
> +//
> +// Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
> +//
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pse-pd/pse.h>
> +#include <linux/regulator/consumer.h>
> +
> +struct gen_pse_priv {
> +	struct pse_controller_dev pcdev;
> +	struct regulator *ps; /*power source */
> +	enum ethtool_podl_pse_admin_state admin_state;
> +};
> +
> +static struct gen_pse_priv *to_gen_pse(struct pse_controller_dev *pcdev)
> +{
> +	return container_of(pcdev, struct gen_pse_priv, pcdev);
> +}
> +
> +static int
> +gen_pse_podl_get_admin_sate(struct pse_controller_dev *pcdev, unsigned long id)

Should that be state?

> +{
> +	struct gen_pse_priv *priv = to_gen_pse(pcdev);
> +
> +	/* aPoDLPSEAdminState can be different to aPoDLPSEPowerDetectionStatus
> +	 * which is provided by the regulator.
> +	 */
> +	return priv->admin_state;
> +}
> +
> +static int
> +gen_pse_podl_set_admin_control(struct pse_controller_dev *pcdev,
> +			       unsigned long id,
> +			       enum ethtool_podl_pse_admin_state state)
> +{
> +	struct gen_pse_priv *priv = to_gen_pse(pcdev);
> +	int ret;
> +
> +	if (priv->admin_state == state)
> +		goto set_state;

return 0; ?

> +
> +	switch (state) {
> +	case ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED:
> +		ret = regulator_enable(priv->ps);
> +		break;
> +	case ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED:
> +		ret = regulator_disable(priv->ps);
> +		break;
> +	default:
> +		dev_err(pcdev->dev, "Unknown admin state %i\n", state);
> +		ret = -ENOTSUPP;
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +set_state:
> +	priv->admin_state = state;
> +
> +	return 0;
> +}
> +
> +static int
> +gen_pse_podl_get_pw_d_status(struct pse_controller_dev *pcdev, unsigned long id)
> +{
> +	struct gen_pse_priv *priv = to_gen_pse(pcdev);
> +	int ret;
> +
> +	ret = regulator_is_enabled(priv->ps);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!ret)
> +		return ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED;
> +
> +	return ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING;
> +}
> +
> +static const struct pse_control_ops gen_pse_ops = {
> +	.get_podl_pse_admin_sate = gen_pse_podl_get_admin_sate,
> +	.set_podl_pse_admin_control = gen_pse_podl_set_admin_control,
> +	.get_podl_pse_pw_d_status = gen_pse_podl_get_pw_d_status,
> +};
> +
> +static int
> +gen_pse_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct gen_pse_priv *priv;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENOENT;
> +
> +	priv->ps = devm_regulator_get(dev, "ieee802.3-podl-pse");
> +	if (IS_ERR(priv->ps)) {
> +		dev_err(dev, "failed to get PSE regulator (%pe)\n", priv->ps);
> +		return PTR_ERR(priv->ps);
> +	}
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	priv->admin_state = ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED;

There is the comment earlier:

	/* aPoDLPSEAdminState can be different to aPoDLPSEPowerDetectionStatus
	 * which is provided by the regulator.

Is this because the regulator might of been turned on, but it has
detected a short and turned itself off? So it is administratively on,
but off in order to stop the magic smoke escaping?

But what about the other way around? Something has already turned the
regulator on, e.g. the bootloader. Should the default be
ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED even thought power is being
delivered? Do we want to put the regulator into the off state at
probe, so it is in a well defined state? Or set priv->admin_state to
whatever regulator_is_enabled() indicates?

	 Andrew
