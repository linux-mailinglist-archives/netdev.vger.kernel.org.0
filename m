Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7017B225EC0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgGTMpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgGTMpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:45:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E551EC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 05:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JDTPFxUA4CFbvghQW4R79YPhLRPhbuUGyCZY9UspPko=; b=0EpDrqaoZr7ZhhDGAOMMim5gu
        UFcid/cYdRmYMkN0rgquK2Z+fYq3GxSPnZIbCTqqqqFtfsiWi2wbjXN/S6Rf5Mc8zi1QCSXm4zkgB
        qSTnGvmPW1wY2/eengVcVUOVTMsffS2B0hzN8RC+SoOGmfnk0CYCNjXk6pfGCTsyf0TYbyRjl4I/6
        3TBbBHdGGIqEB112CUpBg3Q5dlcYnql/JSEEmTXruMRtj5bEzJd6IVzQpNs6XrotJ6Q0om8cKeTZf
        OxBQTO+iF3PuOstzTwyfFiPYHWk/mqkmBp7rLbopl/XFLEmA8k36DHrHzP+1SU7z4KGU6FITVfzSZ
        O2V8YEdbA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41896)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jxVAy-000320-1f; Mon, 20 Jul 2020 13:45:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jxVAx-0004zT-JT; Mon, 20 Jul 2020 13:45:47 +0100
Date:   Mon, 20 Jul 2020 13:45:47 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 08/13] net: phylink: simplify phy case for
 ksettings_set method
Message-ID: <20200720124547.GU1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHG3-0006PX-UZ@rmk-PC.armlinux.org.uk>
 <VI1PR0402MB387177B532EF211E65341873E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB387177B532EF211E65341873E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 10:44:11AM +0000, Ioana Ciornei wrote:
> On 6/30/20 5:29 PM, Russell King wrote:
> > When we have a PHY attached, an ethtool ksettings_set() call only
> > really needs to call through to the phylib equivalent; phylib will
> > call back to us when the link changes so we can update our state.
> > Therefore, we can bypass most of our ksettings_set() call for this
> > case.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> > +	mutex_lock(&pl->state_mutex);
> > +	linkmode_copy(pl->link_config.advertising, config.advertising);
> > +	pl->link_config.interface = config.interface;
> > +	pl->link_config.speed = config.speed;
> > +	pl->link_config.duplex = config.duplex;
> > +	pl->link_config.an_enabled = kset->base.autoneg !=
> > +				     AUTONEG_DISABLE;
> 
> Is there a specific reason why this is not just using config.an_enabled 
> to sync back to pl->link_config?

Due to the history of the code; and changing it in this patch would be
a distraction and actually a separate change.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
