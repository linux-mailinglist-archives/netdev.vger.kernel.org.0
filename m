Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3034A916D
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiBDAEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:04:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41882 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbiBDAEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 19:04:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1/X6M2RlKfhoxDI2wekvr9q+UaNHy+WB1KZulPhgmFk=; b=P53s8KveQe4m0t0uvtKCmzQv8o
        l8d8gTo4zBbee2xUqPaU1nI7rsSFrAWPa7QZoyAoBK7NGyL+Siwbhb4OpZRXGD8yGwALKtjlUKetj
        7T0xNLcqxggRQfju3DitCJABm8Vaegssy4pzGCMww25YWpoP/UQWhSr0rd3+65newjVc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFm5K-004CgG-IL; Fri, 04 Feb 2022 01:04:18 +0100
Date:   Fri, 4 Feb 2022 01:04:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led
 functions
Message-ID: <YfxtglvVDx2JJM9w@lunn.ch>
References: <20210421055047.22858-1-ms@dev.tdt.de>
 <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch>
 <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
 <YfwEvgerYddIUp1V@lunn.ch>
 <CAJ+vNU1qY1VJgw1QRsbmED6-TLQP2wwxSYb+bXfqZ3wiObLgHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU1qY1VJgw1QRsbmED6-TLQP2wwxSYb+bXfqZ3wiObLgHg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew,
> 
> The issue is that in an ideal world where all parts adhere to the
> JEDEC standards 2ns would be correct but that is not reality. In my
> experience with the small embedded boards I help design and support
> not about trace lengths as it would take inches to skew 0.5ns but
> instead differences in setup/hold values for various MAC/PHY parts
> that are likely not adhering the standards.
> 
> Some examples from current boards I support:
> - CN8030 MAC rgmii-rxid with intel-xway GPY111 PHY: we need to
> configure this for rx_delay=1.5ns and tx_delay=0.5ns

So i assume this is what broke for you. Your bootloader sets these
delays, phy-type is rgmii-id, and since you don't have the properties
for what exact delays you want it default to what 802.3 specifies,
2ns.

I actually think the current behaviour of the driver is correct.  By
saying phy-type = rgmii-id you are telling the PHY driver to insert
the delays and that is what it is doing.

In retrospect, i would say you had two choices to cleanly solve this.

1) Do exactly what the patch does, add properties to define what
actual delay you want, when you don't want 2ns.

2) Have the bootloader set the delay, but also tell Linux you have set
the phy mode including the delays, and it should not touch them. There
is a well defined way to do this:

PHY_INTERFACE_MODE_NA

It has two main use cases. The first is that the MAC and PHY are
integrated, there is no MII between them, phy-mode is completely
unnecessary. This is the primary meaning.

The second meaning is, something else has setup the phy mode, e.g. the
bootloader. Don't touch it.

This second meaning does not always work, since the driver might reset
the PHY, and depending on the PHY, that might clear whatever the
bootloader set. So it is not reliable.

> - CN8030 MAC rgmii-rxid with dp83867 GPY111 PHY: we need to configure
> this for rx_delay=2.0ns and tx_delay=2.0ns (as would be expected)
> - IMX8MM FEC MAC rgmii-id with intel-xway PHY: we need to configure
> this for rx_delay=2ns and tx_delay=2.5ns
> - IMX8MM FEC MAC rgmii-id with dp83867 PHY: we need to configure this
> for rx_delay=2.0ns and tx_delay=2.0ns (as would be expected)
> 
> The two boards above have identical well matched trace-lengths between
> the two PHY variant designs so you can see here that the intel-xway
> GPY111 PHY needs an extra 0.5ps delay to avoid RX errors on the
> far-off board.

So a couple of ideas.

Since GPY111 and dp83867 use different properties for the delays, just
put both in DT. The PHY driver will look for the property it
understands and ignore the other. So you can have different delays for
different PHYs.

We have started to standardize on the delay property. And new driver
should be using rx-internal-delay-ps and tx-internal-delay-ps. If you
have two drivers using the same property name, what i just suggested
will not work. Can you control the address the PHY uses? Put the
GPY111 on a different address to the dp83867. List them both in DT. If
you don't have a phy-handle in DT, the FEC will go hunting on its MDIO
bus and use the first PHY it finds. You can put the needed delay
properties in DT for the specific PHY.

	Andrew

