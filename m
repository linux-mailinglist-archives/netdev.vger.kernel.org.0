Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90FE16847F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgBURKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:10:38 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51614 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbgBURKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:10:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bp1lWcxGkXI1dOKZa2p+oi0pswujYwX0tBwQBCst0zM=; b=REgQwD+8Du6hBrxoBK+zFIs0Z
        6A92OGFjwvYnNCRJJ4qpiWJuwucUoi9OHxhYoVQDQTqgVMyaLdK99gZoOtjJRNalWF75yRLvkGVrx
        INHqGMXfpmgKCx6R82YcA0tWuC5c2i3Gq6M97zYis9unSS1TXNpFEWC36zXygXPLHbv2SQJGmJDmd
        KvyqZZIlkf0TWJOJ8yKuJ+dKNLqFI2LVLkvRj1wRGfas03zBgiNIX56pOMgwo8RJPrpZ9XpuWF5QC
        DJ2P8BGlVXy6JKxT8HFqs342ASPkC203Kc66tMqLZ746HkX28SgQ2NBwi7bw1sDQUIoQKdUuKpu3w
        VaFWa05lQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43400)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j5Bop-0002S1-IA; Fri, 21 Feb 2020 17:10:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j5Bom-0003fn-Jw; Fri, 21 Feb 2020 17:10:24 +0000
Date:   Fri, 21 Feb 2020 17:10:24 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: macb: Properly handle phylink on at91rm9200
Message-ID: <20200221171024.GK25745@shell.armlinux.org.uk>
References: <20200217104348.43164-1-alexandre.belloni@bootlin.com>
 <661c1e61-11c8-0c54-83a2-5e81674246e0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661c1e61-11c8-0c54-83a2-5e81674246e0@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 02:03:47PM -0800, Florian Fainelli wrote:
> 
> 
> On 2/17/2020 2:43 AM, Alexandre Belloni wrote:
> > at91ether_init was handling the phy mode and speed but since the switch to
> > phylink, the NCFGR register got overwritten by macb_mac_config().
> > 
> > Add new phylink callbacks to handle emac and at91rm9200 properly.
> > 
> > Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > ---
> 
> [snip]
> 
> > +static void at91ether_mac_link_up(struct phylink_config *config,
> > +				  unsigned int mode,
> > +				  phy_interface_t interface,
> > +				  struct phy_device *phy)
> > +{
> > +	struct net_device *ndev = to_net_dev(config->dev);
> > +	struct macb *bp = netdev_priv(ndev);
> > +
> > +	/* Enable Rx and Tx */
> > +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
> > +
> > +	netif_tx_wake_all_queues(ndev);
> 
> So this happens to be copied from the mvpp2 driver, if this is a
> requirement, should not this be moved to the phylink implementation
> since it already manages the carrier? Those two drivers are the only
> ones doing this.

Looking at mvneta, it does stuff with managing the queues itself, and
I suspect adding that into phylink will mess that driver up.  Maybe
someone with more knowledge can take a look.

But, IMHO, two drivers doing something is not grounds for moving it
into higher layers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
