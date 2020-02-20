Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598641665EE
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgBTSMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:12:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35582 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbgBTSMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 13:12:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FCrzexrV6r/SLxffblwzbkO782uD+G9wMgCdYyWNw1s=; b=mrsNP29hPwh3vir+fN/3hzDPO
        gTXCMMzUKXCoLQuLJGOtmupyH8jzZfFWbpc0m69uv8754ScDYUmGEuVzmffZiMW6/qDIY4kcJbuUX
        x5Pi73G0vpZGghbqb0FUoENw0dBGEzhfQKrcmqbli/cVMQWMaqYt0FnuZdpK4mWdq/WFAyCJeYHhx
        i3u91xe/4Ihs6Uy5EcdFvuq/r/HLS3ycJcVof7W6/2+EuK4/Zz/dMtA5XWpyS33Yr11NUn2/IJD57
        d27vW+63hDYSKBUBqtb2gjU5IXO8YrCsBf1t5ipgzbiZEPRXQzNfa/GWv7tAnFDteE/GbTSd99NXw
        9MWREb8Xw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:42972)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4qJC-0004qI-GI; Thu, 20 Feb 2020 18:12:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4qJ9-0002j1-Ne; Thu, 20 Feb 2020 18:12:19 +0000
Date:   Thu, 20 Feb 2020 18:12:19 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: fix duplicate vlan
 warning
Message-ID: <20200220181219.GC25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <E1j41KQ-0002uy-TQ@rmk-PC.armlinux.org.uk>
 <20200218115157.GG25745@shell.armlinux.org.uk>
 <20200218162750.GR31084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218162750.GR31084@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 05:27:50PM +0100, Andrew Lunn wrote:
> On Tue, Feb 18, 2020 at 11:51:57AM +0000, Russell King - ARM Linux admin wrote:
> > On Tue, Feb 18, 2020 at 11:46:14AM +0000, Russell King wrote:
> > > When setting VLANs on DSA switches, the VLAN is added to both the port
> > > concerned as well as the CPU port by dsa_slave_vlan_add().  If multiple
> > > ports are configured with the same VLAN ID, this triggers a warning on
> > > the CPU port.
> > > 
> > > Avoid this warning for CPU ports.
> > > 
> > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > Note that there is still something not right.  On the ZII dev rev B,
> > setting up a bridge across all the switch ports, I get:
> 
> Hi Russell
> 
> FYI: You need to be a little careful with VLANs on rev B. The third
> switch does not have the PVT hardware. So VLANs are going to 'leak'
> when they cross the DSA link to that switch.

I'm not sure I fully understand what you're saying or the mechanism
behind it.

From what I can see, the 88E6352 and the 88E6185 both contain a VTU
which is capable of taking an ingressing frame and restricting which
ports it can egress from.

If a frame ingresses on one 88E6352, passed across to the other
88E6352, and finally to the 88E6185, doesn't each switch look up in
its own VTU which ports to egress the packet from, which should
include the DSA ports, so it can then be passed to the other switches?
And doesn't the VTU on each switch define which ports the frame is
allowed to egress out of?

From what I can see, setting up a bridge across all lan ports on the
Zii rev B, then enabling vlan filtering, and then allowing VID V on
lan0 and lan8 (one port on each 88E6352, passed across to the other
88E6352, and finally to the 88E6185 which has the other port on)
results in VID V frames passed correctly across, and are received
appropriately.  Untagged traffic continues to be received
appropriately.

Removing VID V from lan8 (the port I'm monitoring) results in VID V
traffic no longer sent out via lan8.

So, it seems to work as one would expect.

What am I missing?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
