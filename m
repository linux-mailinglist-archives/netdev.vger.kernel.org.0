Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDCE11F0D1
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 08:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfLNH4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 02:56:15 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59540 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfLNH4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 02:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hctS6KUiaNGHqgsslJuxo9aI2reeZbNQZlgXcHiTvlI=; b=zici7AUmbqBVtT4YsB1filS6m
        9XN7dbi8MC/OF9tTGT+fbxUb1gxvjG+0pADLzMBto/zsP1KuGI26AsRAb5fUJCVw3nB74kEYDdER4
        6CivBFg2XtF9OgOsm93MtfFt+WieEBdU3APH6Wv1i6jlFHZ7GjbI4DSaHIPL8jkolUYy6w2w00dq3
        R/WKcfHIluO73a3+Pa4TquDz3d7KFUGj5IsZ5BgnEGrcNV8WROFBjygpiHWZfcBF+HCQI8hiefXMx
        OR30MPUO6gQPRU6PFuSXKtppjXSzeoYprUeE9kntzxJIL9Y4vHwqnaNKlFhfhPjfOjqVXSFCQPG/d
        UtXpjPtmQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:48666)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ig2HU-0001ee-08; Sat, 14 Dec 2019 07:56:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ig2HS-0000GW-FF; Sat, 14 Dec 2019 07:56:02 +0000
Date:   Sat, 14 Dec 2019 07:56:02 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Willy Tarreau <w@1wt.eu>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        maxime.chevallier@bootlin.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: marvell: mvpp2: phylink requires the link interrupt
Message-ID: <20191214075602.GY25745@shell.armlinux.org.uk>
References: <E1ieo41-00023K-2O@rmk-PC.armlinux.org.uk>
 <20191213163403.2a054262@cakuba.netronome.com>
 <20191214075127.GX25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191214075127.GX25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 07:51:27AM +0000, Russell King - ARM Linux admin wrote:
> On Fri, Dec 13, 2019 at 04:34:03PM -0800, Jakub Kicinski wrote:
> > On Tue, 10 Dec 2019 22:33:05 +0000, Russell King wrote:
> > > phylink requires the MAC to report when its link status changes when
> > > operating in inband modes.  Failure to report link status changes
> > > means that phylink has no idea when the link events happen, which
> > > results in either the network interface's carrier remaining up or
> > > remaining permanently down.
> > > 
> > > For example, with a fiber module, if the interface is brought up and
> > > link is initially established, taking the link down at the far end
> > > will cut the optical power.  The SFP module's LOS asserts, we
> > > deactivate the link, and the network interface reports no carrier.
> > > 
> > > When the far end is brought back up, the SFP module's LOS deasserts,
> > > but the MAC may be slower to establish link.  If this happens (which
> > > in my tests is a certainty) then phylink never hears that the MAC
> > > has established link with the far end, and the network interface is
> > > stuck reporting no carrier.  This means the interface is
> > > non-functional.
> > > 
> > > Avoiding the link interrupt when we have phylink is basically not
> > > an option, so remove the !port->phylink from the test.
> > > 
> > > Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > Fixes: 4bb043262878 ("net: mvpp2: phylink support") ?
> > 
> > Seems like you maybe didn't want this backported to stable hence 
> > no fixes tag?
> 
> Correct, because backporting just this patch will break the
> Macchiatobin.
> 
> This patch is dependent on the previous two patches, which are more
> about correct use of the API.  I suspect if you try to backport the
> series, things will get very hairly very quickly.

Oh, sorry, too early, wrong patch.  Yes, please add the fixes tag.

> 
> > 
> > Please advise :)
> > 
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > index 111b3b8239e1..ef44c6979a31 100644
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -3674,7 +3674,7 @@ static int mvpp2_open(struct net_device *dev)
> > >  		valid = true;
> > >  	}
> > >  
> > > -	if (priv->hw_version == MVPP22 && port->link_irq && !port->phylink) {
> > > +	if (priv->hw_version == MVPP22 && port->link_irq) {
> > >  		err = request_irq(port->link_irq, mvpp2_link_status_isr, 0,
> > >  				  dev->name, port);
> > >  		if (err) {
> > 
> > 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
