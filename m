Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA9F681671
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbjA3QbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjA3Qa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:30:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6B15CB2;
        Mon, 30 Jan 2023 08:30:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5072BB81269;
        Mon, 30 Jan 2023 16:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5743C433EF;
        Mon, 30 Jan 2023 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675096255;
        bh=AC6U3VMJNN/q/G0+HfHLfVdXp0zpGpH19UmVhxl1N8g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZtquOcQjoSTW8NkmEOZLJNtP8jgsob63o6YSt69ImpK21A7ytVGr17Ti7v5YRWuGg
         B0nQno3ic6QzTMMXNsQFQfC1ONFgvwosSu24sHVhYHN2qvgK61y2o4l0VHZ/pVKjGR
         eJ/prqEvFy3DsE3DzjY4h3piZBVyWzXEmS2X1XS0+L+Q/iXyMe3bPl60ajIsMhQqB6
         Zkhtwl5qrSWGTUkD3QVvaGkdRgrEFPTcO6dZgFZln4qVWGpgHmH8WHIBm0+nhzEWmv
         tZJNbRVvZzyInIZXhZGH0de3pBnDbGmX7Ysj20UUoUECezp6D8B9xfJx65gSH46t8p
         Svo+WaIRqI6Bw==
Date:   Mon, 30 Jan 2023 17:30:48 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v4 4/4] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Message-ID: <20230130173048.520f3f3e@thinkpad>
In-Reply-To: <Y9e05RJWrzFO7z4T@shell.armlinux.org.uk>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
        <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
        <Y9PrDPPbtIClVtB4@shell.armlinux.org.uk>
        <TYBPR01MB534129FDE16A6DB654486671D8D39@TYBPR01MB5341.jpnprd01.prod.outlook.com>
        <Y9e05RJWrzFO7z4T@shell.armlinux.org.uk>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.35; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Jan 2023 12:15:33 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Mon, Jan 30, 2023 at 05:52:15AM +0000, Yoshihiro Shimoda wrote:
> > Hi Russell,
> >   
> > > From: Russell King, Sent: Saturday, January 28, 2023 12:18 AM
> > > 
> > > On Fri, Jan 27, 2023 at 11:26:21PM +0900, Yoshihiro Shimoda wrote:  
> > > > Some Ethernet PHYs (like marvell10g) will decide the host interface
> > > > mode by the media-side speed. So, the rswitch driver needs to
> > > > initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
> > > > after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver has
> > > > .init() for initializing all ports and .power_on() for initializing
> > > > each port. So, add phy_power_{on,off} calling for it.  
> > > 
> > > So how does this work?  
> > 
> > This hardware has MDIO interfaces, and the MDIO can communicate the Ethernet
> > PHY without the Ethernet SERDES initialization. And, the Ethernet PHY can be
> > initialized, and media-side of the PHY works. So, this works.  
> 
> Ethernet PHYs can generally be communicated with irrespective of the
> serdes state, so that isn't the concern.
> 
> What I'm trying to grasp is your decision making behind putting the
> serdes phy power control in the link_up/link_down functions, when
> doing so is fundamentally problematical if in-band mode is ever
> supported - and in-band mode has to be supported for things like
> fibre connections to work.
> 
> > > 88x3310 can change it's MAC facing interface according to the speed
> > > negotiated on the media side, or it can use rate adaption mode, but
> > > if it's not a MACSEC device, the MAC must pace its transmission
> > > rate to that of the media side link.  
> > 
> > My platform has 88x2110 so that it's not a MACSEC device.  
> 
> ... which supports USXGMII, 10GBaseR, 5GBaseR, 2500BaseX and SGMII,
> possibly with rate adaption, and if it's not a MACSEC device, that
> rate adaption will likely require the MAC side to pace its
> transmission to the media speed.
> 
> > > The former requires one to reconfigure the interface mode in
> > > mac_config(), which I don't see happening in this patch set.  
> > 
> > You're correct. This patch set doesn't have such reconfiguration
> > because this driver doesn't support such a feature (for now).  
> 
> Is this planned? When are we likely to see this code?
> 
> > > The latter requires some kind of configuration in mac_link_up()
> > > which I also don't see happening in this patch set.  
> > 
> > You're correct. This patch set doesn't have such configuration
> > in mac_link_up() because this hardware cannot change speed at
> > runtime (for now).  
> 
> the hardware can't even change between the various SGMII speeds? What
> kind of utterly crippled hardware implementation is this? You make it
> sound like the hardware designers don't have a clue what they're doing.
> 
> > > So, I doubt this works properly.
> > > 
> > > Also, I can't see any sign of any working DT configuration for this
> > > switch to even be able to review a use case - all there is in net-next
> > > is the basic description of the rswitch in a .dtsi and no users. It
> > > may be helpful if there was some visibility of its use, and why
> > > phylink is being used in this driver - because right now with phylink's
> > > MAC methods stubbed out in the way they are, and even after this patch
> > > set, I see little point to this driver using phylink.  
> > 
> > In the latest net-next, r8a779f0-spider.dts is a user.
> > 
> > In r8a779f0-spider-ether.dtsi:
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/arch/arm64/boot/dts/renesas/r8a779f0-spider-ethernet.dtsi#n41
> > 
> > In r8a779f0-spider.dts:
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/arch/arm64/boot/dts/renesas/r8a779f0-spider.dts#n10  
> 
> So these configure the ports with PHYs on to use SGMII mode. No mention
> of any speed, yet you say that's configured at probe time? Do you just
> set them to 1G, and hope that the media side link negotiates to 1G
> speeds?
> 
> That doesn't sound like a good idea to me.
> 
> > > Moreover, looking at the binding document, you don't even support SFPs
> > > or fixed link, which are really the two reasons to use phylink over
> > > phylib.  
> > 
> > You're correct. This hardware doesn't support SFPs or fixed link.
> > 
> > I sent a patch at the first, I had used phylib and had added a new function
> > for setting the phy_dev->host_interfaces [1]. And then, Marek suggested
> > that I should use phylink instead of phylib. That's why this driver
> > is using phylink even if this doesn't support SFPs and fixed link.
> > 
> `> [1]
> > https://lore.kernel.org/netdev/20221019124100.41c9bbaf@dellmb/  
> 
> [Adding Marek to the Cc]
> 
> I'm afraid I don't agree with Marek given the state of this driver.
> His assertion is "there's an API for doing this" which is demonstrably
> false. If his assertion were true, then you wouldn't need to add the
> code to phylink to set phydev->host_interfaces for on-board PHYs.
> 
> I'm not particularly happy about adding that to phylink, and now that
> I read your current rather poor implementation of phylink, I'm even
> less happy about it.

OK, it seems that I had a invalid expectation that the author wants to
implement the driver fully, for future possible devices that use
rswitch with SFP cage. If this is not the case, I guess we just have to
end up with another phylib initialization function... Blegh.

But rswitch already uses phylink, so should Yoshihiro convert it whole
back to phylib? (I am not sure how much phylink API is used, maybe it
can stay that way and the new phylib function as proposed in Yoshihiro's
previous proposal can just be added.)

Marek
