Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5688327F30A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgI3ULm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:11:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3ULm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 16:11:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNiRr-00GxFm-Bt; Wed, 30 Sep 2020 22:11:35 +0200
Date:   Wed, 30 Sep 2020 22:11:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
Message-ID: <20200930201135.GX3996795@lunn.ch>
References: <20200930174419.345cc9b4@xhacker.debian>
 <20200930190911.GU3996795@lunn.ch>
 <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 01:07:19PM -0700, Florian Fainelli wrote:
> 
> 
> On 9/30/2020 12:09 PM, Andrew Lunn wrote:
> > On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:
> > > Hi,
> > > 
> > > A GE phy supports pad isolation which can save power in WOL mode. But once the
> > > isolation is enabled, the MAC can't send/receive pkts to/from the phy because
> > > the phy is "isolated". To make the PHY work normally, I need to move the
> > > enabling isolation to suspend hook, so far so good. But the isolation isn't
> > > enabled in system shutdown case, to support this, I want to add shutdown hook
> > > to net phy_driver, then also enable the isolation in the shutdown hook. Is
> > > there any elegant solution?
> > 
> > > Or we can break the assumption: ethernet can still send/receive pkts after
> > > enabling WoL, no?
> > 
> > That is not an easy assumption to break. The MAC might be doing WOL,
> > so it needs to be able to receive packets.
> > 
> > What you might be able to assume is, if this PHY device has had WOL
> > enabled, it can assume the MAC does not need to send/receive after
> > suspend. The problem is, phy_suspend() will not call into the driver
> > is WOL is enabled, so you have no idea when you can isolate the MAC
> > from the PHY.
> > 
> > So adding a shutdown in mdio_driver_register() seems reasonable.  But
> > you need to watch out for ordering. Is the MDIO bus driver still
> > running?
> 
> If your Ethernet MAC controller implements a shutdown callback and that
> callback takes care of unregistering the network device which should also
> ensure that phy_disconnect() gets called, then your PHY's suspend function
> will be called.

Hi Florian

I could be missing something here, but:

phy_suspend does not call into the PHY driver if WOL is enabled. So
Jisheng needs a way to tell the PHY it should isolate itself from the
MAC, and suspend is not that.

     Andrew
