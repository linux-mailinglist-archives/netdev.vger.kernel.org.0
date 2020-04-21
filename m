Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479F01B287E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgDUNv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:51:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgDUNv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 09:51:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mC8revuM/eirCe6Cg2dOwMCGMagYu8uBBjjfqIa21+s=; b=qttLeasPRX2EmDfgJDipY5f2KN
        i2vHtnZWvDqwcvMamK7BlYZWWSn/M9wVRJ/OCBQB0JafY3hmZW1sm4kq1FIKRWLKnLtmtwqCGF+W5
        gSSQOK0EOIAbPIvfFLT8+ggRrJ+hMjoRAxzlW9P+12zpkxJCvGtJP0i/7NZaCNJwEq5Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQtJU-0041zy-0C; Tue, 21 Apr 2020 15:51:48 +0200
Date:   Tue, 21 Apr 2020 15:51:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/4] net: mdio: of: export part of
 of_mdiobus_register_phy()
Message-ID: <20200421135147.GE937199@lunn.ch>
References: <20200421125219.8402-1-o.rempel@pengutronix.de>
 <20200421125219.8402-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421125219.8402-4-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 02:52:18PM +0200, Oleksij Rempel wrote:
> This function will be needed in tja11xx driver for secondary PHY
> support.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/of/of_mdio.c    | 73 ++++++++++++++++++++++++-----------------
>  include/linux/of_mdio.h | 11 ++++++-
>  2 files changed, 52 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index 8270bbf505fb..d9e637b624ce 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -60,39 +60,15 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
>  	return register_mii_timestamper(arg.np, arg.args[0]);
>  }
>  
> -static int of_mdiobus_register_phy(struct mii_bus *mdio,
> -				    struct device_node *child, u32 addr)
> +int __of_mdiobus_register_phy(struct mii_bus *mdio, struct phy_device *phy,
> +			      struct device_node *child, u32 addr)
>  {

Hi Oleksij

I would prefer a different name. __foo functions often indicate
locking is needed, or an internal API which should not be used except
internally. This is going to be an official API. Maybe call it
of_mdiobus_phy_device_register() ?

	 Andrew
