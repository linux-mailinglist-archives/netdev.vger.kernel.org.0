Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E017541D643
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 11:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349370AbhI3J0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 05:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349337AbhI3J0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 05:26:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B046FC06176A;
        Thu, 30 Sep 2021 02:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7uPG7MiDA8CZMuLAKp1G8Bu44Pz55kfmFuBNWS5RNUc=; b=LUEzlW9sK8E6BV+wV9OKdfJ1+0
        9opqrBqLHq7CULraUsoaaOZBnQJkMkjjCB4TEVUNOkSi6qmnFO/5IHYtQ4Wk8q2IxotD30Lc02wPf
        V9MuN54T3MX5dvfIDuibtlQXqlSzDgwjHstB2v7L2edfwXqCftaEQcFHRG5Lz2vVxl3V4J/tKrT18
        hc3W9yvMYFushbsXtWKBm1HdvMs6usQPskelmzSuxXecFvLFFYXhj5coeGaYTLNXsayvJhHUZ91RC
        4/rlZdGcZMmbzjG7Zu6qjJfAnGpP89i/4+J+wQYlvjtnbaVSYyMvofm4XJwFjQALWMDqo1QFY4rTl
        fsNvfF+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54852)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mVsJ1-00035K-0g; Thu, 30 Sep 2021 10:24:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mVsIx-0003WI-WB; Thu, 30 Sep 2021 10:24:40 +0100
Date:   Thu, 30 Sep 2021 10:24:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Message-ID: <YVWCV1Vaq5SAJflX@shell.armlinux.org.uk>
References: <20210930044421.1309538-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930044421.1309538-1-vee.khee.wong@linux.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 12:44:21PM +0800, Wong Vee Khee wrote:
> According to Synopsys DesignWare Cores Ethernet PCS databook, it is
> required to disable Clause 37 auto-negotiation by programming bit-12
> (AN_ENABLE) to 0 if it is already enabled, before programming various
> fields of VR_MII_AN_CTRL registers.
> 
> After all these programming are done, it is then required to enable
> Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
> 
> Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE controller")
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
> v2 -> v3:
>  - Added error handling after xpcs_write().
>  - Added 'changed' flag.
>  - Added fixes tag.
> v1 -> v2:
>  - Removed use of xpcs_modify() helper function.
>  - Add conditional check on inband auto-negotiation.
> ---
>  drivers/net/pcs/pcs-xpcs.c | 41 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index fb0a83dc09ac..d2126f5d5016 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -697,14 +697,18 @@ EXPORT_SYMBOL_GPL(xpcs_config_eee);
>  
>  static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
>  {
> -	int ret;
> +	int ret, reg_val;
> +	int changed = 0;
>  
>  	/* For AN for C37 SGMII mode, the settings are :-
> -	 * 1) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
> -	 * 2) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
> +	 * 1) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 0b (Disable SGMII AN in case
> +	      it is already enabled)
> +	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
> +	 * 3) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
>  	 *    DW xPCS used with DW EQoS MAC is always MAC side SGMII.
> -	 * 3) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
> +	 * 4) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
>  	 *    speed/duplex mode change by HW after SGMII AN complete)
> +	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 1b (Enable SGMII AN)
>  	 *
>  	 * Note: Since it is MAC side SGMII, there is no need to set
>  	 *	 SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from
> @@ -712,6 +716,19 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
>  	 *	 between PHY and Link Partner. There is also no need to
>  	 *	 trigger AN restart for MAC-side SGMII.
>  	 */
> +	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & AN_CL37_EN) {
> +		changed = 1;
> +		reg_val = ret & ~AN_CL37_EN;
> +		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> +				 reg_val);
> +		if (ret < 0)
> +			return ret;
> +	}

I don't think you need to record "changed" here - just maintain a
local copy of the current state of the register, e.g:

+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+	if (ret < 0)
+		return ret;
+
+	reg_val = ret;
+	if (reg_val & AN_CL37_EN) {
+		reg_val &= ~AN_CL37_EN;
...

What you're wanting to do is ensure this bit is clear before you do the
register changes, and once complete, set the bit back to one. If the bit
was previously clear, you can omit this write, otherwise the write was
needed - as you have the code. However, the point is that once you're
past this code, the state of the register in the device will have the
AN_CL37_EN clear. See below for the rest of my comments on this...

> @@ -736,7 +753,21 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
>  	else
>  		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
>  
> -	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> +	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (changed) {
> +		if (phylink_autoneg_inband(mode))
> +			reg_val |= AN_CL37_EN;
> +		else
> +			reg_val &= ~AN_CL37_EN;
> +
> +		return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> +				  reg_val);
> +	}

As I say above, here, you are _guaranteed_ that the AN_CL27_EN bit is
clear in the register due to the effects of your change above. You say
in the commit text:

  After all these programming are done, it is then required to enable
  Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.

So that makes me think that you _always_ need to write back a value
with AN_CL27_EN set. So:

	reg_val |= AN_CL37_EN;
	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, reg_val);

If that is not correct, the commit message is misleading and needs
fixing.

Lastly, I would recommend a much better name for this variable rather
than the bland "reg_val" since you're needing the value preserved over
a chunk of code. "ctrl" maybe?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
