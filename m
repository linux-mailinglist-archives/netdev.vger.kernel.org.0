Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105C22E7783
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 10:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgL3Jmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 04:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL3Jmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 04:42:53 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 729D721919;
        Wed, 30 Dec 2020 09:42:12 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kuXze-004YNK-8Y; Wed, 30 Dec 2020 09:42:10 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 30 Dec 2020 09:42:09 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Subject: Re: Registering IRQ for MT7530 internal PHYs
In-Reply-To: <20201230042208.8997-1-dqfext@gmail.com>
References: <20201230042208.8997-1-dqfext@gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <441a77e8c30927ce5bc24708e1ceed79@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dqfext@gmail.com, davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com, kuba@kernel.org, Landen.Chao@mediatek.com, matthias.bgg@gmail.com, p.zabel@pengutronix.de, linux@armlinux.org.uk, sean.wang@mediatek.com, tglx@linutronix.de, vivien.didelot@gmail.com, olteanv@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, weijie.gao@mediatek.com, gch981213@gmail.com, linus.walleij@linaro.org, opensource@vdorst.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qingfang,

On 2020-12-30 04:22, DENG Qingfang wrote:
> Hi,
> 
> I added MT7530 IRQ support and registered its internal PHYs to IRQ.
> It works but my patch used two hacks.
> 
> 1. Removed phy_drv_supports_irq check, because config_intr and
> handle_interrupt are not set for Generic PHY.
> 
> 2. Allocated ds->slave_mii_bus before calling ds->ops->setup, because
> we cannot call dsa_slave_mii_bus_init which is private.
> 
> Any better ideas?
> 
> Regards,
> Qingfang
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index a67cac15a724..d59a8c50ede3 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -10,6 +10,7 @@
>  #include <linux/mfd/syscon.h>
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
> +#include <linux/of_irq.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <linux/of_platform.h>
> @@ -1639,6 +1640,125 @@ mtk_get_tag_protocol(struct dsa_switch *ds, int 
> port,
>  	}
>  }
> 
> +static irqreturn_t
> +mt7530_irq(int irq, void *data)
> +{
> +	struct mt7530_priv *priv = data;
> +	bool handled = false;
> +	int phy;
> +	u32 val;
> +
> +	val = mt7530_read(priv, MT7530_SYS_INT_STS);
> +	mt7530_write(priv, MT7530_SYS_INT_STS, val);

If that is an ack operation, it should be dealt with as such in
an irqchip callback instead of being open-coded here.

> +
> +	dev_info_ratelimited(priv->dev, "interrupt status: 0x%08x\n", val);
> +	dev_info_ratelimited(priv->dev, "interrupt enable: 0x%08x\n",
> mt7530_read(priv, MT7530_SYS_INT_EN));
> +

I don't think printing these from an interrupt handler is a good idea.
Use the debug primitives if you really want these messages.

> +	for (phy = 0; phy < MT7530_NUM_PHYS; phy++) {
> +		if (val & BIT(phy)) {
> +			unsigned int child_irq;
> +
> +			child_irq = irq_find_mapping(priv->irq_domain, phy);
> +			handle_nested_irq(child_irq);
> +			handled = true;
> +		}
> +	}
> +
> +	return handled ? IRQ_HANDLED : IRQ_NONE;
> +}

What is the reason for not implementing this as a chained interrupt 
flow?

