Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117AC20A372
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403979AbgFYQ6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390448AbgFYQ6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:58:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2738CC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 09:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KA2L7YIaOveCxce914orf+0UI6UF9clLL+eRMx6k4os=; b=WviRB/YJdsgyBkHr99DW0aRkV
        ouBDScXTVtvfzDlsdD8AJiL01vtqul7fzRUiwy7JUc26iKB+ypFJALSZisx4x7TEPmJH9kvttN5tu
        ONYCyI6lYORFnIQLN2WX0spXJLCcFtny9QAgatxh9tWJjw3E2hzTiKzav88978t+r/fspaDmYmaPc
        s1ZGt5XxppUYpILJL3XOfaraqVeoN+6kkyw6k02VBwQru1/m2goX+36top1OZvE71/lK5vIwfd9HI
        NX0k128V+qtNr5zukZYaFUzsu/68TE9CfBqPGTlYCln8gsv/o99cwChLNiZRN1o9SrcFLhnY+Zbb6
        ooRpvgUWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59650)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1joVCc-0004df-Sb; Thu, 25 Jun 2020 17:58:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1joVCc-00039m-Jv; Thu, 25 Jun 2020 17:58:18 +0100
Date:   Thu, 25 Jun 2020 17:58:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 4/7] net: dsa: felix: set proper pause frame
 timers based on link speed
Message-ID: <20200625165818.GK1551@shell.armlinux.org.uk>
References: <20200625152331.3784018-1-olteanv@gmail.com>
 <20200625152331.3784018-5-olteanv@gmail.com>
 <20200625163715.GH1551@shell.armlinux.org.uk>
 <CA+h21hqVF-QkyuhPY9AjOmebYBKhLH7ACo4cdWa8q2Y_7jRHbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqVF-QkyuhPY9AjOmebYBKhLH7ACo4cdWa8q2Y_7jRHbg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 07:48:23PM +0300, Vladimir Oltean wrote:
> On Thu, 25 Jun 2020 at 19:37, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Thu, Jun 25, 2020 at 06:23:28PM +0300, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > state->speed holds a value of 10, 100, 1000 or 2500, but
> > > SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.
> > >
> > > So set the correct speed encoding into this register.
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >  drivers/net/dsa/ocelot/felix.c | 27 +++++++++++++++++++++++----
> > >  1 file changed, 23 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> > > index d229cb5d5f9e..da337c63e7ca 100644
> > > --- a/drivers/net/dsa/ocelot/felix.c
> > > +++ b/drivers/net/dsa/ocelot/felix.c
> > > @@ -250,10 +250,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
> > >                          DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
> > >                          DEV_CLOCK_CFG);
> > >
> > > -     /* Flow control. Link speed is only used here to evaluate the time
> > > -      * specification in incoming pause frames.
> > > -      */
> > > -     mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
> > > +     switch (state->speed) {
> > > +     case SPEED_10:
> > > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
> > > +             break;
> > > +     case SPEED_100:
> > > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
> > > +             break;
> > > +     case SPEED_1000:
> > > +     case SPEED_2500:
> > > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
> > > +             break;
> > > +     case SPEED_UNKNOWN:
> > > +             mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
> > > +             break;
> > > +     default:
> > > +             dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
> > > +                     port, state->speed);
> > > +             return;
> > > +     }
> > >
> > >       /* handle Rx pause in all cases, with 2500base-X this is used for rate
> > >        * adaptation.
> > > @@ -265,6 +280,10 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
> > >                             SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
> > >                             SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
> > >                             SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
> > > +
> > > +     /* Flow control. Link speed is only used here to evaluate the time
> > > +      * specification in incoming pause frames.
> > > +      */
> > >       ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
> >
> > I'm not that happy with the persistence of felix using the legacy
> > method; I can bring a horse to water but can't make it drink comes
> > to mind.  I'm at the point where I don't care _if_ my phylink changes
> > break code that I've asked people to convert and they haven't yet,
> > and I'm planning to send the series that /may/ cause breakage in
> > that regard pretty soon, so the lynx PCS changes can move forward.
> >
> > I even tried to move felix forward by sending a patch for it, and I
> > just gave up with that approach based on your comment.
> >
> > Shrug.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> The callbacks clearly work the way they are, given the current
> structure of phylink, as proven by the users of this driver. Code that
> isn't there yet simply isn't there yet.
> 
> What you consider "useless churn" and what I consider "useless churn"
> are pretty different things.
> To me, patch 7/7 is the useless churn, that's why it's at the end.
> Patches 1-6 are structured in a way that is compatible with
> backporting to a stable 5.4 tree. Patch 7, not so much.
> 
> The fact that you have such an attitude and you make the effort to
> actually send an email complaining about me using state->speed in
> .mac_config(), when literally 3 patches later I'm moving this
> configuration where you want it to be, is pretty annoying.

I have asked you to update felix _prior_ to my patch update, because
I forsee the possibility for there to be breakage from pushing the
PCS support further forward.  In other words, I see there to be a
dependency between moving forward with PCS support and drivers that
still use the legacy method.

You don't see that, so you constantly bitch and moan.

Please stop being a problem.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
