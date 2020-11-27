Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6E2C6963
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbgK0Q2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:28:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52994 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgK0Q2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 11:28:30 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kigba-0099TY-TT; Fri, 27 Nov 2020 17:28:18 +0100
Date:   Fri, 27 Nov 2020 17:28:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201127162818.GT2073444@lunn.ch>
References: <20201119144508.29468-1-tobias@waldekranz.com>
 <20201119144508.29468-3-tobias@waldekranz.com>
 <20201120003009.GW1804098@lunn.ch>
 <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com>
 <20201120133050.GF1804098@lunn.ch>
 <87v9dr925a.fsf@waldekranz.com>
 <20201126225753.GP2075216@lunn.ch>
 <87r1of88dp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1of88dp.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is a digression, but I really do not get this shift from using
> BUG()s to WARN()s in the kernel when you detect a violated invariant. It
> smells of "On Error Resume Next" to me.

A WARN() gives you a chance to actually use the machine to collect
logs, the kernel dump, etc. You might be able to sync the filesystems,
reducing the damage to the disks.  With BUG(), the machine is
dead. You cannot interact with it, all you have to go on, is what you
can see on the disk, or what you might have logged on the serial
console.

> We have to handle EWHATEVER correctly, no? I do not get what is so
> special about ENOMEM.

Nothing is particularly special about it. But looking at the current
code base the only other error we can get is probably ETIMEDOUT from
an MDIO read/write. But if that happens, there is probably no real
recovery. You have no idea what state the switch is in, and all other
MDIO calls are likely to fail in the same way.

> How would a call to kmalloc have any impact on the stack? (Barring
> exotic bugs in the allocator that would allow the heap to intrude on
> stack memory) Or am I misunderstanding what you mean by "the stack"?

I mean the network stack, top to bottom. Say we have a few vlan
interfaces, on top of the bridge, on top of a LAG, on top of DSA, on
top of IP over avian carriers. When setting up a LAG, what else has
happened by the time you get your ENOMEM? What notifications have
already happened, which some other layer has acted upon? It is not
just LAG inside DSA which needs to unwind, it is all the actions which
have been triggered so far.

The initial design of switchdev was transactions. First there was a
prepare call, where you validated the requested action is possible,
and allocate resources needed, but don't actually do it. This prepare
call is allowed to fail. Then there is a second call to actually do
it, and that call is not allowed to fail. This structure avoids most
of the complexity of the unwind, just free up some resources. If you
never had to allocate the resources in the first place, better still.

      Andrew
