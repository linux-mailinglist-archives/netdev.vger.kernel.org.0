Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FCF297278
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465947AbgJWPho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:37:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S462875AbgJWPhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 11:37:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVz8F-0039CC-Gm; Fri, 23 Oct 2020 17:37:31 +0200
Date:   Fri, 23 Oct 2020 17:37:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL Ether
 Group driver
Message-ID: <20201023153731.GC718124@lunn.ch>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xu

Before i look at the other patches, i want to understand the
architecture properly.

> +=======================================================================
> +DFL device driver for Ether Group private feature on Intel(R) PAC N3000
> +=======================================================================
> +
> +This is the driver for Ether Group private feature on Intel(R)
> +PAC (Programmable Acceleration Card) N3000.

I assume this is just one implementation. The FPGA could be placed on
other boards. So some of the limitations you talk about with the BMC
artificial, and the overall architecture of the drivers is more
generic?

> +The Intel(R) PAC N3000 is a FPGA based SmartNIC platform for multi-workload
> +networking application acceleration. A simple diagram below to for the board:
> +
> +                     +----------------------------------------+
> +                     |                  FPGA                  |
> ++----+   +-------+   +-----------+  +----------+  +-----------+   +----------+
> +|QSFP|---|retimer|---|Line Side  |--|User logic|--|Host Side  |---|XL710     |
> ++----+   +-------+   |Ether Group|  |          |  |Ether Group|   |Ethernet  |
> +                     |(PHY + MAC)|  |wiring &  |  |(MAC + PHY)|   |Controller|
> +                     +-----------+  |offloading|  +-----------+   +----------+
> +                     |              +----------+              |
> +                     |                                        |
> +                     +----------------------------------------+

Is XL710 required? I assume any MAC with the correct MII interface
will work?

Do you really mean PHY? I actually expect it is PCS? 

> +The DFL Ether Group driver registers netdev for each line side link. Users
> +could use standard commands (ethtool, ip, ifconfig) for configuration and
> +link state/statistics reading. For host side links, they are always connected
> +to the host ethernet controller, so they should always have same features as
> +the host ethernet controller. There is no need to register netdevs for them.

So lets say the XL710 is eth0. The line side netif is eth1. Where do i
put the IP address? What interface do i add to quagga OSPF? 

> +The driver just enables these links on probe.
> +
> +The retimer chips are managed by onboard BMC (Board Management Controller)
> +firmware, host driver is not capable to access them directly.

What about the QSPF socket? Can the host get access to the I2C bus?
The pins for TX enable, etc. ethtool -m?

> +Speed/Duplex
> +------------
> +The Ether Group doesn't support auto-negotiation. The link speed is fixed to
> +10G, 25G or 40G full duplex according to which Ether Group IP is programmed.

So that means, if i pop out the SFP and put in a different one which
supports a different speed, it is expected to be broken until the FPGA
is reloaded?

     Andrew
