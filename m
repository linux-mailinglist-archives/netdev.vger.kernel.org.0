Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED704843A4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbiADOqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:46:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231519AbiADOqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 09:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ud2jEnjGhrKvClBdA1a2WDyh6jHKcxWAWDDYyIRsGk0=; b=tQqzpviI6bB84IlZ0GaWEC7Sc+
        URKX2jrs31pTvEouEzWKbnvJvWgmaEeHEWXOdsuVXhZ82O+Gjijch0fOp1JBwttwZd49SYT6onwDT
        EYok7dm9PHLBeD5J4liIOKv+Ce1nXQQ9TGAhMZbc1qntHqeok9AX35FoG+Qnb8OJ1/dI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4l4t-000TOh-5U; Tue, 04 Jan 2022 15:46:19 +0100
Date:   Tue, 4 Jan 2022 15:46:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdRdu3jFPnGd1DsH@lunn.ch>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
 <YdQ5i+//UITSbxS/@shell.armlinux.org.uk>
 <YdRVovG9mgEWffkn@Red>
 <YdRZQl6U0y19P/0+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdRZQl6U0y19P/0+@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1227,16 +1227,18 @@ static int m88e1118_config_init(struct phy_device *phydev)
>  {
>  	int err;
>  
> -	/* Change address */
> -	err = marvell_set_page(phydev, MII_MARVELL_MSCR_PAGE);
> -	if (err < 0)
> -		return err;
> -
>  	/* Enable 1000 Mbit */
> -	err = phy_write(phydev, 0x15, 0x1070);
> +	err = phy_write_paged(phydev, MII_MARVELL_MSCR_PAGE,
> +			      MII_88E1121_PHY_MSCR_REG, 0x1070);

Ah, yes, keeping this makes it more backwards compatible.

It would be nice to replace the 0x1070 with #defines.

We already have:

#define MII_88E1121_PHY_MSCR_RX_DELAY	BIT(5)
#define MII_88E1121_PHY_MSCR_TX_DELAY	BIT(4)
#define MII_88E1121_PHY_MSCR_DELAY_MASK	(BIT(5) | BIT(4))

Bits 6 is the MSB of the default MAC speed.
Bit 13 is the LSB of the default MAC speed. These two should default to 10b = 1000Mbps
Bit 12 is reserved, and should be written 1.

    Andrew
