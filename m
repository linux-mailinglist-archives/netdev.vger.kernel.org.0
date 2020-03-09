Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A74F17E5AF
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCIR2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:28:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53580 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgCIR2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 13:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M72E2o99IqXg1pKNMHqXaeZhwNtYb1p0j/z4ztyLjpQ=; b=r8XGzBVZHLiIiTD6e/9vHi6C0E
        JoosDRtVY+1L6ClMron84A8N3lezwjsnzE0uF6P8UOzEf6HsU7lKncJLluLCCU5Upq6VXNcBP6lyr
        IpQADcDR1VN11GXEQSziYD0E+lRLG+Eu5Rg2l3wfjbb5BgvYYOaXAD9+4Zf9cXAHOrl4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jBMC8-0003or-14; Mon, 09 Mar 2020 18:28:00 +0100
Date:   Mon, 9 Mar 2020 18:28:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>
Subject: Re: [PATCH v2 2/2] net: phy: tja11xx: add delayed registration of
 TJA1102 PHY1
Message-ID: <20200309172800.GB14181@lunn.ch>
References: <20200309074044.21399-1-o.rempel@pengutronix.de>
 <20200309074044.21399-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309074044.21399-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 08:40:44AM +0100, Oleksij Rempel wrote:
> TJA1102 is a dual PHY package with PHY0 having proper PHYID and PHY1
> having no ID. On one hand it is possible to for PHY detection by
> compatible, on other hand we should be able to reset complete chip
> before PHY1 configured it, and we need to define dependencies for proper
> power management.
> 
> We can solve it by defining PHY1 as child of PHY0:
> 	tja1102_phy0: ethernet-phy@4 {
> 		reg = <0x4>;
> 
> 		interrupts-extended = <&gpio5 8 IRQ_TYPE_LEVEL_LOW>;
> 
> 		reset-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
> 		reset-assert-us = <20>;
> 		reset-deassert-us = <2000>;
> 
> 		tja1102_phy1: ethernet-phy@5 {
> 			reg = <0x5>;
> 
> 			interrupts-extended = <&gpio5 8 IRQ_TYPE_LEVEL_LOW>;
> 		};
> 	};
> 
> The PHY1 should be a subnode of PHY0 and registered only after PHY0 was
> completely reset and initialized.

Hi Oleksij

Please add a binding document for this.

> +static void tja1102_p1_register(struct work_struct *work)
> +{
> +	struct tja11xx_priv *priv = container_of(work, struct tja11xx_priv,
> +						 phy_register_work);
> +
> +	struct phy_device *phydev_phy0 = priv->phydev;
> +        struct mii_bus *bus = phydev_phy0->mdio.bus;
> +	struct device *dev = &phydev_phy0->mdio.dev;
> +	struct device_node *np = dev->of_node;
> +	struct device_node *child;
> +	int ret;
> +
> +	for_each_available_child_of_node(np, child) {
> +		struct phy_device *phy;
> +		int addr;
> +
> +		addr = of_mdio_parse_addr(dev, child);
> +		if (addr < 0) {
> +			dev_err(dev, "Can't parse addr\n");
> +			continue;
> +		}

It would also be good to check that addr is one more than the parent
device. That seems to be a silicon constraint.

> +
> +		/* skip already registered PHYs */
> +		if (mdiobus_is_registered_device(bus, addr)) {
> +			dev_err(dev, "device is already registred \n");
> +			continue;
> +		}
> +
> +		phy = phy_device_create(bus, addr, PHY_ID_TJA1102,
> +						false, NULL);
> +		if (IS_ERR(phy)) {
> +			dev_err(dev, "Can't register Port : %i\n", addr);

You are not registering at this step, just allocating.

> +			continue;
> +		}
> +
> +		ret = of_irq_get(child, 0);
> +		/* can we be deferred here? */

Yes.

commit 66bdede495c71da9c5ce18542976fae53642880b
Author: Geert Uytterhoeven <geert+renesas@glider.be>
Date:   Wed Oct 18 13:54:03 2017 +0200

    of_mdio: Fix broken PHY IRQ in case of probe deferral
    
    If an Ethernet PHY is initialized before the interrupt controller it is
    connected to, a message like the following is printed:
    
        irq: no irq domain found for /interrupt-controller@e61c0000 !


> +		if (ret > 0) {
> +			phy->irq = ret;
> +			bus->irq[addr] = ret;
> +		} else {
> +			phy->irq = bus->irq[addr];
> +		}
> +
> +		/* overwrite parent phy_device_create() set parent to the
> +		 * mii_bus->dev
> +		 */
> +		phy->mdio.dev.parent = dev;
> +
> +		/* Associate the OF node with the device structure so it
> +		 * can be looked up later */
> +		of_node_get(child);
> +		phy->mdio.dev.of_node = child;
> +		phy->mdio.dev.fwnode = of_fwnode_handle(child);
> +
> +		/* All data is now stored in the phy struct;
> +		 * register it */
> +		ret = phy_device_register(phy);
> +		if (ret) {
> +			phy_device_free(phy);
> +			of_node_put(child);
> +		}
> +	}
> +}

This is a lot of of_mdiobus_register_phy(). I think it would be better
to refactor this code a bit, maybe make a helper out of
of_mdiobus_register_phy() for all the shared code.

	  Andrew
