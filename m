Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4741164022
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgBSJTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:19:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39972 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgBSJTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:19:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0K6Fzmw7bYWKp+EbkalK+AjHAaIVhPNLBweIfAlG/jU=; b=e+WrzJG0qETEUzfzZCt4WHrhb
        OvO/B/aR+oDbvlbPZrnxs6d/E6aOevbAxDxR0zZ+Yw5fQ1+TJ0buaNXfJlM8Mz5QCxVzV4Efoff74
        xik6yIlAHT2Skbn4oRXGiZpfJwcyZ2nX3WfQ6+xVz37r8t5WPZ4joE13IG3Wm8MjmkOhYQ56WH4c6
        5EtQOD3u86QeQ5aqfQyFZPeNC+feTS9QSPuNKRbO+X7iOggVNA81iXOOqMy1QH9E6pgE/jRKzu3hw
        20dyurz+Qoycs70V/N7T8gzKpwg+FG88gddLqIekx8WuFGuATaULJfQxFxOBclXQYhJm9ABEZdeVw
        IYWSF/i8g==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49886)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4LVZ-0004RX-A5; Wed, 19 Feb 2020 09:19:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4LVU-0001KP-9H; Wed, 19 Feb 2020 09:19:00 +0000
Date:   Wed, 19 Feb 2020 09:19:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200219091900.GQ25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <20200219001737.GP25745@shell.armlinux.org.uk>
 <20200219034730.GE10541@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219034730.GE10541@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 04:47:30AM +0100, Andrew Lunn wrote:
> On Wed, Feb 19, 2020 at 12:17:37AM +0000, Russell King - ARM Linux admin wrote:
> > On Tue, Feb 18, 2020 at 04:00:08PM -0800, Florian Fainelli wrote:
> > > On 2/18/20 3:45 AM, Russell King - ARM Linux admin wrote:
> > > > Hi,
> > > > 
> > > > This is a repost of the previously posted RFC back in December, which
> > > > did not get fully reviewed.  I've dropped the RFC tag this time as no
> > > > one really found anything too problematical in the RFC posting.
> > > > 
> > > > I've been trying to configure DSA for VLANs and not having much success.
> > > > The setup is quite simple:
> > > > 
> > > > - The main network is untagged
> > > > - The wifi network is a vlan tagged with id $VN running over the main
> > > >   network.
> > > > 
> > > > I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
> > > > setup to provide wifi access to the vlan $VN network, while the switch
> > > > is also part of the main network.
> > > 
> > > Why not just revert 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa:
> > > Don't add vlans when vlan filtering is disabled")? If a driver wants to
> > > veto the programming of VLANs while it has ports enslaved to a bridge
> > > that does not have VLAN filtering, it should have enough information to
> > > not do that operation.
> > 
> > I do not have the knowledge to know whether reverting that commit
> > would be appropriate; I do not know how the non-Marvell switches will
> > behave with such a revert - what was the reason for the commit in
> > the first place?
> > 
> > The commit says:
> > 
> >     This fixes at least one corner case. There are still issues in other
> >     corners, such as when vlan_filtering is later enabled.
> > 
> > but it doesn't say what that corner case was.  So, presumably reverting
> > it will cause a regression of whatever that corner case was...
> 
> Yes, sorry, bad commit message. I'm not too sure, but it could of been
> that the switch was adding the VLANs to its tables, even though it
> should not because filtering is disabled. And i also think the default
> VLAN was not defined at that point, it only gets defined when
> vlan_filtering is enabled?

It's been too long since I researched all these details, but I seem
to remember that in the Linux software bridge, vlan 1 is always
present even when vlan filtering is not enabled.

Looking at br_vlan_init():

        br->default_pvid = 1;

and nbp_vlan_init() propagates that irrespective of the bridge vlan
enable state to switchdev.  nbp_vlan_init() is called whenever any
interface is added to a bridge (in br_add_if()).

As I believe I mentioned somewhere in the commit messages or covering
message, for at least some of the Marvell DSA switches, it is safe to
add VTU entries - they do not even look at the VTU when the port has
802.1Q disabled.  Whether that is true for all Marvell's DSA switches
I don't know without trawling every functional spec, and I was hoping
that you guys would know.  I guess I need to trawl the specs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
