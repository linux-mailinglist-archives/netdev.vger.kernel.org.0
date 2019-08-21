Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4AA997699
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfHUKBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:01:11 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56929 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfHUKBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 06:01:11 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 511F46000D;
        Wed, 21 Aug 2019 10:01:07 +0000 (UTC)
Date:   Wed, 21 Aug 2019 12:01:06 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20190821100106.GA3006@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190816132959.GC8697@bistromath.localdomain>
 <20190820100140.GA3292@kwain>
 <20190820144119.GA28714@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190820144119.GA28714@bistromath.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sabrina,

On Tue, Aug 20, 2019 at 04:41:19PM +0200, Sabrina Dubroca wrote:
> 2019-08-20, 12:01:40 +0200, Antoine Tenart wrote:
> > So it seems the ability to enable or disable the offloading on a given
> > interface is the main missing feature. I'll add that, however I'll
> > probably (at least at first):
> > 
> > - Have the interface to be fully offloaded or fully handled in s/w (with
> >   errors being thrown if a given configuration isn't supported). Having
> >   both at the same time on a given interface would be tricky because of
> >   the MACsec validation parameter.
> > 
> > - Won't allow to enable/disable the offloading of there are rules in
> >   place, as we're not sure the same rules would be accepted by the other
> >   implementation.
> 
> That's probably quite problematic actually, because to do that you
> need to be able to resync the state between software and hardware,
> particularly packet numbers. So, yeah, we're better off having it
> completely blocked until we have a working implementation (if that
> ever happens).
> 
> However, that means in case the user wants to set up something that's
> not offloadable, they'll have to:
>  - configure the offloaded version until EOPNOTSUPP
>  - tear everything down
>  - restart from scratch without offloading
> 
> That's inconvenient.

That's right, the user might have to replay the whole configuration if
on rule failed to match the h/w requirements. It's inconvenient, but I
think it's better to be safe until we have (if that happens) a working
implementation of synchronizing the rules' state.

> Talking about packet numbers, can you describe how PN exhaustion is
> handled?  I couldn't find much about packet numbers at all in the
> driver patches (I hope the hw doesn't wrap around from 2^32-1 to 0 on
> the same SA).  At some point userspace needs to know that we're
> getting close to 2^32 and that it's time to re-key.  Since the whole
> TX path of the software implementation is bypassed, it looks like the
> PN (as far as drivers/net/macsec.c is concerned) never increases, so
> userspace can't know when to negotiate a new SA.

That's a very good point. It actually was on my todo list for the next
version (I wanted to discuss the other points first). We would also
need to sync the stats at some point.

> > I'm not sure if we should allow to mix the implementations on a given
> > physical interface (by having two MACsec interfaces attached) as the
> > validation would be impossible to do (we would have no idea if a
> > packet was correctly handled by the offloading part or just not being
> > a MACsec packet in the first place, in Rx).
> 
> That's something that really bothers me with this proposal. Quoting
> from the commit message:
> 
> > the packets seen by the networking stack on both the physical and
> > MACsec virtual interface are exactly the same

That bothers me as well.

> If the HW/driver is expected to strip the sectag, I don't see how we
> could ever have multiple secy's at the same time and demultiplex
> properly between them. That's part of the reason why I chose to have
> virtual interfaces: without them, picking the right secy on TX gets
> weird.
> 
> AFAICT, it means that any filters (tc, tcpdump) need to be different
> between offloaded and non-offloaded cases.
> 
> And it's going to be confusing to the administrator when they look at
> tcpdumps expecting to see MACsec frames.

Right. I did not see how *not* to strip the sectag in the h/w back then,
I'll have another look because that would improve things a lot.

@all: do other MACsec offloading hardware allow not to stip the sectag?

> I don't see how this implementation handles non-macsec traffic (on TX,
> that would be packets sent directly through the real interface, for
> example by wpa_supplicant - on RX, incoming MKA traffic for
> wpa_supplicant). Unless I missed something, incoming MKA traffic will
> end up on the macsec interface as well as the lower interface (not
> entirely critical, as long as wpa_supplicant can grab it on the lower
> device, but not consistent with the software implementation).

That's right, as we have no way to tell if an Rx packet was MACsec or
non-MACsec traffic, both will end up on both interfaces. Some h/w may be
able to insert a custom header (or may allow not to strip the sectag),
but I did not find anything related to this in mine (I'll double check).

> How does the driver distinguish traffic that should pass through
> unmodified from traffic that the HW needs to encapsulate and encrypt?

At least in PHYs, packets go in a classification unit (that can match on
multiple parts of the packet, given the hardware capabilities, eg. the
MAC addresses). The result of the match is an action, which can be
"bypass the MACsec block" or "go through it (which links the packet to a
given configuration)". This is done in Rx and in Tx, and this is how the
h/w block will know what to encapsulate and encrypt.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
