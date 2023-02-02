Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31FE687F09
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjBBNpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjBBNow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:44:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D4D8494C;
        Thu,  2 Feb 2023 05:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Fi1TJSrbKBgGwiN1zPJD1jdfo6snjXyIXipDR/qIHGc=; b=AwphTew0bQENfysvJP+DBsYrQX
        RLKgc/+928vBlWPMPqjAFKMto9KwDfsYTJx6YuQA81obTxMr6G557bFaFpIrSjpV+bjFRwVKFq8pv
        pFZaC5Emm9jg+m8HHSijQbBSuyEnOK+8VVlc63ah4eNBLdHu4wIV8lywt/CVZrZzPRNA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNZtQ-003tmJ-IY; Thu, 02 Feb 2023 14:44:48 +0100
Date:   Thu, 2 Feb 2023 14:44:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael@walle.cc
Subject: Re: [PATCH net-next] net: micrel: Add support for lan8841 PHY
Message-ID: <Y9u+UNHht9OAhKHv@lunn.ch>
References: <20230202094704.175665-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202094704.175665-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1172,19 +1189,18 @@ static int ksz9131_of_load_skew_values(struct phy_device *phydev,
>  #define KSZ9131RN_MMD_COMMON_CTRL_REG	2
> +	/* 100BT Clause 40 improvenent errata */
> +	phy_write_mmd(phydev, 28, LAN8841_ANALOG_CONTROL_1, 0x40);
> +	phy_write_mmd(phydev, 28, LAN8841_ANALOG_CONTROL_10, 0x1);

Please could you try to avoid magic numbers.

> +	/* 10M/100M Ethernet Signal Tuning Errata for Shorted-Center Tap
> +	 * Magnetics
> +	 */
> +	ret = phy_read_mmd(phydev, 2, 0x2);

KSZ9131RN_MMD_COMMON_CTRL_REG ?

> +	if (ret & BIT(14)) {
> +		phy_write_mmd(phydev, 28,
> +			      LAN8841_TX_LOW_I_CH_C_POWER_MANAGMENT, 0xbffc);
> +		phy_write_mmd(phydev, 28,
> +			      LAN8841_BTRX_POWER_DOWN, 0xaf);
> +	}
> +
> +	/* LDO Adjustment errata */
> +	phy_write_mmd(phydev, 28, LAN8841_ANALOG_CONTROL_11, 0x1000);
> +
> +	/* 100BT RGMII latency tuning errata */
> +	phy_write_mmd(phydev, 1, LAN8841_ADC_CHANNEL_MASK, 0x0);
> +	phy_write_mmd(phydev, 0, LAN8841_MMD0_REGISTER_17, 0xa);

MDIO_MMD_PMAPMD	instead of 1.


> +
> +	return 0;
> +}
> +
> +#define LAN8841_OUTPUT_CTRL			25
> +#define LAN8841_OUTPUT_CTRL_INT_BUFFER		BIT(14)
> +#define LAN8841_CTRL				31
> +#define LAN8841_CTRL_INTR_POLARITY		BIT(14)
> +static int lan8841_config_intr(struct phy_device *phydev)
> +{
> +	struct irq_data *irq_data;
> +	int temp = 0;
> +
> +	irq_data = irq_get_irq_data(phydev->irq);
> +	if (!irq_data)
> +		return 0;
> +
> +	if (irqd_get_trigger_type(irq_data) & IRQ_TYPE_LEVEL_HIGH) {
> +		/* Change polarity of the interrupt */
> +		phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER);
> +		phy_modify(phydev, LAN8841_CTRL,
> +			   LAN8841_CTRL_INTR_POLARITY,
> +			   LAN8841_CTRL_INTR_POLARITY);
> +	} else {
> +		/* It is enough to set INT buffer to open-drain because then
> +		 * the interrupt will be active low.
> +		 */
> +		phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER, 0);
> +	}
> +
> +	/* enable / disable interrupts */
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		temp = LAN8814_INT_LINK;
> +
> +	return phy_write(phydev, LAN8814_INTC, temp);
> +}
> +
> +static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
> +{
> +	int irq_status;
> +
> +	irq_status = phy_read(phydev, LAN8814_INTS);
> +	if (irq_status < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (irq_status & LAN8814_INT_LINK) {
> +		phy_trigger_machine(phydev);
> +		return IRQ_HANDLED;
> +	}
> +
> +	return IRQ_NONE;
> +}
> +
> +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER 3
> +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN BIT(0)
> +static int lan8841_probe(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	err = kszphy_probe(phydev);
> +	if (err)
> +		return err;
> +
> +	if (phy_read_mmd(phydev, 2, LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER) &

MDIO_MMD_WIS ?

	Andrew
