Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B2E42230F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhJEKIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbhJEKIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:08:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1F0C06161C;
        Tue,  5 Oct 2021 03:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=x5LyrEZtyTYgVW8P7eEdPEoGjAnPMtn7SJqGAKJ+WAM=; b=xcPaIYgXlOo2smSUYYX6a3wMi+
        Z3QY34kICgFD+S/huIFroTkxJUAiwbL4z7zZsBhbqviiC8lZ2Ace5P+fx6FwMoo660DfRJvR/GOIl
        gzTVGFdQdsMxQ6ZafP+x/0tbhoXYFUbFZObP1qt3ViPNghfb2pxRc/PPB0A39wSVA8MiythyYW9A2
        hayH3VYhxeNhbVK7rQK+M4xQBceIdjhAibAegPmZI1igzduL8UVst9H1LlSFWaP+QKfGCPtEfQ9xV
        pIW8y+QfBl3Tn9IKlGIXU5WTSBm9tRa6WGizDDaIevuItbW+3GDkO0lBM3dBa/uIu+iVkVMCvkwkv
        Sp07Fyig==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54950)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXhKq-00007Y-KF; Tue, 05 Oct 2021 11:06:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXhKo-0008NG-Dp; Tue, 05 Oct 2021 11:06:06 +0100
Date:   Tue, 5 Oct 2021 11:06:06 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [RFC net-next PATCH 10/16] net: macb: Move PCS settings to PCS
 callbacks
Message-ID: <YVwjjghGcXaEYgY+@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-11-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-11-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:21PM -0400, Sean Anderson wrote:
> +static void macb_pcs_get_state(struct phylink_pcs *pcs,
> +			       struct phylink_link_state *state)
> +{
> +	struct macb *bp = pcs_to_macb(pcs);
> +
> +	if (gem_readl(bp, NCFGR) & GEM_BIT(SGMIIEN))
> +		state->interface = PHY_INTERFACE_MODE_SGMII;
> +	else
> +		state->interface = PHY_INTERFACE_MODE_1000BASEX;

There is no requirement to set state->interface here. Phylink doesn't
cater for interface changes when reading the state. As documented,
phylink will set state->interface already before calling this function
to indicate what interface mode it is currently expecting from the
hardware.

> +static int macb_pcs_config_an(struct macb *bp, unsigned int mode,
> +			      phy_interface_t interface,
> +			      const unsigned long *advertising)
> +{
> +	bool changed = false;
> +	u16 old, new;
> +
> +	old = gem_readl(bp, PCSANADV);
> +	new = phylink_mii_c22_pcs_encode_advertisement(interface, advertising,
> +						       old);
> +	if (old != new) {
> +		changed = true;
> +		gem_writel(bp, PCSANADV, new);
> +	}
> +
> +	old = new = gem_readl(bp, PCSCNTRL);
> +	if (mode == MLO_AN_INBAND)

Please use phylink_autoneg_inband(mode) here.

> +		new |= BMCR_ANENABLE;
> +	else
> +		new &= ~BMCR_ANENABLE;
> +	if (old != new) {
> +		changed = true;
> +		gem_writel(bp, PCSCNTRL, new);
> +	}

There has been the suggestion that we should allow in-band AN to be
disabled in 1000base-X if we're in in-band mode according to the
ethtool state. I have a patch that adds that.

> +	return changed;
> +}
> +
> +static int macb_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> +			   phy_interface_t interface,
> +			   const unsigned long *advertising,
> +			   bool permit_pause_to_mac)
> +{
> +	bool changed = false;
> +	struct macb *bp = pcs_to_macb(pcs);
> +	u16 old, new;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bp->lock, flags);
> +	old = new = gem_readl(bp, NCFGR);
> +	if (interface == PHY_INTERFACE_MODE_SGMII) {
> +		new |= GEM_BIT(SGMIIEN);
> +	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
> +		new &= ~GEM_BIT(SGMIIEN);
> +	} else {
> +		spin_lock_irqsave(&bp->lock, flags);
> +		return -EOPNOTSUPP;

You can't actually abort at this point - phylink will print the error
and carry on regardless. The checking is all done via the validate()
callback and if that indicates the interface mode is acceptable, then
it should be accepted.

>  static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
>  	.pcs_get_state = macb_usx_pcs_get_state,
>  	.pcs_config = macb_usx_pcs_config,
> -	.pcs_link_up = macb_usx_pcs_link_up,
>  };
>  
>  static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
>  	.pcs_get_state = macb_pcs_get_state,
> -	.pcs_an_restart = macb_pcs_an_restart,

You don't want to remove this. When operating in 1000BASE-X mode, it
will be called if a restart is required (e.g. macb_pcs_config()
returning positive, or an ethtool request.) You need to keep the empty
function. That may also help the diff algorithm to produce a cleaner
patch too.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
