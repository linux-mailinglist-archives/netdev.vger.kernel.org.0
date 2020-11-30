Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9C2C8219
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgK3K0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgK3K0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:26:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB9BC0613CF;
        Mon, 30 Nov 2020 02:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vEW1++ZGtkTahDMwrYyBH6nvIhUYOGLhVMOksh4ZP+I=; b=mQTfXfm4g4w+luNlPlFzp1/Ri
        EqaXltUc9BwMansy2Kg861bA+07iAU1sH5E8mWceS0ed/5IlK+OBfDaRLO6fkisGFbc3NbusPs+w1
        35iux4THBzPdFVgQAvG1Z5IOjgR8DI2cUHoDl3pJoD7r1rRE0JD0kRpU12bLulgPxgNftbEdoKvA5
        ul9E7CUIF8eL2Fg95KlZP16IUQG4ORg/Mxz8cIoGFKkL8WJHuzq5iUwHInVyw85X7h8x2zMVq/gkZ
        uePwUpFzk5IoSJUA6XrPbUKd8d/r/kOBiJzurPjNXY2vReS4gSpAI56jQRbUhUge3X6T4sgGnNA3H
        tTZoVp79Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37950)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kjgNZ-0006Zb-KR; Mon, 30 Nov 2020 10:25:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kjgNY-0004vj-CH; Mon, 30 Nov 2020 10:25:56 +0000
Date:   Mon, 30 Nov 2020 10:25:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: replace __phy_modify()
Message-ID: <20201130102556.GU1551@shell.armlinux.org.uk>
References: <1606731399-8772-1-git-send-email-yejune.deng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606731399-8772-1-git-send-email-yejune.deng@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 06:16:39PM +0800, Yejune Deng wrote:
> a set of phy_set_bits() looks more neater
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>

Sorry, but NAK. You seem to be doing a mechanical code change without
first understanding the code, as the patch shows no sign of an
understanding of the difference between phy_modify() and __phy_modify().
This means you are introducing new bugs with this change.

Please investigate the differences between the two variants of
phy_modify() and post a more correct patch.

Thanks.

> ---
>  drivers/net/phy/marvell.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 587930a..f402e7f 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -1132,8 +1132,8 @@ static int m88e1510_config_init(struct phy_device *phydev)
>  			return err;
>  
>  		/* PHY reset is necessary after changing MODE[2:0] */
> -		err = phy_modify(phydev, MII_88E1510_GEN_CTRL_REG_1, 0,
> -				 MII_88E1510_GEN_CTRL_REG_1_RESET);
> +		err = phy_set_bits(phydev, MII_88E1510_GEN_CTRL_REG_1,
> +				   MII_88E1510_GEN_CTRL_REG_1_RESET);
>  		if (err < 0)
>  			return err;
>  
> @@ -1725,7 +1725,7 @@ static int m88e1318_set_wol(struct phy_device *phydev,
>  			__phy_read(phydev, MII_M1011_IEVENT);
>  
>  		/* Enable the WOL interrupt */
> -		err = __phy_modify(phydev, MII_88E1318S_PHY_CSIER, 0,
> +		err = phy_set_bits(phydev, MII_88E1318S_PHY_CSIER,
>  				   MII_88E1318S_PHY_CSIER_WOL_EIE);
>  		if (err < 0)
>  			goto error;
> @@ -1735,10 +1735,10 @@ static int m88e1318_set_wol(struct phy_device *phydev,
>  			goto error;
>  
>  		/* Setup LED[2] as interrupt pin (active low) */
> -		err = __phy_modify(phydev, MII_88E1318S_PHY_LED_TCR,
> -				   MII_88E1318S_PHY_LED_TCR_FORCE_INT,
> -				   MII_88E1318S_PHY_LED_TCR_INTn_ENABLE |
> -				   MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW);
> +		err = phy_modify(phydev, MII_88E1318S_PHY_LED_TCR,
> +				 MII_88E1318S_PHY_LED_TCR_FORCE_INT,
> +				 MII_88E1318S_PHY_LED_TCR_INTn_ENABLE |
> +				 MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW);
>  		if (err < 0)
>  			goto error;
>  
> @@ -1764,7 +1764,7 @@ static int m88e1318_set_wol(struct phy_device *phydev,
>  			goto error;
>  
>  		/* Clear WOL status and enable magic packet matching */
> -		err = __phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL, 0,
> +		err = phy_set_bits(phydev, MII_88E1318S_PHY_WOL_CTRL,
>  				   MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS |
>  				   MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE);
>  		if (err < 0)
> @@ -1775,9 +1775,9 @@ static int m88e1318_set_wol(struct phy_device *phydev,
>  			goto error;
>  
>  		/* Clear WOL status and disable magic packet matching */
> -		err = __phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL,
> -				   MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE,
> -				   MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS);
> +		err = phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL,
> +				 MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE,
> +				 MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS);
>  		if (err < 0)
>  			goto error;
>  	}
> @@ -1995,7 +1995,7 @@ static int marvell_cable_test_start_common(struct phy_device *phydev)
>  		return bmsr;
>  
>  	if (bmcr & BMCR_ANENABLE) {
> -		ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
> +		ret =  phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE);
>  		if (ret < 0)
>  			return ret;
>  		ret = genphy_soft_reset(phydev);
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
