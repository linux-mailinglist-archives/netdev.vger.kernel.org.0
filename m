Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEB4160136
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 00:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgBOXyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 18:54:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39378 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgBOXyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 18:54:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ct/lCQBlb1bJE6eE6mCcvAVHIaY3v+Uo75rKZOG9gic=; b=IR2gB+Z+9P3JNOQoqMGEZ/4Pj
        3F7fu8wpAlOVo7ao1LqhCC1vTtpPdls3XXCjFq8rZRv3f1qGuWXqhw8BmEbFl9iQJcN3Wb79sUYxh
        iixqQ3ayQmWqjU4jbupbhbWJciivM0VY9LqwNthi0y4nDt2Z/4XVDCmgbQLuLA9yIaryYoMySPu/N
        ebZWth6EBCzzlJUUACKbRjPynEn01lc1ouZ7822M1zrxXfQeFNjqbiRfRzDlydKBNF6cgBCJ3t1wS
        2j/MZ+9FpQzyAHxsmlbN+6wpLl63bz3WKTODiS8hPtqLzrIofEnMrZ2n75lZED2ilwz0Kqgu9HTph
        TWuxdKBbw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:40844)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j37GE-0007sq-GU; Sat, 15 Feb 2020 23:54:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j37GD-0004kR-1w; Sat, 15 Feb 2020 23:54:09 +0000
Date:   Sat, 15 Feb 2020 23:54:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/10] net: add linkmode helper for setting flow
 control advertisement
Message-ID: <20200215235408.GT25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zhE-0003XA-E4@rmk-PC.armlinux.org.uk>
 <20200215185632.GT31084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200215185632.GT31084@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 07:56:32PM +0100, Andrew Lunn wrote:
> On Sat, Feb 15, 2020 at 03:49:32PM +0000, Russell King wrote:
> > Add a linkmode helper to set the flow control advertisement in an
> > ethtool linkmode mask according to the tx/rx capabilities. This
> > implementation is moved from phylib, and documented with an
> > analysis of its shortcomings.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/linkmode.c   | 51 ++++++++++++++++++++++++++++++++++++
> >  drivers/net/phy/phy_device.c | 17 +-----------
> >  include/linux/linkmode.h     |  2 ++
> >  3 files changed, 54 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/net/phy/linkmode.c b/drivers/net/phy/linkmode.c
> > index 969918795228..f60560fe3499 100644
> > --- a/drivers/net/phy/linkmode.c
> > +++ b/drivers/net/phy/linkmode.c
> > @@ -42,3 +42,54 @@ void linkmode_resolve_pause(const unsigned long *local_adv,
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(linkmode_resolve_pause);
> > +
> > +/**
> > + * linkmode_set_pause - set the pause mode advertisement
> > + * @advertisement: advertisement in ethtool format
> > + * @tx: boolean from ethtool struct ethtool_pauseparam tx_pause member
> > + * @rx: boolean from ethtool struct ethtool_pauseparam rx_pause member
> > + *
> > + * Configure the advertised Pause and Asym_Pause bits according to the
> > + * capabilities of provided in @tx and @rx.
> > + *
> > + * We convert as follows:
> > + *  tx rx  Pause AsymDir
> > + *  0  0   0     0
> > + *  0  1   1     1
> > + *  1  0   0     1
> > + *  1  1   1     0
> > + *
> > + * Note: this translation from ethtool tx/rx notation to the advertisement
> > + * is actually very problematical. Here are some examples:
> > + *
> > + * For tx=0 rx=1, meaning transmit is unsupported, receive is supported:
> > + *
> > + *  Local device  Link partner
> > + *  Pause AsymDir Pause AsymDir Result
> > + *    1     1       1     0     TX + RX - but we have no TX support.
> > + *    1     1       0     1	Only this gives RX only
> > + *
> > + * For tx=1 rx=1, meaning we have the capability to transmit and receive
> > + * pause frames:
> > + *
> > + *  Local device  Link partner
> > + *  Pause AsymDir Pause AsymDir Result
> > + *    1     0       0     1     Disabled - but since we do support tx and rx,
> > + *				this should resolve to RX only.
> > + *
> > + * Hence, asking for:
> > + *  rx=1 tx=0 gives Pause+AsymDir advertisement, but we may end up
> > + *            resolving to tx+rx pause or only rx pause depending on
> > + *            the partners advertisement.
> > + *  rx=0 tx=1 gives AsymDir only, which will only give tx pause if
> > + *            the partners advertisement allows it.
> > + *  rx=1 tx=1 gives Pause only, which will only allow tx+rx pause
> > + *            if the other end also advertises Pause.
> > + */
> 
> It is good to document this.
> 
> With the change to netlink ethtool, we have the option to change the
> interface to user space, or at least, easily add another way for
> userspace to configure things. Maybe you can think of a better API?

I don't think we even need "a better API" - we just need to be a
little smarter when it comes to the implementation.

Let me expand my table above with the possible link partner resolutions
based on the current local advertisement
(Pause = rx, AsymDir = tx ^ rx):

 tx rx  Pause AsymDir	Possible partner resolutions
 0  0   0     0		Disabled
 0  1   1     1		TX only, TX+RX, Disabled
 1  0   0     1		RX only, Disabled
 1  1   1     0		TX+RX, Disabled

If we simply modify the logic such that
(Pause = rx, AsymDir = rx | tx):

 tx rx  Pause AsymDir	Possible partner resolutions
 0  0   0     0		Disabled
 0  1   1     1		TX only, TX+RX, Disabled
 1  0   0     1		RX, Disabled
 1  1   1     1		TX only, TX+RX, Disabled

That changes one resolution possibility from where the link partner
resolves to disable pause completely, to enabling transmit pause for
the forced-tx+rx-enabled local state.

To pull out the lines from the 802.3 table:

 Local device  Link partner
 Pause AsymDir Pause AsymDir Result
   0     1       1     0     Disabled

becomes:

   0     1       1     1     TX

to the link partner, which must surely be better when the link partner
is not being forced.

Now, if we want to say "if you force one end, you should force both
ends" then the immediate question then becomes, what is the point in
updating the advertisement at all?  So, would it be better to drop
the requirement to manipulate the advertisement entirely, and only
allow ethtool -s able to change the advertisement?

I don't think there's a clear-cut answer to this, but I think adding
some documentation describing what we've decided to do and
acknowledging any short-comings is very worth while... and that
should probably find its way into ethtool's man page too.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
