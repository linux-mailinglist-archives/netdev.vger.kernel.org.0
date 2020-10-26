Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C51A2988E1
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772370AbgJZI6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:58:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:36628 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1770820AbgJZI6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 04:58:09 -0400
IronPort-SDR: CE+i1vRpv5G5BS4PWLq4YZZkPmB3tX0+/ahsG50rPTS0lvtldQKyws6wN5WQPAShvPAp45JfOA
 P8RBSn7LlxTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="165302367"
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="165302367"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 01:58:07 -0700
IronPort-SDR: W5gqznAoEYdXPhT1hfswbhbOJWaWO0JSF5mkzVqtcjuivJadlDvifzxH9rZ5BQ+aWfD0ul+flM
 +d0d7L7clkcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="360925113"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by orsmga007.jf.intel.com with ESMTP; 26 Oct 2020 01:58:04 -0700
Date:   Mon, 26 Oct 2020 16:52:47 +0800
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
Message-ID: <20201026085246.GC25281@yilunxu-OptiPlex-7050>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
 <20201023153731.GC718124@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023153731.GC718124@lunn.ch>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

Thanks for your fast response, see comments inline.

On Fri, Oct 23, 2020 at 05:37:31PM +0200, Andrew Lunn wrote:
> Hi Xu
> 
> Before i look at the other patches, i want to understand the
> architecture properly.

I have a doc to describe the architecture:

https://www.intel.com/content/www/us/en/programmable/documentation/xgz1560360700260.html

The "Figure 1" is a more detailed figure for the arch. It should be
helpful.

> 
> > +=======================================================================
> > +DFL device driver for Ether Group private feature on Intel(R) PAC N3000
> > +=======================================================================
> > +
> > +This is the driver for Ether Group private feature on Intel(R)
> > +PAC (Programmable Acceleration Card) N3000.
> 
> I assume this is just one implementation. The FPGA could be placed on
> other boards. So some of the limitations you talk about with the BMC
> artificial, and the overall architecture of the drivers is more
> generic?

I could see if the retimer management is changed, e.g. access the retimer
through a host controlled MDIO, maybe I need a more generic way to find the
MDIO bus.

Do you have other suggestions?

> 
> > +The Intel(R) PAC N3000 is a FPGA based SmartNIC platform for multi-workload
> > +networking application acceleration. A simple diagram below to for the board:
> > +
> > +                     +----------------------------------------+
> > +                     |                  FPGA                  |
> > ++----+   +-------+   +-----------+  +----------+  +-----------+   +----------+
> > +|QSFP|---|retimer|---|Line Side  |--|User logic|--|Host Side  |---|XL710     |
> > ++----+   +-------+   |Ether Group|  |          |  |Ether Group|   |Ethernet  |
> > +                     |(PHY + MAC)|  |wiring &  |  |(MAC + PHY)|   |Controller|
> > +                     +-----------+  |offloading|  +-----------+   +----------+
> > +                     |              +----------+              |
> > +                     |                                        |
> > +                     +----------------------------------------+
> 
> Is XL710 required? I assume any MAC with the correct MII interface
> will work?

The XL710 is required for this implementation, in which we have the Host
Side Ether Group facing the host.  The Host Side Ether Group actually
contains the same IP blocks as Line Side. It contains the compacted MAC &
PHY functionalities for 25G/40G case. The 25G MAC-PHY soft IP SPEC can
be found at:

https://www.intel.com/content/www/us/en/programmable/documentation/ewo1447742896786.html

So raw serial data is output from Host Side FPGA, and XL710 is good to
handle this.

> 
> Do you really mean PHY? I actually expect it is PCS? 

For this implementation, yes.

I guess if you program another IP block on FPGA host side, e.g. a PCS interface,
and replace XL710 with another MAC, it may also work. But I think there should
be other drivers to handle this.

I may contact with our Hardware designer if there is some concern we
don't use MII for connection of FPGA & Host.

The FPGA User is mainly concerned about the user logic part. The Ether
Groups in FIU and Board components are not expected to be re-designed by
the user. So I think I should still focus on the driver for this
implementation.

> 
> > +The DFL Ether Group driver registers netdev for each line side link. Users
> > +could use standard commands (ethtool, ip, ifconfig) for configuration and
> > +link state/statistics reading. For host side links, they are always connected
> > +to the host ethernet controller, so they should always have same features as
> > +the host ethernet controller. There is no need to register netdevs for them.
> 
> So lets say the XL710 is eth0. The line side netif is eth1. Where do i
> put the IP address? What interface do i add to quagga OSPF? 

The IP address should be put in eth0. eth0 should always be used for the
tools.

The line/host side Ether Group is not the terminal of the network data stream.
Eth1 will not paticipate in the network data exchange to host.

The main purposes for eth1 are:
1. For users to monitor the network statistics on Line Side, and by comparing the
statistics between eth0 & eth1, users could get some knowledge of how the User
logic is taking function.

2. Get the link state of the front panel. The XL710 is now connected to
Host Side of the FPGA and the its link state would be always on. So to
check the link state of the front panel, we need to query eth1.

> 
> > +The driver just enables these links on probe.
> > +
> > +The retimer chips are managed by onboard BMC (Board Management Controller)
> > +firmware, host driver is not capable to access them directly.
> 
> What about the QSPF socket? Can the host get access to the I2C bus?
> The pins for TX enable, etc. ethtool -m?

No, the QSPF/I2C are also managed by the BMC firmware, and host doesn't
have interface to talk to BMC firmware about QSPF.

> 
> > +Speed/Duplex
> > +------------
> > +The Ether Group doesn't support auto-negotiation. The link speed is fixed to
> > +10G, 25G or 40G full duplex according to which Ether Group IP is programmed.
> 
> So that means, if i pop out the SFP and put in a different one which
> supports a different speed, it is expected to be broken until the FPGA
> is reloaded?

It is expected to be broken.

Now the line side is expected to be configured to 4x10G, 4x25G, 2x25G, 1x25G.
host side is expected to be 4x10G or 2x40G for XL710.

So 4 channel SFP is expected to be inserted to front panel. And we should use
4x25G SFP, which is compatible to 4x10G connection.

Thanks,
Yilun

> 
>      Andrew
