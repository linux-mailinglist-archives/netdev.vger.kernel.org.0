Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8668B60CFA6
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiJYOyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiJYOyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:54:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70131211DC;
        Tue, 25 Oct 2022 07:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1SkHs2ReypL5wxS5Ayju3gfZzKWmcZLvSrMlwHZTm+8=; b=gT4vguM5XriQGCcCcxem64dKMp
        fFH4uYwKkFujfPQi46crEFMolZa0KVoXtQIoGtc9lYyUGNdXcyCKcKQdRMNLFeDzsMn+FAVI3DPQk
        1p+vYuoEb91DYh0cTdhksOhTUJSCg5DBCbonfuJCs8NF98FFJBzgKcMxBZMqfA+mUZds=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onLJ6-000XcV-Dn; Tue, 25 Oct 2022 16:53:32 +0200
Date:   Tue, 25 Oct 2022 16:53:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Camel Guo <camel.guo@axis.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        kernel@axis.com
Subject: Re: [RFC net-next 2/2] net: dsa: Add driver for Maxlinear GSW1XX
 switch
Message-ID: <Y1f4bIavgSv0OWi0@lunn.ch>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025135243.4038706-3-camel.guo@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/dsa/Kconfig
> @@ -122,4 +122,20 @@ config NET_DSA_VITESSE_VSC73XX_PLATFORM
>  	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
>  	  and VSC7398 SparX integrated ethernet switches, connected over
>  	  a CPU-attached address bus and work in memory-mapped I/O mode.
> +
> +config NET_DSA_MXL_GSW1XX
> +	tristate
> +	select REGMAP
> +	help
> +	  This enables support for the Maxlinear GSW1XX integrated ethernet
> +	  switch chips.
> +
> +config NET_DSA_MXL_GSW1XX_MDIO
> +	tristate "MaxLinear GSW1XX ethernet switch in MDIO managed mode"

Please keep this file sorted on the tristate text.

In general, it is wrong to insert at the end. That causes the most
conflicts. By keeping lists like this sorted, inserts tend to be
separated, and so don't cause conflicts. Also, keeping it sorted helps
users actually find the configuration option they want.

> +	select NET_DSA_MXL_GSW1XX
> +	select FIXED_PHY
> +	help
> +	  This enables access functions if the MaxLinear GSW1XX is configured
> +	  for MDIO managed mode.
> +
>  endmenu
> diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
> index 16eb879e0cb4..022fc661107b 100644
> --- a/drivers/net/dsa/Makefile
> +++ b/drivers/net/dsa/Makefile
> @@ -15,6 +15,8 @@ obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
>  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
>  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
>  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
> +obj-$(CONFIG_NET_DSA_MXL_GSW1XX) += gsw1xx_core.o
> +obj-$(CONFIG_NET_DSA_MXL_GSW1XX_MDIO) += gsw1xx_mdio.o

This file is sorted as well.

> diff --git a/drivers/net/dsa/gsw1xx.h b/drivers/net/dsa/gsw1xx.h

If you think there is going to be a gsw1xx_spi.c and gsw1xx_uart.c, i
would suggest you move into a subdirectory.

> +static u32 gsw1xx_switch_r(struct gsw1xx_priv *priv, u32 offset)
> +{
> +	int ret = 0;
> +	u32 val = 0;
> +
> +	ret = regmap_read(priv->regmap, GSW1XX_IP_BASE_ADDR + offset, &val);
> +
> +	return ret < 0 ? (u32)ret : val;

A negative error code becomes positive? So how do you then know it is
an error code?

The general pattern is you pass the error code and the register value
in two separate ways. Generally, the error code as the return value,
as an int, and the register value via a pointer. Just as regmap_read()
does.

> +}
> +
> +static void gsw1xx_switch_w(struct gsw1xx_priv *priv, u32 val, u32 offset)
> +{
> +	regmap_write(priv->regmap, GSW1XX_IP_BASE_ADDR + offset, val);
> +}

Return the error code from regmap_write().

In general, don't ignore errors. Return them up the call stack.