> +
> +static void mt7530_irq_mask(struct irq_data *d)
> +{
> +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> +
> +	priv->irq_enable &= ~BIT(d->hwirq);
> +}
> +
> +static void mt7530_irq_unmask(struct irq_data *d)
> +{
> +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> +
> +	priv->irq_enable |= BIT(d->hwirq);
> +}
> +
> +static void mt7530_irq_bus_lock(struct irq_data *d)
> +{
> +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> +
> +	mutex_lock(&priv->reg_mutex);

Are you always guaranteed to be in a thread context? I guess that
is the case, given that you request a threaded interrupt, but
it would be worth documenting.

> +}
> +
> +static void mt7530_irq_bus_sync_unlock(struct irq_data *d)
> +{
> +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> +
> +	mt7530_write(priv, MT7530_SYS_INT_EN, priv->irq_enable);
> +	mutex_unlock(&priv->reg_mutex);
> +}
> +
> +static struct irq_chip mt7530_irq_chip = {
> +	.name = MT7530_NAME,
> +	.irq_mask = mt7530_irq_mask,
> +	.irq_unmask = mt7530_irq_unmask,
> +	.irq_bus_lock = mt7530_irq_bus_lock,
> +	.irq_bus_sync_unlock = mt7530_irq_bus_sync_unlock,
> +};
> +
> +static int
> +mt7530_irq_map(struct irq_domain *domain, unsigned int irq,
> +	       irq_hw_number_t hwirq)
> +{
> +	irq_set_chip_data(irq, domain->host_data);
> +	irq_set_chip_and_handler(irq, &mt7530_irq_chip, handle_simple_irq);
> +	irq_set_noprobe(irq);
> +
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops mt7530_irq_domain_ops = {
> +	.map = mt7530_irq_map,
> +	.xlate = irq_domain_xlate_onecell,
> +};
> +
> +static void
> +mt7530_irq_init(struct mt7530_priv *priv)
> +{
> +	struct mii_bus *bus = priv->ds->slave_mii_bus;
> +	struct device *dev = priv->dev;
> +	struct device_node *np = dev->of_node;
> +	int parent_irq;
> +	int phy, ret;
> +
> +	parent_irq = of_irq_get(np, 0);
> +	if (parent_irq <= 0) {
> +		dev_err(dev, "failed to get parent IRQ: %d\n", parent_irq);
> +		return;

It seems odd not to propagate the error, since I assume the device will
not be functional.

> +	}
> +
> +	mt7530_set(priv, MT7530_TOP_SIG_CTRL, TOP_SIG_CTRL_NORMAL);
> +	ret = devm_request_threaded_irq(dev, parent_irq, NULL, mt7530_irq,
> +					IRQF_ONESHOT, MT7530_NAME, priv);
> +	if (ret) {
> +		dev_err(dev, "failed to request IRQ: %d\n", ret);
> +		return;
> +	}
> +
> +	priv->irq_domain = irq_domain_add_linear(np, MT7530_NUM_PHYS,
> +						&mt7530_irq_domain_ops, priv);

The creation order is... interesting. You have a handler ready to fire,
nothing seems to initialise the HW state, and the priv data structure
is not fully populated. If any interrupt is pending at this stage,
you have a panic in your hands.

> +	if (!priv->irq_domain) {
> +		dev_err(dev, "failed to create IRQ domain\n");
> +		return;
> +	}
> +
> +	/* IRQ for internal PHYs */
> +	for (phy = 0; phy < MT7530_NUM_PHYS; phy++) {
> +		unsigned int irq = irq_create_mapping(priv->irq_domain, phy);

Why are you eagerly creating all the interrupt mappings? They should be
created on demand as the endpoint drivers come up.

> +
> +		irq_set_parent(irq, parent_irq);
> +		bus->irq[phy] = irq;
> +	}
> +}
> +
>  static int
>  mt7530_setup(struct dsa_switch *ds)
>  {
> @@ -2578,8 +2698,13 @@ static int
>  mt753x_setup(struct dsa_switch *ds)
>  {
>  	struct mt7530_priv *priv = ds->priv;
> +	int ret =  priv->info->sw_setup(ds);
> 
> -	return priv->info->sw_setup(ds);
> +	/* Setup interrupt */
> +	if (!ret)
> +		mt7530_irq_init(priv);
> +
> +	return ret;
>  }
> 
>  static int
> @@ -2780,6 +2905,9 @@ mt7530_remove(struct mdio_device *mdiodev)
>  		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
>  			ret);
> 
> +	if (priv->irq_domain)
> +		irq_domain_remove(priv->irq_domain);

See the comment in front of irq_domain_remove() about the need
to discard the mappings prior to removing a domain.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
