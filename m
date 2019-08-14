Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBF88CE7C
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 10:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfHNIbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 04:31:42 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:42159 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbfHNIbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 04:31:41 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 88B9F2000B;
        Wed, 14 Aug 2019 08:31:38 +0000 (UTC)
Date:   Wed, 14 Aug 2019 10:31:38 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190814083138.GE3200@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor,

On Tue, Aug 13, 2019 at 04:18:40PM +0000, Igor Russkikh wrote:
> On 13.08.2019 16:17, Andrew Lunn wrote:
> > On Tue, Aug 13, 2019 at 10:58:17AM +0200, Antoine Tenart wrote:
> >> I think this question is linked to the use of a MACsec virtual interface
> >> when using h/w offloading. The starting point for me was that I wanted
> >> to reuse the data structures and the API exposed to the userspace by the
> >> s/w implementation of MACsec. I then had two choices: keeping the exact
> >> same interface for the user (having a virtual MACsec interface), or
> >> registering the MACsec genl ops onto the real net devices (and making
> >> the s/w implementation a virtual net dev and a provider of the MACsec
> >> "offloading" ops).
> >>
> >> The advantages of the first option were that nearly all the logic of the
> >> s/w implementation could be kept and especially that it would be
> >> transparent for the user to use both implementations of MACsec.
> > 
> > We have always talked about offloading operations to the hardware,
> > accelerating what the linux stack can do by making use of hardware
> > accelerators. The basic user API should not change because of
> > acceleration. Those are the general guidelines.
> > 
> > It would however be interesting to get comments from those who did the
> > software implementation and what they think of this architecture. I've
> > no personal experience with MACSec, so it is hard for me to say if the
> > current architecture makes sense when using accelerators.
> 
> In terms of overall concepts, I'd add the following:
> 
> 1) With current implementation it's impossible to install SW macsec engine onto
> the device which supports HW offload. That could be a strong limitation in
> cases when user sees HW macsec offload is broken or work differently, and he/she
> wants to replace it with SW one.
> MACSec is a complex feature, and it may happen something is missing in HW.
> Trivial example is 256bit encryption, which is not always a musthave in HW
> implementations.

Agreed. I'm not sure it would be possible to have both used at the same
time but there should be a way to switch between the two
implementations. That is not supported for now, but I think that would
be a good thing, and can probably come later on.

> 2) I think, Antoine, its not totally true that otherwise the user macsec API
> will be broken/changed. netlink api is the same, the only thing we may want to
> add is an optional parameter to force selection of SW macsec engine.

I meant that we can either have a virtual net device representing the
MACsec feature and being the iface used to configure it, or we could
have it only when s/w MACsec is used. That to me is part of the "API",
or at least part of what's exposed to the user.

> I'm also eager to hear from sw macsec users/devs on whats better here.

I'd like more comments as well :)

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
