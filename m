Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFD6299425
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 18:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788180AbgJZRn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 13:43:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:3083 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780088AbgJZRn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 13:43:27 -0400
IronPort-SDR: BH0JLl4Eybc6RQvKozOCQy3lru34M13fSERwetbsZFYDR/xD2kbVLZ8h9VTWRwEnzPjXW1WDSu
 cQR3t9Cna3Iw==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="232151954"
X-IronPort-AV: E=Sophos;i="5.77,420,1596524400"; 
   d="scan'208";a="232151954"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 10:43:25 -0700
IronPort-SDR: 4LTs4ScgMzg0//s/wchZ00jXeSobBAgjXPztZ6tS+jflLlKcGT/VWDJBmAHQDr3PZ9ZRCEPFLc
 XjTAA+9yY44Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,420,1596524400"; 
   d="scan'208";a="468000088"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by orsmga004.jf.intel.com with ESMTP; 26 Oct 2020 10:43:21 -0700
Date:   Tue, 27 Oct 2020 01:38:04 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com,
        yilun.xu@intel.com
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL Ether
  Group driver
Message-ID: <20201026173803.GA10743@yilunxu-OptiPlex-7050>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
 <20201023153731.GC718124@lunn.ch>
 <20201026085246.GC25281@yilunxu-OptiPlex-7050>
 <20201026130001.GC836546@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026130001.GC836546@lunn.ch>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 02:00:01PM +0100, Andrew Lunn wrote:
> > > > +The Intel(R) PAC N3000 is a FPGA based SmartNIC platform for multi-workload
> > > > +networking application acceleration. A simple diagram below to for the board:
> > > > +
> > > > +                     +----------------------------------------+
> > > > +                     |                  FPGA                  |
> > > > ++----+   +-------+   +-----------+  +----------+  +-----------+   +----------+
> > > > +|QSFP|---|retimer|---|Line Side  |--|User logic|--|Host Side  |---|XL710     |
> > > > ++----+   +-------+   |Ether Group|  |          |  |Ether Group|   |Ethernet  |
> > > > +                     |(PHY + MAC)|  |wiring &  |  |(MAC + PHY)|   |Controller|
> > > > +                     +-----------+  |offloading|  +-----------+   +----------+
> > > > +                     |              +----------+              |
> > > > +                     |                                        |
> > > > +                     +----------------------------------------+
> > > 
> > > Is XL710 required? I assume any MAC with the correct MII interface
> > > will work?
> > 
> > The XL710 is required for this implementation, in which we have the Host
> > Side Ether Group facing the host.  The Host Side Ether Group actually
> > contains the same IP blocks as Line Side. It contains the compacted MAC &
> > PHY functionalities for 25G/40G case. The 25G MAC-PHY soft IP SPEC can
> > be found at:
> > 
> > https://www.intel.com/content/www/us/en/programmable/documentation/ewo1447742896786.html
> > 
> > So raw serial data is output from Host Side FPGA, and XL710 is good to
> > handle this.
> 
> What i have seen working with Marvell Ethernet switches, is that
> Marvell normally recommends connecting them to the Ethernet interfaces
> of Marvell SoCs. But the switch just needs a compatible MII interface,
> and lots of boards make use of non-Marvell MAC chips. Freescale FEC is
> very popular.
> 
> What i'm trying to say is that ideally we need a collection of generic
> drivers for the different major components on the board, and a board
> driver which glues it all together. That then allows somebody to build
> other boards, or integrate the FPGA directly into an embedded system
> directly connected to a SoC, etc.
> 
> > > Do you really mean PHY? I actually expect it is PCS? 
> > 
> > For this implementation, yes.
> 
> Yes, you have a PHY? Or Yes, it is PCS?

Sorry, I mean I have a PHY.

> 
> To me, the phylib maintainer, having a PHY means you have a base-T
> interface, 25Gbase-T, 40Gbase-T?  That would be an odd and expensive
> architecture when you should be able to just connect SERDES interfaces
> together.

I see your concerns about the SERDES interface between FPGA & XL710.

Considering the DSA, we just enable the cpu facing ports, seems the
SERDES interface connection doesn't impact the software. It's just too
expensive.

