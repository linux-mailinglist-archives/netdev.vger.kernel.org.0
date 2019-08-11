Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3768689245
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfHKPSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:18:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfHKPSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 11:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JsWO28/Ly7XPDW/T89DFvzSByGDeTkLGeNq8jzFgjX4=; b=lyHSoDRKrrm+Jdslew8MHAQCw0
        629mDZ0tLI6PFzd5rn5QEH7LTo3rV2+t93mQ/rsoGm1TcEe61Ugua2fyIXEgNDarmJvkDZNEnc647
        w4AghYo3fYJi5mR/FFiNb/o6DnPR3PRq5yzk8XHu16EvrIwvO73Ru2thPEmj9JDinANs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwpc6-0003o1-1E; Sun, 11 Aug 2019 17:18:30 +0200
Date:   Sun, 11 Aug 2019 17:18:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port
 registration
Message-ID: <20190811151830.GA14290@lunn.ch>
References: <20190811031857.2899-1-marek.behun@nic.cz>
 <20190811033910.GL30120@lunn.ch>
 <91cd70df-c856-4c7e-7ebb-c01519fb13d2@gmail.com>
 <20190811160404.06450685@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811160404.06450685@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 04:04:04PM +0200, Marek Behun wrote:
> OK guys, something is terribly wrong here.
> 
> I bisected to the commit mentioned (88d6272acaaa), looked around at the
> genphy functions, tried adding the link=0 workaround and it did work,
> so I though this was the issue.
> 
> What I realized now is that before the commit 88d6272acaaa things
> worked because of two bugs, which negated each other. This commit caused
> one of this bugs not to fire, and thus the second bug was not negated.
> 
> What actually happened before the commit that broke it is this:
>   - after the fixed_phy is created, the parameters are corrent
>   - genphy_read_status breaks the parameters:
>      - first it sets the parameters to unknown (SPEED_UNKNOWN,
>        DUPLEX_UNKNOWN)
>      - then read the registers, which are simulated for fixed_phy
>      - then it uses phy-core.c:phy_resolve_aneg_linkmode function, which
>        looks for correct settings by bit-anding the ->advertising and
>        ->lp_advertigins bit arrays. But in fixed_phy, ->lp_advertising
>        is set to zero, so the parameters are left at SPEED_UNKNOWN, ...
>        (this is the first bug)
>   - then adjust_link is called, which then goes to
>     mv88e6xxx_port_setup_mac, where there is a test if it should change
>     something:
>        if (state.link == link && state.speed == speed &&
>            state.duplex == duplex)
>                return 0;
>   - since current speed on the switch port (state.speed) is SPEED_1000,
>     and new speed is SPEED_UNKNOWN, this test fails, and so the rest of
>     this function is called, which makes the port work
>     (the if test is the second bug)
> 
> After the commit that broke things:
>   - after the fixed_phy is created, the parameters are corrent
>   - genphy_read_status doesn't change them
>   - mv88e6xxx_port_setup_mac does nothing, since the if condition above
>     is true
> 
> So, there are two things that are broken:
>  - the test in mv88e6xxx_port_setup_mac whether there is to be a change
>    should be more sophisticated
>  - fixed_phy should also simulate the lp_advertising register
> 
> What do you think of this?

Marek

This is the sort of information i like. I was having trouble
understanding what was really wrong and how it was fixed by your
previous patch.

So setting the emulated lp_advertise to advertise makes a lot of sense
for fixed phy. And it is something worthy of stable.

As for mv88e6xxx_port_setup_mac(), which parameter is actually
important here? My assumption was, if one of the other parameters
changes, it would not happen alone. The link would also go down, and
later come up again, etc. But it seems that assumption is wrong.

At a guess, it is the RGMII delays. That would explain CRC errors in
frames received by the master interface.

       Andrew
