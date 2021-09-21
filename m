Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CC4413950
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 19:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhIUR6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 13:58:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232045AbhIUR5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 13:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WzMEbwZn/Z6/zvDtk3KGoyjHTKqZpd6tQKW8PKGbAzE=; b=aOncr7W3PxHOWmrkANHYEEQqdx
        xIz8Wfe54f9/eDgqxOyW0GTLeFKnOpacmt5Bq/CblT/26RN0JCZbmYtkZC+jTyeseksXVLQFRUXFq
        cFGFX905tLsZuSKBfcH4ovWrZYqNib8fcCzWEtn1yJb/LaXRB1mTNfch4cTF/GRDTYrA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSk00-007f8J-HX; Tue, 21 Sep 2021 19:56:08 +0200
Date:   Tue, 21 Sep 2021 19:56:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for
 FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
Message-ID: <YUocuMM4/VKzNMXq@lunn.ch>
References: <20210915170940.617415-1-saravanak@google.com>
 <20210915170940.617415-3-saravanak@google.com>
 <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch>
 <YUoFFXtWFAhLvIoH@kroah.com>
 <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The existing code attempts to "enforce" device links where the
> supplier is a direct ancestor of the consumer (e.g. its parent), which
> is questionable by itself (why do that?)

In this case, we have an Ethernet switch as the parent device. It
registers an interrupt controller, to the interrupt subsystem. It also
registers an MDIO controller to the MDIO subsystem. The MDIO subsystem
finds the Ethernet PHYs on the MDIO bus, and registers the PHYs to the
PHY subsystem.

Device tree is then used to glue all the parts together. The PHY has
an interrupt output which is connected to the interrupt controller,
and a standard DT property is used to connect the two. The MACs in the
switch are connected to the PHYs, and standard DT properties are used
to connect them together. So we have a loop. But the driver model does
not have a problem with this, at least not until fw_devlink came
along. As soon as a resource is registered with a subsystem, it can be
used. Where as fw_devlink seems to assume a resource cannot be used
until the driver providing it completes probe.

Now, we could ignore all these subsystems, re-invent the wheels inside
the switch driver, and then not have suppliers and consumers at all,
it is all internal. But that seems like a bad idea, more wheels, more
bugs.

So for me, the real fix is that fw_devlink learns that resources are
available as soon as they are registered, not when the provider device
completes probe.

	  Andrew
