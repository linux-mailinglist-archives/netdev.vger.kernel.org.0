Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25CBF6A7F
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfKJRM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:12:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59170 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbfKJRM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 12:12:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d1/wBmCUgQrZFeXbtuxm3UhkIAbROwdwwbzmfZCKtB8=; b=CgdoljIu4ACuGBjfcT4ie5gAs/
        jXMP8unEc3FoDzr/rJQtkI86blqOJaNDEo2MLgrDD5hicSQGulZx1tJnBuewMYQDsTFN1UFcgFcbb
        Ci+eMo1HaCbPFAL1ZtVgQchfzH4knRRiSpAb/OM0ou3DzrgdEowdIlWG9vza8WgZeLUo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTqle-000721-TQ; Sun, 10 Nov 2019 18:12:50 +0100
Date:   Sun, 10 Nov 2019 18:12:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 15/15] net: mscc: ocelot: don't hardcode the
 number of the CPU port
Message-ID: <20191110171250.GH25889@lunn.ch>
References: <20191109130301.13716-1-olteanv@gmail.com>
 <20191109130301.13716-16-olteanv@gmail.com>
 <20191110165031.GF25889@lunn.ch>
 <CA+h21hoDvAX7NgUL0VxkBwyaAst6cr_-xTz9=7T+CANqV=Zv9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoDvAX7NgUL0VxkBwyaAst6cr_-xTz9=7T+CANqV=Zv9A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 07:00:33PM +0200, Vladimir Oltean wrote:
> On Sun, 10 Nov 2019 at 18:50, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sat, Nov 09, 2019 at 03:03:01PM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > VSC7514 is a 10-port switch with 2 extra "CPU ports" (targets in the
> > > queuing subsystem for terminating traffic locally).
> >
> > So maybe that answers my last question.
> >
> > > There are 2 issues with hardcoding the CPU port as #10:
> > > - It is not clear which snippets of the code are configuring something
> > >   for one of the CPU ports, and which snippets are just doing something
> > >   related to the number of physical ports.
> > > - Actually any physical port can act as a CPU port connected to an
> > >   external CPU (in addition to the local CPU). This is called NPI mode
> > >   (Node Processor Interface) and is the way that the 6-port VSC9959
> > >   (Felix) switch is integrated inside NXP LS1028A (the "local management
> > >   CPU" functionality is not used there).
> >
> > So i'm having trouble reading this and spotting the difference between
> > the DSA concept of a CPU port and the two extra "CPU ports". Maybe
> > using the concept of virtual ports would help?
> >
> > Are the physical ports number 0-9, and so port #10 is the first extra
> > "CPU port", aka a virtual port? And so that would not work for DSA,
> > where you need a physical port.
> >
> >       Andrew
> 
> Right. See my other answer which links to Ocelot documentation.

Yes, i'm getting the picture now.

The basic problem is that in the Linux kernel CPU port has a specific
meaning, and it is clashing with the meaning used in the datasheet. So
maybe in the driver, we need to refer to these two ports as 'local
ports'?

The mv88e6xxx driver has a similar problem. Some of the switches have
a Z80 embedded in them. And this Z80 has an ethernet interface
connected to the switch core as port 12. So far we don't support it,
but if we ever do, i'm sure we will end up calling it the z80 port,
not the cpu port.

    Andrew
