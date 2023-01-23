Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DE16783FF
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbjAWSDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbjAWSDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:03:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBBCCA0E;
        Mon, 23 Jan 2023 10:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e4d0VnsFAkiIRf6tSLOqqkKcGHjRyQzCc9X+2Ei+du4=; b=n2eQeEa+UitAEQbDS0EqKYH0M5
        6NQtlr4FQbbO8m80g6LV7aAWpHpfh+RZq0ZmvWgXvgHy2ipYGvNYLH/mx6Kswqdf6UtHFjVRgoVAV
        wIwXViPE8PJy+rV6/rpVdaVlS1SOB0++9q6h7+AfzDhGQpciUUWNoX9LFQ4dJH/aS7Ks=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK1A6-002w00-QG; Mon, 23 Jan 2023 19:03:18 +0100
Date:   Mon, 23 Jan 2023 19:03:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
Message-ID: <Y87L5r8uzINALLw4@lunn.ch>
References: <20230120224011.796097-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120224011.796097-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 11:40:06PM +0100, Michael Walle wrote:
> After the c22 and c45 access split is finally merged. This can now be
> posted again. The old version can be found here:
> https://lore.kernel.org/netdev/20220325213518.2668832-1-michael@walle.cc/
> Although all the discussion was here:
> https://lore.kernel.org/netdev/20220323183419.2278676-1-michael@walle.cc/
> 
> The goal here is to get the GYP215 and LAN8814 running on the Microchip
> LAN9668 SoC. The LAN9668 suppports one external bus and unfortunately, the
> LAN8814 has a bug which makes it impossible to use C45 on that bus.
> Fortunately, it was the intention of the GPY215 driver to be used on a C22
> bus. But I think this could have never really worked, because the
> phy_get_c45_ids() will always do c45 accesses and thus gpy_probe() will
> fail.
> 
> Introduce C45-over-C22 support and use it if the MDIO bus doesn't support
> C45. Also enable it when a PHY is promoted from C22 to C45.

I see this breaking up into two problems.

1) Scanning the bus and finding device, be it by C22, C45, or C45 over C22.

2) Allowing drivers to access C45 register spaces, without caring if
it is C45 transfers or C45 over C22.

For scanning the bus we currently have:


        if (bus->read) {
                err = mdiobus_scan_bus_c22(bus);
                if (err)
                        goto error;
        }

        prevent_c45_scan = mdiobus_prevent_c45_scan(bus);

        if (!prevent_c45_scan && bus->read_c45) {
                err = mdiobus_scan_bus_c45(bus);
                if (err)
                        goto error;
        }

I think we should be adding something like:

	else {
		if (bus->read) {
	                err = mdiobus_scan_bus_c45_over_c22(bus);
	                if (err)
	                        goto error;
	        }
	}

That makes the top level pretty obvious what is going on.

But i think we need some more cleanup lower down. We now have a clean
separation in MDIO bus drivers between C22 bus transactions and C45
transactions bus. But further up it is less clear. PHY drivers should
be using phy_read_mmd()/phy_write_mmd() etc, which means access the
C45 address space, but says nothing about what bus transactions to
use. So that is also quite clean.

The problem is in the middle.  get_phy_c45_devs_in_pkg() uses
mdiobus_c45_read(). Does mdiobus_c45_read() mean perform a C45 bus
transaction, or access the C45 address space? I would say it means
perform a C45 bus transaction. It does not take a phydev, so we are
below the concept of PHYs, and so C45 over C22 does not exist at this
level.

So i think we need to review all calls to
mdiobus_c45_read/mdiobus_c45_write() etc and see if they mean C45 bus
transaction or C45 address space. Those meaning address space should
be changed to phy_read_mmd()/phy_write_mmd().

get_phy_device(), get_phy_c45_devs_in_pkg(), get_phy_c45_ids(),
phy_c45_probe_present() however do not deal with phydev, so cannot use
phy_read_mmd()/phy_write_mmd(). They probably need the bool is_c45
replaced with an enum indicating what sort of bus transaction should
be performed. Depending on that value, they can call
mdiobus_c45_read() or mmd_phy_indirect() and __mdiobus_read().

I don't have time at the moment, but i would like to dig more into
phydev->is_c45. has_c45 makes sense to indicate it has c45 address
space. But we need to see if it is every used to indicate to use c45
transactions. But it is clear we need a new member to indicate if C45
or C45 over C22 should be performed, and this should be set by how the
PHY was found in the first place.

    Andrew
