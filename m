Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1C1449ACA
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbhKHRfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:35:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51082 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230348AbhKHRfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:35:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=ZIgkx2h2uhdvFHjzt95iXBpX3sU9M0VENzKJGAceA5A=; b=Lo
        MW7iBZLZcZ/W5dRgh3tvXYE4v5QLm7sTRyuU8ezpFLticNBV0GKG4eDYOoY75CeKsEV5qPOicuPhL
        TTB3N7ftsOoo5cl0Esl/6Wf3+o3I1MCUrjnB/CSpIpyEWuh+dDWZvVaSM2pM5pmpAJnlGBW7tAOo5
        IKrN4R5IB/qcU1o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk8Vo-00Cuvp-Br; Mon, 08 Nov 2021 18:32:52 +0100
Date:   Mon, 8 Nov 2021 18:32:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YYlfRB7updHplnLE@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
 <YYUzgyS6pfQOmKRk@lunn.ch>
 <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
 <YYkjBdu64r2JF1bR@lunn.ch>
 <4e663877558247048e9b04b027e555b8@sphcmbx02.sunplus.com.tw>
 <YYk5s5fDuub7eBqu@lunn.ch>
 <585e234fdb74499caafee3b43b5e5ab4@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <585e234fdb74499caafee3b43b5e5ab4@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 04:47:34PM +0000, Wells Lu 呂芳騰 wrote:
> > > The switch will not recognize type of packets, regardless BPDU, PTP or
> > > any other packets. If turning off source-address learning function, it
> > > works like an Ethernet plus a 2-port hub.
> > 
> > So without STP, there is no way to stop an loop, and a broadcast storm taking
> > down your network?
> 
> Do you mean connecting two PHY ports to the same LAN? We never 
> connect two PHY ports to the same LAN (or hub). I never think of this 
> loop problem. I thought only WAN has the loop problem.

Any Ethernet network can have a loop. Often loops a deliberate because
they give redundancy. STP will detect this loop, and somewhere in the
network one of the switches will block traffic to break the loop. But
if something in the network breaks, the port can be unblocked to allow
traffic to flow, redundancy. Well behaved switches should always
implement STP.

> How an Ethernet hub take care of this situation?

STP. Run tcpdump on your network. Depending on how your network is
configured, you might see BPDU from your building switches.

> Is that reasonable to connect two ports of an Ethernet hub together?

It is not just together. You cannot guarantee any Ethernet network is
a tree. You could connect the two ports to two different hubs, but
those hubs are connected together, and so you get a loop.

> > Looking at the TX descriptor, there are two bits:
> > 
> >           [18]: force forward to port 0
> >           [19]: force forward to port 1
> > 
> > When the switch is enabled, can these two bits be used?
> 
> Yes, for example, when bit 19 of TX descriptor is enabled, a packet from CPU 
> port is forwarded to LAN port 0 forcibly.
> 
> 
> > In the RX descriptor there is:
> > 
> > pkt_sp:
> >           000: from port0
> >           001: from port1
> >           110: soc0 loopback
> >           101: soc1 loopback
> > 
> > Are these bits used when the switch is enabled?
> 
> Yes, E- MAC driver uses these bits to tell where a packet comes from.
> Note that soc1 port (CPU port) has been removed in this chip.
 
Right. So you can have two netdev when in L2 switch mode.

You need to think about the Linux model some more. In linux,
networking hardware is there to accelerate what the Linux stack can do
in software. Take for example a simple SoC will have two Ethernet
interfaces. You can perform software bridging on those two interfaces:

ip link add name br0 type bridge
ip link set dev br0 up
ip link set dev eth0 master br0
ip link set dev eth1 master br0

The software bridge will decided which interface to send a packet
out. The software will perform learning etc.

You can use your dual MAC setup exactly like this. But you can also go
further. You can use the hardware to accelerate switching packets
between eth0 and eth1. But also Linux can still send packets out
specific ports using these bits. The software bridge and the hardware
bridge work together. This is the correct way to do this in Linux.

> Sorry, I don't know what is a RMC packet?

Sorry, i have no idea.

       Andrew
