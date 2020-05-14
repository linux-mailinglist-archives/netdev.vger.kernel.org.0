Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CD61D253A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 04:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgENCy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 22:54:29 -0400
Received: from 220-134-220-36.HINET-IP.hinet.net ([220.134.220.36]:51650 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgENCy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 22:54:29 -0400
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id 04E1sNaA001167
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 14 May 2020 09:54:24 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id 04E1sKI0001166;
        Thu, 14 May 2020 09:54:20 +0800 (CST)
        (envelope-from kevlo)
Date:   Thu, 14 May 2020 09:54:20 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: phy: broadcom: fix
 BCM54XX_SHD_SCR3_TRDDAPD value for BCM54810
Message-ID: <20200514015420.GA1159@ns.kevlo.org>
References: <20200514005733.GA94953@ns.kevlo.org>
 <63c86b00-171b-cdda-317f-1b14622a50d1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63c86b00-171b-cdda-317f-1b14622a50d1@gmail.com>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 06:31:29PM -0700, Florian Fainelli wrote:
> 
> 
> 
> On 5/13/2020 5:57 PM, Kevin Lo wrote:
> > Set the correct bit when checking for PHY_BRCM_DIS_TXCRXC_NOENRGY on the 
> > BCM54810 PHY.
> 
> Indeed, good catch!
> > 
> > Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Is the following commit when it started to break?
> 
> Fixes: 0ececcfc9267 ("net: phy: broadcom: Allow BCM54810 to use
> bcm54xx_adjust_rxrefclk()")

Yes.

> > ---
> > diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> > index 97201d5cf007..45d0aefb964c 100644
> > --- a/drivers/net/phy/broadcom.c
> > +++ b/drivers/net/phy/broadcom.c
> > @@ -225,8 +225,12 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
> >  	else
> >  		val |= BCM54XX_SHD_SCR3_DLLAPD_DIS;
> >  
> > -	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY)
> > -		val |= BCM54XX_SHD_SCR3_TRDDAPD;
> > +	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
> > +		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810)
> > +			val |= BCM54810_SHD_SCR3_TRDDAPD;
> > +		else
> > +			val |= BCM54XX_SHD_SCR3_TRDDAPD;
> > +	}
> >  
> >  	if (orig != val)
> >  		bcm_phy_write_shadow(phydev, BCM54XX_SHD_SCR3, val);
> > diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> > index d41624db6de2..1d339a862f7b 100644
> > --- a/include/linux/brcmphy.h
> > +++ b/include/linux/brcmphy.h
> > @@ -255,6 +255,7 @@
> >  #define BCM54810_EXP_BROADREACH_LRE_MISC_CTL_EN	(1 << 0)
> >  #define BCM54810_SHD_CLK_CTL			0x3
> >  #define BCM54810_SHD_CLK_CTL_GTXCLK_EN		(1 << 9)
> > +#define BCM54810_SHD_SCR3_TRDDAPD		0x0100
> >  
> >  /* BCM54612E Registers */
> >  #define BCM54612E_EXP_SPARE0		(MII_BCM54XX_EXP_SEL_ETC + 0x34)
> > 
> 
> -- 
> Florian
