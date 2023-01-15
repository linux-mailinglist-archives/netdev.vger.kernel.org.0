Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B8B66B4D8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 00:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjAOXzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 18:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjAOXzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 18:55:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8EC16321;
        Sun, 15 Jan 2023 15:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=C9kBaSGomzBeY39dSxemuW01FKp1Lm9mgpLGAgSDUjc=; b=afjDdP892qLrNfjmmt/PHGmLDR
        HhNB1yaxhrJPKkqVkNohnn5LYDbsNPViPuZvkqXw2voZxehopsUQNRAYmEqE31IHvwITkZpa/t5X/
        2BdPrE49BrkaWyHnJZgo3mBfjNT0LL3nrEDW1WZKMKVwXVcZCGMTbSTZ6STf5PCg1W80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHCqV-002A4x-6c; Mon, 16 Jan 2023 00:55:27 +0100
Date:   Mon, 16 Jan 2023 00:55:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lars-Peter Clausen <lars@metafoo.de>
Cc:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8SSb+tJsfJ3/DvH@lunn.ch>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
 <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Specifying the ID as part of the compatible string works for clause 22 PHYs,
> but for clause 45 PHYs it does not work. The code always wants to read the
> ID from the PHY itself. But I do not understand things well enough to tell
> whether that's a fundamental restriction of C45 or just our implementation
> and the implementation can be changed to fix it.
> 
> Do you have some thoughts on this?

Do you have more details about what goes wrong? Which PHY driver is
it? What compatibles do you put into DT for the PHY?

To some extent, the ID is only used to find the driver. A C45 device
has a lot of ID register, and all of them are used by phy_bus_match()
to see if a driver matches. So you need to be careful which ID you
pick, it needs to match the driver.

It is the driver which decides to use C22 or C45 to talk to the PHY.
However, we do have:

static int phy_probe(struct device *dev)
{
...
        else if (phydev->is_c45)
                err = genphy_c45_pma_read_abilities(phydev);
        else
                err = genphy_read_abilities(phydev);

so it could be a C45 PHY probed using an ID does not have
phydev->is_c45 set, and so it looks in the wrong place for the
capabilities. Make sure you also have the compatible
"ethernet-phy-ieee802.3-c45" which i think should cause is_c45 to be
set.

There is no fundamental restriction that i know of here, it probably
just needs somebody to debug it and find where it goes wrong.

Ah!

int fwnode_mdiobus_register_phy(struct mii_bus *bus,
                                struct fwnode_handle *child, u32 addr)
{
...
        rc = fwnode_property_match_string(child, "compatible",
                                          "ethernet-phy-ieee802.3-c45");
        if (rc >= 0)
                is_c45 = true;

        if (is_c45 || fwnode_get_phy_id(child, &phy_id))
                phy = get_phy_device(bus, addr, is_c45);
        else
                phy = phy_device_create(bus, addr, phy_id, 0, NULL);


So compatible "ethernet-phy-ieee802.3-c45" results in is_c45 being set
true. The if (is_c45 || is then true, so it does not need to call
fwnode_get_phy_id(child, &phy_id) so ignores whatever ID is in DT and
asks the PHY.

Try this, totally untested:

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index b782c35c4ac1..13be23f8ac97 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -134,10 +134,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
        if (rc >= 0)
                is_c45 = true;
 
-       if (is_c45 || fwnode_get_phy_id(child, &phy_id))
+       if (fwnode_get_phy_id (child, &phy_id))
                phy = get_phy_device(bus, addr, is_c45);
        else
-               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+               phy = phy_device_create(bus, addr, phy_id, is_c45, NULL);
        if (IS_ERR(phy)) {
                rc = PTR_ERR(phy);
                goto clean_mii_ts;


     Andrew
