Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F9C962A3
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbfHTOl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:41:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730456AbfHTOlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:41:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DAE43086E24;
        Tue, 20 Aug 2019 14:41:24 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BB8380483;
        Tue, 20 Aug 2019 14:41:20 +0000 (UTC)
Date:   Tue, 20 Aug 2019 16:41:19 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
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
Message-ID: <20190820144119.GA28714@bistromath.localdomain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190816132959.GC8697@bistromath.localdomain>
 <20190820100140.GA3292@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190820100140.GA3292@kwain>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 20 Aug 2019 14:41:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-20, 12:01:40 +0200, Antoine Tenart wrote:
> So it seems the ability to enable or disable the offloading on a given
> interface is the main missing feature. I'll add that, however I'll
> probably (at least at first):
> 
> - Have the interface to be fully offloaded or fully handled in s/w (with
>   errors being thrown if a given configuration isn't supported). Having
>   both at the same time on a given interface would be tricky because of
>   the MACsec validation parameter.
> 
> - Won't allow to enable/disable the offloading of there are rules in
>   place, as we're not sure the same rules would be accepted by the other
>   implementation.

That's probably quite problematic actually, because to do that you
need to be able to resync the state between software and hardware,
particularly packet numbers. So, yeah, we're better off having it
completely blocked until we have a working implementation (if that
ever happens).

However, that means in case the user wants to set up something that's
not offloadable, they'll have to:
 - configure the offloaded version until EOPNOTSUPP
 - tear everything down
 - restart from scratch without offloading

That's inconvenient.

Talking about packet numbers, can you describe how PN exhaustion is
handled?  I couldn't find much about packet numbers at all in the
driver patches (I hope the hw doesn't wrap around from 2^32-1 to 0 on
the same SA).  At some point userspace needs to know that we're
getting close to 2^32 and that it's time to re-key.  Since the whole
TX path of the software implementation is bypassed, it looks like the
PN (as far as drivers/net/macsec.c is concerned) never increases, so
userspace can't know when to negotiate a new SA.

> I'm not sure if we should allow to mix the implementations on a given
> physical interface (by having two MACsec interfaces attached) as the
> validation would be impossible to do (we would have no idea if a
> packet was correctly handled by the offloading part or just not being
> a MACsec packet in the first place, in Rx).

That's something that really bothers me with this proposal. Quoting
from the commit message:

> the packets seen by the networking stack on both the physical and
> MACsec virtual interface are exactly the same

If the HW/driver is expected to strip the sectag, I don't see how we
could ever have multiple secy's at the same time and demultiplex
properly between them. That's part of the reason why I chose to have
virtual interfaces: without them, picking the right secy on TX gets
weird.

AFAICT, it means that any filters (tc, tcpdump) need to be different
between offloaded and non-offloaded cases.

And it's going to be confusing to the administrator when they look at
tcpdumps expecting to see MACsec frames.

I don't see how this implementation handles non-macsec traffic (on TX,
that would be packets sent directly through the real interface, for
example by wpa_supplicant - on RX, incoming MKA traffic for
wpa_supplicant). Unless I missed something, incoming MKA traffic will
end up on the macsec interface as well as the lower interface (not
entirely critical, as long as wpa_supplicant can grab it on the lower
device, but not consistent with the software implementation). How does
the driver distinguish traffic that should pass through unmodified
from traffic that the HW needs to encapsulate and encrypt?

If you look at IPsec offloading, the networking stack builds up the
ESP header, and passes the unencrypted data down to the driver. I'm
wondering if the same would be possible with MACsec offloading: the
macsec virtual interface adds the header (and maybe a dummy ICV), and
then the HW does the encryption. In case of HW that needs to add the
sectag itself, the driver would first strip the headers that the stack
created. On receive, the driver would recreate a sectag and the macsec
interface would just skip all verification (decrypt, PN).

-- 
Sabrina
