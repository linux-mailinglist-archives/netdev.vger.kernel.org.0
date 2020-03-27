Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603001960A0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgC0VtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:49:02 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40256 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbgC0VtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 17:49:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6RKUwhhVvgfoGMJCpKlIDOvfeqhBKdoj/xwfI4aqz7w=; b=MhPwF2AU8VP5jr4prFyJWNn9v
        TOR+ZW938HT4E9QNuauhOeilPDN11TvsY0PMwGSq3ZZvLR0w9IdgHNFR4QU7POJRsv2Y6wNcv84e3
        e14UPeUhoxTB5yDCJkacubXJ0bJpJK8JMAcO7EmS14KAT645U9N4xt3FfA/fvS52W3oExA0MEwxAD
        HW3WedzJyeBz2nLk+ArzCcUZzekNYCyqj+XSsd/HSgyd2dLJh6wS17v2BjrpRO7qu/7yciwY8zNN3
        xYQCbz98tMhQfMt/LNV4ViUUyQG7Qi+nfBfmujgSHP2Ni/Jn18xsHm08VWgfbBsWu7sbDXcenUWOh
        dURqyiNMQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38076)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHwqW-0003Tu-Mh; Fri, 27 Mar 2020 21:48:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHwqU-0004Zz-Gm; Fri, 27 Mar 2020 21:48:54 +0000
Date:   Fri, 27 Mar 2020 21:48:54 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Set link down when
 changing speed
Message-ID: <20200327214854.GS25745@shell.armlinux.org.uk>
References: <20200323214900.14083-1-andrew@lunn.ch>
 <20200323214900.14083-3-andrew@lunn.ch>
 <20200323220113.GX25745@shell.armlinux.org.uk>
 <20200323223934.GA14512@lunn.ch>
 <20200327111316.GF25745@shell.armlinux.org.uk>
 <20200327212608.GU3819@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327212608.GU3819@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 10:26:08PM +0100, Andrew Lunn wrote:
> > > Hi Russell
> > > 
> > > So the problem here is that CPU and DSA ports should default to up and
> > > at their fastest speed. During setup, the driver is setting the CPU
> > > port to 1G and up. Later on, phylink finds the fixed-link node in DT,
> > > and then sets the port to 100Mbps as requested.
> > > 
> > > How do you suggest fixing this? If we find a fixed-link, configure it
> > > first down and then up?
> > 
> > I think this is another example of DSA fighting phylink in terms of
> > what's expected.
> > 
> > The only suggestion I've come up so far with is to avoid calling
> > mv88e6xxx_port_setup_mac() with forced-link-up in
> > mv88e6xxx_setup_port() if we have phylink attached.
> 
> Hi Russell
> 
> Yes, that might work. But it is a solution specific to mv88e6xxx. I
> guess other switches could have a similar issue.
> 
> Is it really that bad to add the link down as i proposed? Do we even
> have a guarantee the port is down before phylink starts configuring
> it, for all switch drivers?

That's partly why I made the suggestion, as mac_config() could end
up being called with potential changes to the configuration with
the link already up.  If that can happen, then it's not just about
the link being down before mac_link_up() is called...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
