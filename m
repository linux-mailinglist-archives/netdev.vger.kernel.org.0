Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8D7E0F85
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732192AbfJWA7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:59:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbfJWA7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 20:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=11Vqwg4tXNQgzPmbrmiQIKL9Uv3EImVmIGVjIdVb9yU=; b=eAkFbQ19AOy7AcPuIFcXCdVsDf
        JukmpNkaPhfE7/BXHZOtsyr0UiuHZycgZZ2PdTrXvtiAt3EOrnJgCETuXC9i9K/HsBp9RhEayFkD/
        OOYt75aWxodQDyKP+IO6khMejbYuUte29Mqn9Vo8Lg8bR++heb/mS/HFYwiAMfGqLtjA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iN4zC-0004Ox-CT; Wed, 23 Oct 2019 02:58:50 +0200
Date:   Wed, 23 Oct 2019 02:58:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v4 5/5] net: dsa: add support for Atheros AR9331 build-in
 switch
Message-ID: <20191023005850.GG5707@lunn.ch>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022055743.6832-6-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -52,6 +52,8 @@ source "drivers/net/dsa/microchip/Kconfig"
>  
>  source "drivers/net/dsa/mv88e6xxx/Kconfig"
>  
> +source "drivers/net/dsa/qca/Kconfig"
> +
>  source "drivers/net/dsa/sja1105/Kconfig"
>  
>  config NET_DSA_QCA8K

> diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
> new file mode 100644
> index 000000000000..7e4978f46642
> --- /dev/null
> +++ b/drivers/net/dsa/qca/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config NET_DSA_AR9331
> +	tristate "Atheros AR9331 Ethernet switch support"

This is where things are a little bit unobvious. If you do
make menu

and go into the DSA menu, you will find the drivers are all sorted
into Alphabetic order, based on the tristate text. But you have
inserted your "Atheros AR9331", after "NXP SJA1105".

It would probably be best if you make the tristate "Qualcomm Atheros
AR9331 ...". The order would be correct then,

> +static int ar9331_sw_port_enable(struct dsa_switch *ds, int port,
> +				 struct phy_device *phy)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	/* nothing to enable. Just set link to initial state */
> +	ret = regmap_write(regmap, AR9331_SW_REG_PORT_STATUS(port), 0);
> +	if (ret)
> +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static void ar9331_sw_port_disable(struct dsa_switch *ds, int port)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_PORT_STATUS(port), 0);
> +	if (ret)
> +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +}

I've asked this before, but i don't remember the answer. Why are
port_enable and port_disable the same?

> +static int ar9331_sw_irq_init(struct ar9331_sw_priv *priv)
> +{
> +	struct device_node *np = priv->dev->of_node;
> +	struct device *dev = priv->dev;
> +	int ret, irq;
> +
> +	irq = of_irq_get(np, 0);
> +	if (irq <= 0) {
> +		dev_err(dev, "failed to get parent IRQ\n");
> +		return irq ? irq : -EINVAL;
> +	}
> +
> +	ret = devm_request_threaded_irq(dev, irq, NULL, ar9331_sw_irq,
> +					IRQF_ONESHOT, AR9331_SW_NAME, priv);
> +	if (ret) {
> +		dev_err(dev, "unable to request irq: %d\n", ret);
> +		return ret;
> +	}
> +
> +	priv->irqdomain = irq_domain_add_linear(np, 1, &ar9331_sw_irqdomain_ops,
> +						priv);
> +	if (!priv->irqdomain) {
> +		dev_err(dev, "failed to create IRQ domain\n");
> +		return -EINVAL;
> +	}
> +
> +	irq_set_parent(irq_create_mapping(priv->irqdomain, 0), irq);
> +
> +	return 0;
> +}


> +static int ar9331_sw_probe(struct mdio_device *mdiodev)
> +{
> +	struct ar9331_sw_priv *priv;
> +	int ret;
> +
> +	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->regmap = devm_regmap_init(&mdiodev->dev, &ar9331_sw_bus, priv,
> +					&ar9331_mdio_regmap_config);
> +	if (IS_ERR(priv->regmap)) {
> +		ret = PTR_ERR(priv->regmap);
> +		dev_err(&mdiodev->dev, "regmap init failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	priv->sw_reset = devm_reset_control_get(&mdiodev->dev, "switch");
> +	if (IS_ERR(priv->sw_reset)) {
> +		dev_err(&mdiodev->dev, "missing switch reset\n");
> +		return PTR_ERR(priv->sw_reset);
> +	}
> +
> +	priv->sbus = mdiodev->bus;
> +	priv->dev = &mdiodev->dev;
> +
> +	ret = ar9331_sw_irq_init(priv);
> +	if (ret)
> +		return ret;
> +
> +	priv->ds = dsa_switch_alloc(&mdiodev->dev, AR9331_SW_PORTS);
> +	if (!priv->ds)
> +		return -ENOMEM;
> +
> +	priv->ds->priv = priv;
> +	priv->ops = ar9331_sw_ops;
> +	priv->ds->ops = &priv->ops;
> +	dev_set_drvdata(&mdiodev->dev, priv);
> +
> +	return dsa_register_switch(priv->ds);

If there is an error here, you need to undo the IRQ code, etc.

> +}
> +
> +static void ar9331_sw_remove(struct mdio_device *mdiodev)
> +{
> +	struct ar9331_sw_priv *priv = dev_get_drvdata(&mdiodev->dev);
> +
> +	mdiobus_unregister(priv->mbus);
> +	dsa_unregister_switch(priv->ds);
> +
> +	reset_control_assert(priv->sw_reset);

You also need to clean up the IRQ code here.

Thanks
    Andrew
