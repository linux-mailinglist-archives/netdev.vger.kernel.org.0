Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D0E163B96
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgBSDru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:47:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgBSDrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:47:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n/rA/wQN2tDW7XQ4a4cG/JrEAfEikgUOMsmDJUptXSc=; b=z5VwMsJkwIeQUTEN1pEg1w1JOq
        ZYgJyL5+tl1cbi0jvD8rU5NSMSNDSuQHyeq0+Tqeg/yiRBT09CBN4K7VaGNRPCLGntZs0tdt07Jbg
        n15+ebT5q+rKZp1D8auZ8g+0oROmR2VOnAvvFTwF/zg87TXVdPbZuRGMC9IUTVvcyHtE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j4GKg-0006dv-Oa; Wed, 19 Feb 2020 04:47:30 +0100
Date:   Wed, 19 Feb 2020 04:47:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200219034730.GE10541@lunn.ch>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <20200219001737.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219001737.GP25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 12:17:37AM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Feb 18, 2020 at 04:00:08PM -0800, Florian Fainelli wrote:
> > On 2/18/20 3:45 AM, Russell King - ARM Linux admin wrote:
> > > Hi,
> > > 
> > > This is a repost of the previously posted RFC back in December, which
> > > did not get fully reviewed.  I've dropped the RFC tag this time as no
> > > one really found anything too problematical in the RFC posting.
> > > 
> > > I've been trying to configure DSA for VLANs and not having much success.
> > > The setup is quite simple:
> > > 
> > > - The main network is untagged
> > > - The wifi network is a vlan tagged with id $VN running over the main
> > >   network.
> > > 
> > > I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
> > > setup to provide wifi access to the vlan $VN network, while the switch
> > > is also part of the main network.
> > 
> > Why not just revert 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa:
> > Don't add vlans when vlan filtering is disabled")? If a driver wants to
> > veto the programming of VLANs while it has ports enslaved to a bridge
> > that does not have VLAN filtering, it should have enough information to
> > not do that operation.
> 
> I do not have the knowledge to know whether reverting that commit
> would be appropriate; I do not know how the non-Marvell switches will
> behave with such a revert - what was the reason for the commit in
> the first place?
> 
> The commit says:
> 
>     This fixes at least one corner case. There are still issues in other
>     corners, such as when vlan_filtering is later enabled.
> 
> but it doesn't say what that corner case was.  So, presumably reverting
> it will cause a regression of whatever that corner case was...

Yes, sorry, bad commit message. I'm not too sure, but it could of been
that the switch was adding the VLANs to its tables, even though it
should not because filtering is disabled. And i also think the default
VLAN was not defined at that point, it only gets defined when
vlan_filtering is enabled?

       Andrew
