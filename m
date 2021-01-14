Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080F42F564A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbhANBp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:45:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbhANBDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:03:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzr2Q-000RN4-4c; Thu, 14 Jan 2021 02:02:58 +0100
Date:   Thu, 14 Jan 2021 02:02:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Message-ID: <X/+YQlEkeNYXditV@lunn.ch>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com>
 <X/+FKCRgkqOtoWbo@lunn.ch>
 <20210114001759.atz5vehkdrire6p7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114001759.atz5vehkdrire6p7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 02:17:59AM +0200, Vladimir Oltean wrote:
> On Thu, Jan 14, 2021 at 12:41:28AM +0100, Andrew Lunn wrote:
> > On Wed, Jan 13, 2021 at 05:41:38PM +0200, Vladimir Oltean wrote:
> > > +	int	(*port_priority_set)(struct dsa_switch *ds, int port,
> > > +				     struct dsa_mall_skbedit_tc_entry *skbedit);
> > 
> > The fact we can turn this on/off suggests there should be a way to
> > disable this in the hardware, when the matchall is removed. I don't
> > see any such remove support in this patch.
> 
> I don't understand this comment, sorry. When the matchall filter
> containing the skbedit action gets removed, DSA calls the driver's
> .port_priority_set callback again, this time with a priority of 0.
> There's nothing to "remove" about a port priority. I made an assumption
> (which I still consider perfectly reasonable) that no port-based
> prioritization means that all traffic gets classified to traffic class 0.

That does not work for mv88e6xxx. Its default setup, if i remember
correctly, is it looks at the TOS bits to determine priority
classes. So in its default state, it is using all the available
traffic classes.  It can also be configured to look at the VLAN
priority, or the TCAM can set the priority class, or there is a per
port default priority, which is what you are describing here. There
are bits to select which of these happen on ingress, on a per port
basis.

So setting the port priority to 0 means setting the priority of
zero. It does not mean go back to the default prioritisation scheme.

I guess any switch which has a range of options for prioritisation
selection will have a similar problem. It defaults to something,
probably something a bit smarter than everything goes to traffic class
0.

      Andrew
