Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB8141EA39
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353227AbhJAJ73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbhJAJ72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 05:59:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B09BC061775;
        Fri,  1 Oct 2021 02:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fCuzHP94LEPxfLS5wTP0qiT8yU1ftlKvpdAto7R4Duw=; b=o5QyA1crVbp2CPTOXV8y3tZ9Od
        TjwK5XnMIwLRLtEMnW+03SCIqDJONijBn9X3ZbDSzd6N9uJI00XYxEtGY3xZcRL/1p9IpMyhghYQc
        ZBH+kO9P0Kap5WzoMeVm71/w6mOjmbJDf1UJ0/vZVz+uW9kuI0dYSOS0y3J+Nqlp5GNWyTNifXbhX
        5g7QN1q7DwF8qESFwgrqSbxJzyU+2IlzVzZQZuNold75/tRVzxWXTTZBCtXOgA7ueMrU6FJYDX8xV
        O+JyzYgZXscrIpTSwx4BJOPWH6sO0aoPvuLQBH0gh1YApX0uvdJApSFZWVXOZun0lR8s52MVQhdOo
        DfAwjsLQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54886)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mWFIL-0004V2-CU; Fri, 01 Oct 2021 10:57:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mWFII-0004Vn-CH; Fri, 01 Oct 2021 10:57:30 +0100
Date:   Fri, 1 Oct 2021 10:57:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Message-ID: <YVbbitGJDZhd6eW/@shell.armlinux.org.uk>
References: <20210930044421.1309538-1-vee.khee.wong@linux.intel.com>
 <YVWCV1Vaq5SAJflX@shell.armlinux.org.uk>
 <20211001001951.erebmghjsewuk3lh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001001951.erebmghjsewuk3lh@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 12:19:52AM +0000, Vladimir Oltean wrote:
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

This is fine...

> 	if (!(mdio_ctrl1 & AN_CL37_EN) && phylink_autoneg_inband(mode)) {
> 		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> 				 mdio_ctrl1 | AN_CL37_EN);
> 		if (ret)
> 			return ret;
> 	}

This is not. If the control register had AN_CL37_EN set initially, then
in the first test above, we clear the bit. However, mdio_ctrl1 will
still contain the bit set. When we get here, we will skip setting the
register bit back to one even if in-band mode was requested.

As I said in a previous email, at this point there is no reason to check
the previous state, because if it was set on entry, we will have cleared
it, so the register state at this point has the bit clear no matter
what. If we need to set it, then we /always/ need to write it here - it
doesn't matter what the initial state was.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
