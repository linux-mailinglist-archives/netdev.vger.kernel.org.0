Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E4441E936
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352851AbhJAIzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:55:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:56770 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhJAIzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 04:55:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="310919944"
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="310919944"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 01:53:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="589005799"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 01 Oct 2021 01:53:24 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id A655858088F;
        Fri,  1 Oct 2021 01:53:21 -0700 (PDT)
Date:   Fri, 1 Oct 2021 16:53:18 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Message-ID: <20211001085318.GB22563@linux.intel.com>
References: <20210930044421.1309538-1-vee.khee.wong@linux.intel.com>
 <YVWCV1Vaq5SAJflX@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVWCV1Vaq5SAJflX@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 10:24:39AM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 30, 2021 at 12:44:21PM +0800, Wong Vee Khee wrote:
> > According to Synopsys DesignWare Cores Ethernet PCS databook, it is
> > required to disable Clause 37 auto-negotiation by programming bit-12
> > (AN_ENABLE) to 0 if it is already enabled, before programming various
> > fields of VR_MII_AN_CTRL registers.
> > 
> > After all these programming are done, it is then required to enable
> > Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
> > 
> > Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE controller")
> > Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > ---
> > v2 -> v3:
> >  - Added error handling after xpcs_write().
> >  - Added 'changed' flag.
> >  - Added fixes tag.
> > v1 -> v2:
> >  - Removed use of xpcs_modify() helper function.
> >  - Add conditional check on inband auto-negotiation.
> > ---
> >  drivers/net/pcs/pcs-xpcs.c | 41 +++++++++++++++++++++++++++++++++-----
> >  1 file changed, 36 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> > index fb0a83dc09ac..d2126f5d5016 100644
> > --- a/drivers/net/pcs/pcs-xpcs.c
> > +++ b/drivers/net/pcs/pcs-xpcs.c
> > @@ -697,14 +697,18 @@ EXPORT_SYMBOL_GPL(xpcs_config_eee);
> >  
> >  static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> >  {
> > -	int ret;
> > +	int ret, reg_val;
> > +	int changed = 0;
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
> > @@ -712,6 +716,19 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> >  	 *	 between PHY and Link Partner. There is also no need to
> >  	 *	 trigger AN restart for MAC-side SGMII.
> >  	 */
> > +	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (ret & AN_CL37_EN) {
> > +		changed = 1;
> > +		reg_val = ret & ~AN_CL37_EN;
> > +		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> > +				 reg_val);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> 
> I don't think you need to record "changed" here - just maintain a
> local copy of the current state of the register, e.g:
>

You're right. Will remove it on v4.
 
> +	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> +	if (ret < 0)
> +		return ret;
> +
> +	reg_val = ret;
> +	if (reg_val & AN_CL37_EN) {
> +		reg_val &= ~AN_CL37_EN;
> ...
> 
> What you're wanting to do is ensure this bit is clear before you do the
> register changes, and once complete, set the bit back to one. If the bit
> was previously clear, you can omit this write, otherwise the write was
> needed - as you have the code. However, the point is that once you're
> past this code, the state of the register in the device will have the
> AN_CL37_EN clear. See below for the rest of my comments on this...
> 
> > @@ -736,7 +753,21 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> >  	else
> >  		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> >  
> > -	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> > +	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (changed) {
> > +		if (phylink_autoneg_inband(mode))
> > +			reg_val |= AN_CL37_EN;
> > +		else
> > +			reg_val &= ~AN_CL37_EN;
> > +
> > +		return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> > +				  reg_val);
> > +	}
> 
> As I say above, here, you are _guaranteed_ that the AN_CL27_EN bit is
> clear in the register due to the effects of your change above. You say
> in the commit text:
> 
>   After all these programming are done, it is then required to enable
>   Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
> 
> So that makes me think that you _always_ need to write back a value
> with AN_CL27_EN set. So:
> 
> 	reg_val |= AN_CL37_EN;
> 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, reg_val);
> 
> If that is not correct, the commit message is misleading and needs
> fixing.
> 

It is written in the Synopsys PCS Databook:

8. Enable CL37 Auto-negotiation, by programming bit[12] of the
   SR_MII_CTRL Register to 1.

So I think we always need to write back the value. Will fix this in v4.

> Lastly, I would recommend a much better name for this variable rather
> than the bland "reg_val" since you're needing the value preserved over
> a chunk of code. "ctrl" maybe?
> 

I will rename it to 'mdio_ctrl'.

> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
