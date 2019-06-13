Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC79643E0C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733197AbfFMPq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:46:56 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45176 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731773AbfFMJer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 05:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7p/hY7wM7ahv5sC5AyaRyYyHc8h6pj1SFEqxSa8Y0lY=; b=Mt3u8nHCp+T+ZtsD3ws+rdoUw
        J4RHYypZx/OJHuuwSj252YL8U34HBLWa8sE5CN+FC/CQCO7jCKYZjgPbXmUOY6jOAXDNzkUcuOXMC
        Gpq1wEi//+/JTG1hiIPW6zCeNtrrzfnrmYxiTbYZ6xo/uEb/x6D3FdrRyJvVXTkmwLIxjNZubk+sG
        v8gTVOqk0ScDd1FndTU87z5Vr6qCEHLAlKiRrhyIV8ah3bySacOxAP2Ih7EQMwKZZavw3C6gtsAuS
        HIkwGtFhkp4gXFcf5XuEmbAdlnYUZvhNPZ6HWntI8dl0jBsL6LWPwwLs2bBcS//IfaN9qOhQagued
        LYduM682w==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38652)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbM80-000251-Ec; Thu, 13 Jun 2019 10:34:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbM7x-00016z-Qc; Thu, 13 Jun 2019 10:34:37 +0100
Date:   Thu, 13 Jun 2019 10:34:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Message-ID: <20190613093437.p4c6xiolrwzikmhq@shell.armlinux.org.uk>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
 <20190613081400.2cicsjpslxoidoox@shell.armlinux.org.uk>
 <VI1PR0402MB2800B6F4FC9C90C96E22979AE0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800B6F4FC9C90C96E22979AE0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:55:16AM +0000, Ioana Ciornei wrote:
> > Subject: Re: [PATCH] net: phylink: set the autoneg state in
> > phylink_phy_change
> > 
> > On Thu, Jun 13, 2019 at 09:37:51AM +0300, Ioana Ciornei wrote:
> > > The phy_state field of phylink should carry only valid information
> > > especially when this can be passed to the .mac_config callback.
> > > Update the an_enabled field with the autoneg state in the
> > > phylink_phy_change function.
> > 
> > an_enabled is meaningless to mac_config for PHY mode.  Why do you think
> > this is necessary?
> 
> Well, it's not necessarily used in PHY mode but, from my opinion, it should be set to the correct value nonetheless.
> 
> Just to give you more context, I am working on adding phylink support on NXP's DPAA2 platforms where any interaction between the PHY management layer and the Ethernet devices is made through a firmware.
> When the .mac_config callback is invoked, the driver communicates the new configuration to the firmware so that the corresponding net_device can see the correct info.
> In this case, the an_enabled field is not used for other purpose than to inform the net_device of the current configuration and nothing more.

The fields that are applicable depend on the negotiation mode:

- Non-inband (PHY or FIXED): set the speed, duplex and pause h/w
   parameters as per the state's speed, duplex and pause settings.
   Every other state setting should be ignored; they are not defined
   for this mode of operation.

- Inband SGMII: set for inband SGMII reporting of speed and duplex
   h/w parameters.  Set pause mode h/w parameters as per the state's
   pause settings.  Every other state setting should be ignored; they
   are not defined for this mode of operation.

- Inband 802.3z: set for 1G or 2.5G depending on the PHY interface mode.
   If an_enabled is true, allow inband 802.3z to set the duplex h/w
   parameter.  If an_enabled and the MLO_PAUSE_AN bit of the pause
   setting are true, allow 802.3z to set the pause h/w parameter.
   Advertise capabilities depending on the 'advertising' setting.

There's only one case where an_enabled is used, which is 802.3z
negotiation, because the MAC side is responsible for negotiating the
link mode.  In all other cases, the MAC is not responsible for any
autonegotiation.

It is important to stick to the above, which will ensure correct
functioning of your driver - going off and doing your own thing (such
as reading from other fields) is not guaranteed to give good results.

> 
> --
> Ioana
> 
> 
> > 
> > >
> > > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > ---
> > >  drivers/net/phy/phylink.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > index 5d0af041b8f9..dd1feb7b5472 100644
> > > --- a/drivers/net/phy/phylink.c
> > > +++ b/drivers/net/phy/phylink.c
> > > @@ -688,6 +688,7 @@ static void phylink_phy_change(struct phy_device
> > *phydev, bool up,
> > >  		pl->phy_state.pause |= MLO_PAUSE_ASYM;
> > >  	pl->phy_state.interface = phydev->interface;
> > >  	pl->phy_state.link = up;
> > > +	pl->phy_state.an_enabled = phydev->autoneg;
> > >  	mutex_unlock(&pl->state_mutex);
> > >
> > >  	phylink_run_resolve(pl);
> > > --
> > > 1.9.1
> > >
> > >
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
