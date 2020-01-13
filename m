Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D79139212
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgAMNWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:22:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAMNWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 08:22:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rROUgpk70UyhCg1/3QrNJgxC2bST7qcuShWBQfIfwek=; b=xkelwf47AvI1dTnksyNnIApRx/
        YeGrbD1Hd3eLSZL/v0OOKNI+UDtRdHpHhVPGgoLxBFl+lmS1taMYY2mR1HJ6AFTXA6P2T68w1BSxo
        khiIbd3b8GyhTI9+Gs7pU+JOx2laVivbd3HmYrecApZ47gw4FW0xlycWESQzYkTNoE+s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iqzfE-0003mp-M7; Mon, 13 Jan 2020 14:21:52 +0100
Date:   Mon, 13 Jan 2020 14:21:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, cphealy@gmail.com,
        rmk+kernel@armlinux.org.uk, kuba@kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: Maintain MDIO device and bus
 statistics
Message-ID: <20200113132152.GB11788@lunn.ch>
References: <20200113045325.13470-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113045325.13470-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 12, 2020 at 08:53:19PM -0800, Florian Fainelli wrote:
> Maintain per MDIO device and MDIO bus statistics comprised of the number
> of transfers/operations, reads and writes and errors. This is useful for
> tracking the per-device and global MDIO bus bandwidth and doing
> optimizations as necessary.

Hi Florian

One point for discussion is, is sysfs the right way to do this?
Should we be using ethtool and exporting the statistics like other
statistics?

The argument against it, is we have devices which are not related to a
network interfaces on MDIO busses. For a PHY we could plumb the per
PHY mdio device statistics into the exiting PHY statistics. But we
also have Ethernet switches on MDIO devices, which don't have an
association to a netdev interface. Broadcom also have some generic PHY
device on MDIO busses, for USB, SATA, etc. And whole bus statistics
don't fit the netdev model at all.

So sysfs does make sense. But i would also suggest we do plumb per PHY
MDIO device statistics into the exiting ethtool call.

> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-mdio |  34 +++++++
>  drivers/net/phy/mdio_bus.c               | 116 +++++++++++++++++++++++
>  drivers/net/phy/mdio_device.c            |   1 +
>  include/linux/mdio.h                     |  10 ++
>  include/linux/phy.h                      |   2 +
>  5 files changed, 163 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-mdio
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-mdio b/Documentation/ABI/testing/sysfs-bus-mdio
> new file mode 100644
> index 000000000000..a552d92890f1
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-mdio
> @@ -0,0 +1,34 @@
> +What:          /sys/bus/mdio_bus/devices/.../statistics/
> +Date:          January 2020
> +KernelVersion: 5.6
> +Contact:       netdev@vger.kernel.org
> +Description:
> +		This folder contains statistics about MDIO bus transactions.
> +
> +What:          /sys/bus/mdio_bus/devices/.../statistics/transfers
> +Date:          January 2020
> +KernelVersion: 5.6
> +Contact:       netdev@vger.kernel.org
> +Description:
> +		Total number of transfers for this MDIO bus.
> +
> +What:          /sys/bus/mdio_bus/devices/.../statistics/errors
> +Date:          January 2020
> +KernelVersion: 5.6
> +Contact:       netdev@vger.kernel.org
> +Description:
> +		Total number of transfer errors for this MDIO bus.
> +
> +What:          /sys/bus/mdio_bus/devices/.../statistics/writes
> +Date:          January 2020
> +KernelVersion: 5.6
> +Contact:       netdev@vger.kernel.org
> +Description:
> +		Total number of write transactions for this MDIO bus.
> +
> +What:          /sys/bus/mdio_bus/devices/.../statistics/reads
> +Date:          January 2020
> +KernelVersion: 5.6
> +Contact:       netdev@vger.kernel.org
> +Description:
> +		Total number of read transactions for this MDIO bus.

Looking at this description, it is not clear we have whole bus and per
device statistics. 

>  int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
>  {
> +	struct mdio_device *mdiodev = bus->mdio_map[addr];
>  	int retval;
>  
>  	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
> @@ -555,6 +645,9 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
>  	retval = bus->read(bus, addr, regnum);
>  
>  	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
> +	mdiobus_stats_acct(&bus->stats, true, retval);
> +	if (mdiodev)
> +		mdiobus_stats_acct(&mdiodev->stats, true, retval);
>  
>  	return retval;

I think for most Ethernet switches, these per device counters are
going to be misleading. The switch often takes up multiple addresses
on the bus, but the switch is represented as a single mdiodev with one
address. So the counters will reflect the transfers on that one
address, not the whole switch. The device tree binding does not have
enough information for us to associated one mdiodev to multiple
addresses. And for some of the Marvell switches, it is a sparse address
map, and i have seen PHY devices in the holes. So in the sysfs
documentation, we should probably add a warning that when used with an
Ethernet switch, the counters are unlikely to be accurate, and should
be interpreted with care.

   Andrew
