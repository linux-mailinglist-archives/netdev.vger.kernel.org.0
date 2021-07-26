Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F5F3D64D3
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbhGZQGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240767AbhGZQFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:05:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660A9C0613CF
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 09:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wy9wwrrut8KUfh/tCsRE2/VvJliVs49yrz+zM/+SbaM=; b=X8uyJuEjPKr3JQ4/7ILRhpUsz
        2HsrahhvzeWaF18iJj8Eiolua1yLp9TddZUydp75vSDmFUnk4Abfh8joBQSXIk5mbJcv+E+vzmcDj
        TUYU8mbg1Nt0qUAtfNJ0vM1BuWN7/Ee+F/5dWQ0sFsXxpFLps7RKeRUMz5jE5dybUKMMzBGmdQUbV
        8L+G0vDzRZ07z3VIX9sDwXiEhObNcCtQw4EiFfSr3PVEN+355w9mAzfVJH0Z5l7RXq/5o6x8iMirI
        wURhfRjGRKOQUoCObTY7TaZKAmEwq5+1fNLqHWsQ9YC4az3aLqMK//oTsZ316nJhjwqGtKQD/dtJQ
        rxGgruHoA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46640)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m83hN-0005Kb-IG; Mon, 26 Jul 2021 17:43:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m83hN-0004rt-9C; Mon, 26 Jul 2021 17:43:25 +0100
Date:   Mon, 26 Jul 2021 17:43:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: mvpp2 switch from gmac to xlg requires ifdown/ifup
Message-ID: <20210726164325.GE22278@shell.armlinux.org.uk>
References: <20210723035202.09a299d6@thinkpad>
 <20210723080538.GB22278@shell.armlinux.org.uk>
 <20210726175223.3122f544@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726175223.3122f544@thinkpad>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 05:52:23PM +0200, Marek Behún wrote:
> On Fri, 23 Jul 2021 09:05:38 +0100
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Fri, Jul 23, 2021 at 03:52:02AM +0200, Marek Behún wrote:
> > > Hello Russell (and possibly others),
> > > 
> > > I discovered that with mvpp2 when switching from gmac (sgmii or
> > > 2500base-x mode) to xlg (10gbase-r mode) due to phylink requesting this
> > > change, the link won't come up unless I do
> > >   ifconfig ethX down
> > >   ifconfig ethX up
> > > 
> > > Can be reproduced on MacchiatoBIN:
> > > 1. connect the two 10g RJ-45 ports (88X3310 PHY) with one cable
> > > 2. bring the interfaces up
> > > 3. the PHYs should link in 10gbase-t, links on MACs will go up in
> > >    10gbase-r
> > > 4. use ethtool on one of the interfaces to advertise modes only up to
> > >    2500base-t
> > > 5. the PHYs will unlink and then link at 2.5gbase-t, links on MACs will
> > >    go up in 2500base-x
> > > 6. use ethtool on the same interface as in step 4 to advertise all
> > >    supported modes
> > > 
> > > 7. the PHYs will unlink and then link at 10gbase-t, BUT MACs won't link
> > >    !!!
> > > 8. execute
> > >      ifconfig ethX down ; ifconfig ethX up
> > >    on both interfaces. After this, the MACs will successfully link in
> > >    10gbase-r with the PHYs
> > > 
> > > It seems that the mvpp2 driver code needs to make additional stuff when
> > > chaning mode from gmac to xlg. I haven't yet been able to find out
> > > what, though.
> > > 
> > > BTW I discovered this because I am working on adding support for
> > > 5gbase-r mode to mvpp2, so that the PHY can support 5gbase-t on copper
> > > side.
> > > The ifdown/ifup cycle is required when switching from gmac to xlg, i.e.:
> > > 	sgmii		to	5gbase-r
> > > 	sgmii		to	10gbase-r
> > > 	2500base-x	to	5gbase-r
> > > 	2500base-x	to	10gbase-r
> > > but also when switching from xlg to different xlg:
> > > 	5gbase-r	to	10gbase-r
> > > 	10gbase-r	to	5gbase-r
> > > 
> > > Did someone notice this bug? I see that Russell made some changes in
> > > the phylink pcs API that touched mvpp2 (the .mac_config method got
> > > split into .mac_prepare, .mac_config and .mac_finish, and also some
> > > other changes). I haven't tried yet if the switch from gmac to xlg
> > > worked at some time in the past. But if it did, maybe these changes
> > > could be the cause?  
> > 
> > What are the PHY leds doing when you encounter this bug?
> > 
> 
> Table summary:
> 
> 			PHY0/eth0	PHY1/eth1
> 			green	yellow	green	yellow
> after boot		ON	OFF	ON	OFF
> eth0 up			ON	OFF	ON	OFF
> eth1 up			blink	ON	blink	ON
> eth0 adv -10g -5g	blink	OFF	blink	OFF
> eth0 adv +5g *	 	OFF	OFF	OFF	OFF
> eth0 down		ON	OFF	ON	OFF
> eth0 up			blink**	OFF	blink** OFF
> eth1 down		ON	OFF	ON	OFF
> eth1 up			blink	OFF	blink	OFF
> 
>  (*  PHYs are linked now, but MACs are not)
>  (** blinks only for a while after link, pings do not work,
>      read my opinion below)
>  (The last 5 lines basically the same happens if I set it to advertise
>   10g instead of 5g, but in case of 10g the yellow LED is ON when the
>   PHYs are linked.)
> 
> In words:
> 
> After boot, the green LED is ON on both PHYs.
> 
> Bringing both interfaces up changes nothing.
> 
> Plugging cable so that they link (at 10gbase-t) bring the yellow LEDs
> ON, and the green LEDs OFF, but the green LEDs blinks on activity.
> (For example when pinging eth0's ipv6 address via eth1.)
> 
> Disabling advertisement of 10gbase-t and 5gbase-t on eth0 makes the
> PHYs link at 2.5gbase-t. Both LEDs are OFF, but green blinks on
> activity.
> 
> Enabling advertisement of 5gbase-t makes the PHYs link, but the MACs
> do not link with the PHYs, and there is no blinking on activity, and
> pings do not work.
> 
> Taking one interface (eth0) down and up makes the PHYs link (we are
> still at 5gbase-t), and the green LEDs blink for a few times because of
> activity on both PHYs. But the pings do not work. I think this is
> because the eth0's PHY sent some neighbour discovery packets, and the
> eth1's PHY received them. But pings do not work because those packets
> don't go from eth1's PHY to eth1's MAC.
> 
> Taking the second interface (eth1) down and up makes the PHYs again
> link at 5gbase-t, and the green LEDs start blinking on activity. Pings
> work.

Hmm, the reason I asked was because I know the 88x3310 with older
firmware can get in a bit of a muddle when switching from SGMII back
to 10G mode. When it does, one of the link LEDs (green I think) blinks
rapidly while it is muddled, and iirc taking the interface down and
back up fixes it. There is no workaround for this other than upgrading
the PHY firmware.

If they only blink momentarily after establishing link, then that is
likely just the IPv6 router solicitation packets.

Hope that helps.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
