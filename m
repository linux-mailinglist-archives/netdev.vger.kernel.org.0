Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F83195613
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 12:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgC0LNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 07:13:24 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60616 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgC0LNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 07:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1Qic4dtWl+G64IWvMBgQDlCfa8PFl1P7z1ltDcWGdH8=; b=c3UoGIipd37tNGmNyG0710sT4
        bYvnAkyROQduk3hPzBTXThS4/upahy1Ska0mfZucwdSX8VWaIXCGOXvlJpzYSLQHc3IAyhf6ogz2s
        lf/bmrGMuzZbVEbrhGcJ0tVXcXaWRvvU0nUeRD/RxAJmA3sZZZkMrp5Qvf0Zpay4bFgBzK7q2KMFs
        xpglrc6XS4uEvgN+2th+Jayr8nDYrm0j5m+nsp9rNv7cMn101BaKhZtuZHxfs2x4Se6KOrjmv3I1O
        j+2kqQwQrVCaaMcARfZkWXalZ9NNbWBu7z+9htBjQe8hLo6ChREMG9igoshNfz+yUIDaqT99R1kFu
        U5Bwqsf5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42014)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHmvO-0000ed-Tf; Fri, 27 Mar 2020 11:13:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHmvM-0004AS-RQ; Fri, 27 Mar 2020 11:13:16 +0000
Date:   Fri, 27 Mar 2020 11:13:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Set link down when
 changing speed
Message-ID: <20200327111316.GF25745@shell.armlinux.org.uk>
References: <20200323214900.14083-1-andrew@lunn.ch>
 <20200323214900.14083-3-andrew@lunn.ch>
 <20200323220113.GX25745@shell.armlinux.org.uk>
 <20200323223934.GA14512@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323223934.GA14512@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 11:39:34PM +0100, Andrew Lunn wrote:
> On Mon, Mar 23, 2020 at 10:01:13PM +0000, Russell King - ARM Linux admin wrote:
> > On Mon, Mar 23, 2020 at 10:49:00PM +0100, Andrew Lunn wrote:
> > > The MAC control register must not be changed unless the link is down.
> > > Add the necassary call into mv88e6xxx_mac_link_up. Without it, the MAC
> > > does not change state, the link remains at the wrong speed.
> > > 
> > > Fixes: 30c4a5b0aad8 ("net: mv88e6xxx: use resolved link config in mac_link_up()")
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > ---
> > >  drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> > > index dd8a5666a584..24ce17503950 100644
> > > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > > @@ -733,6 +733,14 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
> > >  
> > >  	mv88e6xxx_reg_lock(chip);
> > >  	if (!mv88e6xxx_port_ppu_updates(chip, port) || mode == MLO_AN_FIXED) {
> > > +		/* Port's MAC control must not be changed unless the
> > > +		 * link is down
> > > +		 */
> > > +		err = chip->info->ops->port_set_link(chip, port,
> > > +						     LINK_FORCED_DOWN);
> > > +		if (err)
> > > +			goto error;
> > > +
> > 
> > The port should be down at this point, otherwise the link state is not
> > matching phylink's idea of the state.  Your patch merely works around
> > that.  I think it needs solving properly.
> 
> Hi Russell
> 
> So the problem here is that CPU and DSA ports should default to up and
> at their fastest speed. During setup, the driver is setting the CPU
> port to 1G and up. Later on, phylink finds the fixed-link node in DT,
> and then sets the port to 100Mbps as requested.
> 
> How do you suggest fixing this? If we find a fixed-link, configure it
> first down and then up?

I think this is another example of DSA fighting phylink in terms of
what's expected.

The only suggestion I've come up so far with is to avoid calling
mv88e6xxx_port_setup_mac() with forced-link-up in
mv88e6xxx_setup_port() if we have phylink attached.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
