Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF473ED1A8
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbhHPKLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhHPKLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:11:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E564C061764;
        Mon, 16 Aug 2021 03:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4QKRhG3KxQxaNvYnlbTXs7fK6WPTxWwKQ5psEhwVhPs=; b=QdhF+7cG27aNA7Yfd5ytGzJUx
        TezCVcIh5FIHV1PUXItY6nHCMMl9s1yXpdUZcci88HqJaDLkAcplhE5o9zX/a07HtmAAe7wASNSY/
        kfAMNAdSlbryyCc8bjo1Lw3RL8M41tfSoZPXilwv9VONjEmmwAw5Sx2uYOFe3G8rRzRE0q46ubiCw
        HvLFjFxh711JVm5pRZ9YJhxWP8W5w7mbNlpHJnvNYiCtL8XU9Fj1D042emaAum+7+DBqwHEyR955j
        gctSw6RNfEAIuMzGmuqlVa/Mr7yImTQqbmNVVxdrVYER/Ltexz5CsC6DZez4aMiSbdrmJKVXHDmYU
        PPBshUxYA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47368)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mFZa6-0007fD-JE; Mon, 16 Aug 2021 11:10:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mFZa4-0007u2-M8; Mon, 16 Aug 2021 11:10:56 +0100
Date:   Mon, 16 Aug 2021 11:10:56 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: phy: marvell: Add WAKE_PHY support to
 WOL event
Message-ID: <20210816101056.GI22278@shell.armlinux.org.uk>
References: <20210813084508.182333-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813084508.182333-1-yoong.siang.song@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 04:45:08PM +0800, Song Yoong Siang wrote:
> Add Wake-on-PHY feature support by enabling the Link Up Event.
> 
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>

Hi,

I think this can be greatly simplified - see below.

> ---
>  drivers/net/phy/marvell.c | 39 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 3de93c9f2744..415e2a01c151 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -155,6 +155,7 @@
>  
>  #define MII_88E1318S_PHY_WOL_CTRL				0x10
>  #define MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS		BIT(12)
> +#define MII_88E1318S_PHY_WOL_CTRL_LINK_UP_ENABLE		BIT(13)
>  #define MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE	BIT(14)
>  
>  #define MII_PHY_LED_CTRL	        16
> @@ -1746,13 +1747,19 @@ static void m88e1318_get_wol(struct phy_device *phydev,
>  {
>  	int ret;
>  
> -	wol->supported = WAKE_MAGIC;
> +	wol->supported = WAKE_MAGIC | WAKE_PHY;
>  	wol->wolopts = 0;
>  
>  	ret = phy_read_paged(phydev, MII_MARVELL_WOL_PAGE,
>  			     MII_88E1318S_PHY_WOL_CTRL);
> -	if (ret >= 0 && ret & MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE)
> +	if (ret < 0)
> +		return;
> +
> +	if (ret & MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE)
>  		wol->wolopts |= WAKE_MAGIC;
> +
> +	if (ret & MII_88E1318S_PHY_WOL_CTRL_LINK_UP_ENABLE)
> +		wol->wolopts |= WAKE_PHY;
>  }
>  
>  static int m88e1318_set_wol(struct phy_device *phydev,
> @@ -1764,7 +1771,7 @@ static int m88e1318_set_wol(struct phy_device *phydev,
>  	if (oldpage < 0)
>  		goto error;
>  
> -	if (wol->wolopts & WAKE_MAGIC) {
> +	if (wol->wolopts & (WAKE_MAGIC | WAKE_PHY)) {
>  		/* Explicitly switch to page 0x00, just to be sure */
>  		err = marvell_write_page(phydev, MII_MARVELL_COPPER_PAGE);
>  		if (err < 0)
> @@ -1796,7 +1803,9 @@ static int m88e1318_set_wol(struct phy_device *phydev,
>  				   MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW);
>  		if (err < 0)
>  			goto error;
> +	}

Wouldn't it make more sense to always select the WOL page at this point
between these two blocks? From what I can see, the WOL page is selected
by both true and false blocks of the next if() statement, and again by
the newly added if() statement for WAKE_PHY.

Other than that, I don't see any issues.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
