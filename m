Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7112B748D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgKRDJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:09:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgKRDJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 22:09:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfDqw-007eVt-Ac; Wed, 18 Nov 2020 04:09:50 +0100
Date:   Wed, 18 Nov 2020 04:09:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v3] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <20201118030950.GB1804098@lunn.ch>
References: <1605654870-14859-1-git-send-email-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605654870-14859-1-git-send-email-davthompson@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David

> +static int mlxbf_gige_phy_enable_interrupt(struct phy_device *phydev)
> +{
> +	int err = 0;
> +
> +	if (phydev->drv->ack_interrupt)
> +		err = phydev->drv->ack_interrupt(phydev);
> +	if (err < 0)
> +		return err;
> +
> +	phydev->interrupts = PHY_INTERRUPT_ENABLED;
> +	if (phydev->drv->config_intr)
> +		err = phydev->drv->config_intr(phydev);
> +
> +	return err;
> +}
> +
> +static int mlxbf_gige_phy_disable_interrupt(struct phy_device *phydev)
> +{
> +	int err = 0;
> +
> +	if (phydev->drv->ack_interrupt)
> +		err = phydev->drv->ack_interrupt(phydev);
> +	if (err < 0)
> +		return err;
> +
> +	phydev->interrupts = PHY_INTERRUPT_DISABLED;
> +	if (phydev->drv->config_intr)
> +		err = phydev->drv->config_intr(phydev);
> +
> +	return err;
> +}

This is, erm, interesting.

> +irqreturn_t mlxbf_gige_mdio_handle_phy_interrupt(int irq, void *dev_id)
> +{
> +	struct phy_device *phydev;
> +	struct mlxbf_gige *priv;
> +	u32 val;
> +
> +	priv = dev_id;
> +	phydev = priv->netdev->phydev;
> +
> +	/* Check if this interrupt is from PHY device.
> +	 * Return if it is not.
> +	 */
> +	val = readl(priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> +	if (!(val & MLXBF_GIGE_CAUSE_OR_CAUSE_EVTEN0_MASK))
> +		return IRQ_NONE;
> +
> +	phy_mac_interrupt(phydev);
> +
> +	/* Clear interrupt when done, otherwise, no further interrupt
> +	 * will be triggered.
> +	 */
> +	val = readl(priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> +	val |= MLXBF_GIGE_CAUSE_OR_CLRCAUSE_MASK;
> +	writel(val, priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> +
> +	/* Make sure to clear the PHY device interrupt */
> +	if (phydev->drv->ack_interrupt)
> +		phydev->drv->ack_interrupt(phydev);
> +
> +	phydev->interrupts = PHY_INTERRUPT_ENABLED;
> +	if (phydev->drv->config_intr)
> +		phydev->drv->config_intr(phydev);

And more interesting code.

We have to find a better way to do this, you should not by copying
core PHY code into a MAC driver.

So it seems to me, the PHY interrupt you request is not actually a PHY
interrupt. It looks more like an interrupt controller. The EVTEN0
suggests that there could be multiple interrupts here, of which one if
the PHY? This is more a generic GPIO block which can do interrupts
when the pins are configured as inputs? Or is it an interrupt
controller with multiple interrupts?

Once you model this correctly in Linux, you can probably remove all
the interesting code.

    Andrew
