Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9685B873E
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiINL1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiINL1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:27:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834397695E;
        Wed, 14 Sep 2022 04:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AUjtkKGSeEc5ryQMh2d5vikhf7NgY7LP6Ecixsu2EZE=; b=UjFlmk7+ihgH4yg4fdSMInDNNA
        v42A2cjgTEPq5HReCitHOao4dUmSzBGs9acrNAw2vrAigvPcN2l3x7Ijxz5zVvH9iNzFOAI8XlGvK
        knADdhLIGl9IAa8QaXjOE17fiPBlZuL40iXHHhFYMQZopg/OD6DeMVEw8QmkKhPJMFTmruRH8twQP
        8V2AfcLqKcxnYmcUvdbsq5JRMMNU7MmlNN1aGZs/Z2qf2bk4/qxab/SMwXAXpQD09w4hnETYCqqBQ
        Z3uUOPTuoveQsS7jzvCCaRnTkU1/MQD/FyNJm4ZXmRP3cSgc0BUmNfvwQDSwTY3Zhyg0bRpoLAxyP
        UCItwMtg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34316)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYQYQ-0004Iw-6F; Wed, 14 Sep 2022 12:27:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYQYN-0001bh-LP; Wed, 14 Sep 2022 12:27:39 +0100
Date:   Wed, 14 Sep 2022 12:27:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Tristram.Ha@microchip.com,
        prasanna.vengateshan@microchip.com, hkallweit1@gmail.com
Subject: Re: [Patch net-next v2 4/5] net: dsa: microchip: move interrupt
 handling logic from lan937x to ksz_common
Message-ID: <YyG6q6SPURSAtz7C@shell.armlinux.org.uk>
References: <20220914035223.31702-1-arun.ramadoss@microchip.com>
 <20220914035223.31702-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914035223.31702-5-arun.ramadoss@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Some suggestions for a few improvements in a future patch:

On Wed, Sep 14, 2022 at 09:22:22AM +0530, Arun Ramadoss wrote:
> +static int ksz_irq_phy_setup(struct ksz_device *dev)
> +{
> +	struct dsa_switch *ds = dev->ds;
> +	int phy, err_phy;
> +	int irq;
> +	int ret;
> +
> +	for (phy = 0; phy < KSZ_MAX_NUM_PORTS; phy++) {
> +		if (BIT(phy) & ds->phys_mii_mask) {
> +			irq = irq_find_mapping(dev->ports[phy].pirq.domain,
> +					       PORT_SRC_PHY_INT);
> +			if (irq < 0) {
> +				ret = irq;
> +				goto out;
> +			}
> +			ds->slave_mii_bus->irq[phy] = irq;
> +		}
> +	}
> +	return 0;
> +out:
> +	err_phy = phy;
> +
> +	for (phy = 0; phy < err_phy; phy++)
> +		if (BIT(phy) & ds->phys_mii_mask)
> +			irq_dispose_mapping(ds->slave_mii_bus->irq[phy]);

	while (phy--)
		if (BIT(phy) & ds->phys_mii_mask)
			irq_dispose_mapping(ds->slave_mii_bus->irq[phy]);

?

> +static void ksz_girq_mask(struct irq_data *d)
> +{
> +	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
> +	unsigned int n = d->hwirq;
> +
> +	dev->girq.masked |= (1 << n);

	dev->girq.masked |= BIT(d->hwirq);

?

> +}
> +
> +static void ksz_girq_unmask(struct irq_data *d)
> +{
> +	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
> +	unsigned int n = d->hwirq;
> +
> +	dev->girq.masked &= ~(1 << n);

	dev->girq.masked &= ~BIT(d->hw_irq);

?

> +}
> +
> +static void ksz_girq_bus_lock(struct irq_data *d)
> +{
> +	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
> +
> +	mutex_lock(&dev->lock_irq);
> +}
> +
> +static void ksz_girq_bus_sync_unlock(struct irq_data *d)
> +{
> +	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
> +	int ret;
> +
> +	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, dev->girq.masked);
> +	if (ret)
> +		dev_err(dev->dev, "failed to change IRQ mask\n");
> +
> +	mutex_unlock(&dev->lock_irq);
> +}
> +
> +static const struct irq_chip ksz_girq_chip = {
> +	.name			= "ksz-global",
> +	.irq_mask		= ksz_girq_mask,
> +	.irq_unmask		= ksz_girq_unmask,
> +	.irq_bus_lock		= ksz_girq_bus_lock,
> +	.irq_bus_sync_unlock	= ksz_girq_bus_sync_unlock,
> +};

As the pirq code is almost identical to the girq code, how about putting
a "reg_mask", "reg_status" and a pointer to ksz_device into ksz_irq, and
using the ksz_irq as the chip data?

These would then become:

static void ksz_irq_mask(struct irq_data *d)
{
	struct ksz_irq *ki = irq_data_get_irq_chip_data(d);

	ki->masked |= BIT(d->hwirq);
}

static void ksz_irq_unmask(struct irq_data *d)
{
	struct ksz_irq *ki = irq_data_get_irq_chip_data(d);

	ki->masked &= ~BIT(d->hwirq);
}

static void ksz_irq_bus_lock(struct irq_data *d)
{
	struct ksz_irq *ki = irq_data_get_irq_chip_data(d);

	mutex_lock(&ki->dev->lock_irq);
}

static void ksz_irq_bus_sync_unlock(struct irq_data *d)
{
	struct ksz_irq *ki = irq_data_get_irq_chip_data(d);
	struct ksz_device *dev = ki->dev;
	int ret;

	ret = ksz_write32(dev, ki->reg_masked, ki->masked);
	if (ret)
		dev_err(dev->dev, "failed to change IRQ mask\n");

	mutex_unlock(&dev->lock_irq);
}

and thus this code could be shared between both pirq and girq.
I'm pretty sure the thead_fn could be shared as well, and I'm
sure that the setup and tear down could be improved in a similar
way.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
