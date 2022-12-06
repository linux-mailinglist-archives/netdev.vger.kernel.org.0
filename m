Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6C56444E1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiLFNsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiLFNsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:48:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B3B2B246;
        Tue,  6 Dec 2022 05:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=INa+kDPeRtDGTKkXfOH4U8T/bFqxRT7X+F58KC5R7Zo=; b=6RaELbF/PVhJaQy+0ascCjBHbQ
        bREm0vLFZkn/Afl1cdEMUGrDM24BaidGn85e6IXijKnnpLqGN5SqJocD7c/gEviEZ3ApU55zFPefi
        U+0bkZPPWuE2YUEd83bD/DyO4NCq42ln45Va7q+vVdeW8iA8WSS9yzFR6XNKx5zH/XH4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2YIX-004X38-Cn; Tue, 06 Dec 2022 14:47:49 +0100
Date:   Tue, 6 Dec 2022 14:47:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y49IBR8ByMQH6oVt@lunn.ch>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +// module parameter: if set, the link status is derived from the PLCA status
> +// default: false
> +static bool link_status_plca;
> +module_param(link_status_plca, bool, 0644);

No module parameters, they are considered a bad user interface.

> +static int ncn26000_get_features(struct phy_device *phydev)
> +{
> +	linkmode_zero(phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, phydev->supported);
> +
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> +			 phydev->supported);
> +
> +	linkmode_copy(phydev->advertising, phydev->supported);

That should not be needed.

Also, look at PHY_BASIC_T1_FEATURES, and how it is used in
microchip_t1.c.

> +static int ncn26000_read_status(struct phy_device *phydev)
> +{
> +	// The NCN26000 reports NCN26000_LINK_STATUS_BIT if the link status of
> +	// the PHY is up. It further reports the logical AND of the link status
> +	// and the PLCA status in the BMSR_LSTATUS bit. Thus, report the link
> +	// status by testing the appropriate BMSR bit according to the module's
> +	// parameter configuration.
> +	const int lstatus_flag = link_status_plca ?
> +		BMSR_LSTATUS : NCN26000_BMSR_LINK_STATUS_BIT;
> +
> +	int ret;
> +
> +	ret = phy_read(phydev, MII_BMSR);
> +	if (unlikely(ret < 0))
> +		return ret;
> +
> +	// update link status
> +	phydev->link = (ret & lstatus_flag) ? 1 : 0;

What about the latching behaviour of LSTATUS?

https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L2289

> +
> +	// handle more IRQs here

You are not in an IRQ handler...

You should also be setting speed and duplex. I don't think they are
guaranteed to have any specific value if you don't set them.

> +
> +	return 0;
> +}
> +
> +static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
> +{
> +	const struct ncn26000_priv *const priv = phydev->priv;
> +	int ret;
> +
> +	// clear the latched bits in MII_BMSR
> +	phy_read(phydev, MII_BMSR);

Why?

> +
> +	// read and aknowledge the IRQ status register
> +	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> +
> +	if (unlikely(ret < 0) || (ret & priv->enabled_irqs) == 0)

How does NCN26000_REG_IRQ_STATUS work? Can it have bits set which are
not in NCN26000_REG_IRQ_CTL ? That does happen sometimes, but is
pretty unusual. If not, you don't need to track priv->enabled_irqs,
just ensure ret is not 0.

     Andrew
