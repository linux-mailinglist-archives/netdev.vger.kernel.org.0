Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70021F58F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 15:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfEON1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 09:27:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36235 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfEON1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 09:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5S2pVDW3XP4ZL+gZFmV/JbhuTGA4t+wtZImlBpPxNmE=; b=E7njVkvy1niaZbJ+/6CqinEWwO
        1KxgU5JKrAm4rji0wFTnw+q+HkDxlhm5bnol/ztWtzk9MY+u7EFC/4yg7baY+qqqWFbCFJzhGdMqP
        0MNDiNHudnlj4/rpfx4YcogkBw+7dxXEPcIYSP7X6D1FecPJuhVaF70tEz0gSylFlKh0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQtvx-0006n4-Qw; Wed, 15 May 2019 15:27:01 +0200
Date:   Wed, 15 May 2019 15:27:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: dsa: using multi-gbps speeds on CPU port
Message-ID: <20190515132701.GD23276@lunn.ch>
References: <20190515143936.524acd4e@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515143936.524acd4e@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 02:39:36PM +0200, Maxime Chevallier wrote:
> Hello everyone,
> 
> I'm working on a setup where I have a 88e6390X DSA switch connected to
> a CPU (an armada 8040) with 2500BaseX and RXAUI interfaces (we only use
> one at a time).

Hi Maxime

RXAUI should just work. By default, the CPU port is configured to its
maximum speed, so it should be doing 10Gbps. Slowing it down to
2500BaseX is however an issue.

> I'm facing a limitation with the current way to represent that link,
> where we use a fixed-link description in the CPU port, like this :
> 
> ...
> switch0: switch0@1 {
> 	...
> 	port@0 {
> 		reg = <0>;
> 		label = "cpu";
> 		ethernet = <&eth0>;
> 		phy-mode = "2500base-x";
> 		fixed-link {
> 			speed = <2500>;
> 			full-duplex;
> 		};
> 	};
> };
> ...
> 
> In this scenario, the dsa core will try to create a PHY emulating the
> fixed-link on the DSA port side. This can't work with link speeds above
> 1Gbps, since we don't have any emulation for these PHYs, which would be
> using C45 MMDs.
> 
> We could add support to emulate these modes, but I think there were some
> discussions about using phylink to support these higher speed fixed-link
> modes, instead of using PHY emulation.
> 
> However using phylink in master DSA ports seems to be a bit tricky,
> since master ports don't have a dedicated net_device, and instead
> reference the CPU-side netdevice (if I understood correctly).

I think you are getting your terminology wrong. 'master' is eth0 in
the example you gave above. CPU and DSA ports don't have netdev
structures, and so any PHY used with them is not corrected to a
netdev.

> I'll be happy to help on that, but before prototyping anything, I wanted
> to have your thougts on this, and see if you had any plans.

There are two different issues here.

1) Is using a fixed-link on a CPU or DSA port the right way to do this?
2) Making fixed-link support > 1G.

The reason i decided to use fixed-link on CPU and DSA ports is that we
already have all the code needed to configure a port, and an API to do
it, the adjust_link() callback. Things have moved on since then, and
we now have an additional API, .phylink_mac_config(). It might be
better to directly use that. If there is a max-speed property, create
a phylink_link_state structure, which has no reference to a netdev,
and pass it to .phylink_mac_config().

It is just an idea, but maybe you could investigate if that would
work.

On the master interface, the armada 8040, eth0, you still need
something. However, if you look at phylink_parse_fixedlink(), it puts
the speed etc into a phylink_link_state. It never instantiates a
fixed-phy. So i think that could be expanded to support higher speeds
without too much trouble. The interesting part is the IOCTL handler.

	Andrew