> +static u32 gsw1xx_switch_r_timeout(struct gsw1xx_priv *priv, u32 offset,
> +				   u32 cleared)
> +{
> +	u32 val;
> +
> +	return read_poll_timeout(gsw1xx_switch_r, val, (val & cleared) == 0, 20,
> +				 50000, true, priv, offset);
> +}
> +
> +static int gsw1xx_mdio_poll(struct gsw1xx_priv *priv)
> +{
> +	int cnt = 100;
> +
> +	while (likely(cnt--)) {
> +		u32 ctrl = gsw1xx_mdio_r(priv, GSW1XX_MDIO_CTRL);
> +
> +		if ((ctrl & GSW1XX_MDIO_CTRL_BUSY) == 0)
> +			return 0;
> +		usleep_range(20, 40);
> +	}
> +
> +	return -ETIMEDOUT;

It looks like this could be implemented using read_poll_timeout() as
well?

> +}
> +
> +static int gsw1xx_mdio_wr(struct mii_bus *bus, int addr, int reg, u16 val)
> +{
> +	struct gsw1xx_priv *priv = bus->priv;
> +	int err;

Please check for C45 and return -EOPNOTSUPP.

> +
> +	err = gsw1xx_mdio_poll(priv);
> +	if (err) {
> +		dev_err(&bus->dev, "timeout while waiting for MDIO bus\n");
> +		return err;
> +	}
> +
> +	gsw1xx_mdio_w(priv, val, GSW1XX_MDIO_WRITE);
> +	gsw1xx_mdio_w(priv,
> +		      GSW1XX_MDIO_CTRL_WR |
> +			      ((addr & GSW1XX_MDIO_CTRL_PHYAD_MASK)
> +			       << GSW1XX_MDIO_CTRL_PHYAD_SHIFT) |
> +			      (reg & GSW1XX_MDIO_CTRL_REGAD_MASK),
> +		      GSW1XX_MDIO_CTRL);
> +
> +	return 0;
> +}
> +
> +static int gsw1xx_mdio_rd(struct mii_bus *bus, int addr, int reg)
> +{
> +	struct gsw1xx_priv *priv = bus->priv;
> +	int err;

Same here.

> +static int gsw1xx_port_enable(struct dsa_switch *ds, int port,
> +			      struct phy_device *phydev)
> +{
> +	struct gsw1xx_priv *priv = ds->priv;
> +
> +	if (!dsa_is_user_port(ds, port))
> +		return 0;
> +
> +	/* RMON Counter Enable for port */
> +	gsw1xx_switch_w(priv, GSW1XX_IP_BM_PCFG_CNTEN,
> +			GSW1XX_IP_BM_PCFGp(port));
> +
> +	/* enable port fetch/store dma */
> +	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_FDMA_PCTRL_EN,
> +			   GSW1XX_IP_FDMA_PCTRLp(port));
> +	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_SDMA_PCTRL_EN,
> +			   GSW1XX_IP_SDMA_PCTRLp(port));
> +
> +	if (!dsa_is_cpu_port(ds, port)) {

How can this be true given the previous check for dsa_is_user_port()?


> +static int gsw1xx_setup(struct dsa_switch *ds)
> +{
> +	struct gsw1xx_priv *priv = ds->priv;
> +	unsigned int cpu_port = priv->hw_info->cpu_port;
> +	int i;
> +	int err;

Reverse christmass tree, which means you need to delay assigning
cpu_port into the body of the function.

> +int gsw1xx_probe(struct gsw1xx_priv *priv, struct device *dev)
> +{
> +	struct device_node *np, *mdio_np;
> +	int err;
> +	u32 version;

Reverse christmass tree.

> +
> +	if (!priv->regmap || IS_ERR(priv->regmap))
> +		return -EINVAL;
> +
> +	priv->hw_info = of_device_get_match_data(dev);
> +	if (!priv->hw_info)
> +		return -EINVAL;
> +
> +	priv->ds = devm_kzalloc(dev, sizeof(*priv->ds), GFP_KERNEL);
> +	if (!priv->ds)
> +		return -ENOMEM;
> +
> +	priv->ds->dev = dev;
> +	priv->ds->num_ports = priv->hw_info->max_ports;
> +	priv->ds->priv = priv;
> +	priv->ds->ops = &gsw1xx_switch_ops;
> +	priv->dev = dev;
> +	version = gsw1xx_switch_r(priv, GSW1XX_IP_VERSION);
> +
> +	np = dev->of_node;
> +	switch (version) {
> +	case GSW1XX_IP_VERSION_2_3:
> +		if (!of_device_is_compatible(np, "mxl,gsw145-mdio"))
> +			return -EINVAL;
> +		break;
> +	default:
> +		dev_err(dev, "unknown GSW1XX_IP version: 0x%x", version);
> +		return -ENOENT;

I think ENODEV is more appropriate.

I noticed there is no tagging protocol defined. How are frames
direction out a specific port?

I've also not yet looked at the overlap with lantiq_gswip.c.

     Andrew
