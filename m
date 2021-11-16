Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FE4452D02
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhKPImF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhKPImE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 03:42:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A22C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 00:39:07 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mmtzc-0001T6-Oi; Tue, 16 Nov 2021 09:39:04 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mmtzb-0008FT-5m; Tue, 16 Nov 2021 09:39:03 +0100
Date:   Tue, 16 Nov 2021 09:39:03 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>, g@pengutronix.de
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211116083903.GA16121@pengutronix.de>
References: <20211108111034.2735339-1-o.rempel@pengutronix.de>
 <20211110123640.z5hub3nv37dypa6m@skbuf>
 <20211112075823.GJ12195@pengutronix.de>
 <20211115234546.spi7hz2fsxddn4dz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211115234546.spi7hz2fsxddn4dz@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 05:38:52 up 271 days,  8:02, 107 users,  load average: 0.04, 0.14,
 0.13
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 01:45:46AM +0200, Vladimir Oltean wrote:

.....

> > > Why != DISABLED? I expect that dev_ops->cfg_port_member() affects only
> > > data packet forwarding, not control packet forwarding, right?
> > 
> > No. According to the KSZ9477S datasheet:
> > "The processor should program the “Static MAC Table” with the entries that it
> > needs to receive (for example, BPDU packets). The “overriding” bit should be set
> > so that the switch will forward those specific packets to the processor. The
> > processor may send packets to the port(s) in this state. Address learning is
> > disabled on the port in this state."
> > 
> > This part is not implemented.
> > 
> > In current driver implementation (before or after this patch), all
> > packets are forwarded. It looks like, current STP implementation in this driver
> > is not complete. If I create a loop, the bridge will permanently toggle one of
> > ports between blocking and listening. 
> > 
> > Currently I do not know how to proceed with it. Remove stp callback and
> > make proper, straightforward bride_join/leave? Implement common soft STP
> > for all switches without HW STP support?
> 
> What does "soft STP" mean?

Some HW seems to provide configuration bits for ports STP states. For
example by enabling it, I can just set listening state and it will only pass
BPDU packets without need to program static MAC table. (At least, this
would be my expectation)

For example like this:
https://elixir.bootlin.com/linux/v5.16-rc1/source/drivers/net/dsa/mt7530.c#L1121

If this HW really exist and works as expected, how should I name it?

> You need to have a port state in which data  plane packets are blocked,
> but BPDUs can pass.

ack.

> Unless you trap all packets to the CPU and make the selection in software
> (therefore, including the forwarding, I don't know if that is so desirable),

Yes, this is my point, on plain linux bridge with two simple USB ethernet
adapters, I'm able to use STP without any HW offloading.

If my HW do not provide straightforward way to trap BPDU packets to CPU,
i should be able to reuse functionality already provided by the linux
bridge. Probably I need to signal it some how from dsa driver, to let linux
bridge make proper decision and reduce logging noise.

For example:
- Have flag like: ds->sta_without_bpdu_trap = true;
- If no .port_mdb_add/.port_fdb_add callbacks are implemented, handle
  all incoming packet by the linux bridge without making lots of noise,
  and use .port_bridge_join/.port_bridge_leave to separate ports.
- If .port_mdb_add/.port_fdb_add are implemented, program the static MAC table.

> you don't have much of a choice except to do what you've said above, program
> the static MAC table with entries for 01-80-c2-00-00-0x which trap those
> link-local multicast addresses to the CPU and set the STP state override
> bit for them and for them only.

Hm... Microchip documentation do not describes it as STP state override. Only
as "port state override". And since STP state is not directly configurable
on this switch, it probably means receive/transmit enable state of the port.
So, packets with matching MAC should be forwarded even if port is in the
receive disabled state. Correct?

> BTW, see the "bridge link set" section in "man bridge" for a list of
> what you should do in each STP state.

ack. Thank you.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
