Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1866506CAC
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 14:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352387AbiDSMpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 08:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352366AbiDSMpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 08:45:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1BC36E0E;
        Tue, 19 Apr 2022 05:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VPo0pGY4v9eEQhd6+pxXM+SOE4qpAR3z9n5HKjXfKDE=; b=1YC9dPEOG1ouCNKKEVBfcZyuyO
        fVooB6ee9AScE7UxtvnYu5aGqovywK9m/tKd6O8hBmWHR12uFwxlFwiKzstkBlZy8zd87/i/F/ZxK
        JW11PdX61X4EGBhdIDPsmT8hZaKeHnFY+haCbtOlY5IX4mCMqCLBlcsVslTOCuRGg/4k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngnBV-00GUvG-GS; Tue, 19 Apr 2022 14:42:21 +0200
Date:   Tue, 19 Apr 2022 14:42:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        richardcochran@gmail.com
Subject: Re: [RFC PATCH net-next 2/2] net: phy: micrel: Implement
 set/get_adj_latency for lan8814
Message-ID: <Yl6uLbhB4tNhN/Ld@lunn.ch>
References: <20220419083704.48573-1-horatiu.vultur@microchip.com>
 <20220419083704.48573-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419083704.48573-3-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 10:37:04AM +0200, Horatiu Vultur wrote:
> The lan8814 driver supports adjustments of the latency in the silicon
> based on the speed and direction, therefore implement set/get_adj_latency
> to adjust the HW.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 87 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 96840695debd..099d1ecd6dad 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -120,6 +120,15 @@
>  #define PTP_TIMESTAMP_EN_PDREQ_			BIT(2)
>  #define PTP_TIMESTAMP_EN_PDRES_			BIT(3)
>  
> +#define PTP_RX_LATENCY_1000			0x0224
> +#define PTP_TX_LATENCY_1000			0x0225
> +
> +#define PTP_RX_LATENCY_100			0x0222
> +#define PTP_TX_LATENCY_100			0x0223
> +
> +#define PTP_RX_LATENCY_10			0x0220
> +#define PTP_TX_LATENCY_10			0x0221
> +
>  #define PTP_TX_PARSE_L2_ADDR_EN			0x0284
>  #define PTP_RX_PARSE_L2_ADDR_EN			0x0244
>  
> @@ -208,6 +217,16 @@
>  #define PTP_TSU_INT_STS_PTP_RX_TS_OVRFL_INT_	BIT(1)
>  #define PTP_TSU_INT_STS_PTP_RX_TS_EN_		BIT(0)
>  
> +/* Represents the reset value of the latency registers,
> + * The values are express in ns
> + */
> +#define LAN8814_RX_10_LATENCY			8874
> +#define LAN8814_TX_10_LATENCY			11850
> +#define LAN8814_RX_100_LATENCY			2346
> +#define LAN8814_TX_100_LATENCY			705
> +#define LAN8814_RX_1000_LATENCY			429
> +#define LAN8814_TX_1000_LATENCY			201
> +
>  /* PHY Control 1 */
>  #define MII_KSZPHY_CTRL_1			0x1e
>  #define KSZ8081_CTRL1_MDIX_STAT			BIT(4)
> @@ -2657,6 +2676,72 @@ static int lan8804_config_init(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int lan8814_set_adj_latency(struct phy_device *phydev,
> +				   enum ethtool_link_mode_bit_indices link_mode,
> +				   s32 rx, s32 tx)
> +{
> +	switch (link_mode) {
> +	case ETHTOOL_LINK_MODE_10baseT_Half_BIT:
> +	case ETHTOOL_LINK_MODE_10baseT_Full_BIT:
> +		rx += LAN8814_RX_10_LATENCY;
> +		tx += LAN8814_TX_10_LATENCY;
> +		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_10, rx);
> +		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_10, tx);

It is not ideal that the user sees an entry for both link modes X and
X+1 in your file, and that writing to link mode X magically also
changes X+1.

I'm not sure there is anything you can do about this in a generic
implementation, so you at least need to document it in sysfs.

What about range checks? I can pass 32764 as an rx delay, which when
added to PTP_RX_LATENCY_10=0x0220 is going to wrap around and be
negative.

		Andrew
