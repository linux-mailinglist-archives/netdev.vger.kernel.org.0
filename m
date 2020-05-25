Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0FC1E091E
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389083AbgEYImK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388786AbgEYImK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:42:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBF0C061A0E;
        Mon, 25 May 2020 01:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wAm2I1AOEydHH9CYIKMSAc2QfOp8pMOdoNnrQ4sB5yE=; b=mhmvJ/rVfVyaZ1m+aA3FWBMim
        X7uZAgugBoI6CFNRuNYEzxontKM3BZo99Jcd7CIilaeVu1U+aBgVqCKkbee3pgndZQwejUAuxNYRR
        GKhHecTy2CEhnVs0nrusRk5iz0+l8YqmC2YDnr/ys5ewiKxX4GppYLly1zTWGhPxnV+EraUEiZyaW
        zK6/FnhyknGpAOVN8mDcPrrZYm2BzVHCNMRFmrQmLSutdMResZVlDuwvrTfpkx/14ThJ87m82ELvt
        mSXSnXtjvZkCygxAFYAz1XdD70XqbkPnUBMZ3sJwRktGc9M+U+KYFKiP8hkd5T5sdxAVrkcMBcnwP
        0UXZ7yGMQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44772)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jd8gL-0004js-3C; Mon, 25 May 2020 09:42:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jd8gH-0004Dg-LI; Mon, 25 May 2020 09:41:57 +0100
Date:   Mon, 25 May 2020 09:41:57 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        harini.katakam@xilinx.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 3/5] net: macb: fix macb_get/set_wol() when moving to
 phylink
Message-ID: <20200525084157.GI1551@shell.armlinux.org.uk>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
 <4aeebe901fde6db70a5ca12b10e793dd2ee6ce60.1588763703.git.nicolas.ferre@microchip.com>
 <20200513130536.GI1551@shell.armlinux.org.uk>
 <c0bc2167-e49e-1026-94e3-cb5931755389@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0bc2167-e49e-1026-94e3-cb5931755389@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 04:16:04PM +0200, Nicolas Ferre wrote:
> Russell,
> 
> Thanks for the feedback.
> 
> On 13/05/2020 at 15:05, Russell King - ARM Linux admin wrote:
> > On Wed, May 06, 2020 at 01:37:39PM +0200, nicolas.ferre@microchip.com wrote:
> > > From: Nicolas Ferre <nicolas.ferre@microchip.com>
> > > 
> > > Keep previous function goals and integrate phylink actions to them.
> > > 
> > > phylink_ethtool_get_wol() is not enough to figure out if Ethernet driver
> > > supports Wake-on-Lan.
> > > Initialization of "supported" and "wolopts" members is done in phylink
> > > function, no need to keep them in calling function.
> > > 
> > > phylink_ethtool_set_wol() return value is not enough to determine
> > > if WoL is enabled for the calling Ethernet driver. Call it first
> > > but don't rely on its return value as most of simple PHY drivers
> > > don't implement a set_wol() function.
> > > 
> > > Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> > > Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> > > Cc: Harini Katakam <harini.katakam@xilinx.com>
> > > Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> > > ---
> > >   drivers/net/ethernet/cadence/macb_main.c | 18 ++++++++++--------
> > >   1 file changed, 10 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > > index 53e81ab048ae..24c044dc7fa0 100644
> > > --- a/drivers/net/ethernet/cadence/macb_main.c
> > > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > > @@ -2817,21 +2817,23 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> > >   {
> > >        struct macb *bp = netdev_priv(netdev);
> > > 
> > > -     wol->supported = 0;
> > > -     wol->wolopts = 0;
> > > -
> > > -     if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET)
> > > +     if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET) {
> > >                phylink_ethtool_get_wol(bp->phylink, wol);
> > > +             wol->supported |= WAKE_MAGIC;
> > > +
> > > +             if (bp->wol & MACB_WOL_ENABLED)
> > > +                     wol->wolopts |= WAKE_MAGIC;
> > > +     }
> > >   }
> > > 
> > >   static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> > >   {
> > >        struct macb *bp = netdev_priv(netdev);
> > > -     int ret;
> > > 
> > > -     ret = phylink_ethtool_set_wol(bp->phylink, wol);
> > > -     if (!ret)
> > > -             return 0;
> > > +     /* Pass the order to phylink layer.
> > > +      * Don't test return value as set_wol() is often not supported.
> > > +      */
> > > +     phylink_ethtool_set_wol(bp->phylink, wol);
> > 
> > If this returns an error, does that mean WOL works or does it not?
> 
> In my use case (simple phy: "Micrel KSZ8081"), if I have the error
> "-EOPNOTSUPP", it simply means that this phy driver doesn't have the
> set_wol() function. But on the MAC side, I can perfectly wake-up on WoL
> event as the phy acts as a pass-through.
> 
> > Note that if set_wol() is not supported, this will return -EOPNOTSUPP.
> > What about other errors?
> 
> True, I don't manage them. But for now this patch is a fix that only reverts
> to previous behavior. In other terms, it only fixes the regression.
> 
> But can I make the difference, and how, between?
> 1/ the phy doesn't support WoL and could prevent the WoL to happen on the
> MAC
> 2/ the phy doesn't implement (yet) the set_wol() function, if MAC can
> manage, it's fine

I think you need to read and understand the code, but don't worry, I'll
do it for you.  There are not that many implementations in phylib, so
it doesn't take long:

m88e1318_set_wol(), dp83867_set_wol(), dp83822_set_wol(),
at803x_set_wol(), lan88xx_set_wol(), and vsc85xx_wol_set().

For case 2, phylib returns -EOPNOTSUPP.

m88e1318_set_wol() returns zero on success, or propagates an error from
the MDIO bus accessors.

dp83867_set_wol() returns zero on success, or -EINVAL if the MAC address
is invalid. No bus errors are propagated.

dp83822_set_wol() is the same as dp83867_set_wol().

at803x_set_wol() returns zero on success, or -ENODEV if there is no
netdev attached (which means you shouldn't be calling this anyway),
-EINVAL if the MAC address is invalid, or sometimes propagates an
error from the MDIO bus accessors.

lan88xx_set_wol() always returns zero, but the function does nothing
other than saving the requested state, and uses that to avoid calling
genphy_suspend() for this PHY.

vsc85xx_wol_set() returns zero on success, or propagates an error from
the MDIO bus accessors.

So, what we can tell from the return code is:

- If it returned zero, the PHY likely supports and properly configured
  WoL, and you may not need to configure the MAC (depends on whether
  the PHY can wake the system up on its own.)
- If it returns -EOPNOTSUPP, there is no support for WoL at the PHY,
  and you need to program your MAC - assuming that the PHY is going to
  stay alive.
- If it returns some other error code, there was a failure of some sort
  to configure the PHY for WoL, which probably means the PHY is not
  responding, and probably means the system isn't going to be capable
  of waking up through this PHY.

For case 1, there is no code path that detects whether the PHY concerned
supports WoL or doesn't - the code paths in each driver assume that if
the PHY supports WoL, then it supports WoL.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
