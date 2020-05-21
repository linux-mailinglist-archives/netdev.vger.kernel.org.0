Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12491DD1D6
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgEUP1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729960AbgEUP1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:27:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B65AC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 08:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0/ZPDjDG747lZWcyAHPnfg2j2jmV3xoyCFDwRjqF4r0=; b=lHyQysWqPXILZY0/ShUbF5TXQ
        474A60MrFjVz8EqLVya1I/2apD24SFovaAvyUvVGa2GlXqQLhS0u5CS+YQh2kvFtO4txUeHLfYttd
        AUR+NoV1vbt8hJpcYGRhutgENQR65EBg7dPwb6EeSIiDPSQpvr80vg/EdQvzH6PJsvB6ScP049N1N
        rzYHZtMkhmk0XjEjEcO0VjkDi25e+UL5LqCpSI+IpYtPJH2oEhjCk6DJ7TQny8HU2umF6nCwZx3XN
        o6/3iEtEFyIwr+OVOFsM1fvWxpN/YtAj89gRnRPFDCrY83/xEq/qXbGzt0SB7b15Q1JFoLS258YmO
        dvPeOIsyQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35120)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jbn65-0002mB-GY; Thu, 21 May 2020 16:27:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jbn60-0000JE-RI; Thu, 21 May 2020 16:26:56 +0100
Date:   Thu, 21 May 2020 16:26:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
Message-ID: <20200521152656.GU1551@shell.armlinux.org.uk>
References: <3268996.Ej3Lftc7GC@tool>
 <20200521151916.GC677363@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521151916.GC677363@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 05:19:16PM +0200, Andrew Lunn wrote:
> >  drivers/net/ethernet/marvell/mvneta.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 41d2a0eac..f9170bc93 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -3567,8 +3567,9 @@ static void mvneta_start_dev(struct mvneta_port *pp)
> >  
> >  	phylink_start(pp->phylink);
> >  
> > -	/* We may have called phy_speed_down before */
> > -	phy_speed_up(pp->dev->phydev);
> > +	if(pp->dev->phydev)
> > +		/* We may have called phy_speed_down before */
> > +		phy_speed_up(pp->dev->phydev);
> 
> I don't think it is as simple as this. You should not really be mixing
> phy_ and phylink_ calls within one driver. You might of noticed there
> are no other phy_ calls in this driver. So ideally you want to add
> phylink_ calls which do the right thing.

And... what is mvneta doing getting the phydev?  I removed all that
code when converting it to phylink, since the idea with phylink is
that the PHY is the responsibility of phylink not the network driver.

I hope the patch adding pp->dev->phydev hasn't been merged as it's
almost certainly wrong.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
