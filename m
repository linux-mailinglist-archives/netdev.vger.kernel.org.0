Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2517F9AE6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfKLUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:40:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36638 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfKLUkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 15:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lrnDPZVh/OyBaAKxy0kOshtkgZKmgCWulzk6XftRP70=; b=gJ7DzG6zE/04FCMwnj0TgMn3eb
        46tt584s4wf4JJNyjq9vvzrzLpikzH+oXt08qJszwOMKOFkHwdYD8q173R9CUWyCjgzyp56FGpvw1
        yXHXLDj40puJhz4dA833sWLVswdGad3dYMKpUZIa8t1InGh3eGwqb7OqcVzMwS9KkV20=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUcxj-0003SO-MA; Tue, 12 Nov 2019 21:40:31 +0100
Date:   Tue, 12 Nov 2019 21:40:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Message-ID: <20191112204031.GH10875@lunn.ch>
References: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 10:54:08AM -0500, Bryan Whitehead wrote:
> Add support for the following VSC PHYs
> 	VSC8504, VSC8552, VSC8572,
> 	VSC8562, VSC8564, VSC8575, VSC8582
> 
> Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
> ---
>  drivers/net/phy/mscc.c | 182 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 182 insertions(+)
> 
> diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
> index 805cda3..8933681 100644
> --- a/drivers/net/phy/mscc.c
> +++ b/drivers/net/phy/mscc.c
> @@ -253,12 +253,18 @@ enum rgmii_rx_clock_delay {
>  #define MSCC_PHY_TR_MSB			  18
>  
>  /* Microsemi PHY ID's */
> +#define PHY_ID_VSC8504			  0x000704c0
>  #define PHY_ID_VSC8514			  0x00070670
>  #define PHY_ID_VSC8530			  0x00070560
>  #define PHY_ID_VSC8531			  0x00070570
>  #define PHY_ID_VSC8540			  0x00070760
>  #define PHY_ID_VSC8541			  0x00070770
> +#define PHY_ID_VSC8552			  0x000704e0
> +#define PHY_ID_VSC856X			  0x000707e0
> +#define PHY_ID_VSC8572			  0x000704d0
>  #define PHY_ID_VSC8574			  0x000704a0
> +#define PHY_ID_VSC8575			  0x000707d0
> +#define PHY_ID_VSC8582			  0x000707b0
>  #define PHY_ID_VSC8584			  0x000707c0
>  
>  #define MSCC_VDDMAC_1500		  1500
> @@ -1597,6 +1603,8 @@ static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
>  
>  		phy = container_of(map[addr], struct phy_device, mdio);
>  
> +		if (!phy)
> +			continue;
> +
>  		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
>  		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
>  			continue;
> @@ -1648,9 +1656,27 @@ static int vsc8584_config_init(struct phy_device *phydev)
>  	 */
>  	if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0)) {
>  		if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
> +		    (PHY_ID_VSC8504 & phydev->drv->phy_id_mask))
> +			ret = vsc8574_config_pre_init(phydev);
> +		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
> +		    (PHY_ID_VSC8552 & phydev->drv->phy_id_mask))
> +			ret = vsc8574_config_pre_init(phydev);
> +		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
> +		    (PHY_ID_VSC856X & phydev->drv->phy_id_mask))
> +			ret = vsc8584_config_pre_init(phydev);

Could we turn this into a switch statement? I think

      switch (phydev->phy_id & phydev->drv->phy_id_mask) {
      case PHY_ID_VSC8504:
      case PHY_ID_VSC8552:
      	   ret = vsc8574_config_pre_init(phydev);
	   break
      case PHY_ID_VSC856X:
      	   ret = vsc8584_config_pre_init(phydev);
	   break;

etc should work, since PHY_ID_VSC8<FOO> always has the lower nibble set
to 0.

   Andrew
