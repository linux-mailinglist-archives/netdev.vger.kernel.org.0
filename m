Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8399241E91E
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352757AbhJAIhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:37:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:37732 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352324AbhJAIhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 04:37:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="225453721"
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="225453721"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 01:35:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="708436315"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 01 Oct 2021 01:35:49 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 0724B580970;
        Fri,  1 Oct 2021 01:35:44 -0700 (PDT)
Date:   Fri, 1 Oct 2021 16:35:42 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Message-ID: <20211001083542.GA22563@linux.intel.com>
References: <20210930044421.1309538-1-vee.khee.wong@linux.intel.com>
 <YVWCV1Vaq5SAJflX@shell.armlinux.org.uk>
 <20211001001951.erebmghjsewuk3lh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001001951.erebmghjsewuk3lh@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 12:19:52AM +0000, Vladimir Oltean wrote:
> On Thu, Sep 30, 2021 at 10:24:39AM +0100, Russell King (Oracle) wrote:
> > On Thu, Sep 30, 2021 at 12:44:21PM +0800, Wong Vee Khee wrote:
> > > According to Synopsys DesignWare Cores Ethernet PCS databook, it is
> > > required to disable Clause 37 auto-negotiation by programming bit-12
> > > (AN_ENABLE) to 0 if it is already enabled, before programming various
> > > fields of VR_MII_AN_CTRL registers.
> > > 
> > > After all these programming are done, it is then required to enable
> > > Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
> > > 
> > > Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE controller")
> > > Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > > ---
> > > v2 -> v3:
> > >  - Added error handling after xpcs_write().
> > >  - Added 'changed' flag.
> > >  - Added fixes tag.
> > > v1 -> v2:
> > >  - Removed use of xpcs_modify() helper function.
> > >  - Add conditional check on inband auto-negotiation.
> > > ---
> > >  drivers/net/pcs/pcs-xpcs.c | 41 +++++++++++++++++++++++++++++++++-----
> > >  1 file changed, 36 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> > > index fb0a83dc09ac..d2126f5d5016 100644
> > > --- a/drivers/net/pcs/pcs-xpcs.c
> > > +++ b/drivers/net/pcs/pcs-xpcs.c
> > > @@ -697,14 +697,18 @@ EXPORT_SYMBOL_GPL(xpcs_config_eee);
> > >  
> > >  static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> > >  {
> > > -	int ret;
> > > +	int ret, reg_val;
> > > +	int changed = 0;
> > >  
> > >  	/* For AN for C37 SGMII mode, the settings are :-
> > > -	 * 1) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
> > > -	 * 2) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
> > > +	 * 1) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 0b (Disable SGMII AN in case
> > > +	      it is already enabled)
> > > +	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
> > > +	 * 3) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
> > >  	 *    DW xPCS used with DW EQoS MAC is always MAC side SGMII.
> > > -	 * 3) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
> > > +	 * 4) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
> > >  	 *    speed/duplex mode change by HW after SGMII AN complete)
> > > +	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 1b (Enable SGMII AN)
> > >  	 *
> > >  	 * Note: Since it is MAC side SGMII, there is no need to set
> > >  	 *	 SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from
> > > @@ -712,6 +716,19 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> > >  	 *	 between PHY and Link Partner. There is also no need to
> > >  	 *	 trigger AN restart for MAC-side SGMII.
> > >  	 */
> > > +	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	if (ret & AN_CL37_EN) {
> > > +		changed = 1;
> > > +		reg_val = ret & ~AN_CL37_EN;
> > > +		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> > > +				 reg_val);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +	}
> > 
> > I don't think you need to record "changed" here - just maintain a
> > local copy of the current state of the register, e.g:
> > 
> > +	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	reg_val = ret;
> > +	if (reg_val & AN_CL37_EN) {
> > +		reg_val &= ~AN_CL37_EN;
> > ...
> > 
> > What you're wanting to do is ensure this bit is clear before you do the
> > register changes, and once complete, set the bit back to one. If the bit
> > was previously clear, you can omit this write, otherwise the write was
> > needed - as you have the code. However, the point is that once you're
> > past this code, the state of the register in the device will have the
> > AN_CL37_EN clear. See below for the rest of my comments on this...
> 
> VK, I don't want to force you towards a certain implementation, but I
> just want to throw this out there, this works for me, and doesn't do
> more reads or writes than strictly necessary, and it also breaks up the
> wall-of-text comment into more digestible pieces:

I agree on breaking up the comments, which make it more readable.
Also do not perform unnecessary writes.

What about doing this once the fix is merged into net-next?

It seems there are a lot of clean-ups need to be introduced, which is
more reasonable to be in net-next.

> 
> static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> {
> 	int ret, mdio_ctrl1, old_an_ctrl, an_ctrl, old_dig_ctrl1, dig_ctrl1;
> 
> 	/* Disable SGMII AN in case it is already enabled */
> 	mdio_ctrl1 = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> 	if (mdio_ctrl1 < 0)
> 		return mdio_ctrl1;
> 
> 	if (mdio_ctrl1 & AN_CL37_EN) {
> 		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> 				 mdio_ctrl1 & ~AN_CL37_EN);
> 		if (ret < 0)
> 			return ret;
> 	}
> 
> 	/* Set VR_MII_AN_CTRL[PCS_MODE] to SGMII AN, and
> 	 * VR_MII_AN_CTRL[TX_CONFIG] to MAC side SGMII.
> 	 */
> 	old_an_ctrl = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
> 	if (old_an_ctrl < 0)
> 		return old_an_ctrl;
> 
> 	an_ctrl = old_an_ctrl & ~(DW_VR_MII_PCS_MODE_MASK | DW_VR_MII_TX_CONFIG_MASK);
> 	an_ctrl |= (DW_VR_MII_PCS_MODE_C37_SGMII << DW_VR_MII_AN_CTRL_PCS_MODE_SHIFT) &
> 		   DW_VR_MII_PCS_MODE_MASK;
> 	an_ctrl |= (DW_VR_MII_TX_CONFIG_MAC_SIDE_SGMII << DW_VR_MII_AN_CTRL_TX_CONFIG_SHIFT) &
> 		   DW_VR_MII_TX_CONFIG_MASK;
> 
> 	if (an_ctrl != old_an_ctrl) {
> 		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL, an_ctrl);
> 		if (ret < 0)
> 			return ret;
> 	}
> 
> 	/* If using in-band autoneg, enable automatic speed/duplex mode change
> 	 * by HW after SGMII AN complete.
> 	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 1b (Enable SGMII AN)
> 	 */
> 	old_dig_ctrl1 = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1);
> 	if (old_dig_ctrl1 < 0)
> 		return old_dig_ctrl1;
> 
> 	if (phylink_autoneg_inband(mode))
> 		dig_ctrl1 = old_dig_ctrl1 | DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> 	else
> 		dig_ctrl1 = old_dig_ctrl1 & ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> 
> 	if (dig_ctrl1 != old_dig_ctrl1) {
> 		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, dig_ctrl1);
> 		if (ret < 0)
> 			return ret;
> 	}
> 
> 	if (!(mdio_ctrl1 & AN_CL37_EN) && phylink_autoneg_inband(mode)) {
> 		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> 				 mdio_ctrl1 | AN_CL37_EN);
> 		if (ret)
> 			return ret;
> 	}
> 
> 	/* Note: Since it is MAC side SGMII, there is no need to set
> 	 * SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from PHY about
> 	 * the link state change after C28 AN is completed between PHY and Link
> 	 * Partner. There is also no need to trigger AN restart for MAC-side
> 	 * SGMII.
> 	 */
> 
> 	return 0;
> }
> 
> > 
> > > @@ -736,7 +753,21 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
> > >  	else
> > >  		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> > >  
> > > -	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> > > +	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	if (changed) {
> > > +		if (phylink_autoneg_inband(mode))
> > > +			reg_val |= AN_CL37_EN;
> > > +		else
> > > +			reg_val &= ~AN_CL37_EN;
> > > +
> > > +		return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> > > +				  reg_val);
> > > +	}
> > 
> > As I say above, here, you are _guaranteed_ that the AN_CL27_EN bit is
> > clear in the register due to the effects of your change above. You say
> > in the commit text:
> > 
> >   After all these programming are done, it is then required to enable
> >   Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
> > 
> > So that makes me think that you _always_ need to write back a value
> > with AN_CL27_EN set. So:
> > 
> > 	reg_val |= AN_CL37_EN;
> > 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, reg_val);
> 
> I will only say this: modifying the last part of the function I posted
> above like this:
> 
> //	if (!(mdio_ctrl1 & AN_CL37_EN) && phylink_autoneg_inband(mode)) {
> 		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> 				 mdio_ctrl1 | AN_CL37_EN);
> 		if (ret)
> 			return ret;
> //	}
> 
> aka unconditionally writing an mdio_ctrl1 value with the AN_CL37_EN bit set,
> will still end up with a functional link. But the only reason for that
> is this:
> 
> static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
> 			       int speed, int duplex)
> {
> 	int val, ret;
> 
> 	if (phylink_autoneg_inband(mode))
> 		return;
> 
> 	switch (speed) {
> 	case SPEED_1000:
> 		val = BMCR_SPEED1000;
> 		break;
> 	case SPEED_100:
> 		val = BMCR_SPEED100;
> 		break;
> 	case SPEED_10:
> 		val = BMCR_SPEED10;
> 		break;
> 	default:
> 		return;
> 	}
> 
> 	if (duplex == DUPLEX_FULL)
> 		val |= BMCR_FULLDPLX;
> 
> 	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, val);   <- this clears the AN_CL37_EN bit again
> 	if (ret)
> 		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
> }
> 
> If I add "val |= AN_CL37_EN;" before the xpcs_write in xpcs_link_up_sgmii(),
> my SGMII link with in-band autoneg turned off breaks.
> 
> > If that is not correct, the commit message is misleading and needs
> > fixing.
> > 
> > Lastly, I would recommend a much better name for this variable rather
> > than the bland "reg_val" since you're needing the value preserved over
> > a chunk of code. "ctrl" maybe?
