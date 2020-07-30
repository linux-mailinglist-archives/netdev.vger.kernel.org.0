Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBFE23325F
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgG3Mrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 08:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgG3Mri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 08:47:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F29DC061794
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 05:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HgjoJyjU6aa0gxDSEC6N/hI6lcodfLiwKw1BQAiEnI4=; b=HfaY6evfipBREsATGzSMjgXEW
        8TiAy6phSweInoyftUfo+Pm7Rq+4mJlH/12Vb8M6WrS51Iivmy57yH6xLhFk4IAox6JUYUNhDUJTF
        31VfyleLFwL6DbOkpV8s32HjySEsEYB2oU+eF/iqK1IeYW4eo0HKm5bMw3bQPmW06CYfRQPaXrG/R
        ouu1O/nfqQFugM/D51HIHv03W9EXu6qgnY77RgGLKawanwL7NEaCWeR7El6uq27L6hC/zCBH+QKI2
        4HrRc8LpF+RA1OXjRQI9ZC8txQcKlBRqQrW43pXE0aXr5WUGem0rvpnjDRaPB2K7f8Bm4tmcfJUY0
        ye8km04RQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46102)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k17y8-0006Q1-V9; Thu, 30 Jul 2020 13:47:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k17y6-0006lg-At; Thu, 30 Jul 2020 13:47:30 +0100
Date:   Thu, 30 Jul 2020 13:47:30 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20200730124730.GY1605@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200730110613.GC1551@shell.armlinux.org.uk>
 <20200730115419.GX1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730115419.GX1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 12:54:19PM +0100, Russell King - ARM Linux admin wrote:
> On Thu, Jul 30, 2020 at 12:06:13PM +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Jul 29, 2020 at 06:19:32AM -0700, Richard Cochran wrote:
> > > On Wed, Jul 29, 2020 at 11:58:07AM +0100, Russell King - ARM Linux admin wrote:
> > > > How do we deal with this situation - from what I can see from the
> > > > ethtool API, we have to make a choice about which to use.  How do we
> > > > make that choice?
> > > 
> > > Unfortunately the stack does not implement simultaneous MAC + PHY time
> > > stamping.  If your board has both, then you make the choice to use the
> > > PHY by selecting NETWORK_PHY_TIMESTAMPING at kernel compile time.
> > > 
> > > (Also some MAC drivers do not defer to the PHY properly.  Sometimes
> > > you can work around that by de-selecting the MAC's PTP function in the
> > > Kconfig if possible, but otherwise you need to patch the MAC driver.)
> > >  
> > > > Do we need a property to indicate whether we wish to use the PHY
> > > > or MAC PTP stamping, or something more elaborate?
> > > 
> > > To do this at run time would require quite some work, I expect.
> > 
> > Okay, I'm falling into horrible multicast issues with DSA switches
> > while trying to test.
> > 
> > Some of my platforms have IP_MULTICAST=y, others have IP_MULTICAST=n.
> > This causes some to send IGMP messages when binding to the multicast
> > address, others do not.
> > 
> > Those that do cause the DSA switch to add a static database entry
> > causing all traffic for that multicast address to be only directed to
> > the port(s) that the machine(s) with IP_MULTICAST=y kernels are
> > connected to, depriving all IP_MULTICAST=n machines from seeing those
> > packets.
> > 
> > Maybe, with modern networking technology, it's about time that the
> > kernel configuration help recommended that kernels should be built
> > with IP_MULTICAST=y ?
> 
> Hmm, and even with IP_MULTICAST=y, I still can't get the "timestamping"
> program from the kernel sources to work.
> 
> On two different machines, I'm running:
> 
> # ./timestamping32 eno0 SOF_TIMESTAMPING_RX_HARDWARE SOF_TIMESTAMPING_RAW_HARDWARE
> 
> On one machine (arm32) this works - it can see the traffic it generates
> and receives from the other machine.
> 
> On the other machine (arm64), it sees _no_ traffic at all, but tcpdump
> on that machine can see the traffic being received:
> 
> 12:36:40.002065 00:51:82:11:33:03 > 01:00:5e:00:01:82, ethertype IPv4 (0x0800),
> length 166: (tos 0x0, ttl 1, id 15045, offset 0, flags [DF], proto UDP (17), length 152)
>     192.168.3.1.319 > 224.0.1.130.319: [bad udp cksum 0xa5c1 -> 0x7aaa!] UDP, length 124
> 12:36:41.105391 00:50:43:02:03:02 > 01:00:5e:00:01:82, ethertype IPv4 (0x0800),
> length 166: (tos 0x0, ttl 1, id 9715, offset 0, flags [DF], proto UDP (17), length 152)
>     192.168.3.2.319 > 224.0.1.130.319: [udp sum ok] UDP, length 124
> 
> The bad udp cksum is due to checksum offloadong on transmit - 3.1 is the
> arm64 host running that tcpdump.
> 
> When I look at /proc/net/snmp, I can see the IP InReceives incrementing
> but not the IP InDelivers nor UDP InDatagrams counter:
> 
> Ip: 2 64 1602 0 3 0 0 0 297 531 0 46 0 0 0 0 0 0 0
> Udp: 572 0 0 480 0 0 0 4
> Ip: 2 64 1603 0 3 0 0 0 297 531 0 46 0 0 0 0 0 0 0
> Udp: 572 0 0 480 0 0 0 4
> 
> I don't have any firewall rules on the machine.
> 
> I've checked rp_filter on the appropriate interfaces... it's disabled
> on the ARM64 machine.  The only other difference in interface config
> is accept_source_route, which is enabled on the ARM64 machine.
> 
> So, something in the IPv4 layer on ARM64 is silently discarding
> multicast UDP PTP packets, and I've no idea what... and I'm coming to
> the conclusion that this is all way too much effort and way too
> unreliable to be worth spending any more time trying to make work.
> 
> I'll send out what I have in the hope that maybe someone will find it
> useful and maybe able to complete the work.  However, with these
> problems, it is totally unusable for me, and hence I can't test it.

