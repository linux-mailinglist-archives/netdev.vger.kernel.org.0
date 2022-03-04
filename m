Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A84CD4AB
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbiCDNHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiCDNHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:07:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CB46D1BF;
        Fri,  4 Mar 2022 05:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v9B6D3GHWg6WGr5pmkrQMreNeUJyb8qZF9cdJ7XnKQo=; b=muZw9pJAdvpIZ8VMuckZF+1FPC
        0jzhCeui3arpLahxGBmw87ep6vcONt7sj9/CD2JgfnDvRKbQQkS0u9O8ZrSnYQjyUalgqTjClNMhp
        QAbntofSiTu5IyCQljtXcU7mHU92zNUZ4Yx+Z3W/iV4vC2J2K/pp+8o0wRGHmZA1tPRw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQ7dJ-009EJa-6Y; Fri, 04 Mar 2022 14:06:09 +0100
Date:   Fri, 4 Mar 2022 14:06:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, madhuri.sripada@microchip.com,
        manohar.puri@microchip.com
Subject: Re: [PATCH net-next 3/3] net: phy: micrel: 1588 support for LAN8814
 phy
Message-ID: <YiIOwZih+I6gsNlM@lunn.ch>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-4-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304093418.31645-4-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct kszphy_latencies lan8814_latencies = {
> +	.rx_10		= 0x22AA,
> +	.tx_10		= 0x2E4A,
> +	.rx_100		= 0x092A,
> +	.tx_100		= 0x02C1,
> +	.rx_1000	= 0x01AD,
> +	.tx_1000	= 0x00C9,
> +};

Seems odd to use hex here. Are these the defaults? At minimum, you
need to add these to the binding document, making it clear what
defaults are used. Also, what are the unit here?

> +	/* Make sure the PHY is not broken. Read idle error count,
> +	 * and reset the PHY if it is maxed out.
> +	 */
> +	regval = phy_read(phydev, MII_STAT1000);
> +	if ((regval & 0xFF) == 0xFF) {
> +		phy_init_hw(phydev);
> +		phydev->link = 0;
> +		if (phydev->drv->config_intr && phy_interrupt_is_valid(phydev))
> +			phydev->drv->config_intr(phydev);
> +		return genphy_config_aneg(phydev);
> +	}

Is this related to PTP? Or is the PHY broken in general? This looks
like it should be something submitted to stable.

> +static int lan8814_config_init(struct phy_device *phydev)
> +{
> +	int val;
> +
> +	/* Reset the PHY */
> +	val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
> +	val |= LAN8814_QSGMII_SOFT_RESET_BIT;
> +	lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET, val);
> +
> +	/* Disable ANEG with QSGMII PCS Host side */
> +	val = lanphy_read_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
> +	val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
> +	lanphy_write_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
> +
> +	/* MDI-X setting for swap A,B transmit */
> +	val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
> +	val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
> +	val |= LAN8814_ALIGN_TX_A_B_SWAP;
> +	lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);

This does not look related to PTP. If David has not ready merged this,
i would of said you should of submitted this as a separate patch.

> +static void lan8814_parse_latency(struct phy_device *phydev)
> +{
> +	const struct device_node *np = phydev->mdio.dev.of_node;
> +	struct kszphy_priv *priv = phydev->priv;
> +	struct kszphy_latencies *latency = &priv->latencies;
> +	u32 val;
> +
> +	if (!of_property_read_u32(np, "lan8814,latency_rx_10", &val))
> +		latency->rx_10 = val;
> +	if (!of_property_read_u32(np, "lan8814,latency_tx_10", &val))
> +		latency->tx_10 = val;
> +	if (!of_property_read_u32(np, "lan8814,latency_rx_100", &val))
> +		latency->rx_100 = val;
> +	if (!of_property_read_u32(np, "lan8814,latency_tx_100", &val))
> +		latency->tx_100 = val;
> +	if (!of_property_read_u32(np, "lan8814,latency_rx_1000", &val))
> +		latency->rx_1000 = val;
> +	if (!of_property_read_u32(np, "lan8814,latency_tx_1000", &val))
> +		latency->tx_1000 = val;

Are range checks need here? You are reading a u32, but PHY registers
are generally 16 bit.

    Andrew
