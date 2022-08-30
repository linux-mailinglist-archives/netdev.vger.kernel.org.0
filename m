Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D945A649D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiH3NZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiH3NZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:25:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB175C34D;
        Tue, 30 Aug 2022 06:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ChRLCxcp2Pv+XebXI/mR0LbNe8f7KSwCYY4t/Bic+Qw=; b=My8BgyGGaGQz8KT9o94tZ4PapB
        mwV9r3Sb0UFfymn4r1wKTWa4N//oMkkGslOZb1fO6jNlocpVBUDqE1nSydtwiS/esoqtVo5C4moKl
        jWHoikY/fICHGOcvbR/qLNe5mrwhXVIK9KGM9gBxW4kOWBSok6iKd9k5m8UXQ52uMPrA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oT1FU-00F4ht-Lb; Tue, 30 Aug 2022 15:25:48 +0200
Date:   Tue, 30 Aug 2022 15:25:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [RFC Patch net-next v3 3/3] net: dsa: microchip: lan937x: add
 interrupt support for port phy link
Message-ID: <Yw4P3OJgtTtmgBHN@lunn.ch>
References: <20220830105303.22067-1-arun.ramadoss@microchip.com>
 <20220830105303.22067-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830105303.22067-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -85,6 +94,7 @@ struct ksz_port {
>  	u32 rgmii_tx_val;
>  	u32 rgmii_rx_val;
>  	struct ksz_device *ksz_dev;
> +	struct ksz_irq irq;

Here irq is of type ksz_irq.

>  	u8 num;
>  };
>  
> @@ -103,6 +113,7 @@ struct ksz_device {
>  	struct regmap *regmap[3];
>  
>  	void *priv;
> +	int irq;

Here it is of type int.

>  
>  	struct gpio_desc *reset_gpio;	/* Optional reset GPIO */
>  
> @@ -124,6 +135,8 @@ struct ksz_device {
>  	u16 mirror_tx;
>  	u32 features;			/* chip specific features */
>  	u16 port_mask;
> +	struct mutex lock_irq;		/* IRQ Access */
> +	struct ksz_irq girq;

And here you have the type ksz_irq called qirq. This is going to be
confusing.

I suggest you make the first one called pirq, for port, and then we
have girq for global, and irq is just a number.

>  static int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
>  {
>  	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
> @@ -171,6 +175,7 @@ static int lan937x_mdio_register(struct ksz_device *dev)
>  	struct device_node *mdio_np;
>  	struct mii_bus *bus;
>  	int ret;
> +	int p;
>  
>  	mdio_np = of_get_child_by_name(dev->dev->of_node, "mdio");
>  	if (!mdio_np) {
> @@ -194,6 +199,16 @@ static int lan937x_mdio_register(struct ksz_device *dev)
>  
>  	ds->slave_mii_bus = bus;
>  
> +	for (p = 0; p < KSZ_MAX_NUM_PORTS; p++) {
> +		if (BIT(p) & ds->phys_mii_mask) {
> +			unsigned int irq;
> +
> +			irq = irq_find_mapping(dev->ports[p].irq.domain,
> +					       PORT_SRC_PHY_INT);

This could return an error code. You really should check for it, the
irq subsystem is not going to be happy with a negative irq number.

> +			ds->slave_mii_bus->irq[p] = irq;
> +		}
> +	}
> +
>  	ret = devm_of_mdiobus_register(ds->dev, bus, mdio_np);
>  	if (ret) {
>  		dev_err(ds->dev, "unable to register MDIO bus %s\n",

I don't see anywhere you destroy the mappings you created above when
the MDIO bus is unregistered. The equivalent of
mv88e6xxx_g2_irq_mdio_free().


> +static irqreturn_t lan937x_girq_thread_fn(int irq, void *dev_id)
> +{
> +	struct ksz_device *dev = dev_id;
> +	unsigned int nhandled = 0;
> +	unsigned int sub_irq;
> +	unsigned int n;
> +	u32 data;
> +	int ret;
> +
> +	ret = ksz_read32(dev, REG_SW_INT_STATUS__4, &data);
> +	if (ret)
> +		goto out;
> +
> +	if (data & POR_READY_INT) {
> +		ret = ksz_write32(dev, REG_SW_INT_STATUS__4, POR_READY_INT);
> +		if (ret)
> +			goto out;
> +	}

What do these two read/writes do? It seems like you are discarding an
interrupt?


> +
> +	/* Read global interrupt status register */
> +	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data);
> +	if (ret)
> +		goto out;
> +
> +	for (n = 0; n < dev->girq.nirqs; ++n) {
> +		if (data & (1 << n)) {
> +			sub_irq = irq_find_mapping(dev->girq.domain, n);
> +			handle_nested_irq(sub_irq);
> +			++nhandled;
> +		}
> +	}
> +out:
> +	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
> +}
> +
> +static irqreturn_t lan937x_pirq_thread_fn(int irq, void *dev_id)
> +{
> +	struct ksz_port *port = dev_id;
> +	unsigned int nhandled = 0;
> +	struct ksz_device *dev;
> +	unsigned int sub_irq;
> +	unsigned int n;
> +	u8 data;
> +
> +	dev = port->ksz_dev;
> +
> +	/* Read global interrupt status register */
> +	ksz_pread8(dev, port->num, REG_PORT_INT_STATUS, &data);

I think global here should be port?

> +
> +	for (n = 0; n < port->irq.nirqs; ++n) {
> +		if (data & (1 << n)) {
> +			sub_irq = irq_find_mapping(port->irq.domain, n);
> +			handle_nested_irq(sub_irq);
> +			++nhandled;
> +		}
> +	}
> +
> +	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
> +}
> +

>  int lan937x_setup(struct dsa_switch *ds)
>  {
>  	struct ksz_device *dev = ds->priv;
> +	struct dsa_port *dp;
>  	int ret;
>  
>  	/* enable Indirect Access from SPI to the VPHY registers */
> @@ -395,10 +688,22 @@ int lan937x_setup(struct dsa_switch *ds)
>  		return ret;
>  	}
>  
> +	if (dev->irq > 0) {
> +		ret = lan937x_girq_setup(dev);
> +		if (ret)
> +			return ret;
> +
> +		dsa_switch_for_each_user_port(dp, dev->ds) {
> +			ret = lan937x_pirq_setup(dev, dp->index);
> +			if (ret)
> +				goto out_girq;
> +		}
> +	}
> +

>  void lan937x_switch_exit(struct ksz_device *dev)
>  {
> +	struct dsa_port *dp;
> +
>  	lan937x_reset_switch(dev);
> +
> +	if (dev->irq > 0) {
> +		dsa_switch_for_each_user_port(dp, dev->ds) {
> +			lan937x_pirq_free(&dev->ports[dp->index], dp->index);
> +		}
> +
> +		lan937x_girq_free(dev);

This is where your problem with exit vs reset is coming from. You
setup all the interrupt code in setup(). But currently there is no
function which is the opposite of setup(). Generally, it is called
tairdown. Add such a function.

	  Andrew
