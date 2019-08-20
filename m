Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C1795BDC
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfHTKBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:01:44 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:59105 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbfHTKBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:01:44 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id B714DFF808;
        Tue, 20 Aug 2019 10:01:40 +0000 (UTC)
Date:   Tue, 20 Aug 2019 12:01:40 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20190820100140.GA3292@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190816132959.GC8697@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190816132959.GC8697@bistromath.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sabrina,

On Fri, Aug 16, 2019 at 03:29:59PM +0200, Sabrina Dubroca wrote:
> 2019-08-13, 16:18:40 +0000, Igor Russkikh wrote:
> > On 13.08.2019 16:17, Andrew Lunn wrote:
> 
> > That could be a strong limitation in
> > cases when user sees HW macsec offload is broken or work differently, and he/she
> > wants to replace it with SW one.
> 
> Agreed, I think an offload that cannot be disabled is quite problematic.
> 
> > MACSec is a complex feature, and it may happen something is missing in HW.
> > Trivial example is 256bit encryption, which is not always a musthave in HW
> > implementations.
> 
> +1
> 
> > 2) I think, Antoine, its not totally true that otherwise the user macsec API
> > will be broken/changed. netlink api is the same, the only thing we may want to
> > add is an optional parameter to force selection of SW macsec engine.
> 
> Yes, I think we need an offload on/off parameter (and IMO it should
> probably be off by default). Then, if offloading is requested but
> cannot be satisfied (unsupported key length, too many SAs, etc), or if
> incompatible settings are requested (mixing offloaded and
> non-offloaded SCs on a device that cannot do it), return an error.
> 
> If we also export that offload parameter during netlink dumps, we can
> inspect the state of the system, which helps for debugging.

So it seems the ability to enable or disable the offloading on a given
interface is the main missing feature. I'll add that, however I'll
probably (at least at first):

- Have the interface to be fully offloaded or fully handled in s/w (with
  errors being thrown if a given configuration isn't supported). Having
  both at the same time on a given interface would be tricky because of
  the MACsec validation parameter.

- Won't allow to enable/disable the offloading of there are rules in
  place, as we're not sure the same rules would be accepted by the other
  implementation.

I'm not sure if we should allow to mix the implementations on a given
physical interface (by having two MACsec interfaces attached) as the
validation would be impossible to do (we would have no idea if a
packet was correctly handled by the offloading part or just not being
a MACsec packet in the first place, in Rx).

I agree the offloading should be disabled by default, and only enabled
by an user explicitly.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
