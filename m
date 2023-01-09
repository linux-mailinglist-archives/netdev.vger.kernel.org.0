Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0247662698
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbjAINMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237214AbjAINLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:11:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497FA13CC7
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=36X1UPwC8MTPedPNphdjrqKPCP5RxetljSce9CDg1v8=; b=CJJhJ2dzoxblUBrFa1csbYGHwt
        EiyZzNXwUiSpIQ859Drr3EN3LSZ+EwMxyzed7cQxGtoNclF7stiGHcocxKTozuEFQ3w2Z4lpjQdsL
        LJ8YgWPVZ0QIENKuUHK9vx6HEzWJbo/pTEKTSaIujLM8GHJ3kHlKf51oI8jayznoIKu4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pErvY-001ZDX-OH; Mon, 09 Jan 2023 14:11:00 +0100
Date:   Mon, 9 Jan 2023 14:11:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Subject: Re: [PATCH net-next v6] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y7wSZJC3F5liYvTe@lunn.ch>
References: <20230108093903.27054-1-mengyuanlou@net-swift.com>
 <Y7roqgyjDN91hSIH@lunn.ch>
 <6A65AA55-3962-4E48-A778-7D1EF0820D89@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A65AA55-3962-4E48-A778-7D1EF0820D89@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +static void ngbe_phy_fixup(struct wx *wx)
> >> +{
> >> + struct phy_device *phydev = wx->phydev;
> >> + struct ethtool_eee eee;
> >> +
> >> + if (wx->mac_type != em_mac_type_mdi)
> >> + return;
> > 
> > Does this mean that if using the internal PHY the MAC does support EEE
> > and half duplex?
> 
> 
> 1) The MAC does not support half duplex. 
>    Internal phy and external phys all need to close half duplex.
> 
> 2) The internal phy does not support eee. 
>    When using the internal phy, we disable eee.

So this condition is wrong and need deleting?

> >> +int ngbe_mdio_init(struct wx *wx)
> >> +{
> >> + struct pci_dev *pdev = wx->pdev;
> >> + struct mii_bus *mii_bus;
> >> + int ret;
> >> +
> >> + mii_bus = devm_mdiobus_alloc(&pdev->dev);
> >> + if (!mii_bus)
> >> + return -ENOMEM;
> >> +
> >> + mii_bus->name = "ngbe_mii_bus";
> >> + mii_bus->read = ngbe_phy_read_reg;
> >> + mii_bus->write = ngbe_phy_write_reg;
> >> + mii_bus->phy_mask = GENMASK(31, 4);
> >> + mii_bus->probe_capabilities = MDIOBUS_C22_C45;
> > 
> > That is not strictly true. The internal MDIO bus does not suport
> > C45. In practice, it probably does not matter.
> 
> >> mii_bus->probe_capabilities = MDIOBUS_C22_C45;
> So, it is not necessary?
> If I correct handling in read/write.

mii_bus->probe_capabilities controls how the MDIO bus is probed for
devices. MDIOBUS_C22_C45 means it will first look for C22 devices, and
then look for C45 devices. One of your busses does not support C45,
and will always return -EOPNOTSUPP. So it is just a waste of time
probing that bus for C45 devices. But it will not break, which is why
i said it probably does not matter. You could if you wanted set
mii_bus->probe_capabilities based on which bus is being used, internal
or external, and that might speed up the driver loading a little.

	Andrew
