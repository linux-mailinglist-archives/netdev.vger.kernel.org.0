Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DD31C2671
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 17:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgEBPJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 11:09:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37954 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbgEBPJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 May 2020 11:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IFsRGO5e1rfVXlct2Kp+RCv1fGdk2G1SnctbUVOtFHs=; b=ch1rntif43Fa9B7XMjkLBAKmi9
        iyiyLfX7FNY908IAIM4uHfnC0vQSS/y2DOtNUx1NY3tjKHcuiMrDpoCrrx8xX16f9hA9XjvAAKevI
        xrP5tdO+E8HSDQfbDfgrPVE5qO1X9ml26i7hJIO5nx6utQQOJTIc2Uib59IL1Cl8jcKI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUtlB-000e5x-7H; Sat, 02 May 2020 17:08:57 +0200
Date:   Sat, 2 May 2020 17:08:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next 1/2] ethtool: Add support for 100Gbps per lane
 link modes
Message-ID: <20200502150857.GC142589@lunn.ch>
References: <20200430234106.52732-1-saeedm@mellanox.com>
 <20200430234106.52732-2-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430234106.52732-2-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 04:41:05PM -0700, Saeed Mahameed wrote:
> From: Meir Lichtinger <meirl@mellanox.com>
> 
> Define 100G, 200G and 400G link modes using 100Gbps per lane
> 
> Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
> CC: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Aya Levin <ayal@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/phy/phy-core.c   | 17 ++++++++++++++++-
>  include/uapi/linux/ethtool.h | 15 +++++++++++++++
>  net/ethtool/common.c         | 15 +++++++++++++++
>  net/ethtool/linkmodes.c      | 16 ++++++++++++++++
>  4 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 66b8c61ca74c..a71fc8b18973 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -8,7 +8,7 @@
>  
>  const char *phy_speed_to_str(int speed)
>  {
> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 75,
> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 90,
>  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>  		"If a speed or mode has been added please update phy_speed_to_str "
>  		"and the PHY settings array.\n");
> @@ -78,12 +78,22 @@ static const struct phy_setting settings[] = {
>  	PHY_SETTING( 400000, FULL, 400000baseLR8_ER8_FR8_Full	),
>  	PHY_SETTING( 400000, FULL, 400000baseDR8_Full		),
>  	PHY_SETTING( 400000, FULL, 400000baseSR8_Full		),
> +	PHY_SETTING( 400000, FULL, 400000baseCR4_Full		),
> +	PHY_SETTING( 400000, FULL, 400000baseKR4_Full		),
> +	PHY_SETTING( 400000, FULL, 400000baseLR4_ER4_FR4_Full	),

Hi Mier, Saeed.

Could you explain this last one? Seems unlikely this is a 12 pair link
mode. So i assume it is four pair which can do LR4, ER4 or FR4? Can
you connect a 400000baseLR4 to a 400000baseER4 with a 10Km cable and
it work? How do you know you have connected a 400000baseLR4 to a
400000baseER4 with a 40Km and it is not expected to work, when looking
at ethtool? I assume the EEPROM contents tell you if the module is
LR4, ER4, or FR4?

     Andrew
