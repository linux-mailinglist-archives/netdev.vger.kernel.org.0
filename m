Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB30940063C
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 21:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350063AbhICT5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 15:57:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55464 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234588AbhICT5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 15:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HO9XoMvuwbHH8/CXHe0tF2X2C2TJeLj8UMZGt5fiCxU=; b=ubsVN9rx+OYAid+ONmg8UxSgx+
        od95mDe1Wp1rdj5aEkMztftthexgBZBJaQFzRKMakMt4OhXq1t7OmT9tc54hynpZ3Izy/fkrsBc6Q
        V7NwPIhoMLMklmG2yEywn0ebLn5AYOvY6Phl+L9peqpguB3g2x4tXn5GAVgMWgkt7+q8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mMFI9-005AsI-9E; Fri, 03 Sep 2021 21:56:01 +0200
Date:   Fri, 3 Sep 2021 21:56:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <YTJ90frD66C3mVga@lunn.ch>
References: <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
 <20210902202124.o5lcnukdzjkbft7l@skbuf>
 <20210902202905.GN22278@shell.armlinux.org.uk>
 <20210903162253.5utsa45zy6h4v76t@skbuf>
 <YTJZj/Js+nmDTG0y@lunn.ch>
 <20210903185850.GY22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903185850.GY22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 07:58:50PM +0100, Russell King (Oracle) wrote:
> On Fri, Sep 03, 2021 at 07:21:19PM +0200, Andrew Lunn wrote:
> > Hi Russell
> > 
> > Do you have
> > 
> > auto brdsl
> > 
> > in your /etc/network/interfaces?
> > 
> > Looking at /lib/udev/bridge-network-interface it seems it will only do
> > hotplug of interfaces if auto is set on the bridge interface. Without
> > auto, it only does coldplug. So late appearing switch ports won't get
> > added.
> 
> I think you're looking at this:
> 
> [ "$BRIDGE_HOTPLUG" = "no" ] && exit 0
> 
> ?

No, i was meaning this bit:

   for i in $(ifquery --list --allow auto); do
        ports=$(ifquery $i | sed -n -e's/^bridge[_-]ports: //p')

Inside this is the actual adding of the interface to the bridge:

                                        brctl addif $i $port && ip link set dev $port up


$ /sbin/ifquery --list --allow auto
lo
eth0
br42

I have various tap interfaces for VMs which get added to br42 when
they appear.

     Andrew
