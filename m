Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E3718898C
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCQP4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:56:21 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41768 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgCQP4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DaEjZWHg+aPnL/JZ/zbBxu8dpS7jVH4iTlfnialKxSI=; b=T6H4mNJ/e2HcSexna+g6CzRce
        dKg6BCHW6UmTxXobFLTyXN3599y30e0k2OGUfgk/FsnflPFfkVA4+OyKZouApTpcqs+fuUtEN2Rzo
        dnzYrczRR6a+vm/fGXkMK5SBmM5sgekwjpdWl0unTo2DCePtNCAePPDh4qrm45WydmcDcls6fT2KP
        AaA0WUknKyzZCY1MYBGhlBsT6hWvt2Kxbogvo72k778LPnYt1jqXIS0UtvK+woddCAaWYkvs+saL9
        Jdw/6FDtUv2zEhhF+0YHP4ayedeJVRvLLRrTmVzt/2hK9jBSS5llsWYFOHs4IYX0QiVxkCZO4pXyI
        841I36Lfw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33578)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEEZh-00080P-3b; Tue, 17 Mar 2020 15:56:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEEZe-0002vk-5a; Tue, 17 Mar 2020 15:56:10 +0000
Date:   Tue, 17 Mar 2020 15:56:10 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200317155610.GS25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <BN8PR12MB3266FC193AF677B87DFC98C2D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266FC193AF677B87DFC98C2D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 03:48:50PM +0000, Jose Abreu wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Date: Mar/17/2020, 14:52:51 (UTC+00:00)
> 
> > -static void phylink_mac_an_restart(struct phylink *pl)
> > +static void phylink_mac_pcs_an_restart(struct phylink *pl)
> >  {
> >  	if (pl->link_config.an_enabled &&
> > -	    phy_interface_mode_is_8023z(pl->link_config.interface))
> > -		pl->mac_ops->mac_an_restart(pl->config);
> > +	    phy_interface_mode_is_8023z(pl->link_config.interface)) {
> 
> Please consider removing this condition and just rely on an_enabled field. 
> I have USXGMII support for Clause 73 Autoneg so this won't work with 
> that.

That is actually incorrect.  SGMII can have an_enabled being true, but
SGMII is not an autonegotiation between the MAC and PHY - it is merely
a mechanism for the PHY to inform the MAC what the results of _its_
negotiation are.

I suspect USXGMII is the same since it is just an "upgraded" version of
SGMII.  Please can you check whether there really is any value in trying
(and likely failing) to restart the "handshake" with the PHY from the
MAC end, rather than requesting the PHY to restart negotiation on its
media side.

> Overall, looks nice but I don't see a mechanism to restart AutoNeg in case 
> of failure. i.e. following PHYLIB implementation you should add a call to 
> restart_aneg in the state machine. This was just a quick look so I may 
> have missed this.

phylink doesn't have a state machine.  At what point do you think that
restarting negotiation (and which negotiation in the case of SGMII or
presumably USXGMII) would be appropriate?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
