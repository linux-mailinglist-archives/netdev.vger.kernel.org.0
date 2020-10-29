Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CC029ED0D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbgJ2NiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:38:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgJ2NiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 09:38:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY87r-004AMG-Fc; Thu, 29 Oct 2020 14:37:59 +0100
Date:   Thu, 29 Oct 2020 14:37:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: realtek: Add phy ids for
 RTL8226-CG/RTL8226B-CG
Message-ID: <20201029133759.GQ933237@lunn.ch>
References: <1603973277-1634-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603973277-1634-1-git-send-email-willy.liu@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 08:07:57PM +0800, Willy Liu wrote:
> Realtek single-port 2.5Gbps Ethernet PHY ids as below:
> RTL8226-CG: 0x001cc800(ES)/0x001cc838(MP)
> RTL8226B-CG/RTL8221B-CG: 0x001cc840(ES)/0x001cc848(MP)
> ES: engineer sample
> MP: mass production
> 
> Since above PHYs are already in mass production stage,
> mass production id should be added.
> 
> Signed-off-by: Willy Liu <willy.liu@realtek.com>
> ---
>  drivers/net/phy/realtek.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>  mode change 100644 => 100755 drivers/net/phy/realtek.c
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> old mode 100644
> new mode 100755
> index fb1db71..988f075
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -57,6 +57,9 @@
>  #define RTLGEN_SPEED_MASK			0x0630
>  
>  #define RTL_GENERIC_PHYID			0x001cc800
> +#define RTL_8226_MP_PHYID			0x001cc838
> +#define RTL_8221B_ES_PHYID			0x001cc840
> +#define RTL_8221B_MP_PHYID			0x001cc848
>  
>  MODULE_DESCRIPTION("Realtek PHY driver");
>  MODULE_AUTHOR("Johnson Leung");
> @@ -533,10 +536,17 @@ static int rtlgen_match_phy_device(struct phy_device *phydev)
>  
>  static int rtl8226_match_phy_device(struct phy_device *phydev)
>  {
> -	return phydev->phy_id == RTL_GENERIC_PHYID &&
> +	return (phydev->phy_id == RTL_GENERIC_PHYID) ||
> +	       (phydev->phy_id == RTL_8226_MP_PHYID) &&
>  	       rtlgen_supports_2_5gbps(phydev);

Hi Willy

If i understand the code correctly, this match function is used
because the engineering sample did not use a proper ID? The mass
production part does, so there is no need to make use of this
hack. Please just list it as a normal PHY using PHY_ID_MATCH_EXACT().


>  }
>  
> +static int rtl8221b_match_phy_device(struct phy_device *phydev)
> +{
> +	return (phydev->phy_id == RTL_8221B_ES_PHYID) ||
> +	       (phydev->phy_id == RTL_8221B_MP_PHYID);
> +}

Again, these appear to be well defined ID, so just list them in the
normal ways.

       Andrew
