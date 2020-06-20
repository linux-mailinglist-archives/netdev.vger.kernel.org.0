Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443C0202428
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 16:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgFTOfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 10:35:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbgFTOfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 10:35:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmeaU-001P9t-AV; Sat, 20 Jun 2020 16:35:18 +0200
Date:   Sat, 20 Jun 2020 16:35:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     Jason Cobham <jcobham@questertangent.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Question on DSA switches, IGMP forwarding and switchdev
Message-ID: <20200620143518.GG304147@lunn.ch>
References: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
 <20200619215817.GN279339@lunn.ch>
 <72f92622c69143b0880125dfe9f9a955@questertangent.com>
 <20200619223606.GO279339@lunn.ch>
 <eb6b5f84-2a5a-1938-0657-0eac9f2390df@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6b5f84-2a5a-1938-0657-0eac9f2390df@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So yes, we can read the code here, but I'm wondering which packet types
> would then get this flag set, and which won't. Because in case of
> IGMP/MLD, the packets are in fact forwarded, but the meaning of the flag
> in skb is to prevent the skb from being forwarded further, which seems
> wrong in all cases.
> 
> I'm thinking maybe the flag should never be set?

It is a while since i did much with multicast, so please correct me
when i'm wrong...

IGMP can use different group addresses as far as i remember.
Join/leave uses the group address of interest. But query can use
224.0.0.1 or the group address.

The bridge should learn from joins, either spontaneous or as a reply
to a query. When it sees a join, it should add a multicast FDB to the
hardware for the group, so traffic is forwarded out that port.

So for real multicast traffic, we do want the flag set, the hardware
should be doing the forwarding. If we don't set the flag, we end up
with duplication when the SW bridge also forwards the multicast
traffic.

For IGMP/MLD itself, we probably need to see what the switch does. For
IGMP using the group address, does the multicast FDB rule match and
cause the hardware to forward the IGMP? If yes, then we need the flag
set, otherwise the IGMP gets duplicated. If no, then we don't want the
flag set, and leave the SW bridge to do the forwarding, or reply
itself if it is the querier.

For IGMP using 224.0.0.1, do we ever get a multicast FDB added for
that?

It sounds like you have a better test setup than i have. Can you play
with this?

6352 uses the EDSA tagger. But the same bits exist in the DSA tag,
which the 6390 uses, due to incompatibility reasons. So it would be
nice to extend both taggers.

     Thanks
	Andrew
