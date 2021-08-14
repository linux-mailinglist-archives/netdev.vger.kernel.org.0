Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350753EC41B
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbhHNR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 13:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbhHNR1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 13:27:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F5DC061764;
        Sat, 14 Aug 2021 10:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ts6p6DQyVVItKQ36n6pBKr81c8bi9xYRh03p1TenZaI=; b=VwZQ0ebrVRQEh16Wv2emfZGPQ
        m7aTqirnFQfWuPWGcutZb/cvsfgATL3BFVunz4xEVgIX3/MLWA1A9paNiuioU4Q4ZiKMB9NqLnl5J
        9nGEVyBDYQ+5J4XOZKcnIpfNiYJKSPTaMxzeb2tsIbK4EEQZD1+SL1mHJ2vgblwNHQjBdbSuF8ykX
        TVnYIW+GYmRUnUp4sshsc+vVX2OEtanNrqNKyHfglFqgusd6SrgoS66jtLbO3QSMcJf3GmAHbBmhB
        Z4gZ6zxTtGVx3+6NHyZPtnkdUBcmvwVvOXaqwvPJXB0i4fS4EsDt0aizk/FCk8bDd4E7dcXlOz2Rm
        kQMod8q7g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47290)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mExQw-0005SN-V5; Sat, 14 Aug 2021 18:26:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mExQu-0006DJ-SL; Sat, 14 Aug 2021 18:26:56 +0100
Date:   Sat, 14 Aug 2021 18:26:56 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <20210814172656.GA22278@shell.armlinux.org.uk>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813084536.182381-1-yoong.siang.song@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 04:45:36PM +0800, Song Yoong Siang wrote:
> Add Wake-on-PHY feature support by enabling the Link Status Changed
> interrupt.
> 
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---
>  drivers/net/phy/marvell10g.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 0b7cae118ad7..d46761c225f0 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -76,6 +76,11 @@ enum {
>  	MV_PCS_CSSR1_SPD2_2500	= 0x0004,
>  	MV_PCS_CSSR1_SPD2_10000	= 0x0000,
>  
> +	/* Copper Specific Interrupt registers */
> +	MV_PCS_INTR_ENABLE	= 0x8010,
> +	MV_PCS_INTR_ENABLE_LSC	= BIT(10),
> +	MV_PCS_INTR_STS		= 0x8011,
> +
>  	/* Temperature read register (88E2110 only) */
>  	MV_PCS_TEMP		= 0x8042,
>  
> @@ -1036,7 +1041,7 @@ static void mv3110_get_wol(struct phy_device *phydev,
>  {
>  	int ret;
>  
> -	wol->supported = WAKE_MAGIC;
> +	wol->supported = WAKE_MAGIC | WAKE_PHY;
>  	wol->wolopts = 0;
>  
>  	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_WOL_CTRL);
> @@ -1045,6 +1050,13 @@ static void mv3110_get_wol(struct phy_device *phydev,
>  
>  	if (ret & MV_V2_WOL_CTRL_MAGIC_PKT_EN)
>  		wol->wolopts |= WAKE_MAGIC;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_INTR_ENABLE);
> +	if (ret < 0)
> +		return;
> +
> +	if (ret & MV_PCS_INTR_ENABLE_LSC)
> +		wol->wolopts |= WAKE_PHY;
>  }
>  
>  static int mv3110_set_wol(struct phy_device *phydev,
> @@ -1099,6 +1111,25 @@ static int mv3110_set_wol(struct phy_device *phydev,
>  			return ret;
>  	}
>  
> +	if (wol->wolopts & WAKE_PHY) {
> +		/* Enable the link status changed interrupt */
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS,
> +				       MV_PCS_INTR_ENABLE,
> +				       MV_PCS_INTR_ENABLE_LSC);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Clear the interrupt status register */
> +		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_INTR_STS);
> +	} else {
> +		/* Disable the link status changed interrupt */
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PCS,
> +					 MV_PCS_INTR_ENABLE,
> +					 MV_PCS_INTR_ENABLE_LSC);
> +		if (ret < 0)
> +			return ret;
> +	}
> +

How does this work if the driver has no interrupt support? What is
the hardware setup this has been tested with?

What if we later want to add interrupt support to this driver to
support detecting changes in link state - isn't using this bit
in the interrupt enable register going to confict with that?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
