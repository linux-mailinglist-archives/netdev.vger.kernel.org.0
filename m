Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2A7296DA2
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 13:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462965AbgJWL0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 07:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462868AbgJWL0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 07:26:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F378C0613CE;
        Fri, 23 Oct 2020 04:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6PDeYQxNtg045NRHc1XlULYVUVuYGlzxkJDnsao8G9w=; b=mLHlNYkyyDY2dlrmBpuK+nB+I
        eWLwkgic9XNJO0sY6G1oiTmQk35hqisG7P2IytIqtGtwvI10087RIBgxxyahx2tKnLFkcv1ayDmuT
        w2X6xmYN4vw20+72kbP3ROUcycOOfya4qLN2xr9WiT6oAeqsvdDnqaibYH0AMs59QVGFgB/Ffgpjj
        wnoYXQ9Q7at1qznZL4l0exWRRShzprq/6GkuDA9mgyYl+qGzDMZ45b2uq4jal2oGLKOOf1he27Y/m
        gtQ8Ti+GviHhfb4sRZJ9N6WCE3+KeBzK4nfEYkDrGLcl5qudKidDJ0r3DWyK9Ab2hRboU/jBPUhNQ
        4hoQpfBRA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49950)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kVvCj-0003MW-Et; Fri, 23 Oct 2020 12:25:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kVvCf-0008Ov-Qv; Fri, 23 Oct 2020 12:25:49 +0100
Date:   Fri, 23 Oct 2020 12:25:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Milind Parab <mparab@cadence.com>
Subject: Re: [PATCH v3] net: macb: add support for high speed interface
Message-ID: <20201023112549.GB1551@shell.armlinux.org.uk>
References: <1603302245-30654-1-git-send-email-pthombar@cadence.com>
 <20201021185056.GN1551@shell.armlinux.org.uk>
 <DM5PR07MB31961F14DD8A38B7FFA8DA24C11D0@DM5PR07MB3196.namprd07.prod.outlook.com>
 <DM5PR07MB3196723723F236F6113DDF9EC11A0@DM5PR07MB3196.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR07MB3196723723F236F6113DDF9EC11A0@DM5PR07MB3196.namprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 10:59:42AM +0000, Parshuram Raju Thombare wrote:
> Hi,
> 
> I was trying to find out any ethernet driver where this issue of selecting appropriate
> pcs_ops due to phylink changing interface mode dynamically is handled. 
> But, apparently, so far only mvpp2 has adapted pcs_ops. And even in mvpp2, it is
> not obvious how this case is handled. 

Yes, mvpp2 is the only driver that has been converted.  I'm not sure
why you say that it's not obvious how it's handled.

Whenever the interface changes, we go through the full reconfiguration
procedure that I've already outlined. This involves calling the
mac_prepare() method which calls into mvpp2_mac_prepare() and its
child mvpp2__mac_prepare().

In mvpp2__mac_prepare(), we switch the "ops" for port->phylink_pcs,
and then back in mvpp2_mac_prepare(), we ensure that the PCS instance
is set to the port->phylink_pcs (which internally updates the
pl->pcs_ops pointer in phylink.)

That results in phylink switching between the XLG and GMAC PCS
operations depending on the interface in use.

> Also, apart from interface mode changed due to SFPs with different types of PHY
> being used, it is not clear when phylink selects interface mode different than it
> initially requested to the ethernet driver.

The ethernet driver's initial interface mode has no real bearing when a
SFP is inserted. A SFP or SFP+ module can require one of several
different interface modes, and generally can not be programmed to
operate in any other mode.

For example, a 1G fiber SFP can _only_ operate in 1000BASE-X. SGMII and
10G modes are not permissible. Trying to use RGMII (for example) is a
nonsense because there aren't enough pins on the module to connect
RGMII, and the module would not know what to do with it.

If the module is a 10M/100M/1G copper SFP, then things get more fun -
and what can be done depends whether the SFP has an accessible PHY we
can drive. The PHY may support 1000BASE-X and/or SGMII, and there is
no real way to determine which the SFP supports. The EEPROM does _not_
help with this. We work around that at present by always using SGMII
(there are copper modules that the PHY is inaccessible but is in SGMII
mode - Mikrotik S-RJ01 for example). For others where the PHY is
accessible, it is generally an 88E1111, which may power up in either
SGMII or 1000BASE-X mode. We always select SGMII for these, and the
88E1111 driver knows how to reprogram the PHY to operate in this mode.

If it's a SFP+ module, then similar games occur. If it's a fiber module,
then 10GBASE-R needs to be selected, since that's the protocol that is
defined to be used over 10G fiber connections. Otherwise, again, it's
up to the PHY - and the PHY can be one that switches between 10GBASE-R,
2500BASE-X, and SGMII depending on the speed that was negotiated on its
copper side.

There is nothing simple here - but as far as the MAC driver is
concerned, phylink will ask the MAC driver to reconfigure itself for
the interface mode as appropriate.

> >pcs_config and pcs_link_up passes "interface" as an argument, and in
> >pcs_get_state call "state->interface" appeared to be populated just before
> >calling it and hence should be valid.
> 
> It seems state->interface in pcs_get_state is not always valid when SFPs with
> different types of PHY are used.
> 
> There is a chance of SFP with different type of PHY is inserted,
> eventually invoking phylink_resolve for interface mode different than
> phylink initially requested, and causing major reconfiguration.
> 
> However, pcs_get_state is called before major reconfiguration, where selecting
> which pcs_ops and PCS to be used is difficult without correct interface mode.  

Correct - state->interface will always be the currently configured
interface mode, because that's the one that the MAC hardware is
configured for. Other PCS interfaces may be powered down and/or
disconnected from the serdes lane.

However, the interface will not change at the point you are referring
to when in in-band mode (there is no support for dynamic changes of
interface in that circumstance.) The change of interface happens when
a SFP module is being brought up either via the phylink_sfp_config*()
functions, or if there is a PHY, via the phylib driver propagating its
operating interface mode back through phylink (but in this case, we
will not be in in-band mode, and pcs_get_state() will not be called.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
