Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2834918580D
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgCOByM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgCOByM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zPDB1HvowBEZp5Hyh1O74oA1y5oZAO1PHhyz4vUG3XY=; b=Z7KYS7Na9nykCUWpFbxMkXPqXh
        Lj2NP8Da/K6YD7QkhcfchqpLkfD15k/DYbF8/ikaIN3nm4HRXvOeP2P9NBqrpqHBOIscYaGS6rEtV
        EBWpOn8bO/LiiJLFfUozIGo6YlmayW/fbPQ6VNWF2A+PJPhEi9bmNC0FYLp9rLx1lUVQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDEdU-0002Uk-Fu; Sat, 14 Mar 2020 22:48:00 +0100
Date:   Sat, 14 Mar 2020 22:48:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: phylink: pcs: add 802.3 clause 45
 helpers
Message-ID: <20200314214800.GF8622@lunn.ch>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
 <E1jD44s-0006Mx-Fv@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD44s-0006Mx-Fv@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:31:34AM +0000, Russell King wrote:
> Implement helpers for PCS accessed via the MII bus using 802.3 clause
> 45 cycles for 10GBASE-R. Only link up/down is supported, 10G full
> duplex is assumed.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 30 ++++++++++++++++++++++++++++++
>  include/linux/phylink.h   |  2 ++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 7ca427c46d9f..bff570f59d5c 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2247,4 +2247,34 @@ void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs)
>  }
>  EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_an_restart);
>  
> +#define C45_ADDR(d,a)	(MII_ADDR_C45 | (d) << 16 | (a))

Hi Russell

That seems like a macro that should be made global.

dsa/mv88e6xxx/serdes.c: int reg_c45 = MII_ADDR_C45 | device << 16 | reg;
dsa/mv88e6xxx/serdes.c: int reg_c45 = MII_ADDR_C45 | device << 16 | reg;
ethernet/intel/ixgbe/ixgbe_main.c:                      regnum |= (devad << 16) | MII_ADDR_C45;
ethernet/intel/ixgbe/ixgbe_main.c:                      regnum |= (devad << 16) | MII_ADDR_C45;
phy/phylink.c:          devad = MII_ADDR_C45 | devad << 16 | reg;
phy/phylink.c:          devad = MII_ADDR_C45 | devad << 16 | reg;
phy/phylink.c:          devad = MII_ADDR_C45 | devad << 16 | reg;
phy/phylink.c:          devad = MII_ADDR_C45 | devad << 16 | reg;
phy/phy-core.c:         u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
phy/phy-core.c:         u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
phy/phy_device.c:       reg_addr = MII_ADDR_C45 | dev_addr << 16 | MDIO_DEVS2;
phy/phy_device.c:       reg_addr = MII_ADDR_C45 | dev_addr << 16 | MDIO_DEVS1;
phy/phy_device.c:               reg_addr = MII_ADDR_C45 | i << 16 | MII_PHYSID1;
phy/phy_device.c:               reg_addr = MII_ADDR_C45 | i << 16 | MII_PHYSID2;
phy/phy.c:                      devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
phy/phy.c:                      devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
phy/bcm87xx.c:          u32 regnum = MII_ADDR_C45 | (devid << 16) | reg;

I'm not suggesting you convert all these cases, just make the macro
available and we can make more use of it later.

Thanks
	Andrew
