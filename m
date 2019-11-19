Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2733E102A95
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfKSROv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:14:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54536 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfKSROv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:14:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jKYFns6IptPpe8g2lLn2qEwVIV6LLylnqhv3isg0R0w=; b=qrXcjlrwz3mIqKCO8PbCP1YN8
        BdFFeqcOcyBlr26O3eaYJg65sdt22DsOd31cL2mRuxISYVL0wjc80HrWWuzZ8a1ynxkthfxEN5cPN
        GiiSRUXSokEQpVo4OgkY8jZjbk2oIigMb/FIuNwSxd1+0XYMxWhtRsPoAslQ41wcJLgYMy+f3y9Xm
        NKL3yEXZ3S2dj0JuW6WrVMScnrcjszaXq2ZxdGvjYzPcW0X+avFBjL38RcBdJ0tqGTil8HeXK8jE/
        KV6wtdyiaRGpYiqfMljFURlse32IHiORw1TgDXWlOXxTmlHN25f1K+cjev6OknjP5hL5G+wkcYiw/
        V2DNVyjbA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41804)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iX75R-0002iM-Ov; Tue, 19 Nov 2019 17:14:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iX75N-0000uU-4t; Tue, 19 Nov 2019 17:14:41 +0000
Date:   Tue, 19 Nov 2019 17:14:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191119171441.GE25745@shell.armlinux.org.uk>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <1572477512-4618-5-git-send-email-ioana.ciornei@nxp.com>
 <20191117161351.GH1344@shell.armlinux.org.uk>
 <VI1PR0402MB2800DAE9E3951704B7F643FAE04C0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800DAE9E3951704B7F643FAE04C0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 04:22:46PM +0000, Ioana Ciornei wrote:
> > Subject: Re: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support
> > through phylink
> > 
> > On Thu, Oct 31, 2019 at 01:18:31AM +0200, Ioana Ciornei wrote:
> > > The dpaa2-eth driver now has support for connecting to its associated
> > > PHY device found through standard OF bindings.
> > >
> > > This happens when the DPNI object (that the driver probes on) gets
> > > connected to a DPMAC. When that happens, the device tree is looked up
> > > by the DPMAC ID, and the associated PHY bindings are found.
> > >
> > > The old logic of handling the net device's link state by hand still
> > > needs to be kept, as the DPNI can be connected to other devices on the
> > > bus than a DPMAC: other DPNI, DPSW ports, etc. This logic is only
> > > engaged when there is no DPMAC (and therefore no phylink instance)
> > > attached.
> > >
> > > The MC firmware support multiple type of DPMAC links: TYPE_FIXED,
> > > TYPE_PHY. The TYPE_FIXED mode does not require any DPMAC
> > management
> > > from Linux side, and as such, the driver will not handle such a DPMAC.
> > >
> > > Although PHYLINK typically handles SFP cages and in-band AN modes, for
> > > the moment the driver only supports the RGMII interfaces found on the
> > > LX2160A. Support for other modes will come later.
> > >
> > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > ...
> > 
> > > @@ -3363,6 +3425,13 @@ static irqreturn_t dpni_irq0_handler_thread(int
> > irq_num, void *arg)
> > >  	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
> > >  		set_mac_addr(netdev_priv(net_dev));
> > >  		update_tx_fqids(priv);
> > > +
> > > +		rtnl_lock();
> > > +		if (priv->mac)
> > > +			dpaa2_eth_disconnect_mac(priv);
> > > +		else
> > > +			dpaa2_eth_connect_mac(priv);
> > > +		rtnl_unlock();
> > 
> > Sorry, but this locking is deadlock prone.
> > 
> > You're taking rtnl_lock().
> > dpaa2_eth_connect_mac() calls dpaa2_mac_connect().
> > dpaa2_mac_connect() calls phylink_create().
> > phylink_create() calls phylink_register_sfp().
> > phylink_register_sfp() calls sfp_bus_add_upstream().
> > sfp_bus_add_upstream() calls rtnl_lock() *** DEADLOCK ***.
> 
> I recently discovered this also when working on adding support for SFPs.
> 
> > 
> > Neither phylink_create() nor phylink_destroy() may be called holding the rtnl
> > lock.
> > 
> 
> Just to summarise:
> 
> * phylink_create() and phylink_destroy() should NOT be called with the rtnl lock held

Correct.  However, they are only intended to be called from paths where
the netdev is *not* registered.

> * phylink_disconnect_phy() should be called with the lock

Correct.

> * depending on when the netdev is registered the phylink_of_phy_connect()
> may be called with or without the rtnl lock

Correct - if it is called _before_ the netdev has been published, then
it is safe to add the PHY to phylink.  If the netdev has been published,
userspace or the kernel can manipulate its state, and that's where races
can occur - so the rtnl lock must be held.

> I'll have to move the lock and unlock around the actual _connect() and _disconnect_phy()
> calls so that even the case where the DPMAC is connected at runtime
> (the EVENT_ENDPOINT_CHANGED referred above) is treated correctly.

I am extremely concerned about this, because it appears that you are
calling phylink_create() and phylink_destroy() for a net device that
is published.  That scenario is not in the design scope of phylink.

phylink is designed such that it is created before the network device
is published, and it persists until the network device is destroyed.
It was never intended to be dynamically created and removed with the
network device published.

Isn't it also true that there isn't a 1:1 mapping between dpni devices
and dpmac devices?  In a virtualised setup, isn't it true that each
VM can have its own dpni device which is connected to a single dpmac
device?  Isn't it also true that a single dpni device can be connected
to a vitual switch which itself is connected to several dpmac devices?
An example of that can be seen in Figure 41 of the LX2160A BSP v0.5
document, where we see an example of two DPMAC objects connected to
a single DPSW (switch) object, which are then connected to two DPNI
objects (which are our ethernet interfaces.)  Another example is
Figure 49 which is even more complex.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
