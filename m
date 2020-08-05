Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB9E23CFF4
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgHET1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:27:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbgHERNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 13:13:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k3Jda-008NJr-P6; Wed, 05 Aug 2020 15:39:22 +0200
Date:   Wed, 5 Aug 2020 15:39:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Swarm NameRedacted <thesw4rm@pm.me>
Cc:     netdev@vger.kernel.org
Subject: Re: Packet not rerouting via different bridge interface after
 modifying destination IP in TC ingress hook
Message-ID: <20200805133922.GB1960434@lunn.ch>
References: <20200805081951.4iznjdgudulitamc@chillin-at-nou.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805081951.4iznjdgudulitamc@chillin-at-nou.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 08:19:57AM +0000, Swarm NameRedacted wrote:
> Hi,
> 
> I am trying to build a quick script via TC direct action and eBPF to
> modify the destination IP of a packet so that it is routed through a
> different bridge interface. Made a quick network diagram below to
> demonstrate it. 
> 
>       Packet (dst: 10.10.3.2)
>                 |
>                 |
>     ingress - (change dst to 10.10.4.1)
>                 |
>                 |
>                eth0
>                 |
>                 |
>       br0 - (addr: 10.10.3.1)
> __eth0______   ___ens19_______
>      |                |
>      |                |
>      |                |
>      |                |
> host: 10.10.4.1  host: 10.10.3.2
> 
> 
> 
> As shown, I send a packet from a separate client to eth0. eth0 is the
> WAN interface of its machine and ens19 is the LAN interface; both are
> connecting with bridge br0. Without modification, the packet goes
> straight through ens19 to 10.10.3.2. 
> 
> Theoretically, by modifying the destination IP to 10.10.4.1 at ingress,
> the packet should be rerouted to go back through eth0. However, in
> practice, I find that the packet still goes through ens19 after
> modification, and of course after that it never reaches anything. 
> 
> Why is it that ingress catches the packet before the bridging decision,
> but the packet isn't rerouted? Is there a better way to do this?
 
What is not clear is the subnet size. Is this all a /16 network? So
that 10.10.4.1 and 10.10.3.2 are in the same subnet? Or are these
different subnets, and you have a router somewhere you do not show in
your diagram? Is this redirect happening at L2, or L3? Maybe you even
have NAT involved, since you talk about WAN and LAN? Do you also need
to be modifying the destination MAC address?

You also need to think about at what layer in the stack is the IP
address being modified? A bridge works on L2. Is the packet being
bridges at L2 and sent out without an IP processing at L3? Do you
actually want to be using ebtables to modify the packet at L2?

But maybe take a step back. You are wanting to do something really
odd. What is your real use case. Maybe there is a better way to do
what you want. Please explain why you want to send a packet back out
the way it came in, with a different IP address.

	 Andrew