To prove the point...

Two arm32 machines connected back to back through eno2, both running
the basic test:
# ./timestamping eno2

see each other.

Try that same test between arm32 and arm64 connected in a similar
manner, and the arm32 machine can see the UDP packets from the arm64
machine, but the arm64 machine discards the UDP packets from the arm32
machine in the IP layer running the exact same commands.

Both kernels and timestamping programs built from the same sources.

So, to summarise where I am:

- TAI (PHC) support:
  * Works on Marvell 88E1512 PHY, with one event capture.
  * Works on mvneta on Armada 388, no event capture implemented.
  * Works on mvpp2.2 on Armada 8040.  Event capture is possible, but
    interferes with the operation of the driver; no way to mask the
    external event trigger interference. Generating a "trigger" which
    can be set to a defined time and pulse with uses the same pin, and
    is also always seen as an external event, interfering with the
    operation of the hardware. There are two "clock" generation
    capabilities which one of which is described as "PPS", but these
    can't be aligned to a second boundary.

- PTP transmit timestamping:
  * Works on Marvell 88E1512 PHY.
  * Unimplemented on mvneta on Armada 388 - I am unable to get the PTP
    port registers to respond, and the documentation gives no hints;
    the PTP global registers and TAI registers respond however. No
    errata hint at this being a problem.
  * Unimplemented on mvpp2.2 on Armada 8040 - I haven't got far enough
    to implement this.

- PTP receive timestamping:
  * I think this works on Marvell 88E1512 PHY, but I'm now not sure.
  * Implemented on mvpp2.2 on Armada 8040 - but unable to test (see
    above issues with the IP layer discarding what seem to be totally
    correct packets on ARM64.)
  * Unimplemented on mvneta on Armada 388 - see above (PTP tx).

- DSA switches can effectively block multicast packets if only some
  kernels on the network have IP_MULTICAST=y and others have
  IP_MULTICAST=n, which adds a level of complexity and unreliability.
  (The answer is likely to always have IP_MULTICAST=y, and maybe the
  kernel should default to that - or in this day and age, the option
  ought to be removed.)

Hence why I'm at the point of giving up; I don't see that PTP will be
of very limited benefit on my network with all these issues, and in
any case, NTP has been "good enough" for the last 20+ years.  Given
that only a limited number of machines will be able to implement PTP
support anyway, NTP will have to run along side it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
