Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8D41C3AE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343489AbhI2LrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:47:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:65233 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhI2LrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 07:47:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="223030288"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="223030288"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 04:45:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="456995440"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 29 Sep 2021 04:45:28 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id B3C8458097E;
        Wed, 29 Sep 2021 04:45:25 -0700 (PDT)
Date:   Wed, 29 Sep 2021 19:45:22 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: pcs: xpcs: fix incorrect CL37 AN
 sequence
Message-ID: <20210929114522.GA2089@linux.intel.com>
References: <20210928041938.3936497-1-vee.khee.wong@linux.intel.com>
 <20210928041938.3936497-3-vee.khee.wong@linux.intel.com>
 <20210928102730.72vays22sulixodb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928102730.72vays22sulixodb@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 10:27:31AM +0000, Vladimir Oltean wrote:
> On Tue, Sep 28, 2021 at 12:19:38PM +0800, Wong Vee Khee wrote:
> > According to Synopsys DesignWare Cores Ethernet PCS databook, it is
> > required to disable Clause 37 auto-negotiation by programming bit-12
> > (AN_ENABLE) to 0 if it is already enabled, before programming various
> > fields of VR_MII_AN_CTRL registers.
> > 
> > After all these programming are done, it is then required to enable
> > Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
> > 
> > Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > ---
> 
> 
> 
> >  drivers/net/pcs/pcs-xpcs.c | 24 ++++++++++++++++++++----
> >  1 file changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> > index da8c81d25edd..eacfb32bb229 100644
> > --- a/drivers/net/pcs/pcs-xpcs.c
> > +++ b/drivers/net/pcs/pcs-xpcs.c
> > @@ -709,11 +709,14 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> >  	int ret;
> >  
> >  	/* For AN for C37 SGMII mode, the settings are :-
> > -	 * 1) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
> > -	 * 2) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
> > +	 * 1) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 0b (Disable SGMII AN in case
> > +	      it is already enabled)
> > +	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
> > +	 * 3) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
> >  	 *    DW xPCS used with DW EQoS MAC is always MAC side SGMII.
> > -	 * 3) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
> > +	 * 4) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
> >  	 *    speed/duplex mode change by HW after SGMII AN complete)
> > +	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 1b (Enable SGMII AN)
> >  	 *
> >  	 * Note: Since it is MAC side SGMII, there is no need to set
> >  	 *	 SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from
> > @@ -721,6 +724,11 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> >  	 *	 between PHY and Link Partner. There is also no need to
> >  	 *	 trigger AN restart for MAC-side SGMII.
> >  	 */
> > +	ret = xpcs_modify(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, AN_CL37_EN,
> 
> Would you mind using "MDIO_CTRL1" instead of "DW_VR_MII_MMD_CTRL", and
> "MDIO_AN_CTRL1_ENABLE" instead of "AN_CL37_EN"? After all, the
> "SR_MII_CTRL" naming from the data book comes from "Standard Register".
> 
> > +			  0);
> > +	if (ret < 0)
> > +		return ret;
> > +
> >  	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
> >  	if (ret < 0)
> >  		return ret;
> > @@ -745,7 +753,15 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> >  	else
> >  		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> >  
> > -	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> > +	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> 
> There is an interesting note in the data book about the MAC_AUTO_SW bit:
> 
> | This mode is valid only when DWC_xpcs is configured as MAC-side
> | SGMII/USXGMII/QSGMII and should be set only when Auto-negotiation is
> | enabled (AN_ENABLE bit is set to 1).
> 
> With your patch, it will be set while the AN_ENABLE bit is zero.
> I wonder whether that's a poor choice of words, because it does
> contradict with the sequence described in section "7.12.1 SGMII
> Auto-Negotiation", and if it just means "only set MAC_AUTO_SW if you
> intend to eventually set AN_ENABLE", not "you must set it only _while_
> AN_ENABLE is set".
>

I am actually following what is described in section "7.12.1 SGMII
Auto-Negotiation". I guess it is more accurate to follow what is
described in there.
 
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret |= AN_CL37_EN;
> 
> So this is the part that really confuses me.
> The xpcs driver did not use to do any configuration at all for this bit.
> Am I right in assuming that we were all operating with the default value?
> Because in your case, the default value is set by your bootloader
> (AN_CL37_EN is set), and in my case, the default is the hardware reset
> (AN_CL37_EN is not set). I think (haven't tested) that this change would
> actually break my setups where phylink_autoneg_inband(mode) returns false.
> 
> So could you please add this conditional?
> 
> 	if (phylink_autoneg_inband(mode))
> 		ret |= MDIO_AN_CTRL1_ENABLE;
> 	else
> 		ret &= ~MDIO_AN_CTRL1_ENABLE;
>

Added this. I will still use 'AN_CL37_EN' instead of
'MDIO_AN_CTRL1_ENABLE' for now. Let's rename all 'AN_CL37_EN' to
'MDIO_AN_CTRL1_ENABLE' later on net-next.

> > +	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
> >  }
> >  
> >  static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
> > -- 
> > 2.25.1
> > 
