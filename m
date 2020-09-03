Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376C825CC80
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgICVmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:42:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgICVmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 17:42:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDx0B-00D6rQ-0C; Thu, 03 Sep 2020 23:42:39 +0200
Date:   Thu, 3 Sep 2020 23:42:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, adam.rudzinski@arf.net.pl,
        Marco Felsch <m.felsch@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        devicetree@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: Support enabling clocks prior to
 bus probe
Message-ID: <20200903214238.GF3112546@lunn.ch>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-2-f.fainelli@gmail.com>
 <CAL_JsqL=XLJo9nrX+AMs41QvA3qpW6zoyB8qNwRx3V-+U-+uLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqL=XLJo9nrX+AMs41QvA3qpW6zoyB8qNwRx3V-+U-+uLg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 03:28:22PM -0600, Rob Herring wrote:
> What if a device requires clocks enabled in a certain order or timing?
> It's not just clocks, you could have some GPIOs or a regulator that
> need enabling first. It's device specific, so really needs a per
> device solution. This is not just an issue with MDIO. I think we
> really need some sort of pre-probe hook in the driver model in order
> to do any non-discoverable init for discoverable buses.

Hi Rob

How do you solve the chicken/egg of knowing what device specific init
is needed before you can discover what device you have on the bus?

> Or perhaps forcing probe when there are devices defined in DT if
> they're not discovered by normal means.

The PHY subsystem has this. You came specify in DT the ID of the
device which we would normally read during bus discovery. The correct
driver is then loaded and probed. But it is good practice to avoid
this. OEMs are known to change the PHY in order to perform cost
optimisation. So we prefer to do discover and do the right thing if
the PHY has changed.

As for GPIOS and regulators, i expect this code will expand pretty
soon after being merged to handle those. There are users wanting
it. We already have some standard properties defined, in terms of
gpios, delay while off, delay after turning it on. As for ordering, i
guess it would make sense to enable the clocks and then hit it with a
reset? If there is a device which cannot be handled like this, it can
always hard code its ID in device tree, and fully control its
resources in the driver.

	  Andrew
