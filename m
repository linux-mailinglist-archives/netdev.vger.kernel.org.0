Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315CA318CD7
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhBKOAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:00:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhBKN6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 08:58:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lACT7-005aPt-7q; Thu, 11 Feb 2021 14:57:17 +0100
Date:   Thu, 11 Feb 2021 14:57:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
Message-ID: <YCU3vaZ51XpksIpc@lunn.ch>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
 <YCRjmpKjK0pxKTCP@lunn.ch>
 <CAGETcx-tBw_=VPvQVYcpPJBJjgQvp8UASrdMdSbSduahZpJf9w@mail.gmail.com>
 <4f0086ad-1258-063d-0ace-fe4c6c114991@gmail.com>
 <CAGETcx_9bmeLzOvDp8eCGdWtfwZNajCBCNSbyx7a_0T=FcSvwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_9bmeLzOvDp8eCGdWtfwZNajCBCNSbyx7a_0T=FcSvwA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yeah, I plan to fix this. So I have a few more questions. In the
> example I gave, what should happen if the gpios listed in the phy's DT
> node aren't ready yet?

There are four different use cases for GPIO.

1) The GPIO is used to reset all devices on the MDIO bus. When the bus
is registered with the core, the core will try to get this GPIO. If we
get EPROBE_DEFER, the registration of the bus is deferred and tried
again later. If the MAC driver tries to get the PHY device before the
MDIO bus is enumerated, it should also get EPROBE_DEFER, and in the
end everything should work.

2) The GPIO is for a specific PHY. Here we have an oddity in the
code. If the PHY responds to bus enumeration, before we start doing
anything with the reset GPIO, it will be discovered on the bus. At
this point, we try to get the GPIO. If that fails with EPROBE_DEFER,
all the PHYs on the bus are unregistered, and the bus registration
process fails with EPROBE_DEFER.

3) The GPIO is for a specific PHY. However, the device does not
respond to enumeration, because it is held in reset. You can get
around this by placing the ID values into device tree. The bus is
first enumerated in the normal way. And then devices which are listed
in DT, but have not been found, and have ID registers are registered
to the bus. This follows pretty much the same path as for a device
which is discovered. Before the device is registered with the device
core, we get the GPIOs, and handle the EPROBE_DEFER, unwinding
everything.

4) The GPIO does not use the normal name in DT. Or the PHY has some
other resource, which phylib does nothing with. The driver specific to
the hardware has code to handle the resource. It should try to get
those resources during probe. If probe returns EPROBE_DEFER, the probe
will be retried later. And when the MAC driver tries to find the PHY,
it should also get EPROBE_DEFER.

In case 4, the fallback driver has no idea about these PHY devices
specific properties. They are not part of 802.3 clause 22. So it will
ignore them. Probably the PHY will not work, because it is missing a
reset, or a clock, or a regulator. But we don't really care about
that. In order that the DT was accepted into the kernel, there must be
a device specific driver which uses those properties. So the kernel
installation is broken, that hardware specific driver is missing.

	Andrew
