Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D2B4A9A9F
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbiBDOFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:05:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233512AbiBDOFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 09:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9JssIWingg3SjbCos9YUJucNleA1gB0olHIjVFnf1WI=; b=VyMHJWq+721SJm8kgbWIjj6V0v
        ZflmIrSBYycYlU0fQ9zogHJyGC3dM87h7nsg4lRFSLQeaEUZTayJumegAIQjGy9BU6yqiskRkPsFs
        g6kUdypizOb+uKehTinKqJfHKhUBl5nTCGC7gtMwcbXIKzzOIXS4VCeG/9QijFzTdBgI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFzCz-004HHx-DR; Fri, 04 Feb 2022 15:05:05 +0100
Date:   Fri, 4 Feb 2022 15:05:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY
 support
Message-ID: <Yf0ykctMgWKswgpC@lunn.ch>
References: <20220204133635.296974-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <20220204133635.296974-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204133635.296974-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 02:36:34PM +0100, Enguerrand de Ribaucourt wrote:
> Adding Microchip 9897 Phy included in KSZ9897 Switch.
> The KSZ9897 shares the same prefix as the KSZ8081. The phy_id_mask was
> updated to allow the KSZ9897 to be matched.
> 
> Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
> ---
>  drivers/net/phy/micrel.c   | 15 +++++++++++++--
>  include/linux/micrel_phy.h |  1 +
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 44a24b99c894..9b2047e26449 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1726,7 +1726,7 @@ static struct phy_driver ksphy_driver[] = {
>  }, {
>  	.phy_id		= PHY_ID_KSZ8081,
>  	.name		= "Micrel KSZ8081 or KSZ8091",
> -	.phy_id_mask	= MICREL_PHY_ID_MASK,
> +	.phy_id_mask	= 0x00ffffff,

You can probably use PHY_ID_MATCH_EXACT().

>  	.flags		= PHY_POLL_CABLE_TEST,
>  	/* PHY_BASIC_FEATURES */
>  	.driver_data	= &ksz8081_type,
> @@ -1869,6 +1869,16 @@ static struct phy_driver ksphy_driver[] = {
>  	.config_init	= kszphy_config_init,
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
> +}, {
> +	.phy_id		= PHY_ID_KSZ9897,
> +	.phy_id_mask	= 0x00ffffff,

Here as well.

> +	.name		= "Microchip KSZ9897",
> +	/* PHY_BASIC_FEATURES */
> +	.config_init	= kszphy_config_init,
> +	.config_aneg	= ksz8873mll_config_aneg,
> +	.read_status	= ksz8873mll_read_status,
> +	.suspend	= genphy_suspend,
> +	.resume		= genphy_resume,
>  } };
>  
>  module_phy_driver(ksphy_driver);
> @@ -1888,11 +1898,12 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
>  	{ PHY_ID_KSZ8041, MICREL_PHY_ID_MASK },
>  	{ PHY_ID_KSZ8051, MICREL_PHY_ID_MASK },
>  	{ PHY_ID_KSZ8061, MICREL_PHY_ID_MASK },
> -	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
> +	{ PHY_ID_KSZ8081, 0x00ffffff },

And here.

>  	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
>  	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
>  	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
>  	{ PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
> +	{ PHY_ID_KSZ9897, 0x00ffffff },

etc.

	Andrew
