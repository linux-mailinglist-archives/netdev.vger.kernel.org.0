Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1B044E2BA
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 08:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhKLIBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 03:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhKLIBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 03:01:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE7EC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 23:58:26 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mlRS5-00025P-7C; Fri, 12 Nov 2021 08:58:25 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mlRS3-00051M-3e; Fri, 12 Nov 2021 08:58:23 +0100
Date:   Fri, 12 Nov 2021 08:58:23 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211112075823.GJ12195@pengutronix.de>
References: <20211108111034.2735339-1-o.rempel@pengutronix.de>
 <20211110123640.z5hub3nv37dypa6m@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211110123640.z5hub3nv37dypa6m@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:07:17 up 267 days,  9:31, 105 users,  load average: 0.13, 0.15,
 0.12
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 02:36:40PM +0200, Vladimir Oltean wrote:
> On Mon, Nov 08, 2021 at 12:10:34PM +0100, Oleksij Rempel wrote:
> > Current driver version is able to handle only one bridge at time.
> > Configuring two bridges on two different ports would end up shorting this
> > bridges by HW. To reproduce it:
> > 
> > 	ip l a name br0 type bridge
> > 	ip l a name br1 type bridge
> > 	ip l s dev br0 up
> > 	ip l s dev br1 up
> > 	ip l s lan1 master br0
> > 	ip l s dev lan1 up
> > 	ip l s lan2 master br1
> > 	ip l s dev lan2 up
> > 
> > 	Ping on lan1 and get response on lan2, which should not happen.
> > 
> > This happened, because current driver version is storing one global "Port VLAN
> > Membership" and applying it to all ports which are members of any
> > bridge.
> > To solve this issue, we need to handle each port separately.
> > 
> > This patch is dropping the global port member storage and calculating
> > membership dynamically depending on STP state and bridge participation.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> 
> Because there wasn't any restriction in the driver against multiple
> bridges, I would be tempted to send to the "net" tree and provide a
> Fixes: tag.

This patch looks too intrusive to me. It will be hard to backport it to
older versions. How about have two patches: add limit to one bridge for
net and add support for multiple bridges for net-next?

> > +	dp = dsa_to_port(ds, port);
> > +
> > +	for (i = 0; i < ds->num_ports; i++) {
> > +		const struct dsa_port *dpi = dsa_to_port(ds, i);
> 
> Other drivers name this "other_dp", I don't think that name is too bad.
> Also, you can use "dsa_switch_for_each_user_port", which is also more
> efficient, although you can't if you target 'stable' with this change,
> since it has been introduced rather recently.

ok

> > +		struct ksz_port *pi = &dev->ports[i];
> 
> and this could be "other_p" rather than "pi".

ok

> > +		u8 val = 0;
> > +
> > +		if (!dsa_is_user_port(ds, i))
> >  			continue;
> > -		p = &dev->ports[i];
> > -		if (!(dev->member & (1 << i)))
> > +		if (port == i)
> >  			continue;
> > +		if (!dp->bridge_dev || dp->bridge_dev != dpi->bridge_dev)
> > +			continue;
> > +
> > +		pi = &dev->ports[i];
> > +		if (pi->stp_state != BR_STATE_DISABLED)
> > +			val |= BIT(dsa_upstream_port(ds, i));
> >  
> 
> This is saying:
> For each {user port, other port} pair, if the other port isn't DISABLED,
> then allow the user port to forward towards the CPU port of the other port.
> What sense does that make? You don't support multiple CPU ports, so this
> port's CPU port is that port's CPU port, and you have one more (broken)
> forwarding rule towards the CPU port below.

Ok, understand.

> > -		/* Port is a member of the bridge and is forwarding. */
> > -		if (p->stp_state == BR_STATE_FORWARDING &&
> > -		    p->member != dev->member)
> > -			dev->dev_ops->cfg_port_member(dev, i, dev->member);
> > +		if (pi->stp_state == BR_STATE_FORWARDING &&
> > +		    p->stp_state == BR_STATE_FORWARDING) {
> > +			val |= BIT(port);
> > +			port_member |= BIT(i);
> > +		}
> > +
> > +		dev->dev_ops->cfg_port_member(dev, i, val);
> >  	}
> > +
> > +	if (p->stp_state != BR_STATE_DISABLED)
> > +		port_member |= BIT(dsa_upstream_port(ds, port));
> 
> Why != DISABLED? I expect that dev_ops->cfg_port_member() affects only
> data packet forwarding, not control packet forwarding, right?

No. According to the KSZ9477S datasheet:
"The processor should program the “Static MAC Table” with the entries that it
needs to receive (for example, BPDU packets). The “overriding” bit should be set
so that the switch will forward those specific packets to the processor. The
processor may send packets to the port(s) in this state. Address learning is
disabled on the port in this state."

This part is not implemented.

In current driver implementation (before or after this patch), all
packets are forwarded. It looks like, current STP implementation in this driver
is not complete. If I create a loop, the bridge will permanently toggle one of
ports between blocking and listening. 

Currently I do not know how to proceed with it. Remove stp callback and
make proper, straightforward bride_join/leave? Implement common soft STP
for all switches without HW STP support?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
