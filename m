Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3862B2E34
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 16:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgKNPpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 10:45:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgKNPpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 10:45:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdxjU-0072ah-HO; Sat, 14 Nov 2020 16:44:56 +0100
Date:   Sat, 14 Nov 2020 16:44:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Message-ID: <20201114154456.GY1480543@lunn.ch>
References: <20201114020851.GW1480543@lunn.ch>
 <C72Y9Y96O02K.2J4BFT8MY7S6U@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C72Y9Y96O02K.2J4BFT8MY7S6U@wkz-x280>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > + *
> > > + * A 3-bit code is used to relay why a particular frame was sent to
> > > + * the CPU. We only use this to determine if the packet was mirrored
> > > + * or trapped, i.e. whether the packet has been forwarded by hardware
> > > + * or not.
> >
> > Maybe add that, not all generations support all codes.
> 
> Not sure I have that information.

I'm not asking you list per code which switches support it. I'm just
think we should add a warning, it cannot be assumed all switches
support all codes. I just looked at the 6161 for example, and it is
missing 5 from its list.

> > > +			 */
> > > +			return NULL;
> > > +		case DSA_CODE_ARP_MIRROR:
> > > +		case DSA_CODE_POLICY_MIRROR:
> > > +			/* Mark mirrored packets to notify any upper
> > > +			 * device (like a bridge) that forwarding has
> > > +			 * already been done by hardware.
> > > +			 */
> > > +			skb->offload_fwd_mark = 1;
> > > +			break;
> > > +		case DSA_CODE_MGMT_TRAP:
> > > +		case DSA_CODE_IGMP_MLD_TRAP:
> > > +		case DSA_CODE_POLICY_TRAP:
> > > +			/* Traps have, by definition, not been
> > > +			 * forwarded by hardware, so don't mark them.
> > > +			 */
> >
> > Humm, yes, they have not been forwarded by hardware. But is the
> > software bridge going to do the right thing and not flood them? Up
> 
> The bridge is free to flood them if it wants to (e.g. IGMP/MLD
> snooping is off) or not (e.g. IGMP/MLD snooping enabled). The point
> is, that is not for a lowly switchdev driver to decide. Our job is to
> relay to the bridge if this skb has been forwarded or not, the end.
> 
> > until now, i think we did mark them. So this is a clear change in
> > behaviour. I wonder if we want to break this out into a separate
> > patch? If something breaks, we can then bisect was it the combining
> > which broke it, or the change of this mark.
> 
> Since mv88e6xxx can not configure anything that generates
> DSA_CODE_MGMT_TRAP or DSA_CODE_POLICY_TRAP yet, we do not have to
> worry about any change in behavior there.
> 
> That leaves us with DSA_CODE_IGMP_MLD_TRAP. Here is the problem:
> 
> Currenly, tag_dsa.c will set skb->offload_fwd_mark for IGMP/MLD
> packets, whereas tag_edsa.c will exempt them. So we can not unify the
> two without changing the behavior of one.

I'm not saying that this change is wrong. I'm just afraid as a
behaviour change, it might break something. If something does break,
it will be easier to track down, if it is a change on its own. So
please look if we can add a simple patch to tag_dsa.c which removes
the marking of such frames. And then the next patch can combine the
two into one driver. If it does break, git bisect will then tell us
which patch broke it.

     Andrew