> 
> > > > +The DFL Ether Group driver registers netdev for each line side link. Users
> > > > +could use standard commands (ethtool, ip, ifconfig) for configuration and
> > > > +link state/statistics reading. For host side links, they are always connected
> > > > +to the host ethernet controller, so they should always have same features as
> > > > +the host ethernet controller. There is no need to register netdevs for them.
> > > 
> > > So lets say the XL710 is eth0. The line side netif is eth1. Where do i
> > > put the IP address? What interface do i add to quagga OSPF? 
> > 
> > The IP address should be put in eth0. eth0 should always be used for the
> > tools.
> 
> That was what i was afraid of :-)
> 
> > 
> > The line/host side Ether Group is not the terminal of the network data stream.
> > Eth1 will not paticipate in the network data exchange to host.
> > 
> > The main purposes for eth1 are:
> > 1. For users to monitor the network statistics on Line Side, and by comparing the
> > statistics between eth0 & eth1, users could get some knowledge of how the User
> > logic is taking function.
> > 
> > 2. Get the link state of the front panel. The XL710 is now connected to
> > Host Side of the FPGA and the its link state would be always on. So to
> > check the link state of the front panel, we need to query eth1.
> 
> This is very non-intuitive. We try to avoid this in the kernel and the
> API to userspace. Ethernet switches are always modelled as
> accelerators for what the Linux network stack can already do. You
> configure an Ethernet switch port in just the same way configure any
> other netdev. You add an IP address to the switch port, you get the
> Ethernet statistics from the switch port, routing protocols use the
> switch port.
> 
> You design needs to be the same. All configuration needs to happen via
> eth1.
> 
> Please look at the DSA architecture. What you have here is very
> similar to a two port DSA switch. In DSA terminology, we would call
> eth0 the master interface.  It needs to be up, but otherwise the user
> does not configure it. eth1 is the slave interface. It is the user
> facing interface of the switch. All configuration happens on this
> interface. Linux can also send/receive packets on this netdev. The
> slave TX function forwards the frame to the master interface netdev,
> via a DSA tagger. Frames which eth0 receive are passed through the
> tagger and then passed to the slave interface.
> 
> All the infrastructure you need is already in place. Please use
> it. I'm not saying you need to write a DSA driver, but you should make
> use of the same ideas and low level hooks in the network stack which
> DSA uses.

I did some investigation about the DSA, and actually I wrote a
experimental DSA driver. It works and almost meets my need, I can make
configuration, run pktgen on slave inf.

A main concern for dsa is the wiring from slave inf to master inf depends
on the user logic. If FPGA users want to make their own user logic, they
may need a new driver. But our original design for the FPGA is, kernel
drivers support the fundamental parts - FPGA FIU (where Ether Group is in)
& other peripherals on board, and userspace direct I/O access for User
logic. Then FPGA user don't have to write & compile a driver for their
user logic change.
It seems not that case for netdev. The user logic is a part of the whole
functionality of the netdev, we cannot split part of the hardware
component to userspace and the rest in kernel. I really need to
reconsider this.

> 
> > > What about the QSPF socket? Can the host get access to the I2C bus?
> > > The pins for TX enable, etc. ethtool -m?
> > 
> > No, the QSPF/I2C are also managed by the BMC firmware, and host doesn't
> > have interface to talk to BMC firmware about QSPF.
> 
> So can i even tell what SFP is in the socket? 

No.

> 
> > > > +Speed/Duplex
> > > > +------------
> > > > +The Ether Group doesn't support auto-negotiation. The link speed is fixed to
> > > > +10G, 25G or 40G full duplex according to which Ether Group IP is programmed.
> > > 
> > > So that means, if i pop out the SFP and put in a different one which
> > > supports a different speed, it is expected to be broken until the FPGA
> > > is reloaded?
> > 
> > It is expected to be broken.
> 
> And since i have no access to the SFP information, i have no idea what
> is actually broken? How i should configure the various layers?

With this hardware implementation, I'm afraid host can not know what is broken.
It can just see the Speed of the slave inf is never changed, and the link state
is "No" on slave inf. Is it like the fixed phy or fixed link mode?

Is it possible just see it as fixed and configure the layers?

> 
> > Now the line side is expected to be configured to 4x10G, 4x25G, 2x25G, 1x25G.
> > host side is expected to be 4x10G or 2x40G for XL710.
> > 
> > So 4 channel SFP is expected to be inserted to front panel. And we should use
> > 4x25G SFP, which is compatible to 4x10G connection.
> 
> So if you had exported the SFP to linux, phylink could of handled some
> of this for you. Probably with some extensions to phylink, but Russell
> King would of probably helped you. phylink has a good idea how to
> decode the SFP EEPROM and figure out the link mode. It has interfaces
> to configure PCS blocks, So it could probably deal with the line side
> and host side PCS. And it would of been easy to send a udev
> notification that the SFP has changed, maybe user space needs to
> download a different FPGA bit file? So the user would not see a broken
> interface, the hardware could be reconfigured on the fly.
> 
> This is one problem i have with this driver. It is based around this
> somewhat broken reference design. phylib, along with the hacks you
> have, are enough for this reference design. But really you want to
> make use of phylink in order to support less limited designs which
> will follow. Or you need to push a lot more into the BMC, and don't
> use phylib at all.

Mm.. seems the hardware should be changed, either let host directly
access the QSFP, or re-design the BMC to provide more info for QSFP.

Is it possible we didn't change the hardware, and we support the
components (QSFP, retimer) by fixed-link mode. I know this makes the
driver specific to the board, but the boards are being used by
customers and I'm trying to make them supported without hardware
changes...


Thanks for your very detailed explaination and guide.
Yilun

> 
>     Andrew
