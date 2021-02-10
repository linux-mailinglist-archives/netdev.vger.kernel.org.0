Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266643173B4
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhBJWw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:52:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233516AbhBJWw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 17:52:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9yLC-005Pl9-0r; Wed, 10 Feb 2021 23:52:10 +0100
Date:   Wed, 10 Feb 2021 23:52:10 +0100
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
Message-ID: <YCRjmpKjK0pxKTCP@lunn.ch>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:13:48PM -0800, Saravana Kannan wrote:
> Hi,
> 
> This email was triggered by this other email[1].
> 
> Why is phy_attach_direct() directly calling device_bind_driver()
> instead of using bus_probe_device()?

Hi Saravana

So this is to do with the generic PHY, which is a special case.

First the normal case. The MDIO bus driver registers an MDIO bus using
mdiobus_register(). This will enumerate the bus, finding PHYs on
it. Each PHY device is registered with the device core, using the
usual device_add(). The core will go through the registered PHY
drivers and see if one can drive this hardware, based on the ID
registers the PHY has at address 2 and 3. If a match is found, the
driver probes the device, all in the usual way.

Sometime later, the MAC driver wants to make use of the PHY
device. This is often in the open() call of the MAC driver, when the
interface is configured up. The MAC driver asks phylib to associate a
PHY devices to the MAC device. In the normal case, the PHY has been
probed, and everything is good to go.

However, sometimes, there is no driver for the PHY. There is no driver
for that hardware. Or the driver has not been built, or it is not on
the disk, etc. So the device core has not been able to probe
it. However, IEEE 802.3 clause 22 defines a minimum set of registers a
PHY should support. And most PHY devices have this minimum. So there
is a fall back driver, the generic PHY driver. It assumes the minimum
registers are available, and does its best to drive the hardware. It
often works, but not always. So if the MAC asks phylib to connect to a
PHY which does not have a driver, we forcefully bind the generic
driver to the device, and hope for the best.

We don't actually recommend using the generic driver. Use the specific
driver for the hardware. But the generic driver can at least get you
going, allow you to scp the correct driver onto the system, etc.

   Andrew
