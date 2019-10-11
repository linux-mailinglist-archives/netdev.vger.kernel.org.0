Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC61BD38F9
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 07:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfJKF5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 01:57:13 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36252 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfJKF5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 01:57:13 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id A4B3C25B7D9;
        Fri, 11 Oct 2019 16:57:09 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 98F77E21812; Fri, 11 Oct 2019 07:57:07 +0200 (CEST)
Date:   Fri, 11 Oct 2019 07:57:07 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH V2 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
Message-ID: <20191011055707.stsk5dwwg7acfmnv@verge.net.au>
References: <20191010194622.28742-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010194622.28742-1-marex@denx.de>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 09:46:21PM +0200, Marek Vasut wrote:
> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
> is wrong, since the KSZ8051 configures registers of the PHY which are
> not present on the simplified KSZ87xx switch PHYs and misconfigures
> other registers of the KSZ87xx switch PHYs.
> 
> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
> KSZ87xx switch by checking the Basic Status register Bit 0, which is
> read-only and indicates presence of the Extended Capability Registers.
> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
> 
> This patch implements simple check for the presence of this bit for
> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
> PHY driver instance.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: George McCollister <george.mccollister@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> ---
> NOTE: It was also suggested to populate phydev->dev_flags to discern
>       the PHY from the switch, this does not work for setups where
>       the switch is used as a PHY without a DSA driver. Checking the
>       BMSR Bit 0 for Extended Capability Register works for both DSA
>       and non-DSA usecase.
> V2: Move phy_id check into ksz8051_match_phy_device() and
>     ksz8795_match_phy_device() and drop phy_id{,_mask} from the
>     ksphy_driver[] list to avoid matching on other PHY IDs.
> ---
>  drivers/net/phy/micrel.c | 40 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 2fea5541c35a..028a4a177790 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -341,6 +341,25 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
>  	return genphy_config_aneg(phydev);
>  }
>  
> +static int ksz8051_match_phy_device(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
> +		return 0;
> +
> +	ret = phy_read(phydev, MII_BMSR);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* KSZ8051 PHY and KSZ8794/KSZ8795/KSZ8765 switch share the same
> +	 * exact PHY ID. However, they can be told apart by the extended
> +	 * capability registers presence. The KSZ8051 PHY has them while
> +	 * the switch does not.
> +	 */
> +	return ret & BMSR_ERCAP;
> +}
> +
>  static int ksz8081_config_init(struct phy_device *phydev)
>  {
>  	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
> @@ -364,6 +383,21 @@ static int ksz8061_config_init(struct phy_device *phydev)
>  	return kszphy_config_init(phydev);
>  }
>  
> +static int ksz8795_match_phy_device(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8795)
> +		return 0;
> +
> +	ret = phy_read(phydev, MII_BMSR);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* See comment in ksz8051_match_phy_device() for details. */
> +	return !(ret & BMSR_ERCAP);
> +}
> +

Hi Marek,

given the similarity between ksz8051_match_phy_device() and
ksz8795_match_phy_device() I wonder if a common helper is appropriate.

>  static int ksz9021_load_values_from_of(struct phy_device *phydev,
>  				       const struct device_node *of_node,
>  				       u16 reg,
> @@ -1017,8 +1051,6 @@ static struct phy_driver ksphy_driver[] = {
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> -	.phy_id		= PHY_ID_KSZ8051,
> -	.phy_id_mask	= MICREL_PHY_ID_MASK,
>  	.name		= "Micrel KSZ8051",
>  	/* PHY_BASIC_FEATURES */
>  	.driver_data	= &ksz8051_type,
> @@ -1029,6 +1061,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.get_sset_count = kszphy_get_sset_count,
>  	.get_strings	= kszphy_get_strings,
>  	.get_stats	= kszphy_get_stats,
> +	.match_phy_device = ksz8051_match_phy_device,
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> @@ -1141,13 +1174,12 @@ static struct phy_driver ksphy_driver[] = {
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> -	.phy_id		= PHY_ID_KSZ8795,
> -	.phy_id_mask	= MICREL_PHY_ID_MASK,
>  	.name		= "Micrel KSZ8795",
>  	/* PHY_BASIC_FEATURES */
>  	.config_init	= kszphy_config_init,
>  	.config_aneg	= ksz8873mll_config_aneg,
>  	.read_status	= ksz8873mll_read_status,
> +	.match_phy_device = ksz8795_match_phy_device,
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> -- 
> 2.23.0
> 
