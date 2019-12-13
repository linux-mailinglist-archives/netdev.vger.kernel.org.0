Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E5311E7D2
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 17:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfLMQLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 11:11:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49216 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbfLMQLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 11:11:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jDuXV/W8alQ1RXvNo3evM02Xeqkxr1Cbr87zhWql228=; b=xUca8MX5F9wfvZsV2WiJefqMR
        0GGsLtnn6+D7P1QVTn6DPI6ONcsNj8rrNCxl0Wtcu1tDku3gQN1oeIeWB5RuTkAj9dZtabmfM5g6e
        /BpnySVqR86ohyhIMh5Kt56QNhssnCuI3GHw19WYNpytJMjjwckQRJ+Yb8C8F27zip7piSQfHyRw9
        r/Bal1rWd0OfPGNMKVGwavifItp90I0OW9hu6soFK9kYJFPpiWK1LxmBhX/hKQa81jsXFvbdKmYET
        zkv4jfG8Rn47cmoqSDditR2Kga+iCqkcEbx6vOr3iAL/5l3r+DLt/E0Pv1KzEFDlwfc7Q1I+riNOi
        S1Eor2OLg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52502)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ifnXe-0005ok-K3; Fri, 13 Dec 2019 16:11:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ifnXc-00081Z-Cx; Fri, 13 Dec 2019 16:11:44 +0000
Date:   Fri, 13 Dec 2019 16:11:44 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: mvpp2: update mvpp2 validate()
 implementation
Message-ID: <20191213161144.GU25745@shell.armlinux.org.uk>
References: <20191212174309.GM25745@shell.armlinux.org.uk>
 <E1ifSV8-0000b1-NW@rmk-PC.armlinux.org.uk>
 <20191213160420.GA26710@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213160420.GA26710@kwain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 05:04:20PM +0100, Antoine Tenart wrote:
> Hello Russell,
> 
> On Thu, Dec 12, 2019 at 05:43:46PM +0000, Russell King wrote:
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index 111b3b8239e1..fddd856338b4 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -4786,6 +4786,8 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
> >  			phylink_set(mask, 10000baseER_Full);
> >  			phylink_set(mask, 10000baseKR_Full);
> >  		}
> > +		if (state->interface != PHY_INTERFACE_MODE_NA)
> > +			break;
> 
> >  		/* Fall-through */
> >  	case PHY_INTERFACE_MODE_RGMII:
> >  	case PHY_INTERFACE_MODE_RGMII_ID:
> > @@ -4796,13 +4798,21 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
> >  		phylink_set(mask, 10baseT_Full);
> >  		phylink_set(mask, 100baseT_Half);
> >  		phylink_set(mask, 100baseT_Full);
> > +		if (state->interface != PHY_INTERFACE_MODE_NA)
> > +			break;
> 
> The two checks above will break the 10G/1G interfaces on the mcbin
> (eth0/eth1) as they can support both 10gbase-kr and 10/100/1000baseT
> modes depending on what's connected. With this patch only the modes
> related to the one defined in the device tree would be valid, breaking
> run-time reconfiguration of the link.

Exactly which scenario are you talking about?  The mcbin doubleshot
setup, or the singleshot setup?

This patch (when combined with the others) has no effect on the
doubleshot, and should have no effect on the SFP cages on the single
shot.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
