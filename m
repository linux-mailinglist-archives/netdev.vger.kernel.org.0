Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A37234A64
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387529AbgGaRma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:42:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733153AbgGaRm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 13:42:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1Z30-007iyi-Ua; Fri, 31 Jul 2020 19:42:22 +0200
Date:   Fri, 31 Jul 2020 19:42:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <dthompson@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200731174222.GE1748118@lunn.ch>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David

>> +static int mlxbf_gige_mdio_poll_bit(struct mlxbf_gige *priv, u32 bit_mask)
> +{
> +	unsigned long timeout;
> +	u32 val;
> +
> +	timeout = jiffies + msecs_to_jiffies(MLXBF_GIGE_MDIO_POLL_BUSY_TIMEOUT);
> +	do {
> +		val = readl(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
> +		if (!(val & bit_mask))
> +			return 0;
> +		udelay(MLXBF_GIGE_MDIO_POLL_DELAY_USEC);
> +	} while (time_before(jiffies, timeout));

Please use one of the include/linux/iopoll.h macros. 

> +
> +	return -ETIME;

ETIMEDOUT, not ETIME. But that will automatically be fixed when you
use iopoll.h. Core code has less bugs, which is why you should use it.

> +}
> +
> +static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
> +{
> +	struct mlxbf_gige *priv = bus->priv;
> +	u32 cmd;
> +	u32 ret;
> +
> +	/* If the lock is held by something else, drop the request.
> +	 * If the lock is cleared, that means the busy bit was cleared.
> +	 */

How can this happen? The mdio core has a mutex which prevents parallel
access?

> +	ret = mlxbf_gige_mdio_poll_bit(priv, MLXBF_GIGE_MDIO_GW_LOCK_MASK);
> +	if (ret)
> +		return -EBUSY;

PHY drivers are not going to like that. They are not going to
retry. What is likely to happen is that phylib moves into the ERROR
state, and the PHY driver grinds to a halt.

> +static void mlxbf_gige_mdio_disable_phy_int(struct mlxbf_gige *priv)
> +{
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&priv->gpio_lock, flags);
> +	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
> +	val &= ~priv->phy_int_gpio_mask;
> +	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
> +	spin_unlock_irqrestore(&priv->gpio_lock, flags);
> +}
> +
> +static void mlxbf_gige_mdio_enable_phy_int(struct mlxbf_gige *priv)
> +{
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&priv->gpio_lock, flags);
> +	/* The INT_N interrupt level is active low.
> +	 * So enable cause fall bit to detect when GPIO
> +	 * state goes low.
> +	 */
> +	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_FALL_EN);
> +	val |= priv->phy_int_gpio_mask;
> +	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_FALL_EN);
> +
> +	/* Enable PHY interrupt by setting the priority level */
> +	val = readl(priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
> +	val |= priv->phy_int_gpio_mask;
> +	writel(val, priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
> +	spin_unlock_irqrestore(&priv->gpio_lock, flags);
> +}
> +
> +/* Interrupt handler is called from mlxbf_gige_main.c
> + * driver whenever a phy interrupt is received.
> + */
> +irqreturn_t mlxbf_gige_mdio_handle_phy_interrupt(struct mlxbf_gige *priv)
> +{
> +	u32 val;
> +
> +	/* The YU interrupt is shared between SMBus and GPIOs.
> +	 * So first, determine whether this is a GPIO interrupt.
> +	 */
> +	val = readl(priv->cause_rsh_coalesce0_io);
> +	if (!MLXBF_GIGE_GPIO_CAUSE_IRQ_IS_SET(val)) {
> +		/* Nothing to do here, not a GPIO interrupt */
> +		return IRQ_NONE;
> +	}
> +	/* Then determine which gpio register this interrupt is for.
> +	 * Return if the interrupt is not for gpio block 0.
> +	 */
> +	val = readl(priv->cause_gpio_arm_coalesce0_io);
> +	if (!(val & MLXBF_GIGE_GPIO_BLOCK0_MASK))
> +		return IRQ_NONE;
> +
> +	/* Finally check if this interrupt is from PHY device.
> +	 * Return if it is not.
> +	 */
> +	val = readl(priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> +	if (!(val & priv->phy_int_gpio_mask))
> +		return IRQ_NONE;
> +
> +	/* Clear interrupt when done, otherwise, no further interrupt
> +	 * will be triggered.
> +	 * Writing 0x1 to the clear cause register also clears the
> +	 * following registers:
> +	 * cause_gpio_arm_coalesce0
> +	 * cause_rsh_coalesce0
> +	 */
> +	val = readl(priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> +	val |= priv->phy_int_gpio_mask;
> +	writel(val, priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);

Shoudn't there be a call into the PHY driver at this point?

> +
> +	return IRQ_HANDLED;
> +}

So these last three functions seem to be an interrupt controller?  So
why not model it as a Linux interrupt controller? 

> +static void mlxbf_gige_mdio_init_config(struct mlxbf_gige *priv)
> +{
> +	struct device *dev = priv->dev;
> +	u32 mdio_full_drive;
> +	u32 mdio_out_sample;
> +	u32 mdio_in_sample;
> +	u32 mdio_voltage;
> +	u32 mdc_period;
> +	u32 mdio_mode;
> +	u32 mdio_cfg;
> +	int ret;
> +
> +	ret = device_property_read_u32(dev, "mdio-mode", &mdio_mode);
> +	if (ret < 0)
> +		mdio_mode = MLXBF_GIGE_MDIO_MODE_MASTER;
> +
> +	ret = device_property_read_u32(dev, "mdio-voltage", &mdio_voltage);
> +	if (ret < 0)
> +		mdio_voltage = MLXBF_GIGE_MDIO3_3;
> +
> +	ret = device_property_read_u32(dev, "mdio-full-drive", &mdio_full_drive);
> +	if (ret < 0)
> +		mdio_full_drive = MLXBF_GIGE_MDIO_FULL_DRIVE;
> +
> +	ret = device_property_read_u32(dev, "mdc-period", &mdc_period);
> +	if (ret < 0)
> +		mdc_period = MLXBF_GIGE_MDIO_PERIOD;
> +
> +	ret = device_property_read_u32(dev, "mdio-in-sample", &mdio_in_sample);
> +	if (ret < 0)
> +		mdio_in_sample = MLXBF_GIGE_MDIO_IN_SAMP;
> +
> +	ret = device_property_read_u32(dev, "mdio-out-sample", &mdio_out_sample);
> +	if (ret < 0)
> +		mdio_out_sample = MLXBF_GIGE_MDIO_OUT_SAMP;

Please see the discussion going on in the thread:

https://lore.kernel.org/linux-acpi/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t

and in particular

https://lore.kernel.org/linux-acpi/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t

My reading of this is you need to provide a specification of these
properties, and show they really are being used. Please join in on
that thread. Until we make progress on how ACPI should be used, you
might want to drop all these properties and just hard code it as a
standard 2.5Mhz MDIO bus.

> +int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
> +{
> +
> +	ret = device_property_read_u32(dev, "phy-addr", &phy_addr);
> +	if (ret < 0)
> +		phy_addr = MLXBF_GIGE_MDIO_DEFAULT_PHY_ADDR;

This is going to be problematic. See above.

> +
> +	priv->mdiobus->irq[phy_addr] = PHY_POLL;

That is the default anyway. You can skip this.  But why do you have
interrupt handling code, and then poll it? Maybe just delete all the
interrupt code?

> +
> +	/* Auto probe PHY at the corresponding address */
> +	priv->mdiobus->phy_mask = ~(1 << phy_addr);
> +	ret = mdiobus_register(priv->mdiobus);
> +	if (ret)
> +		dev_err(dev, "Failed to register MDIO bus\n");

Does it break if you scan the whole bus? It would allow you to avoid
some of the ACPI issues.

> +
> +	return ret;
> +}
> +

  Andrew
