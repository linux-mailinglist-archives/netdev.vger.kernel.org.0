Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB1690309
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfHPNaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbfHPNaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:30:05 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2726D300189C;
        Fri, 16 Aug 2019 13:30:04 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D6B51001B02;
        Fri, 16 Aug 2019 13:30:01 +0000 (UTC)
Date:   Fri, 16 Aug 2019 15:29:59 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
Message-ID: <20190816132959.GC8697@bistromath.localdomain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 16 Aug 2019 13:30:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-13, 16:18:40 +0000, Igor Russkikh wrote:
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
> > Hi Antoine
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
> the device which supports HW offload.

You mean how it's implemented in this patchset?

> That could be a strong limitation in
> cases when user sees HW macsec offload is broken or work differently, and he/she
> wants to replace it with SW one.

Agreed, I think an offload that cannot be disabled is quite problematic.

> MACSec is a complex feature, and it may happen something is missing in HW.
> Trivial example is 256bit encryption, which is not always a musthave in HW
> implementations.

+1

> 2) I think, Antoine, its not totally true that otherwise the user macsec API
> will be broken/changed. netlink api is the same, the only thing we may want to
> add is an optional parameter to force selection of SW macsec engine.

Yes, I think we need an offload on/off parameter (and IMO it should
probably be off by default). Then, if offloading is requested but
cannot be satisfied (unsupported key length, too many SAs, etc), or if
incompatible settings are requested (mixing offloaded and
non-offloaded SCs on a device that cannot do it), return an error.

If we also export that offload parameter during netlink dumps, we can
inspect the state of the system, which helps for debugging.

> I'm also eager to hear from sw macsec users/devs on whats better here.

I don't do much development on MACsec these days, and I don't
personally use it outside of testing and development.

-- 
Sabrina
