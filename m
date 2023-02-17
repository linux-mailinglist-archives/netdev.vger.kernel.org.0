Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851B869AD42
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjBQN6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjBQN6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:58:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174B367820
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=81w9YPZlo0KkFo/ylm1IIOoW5RkmrQQnGilCOSGsqSc=; b=KCNopQAP8SOAaZTuz/yAeiz+v/
        eyts+g4V2qTmd8bcAbMd+LPb8PMdqKVy23w2ZwVUyJqh6QGo0zE3ac+f/imYAGEe07cr+Mim2Lrx5
        hbl4+a1xqvVNqqCeUXe8mMaaXLVwLvo/a9Q5oNfUOaS6NKHF+WQMPI3Pxl3VCJcPzm5A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT0rp-005HmR-EK; Fri, 17 Feb 2023 14:33:37 +0100
Date:   Fri, 17 Feb 2023 14:33:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 02/18] net: phy: Add helper to set EEE Clock stop
 enable bit
Message-ID: <Y++CMSRYMmUf5bt+@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217034230.1249661-3-andrew@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:42:14AM +0100, Andrew Lunn wrote:
> The MAC driver can request that the PHY stops the clock during EEE
> LPI. This has normally been does as part of phy_init_eee(), however
> that function is overly complex and often wrongly used. Add a
> standalone helper, to aid removing phy_init_eee().
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/phy.c | 19 +++++++++++++++++++
>  include/linux/phy.h   |  1 +
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 1e6df250d0d0..b25e0946405b 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -1475,6 +1475,25 @@ void phy_mac_interrupt(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(phy_mac_interrupt);
>  
> +/**
> + * phy_eee_clk_stop_enable - Clock should stop during LIP
> + * @phydev: target phy_device struct
> + *
> + * Description: Program the MMD register 3.0 setting the "Clock stop enable"
> + * bit.
> + */
> +int phy_eee_clk_stop_enable(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	mutex_lock(&phydev->lock);
> +	ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
> +			       MDIO_PCS_CTRL1_CLKSTOP_EN);
> +	mutex_unlock(&phydev->lock);
> +
> +	return ret;
> +}

There is a missing EXPORT_SYMBOL_GPL() here, so modular builds don't
work.

	Andrew
