Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5A94532BB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbhKPNT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236644AbhKPNT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 08:19:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182E5C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 05:17:02 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mmyKZ-0003me-Tq; Tue, 16 Nov 2021 14:16:59 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mmyKX-000665-QV; Tue, 16 Nov 2021 14:16:57 +0100
Date:   Tue, 16 Nov 2021 14:16:57 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     g@pengutronix.de, Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211116131657.GC16121@pengutronix.de>
References: <20211108111034.2735339-1-o.rempel@pengutronix.de>
 <20211110123640.z5hub3nv37dypa6m@skbuf>
 <20211112075823.GJ12195@pengutronix.de>
 <20211115234546.spi7hz2fsxddn4dz@skbuf>
 <20211116083903.GA16121@pengutronix.de>
 <20211116124723.kivonrdbgqdxlryd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211116124723.kivonrdbgqdxlryd@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:58:20 up 271 days, 16:22, 156 users,  load average: 0.13, 0.15,
 0.20
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 02:47:23PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 16, 2021 at 09:39:03AM +0100, Oleksij Rempel wrote:
> > On Tue, Nov 16, 2021 at 01:45:46AM +0200, Vladimir Oltean wrote:
> > 
> > .....
 
> > Probably I need to signal it some how from dsa driver, to let linux
> > bridge make proper decision and reduce logging noise.
> 
> What logging noise?

I get this with current ksz driver:
[   40.185928] br0: port 2(lan2) entered blocking state
[   40.190924] br0: port 2(lan2) entered listening state
[   41.043186] br0: port 2(lan2) entered blocking state
[   55.512832] br0: port 1(lan1) entered learning state
[   61.272802] br0: port 2(lan2) neighbor 8000.ae:1b:91:58:77:8b lost
[   61.279192] br0: port 2(lan2) entered listening state
[   63.113236] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[   63.123314] br0: port 2(lan2) entered blocking state
[   68.953098] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[   70.872840] br0: port 1(lan1) entered forwarding state
[   70.878183] br0: topology change detected, propagating
[   70.883820] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[   83.672804] br0: port 2(lan2) neighbor 8000.ae:1b:91:58:77:8b lost
[   83.679181] br0: port 2(lan2) entered listening state
[   85.113244] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[   85.123313] br0: port 2(lan2) entered blocking state
[   97.753160] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[  103.513076] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[  105.432801] br0: port 2(lan2) neighbor 8000.ae:1b:91:58:77:8b lost
[  105.439221] br0: port 2(lan2) entered listening state
[  107.113238] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[  107.123326] br0: port 2(lan2) entered blocking state
[  127.192807] br0: port 2(lan2) neighbor 8000.ae:1b:91:58:77:8b lost
[  127.199220] br0: port 2(lan2) entered listening state
[  129.113249] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[  129.123378] br0: port 2(lan2) entered blocking state
[  149.592804] br0: port 2(lan2) neighbor 8000.ae:1b:91:58:77:8b lost
[  149.600308] br0: port 2(lan2) entered listening state
[  151.113276] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
[  151.125213] br0: port 2(lan2) entered blocking state

Probably I have wrong expectation... 

> > And since STP state is not directly configurable on this switch, it
> > probably means receive/transmit enable state of the port.  So, packets
> > with matching MAC should be forwarded even if port is in the receive
> > disabled state. Correct?
> 
> In the context we've been discussing so far, "forwarding" has a pretty
> specific meaning, which is autonomously redirecting from one front port
> to another. For link-local packets, what you want is "trapping", i.e.
> send to the CPU and to the CPU only.

Ok. Thank you!

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
