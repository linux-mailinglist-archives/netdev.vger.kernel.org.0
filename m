Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428B8162796
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgBROBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:01:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgBROBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 09:01:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DSNbhoBkhWknUTfDd9IqyGPBpflOa3A+hx3OdsN/Pwg=; b=x3uk7rhZl6lRJuUgBGOqvlMgTu
        8HJPKOxVVeCxEvuNfNvKiSzrYIl4Lz4KvAA/O0Xgakz/L/k7eO1vm0JRN5m8V2Anb+Yre89uor0rn
        djmwjgERG4rBNP+9hvo12sKl0cSACamVXAWwanDMLgYh2uxolqpBP9HlxldTZhnaqk4g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j43R1-0002r6-9B; Tue, 18 Feb 2020 15:01:11 +0100
Date:   Tue, 18 Feb 2020 15:01:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
Message-ID: <20200218140111.GB10541@lunn.ch>
References: <20200217150058.5586-1-olteanv@gmail.com>
 <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 02:29:15PM +0200, Vladimir Oltean wrote:
> Hi Allan,
> 
> On Tue, 18 Feb 2020 at 13:32, Allan W. Nielsen
> <allan.nielsen@microchip.com> wrote:
> >
> > On 17.02.2020 17:00, Vladimir Oltean wrote:
> > >EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > >
> > >From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > >The Ocelot switches have what is, in my opinion, a design flaw: their
> > >DSA header is in front of the Ethernet header, which means that they
> > >subvert the DSA master's RX filter, which for all practical purposes,
> > >either needs to be in promiscuous mode, or the OCELOT_TAG_PREFIX_LONG
> > >needs to be used for extraction, which makes the switch add a fake DMAC
> > >of ff:ff:ff:ff:ff:ff so that the DSA master accepts the frame.
> > >
> > >The issue with this design, of course, is that the CPU will be spammed
> > >with frames that it doesn't want to respond to, and there isn't any
> > >hardware offload in place by default to drop them.
> > In the case of Ocelot, the NPI port is expected to be connected back to
> > back to the CPU, meaning that it should not matter what DMAC is set.
> >
> 
> You are omitting the fact that the host Ethernet port has an RX filter
> as well. By default it should drop frames that aren't broadcast or
> aren't sent to a destination MAC equal to its configured MAC address.
> Most DSA switches add their tag _after_ the Ethernet header. This
> makes the DMAC and SMAC seen by the front-panel port of the switch be
> the same as the DMAC and SMAC seen by the host port. Combined with the
> fact that DSA sets up switch port MAC addresses to be inherited from
> the host port, RX filtering 'just works'.

It is a little bit more complex than that, but basically yes. If the
slave interface is in promisc mode, the master interface is also made
promisc. So as soon as you add a slave to a bridge, the master it set
promisc. Also, if the slave has a different MAC address to the master,
the MAC address is added to the masters RX filter.

If the DSA header is before the DMAC, you need promisc mode all the
time. But i don't expect the CPU port to be spammed. The switch should
only be forwarding frames to the CPU which the CPU is actually
interested in.

> Be there 4 net devices: swp0, swp1, swp2, swp3.
> At probe time, the following doesn't work on the Felix DSA driver:
> ip addr add 192.168.1.1/24 dev swp0
> ping 192.168.1.2

That is expected to work.

> But if I do this:
> ip link add dev br0 type bridge
> ip link set dev swp0 master br0
> ip link set dev swp0 nomaster
> ping 192.168.1.2
> Then it works, because the code path from ocelot_bridge_stp_state_set
> that puts the CPU port in the forwarding mask of the other ports gets
> executed on the "bridge leave" action.

It probably also works because when the port is added to the bridge,
the bridge puts the port into promisc mode. That in term causes the
master to be put into promisc mode.

       Andrew
